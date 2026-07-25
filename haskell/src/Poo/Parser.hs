{-# LANGUAGE OverloadedStrings #-}

module Poo.Parser
  ( parseProgram
  ) where

import Poo.AST
import Poo.Token
import Poo.Lexer (tokenize, TokenStream)
import Data.Void
import Data.Text (Text)
import Text.Megaparsec
import Text.Megaparsec.Char

type Parser = Parsec Void TokenStream

-- Helper: match a specific token
tok :: Token -> Parser Token
tok t = token (\x -> if x == t then Just x else Nothing) mempty

-- Basic atoms
parseIdent :: Parser Name
parseIdent = token (\case TIdent n -> Just n; _ -> Nothing) mempty

parseLiteral :: Parser Literal
parseLiteral = token (\case
  TInt    i   -> Just (LInt    i)
  TFloat  f   -> Just (LFloat  f)
  TString s   -> Just (LString s)
  TBool   b   -> Just (LBool   b)
  TNull       -> Just LNull
  TUndefined  -> Just LUndefined
  _           -> Nothing) mempty

-- ============ HELPERS

-- Allows trailing comma:  a, b, c,   or   a, b, c
sepByTrail :: Parser a -> Parser sep -> Parser [a]
sepByTrail p sep = do
  x <- optional p
  case x of
    Nothing -> pure []
    Just v  -> do
      rest <- many (sep *> p)
      _    <- optional sep          -- the trailing one
      pure (v : rest)

-- ============================================================
-- Expressions with Precedence + Unary + Collections
-- ============================================================

-- Precedence levels (from lowest to highest):
-- 1. Pipe           (>>)
-- 2. Logical Or     (||)
-- 3. Logical And    (&&)
-- 4. Comparison     (== != < > =< >=)
-- 5. Addition       (+ -)
-- 6. Multiplication (* / %)
-- 7. Application / Atoms

parseExpr :: Parser Expr
parseExpr = parsePipe

-- Level 1: Pipe
parsePipe :: Parser Expr
parsePipe = do
  left <- pOr
  rest <- many (tok TPipe *> parseOr)
  pure $ foldl Pipe left rest

-- Level 2: Logical Or
parseOr :: Parser Expr
parseOr = parseBinaryOp parseAnd [(TOrOp, Or)]

-- Level 3: Logical And
parseAnd :: Parser Expr
parseAnd = parseBinaryOp parseComparison [(TAnd, And)]

-- Level 4: Comparison
parseComparison :: Parser Expr
parseComparison = parseBinaryOp parseAdd
  [ (TEq,  Eq)
  , (TNeq, Neq)
  , (TLt,  Lt)
  , (TGt,  Gt)
  , (TLe,  Le)
  , (TGe,  Ge)
  ]

-- Level 5: Addition / Subtraction
parseAdd :: Parser Expr
parseAdd = parseBinaryOp pMul
  [ (TPlus,  Add)
  , (TMinus, Sub)
  ]

-- Level 6: Multiplication / Division / Modulo
parseMul :: Parser Expr
parseMul = parseBinaryOp parseUnary
  [ (TStar,    Mul)
  , (TSlash,   Div)
  , (TPercent, Mod)
  ]

-- Level 7: Unary operators
parseUnary :: Parser Expr
parseUnary = choice
  [ do tok TMinus
       e <- parseUnary
       pure (Unary Neg e)
  , parseApp
  ]

-- Level 8: Function application (supports positional + named args)
parseFnApp :: Parser Expr
parseFnApp = do
  func <- parseAtom
  choice
    [ try (parseFnCallArgs func)   -- f(...)  or  f(a: 1, b: 2)
    , do args <- many parseAtom    -- bare application: f a b
         pure $ case args of
           [] -> func
           _  -> App func (map Positional args)
    ]

-- Parses the argument list inside parentheses
parseFnCallArgs :: Expr -> Parser Expr
parseFnCallArgs func = do
  tok TLParen
  args <- parseArg `sepByTrail` tok TComma
  tok TRParen
  pure (App func args)

-- A single argument: either named or positional
parseArg :: Parser Arg
parseArg = choice
  [ try parseNamedArg
  , Positional <$> pExpr
  ]

parseNamedArg :: Parser Arg
parseNamedArg = do
  name <- parseIdent
  tok TColon
  value <- parseExpr
  pure (Named name value)

-- Atoms (literals, variables, parentheses, collections, if)
parseAtom :: Parser Expr
parseAtom = choice
  [ Lit <$> parseLiteral
  , Var <$> parseIdent
  , parseParens
  , parseArray
  , parseList
  , parseTuple
  , parseRecord
  , parseIf
  , parseLoop
  ]

parseParens :: Parser Expr
parseParens = do
  tok TLParen
  e <- parseExpr
  tok TRParen
  pure e

-- -------------------- Collections --------------------

parseArray :: Parser Expr
parseArray = do
  tok TLBracket
  elems <- parseExpr `sepByTrail` tok TComma
  tok TRBracket
  pure (Array elems)

parseList :: Parser Expr
parseList = do
  tok THashLBracket
  elems <- parseExpr `sepByTrail` tok TComma
  tok TRBracket
  pure (List elems)

parseTuple :: Parser Expr
parseTuple = do
  tok THashLParen
  elems <- parseExpr `sepByTrail` tok TComma
  tok TRParen
  pure (Tuple elems)

parseRecord :: Parser Expr
parseRecord = do
  tok THashLBrace
  fields <- parseField `sepByTrail` tok TComma
  tok TRBrace
  pure (Record fields)

parseField :: Parser (Name, Expr)
parseField = do
  name <- pIdent
  tok TColon
  value <- parseExpr
  pure (name, value)

-- -------------------- loop --------------------

parseLoop :: Parser Expr
parseLoop = do
  tok TLoop
  choice
    [ try parseLoopOver
    , parseLoopWhile
    ]

-- loop (collection as name) { body }
-- loop  collection as name do expr
parseLoopOver :: Parser Expr
parseLoopOver = do
  -- optional parentheses around the header
  (coll, name) <- choice
    [ do tok TLParen
         c <- parseExpr
         tok TAs
         n <- parseIdent
         tok TRParen
         pure (c, n)
    , do c <- parseExpr
         tok TAs
         n <- parseIdent
         pure (c, n)
    ]
  body <- parseLoopBody
  pure (Loop (LoopOver coll name body))

-- loop (condition) { body }
-- loop (condition) do expr
parseLoopWhile :: Parser Expr
parseLoopWhile = do
  tok TLParen
  cond <- parseExpr
  tok TRParen
  body <- parseLoopBody
  pure (Loop (LoopWhile cond body))

parseLoopBody :: Parser Expr
parseLoopBody = choice
  [ do tok TDo
       parseExpr
  , parseBlock
  ]

-- -------------------- if / or --------------------

parseIf :: Parser Expr
parseIf = do
  tok TIf
  cond       <- parseExpr
  thenBranch <- parseThenBranch
  elses      <- many pOrClause
  pure (buildIfChain cond thenBranch elses)

-- Helper: baut verschachtelte Ifs
buildIfChain :: Expr -> Expr -> [(Maybe Expr, Expr)] -> Expr
buildIfChain cond thenBranch [] = If cond thenBranch Nothing
buildIfChain cond thenBranch ((mcond, branch):rest) =
  If cond thenBranch (Just $ case mcond of
    Nothing   -> branch
    Just c    -> buildIfChain c branch rest)

parseOrClause :: Parser (Maybe Expr, Expr)
parseOrClause = do
  tok TOr
  choice
    [ try $ do
        cond <- parseExpr
        body <- parseBranchBody
        pure (Just cond, body)
    , do
        body <- parseBranchBody
        pure (Nothing, body)  - plain "or ..."
    ]

parseBranchBody :: Parser Expr
parseBranchBody = choice
  [ do tok TDo
       parseExpr
  , parseBlock
  ]

parseBlock :: Parser Expr
parseBlock = do
  tok TLBrace
  stmts <- many parseStmt
  tok TRBrace
  pure (Block stmts)

-- ----------------------------------------------------
-- -------------------- Statements --------------------
-- ----------------------------------------------------

parseVal :: Parser Stmt
parseVal = do
  tok TVal
  name <- parseIdent
  tok TAssign
  expr <- parseExpr
  tok TSemicolon
  pure (Val name expr)

-- -------------------- fn --------------------

parseFn :: Parser Stmt
parseFn = do
  tok TFn
  name <- parseIdent

  -- two styles:
  -- 1. fn name = params => body
  -- 2. fn name  (params) { body }
  choice
    [ try parseFnArrow
    , parseFnClassic
    ]
  where
    parseFnArrow = do
      tok TAssign
      params <- parseParams
      tok TArrow
      body <- parseFnBody
      optional (tok TSemicolon)
      pure (Fn name params body)

    parseFnClassic = do
      params <- parseParams
      body   <- parseBlock
      optional (tok TSemicolon)
      pure (Fn name params body)

parseParams :: Parser [Name]
parseParams = choice
  [ do tok TLParen
       ps <- parseIdent `sepByTrail` tok TComma
       tok TRParen
       pure ps
  , pure <$> parseIdent  -- single param without parens
  , pure []              -- zero params
  ]

parseFnBody :: Parser Expr
parseFnBody = choice
  [ parseBlock
  , parseExpr
  ]

parseReturn :: Parser Stmt
parseReturn = do
  tok TReturn
  maybeExpr <- optional parseExpr
  optional (tok TSemicolon)
  pure (Return maybeExpr)

parseStmt :: Parser Stmt
parseStmt = choice
  [ parseVal
  , parseFn
  , parseReturn
  , ExprStmt <$> parseExpr <* optional (tok TSemicolon)
  ]

parseProgram :: Parser Program
parseProgram = many parseStmt <* eof

-- Entry point
parseProgram :: Text -> Either String Program
parseProgram src = do
  tokens <- either (Left . errorBundlePretty) Right (tokenize src)
            either (Left . errorBundlePretty) Right (parse parseProgram "" tokens)   
  

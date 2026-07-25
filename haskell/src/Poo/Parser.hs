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
parseIdentifier :: Parser Name
parseIdentifier = token (\case TIdent n -> Just n; _ -> Nothing) mempty

parseLiteral :: Parser Literal
parseLiteral = token (\case
  TokenInt    i   -> Just (LInt    i)
  TokenFloat  f   -> Just (LFloat  f)
  TokenString s   -> Just (LString s)
  TokenBool   b   -> Just (LBool   b)
  TokenNull       -> Just LNull
  TokenUndefined  -> Just LUndefined
  _               -> Nothing) mempty

-- ============ HELPERS

-- Allows trailing comma:  a, b, c,   or   a, b, c
sepByTrail :: Parser a -> Parser sep -> Parser [a]
sepByTrail p sep = do
  x <- optional p
  case x of
    Nothing -> pure []
    Just v  -> do
      rest <- many (sep *> p)
      _    <- optional sep  -- the trailing one
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
  rest <- many (tok TokenPipe *> parseOr)
  pure $ foldl Pipe left rest

-- Level 2: Logical Or
parseOr :: Parser Expr
parseOr = parseBinaryOp parseAnd [(TokenOrOp, Or)]

-- Level 3: Logical And
parseAnd :: Parser Expr
parseAnd = parseBinaryOp parseComparison [(TokenAnd, And)]

-- Level 4: Comparison
parseComparison :: Parser Expr
parseComparison = parseBinaryOp parseAdd
  [ (TokenEq,  Eq)
  , (TokenNeq, Neq)
  , (TokenLt,  Lt)
  , (TokenGt,  Gt)
  , (TokenLe,  Le)
  , (TokenGe,  Ge)
  ]

-- Level 5: Addition / Subtraction
parseAdd :: Parser Expr
parseAdd = parseBinaryOp parseMul
  [ (TokenPlus,  Add)
  , (TokenMinus, Sub)
  ]

-- Level 6: Multiplication / Division / Modulo
parseMul :: Parser Expr
parseMul = parseBinaryOp parseUnary
  [ (TokenStar,    Mul)
  , (TokenSlash,   Div)
  , (TokenPercent, Mod)
  ]

-- Level 7: Unary operators
parseUnary :: Parser Expr
parseUnary = choice
  [ do tok TokenMinus
       e <- parseUnary
       pure (Unary Neg e)
  , parseApp
  ]

-- Level 8: Function application (supports positional + named args)
parseFnApp :: Parser Expr
parseFnApp = do
  func <- parseAtom
  choice
    [ try (parseFnCallArgs func)  -- f(...)  or  f(a: 1, b: 2)
    , do args <- many parseAtom   -- bare application: f a b
         pure $ case args of
           [] -> func
           _  -> App func (map Positional args)
    ]

-- Parses the argument list inside parentheses
parseFnCallArgs :: Expr -> Parser Expr
parseFnCallArgs func = do
  tok TokenParenL
  args <- parseArg `sepByTrail` tok TokenComma
  tok TokenParenR
  pure (App func args)

-- A single argument: either named or positional
parseArg :: Parser Arg
parseArg = choice
  [ try parseNamedArg
  , Positional <$> parseExpr
  ]

parseNamedArg :: Parser Arg
parseNamedArg = do
  name <- parseIdent
  tok TokenColon
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
  , parseSwitch
  ]

parseParens :: Parser Expr
parseParens = do
  tok TokenParenL
  e <- parseExpr
  tok TokenParenR
  pure e

-- -------------------- Collections --------------------

parseArray :: Parser Expr
parseArray = do
  tok TokenBracketL
  elems <- parseExpr `sepByTrail` tok TokenComma
  tok TokenBracketR
  pure (Array elems)

parseList :: Parser Expr
parseList = do
  tok TokenHashBracketL
  elems <- parseExpr `sepByTrail` tok TokenComma
  tok TokenBracketR
  pure (List elems)

parseTuple :: Parser Expr
parseTuple = do
  tok TokenHashParenL
  elems <- parseExpr `sepByTrail` tok TokenComma
  tok TokenParenR
  pure (Tuple elems)

parseRecord :: Parser Expr
parseRecord = do
  tok TokenHashBraceL
  fields <- parseField `sepByTrail` tok TokenComma
  tok TokenBraceR
  pure (Record fields)

parseField :: Parser (Name, Expr)
parseField = do
  name <- parseIdentifier
  tok TokenColon
  value <- parseExpr
  pure (name, value)

-- -------------------- loop --------------------

parseLoop :: Parser Expr
parseLoop = choice
  [ try parseLoopBang  -- loop! ...
  , parseLoopNormal    -- loop ...
  ]

parseLoopNormal :: Parser Expr
parseLoopNormal = do
  tok TokenLoop
  choice
    [ try parseLoopOver
    , parseLoopWhile False  -- normal while
    ]

parseLoopBang :: Parser Expr
parseLoopBang = do
  tok TokenLoopBang
  parseLoopWhile True  -- inverted while

-- Gemeinsame While-Logik
parseLoopWhile :: Bool -> Parser Expr
parseLoopWhile inverted = do
  tok TokenParenL
  cond <- parseExpr
  tok TokenParenR
  body <- parseLoopBody
  pure $ Loop $ if inverted
    then LoopWhileNot cond body
    else LoopWhile    cond body

-- loop (collection as name) { body }
-- loop  collection as name do expr
parseLoopOver :: Parser Expr
parseLoopOver = do
  -- optional parentheses around the header
  (coll, name) <- choice
    [ do tok TokenParenL
         c <- parseExpr
         tok TokenAs
         n <- parseIdentifier
         tok TokenParenR
         pure (c, n)
    , do c <- parseExpr
         tok TokenAs
         n <- parseIdentifier
         pure (c, n)
    ]
  body <- parseLoopBody
  pure (Loop (LoopOver coll name body))

parseLoopBody :: Parser Expr
parseLoopBody = choice
  [ do tok TokenDo
       parseExpr
  , parseBlock
  ]

-- -------------------- if / or --------------------

parseIf :: Parser Expr
parseIf = do
  tok TokenIf
  cond       <- parseExpr
  thenBranch <- parseThenBranch
  elses      <- many parseOrClause
  pure (buildIfChain cond thenBranch elses)

-- Helper: baut verschachtelte Ifs
buildIfChain :: Expr -> Expr -> [(Maybe Expr, Expr)] -> Expr
buildIfChain cond thenBranch [] = If cond thenBranch Nothing
buildIfChain cond thenBranch ((mcond, branch):rest) =
  If cond thenBranch (Just $ case mcond of
    Nothing -> branch
    Just c  -> buildIfChain c branch rest)

parseOrClause :: Parser (Maybe Expr, Expr)
parseOrClause = do
  tok TokenOr
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
  [ do tok TokenDo
       parseExpr
  , parseBlock
  ]

parseBlock :: Parser Expr
parseBlock = do
  tok TokenBraceL
  stmts <- many parseStmt
  tok TokenBraceR
  pure (Block stmts)

-- -------------------- switch --------------------

parseSwitch :: Parser Expr
parseSwitch = choice
  [ try parseSwitchBang
  , parseSwitchNormal
  ]

parseSwitchNormal :: Parser Expr
parseSwitchNormal = do
  tok TokenSwitch
  maybeScrutinee <- optional (tok TokenParenL *> parseExpr <* tok TokenParenR)     
  cases          <- parseSwitchBody
  pure $ case maybeScrutinee of
    Nothing  -> Switch SwitchNormal cases Nothing
    Just scr -> Switch SwitchNormal cases (Just scr)

parseSwitchBang :: Parser Expr
parseSwitchBang = do
  tok TokenSwitchBang
  maybeScrutinee <- optional (tok TokenParenL *> pExpr <* tok TokenParenR)
  cases          <- parseSwitchBody
  pure $ case maybeScrutinee of
    Nothing  -> Switch SwitchInverted cases Nothing
    Just scr -> Switch SwitchInverted cases (Just scr)

parseSwitchBody :: Parser [SwitchCase]
parseSwitchBody = do
  tok TokenBraceL
  cases <- some parseSwitchCase
  tok TokenBraceR
  pure cases

parseSwitchCase :: Parser SwitchCase
parseSwitchCase = choice
  [ try parseDefaultCase
  , parseNormalCase
  ]

parseNormalCase :: Parser SwitchCase
parseNormalCase = do
  cond <- parseExpr
  body <- parseBranchBody  -- "do expr" oder Block
  pure (SwitchCase (Just cond) body)

parseDefaultCase :: Parser SwitchCase
parseDefaultCase = do
  tok TokenOr
  body <- parseBranchBody
  pure (SwitchCase Nothing body)

-- ----------------------------------------------------
-- -------------------- Statements --------------------
-- ----------------------------------------------------

parseVal :: Parser Stmt
parseVal = do
  tok TokenVal
  name <- parseIdent
  tok TokenAssign
  expr <- parseExpr
  tok TokenSemicolon
  pure (Val name expr)

-- -------------------- fn --------------------

parseFn :: Parser Stmt
parseFn = do
  tok TokenFn
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
      tok TokenAssign
      params <- parseParams
      tok TokenArrow
      body <- parseFnBody
      optional (tok TokenSemicolon)
      pure (Fn name params body)

    parseFnClassic = do
      params <- parseParams
      body   <- parseBlock
      optional (tok TokenSemicolon)
      pure (Fn name params body)

parseParams :: Parser [Name]
parseParams = choice
  [ do tok TokenParenL
       ps <- parseIdentifier `sepByTrail` tok TokenComma
       tok TokenParenR
       pure ps
  , pure <$> parseIdentifier  -- single param without parens
  , pure []                   -- zero params
  ]

parseFnBody :: Parser Expr
parseFnBody = choice
  [ parseBlock
  , parseExpr
  ]

parseBreak :: Parser Stmt
parseBreak = tok TokenBreak *> optional (tok TokenSemicolon) *> pure Break

parseContinue :: Parser Stmt
parseContinue = tok TokenContinue *> optional (tok TokenSemicolon) *> pure Continue

parseReturn :: Parser Stmt
parseReturn = do
  tok TokenReturn
  maybeExpr <- optional parseExpr
  optional (tok TokenSemicolon)
  pure (Return maybeExpr)

parseStmt :: Parser Stmt
parseStmt = choice
  [ parseVal
  , parseFn
  , parseReturn
  , parseBreak
  , parseContinue
  , ExprStmt <$> parseExpr <* optional (tok TokenSemicolon)
  ]

parseProgram :: Parser Program
parseProgram = many parseStmt <* eof

-- Entry point
parseProgram :: Text -> Either String Program
parseProgram src = do
  tokens <- either (Left . errorBundlePretty) Right (tokenize src)
            either (Left . errorBundlePretty) Right (parse parseProgram "" tokens)   
  

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
pIdent :: Parser Name
pIdent = token (\case TIdent n -> Just n; _ -> Nothing) mempty

pLiteral :: Parser Literal
pLiteral = token (\case
  TInt i      -> Just (LInt i)
  TFloat f    -> Just (LFloat f)
  TString s   -> Just (LString s)
  TBool b     -> Just (LBool b)
  TNull       -> Just LNull
  TUndefined  -> Just LUndefined
  _           -> Nothing) mempty

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

pExpr :: Parser Expr
pExpr = pPipe

-- Level 1: Pipe
pPipe :: Parser Expr
pPipe = do
  left <- pOr
  rest <- many (tok TPipe *> pOr)
  pure $ foldl Pipe left rest

-- Level 2: Logical Or
pOr :: Parser Expr
pOr = pBinaryOp pAnd [(TOrOp, Or)]

-- Level 3: Logical And
pAnd :: Parser Expr
pAnd = pBinaryOp pComparison [(TAnd, And)]

-- Level 4: Comparison
pComparison :: Parser Expr
pComparison = pBinaryOp pAdd
  [ (TEq,  Eq)
  , (TNeq, Neq)
  , (TLt,  Lt)
  , (TGt,  Gt)
  , (TLe,  Le)
  , (TGe,  Ge)
  ]

-- Level 5: Addition / Subtraction
pAdd :: Parser Expr
pAdd = pBinaryOp pMul
  [ (TPlus,  Add)
  , (TMinus, Sub)
  ]

-- Level 6: Multiplication / Division / Modulo
pMul :: Parser Expr
pMul = pBinaryOp pUnary
  [ (TStar,    Mul)
  , (TSlash,   Div)
  , (TPercent, Mod)
  ]

-- Level 7: Unary operators
pUnary :: Parser Expr
pUnary = choice
  [ do tok TMinus
       e <- pUnary
       pure (Unary Neg e)
  , pApp
  ]

-- Level 8: Function application
pApp :: Parser Expr
pApp = do
  func <- pAtom
  args <- many pAtom
  pure $ case args of
    [] -> func
    _  -> App func args

-- Atoms (literals, variables, parentheses, collections, if)
pAtom :: Parser Expr
pAtom = choice
  [ Lit <$> pLiteral
  , Var <$> pIdent
  , pParens
  , pArray
  , pList
  , pTuple
  , pRecord
  , pIf
  ]

pParens :: Parser Expr
pParens = do
  tok TLParen
  e <- pExpr
  tok TRParen
  pure e

-- -------------------- Collections --------------------

pArray :: Parser Expr
pArray = do
  tok TLBracket
  elems <- pExpr `sepBy` tok TComma
  tok TRBracket
  pure (Array elems)

pList :: Parser Expr
pList = do
  tok THashLBracket
  elems <- pExpr `sepBy` tok TComma
  tok TRBracket
  pure (List elems)

pTuple :: Parser Expr
pTuple = do
  tok THashLParen
  elems <- pExpr `sepBy` tok TComma
  tok TRParen
  pure (Tuple elems)

pRecord :: Parser Expr
pRecord = do
  tok THashLBrace
  fields <- pField `sepBy` tok TComma
  tok TRBrace
  pure (Record fields)

pField :: Parser (Name, Expr)
pField = do
  name <- pIdent
  tok TColon
  value <- pExpr
  pure (name, value)

-- -------------------- if / or --------------------

pIf :: Parser Expr
pIf = do
  tok TIf
  cond <- pExpr
  thenBranch <- pThenBranch
  elseBranch <- optional pOrBranch
  pure (If cond thenBranch elseBranch)

pThenBranch :: Parser Expr
pThenBranch = choice
  [ do tok TDo
       pExpr
  , pBlock
  ]

pOrBranch :: Parser Expr
pOrBranch = do
  tok TOr
  -- either "or <cond> ..." or just "or ..."
  choice
    [ try $ do
        cond <- pExpr
        branch <- pThenBranch
        pure (If cond branch Nothing)   -- simplified for now
    , pThenBranch
    ]

pBlock :: Parser Expr
pBlock = do
  tok TLBrace
  stmts <- many pStmt
  tok TRBrace
  pure (Block stmts)

-- Statements
pVal :: Parser Stmt
pVal = do
  tok TVal
  name <- pIdent
  tok TAssign
  expr <- pExpr
  tok TSemicolon
  pure (Val name expr)

pFn :: Parser Stmt
pFn = do
  tok TFn
  name <- pIdent
  tok TAssign
  params <- pParams
  tok TArrow
  body <- pExpr
  tok TSemicolon
  pure (Fn name params body)

pParams :: Parser [Name]
pParams = choice
  [ do tok TLParen
       ps <- pIdent `sepBy` tok TComma
       tok TRParen
       pure ps
  , pure <$> pIdent          -- single param without parens
  , pure []                  -- no params
  ]

pStmt :: Parser Stmt
pStmt = choice
  [ pVal
  , pFn
  , ExprStmt <$> pExpr <* optional (tok TSemicolon)
  ]

pProgram :: Parser Program
pProgram = many pStmt <* eof

-- Entry point
parseProgram :: Text -> Either String Program
parseProgram src = do
  tokens <- either (Left . errorBundlePretty) Right (tokenize src)
  either (Left . errorBundlePretty) Right (parse pProgram "" tokens)
  

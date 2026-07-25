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
-- Expressions with Operator Precedence
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

-- Level 1: Pipe (left-associative)
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
pMul = pBinaryOp pApp
  [ (TStar,    Mul)
  , (TSlash,   Div)
  , (TPercent, Mod)
  ]

-- Helper for left-associative binary operators
pBinaryOp :: Parser Expr -> [(Token, BinOp)] -> Parser Expr
pBinaryOp higher ops = do
  left <- higher
  rest <- many $ do
    op  <- choice [tok t *> pure binOp | (t, binOp) <- ops]
    right <- higher
    pure (op, right)
  pure $ foldl (\acc (op, right) -> Binary acc op right) left rest

-- Level 7: Function application + Atoms
pApp :: Parser Expr
pApp = do
  func <- pAtom
  args <- many pAtom
  pure $ case args of
    [] -> func
    _  -> App func args

pAtom :: Parser Expr
pAtom = choice
  [ Lit <$> pLiteral
  , Var <$> pIdent
  , do tok TLParen
       e <- pExpr
       tok TRParen
       pure e
  ]

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
pStmt = choice [pVal, pFn, ExprStmt <$> pExpr <* tok TSemicolon]

pProgram :: Parser Program
pProgram = many pStmt <* eof

-- Entry point
parseProgram :: Text -> Either String Program
parseProgram src = do
  tokens <- either (Left . errorBundlePretty) Right (tokenize src)
  either (Left . errorBundlePretty) Right (parse pProgram "" tokens)
  

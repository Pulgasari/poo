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

-- Expressions (very simplified precedence for now)
pExpr :: Parser Expr
pExpr = pPipe

pPipe :: Parser Expr
pPipe = do
  left <- pBinary
  option left $ do
    tok TPipe
    right <- pPipe
    pure (Pipe left right)

pBinary :: Parser Expr
pBinary = pApp  -- for now we keep it simple; operators come later

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
  

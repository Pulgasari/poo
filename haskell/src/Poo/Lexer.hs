{-# LANGUAGE OverloadedStrings #-}

module Poo.Lexer
  ( TokenStream
  , tokenize
  ) where

import Poo.Token
import Data.Void
import Data.Text (Text)
import qualified Data.Text as T
import Text.Megaparsec
import Text.Megaparsec.Char
import qualified Text.Megaparsec.Char.Lexer as L

type Parser = Parsec Void Text

-- Skip whitespace and comments
sc :: Parser ()
sc = L.space
  space1
  (L.skipLineComment "//")
  empty

lexeme :: Parser a -> Parser a
lexeme = L.lexeme sc

symbol :: Text -> Parser Text
symbol = L.symbol sc

-- Individual token parsers
pInteger :: Parser Token
pInteger = TInt <$> lexeme L.decimal

pFloat :: Parser Token
pFloat = TFloat <$> lexeme L.float

pString :: Parser Token
pString = TString <$> lexeme (char '"' *> manyTill L.charLiteral (char '"'))

pIdentOrKeyword :: Parser Token
pIdentOrKeyword = do
  name <- lexeme ((:) <$> letterChar <*> many (alphaNumChar <|> char '_'))
  pure $ case name of
    "val"       -> TVal
    "fn"        -> TFn
    "if"        -> TIf
    "or"        -> TOr
    "loop!"     -> TLoopBang
    "loop"      -> TLoop
    "break"     -> TBreak
    "continue"  -> TContinue
    "do"        -> TDo
    "as"        -> TAs
    "return"    -> TReturn
    "true"      -> TBool True
    "false"     -> TBool False
    "null"      -> TNull
    "undefined" -> TUndefined
    _           -> TIdent name

pOperator :: Parser Token
pOperator = choice
  [ TPipe   <$ symbol ">>"
  , TArrow  <$ symbol "=>"
  , TEq     <$ symbol "=="
  , TNeq    <$ symbol "!="
  , TLe     <$ symbol "=<"
  , TGe     <$ symbol ">="
  , TAnd    <$ symbol "&&"
  , TOrOp   <$ symbol "||"
  , TPlus   <$ symbol "+"
  , TMinus  <$ symbol "-"
  , TStar   <$ symbol "*"
  , TSlash  <$ symbol "/"
  , TPercent<$ symbol "%"
  , TLt     <$ symbol "<"
  , TGt     <$ symbol ">"
  , TAssign <$ symbol "="
  , THash   <$ symbol "#"
  ]

pDelimiter :: Parser Token
pDelimiter = choice
  [ 
    THashLBracket <$ symbol "#["
  , THashLParen   <$ symbol "#("
  , THashLBrace   <$ symbol "#{"
  , TColon        <$ symbol ":"
  , TLParen       <$ symbol "("
  , TRParen       <$ symbol ")"
  , TLBrace       <$ symbol "{"
  , TRBrace       <$ symbol "}"
  , TLBracket     <$ symbol "["
  , TRBracket     <$ symbol "]"
  , TComma        <$ symbol ","
  , TSemicolon    <$ symbol ";"
  ]

pToken :: Parser Token
pToken = choice
  [ try pFloat
  , pInteger
  , pString
  , pIdentOrKeyword
  , pOperator
  , pDelimiter
  ]

type TokenStream = [Token]

tokenize :: Text -> Either (ParseErrorBundle Text Void) TokenStream
tokenize = parse (sc *> many pToken <* eof) ""

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
parseInteger :: Parser Token
parseInteger = TokenInt <$> lexeme L.decimal

parseFloat :: Parser Token
parseFloat = TokenFloat <$> lexeme L.float

parseString :: Parser Token
parseString = TokenString <$> lexeme (char '"' *> manyTill L.charLiteral (char '"'))

parseIdentOrKeyword :: Parser Token
parseIdentOrKeyword = do
  name <- lexeme ((:) <$> letterChar <*> many (alphaNumChar <|> char '_'))
  pure $ case name of
    "val"       -> TokenVal
    "fn"        -> TokenFn
    "if"        -> TokenIf
    "or"        -> TokenOr
    "loop!"     -> TokenLoopBang
    "loop"      -> TokenLoop
    "switch!"   -> TokenSwitchBang
    "switch"    -> TokenSwitch
    "break"     -> TokenBreak
    "continue"  -> TokenContinue
    "do"        -> TokenDo
    "as"        -> TokenAs
    "return"    -> TokenReturn
    "true"      -> TokenBool True
    "false"     -> TokenBool False
    "null"      -> TokenNull
    "undefined" -> TokenUndefined
    _           -> TokenIdent name

parseOperator :: Parser Token
parseOperator = choice
  [ TokenPipe     <$ symbol ">>"
  , TokenArrow    <$ symbol "=>"
  , TokenEq       <$ symbol "=="
  , TokenNeq      <$ symbol "!="
  , TokenLe       <$ symbol "=<"
  , TokenGe       <$ symbol ">="
  , TokenAnd      <$ symbol "&&"
  , TokenOrOp     <$ symbol "||"
  , TokenPlus     <$ symbol "+"
  , TokenMinus    <$ symbol "-"
  , TokenStar     <$ symbol "*"
  , TokenSlash    <$ symbol "/"
  , TokenPercent  <$ symbol "%"
  , TokenLt       <$ symbol "<"
  , TokenGt       <$ symbol ">"
  , TokenAssign   <$ symbol "="
  , TokenHash     <$ symbol "#"
  ]

parseDelimiter :: Parser Token
parseDelimiter = choice
  [ 
    TokenHashBracketL <$ symbol "#["
  , TokenHashParenL   <$ symbol "#("
  , TokenHashBraceL   <$ symbol "#{"
  , TokenColon        <$ symbol ":"
  , TokenParenL       <$ symbol "("
  , TokenParenR       <$ symbol ")"
  , TokenBraceL       <$ symbol "{"
  , TokenBraceR       <$ symbol "}"
  , TokenBracketL     <$ symbol "["
  , TokenBracketR     <$ symbol "]"
  , TokenComma        <$ symbol ","
  , TokenSemicolon    <$ symbol ";"
  ]

parseToken :: Parser Token
parseToken = choice
  [ try parseFloat
  , parseInteger
  , parseString
  , parseIdentOrKeyword
  , parseOperator
  , parseDelimiter
  ]

type TokenStream = [Token]

tokenize :: Text -> Either (ParseErrorBundle Text Void) TokenStream
tokenize = parse (sc *> many parseToken <* eof) ""

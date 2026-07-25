module Poo.Token where

data Token
  -- Literals & Identifiers
  = TokenInt    Integer
  | TokenFloat  Double
  | TokenString String
  | TokenBool   Bool
  | TokenNull
  | TokenUndefined
  | TokenIdent String
  | TokenHashBracketL   -- #[
  | TokenHashParenL     -- #(
  | TokenHashBraceL     -- #{
  | TokenColon          -- :

  -- Keywords
  | TokenAs         -- as
  | TokenBreak      -- break
  | TokenContinue   -- continue
  | TokenDo         -- do
  | TokenFn         -- fn
  | TokenIf         -- if
  | TokenLoop       -- loop
  | TokenLoopBang   -- loop!
  | TokenOr         -- or
  | TokenReturn     -- return
  | TokenSwitch     -- switch
  | TokenSwitchBang -- switch!
  | TokenVal        -- val

  -- Operators -----------------------------------
  | TokenPlus | TokenMinus  --  + -
  | TokenStar | TokenSlash  --  * /
  | TokenPercent            --  %
  | TokenEq   | TokenNeq    --  == !=
  | TokenLt   | TokenGt     --  < >
  | TokenLe   | TokenGe     --  =< >=
  | TokenAnd  | TokenOrOp   --  && ||
  | TokenPipe               --  >>
  | TokenAssign             -- =

  -- Delimiters -------------
  | TokenParenL   | TokenParenR    -- ( )
  | TokenBraceL   | TokenBraceR    -- [ ]
  | TokenBracketL | TokenBracketR  -- { }
  | TokenComma                     -- ,
  | TokenSemicolon                 -- ;
  | TokenArrow                     -- =>
  | TokenHash                      -- #

  | TokenEOF
  deriving (Show, Eq)

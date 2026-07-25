module Poo.Token where

data Token
  -- Literals & Identifiers
  = TInt Integer
  | TFloat Double
  | TString String
  | TBool Bool
  | TNull
  | TUndefined
  | TIdent String
  | THashLBracket   -- #[
  | THashLParen     -- #(
  | THashLBrace     -- #{
  | TColon          -- :

  -- Keywords
  | TAs        -- as
  | TBreak     -- break
  | TContinue  -- continue
  | TDo        -- do
  | TFn        -- fn
  | TIf        -- if
  | TLoop      -- loop
  | TLoopBang  -- loop!
  | TOr        -- or
  | TReturn    -- return
  | TVal       -- val

  -- Operators -----------------------------------
  | TPlus | TMinus | TStar | TSlash | TPercent  --  + - * / %
  | TEq   | TNeq   | TLt   | TGt   | TLe | TGe  --  == !== < > =< >=
  | TAnd  | TOrOp                               -- && ||
  | TPipe                                       -- >>
  | TAssign                                     -- =

  -- Delimiters -------------
  | TLParen   | TRParen    -- ( )
  | TLBrace   | TRBrace    -- [ ]
  | TLBracket | TRBracket  -- { }
  | TComma                 -- ,
  | TSemicolon             -- ;
  | TArrow                 -- =>
  | THash                  -- #

  | TEOF
  deriving (Show, Eq)

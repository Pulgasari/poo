module Poo.AST where

type Name = String

data Literal
  = LInt    Integer
  | LFloat  Double
  | LString String
  | LBool   Bool
  | LNull
  | LUndefined
  deriving (Show, Eq)

data BinOp
  = Add | Sub | Mul | Div | Mod
  | Eq  | Neq | Lt  | Gt  | Le  | Ge
  | And | Or
  deriving (Show, Eq)

data Expr
  = Lit    Literal
  | Var    Name
  | App    Expr   [Expr]             -- f(a, b)  or  f a
  | Binary Expr   BinOp Expr
  | Pipe   Expr   Expr               -- a >> f
  | If     Expr   Expr (Maybe Expr)  -- if ... or ...
  | Lambda [Name] Expr               -- (a, b) => expr
  | Block  [Stmt]
  deriving (Show, Eq)

data Stmt
  = Val Name Expr                -- val x = ...
  | Fn  Name [Name] Expr          -- fn name = params => body
  | ExprStmt Expr
  deriving (Show, Eq)

type Program = [Stmt]

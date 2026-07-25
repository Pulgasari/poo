module Poo.AST where

type Name = String

data Literal
  = LInt     Integer
  | LFloat   Double
  | LString  String
  | LBool    Bool
  | LNull
  | LUndefined
  deriving (Show, Eq)

data BinOp
  = Add | Sub | Mul | Div | Mod
  | Eq  | Neq | Lt  | Gt  | Le  | Ge
  | And | Or
  deriving (Show, Eq)

data UnaryOp
  = Neg     -- -x
  | Not     -- optional, falls du ! später willst
  deriving (Show, Eq)

data Expr
  = Lit    Literal
  | Var    Name
  | App    Expr    [Expr]             -- f(a, b)  or  f a
  | Binary Expr    BinOp Expr
  | Unary  Expr    Expr
  | Unary  UnaryOp Expr
  | Pipe   Expr    Expr               -- a >> f
  | If     Expr    Expr (Maybe Expr)  -- if ... or ...
  | Lambda [Name]  Expr               -- (a, b) => expr
  | Block  [Stmt]
  | Array  [Expr]                     --  [1, 2, 3]
  | List   [Expr]                     -- #[1, 2, 3]
  | Tuple  [Expr]                     -- #(1, 2, 3)
  | Record [(Name, Expr)]             -- #{a: 1, b: 2}
  | Loop   LoopKind
  deriving (Show, Eq)

data LoopKind
  = LoopWhile Expr Expr       -- loop (cond) { body }   or  loop (cond) do expr   
  | LoopOver  Expr Name Expr  -- loop coll as name { body }
  deriving (Show, Eq)

data Stmt
  = Val Name Expr         -- val x = ...
  | Fn  Name [Name] Expr  -- fn name = params => body
  | ExprStmt Expr
  deriving (Show, Eq)

type Program = [Stmt]








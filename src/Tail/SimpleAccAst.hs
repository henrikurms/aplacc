module Tail.SimpleAccAst
  ( module Tail.SimpleAccAst
  , T.BType(..)
  ) where

import qualified Tail.Ast as T

data Type
  = Exp T.BType         -- Exp t
  | Acc Integer T.BType -- Acc (Array n t)
  deriving (Show, Eq)

baseType :: Type -> T.BType
baseType (Exp t) = t
baseType (Acc _ t) = t

data Name
  = Ident T.Ident
  | Symbol String
  deriving (Show)

data QName
  = UnQual Name
  | Prelude Name
  | Accelerate Name
  | Primitive Name
  deriving (Show)

data Exp
  = Var QName
  | I Integer
  | D Double
  | Shape [Integer]
  | Neg Exp
  | TypSig Exp Type
  | List [Exp]
  | InfixApp QName [Exp]       -- x1 `op` x2 `op` …
  | App QName [Exp]            -- op x1 x2 …
  | Let T.Ident Type Exp Exp    -- let x = e1 :: t in e2
  | Fn T.Ident Type Exp         -- \x -> e
  deriving (Show)

type Program = Exp

the x  = App (Accelerate $ Ident "the") [x]
unit x = App (Accelerate $ Ident "unit") [x]
i2d x  = App (Primitive  $ Ident "i2d") [x]
fromList n x = App (Accelerate $ Ident "fromList") [Shape [fromIntegral n], x]
use x  = App (Accelerate $ Ident "use") [x]

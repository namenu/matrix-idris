module Color

import Const
import Control.Algebra

%access export

||| TODO : bound r, g, b to 0.0 ~ 1.0
record Color where
  constructor MkColor
  r, g, b : Double


black : Color
black = MkColor 0 0 0

toIntTuple : Color -> (Int, Int, Int)
toIntTuple (MkColor r g b) = (conv r, conv g, conv b)
                             where conv : Double -> Int
                                   conv v = min 255 (max 0 (cast (v * 255 + 0.5)))

toByteTuple : Color -> (Bits8, Bits8, Bits8)
toByteTuple (MkColor r g b) = (prim__fromFloatB8 r, prim__fromFloatB8 g, prim__fromFloatB8 b)


Eq Color where
  (==) (MkColor r1 g1 b1) (MkColor r2 g2 b2)
         = abs (r1 - r2) < ε && abs (g1 - g2) < ε && abs (b1 - b2) < ε



(+) : Color -> Color -> Color
(+) (MkColor r1 g1 b1) (MkColor r2 g2 b2) = MkColor (r1 + r2) (g1 + g2) (b1 + b2)

(-) : Color -> Color -> Color
(-) (MkColor r1 g1 b1) (MkColor r2 g2 b2) = MkColor (r1 - r2) (g1 - g2) (b1 - b2)

(*) : Color -> Color -> Color
(*) (MkColor r1 g1 b1) (MkColor r2 g2 b2) = MkColor (r1 * r2) (g1 * g2) (b1 * b2)


Semigroup Color where
  (<+>) = (+)

Monoid Color where
  neutral = black

-- action over Colorspace

infixl 5 *.

(*.) : Color -> Double -> Color
(*.) (MkColor r g b) v = MkColor (r * v) (g * v) (b * v)

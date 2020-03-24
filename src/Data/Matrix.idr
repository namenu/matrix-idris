module Data.Matrix

import public Data.Vect

--%default total
%access public export


-- Vect helpers

indices : (n : Nat) -> Vect n (Fin n)
indices Z = []
indices (S k) = FZ :: (map FS $ indices k)

zipi : Vect n a -> Vect n (Fin n, a)
zipi {n} m = zip (indices n) m


-- Constructor

Matrix : Nat -> Nat -> Type -> Type
Matrix n m a = Vect n (Vect m a)


at : Fin n -> Fin m -> Matrix n m a -> a
at r c = index c . index r

row : Fin n -> Matrix n m a -> Vect m a
row = index

col : Fin m -> Matrix n m a -> Vect n a
col c = map (index c)


dotProduct : (Num a) => Vect n a -> Vect n a -> a
dotProduct x y = sum $ zipWith (*) x y


(*) : Num a => Matrix n k a -> Matrix k m a -> Matrix n m a
(*) m1 m2 = map (vectMult m2) m1
  where
    vectMult : Num a => Matrix n m a -> Vect n a -> Vect m a
    vectMult m v = map (dotProduct v) (transpose m)


submatrix : Fin (S n) -> Fin (S m) -> Matrix (S n) (S m) a -> Matrix n m a
submatrix r c = deleteRow r . deleteCol c
  where
    deleteRow : Fin (S n) -> Matrix (S n) m a -> Matrix n m a
    deleteRow = deleteAt

    deleteCol : Fin (S m) -> Matrix n (S m) a -> Matrix n m a
    deleteCol c = map (deleteAt c)


det2 : Neg a => Matrix 2 2 a -> a
det2 [[a, b], [c, d]] = a * d - b * c


mutual
  ||| 2x2 이상
  det : Neg a => Matrix (2 + n) (2 + n) a -> a
  det {n} m = case n of
                   Z     => det2 m
                   (S k) => sum $ map (\c => at 0 c m * cofactor 0 c m) $ indices (3 + k)


  ||| not total due to mod (Integral)
  cofactor : Neg a => Fin (3 + n) -> Fin (3 + n) -> Matrix (3 + n) (3 + n) a -> a
  cofactor r c m = let minor = det (submatrix r c m)
                       sign = case mod (finToInteger r + finToInteger c) 2 of
                                   0 => (* 1)
                                   1 => (* -1)
                    in sign minor


invertible : Double -> Matrix (S (S n)) (S (S n)) Double -> Bool
invertible eps m = det m >= eps
--- TYPES ---

-- removeNonUppercase "has type of" (::) String
-- removeNonUppercase :: [Char] -> [Char]
removeNonUppercase :: String -> String   -- Same as above. String is synonymous with [Char]
removeNonUppercase st = [c | c <- st, c `elem` ['A'..'Z']]

{-
   Explicit type declaration is considered good practice, except for simple functions/expressions
   as the type can be easily inferred by the compiler.
-}

{- 
   The parameters are separated with '->' with no special distinction between the parameters 
   and the return type. The return type is the last item in the declaration, the parameters are the first three.
-}
addThree :: Int -> Int -> Int -> Int
addThree x y z = x + y + z

{- 
   Common Types:
      Int:     Integer, used for whole numbers. Bounded (has a min and max value)
      Integer: Integer. Unbounded, can be used for very large (whole) numbers.
-}
factorial :: Integer -> Integer
factorial n = product [1..n]
{-
   ghci> factorial 50
   30414093201713378043612608166064768844377641568960512000000000000
-}

--  Float: Real floating point with single precision
circumference :: Float -> Float
circumference r = 2 * pi * r
{-
   ghci> circumference 4.0
   25.132742
-}

--  Double: Real floating point with double the precision
circumference' :: Double -> Double
circumference' r = 2 * pi * r
   --  ghci> circumference' 4.0
   --  25.132741228718345

{-
   Bool: Boolean, can only be True or False
   Char: Represents a character, denoted by single quotes. A list of characters is a String
-}


--- TYPE VARIABLES ---
{-
   ghci> :t head
   head :: GHC.Stack.Types.HasCallStack => [a] -> a
   ghci> :t fst
   fst :: (a, b) -> a
   ghci>

   The 'a' and 'b' in the GHCI output are 'type variables', meaning they can be of any type.
   Functions with type variables are known as polymorphic functions
-}
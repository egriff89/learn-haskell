--- RECURSION ---
{-
   A way of defining functions that call themselves until a base/edge condition is reached.

   Example: the Fibonacci sequence - F(n) = F(n - 1) + F(n - 2)
      Edge cases:
         F(0) = 0
         F(1) = 1
      
      3rd Fibonacci number:
         F(3) = F(3 - 1) + F(3 - 2)
         F(3) = F(2) + F(1)
         F(3) = (F(2 - 1) + F(2 - 2)) + 1
         F(3) = (1 + 0) + 1
         F(3) = 2

   There are no loops in Haskell, just recursion.
-}

-- Custom maximum function
maximum' :: (Ord a) => [a] -> a
maximum' []  = error "maximum of empty list"
maximum' [x] = x
maximum' (x:xs) = max x (maximum' xs)
-- maximum' (x:xs)
--    | x > maxTail = x
--    | otherwise = maxTail
--    where maxTail = maximum' xs

-- Custom replicate: return list containing N elements of X
replicate' :: (Num i, Ord i) => i -> a -> [a]
replicate' n x
   | n <= 0    = []
   | otherwise = x:replicate' (n-1) x
{-
ghci> replicate' 3 5
[5,5,5]
-}

-- Custom take: return list of first N elements of provided list
take' :: (Num i, Ord i) => i -> [a] -> [a]
take' n _
   | n <= 0    = []
take' _ []     = []
take' n (x:xs) = x : take' (n-1) xs
{-
   ghci> take' 3 [4,3,2,1]
   [4,3,2]
-}

-- Custom reverse: reverse a list
reverse' :: [a] -> [a]
reverse' [] = []
reverse' (x:xs) = reverse' xs ++ [x]
{-
   ghci> reverse' [1,2,3,4,5]
   [5,4,3,2,1]
-}

-- Custom repeat: return infinite list of X
repeat' :: a -> [a]
repeat' x = x:repeat' x
{-
   ghci> take' 10 (repeat' 3)
   [3,3,3,3,3,3,3,3,3,3]
   ghci> take' 50 (repeat' 1) 
   [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
-}

-- Custom zip: take two lists and zip them together
zip' :: [a] -> [b] -> [(a,b)]
zip' _ [] = []
zip' [] _ = []
zip' (x:xs) (y:ys) = (x,y):zip' xs ys
{-
   ghci> zip' [1,2,3] [4,5,6]
   [(1,4),(2,5),(3,6)]
-}

-- Custom elem: check if an element is in a list
elem' :: (Eq a) => a -> [a] -> Bool
elem' a [] = False
elem' a (x:xs)
   | a == x    = True
   | otherwise = a `elem'` xs
{-
   ghci> 'a' `elem'` ['a','b','c']
   True  
   ghci> 'a' `elem'` ['b','c']    
   False
   ghci> 'a' `elem'` []       
   False
-}


--- QUICKSORT ---
quicksort :: (Ord a) => [a] -> [a]
quicksort [] = []
quicksort (x:xs) =
   let smallerSorted = quicksort [a | a <- xs, a <= x]
       biggerSorted  = quicksort [a | a <- xs, a > x]
   in smallerSorted ++ [x] ++ biggerSorted
{-
   ghci> quicksort [10,2,5,3,1,6,7,4,2,3,4,8,9]
   [1,2,2,3,3,4,4,5,6,7,8,9,10]
   ghci> quicksort "the quick brown fox jumps over the lazy dog"
   "        abcdeeefghhijklmnoooopqrrsttuuvwxyz"
-}
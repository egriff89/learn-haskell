--- LOADING MODULES ---
{-
   A Haskell module is a collection of related functions, types and typeclasses. A Haskell program 
   is a collection of modules where the main module loads up the other modules and then uses 
   the functions defined in them to do something.

   If a module is generic enough, the exported functions can be used across multiple
   different programs. Separating your own code into loosely coupled modules will allow
   you to use them later on.

   The Haskell standard library is split into modules, each of them contains functions and types 
   that are somehow related and serve some common purpose. There's a module for manipulating lists, 
   a module for concurrent programming, a module for dealing with complex numbers, etc. All the functions, 
   types and typeclasses that we've dealt with so far were part of the `Prelude` module, which is imported by default.
-}

{-
   Syntax: 
      Import an entire module  - `import <module>`
      Import specific function - `import <module> (<function>)`
      
      Dealing with name clashes:
         Hide specific functions - `import <module> hiding (<function>)`
         Fully qualify imports   - `import qualified <module>`
      Alias qualified imports    - `import qualified Data.Map as M`
-}


--- DATA.LIST
import Data.List

-- `intersperse`: takes an element and a list and then puts that element in between each pair of elements in the list
monkey :: String
monkey = intersperse '.' "MONKEY"
{-
   ghci> monkey
   "M.O.N.K.E.Y"
-}

-- `intercalate`: takes a list of lists and a list, inserts that list in between all those lists and then flattens the result
addSpace :: String
addSpace = intercalate " " ["hey", "there", "guys"]

flattenLists :: [Integer]
flattenLists = intercalate [0,0,0] [[1,2,3],[4,5,6],[7,8,9]]
{-
   ghci> addSpace 
   "hey there guys"
   ghci> flattenLists 
   [1,2,3,0,0,0,4,5,6,0,0,0,7,8,9]
-}

-- `transpose`: transposes a list of lists. If you look at a list of lists as a 2D matrix, the columns become the rows and vice versa
trMatrix :: [[Integer]]
trMatrix = transpose [[1,2,3],[4,5,6],[7,8,9]]

trString :: [String]
trString = transpose ["hey", "there", "guys"]
{-
   ghci> trMatrix 
   [[1,4,7],[2,5,8],[3,6,9]]
   ghci> trString 
   ["htg","ehu","yey","rs","e"]
-}

addPolynomials :: [Integer]
-- Adds polynomials 3x^2 + 5x + 9, 10x^3 + 9 and 8x^3 + 5x^2 + x - 1
addPolynomials = map sum $ transpose [[0,3,5,9],[10,0,0,9],[8,5,1,-1]]
{-
   ghci> addPolynomials
   [18,8,6,17]
-}

{-
   `foldl'` and `foldl1'` are stricter versions of their respective lazy incarnations. When using lazy folds on really big lists, you might often get a stack overflow error. The culprit for that is that due to the lazy nature of the folds, the accumulator value isn't actually updated as the folding happens. What actually happens is that the accumulator kind of makes a promise that it will compute its value when asked to actually produce the result (also called a thunk). That happens for every intermediate accumulator and all those thunks overflow your stack. The strict folds aren't lazy buggers and actually compute the intermediate values as they go along instead of filling up your stack with thunks. So if you ever get stack overflow errors when doing lazy folds, try switching to their strict versions.
-}

-- `concat`: Flatten a list of lists into just a list of elements.
fooBarCar :: [Char]
fooBarCar = concat ["foo", "bar", "car"]
{-
   ghci> fooBarCar 
   "foobarcar"
   ghci> concat [[3,4,5],[2,3,4],[2,1,1]]  
   [3,4,5,2,3,4,2,1,1] 
-}

{-
   `concat` only removes one level of nesting. If you want to flatten something like `[[[2,3],[3,4,5],[2]],[[2,3],[3,4]]]`,
   a list of lists of lists (two levels of nesting), you need to concatenate it twice:

      ghci> concat $ concat [[[2,3],[3,4,5],[2]],[[2,3],[3,4]]]
      [2,3,3,4,5,2,2,3,3,4]
-}

-- `concatMap`: The same as first mapping a function to a list and then concatenating the list with `concat`
catMapReplicate :: [Integer]
catMapReplicate = concatMap (replicate 4) [1..3]
{-
   ghci> catMapReplicate 
   [1,1,1,1,2,2,2,2,3,3,3,3]
   ghci> concat $ map (replicate 4) [1..3]
   [1,1,1,1,2,2,2,2,3,3,3,3]
-}

{-
   `and`: Takes a list of boolean values and returns `True` only if all the values in the list are `True`.
      
      ghci> and $ map (>4) [5,6,7,8]  
      True  
      ghci> and $ map (==4) [4,4,4,3,4]  
      False

   `or`: Like `and`, but only returns `True` if any of the boolean values in a list is `True`.
      
      ghci> or $ map (==4) [2,3,4,5,6,1]  
      True  
      ghci> or $ map (>4) [1,2,3]  
      False 

   `any` and `all`: Take a predicate and then check if any or all the elements in a list satisfy the predicate, respectively. 
      - Generally used in favor of mapping over a list and using `and` or `or`.
      
      ghci> any (==4) [2,3,5,6,1,4]  
      True  
      ghci> all (>4) [6,9,10]  
      True  
      ghci> all (`elem` ['A'..'Z']) "HEYGUYSwhatsup"  
      False  
      ghci> any (`elem` ['A'..'Z']) "HEYGUYSwhatsup"  
      True  
-}

-- `iterate`: Takes a function and starting value. Function is applied to the starting value and subsequent return values infinitely.
iterateAndDouble :: Num a => Int -> [a]
iterateAndDouble n = take n $ iterate (*2) 1
{-
   ghci> iterateAndDouble 10
   [1,2,4,8,16,32,64,128,256,512]
   ghci> take 3 $ iterate (++ "haha") "haha"  
   ["haha","hahahaha","hahahahahaha"]
-}

-- `splitAt`: Takes a number and a list and splits the list at that many elements, returning the resulting two lists in a tuple.
splitMeBro :: Int -> [a] -> ([a], [a])
splitMeBro n s = splitAt n s
{-
   ghci> splitMeBro 3 "heyman"
   ("hey","man")
   ghci> splitMeBro 100 "heyman"
   ("heyman","")
   ghci> let (a,b) = splitAt 3 "foobar" in b ++ a
   "barfoo"
   ghci> let (a,b) = splitAt 2 "foobar" in b ++ a   
   "obarfo"
-}

-- `takeWhile`: Takes elements from a list while the predicate holds true and cuts off when false. It turns out this is very useful.
{-
   ghci> takeWhile (>3) [6,5,4,3,2,1,2,3,4,5,4,3,2,1]  
   [6,5,4]  
   ghci> takeWhile (/=' ') "This is a sentence"  
   "This"
-}

-- sum of all third powers that are under 10,000
sumThirdPowUnder10k :: Integer
sumThirdPowUnder10k = sum $ takeWhile (<10000) $ map (^3) [1..]
{-
   ghci> sumThirdPowUnder10k 
   53361
-}


-- `dropWhile`: Similar to `takeWhile`, but drops all the elements while predicate is true. Returns rest of list once predicate is false.
{-
   ghci> dropWhile (/=' ') "This is a sentence"  
   " is a sentence"  
   ghci> dropWhile (<3) [1,2,2,2,3,4,5,4,3,2,1]  
   [3,4,5,4,3,2,1] 
-}

{-
   We're given a list that represents the value of a stock by date. The list is made of tuples whose first component is the stock value, 
   the second is the year, the third is the month and the fourth is the date. We want to know when the stock value first exceeded one thousand dollars!
-}
stock :: [(Double, Integer, Integer, Integer)]
stock = [(994.4,2008,9,1),(995.2,2008,9,2),(999.2,2008,9,3),(1001.4,2008,9,4),(998.3,2008,9,5)]

firstDateStockBroke1k :: (Double, Integer, Integer, Integer)
firstDateStockBroke1k = head $ dropWhile (\(val,y,m,d) -> val < 1000) stock
{-
   ghci> firstDateStockBroke1k
   (1001.4,2008,9,4)
-}

-- `span`: Like `takeWhile`, but returns a pair of lists.
{-
   ghci> let (fw, rest) = span (/=' ') "This is a sentence" in "First word:" ++ fw ++ ", the rest:" ++ rest  
   "First word: This, the rest: is a sentence" 
-}

-- `break`: Breaks list when predicate is first true
breakAt4 :: ([Integer], [Integer])
breakAt4 = break (==4) [1,2,3,4,5,6,7]

spanUntil4 :: ([Integer], [Integer])
spanUntil4 = span (/=4) [1,2,3,4,5,6,7] -- Same as above, but using `span`
{-
   ghci> breakAt4 
   ([1,2,3],[4,5,6,7])
   ghci> spanUntil4 
   ([1,2,3],[4,5,6,7]) 
-}

{-
   `sort` simply sorts a list. List elements have to be part of the Ord typeclass, otherwise the list can't be sorted.
      ghci> sort [8,5,3,2,1,6,4,2]  
      [1,2,2,3,4,5,6,8]  
      ghci> sort "This will be sorted soon"  
      "    Tbdeehiillnooorssstw"

   `group` takes a list and groups adjacent elements into sublists if they are equal.
      ghci> group [1,1,1,1,2,2,2,2,3,3,2,2,2,5,6,7]  
      [[1,1,1,1],[2,2,2,2],[3,3],[2,2,2],[5],[6],[7]] 

   `inits` and `tails` are like `init` and `tail`, only they recursively apply that to a list until there's nothing left. Observe.
      ghci> inits "w00t"  
      ["","w","w0","w00","w00t"]  
      ghci> tails "w00t"  
      ["w00t","00t","0t","t",""]  
      ghci> let w = "w00t" in zip (inits w) (tails w)  
      [("","w00t"),("w","00t"),("w0","0t"),("w00","t"),("w00t","")]
-}

-- searching a list for a sublist (using `tails` and a fold)
-- First we call tails with the list in which we're searching. Then we go over each tail and see if it starts with what we're looking for.
search :: (Eq a) => [a] -> [a] -> Bool
search needle haystack = 
   let nlen = length needle
   in foldl (\acc x -> if take nlen x == needle then True else acc) False (tails haystack)


-- `isInfixOf` searches for a sublist within a list and returns True if the sublist we're looking for is somewhere inside the target list.
{-
   ghci> "cat" `isInfixOf` "im a cat burglar"  
   True  
   ghci> "Cat" `isInfixOf` "im a cat burglar"  
   False  
   ghci> "cats" `isInfixOf` "im a cat burglar"  
   False 
-}

-- `isPrefixOf` and `isSuffixOf` search for a sublist at the beginning and at the end of a list, respectively.
{-
   ghci> "hey" `isPrefixOf` "hey there!"  
   True  
   ghci> "hey" `isPrefixOf` "oh hey there!"  
   False  
   ghci> "there!" `isSuffixOf` "oh hey there!"  
   True  
   ghci> "there!" `isSuffixOf` "oh hey there"  
   False 
-}

-- `elem` and `notElem` check if an element is or isn't inside a list.

-- `partition`: Takes a list and a predicate and returns a pair of lists. The first contains all matching elements, failed matches are in the second.
partString :: String -> (String, String)
partString s = partition (`elem` ['A'..'Z']) s
{-
   ghci> partString "BOBsidneyMORGANeddy"
   ("BOBMORGAN","sidneyeddy")
-}

{-
   NOTE: While `span` and `break` are done once they encounter the first element that doesn't and does satisfy the predicate, 
   `partition` goes through the whole list and splits it up according to the predicate.
-}
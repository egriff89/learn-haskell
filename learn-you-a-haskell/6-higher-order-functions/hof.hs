{-
   Haskell functions can take functions as parameters and return functions as return values. 
   A function that does either of those is called a higher order function. Higher order functions aren't just a part of the Haskell experience, 
   they pretty much are the Haskell experience. 
   It turns out that if you want to define computations by defining what stuff is instead of defining steps that change some state and maybe looping them, higher order functions are indispensable. They're a really powerful way of solving problems and thinking about programs.
-}

-- CURRIED FUNCTIONS
{-
   Currying is the process of transforming a function that takes multiple arguments in a tuple as its argument, into a function that takes just a single argument and returns another function which accepts further arguments, one by one, that the original function would receive in the rest of that tuple.

   Example: The `max` function
   It looks like it takes two parameters and returns the one that's bigger. Doing `max 4 5` first creates a function that takes a parameter and returns either 4 or that parameter, depending on which is bigger. Then, 5 is applied to that function and that function produces our desired result. That sounds like a mouthful but it's actually a really cool concept. The following two calls are equivalent:

   ghci> max 4 5  
   5  
   ghci> (max 4) 5  
   5

   Putting a space between two things is simply function application. The space is sort of like an operator and it has the highest precedence.

   The type of `max` is: "max :: (Ord a) => a -> a -> a". It can also be written as: "max :: (Ord a) => a -> (a -> a)"
   Could be read as: "`max` takes an 'a' and returns (that's the ->) a function that takes an 'a' and returns an 'a'". That's why the return type and the parameters of functions are all simply separated with arrows.

   If we call a function with too few parameters, we get back a -partially applied function-, meaning a function that takes as many parameters as we left out. Using partial application (calling functions with too few parameters, if you will) is a neat way to create functions on the fly so we can pass them to another function or to seed them with some data.
-}

-- Sample function multThree
-- multThree :: (Num a) => a -> (a -> (a -> a))
multThree :: (Num a) => a -> a -> a -> a
multThree x y z = x * y * z

{-
   Ex: `multThree 3 5 9` OR `((multThree 3) 5) 9`
      First, 3 is applied to multThree which creates and returns a function that multiplies a value by 3.
      Second, 5 is applied to this new function and returns a function that multiplies a new parameter by 15.
      Finally, 9 is applied to this new function and returns the value 135.
-}


-- Examples of partial application

-- Multiply two numbers by 9
multTwoWithNine :: Integer -> Integer -> Integer
multTwoWithNine = multThree 9  -- partial application: `multThree 9 _ _`
{-
   ghci> multTwoWithNine 2 3
   54
-}

-- Multiply a number by 18
multWithEighteen :: Integer -> Integer
multWithEighteen = multTwoWithNine 2    -- partial application: `multThree 9 2 _`
{-
   ghci> multWithEighteen 10  
   180
-}

-- compare :: (Ord a) => a -> (a -> Ordering)
compareWithHundred :: (Num a, Ord a) => (a -> Ordering)
-- compareWithHundred x = compare 100 x
compareWithHundred = compare 100


{-
   Infix functions can also be partially applied by using sections. To section an infix function, simply surround it with parentheses and only supply a parameter on one side. That creates a function that takes one parameter and then applies it to the side that's missing an operand. An insultingly trivial function:
-}
divideByTen :: (Floating a) => a -> a
divideByTen = (/10)
{-
   ghci> divideByTen 200
   20.0  
   ghci> (/10) 200
   20.0
-}

-- A function that checks if a character supplied to it is an uppercase letter
isUpperAlphanum :: Char -> Bool
isUpperAlphanum = (`elem` ['A'..'Z'])


--- HIGHER-ORDERISM ---
{-
   ** Higher order functions are those that can take functions as parameters and can also return functions **
   
   Notice the type declaration. Before, we didn't need parentheses because `->` is naturally right-associative. However, here, 
   they're mandatory. They indicate that the first parameter is a function that takes something and returns that same thing. 
   The second parameter is something of that type also and the return value is also of the same type.
-}

-- Function that takes a function and then applies it twice to something
applyTwice :: (a -> a) -> a -> a
applyTwice f x = f (f x)
{-
   ghci> applyTwice (+3) 10
   16    
   ghci> applyTwice (++ " HAHA") "HEY"
   "HEY HAHA HAHA"
   ghci> applyTwice (multThree 2 2) 9
   144
-}

-- Custom zipWith
zipWith' :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith' _ [] _ = []
zipWith' _ _ [] = []
zipWith' f (x:xs) (y:ys) = f x y : zipWith' f xs ys
{-
   ghci> zipWith' (+) [4,2,5,6] [2,6,2,3]
   [6,8,7,9]
   ghci> zipWith' max [6,3,2,1] [7,3,1,5]
   [7,3,2,5]
   ghci> zipWith' (++) ["foo ", "bar ", "baz "] ["fighters", "hoppers", "aldrin"]
   ["foo fighters","bar hoppers","baz aldrin"]
   ghci> zipWith' (*) (replicate 5 2) [1..]
   [2,4,6,8,10]
   ghci> zipWith' (zipWith' (*)) [[1,2,3],[3,5,6],[2,3,4]] [[3,2,2],[3,4,5],[5,4,3]]
   [[3,4,6],[9,20,30],[10,12,12]]
-}

-- Takes a function and returns a function that is like our original function, only the first two arguments are flipped
flip' :: (a -> b -> c) -> b -> a -> c
flip' f x y = f y x
{-
   ghci> flip' zip [1,2,3,4,5] "hello" 
   [('h',1),('e',2),('l',3),('l',4),('o',5)]
   ghci> zipWith (flip' div) [2,2..] [10,8,6,4,2] 
   [5,4,3,2,1]
-}


--- MAPS AND FILTERS ---
{-
   `map` takes a function and a list and applies that function to every element in the list, producing a new list.

      map :: (a -> b) -> [a] -> [b]  
      map _ [] = []  
      map f (x:xs) = f x : map f xs

   Ex:
      ghci> map (+3) [1,5,3,1,6]  
      [4,8,6,4,9]  
      ghci> map (++ "!") ["BIFF", "BANG", "POW"]  
      ["BIFF!","BANG!","POW!"]  
      ghci> map (replicate 3) [3..6]  
      [[3,3,3],[4,4,4],[5,5,5],[6,6,6]]  
      ghci> map (map (^2)) [[1,2],[3,4,5,6],[7,8]]  
      [[1,4],[9,16,25,36],[49,64]]  
      ghci> map fst [(1,2),(3,5),(6,3),(2,6),(2,5)]  
      [1,3,6,2,2]

   Each of these could be achieved with a list comprehension. `map (+3) [1,5,3,1,6]` is the same 
   as writing `[x+3 | x <- [1,5,3,1,6]]`. However, using map is much more readable for cases 
   where you only apply some function to the elements of a list, especially once you're dealing with 
   maps of maps and then the whole thing with a lot of brackets can get a bit messy.
-}

{-
   `filter` is a function that takes a predicate (a predicate is a function that tells whether 
   something is true or not, so in our case, a function that returns a boolean value) and a list and 
   then returns the list of elements that satisfy the predicate. The type signature and implementation go like this:

      filter :: (a -> Bool) -> [a] -> [a]  
      filter _ [] = []  
      filter p (x:xs)   
         | p x       = x : filter p xs  
         | otherwise = filter p xs

   Ex:
      ghci> filter (>3) [1,5,3,2,1,6,4,3,2,1]  
      [5,6,4]  
      ghci> filter (==3) [1,2,3,4,5]  
      [3]  
      ghci> filter even [1..10]  
      [2,4,6,8,10]  
      ghci> let notNull x = not (null x) in filter notNull [[1,2,3],[],[3,4,5],[2,2],[],[],[]]  
      [[1,2,3],[3,4,5],[2,2]]  
      ghci> filter (`elem` ['a'..'z']) "u LaUgH aT mE BeCaUsE I aM diFfeRent"  
      "uagameasadifeent"  
      ghci> filter (`elem` ['A'..'Z']) "i lauGh At You BecAuse u r aLL the Same"  
      "GAYBALLS"

   All of this could also be achived with list comprehensions by the use of predicates. There's no 
   set rule for when to use `map` and `filter` versus using list comprehension, you just have to decide 
   what's more readable depending on the code and the context. The filter equivalent of applying several 
   predicates in a list comprehension is either filtering something several times or joining 
   the predicates with the logical `&&` function
-}

-- quicksort function from last chapter, using filter
quicksort :: (Ord a) => [a] -> [a]
quicksort [] = []
quicksort (x:xs) =
   let smallerSorted = quicksort (filter (<=x) xs)
       biggerSorted  = quicksort (filter (>x) xs)
   in smallerSorted ++ [x] ++ biggerSorted

-- Find the largest number under 100,000 divisible 3829
largestDivisible :: (Integral a) => a
largestDivisible = head (filter p [100000,99999..])
   where p x = x `mod` 3829 == 0
{-
   ghci> largestDivisible 
   99554
-}


{-
   Collatz Sequences
      - Take a natural number. If it's even, we divide it by two. 
      - If it's odd, we multiply it by 3 and then add 1 to that. 
      We take the resulting number and apply the same thing to it, which produces a new number and so on. In essence, 
      we get a chain of numbers. It is thought that for all starting numbers, the chains finish at the number 1.

      If we take the starting number 13, we get this sequence: 13, 40, 20, 10, 5, 16, 8, 4, 2, 1.
-}

chain :: (Integral a) => a -> [a]
chain 1 = [1]
chain n
   | even n = n:chain (n `div` 2)
   | odd n  = n:chain (3*n + 1)
{-
   ghci> chain 10
   [10,5,16,8,4,2,1]
   ghci> chain 1
   [1]   
   ghci> chain 30
   [30,15,46,23,70,35,106,53,160,80,40,20,10,5,16,8,4,2,1]
-}

-- For all starting numbers between 1 and 100, how many chains have a length greater than 15?
numLongChains :: Int
numLongChains = length (filter isLong (map chain [1..100]))
   where isLong xs = length xs > 15
{-
   ghci> numLongChains 
   66 
-}


--- LAMBDAS ---
{-
   Lambdas are basically anonymous functions that are used because we need some functions only once. 
   Normally, we make a lambda with the sole purpose of passing it to a higher-order function. To make a lambda, 
   we write a `\` (because it kind of looks like the greek letter lambda if you squint hard enough) and then we write the parameters, 
   separated by spaces. After that comes a `->` and then the function body. We usually surround them by parentheses, 
   because otherwise they extend all the way to the right.
-}


-- numLongChains, but with a lambda
numLongChains' :: Int
numLongChains' = length (filter (\xs -> length xs > 15) (map chain [1..100]))
{-
   ghci> numLongChains'
   66 
-}


--- FOLDS ---
{-
   A fold takes a binary function, a starting value (I like to call it the accumulator) and a list to fold up. 
   The binary function itself takes two parameters. The binary function is called with the accumulator and the first (or last) 
   element and produces a new accumulator. Then, the binary function is called again with the new accumulator 
   and the now new first (or last) element, and so on. Once we've walked over the whole list, only the accumulator remains, 
   which is what we've reduced the list to.
-}

-- `foldl` function - Folds list up from the left side
-- Custom `sum` function using `foldl`
sum' :: (Num a) => [a] -> a
sum' xs = foldl (\acc x -> acc + x) 0 xs
-- sum' xs = foldl (+) 0
{-
   ghci> sum' [3,5,2,1]
   11
-}

-- Custom `elem` function using `foldl`
elem' :: (Eq a) => a -> [a] -> Bool
elem' y ys = foldl (\acc x -> if x == y then True else acc) False ys


{-
   The right fold, `foldr` works in a similar way to the left fold, only the accumulator eats up the values from the right. 
   Also, the left fold's binary function has the accumulator as the first parameter and the current value as the second one 
   (so `\acc x -> ...`), the right fold's binary function has the current value as the first parameter and the accumulator as 
   the second one (so `\x acc -> ...`). It kind of makes sense that the right fold has the accumulator on the right, 
   because it folds from the right side.

   The accumulator value (and hence, the result) of a fold can be of any type. It can be a number, a boolean or even a new list. 
   We'll be implementing the `map` function with a right fold. The accumulator will be a list, we'll be accumulating 
   the mapped list element by element. From that, it's obvious that the starting element will be an empty list.
-}

map' :: (a -> b) -> [a] -> [b]
map' f xs = foldr (\x acc -> f x : acc) [] xs

{-
   We could have implemented this function with a left fold too. It would be `map' f xs = foldl (\acc x -> acc ++ [f x]) [] xs`, 
   but the thing is that the `++` function is much more expensive than `:`, so we usually use right folds when we're building up new lists from a list.

   One big difference: right folds work on infinite lists, whereas left ones don't! To put it plainly, if you take an infinite list at some point and you fold it up from the right, you'll eventually reach the beginning of the list. However, if you take an infinite list at a point and you try to fold it up from the left, you'll never reach an end!

   Folds can be used to implement any function where you traverse a list once, element by element, and then return something 
   based on that. Whenever you want to traverse a list to return something, chances are you want a fold.
-}


{-
   The `foldl1` and `foldr1` functions work much like `foldl` and `foldr`, only you don't need to provide them with an explicit starting value. 
   They assume the first (or last) element of the list to be the starting value and then start the fold with the element next to it. 
   With that in mind, the sum function can be implemented like so: `sum = foldl1 (+)`.  Because they depend on the lists they fold up 
   having at least one element, they cause runtime errors if called with empty lists. `foldl` and `foldr`, on the other hand, work fine with empty lists. When making a fold, think about how it acts on an empty list. If the function doesn't make sense when given an empty list, you can probably use a `foldl1` or `foldr1` to implement it.
-}

maximum' :: (Ord a) => [a] -> a
maximum' = foldr1 (\x acc -> if x > acc then x else acc)

reverse' :: [a] -> [a]
reverse' = foldl (\acc x -> x : acc) []

product' :: (Num a) => [a] -> a
product' = foldr1 (*)

filter' :: (a -> Bool) -> [a] -> [a]
filter' p = foldr (\x acc -> if p x then x : acc else acc) []

head' :: [a] -> a
head' = foldr1 (\x _ -> x)

last' :: [a] -> a
last' = foldl1 (\_ x -> x)


{-
   `scanl` and `scanr` are like `foldl` and `foldr`, only they report all the intermediate accumulator states in the form of a list. 
   There are also `scanl1` and `scanr1`, which are analogous to `foldl1` and `foldr1`.

   Ex:
      ghci> scanl (+) 0 [3,5,2,1]  
      [0,3,8,10,11]  
      ghci> scanr (+) 0 [3,5,2,1]  
      [11,8,3,1,0]  
      ghci> scanl1 (\acc x -> if x > acc then x else acc) [3,4,5,3,7,9,2,1]  
      [3,4,5,5,7,9,9,9]  
      ghci> scanl (flip (:)) [] [3,2,1]  
      [[],[3],[2,3],[1,2,3]]

   When using a `scanl`, the final result will be in the last element of the resulting list while a `scanr` will place the result in the head.
-}

{-
   Scans are used to monitor the progression of a function that can be implemented as a fold. Let's answer us this question: 
   
      How many elements does it take for the sum of the roots of all natural numbers to exceed 1000? 
   
   To get the squares of all natural numbers, we just do `map sqrt [1..]`. Now, to get the sum, we could do a fold, but because we're interested 
   in how the sum progresses, we're going to do a scan. Once we've done the scan, we just see how many sums are under 1000. The first sum 
   in the scanlist will be 1, normally. The second will be 1 plus the square root of 2. The third will be that plus the square root of 3. 
   If there are X sums under 1000, then it takes X+1 elements for the sum to exceed 1000.
-}

sqrtSums :: Int
sqrtSums = length (takeWhile (<1000) (scanl1 (+) (map sqrt [1..]))) + 1
{-
   ghci> sqrtSums 
   131
-}


--- FUNCTION APPLICATION WITH `$` ---
{-
   Alright, next up, we'll take a look at the `$` function, also called 'function application'. First of all, let's check out how it's defined:

      ($) :: (a -> b) -> a -> b  
      f $ x = f x 

   Whereas normal function application (putting a space between two things) has a really high precedence, the `$` function has the lowest precedence. 
   Function application with a space is left-associative (so `f a b c` is the same as `((f a) b) c))`, function application with `$` is right-associative.

   Consider the expression `sum (map sqrt [1..130])`. Because `$` has such a low precedence, we can rewrite that expression as 
   `sum $ map sqrt [1..130]`. When a `$` is encountered, the expression on its right is applied as the parameter to the function on its left.

   How about `sum (filter (> 10) (map (*2) [2..10]))`? Well, because $ is right-associative, `f (g (z x))` is equal to `f $ g $ z x`. We can 
   rewrite `sum (filter (> 10) (map (*2) [2..10]))` as `sum $ filter (> 10) $ map (*2) [2..10]`.

   Since it's a regular function, you can also map it over a list of other functions:
      ghci> map ($ 3) [(4+), (10*), (^2), sqrt]  
      [7.0,30.0,9.0,1.7320508075688772] 
-}


--- FUNCTION COMPOSITION ---
{-
   In mathematics, function composition is defined like this: `(f o g)(x) = f(g(x))`, meaning that composing two functions produces 
   a new function that, when called with a parameter, say, x is the equivalent of calling `g` with the parameter `x` and then calling the `f` with that result.

   In Haskell, function composition is pretty much the same thing. We do function composition with the `.` function, which is defined like so:
      (.) :: (b -> c) -> (a -> b) -> a -> c  
      f . g = \x -> f (g x)

   Mind the type declaration. `f` must take as its parameter a value that has the same type as `g`'s return value. So the resulting function takes 
   a parameter of the same type that `g` takes and returns a value of the same type that `f` returns. The expression `negate . (* 3)` returns 
   a function that takes a number, multiplies it by 3 and then negates it.

   One of the uses for function composition is making functions on the fly to pass to other functions. Sure, lambdas can be used for that, 
   but many times, function composition is clearer and more concise. Say we have a list of numbers and we want to turn them all into negative numbers. 
   One way to do that would be to get each number's absolute value and then negate it, like so:

      ghci> map (\x -> negate (abs x)) [5,-3,-6,7,-3,2,-19,24]  
      [-5,-3,-6,-7,-3,-2,-19,-24]

   Using function composition, we can rewrite that as:

      ghci> map (negate . abs) [5,-3,-6,7,-3,2,-19,24]  
      [-5,-3,-6,-7,-3,-2,-19,-24]

   But what about functions that take several parameters? Well, if we want to use them in function composition, we usually have to 
   partially apply them just so much that each function takes just one parameter. `sum (replicate 5 (max 6.7 8.9))` can be rewritten 
   as `(sum . replicate 5 . max 6.7) 8.9` or as `sum . replicate 5 . max 6.7 $ 8.9`. What goes on in here is this: a function that 
   takes what `max 6.7` takes and applies `replicate 5` to it is created. Then, a function that takes the result of that and 
   does a sum of it is created. Finally, that function is called with 8.9. But normally, you just read that as: apply 8.9 to `max 6.7`, 
   then apply `replicate 5` to that and then apply `sum` to that. If you want to rewrite an expression with a lot of parentheses 
   by using function composition, you can start by putting the last parameter of the innermost function after a `$` and then just 
   composing all the other function calls, writing them without their last parameter and putting dots between them. 
   If you have `replicate 100 (product (map (*3) (zipWith max [1,2,3,4,5] [4,5,6,7,8])))`, you can write it as 
   `replicate 100 . product . map (*3) . zipWith max [1,2,3,4,5] $ [4,5,6,7,8]`. If the expression ends with three parentheses, 
   chances are that if you translate it into function composition, it'll have three composition operators.
-}

-- `oddSquareSum` from earlier, but with composition
oddSquareSum' :: Integer  
oddSquareSum' = sum . takeWhile (<10000) . filter odd . map (^2) $ [1..]

-- OR for easier understanding
oddSquareSum'' :: Integer  
oddSquareSum'' = 
   let oddSquares = filter odd $ map (^2) [1..]
       belowLimit = takeWhile (<10000) oddSquares
   in sum belowLimit
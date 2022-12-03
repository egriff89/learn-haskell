--- PATTERN MATCHING ---

{- 
   Pattern matching consists of specifying patterns to which some data should conform 
   and then checking to see if it does and deconstructing the data according to those patterns. 
   
   When defining functions, you can define separate function bodies for different patterns. This leads 
   to really neat code that's simple and readable. You can pattern match on any data type.
-}

-- Patterns checked top to bottom, the first that matches is executed
lucky :: (Integral a) => a -> String
lucky 7 = "LUCKY NUMBER SEVEN!"
lucky x = "Sorry, you're out of luck, pal!"

sayMe :: (Integral a) => a -> String
sayMe 1 = "One!"
sayMe 2 = "Two!"
sayMe 3 = "Three!"
sayMe 4 = "Four!"
sayMe 5 = "Five!"
sayMe x = "Not between 1 and 5"

-- Same function from last chapter, but defined recursively w/ pattern matching
factorial :: (Integral a) => a -> a
factorial 0 = 1
factorial n = n * factorial(n - 1)

-- Example of failed pattern matching (no catch-all expression at the end)
charName :: Char -> String
charName 'a' = "Albert"
charName 'b' = "Broseph"
charName 'c' = "Cecil"
{-
   ghci> charName 'h'
   "*** Exception: syntax.hs:(31,1)-(33,22): Non-exhaustive patterns in function charName
   ghci>
-}

-- Tuple addition w/o pattern matching
-- addVectors :: (Num a) => (a, a) -> (a, a) -> (a, a)
-- addVectors a b = (fst a + fst b, snd a + snd b)

-- With pattern matching
addVectors :: (Num a) => (a, a) -> (a, a) -> (a, a)
addVectors (x1, y1) (x2, y2) = (x1 + x2, y1 + y2)

-- Extract components of triples (fst and snd extract pairs)
first :: (a, b, c) -> a
first (x, _, _) = x

second :: (a, b, c) -> b
second (_, y, _) = y

third :: (a, b, c) -> c
third (_, _, z) = z

-- Matching in list comprehensions
xs = [(1,3), (4,3), (2,4), (5,3), (5,6), (3,1)]
matchRes = [a+b | (a,b) <- xs] -- [4,7,6,8,11,4]

-- List pattern matching - custom head function
head' :: [a] -> a
head' []    = error "Can't call head on an empty list, dummy!"
head' (x:_) = x
{-
   ghci> head' [4,5,6]
   4     
   ghci> head' []
   *** Exception: Can't call head on an empty list, dummy!
-}

-- Let's make a trivial function that tells us some of the first elements of the list in (in)convenient English form.
tell :: (Show a) => [a] -> String
tell []       = "The list is empty"
tell (x:[])   = "The list has one element: " ++ show x
tell (x:y:[]) = "The list has two elements: " ++ show x ++ " and " ++ show y
tell (x:y:_)  = "This list is long. The first two elements are: " ++ show x ++ " and " ++ show y

-- Custom length function w/ pattern matching and recursion
length' :: (Num b) => [a] -> b
length' []     = 0
length' (_:xs) = 1 + length' xs

-- Custom sum
sum' :: (Num a) => [a] -> a
sum' []     = 0
sum' (x:xs) = x + sum' xs


{-
   There's also a thing called "as patterns". Those are a handy way of breaking something up according to a pattern
    and binding it to names whilst still keeping a reference to the whole thing. You do that by putting a name 
    and an @ in front of a pattern. For instance, the pattern xs@(x:y:ys). This pattern will match exactly the same 
    thing as x:y:ys but you can easily get the whole list via xs instead of repeating yourself by typing out x:y:ys 
    in the function body again. Here's a quick and dirty example:
-}
capital :: String -> String
capital ""         = "Empty string, whoops!"
capital all@(x:xs) = "The first letter of " ++ all ++ " is " ++ [x]
{-
   ghci> capital "Dracula"
   "The first letter of Dracula is D"
   ghci>
-}


--- GUARDS ---

{-
   Guards are indicated by pipes that follow a function's name and its parameters. Usually, 
   they're indented a bit to the right and lined up. Basically a boolean expression. 
   If it evaluates to True, then the corresponding function body is used. 
   If it evaluates to False, checking drops through to the next guard and so on.
-}

-- Example: Function that berates you depending on your BMI (body mass index)
bmiTell :: (RealFloat a) => a -> a -> String
bmiTell weight height
   | weight / height ^ 2 <= 18.5 = "You're underweight, you emo, you!"
   | weight / height ^ 2 <= 25.0 = "You're supposedly normal. Pffft, I bet you're ugly!"
   | weight / height ^ 2 <= 30.0 = "You're fat! Lose some weight, fatty!"
   | otherwise   = "You're a whale, congratulations!"
{-
   ghci> bmiTell 85 1.90
   "You're supposedly normal. Pffft, I bet you're ugly!"
   ghci>
-}

-- Custom max function using guards
max' :: (Ord a) => a -> a -> a
max' a b
   | a > b     = a
   | otherwise = b
-- Can also be written inline: max' a b | a > b = a | otherwise = b
-- Hard to read, don't do it!

-- Custom comnpare using guards
myCompare :: (Ord a) => a -> a -> Ordering
a `myCompare` b
   | a > b     = GT
   | a == b    = EQ
   | otherwise = LT
{-
   ghci> 3 `myCompare` 2
   GT    
   ghci>
-}


--- WHERE ---

{-
   Allows you to bind values to names visible across the guards to avoid code repetition. We put the keyword 
   "where" after the guards (usually it's best to indent it as much as the pipes are indented) and then we 
   define several names or functions.
-}

-- Updated bmiTell function using "where"
bmiTell' :: (RealFloat a) => a -> a -> String
bmiTell' weight height
   | bmi <= skinny = "You're underweight, you emo, you!"
   | bmi <= normal = "You're supposedly normal. Pffft, I bet you're ugly!"
   | bmi <= fat    = "You're fat! Lose some weight, fatty!"
   | otherwise     = "You're a whale, congratulations!"
   where bmi = weight / height ^ 2
         (skinny, normal, fat) = (18.5, 25.0, 30.0)


-- Get someone's initials
initials :: String -> String -> String
initials firstname lastname = [f] ++ ". " ++ [l] ++ "."
   where (f:_) = firstname
         (l:_) = lastname


-- Take weight-height pairs and return a list of BMIs
calcBmis :: (RealFloat a) => [(a, a)] -> [a]
calcBmis xs = [bmi w h | (w, h) <- xs]
   where bmi weight height = weight / height ^ 2


--- LET BINDINGS ---

{-
   Very similar to where bindings are let bindings. Where bindings are a syntactic construct that let you 
   bind to variables at the end of a function and the whole function can see them, including all the guards. 
   Let bindings let you bind to variables anywhere and are expressions themselves, but are very local, so they don't span across guards.
-}

-- Get a cylinder's surface area based on its height and radius
cylinder :: (RealFloat a) => a -> a -> a
cylinder r h =
   let sideArea = 2 * pi * r * h
       topArea  = pi * r^2
   in sideArea + 2 * topArea

{-
   Unlike "where" binding, "let" bindings are expressions themselves and can be used
   practically everywhere. The same with "if" statements.
      ghci> 4 * (let a = 9 in a + 1) + 2  
      42

   They can also introduce functions in local scope:
      ghci> [let square x = x * x in (square 5, square 3, square 2)]  
      [(25,9,4)]

   Binding several variables inline is possible, you just need to use semicolons:
      ghci> (let a = 100; b = 200; c = 300 in a*b*c, let foo="Hey "; bar = "there!" in foo ++ bar)  
      (6000000,"Hey there!")  
-}

-- calcBmis, but using `let` in a list comprehension
calcBmis' :: (RealFloat a) => [(a, a)] -> [a]
calcBmis' xs = [bmi | (w, h) <- xs, let bmi = w / h ^ 2]


--- CASE EXPRESSIONS ---

{-
   Pattern matching is syntactic sugar for case expressions and are interchangeable

   Syntax:
      case expression of pattern -> result  
                         pattern -> result  
                         pattern -> result  
                         ...
-}


head'' :: [a] -> a
head'' xs = 
   case xs of []    -> error "No head for empty lists!"
              (x:_) -> x

{-
   Same exact thing as:

   head' :: [a] -> a
   head' []    = error "Can't call head on an empty list, dummy!"
   head' (x:_) = x
-}

-- Valid
describeList :: [a] -> String
describeList xs = "The list is " ++ case xs of []  -> "empty."
                                               [x] -> "a singleton list."
                                               xs  -> "a longer list."

-- Also this
describeList' :: [a] -> String
describeList' xs = "The list is " ++ what xs
   where what []  = "empty."
         what [x] = "a singleton list."
         what xs  = "a longer list."
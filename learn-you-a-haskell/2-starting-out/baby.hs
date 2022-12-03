--- FUNCTIONS ---

-- Multiplies a number by two
doubleMe x = x + x

-- Takes two numbers, multiples them by two, then adds them
doubleUs x y = x * 2 + y * 2

-- Same as above, but using doubleMe instead
doubleUs' x y = doubleMe x + doubleMe y

-- Double number smaller than 100
doubleSmallNumber x =
  if x > 100
    then x
    else x * 2

-- Same as previous, but adds 1 to result
doubleSmallNumber' x = (if x > 100 then x else x * 2) + 1

--- LISTS ---
lostNumbers = [4, 8, 15, 16, 23, 42]

-- List concatenation, ++
hello = "hello" ++ " " ++ "world" -- "hello world"
woot = ['w', 'o'] ++ ['o', 't'] -- "woot"

-- Add to the beginning of a list, : (cons operator)
cat = 'A':" SMALL CAT" -- "A SMALL CAT"
consNums = 5:[1,2,3,4,5] -- [5,1,2,3,4,5]

-- Get element out of list, !! (index starts at 0)
steve = "Steve Buscemi" !! 6 -- 'B'
moreNums = [9.4,33.2,96.2,11.2,23.25] !! 1 -- 33.2

-- Nested lists
b    = [[1,2,3,4],[5,3,3,3],[1,2,2,3,4],[1,2,3]]
b'   = b ++ [[1,1,1,1]] -- [[1,2,3,4],[5,3,3,3],[1,2,2,3,4],[1,2,3],[1,1,1,1]]
b''  = [6,6,6]:b -- [[6,6,6],[1,2,3,4],[5,3,3,3],[1,2,2,3,4],[1,2,3]]
b''' = b !! 2 -- [1,2,2,3,4]

-- Other list functions
h = head [5,4,3,2,1] -- 5
t = tail [5,4,3,2,1] -- [4,3,2,1]
l = last [5,4,3,2,1] -- 1
i = init [5,4,3,2,1] -- [5,4,3,2]

empty   = head [] -- Exception: Prelude.head: empty list
len     = length [5,4,3,2,1] -- 5
isNull  = null [1,2,3] -- False
isNull' = null [] -- True
rev = reverse [5,4,3,2,1] -- [1,2,3,4,5]
min = minimum [8,4,2,1,5,6] -- 1
max = maximum [1,9,2,3,4] -- 9

-- Some basic math functions (sum, product)
sum' = sum [5,2,1,6,3,2,5,7] -- 31
prod  = product [6,2,1,2] -- 24
prod' = product [1,2,5,6,7,9,2,0] -- 0

-- Returns list of specified elements from beginning of list
tk    = take 3 [5,4,3,2,1] -- [5,4,3]
tk'   = take 1 [3,9,3] -- [3]
tk''  = take 5 [1,2] -- [1,2]
tk''' = take 0 [6,6,6] -- []

-- Drops elements from beginning of list, returns list of remaining elements
d    = drop 3 [8,4,2,1,5,6] -- [1,5,6]
d''  = drop 0 [1,2,3,4] -- [1,2,3,4]
d''' = drop 100 [6,6,6] -- []

-- Check if something is part of a list
inList  = 4 `elem` [3,4,5,6] -- True (infix notation, most common as it's easier to read)
inList' = elem 10 [3,4,5,6] -- False (prefix notation)

--- RANGES ---
first20Natural = [1..20] -- [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
lowerAtoZ = ['a'..'z'] -- "abcdefghijklmnopqrstuvwxyz"
upperKtoZ = ['K'..'Z'] -- "KLMNOPQRSTUVWXYZ"

-- You can also specify steps
first20NaturalEven = [2,4..20] -- [2,4,6,8,10,12,14,16,18,20]
first20NaturalOdd  = [1,3..20] -- [1,3,5,7,9,11,13,15,17,19]
everyThird = [3,6..20] -- [3,6,9,12,15,18]
first20NaturalReverse = [20,19..1] -- [20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1]

-- FYI: don't use floating points in ranges, gets pretty funky
funky = [0.1,0.3..1] -- [0.1,0.3,0.5,0.7,0.8999999999999999,1.0999999999999999]

-- First 24 elements from an infinite list, multiples of 13
first24 = take 24 [13,26..] -- [13,26,39,52,65,78,91,104,117,130,143,156,169,182,195,208,221,234,247,260,273,286,299,312]

-- cycle: produce an infinite list from a finite list
infTake10 = take 10 (cycle [1,2,3]) -- [1,2,3,1,2,3,1,2,3,1]
inf12LOL  = take 12 (cycle "LOL ") -- "LOL LOL LOL "

-- repeat: cycle, but for a single element
repeat5 = take 10 (repeat 5) -- [5,5,5,5,5,5,5,5,5,5]

-- replicate: simpler top use than repeat for single elements
repl10 = replicate 3 10 -- [10,10,10]

--- LIST COMPREHENSIONS ---
-- Returns all numbers from 1 to 10 doubled
doubledRange = [x*2 | x <- [1..10]] -- [2,4,6,8,10,12,14,16,18,20]
-- Returns only elements greater than or equal to 12 after doubling
doubledRange12orGreater = [x*2 | x <- [1..10], x*2 >= 12] -- [12,14,16,18,20]
-- All numbers from 50-100 whose remainder is 3 after dividing by 7
rem3AfterDiv7 = [x | x <- [50..100], x `mod` 7 == 3] -- [52,59,66,73,80,87,94]

-- Replace odd numbers > 10 with "BANG!", less than 10 with "BOOM!". Throw out even numbers
boomBangs xs = [if x < 10 then "BOOM!" else "BANG!" | x <- xs, odd x]

-- Multiple predicates are allowed, and the element must satisfy all of them to be included in the resulting list
not13or15or19 = [x | x <- [10..20], x /= 13, x /= 15, x /= 19] -- [10,11,12,14,16,17,18,20]

-- Get products of all possible combinations of two lists
productsOf2Lists = [x*y | x <- [2,5,10], y <- [8,10,11]] -- [16,20,22,40,50,55,80,100,110]
-- All products > 50
productsOf2Lists' = [x*y | x <- [2,5,10], y <- [8,10,11], x*y > 50] -- [55,80,100,110]

-- Combine a list of adjectives and nouns...for epic hilarity
nouns = ["hobo","frog", "pope"]
adjectives = ["lazy","grouchy","scheming"]
hilarity = [adjective ++ " " ++ noun | adjective <- adjectives, noun <- nouns] -- ["lazy hobo","lazy frog","lazy pope","grouchy hobo","grouchy frog","grouchy pope","scheming hobo","scheming frog","scheming pope"]

-- Custom length
length' xs = sum [1 | _ <- xs]
{- 
  ghci> length' "hello, world"
  12    
  ghci>
-}

removeNonUppercase st = [c | c <- st, c `elem` ['A'..'Z']]
{- 
  ghci> removeNonUppercase "Hahaha! Ahahaha!"
  "HA"  
  ghci> removeNonUppercase "IdontLIKEFROGS"  
  "ILIKEFROGS"
  ghci>
-} 

-- Nested comprehension. Removing all odd numbers without flattening
xxs   = [[1,3,5,2,3,1,2,4,5],[1,2,3,4,5,6,7,8,9],[1,2,4,2,1,6,3,1,3,2,3,6]] 
noOdd = [[x | x <- xs, even x] | xs <- xxs] -- [[2,2,4],[2,4,6,8],[2,4,2,6,2,6]]

--- TUPLES ---
-- fst: takes a pair and returns the first component
f  = fst (8,11) -- 8
f' = fst ("Wow", False) -- "Wow"

-- snd: takes a pair and returns the second component
s  = snd (8,11) -- 11
s' = snd ("Wow", False) -- False

-- zip: takes two lists and returns a list of pairs
zipped = zip [1,2,3,4,5] [5,5,5,5,5] -- [(1,5),(2,5),(3,5),(4,5),(5,5)]
zippedAgain = zip [1..5] ["one", "two", "three", "four", "five"] -- [(1,"one"),(2,"two"),(3,"three"),(4,"four"),(5,"five")]

-- The longer list gets cut off to match the length of the shorter one
zipUnequal = zip [5,3,2,6,2,7,2,5,4,6,6] ["im","a","turtle"] -- [(5,"im"),(3,"a"),(2,"turtle")]

-- Zipping infinite and finite lists works like normal. (Haskell is lazy and only grabs what it needs to match the list lengths)
zipToInfinite = zip [1..] ["apple", "orange", "cherry", "mango"] -- [(1,"apple"),(2,"orange"),(3,"cherry"),(4,"mango")]


----- Which right triangle that has integers for all sides and all sides equal to or smaller than 10 has a perimeter of 24? -----
-- Generate all triangles with sides equal to or smaller than 10
triangles = [(a,b,c) | c <- [1..10], b <- [1..10], a <- [1..10]] -- a lot. check in GHCI
-- Generate all right triangles, B < C and A < B
rightTriangles  = [(a,b,c) | c <- [1..10], b <- [1..c], a <- [1..b], a^2 + b^2 == c^2] -- [(3,4,5),(6,8,10)]
-- Right triangles where the perimeter is 24 (a+b+c)
rightTriangles' = [(a,b,c) | c <- [1..10], b <- [1..c], a <- [1..b], a^2 + b^2 == c^2, a+b+c == 24] -- [(6,8,10)]
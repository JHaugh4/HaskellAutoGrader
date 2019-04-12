module Main where

import Test.Hspec
import Data.List

-- --5.1 Trees
-- data Tree a = E
--             | T a (Tree a) (Tree a)
--             deriving (Eq, Show)

-- ex :: Tree Char
-- ex = T 'a' (T 'b' E (T 'c' E E)) (T 'd' E E)

-- bfnum :: Tree a -> Tree Int
-- bfnum t = let (ms, r) = thread (1 : ms) t
--            in r
--   where
--     thread ms E = (ms, E)
--     thread (m : ms) (T x lt rt) =
--       let (ms1, lt') = thread ms lt
--           (ms2, rt') = thread ms1 rt
--       in ((m + 1) : ms2, T m lt' rt')

-- --5.2 Expression Trees
-- type Identifier = String

-- data Expr = Num Integer
--           | Var Identifier
--           | Let {var :: Identifier, value :: Expr, body :: Expr}
--           | Add Expr Expr
--           | Sub Expr Expr
--           | Mul Expr Expr
--           | Div Expr Expr
--           deriving (Eq)

-- instance Show Expr where
--   show (Num x) = show x
--   show (Var x) = x
--   show (Let var val body) = "let " ++ var ++ " = " ++ show val 
--                         ++ " in " ++ show body ++ " end"
--   show (Add expr1 expr2) = show expr1 ++ " + " ++ show expr2 
--   show (Sub expr1 expr2) = show expr1 ++ " - " ++ show expr2 
--   show (Mul expr1 expr2) = show expr1 ++ " * " ++ show expr2 
--   show (Div expr1 expr2) = show expr1 ++ " / " ++ show expr2 

-- type Env = Identifier -> Integer

-- emptyEnv :: Env
-- emptyEnv = \s -> error ("unbound: " ++ s)

-- extendEnv :: Env -> Identifier -> Integer -> Env
-- extendEnv oldEnv s n = \s' -> if s' == s then n else oldEnv s'

-- evalInEnv :: Env -> Expr -> Integer
-- evalInEnv env (Num x) = x
-- evalInEnv env (Var x) = env x
-- evalInEnv env (Let var val body) = 
--   let val' = evalInEnv env val
--       env' = extendEnv env var val'
--   in evalInEnv env' body
-- evalInEnv env (Add x y) = evalInEnv env x + evalInEnv env y
-- evalInEnv env (Sub x y) = evalInEnv env x - evalInEnv env y
-- evalInEnv env (Mul x y) = evalInEnv env x * evalInEnv env y
-- evalInEnv env (Div x y) = evalInEnv env x `div` evalInEnv env y

-- --5.3 Infinite Lists
-- diag :: [[a]] -> [a]
-- diag xss = concatMap (takeDrop xss) [0..]

-- takeDrop :: [[a]] -> Int -> [a]
-- takeDrop xss n = 
--   let xss' = zip (take (n+1) xss) [0..]
--       ans  = foldr (\(x,n') ys -> (take 1 . drop (n-n') $ x) ++ ys)               [] xss'
--   in ans

-- --

-- rlist = [[ i/j | i <- [1..]] | j <- [1..]]
-- qlist1 = [[ show i ++ "/" ++ show j | i <- [1..]] | j <- [1..]]
-- qlist2 = [[ fracString i j | i <- [1..]] | j <- [1..]]

-- fracString num den = if denominator == 1
--                      then show numerator
--                      else show numerator ++ "/" ++ show denominator
--   where c = gcd num den
--         numerator = num `div` c
--         denominator = den `div` c

-- block n x = map (take n) (take n x)

main :: IO ()
main = do
  hspec spec

{-
I had to define copies of these functions since it was not guranteed that students would have them defined in their files and they are needed for some of the tests. To avoid having to do this assign the students a rigid template file that must only be filled in with code and nothing can be removed.
-}

myEval :: Expr -> Integer
myEval e = evalInEnv myEmptyEnv e

myEmptyEnv :: String -> Integer
myEmptyEnv = \s -> error ("unbound: " ++ s)

myRList = [[ i/j | i <- [1..]] | j <- [1..]]
myQlist1 = [[ show i ++ "/" ++ show j | i <- [1..]] | j <- [1..]]
myQList2 = [[ myFracString i j | i <- [1..]] | j <- [1..]]

myFracString num den = if denominator == 1
                       then show numerator
                       else show numerator ++ "/" ++ show denominator
  where c = gcd num den
        numerator = num `div` c
        denominator = den `div` c

{-
The unit tests must be defined in this in order for the output file interpreter to work. Namely use one describe per problem and then use it for each unit tests in the block.
-}

spec :: Spec
spec = do
  describe "5.1" $ do
    it "bfnum T 'a' (T 'b' E (T 'c' E E)) (T 'd' E E)" $ do
      (bfnum $ T 'a' (T 'b' E (T 'c' E E)) (T 'd' E E)) `shouldBe` (T 1 (T 2 E (T 4 E E)) (T 3 E E))
    it "bfnum T 1 E (T 2 E (T 3 E (T 4 E E)))" $ do
      (bfnum $ T 1 E (T 2 E (T 3 E (T 4 E E)))) `shouldBe` (T 1 E (T 2 E (T 3 E (T 4 E E))))
    it "bfnum T [] (T [] (T [] (T [] (T [] (T [] E E) (T [] E E)) E) (T [] E E)) E) (T [] E E)" $ do
      (bfnum $ T [] (T [] (T [] (T [] (T [] (T [] E E) (T [] E E)) E) (T [] E E)) E) (T [] E E)) `shouldBe` (T 1 (T 2 (T 4 (T 5 (T 7 (T 8 E E) (T 9 E E)) E) (T 6 E E)) E) (T 3 E E))

  describe "5.2" $ do
    it "show test" $ do
      (show $ Let "x" (Num 5) (Add (Var "x") (Num 5))) `shouldNotBe` []
    it "eval Let \"x\" (Num 5) (Add (Var \"x\") (Num 5))" $ do
      (myEval $ Let "x" (Num 5) (Add (Var "x") (Num 5))) `shouldBe` 10
    it "eval Add (Let \"x\" (Sub (Num 10) (Num 3) (Let \"y\" (Mul (Var \"x\" (Num 2)) (Div (Var \"y\") (Var \"x\"))))" $ do
      (myEval $ Add (Let "x" (Sub (Num 10) (Num 3)) (Let "y" (Mul (Var "x") (Num 2)) (Div (Var "y") (Var "x")))) (Num 11))`shouldBe` 13

  describe "5.3" $ do
    it "take 30 $ diag qlist2" $ do
      (take 30 $ diag myQList2) `shouldBe` (["1","2","1/2","3","1","1/3","4","3/2","2/3","1/4","5","2","1","1/2","1/5","6","5/2","4/3","3/4","2/5","1/6","7","3","5/3","1","3/5","1/3","1/7","8","7/2"])
    it "take 15 $ diag rlist" $ do
      (take 15 $ diag myRList) `shouldBe` ([1.0,2.0,0.5,3.0,1.0,0.3333333333333333,4.0,1.5,0.6666666666666666,0.25,5.0,2.0,1.0,0.5,0.2])
    it "take 25 $ diag qlist1" $ do
      (take 25 $ diag myQlist1) `shouldBe` (["1/1","2/1","1/2","3/1","2/2","1/3","4/1","3/2","2/3","1/4","5/1","4/2","3/3","2/4","1/5","6/1","5/2","4/3","3/4","2/5","1/6","7/1","6/2","5/3","4/4"])
  
--These are the delimeters I use to insert students code.

--i<@@>i

--j<@@>j

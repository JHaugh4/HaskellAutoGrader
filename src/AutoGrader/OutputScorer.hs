{-# LANGUAGE BangPatterns, OverloadedStrings #-}

module OutputScorer where

import Data.List
import ConfigParser
import qualified Data.Map.Strict as M
import Data.Foldable
import Data.Monoid

type FileContents = String

data Score = Score Int Int deriving (Eq)

instance Show Score where
  show (Score a b) = show a ++ " / " ++ show b

instance Monoid Score where
  mempty = Score 0 0
  mappend (Score a b) (Score c d) = Score (a+c) (b+d)

scoreOutputFile :: [FileContents] -> [TestConfig] -> Score
scoreOutputFile _ [] = mempty
scoreOutputFile fileLines ((TestConfig _ nTest ptsTest spc):ts) =
  (fold $ zipWith passed labeledTests scores) <> scoreOutputFile rest ts
  where
    (curTest',rest) = splitAt (nTest+1) fileLines
    curTest = drop 1 curTest'
    scores = fillScoreList spc nTest ptsTest
    labeledTests = fmap ((/= "FAILED") . head . drop 1 . reverse . words) curTest
    passed b n = if b then Score n n else Score 0 n

fillScoreList :: M.Map String Int -> Int -> Int -> [Int]
fillScoreList mp nTest ptsTest = check <$> [1..nTest]
  where
    check m = case (M.!?) mp (show m) of
                Nothing -> ptsTest
                Just x  -> x
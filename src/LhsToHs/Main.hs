module Main where

import Data.List
import System.Environment

{-
Very simple lhsToHs converter that only takes it account begin and end{code} tags. It takes everything in between those tags and returns those.
-}

convertLines :: [String] -> [String]
convertLines [] = []
convertLines (line:moreLines)
  | isBegin line = 
    let 
      (taken, rest) = span (not . isEnd) moreLines
    in taken ++ convertLines rest
  | otherwise    = convertLines moreLines
  where
    lineVal = takeWhile (\c -> c /= '\n' && c /= ' ')
    isBegin l = (lineVal l) == "\\begin{code}"
    isEnd l   = (lineVal l) == "\\end{code}"

main :: IO ()
main = do
  file <- readFile . head =<< getArgs
  putStrLn . unlines . convertLines . lines $ file
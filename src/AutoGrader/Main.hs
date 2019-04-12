{-# LANGUAGE BangPatterns, OverloadedStrings #-}

module Main where

import System.Environment (getArgs)
import ConfigParser
import OutputScorer
import Data.Aeson
import Data.List
import System.IO.Strict as I

-- :set args ./ParserFiles/SampleConfig.json ./ParserFiles/HSpecOutput.txt

main :: IO ()
main = do
  [json, filepath] <- getArgs
  decoded <- eitherDecode <$> (getJSON json)
  file <- I.readFile filepath
  case decoded of
    Left err -> putStrLn err
    Right cs -> print $ scoreOutputFile (lines file) cs
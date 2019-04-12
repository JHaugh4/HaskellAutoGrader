{-# LANGUAGE BangPatterns, OverloadedStrings, DeriveGeneric #-}

module ConfigParser where

import Data.Aeson
import qualified Data.Map.Strict as M
import Control.Monad (mzero)
import GHC.Generics (Generic)
import qualified Data.ByteString.Lazy as B

data TestConfig =
  TestConfig { testName :: !String
             , numTests :: Int
             , ptsPerTest :: Int
             , specialCases :: M.Map String Int
             } deriving (Eq, Show, Generic)

instance FromJSON TestConfig
instance ToJSON TestConfig

getJSON :: String -> IO B.ByteString
getJSON jsonFile = B.readFile jsonFile
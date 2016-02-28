{-# LANGUAGE OverloadedStrings #-}

import Control.Monad
import Data.Conduit.Combinators
import Network.HTTP.Conduit
import System.Environment

a :: IO ()
a = do
  manager <- newManager tlsManagerSettings
  request <- parseUrl "http://httpbin.org/status/409"
  void $ httpLbs request manager

b :: IO ()
b = do
  manager <- newManager tlsManagerSettings
  request <- parseUrl "http://httpbin.org/status/409"
  void $ flip httpLbs manager request
    { requestBody = requestBodySourceChunked $ repeatM $ return "a"
    }

main :: IO ()
main = do
  args <- getArgs
  case args of
    ["a"] -> a
    _     -> b

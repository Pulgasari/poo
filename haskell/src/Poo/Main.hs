module Main where

import Poo.Parser (parseProgram)
import Data.Text (pack)
import System.Environment (getArgs)

main :: IO ()
main = do
  args <- getArgs
  case args of
    [file] -> do
      src <- readFile file
      case parseProgram (pack src) of
        Left err  -> putStrLn $ "Error:\n" ++ err
        Right ast -> print ast
    _ -> putStrLn "Usage: poo-parser <file.poo>"

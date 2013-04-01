module Main where

import qualified Text.Regex.PCRE.String as PCRE
import Data.Char (toLower)
import Data.List (intersperse)

transDict :: [(String,String)]
transDict =
    [("analysed"      ,"analyzed")
    ,("built-in"      ,"builtin")
    ,("chastized"     ,"chastised")
    ,("commandline"   ,"command-line")
    ,("de-allocate"   ,"deallocate")
    ,("dropin"        ,"drop-in")
    ,("hardcode"      ,"hard-code")
    ,("meta-data"     ,"metadata")
    ,("multicharacter","multi-character")
    ,("multiway"      ,"multi-way")
    ,("non-empty"     ,"nonempty")
    ,("non-profit"    ,"nonprofit")
    ,("non-trappable" ,"nontrappable")
    ,("pre-define"    ,"predefine")
    ,("preextend"     ,"pre-extend")
    ,("re-compiling"  ,"recompiling")
    ,("reenter"       ,"re-enter")
    ,("turnkey"       ,"turn-key")]

transWord :: String -> String
transWord word = case (lookup (map toLower word) transDict) of
                   Just trans -> trans
                   Nothing -> word

transDictRegex :: IO PCRE.Regex
transDictRegex = do
  compres <- PCRE.compile compopt execopt pattern
  case compres of
    Left (offset, string)
        -> error $
           "Regex pattern error" ++
           " at offset " ++ show offset ++
           " for string: " ++ string
    Right regex
        -> return regex
  where pattern = "(" ++ (concat $ intersperse "|" $ map fst transDict) ++ ")"
        compopt = PCRE.compCaseless + PCRE.compMultiline + PCRE.compUTF8
        execopt = PCRE.execBlank

matchRegex :: String -> IO (String, String, String)
matchRegex input = do
  regex <- transDictRegex
  execres <- PCRE.regexec regex input
  case execres of
    Left err -> error $ "regexec WrapError " ++ show err ++ "for: " ++ input
    Right Nothing -> return (input, [], [])
    Right (Just (head, word, tail, _)) -> return (head, word, tail)

translate :: String -> IO String
translate [] = do return []
translate input = do
  (head, word, tail) <- matchRegex input
  tailTrans <- (translate tail)
  return $ head ++ (transWord word) ++ tailTrans

main :: IO ()
main = do getContents >>= translate >>= putStr

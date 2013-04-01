module Main where

import Data.Char (toLower)
import Data.Fixed (divMod')
import Data.List (intersperse, isInfixOf, foldl')
import System.Environment (getArgs)

import qualified Codec.MIME.Parse       as MIME
import qualified Data.Time.Clock        as CLOCK
import qualified Data.Time.Format       as TIME
import qualified System.Locale          as LOCALE
import qualified Text.Regex.PCRE.String as PCRE

data ServerHeader = ServerHeader {
      receivedFrom :: String
    , receivedBy   :: String
    , receivedAt   :: CLOCK.UTCTime
    } deriving (Show)

serverHeaderRegex :: IO PCRE.Regex
serverHeaderRegex = do
  let pattern = "from (.*) by (.*) with (.*); (.*)"
  compres <- PCRE.compile PCRE.compBlank PCRE.execBlank pattern
  case compres of
    Left (offset, string)
        -> error $
           "Regex pattern error" ++
           " at offset " ++ show offset ++
           " for string: " ++ string
    Right regex
        -> return regex

parseTime :: String -> CLOCK.UTCTime
parseTime time = case parseres of
                   Just utctime -> utctime
                   Nothing -> error $ "Invalid data format: " ++ time
                 where parseres = TIME.parseTime
                                  LOCALE.defaultTimeLocale
                                  "%a, %e %b %Y %X %z (%Z)"
                                  time
                                  :: Maybe CLOCK.UTCTime

parseServerHeader :: String -> IO ServerHeader
parseServerHeader input = do
  let header = concat $ intersperse " " $ words input
      headerWithFrom  = if "from" `isInfixOf` header
                        then header
                        else "from - " ++ header
  regex <- serverHeaderRegex
  execres <- PCRE.regexec regex headerWithFrom
  case execres of
    Left err -> error $ "regexec WrapError " ++ show err ++ "for: " ++ input
    Right Nothing -> error $ "Invalid server header: " ++ headerWithFrom
    Right (Just (_, _, _, [from, by, _, time]))
        -> return $ ServerHeader from by (parseTime time)

parseServerHeaders :: String -> IO [ServerHeader]
parseServerHeaders contents = do
  mapM (parseServerHeader . snd) $ reverse $ filter match headers
  where match   = (== "received") . (map toLower) . fst
        headers = fst $ MIME.parseHeaders contents

prettifyTimeDiff :: (Real a) => a -> String
prettifyTimeDiff diff =
  concat $ intersperse " " $ map (\(n,t) -> show n ++ t)
         $ if null diffs then [(0,"s")] else diffs
  where merge (tot,acc) (sec,typ) = let (sec',tot') = divMod' tot sec
                                    in (tot',(sec',typ):acc)
        metrics = [(86400,"d"),(3600,"h"),(60,"m"),(1,"s")]
        diffs = filter ((/= 0) . fst) $ reverse $ snd $ foldl' merge (diff,[]) metrics

printServerHeaders :: String -> IO ()
printServerHeaders contents = do
  headers <- parseServerHeaders contents
  mapM_ printHeader (zip headers $ (head headers) : headers)
  where printHeader (c,p) = do
          putStrLn $ "after " ++ (prettifyTimeDiff $ CLOCK.diffUTCTime (receivedAt c) (receivedAt p))
          putStrLn $ " from " ++ (receivedFrom c)
          putStrLn $ "   by " ++ (receivedBy c)
          putStrLn $ "   at " ++ (show $ receivedAt c)

main :: IO ()
main = do
  args <- getArgs
  case args of
    []         -> getContents >>= printServerHeaders
    [pathname] -> readFile pathname >>= printServerHeaders
    _          -> error "Arguments: [<PATHNAME>]"

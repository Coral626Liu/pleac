module Main where

import Data.Char (isSpace)
import System.Time (ClockTime(..))
import System.Exit (ExitCode(..))
import System.Process (readProcessWithExitCode)
import Data.List (elemIndex, foldl', intercalate, words)
import qualified Data.Text as T

psFields :: [String]
psFields = ["flags","uid","pid","ppid","pri","nice","size","rss","wchan","stat",
            "tty","time","command"]


-- Accessors for ps output line fields -----------------------------------------

breakPSFields :: String -> [String]
breakPSFields line =
    breakFields line nInitCols
    where nInitCols        = (length psFields) - 1
          dropSpace        = dropWhile isSpace
          breakFields [] _ = []
          breakFields cs 0 = [T.unpack $ T.strip $ T.pack cs]
          breakFields cs n = let (h,t) = break isSpace $ dropSpace cs
                                 t'    = (breakFields t (n - 1))
                             in h:t'

type PSField = ([String], String)

getPSFields :: IO [PSField]
getPSFields = do
  (ecode, out, err) <- readProcessWithExitCode "ps" psargs []
  case ecode of
    ExitFailure eno -> error $ "ps failure: [" ++ show eno ++ "] " ++ err
    ExitSuccess -> return $ map (\l -> (breakPSFields l, l)) $ tail $ lines out
  where psargs = ["ax", "-o", intercalate "," psFields]

filterPSFields :: (PSField -> Bool) -> IO [PSField]
filterPSFields p = do getPSFields >>= (\fs -> return $ filter p fs)

printPSFields :: (PSField -> Bool) -> IO ()
printPSFields p = filterPSFields p >>= mapM_ (putStrLn . snd)


-- Query DSL -------------------------------------------------------------------

parseInt :: String -> Int
parseInt cs = read cs :: Int

parseClockTime :: String -> ClockTime
parseClockTime cs = TOD (toInteger secs) 0
                    where secs = foldl' (\a s -> (60 * a) + s) 0 $
                                 map (parseInt . T.unpack) $
                                 T.split (T.pack ":") (T.pack cs)

liftAcP :: String -> (String -> a) -> (a -> a -> Bool) -> a -> PSField -> Bool
liftAcP a p f v s = (p $ (fst s) !! i) `f` v
                    where i = case (a `elemIndex` psFields) of
                                Just n  -> n
                                Nothing -> error $ "Wrong ps field: " ++ a

flagsP   = liftAcP "flags"   parseInt
uidP     = liftAcP "uid"     parseInt
pidP     = liftAcP "pid"     parseInt
ppidP    = liftAcP "ppid"    parseInt
priP     = liftAcP "pri"     parseInt
niceP    = liftAcP "nice"    id
sizeP    = liftAcP "size"    parseInt
rssP     = liftAcP "rss"     parseInt
wchanP   = liftAcP "wchan"   id
statP    = liftAcP "stat"    id
ttyP     = liftAcP "tty"     id
timeP    = liftAcP "time"    parseClockTime
commandP = liftAcP "command" id

liftOpP o x y s = (x s) `o` (y s)

(&&?)    = liftOpP (&&)
infixr 3 &&?

(||?)    = liftOpP (||)
infixr 2 ||?


-- Example Runs ----------------------------------------------------------------

-- You will need below ghc command line wrapper before using this script from
-- the command line.

--   $ cat PSGrep.sh
--   #!/bin/sh
--   ghc -e "printPSFields \$ $@" PSGrep.hs

-- Rest is trivial...

--   $ ./PSGrep.sh 'flagsP (==) 0 &&? sizeP (<) 1024'
--   0     0  3019     1  19   0   256   504 -      Ss+  tty2     00:00:00 /sbin/getty 38400 tty2
--   0     0  3020     1  19   0   256   508 -      Ss+  tty3     00:00:00 /sbin/getty 38400 tty3
--   0     0  3022     1  19   0   256   500 -      Ss+  tty4     00:00:00 /sbin/getty 38400 tty4
--   0     0  3023     1  19   0   256   504 -      Ss+  tty5     00:00:00 /sbin/getty 38400 tty5
--   0     0  3024     1  19   0   256   504 -      Ss+  tty6     00:00:00 /sbin/getty 38400 tty6

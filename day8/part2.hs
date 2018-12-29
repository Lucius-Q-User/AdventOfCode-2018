import Control.Monad.State

data Tree = Tree [Tree] [Int] deriving (Show)
main = do
  line <- readFile "in.txt"
  let ints = map read $ words line
  putStrLn . show . sumTree $ evalState parseTree ints

parseTree :: State [Int] Tree
parseTree = do
  [nchildren, nmeta] <- consume 2
  ch <- forM [1..nchildren] (const parseTree)
  meta <- consume nmeta
  return $ Tree ch meta

consume :: Int -> State [Int] [Int]
consume n = do
  (head, tail) <- fmap (splitAt n) get
  put tail
  return head

listGet :: Int -> [a] -> Maybe a
listGet _ [] = Nothing
listGet 0 (h:t) = Just h
listGet n (h:t) = listGet (n-1) t


sumTree :: Tree -> Int
sumTree (Tree [] meta) =
  sum meta

sumTree (Tree ch meta) =
  sum $ map (\x -> maybe 0 sumTree (listGet (x - 1) ch)) meta

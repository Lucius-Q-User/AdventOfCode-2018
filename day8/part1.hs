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

sumTree :: Tree -> Int
sumTree (Tree ch meta) =
  (sum $ fmap sumTree ch) + sum meta

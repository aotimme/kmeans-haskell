import Data.List
import Debug.Trace
import System.Environment
{- perform kmeans clustering -}

type Vector = [Double]

parsePoints :: [Char] -> [Vector]
parsePoints contents =
  map (\x -> map (\y -> read y :: Double) x) points
  where points = map words (lines contents)

-- get the squared euclidean distance between two points
getSquaredEuclideanDistance :: Vector -> Vector -> Double
getSquaredEuclideanDistance p1 p2 =
  let zipped = zip p1 p2
      squareDiff (a, b) c = c + (a - b) ** 2 
  in  foldr squareDiff 0 zipped

-- get euclidean distance between two points
getEuclideanDistance :: Vector -> Vector -> Double
getEuclideanDistance p1 p2 = sqrt $ getSquaredEuclideanDistance p1 p2


-- helper for getMinIndex
accumulateMin :: Ord a => (Int, a, Int) -> a -> (Int, a, Int)
accumulateMin (minIdx, min, curIdx) x
  | min <= x    = (minIdx, min, curIdx + 1)
  | otherwise   = (curIdx, x, curIdx + 1)

-- get index of minimum element of list
-- faster than:
--    head $ filter ((== minimum xs) . (xs !!)) [0..]
getMinIndex :: Ord a => [a] -> Int
getMinIndex (x:xs) = first $ foldl accumulateMin (0,x,1) xs
  where first (a, _, _) = a


-- get closest centroid to a point
getClosestCentroid :: Vector -> [Vector] -> Int
getClosestCentroid point centroids =
  let distances = map (getSquaredEuclideanDistance point) centroids
  in  getMinIndex distances

-- classify points
classifyPoints :: [Vector] -> [Vector] -> [Int]
classifyPoints points centroids = map ((flip getClosestCentroid) centroids) points

-- averages a list
average :: [Double] -> Double
average xs = sum xs / fromIntegral (length xs) :: Double

-- get center of a list of points
getCenter :: [Vector] -> Vector
getCenter points = map average $ transpose points

-- Inefficient!!
getCentroids :: [Vector] -> [Int] -> [Vector]
getCentroids points classes =
  let classifiedPoints = zip points classes
      classSort (_,c) (_,k)
        | c < k     = LT
        | c > k     = GT
        | otherwise = EQ
      inSameClass (_,c) (_,k) = c == k
      groupedPoints = groupBy inSameClass $ sortBy classSort classifiedPoints
      unclassifiedPoints = map (\x -> fst (unzip x)) groupedPoints
  in  map getCenter unclassifiedPoints

-- Inefficient!! (but just a helper for trace)
getNumInClasses :: [Int] -> String
getNumInClasses klasses =
  let numZero = length $ filter (==0) klasses
      numOne  = length $ filter (==1) klasses
  in  "Group 0: " ++ (show numZero) ++ "\nGroup 1: " ++ (show numOne)

-- get new set of centroids from points and current centroids
doKmeansIteration :: [Vector] -> [Vector] -> [Vector]
doKmeansIteration points centroids =
  let klasses   = classifyPoints points centroids
  in  trace (getNumInClasses klasses) getCentroids points klasses

doKmeans :: [Vector] -> [Vector] -> Int -> [Int]
doKmeans points centroids maxIters =
  let newCentroids = (iterate (doKmeansIteration points) centroids) !! (maxIters - 1)
  in  classifyPoints points newCentroids

main = do
  args <- getArgs
  pointsContents <- readFile $ args !! 1
  centroidsContents <- readFile $ args !! 3
  let points    = parsePoints pointsContents
      centroids = parsePoints centroidsContents
      k         = read (args !! 0) :: Int
      maxIters  = read (args !! 2) :: Int
  putStrLn ("K          = " ++ (show k))
  putStrLn ("Iterations = " ++ (show maxIters))
  putStrLn ("Num Points = " ++ (show $ length points))
  --putStrLn "Centroids:"
  --putStrLn . unlines $ map show centroids
  let klasses = doKmeans points centroids maxIters
  putStrLn ("Group 0: " ++ (show $ length (filter (==0) klasses)))
  putStrLn ("Group 1: " ++ (show $ length (filter (==1) klasses)))

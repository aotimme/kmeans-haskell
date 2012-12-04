=== K-Means in Haskell

Performs K-means clustering on a list of tab-separated numeric vectors
given a number K of clusters, a list of tab-separated numberic vectors
of starting centroids, and a number of maximum iterations

Sample usage:

```
ghc --make kmeans.hs
./kmeans 2 yeast.dat 10 yeast_centroids.dat
```

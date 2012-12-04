K-Means in Haskell
===============

Performs K-means clustering on a list of tab-separated numeric vectors
given a number K of clusters, a list of tab-separated numberic vectors
of starting centroids, and a number of maximum iterations

Sample usage:

```
ghc --make kmeans.hs
./kmeans 2 yeast.dat 10 yeast_centroids.dat
```

Out-of-the-box, this should print out:

```
K          = 2
Iterations = 10
Num Points = 2467
Group 0: 1496
Group 1: 971
Group 0: 1589
Group 1: 878
Group 0: 1659
Group 1: 808
Group 0: 1706
Group 1: 761
Group 0: 1743
Group 1: 724
Group 0: 1757
Group 1: 710
Group 0: 1772
Group 1: 695
Group 0: 1782
Group 1: 685
Group 0: 1793
Group 1: 67
Group 0: 1802
Group 1: 665
```

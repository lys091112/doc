## 图论的基本概念

### 1. 基础概念

1. 匹配

    给定一个二分图，在G的一个子图G’中，如果G’的边集中的任意两条边都不依附于同一个顶点，则称G’的边集为G的一个匹配

2. 最大匹配

    在所有的匹配中，边数最多的那个匹配就是二分图的最大匹配了

- 最小支配集：

    从V中取尽量少的 点组成一个集合，使得V中剩余的点都与取出来的点有变相连。

- 顶点覆盖：

    图G的顶点覆盖是一个顶点集合V，使得G中的每一条边都接触V中的至少一个顶点,我们称集合V覆盖了G的边

- 最小顶点覆盖：

    在所有的顶点覆盖集中，顶点数最小的那个叫最小顶点集合。

- 独立集：

    在所有的顶点中选取一些顶点，这些顶点两两之间没有连线，这些点就叫独立集

- 最大独立点集：

    在左右的独立集中，顶点数最多的那个集合。二分图的最大独立点集是指从二分图G=(X,Y;E)选取一些点v*属于{X,Y}，使得点集v*中任意两点之间没有通过边连接。而二分图的最大独立点集模型就是求取max|v*|。

- 最小点权覆盖：

    如果覆盖每个顶点需要付出不同的代价，或称为点权（或为容量），那么问题可以描述成，在保证覆盖所有边的情况下，如何使得权和最小。

- 路径覆盖：

    在图中找一些路径，这些路径覆盖图中所有的顶点，每个顶点都只与一条路径相关联。

- 最小路径覆盖：

    在所有的路径覆盖中，路径个数最小的就是最小路径覆盖了。

顶点集C被称为无向图 G=(V,E) 的团: 如果C是顶点集V的子集(C⊆V)，而且任意两个C中的顶点都有边连接。另一种等价的说法是，由C诱导的子图是完全图 （有时也用“团”来指这样的子图）。

极大团是指增加任一顶点都不再符合团定义的团，也就是说，极大团不能被任何一个更大的团所包含。

最大团是一个图中顶点数最多的团。图G的团数（clique number）ω(G) 是指G中最大团的顶点数。图G的边团覆盖数（edge clique cover number）是指覆盖G中所有的边所需要的最少的团的数目。图G的二分维数（bipartite dimension）是指覆盖G中所有边所需要的最少的二分团的数目，其中二分团（biclique）就是完全二分子图 。而分团覆盖问题 （Clique cover problem）所关心的是用最少的团去覆盖G中所有的顶点。

割点：是无向连通图中一个顶点v, 如果删除它以及它关联的边后，得到的新图至少包含两个连通分支。

桥：无向连通图中的一条边，如果删除它，得到的新图包含两个连通分量。

双连通图：不含割点的无向连通图。

双连通分支：无向连通图的最大双连通子图。

####  1.1 欧拉路径

大前提：基图（去掉方向后的图）中所有度非零的点属于一个连通分量。

欧拉路径：从一个点出发，每条边都只走一遍，结束于另一个点。 无向图中，只有两个点的度为奇数，这两个点分别为起点和终点。有向图中，只有一个点的出度比入度大1，这个点当起点，只有一个点的入度比出度大1，这个点当终点。

欧拉回路：起点和终点是同一个点。 无向图中，每个点的度为偶数。有向图中，每个点的入度等于出度

##### 1.1 

    找欧拉路径可以通过在图上的两个奇数点之间加一条边转化为求欧拉回路的问题

### 特性  

- 最小顶点覆盖 = 最大匹配

- 最小路径覆盖=节点数-其对应二分图的最大匹配数

- 最大独立集 = 顶点个数 – 最大匹配（最小顶点覆盖）
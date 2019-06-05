.. _algorithm_base_union-find:

并查集
===========

并查集（Union-find Sets）是一种非常精巧而实用的数据结构，它主要用于处理一些不相交集合的合并问题。一些常见的用途有求连通子图、求最小生成树的 Kruskal 算法和求最近公共祖先（Least Common Ancestors, LCA）等。

使用并查集时，首先会存在一组不相交的动态集合

并查集的基本操作有三个：

::

    makeSet(s)：建立一个新的并查集，其中包含 s 个单元素集合。

    unionSet(x, y)：把元素 x 和元素 y 所在的集合合并，要求 x 和 y 所在的集合不相交，如果相交则不合并。

    find(x)：找到元素 x 所在的集合的代表，该操作也可以用于判断两个元素是否位于同一个集合，只要将它们各自的代表比较一下就可以了。


find 方法中有用到路径压缩法，即将子节点的父节点统一指向当前树的节点

.. code-block:: go

    func (unionFind *UnionFind) Find(x int) int {
        if x != father[x] {
            father[x] = unionFind.Find(father[x]) //回溯时进行路径压缩
        }
        return father[x]
    }

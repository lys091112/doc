.. highlight:: rst

字符串
===========


 字符串匹配算法 
:::::::::::::::::

   朴素算法（Naive Algorithm）、Rabin-Karp 算法、有限自动机算法（Finite Automation）、 Knuth-Morris-Pratt 算法（即 KMP Algorithm）、Boyer-Moore 算法、Simon 算法、Colussi 算法、Galil-Giancarlo 算法、Apostolico-Crochemore 算法、Horspool 算法和 Sunday 算法

1. KMP

2. BM

3. Sunday
''''''''''''''

Sunday算法是从前往后匹配，在匹配失败时关注的是主串中参加匹配的最末位字符的下一位字符。

如果该字符没有在模式串中出现则直接跳过，即移动位数 = 模式串长度 + 1；
否则，其移动位数 = 模式串长度 - 该字符最右出现的位置(以0开始) = 模式串中该字符最右出现的位置到尾部的距离 + 1

时间复杂度统计：
    n 为字符串长度 m为匹配长度
    Sunday预处理阶段的时间为：O(∣∣∑∣∣ + m)

    最坏情况下时间复杂度为：O(nm)  即每次向后移动一个位置， 有因为find_fit_pos的时间为o(m) 所以为o(nm)

    平均时间复杂度：O(n)

    空间复杂度：O(∣∣∑∣∣)

KMP BM Sunday 算法对比
'''''''''''''''''''''''''''
 
1. BM算法的跳转确实比KMP算法要优秀，但是BM算法首先要构建一个好后缀表，这个表的构建是需要O(n^2)的复杂度的。如果目标串的规模很大（起码比模式串大O（n^2）个规模），那么BM算法才能在跳转上体现优势，BM算法在算法竞赛上经常不被待见。

2. Sunday算法获得比BM算法更大的跳跃距离，但是缺点很明显，就是很容易退化，比如在目标串baaabaaabaaaa寻找模式串aaaa，目标串最多只能跳两个位置，复杂度达到O(t_len*p_len

3. BM算法和KMP算法都很好地利用了前缀和后缀的匹配方式，都是很优秀的单模匹配算法，但是BM算法构建好后缀表需要花大量的时间，往往对于小规模匹配情况可能KMP算法和C标准函数strstr效果更好(strstr函数虽然用的是O(n^2)的算法，但是可能模式串也不是很大，而且这个函数可能是经过微软在汇编层进行过优化的)


常用场景
:::::::::::::
1. 最长连续公共子序列
   后缀数组

2. 编辑距离算法

3. 最长公共子序列

4. 字符串模糊匹配


Hash
字典树
AC自动机
后缀数组
EX_KMP
SAM(后缀自动机)



manacher、 回文串自动机
''''''''''''''''''''''''''
Manacher算法可以在O(n)的时间内求出以每个位置为中心的最长回文串,但是如果要统计回文串的个数，Manacher就捉襟见肘

# 那些令人惊奇的算法

*1. 有一个黑匣子，黑匣子里有一个关于 x 的多项式 p(x) 。我们不知道它有多少项，但已知所有的系数都是正整数。每一次，你可以给黑匣子输入一个整数，黑匣子将返回把这个整数代入多项式后的值。那么，最少需要多少次， 我们可以得到这个多项式每项的系数呢？
    
    Answer: 两次.
    第一次另x=1,得出a0+a1+...+an=S.
    第二次令x=S+1,带入多项方程式,得出a0+a1(S+1)+a2(S+1)^2+...+an(S+1)^n=M ,
    将M转化为S+1的多项式,那么对应的阶的参数值就是要求的解.既将数据转化为n进制多项式表示.
        
        
*2. 问: 有一种玻璃杯质量确定但未知，需要检测。 有一栋100层的大楼，该种玻璃杯从某一层楼扔下，刚好会碎。现给你两个杯子，问怎样检测出这个杯子的质量，即找到在哪一层楼刚好会碎？ 

    Answer:再一个比较常见的方法是，先分区间的扔，再慢慢地一层一层地扔，隐含着分段查找的策略。
    具体操作方式是：
    先从第10楼扔，再从第20楼扔，依次下去，如果到某一层碎掉，比如50层碎掉了，我再从41楼开始扔，这样的话应该算是比较快了把？
    这个方法是要快一点不过如果我杯子的质量比较好，在99楼才会刚好碎掉。
    这样，最差的情况下，需要扔19次才能找到目标楼层，还是不能让面试官满意

    具体方法设计：
    每次扔的区间减少一层，这样做可以保证每个区间查找的最差次数是一样的。
    假定第一步在15楼扔，没碎的话则下一步在29楼扔，没碎下一步在42楼扔....碎掉之后则在上一次没碎的楼层开始向上扔。那么最开始在哪一层开始扔呢？？
    这里我们需要拿支笔算一下：
    x+(x-1)+(x-2)+...+2 >=100
    求出答案位14. 
    平均次数为:0.14*7.5+0.13*8+0.12*8.5+0.11*9+0.1*9.5+0.09*10+0.08*10.5+0.07*11+0.06*11.5+0.05*12+0.04*12.5+0.01*12 ＝ 9.47次 
    (在1-14中选择的概率为0.14,总计需要平均次数位1+(13 / 2) = 7.5)

*3. 有个list，已知存在majority element，就是出现次数多余一半的元素，怎么把它找出来。比如 abaacbbacaa 中的a。如果不知道list里面是不是有majority element，如果有就把它找出来，没有的话return none呢？

    很简单的方式,算法很简单，开始记录0
    遍历第i个元素时
    ------如果当前记录的是0，那么记录(第i个元素,1)
    ------如果当前记录是(x,y)
    ------------如果当前元素是x，那么记录(x,y+1)
    ------------否则记录(x,y-1)（如果y-1=0，记为0)
    因为有一个数超过立其中的一半,所以最后相互加减下去,剩下的大于1的一定是majority element

*4. 有一个n个元素的数组，除了一个元素只出现一次外，其他元素都出现两次，让你找出这个只出现一次的元素是几，要求时间复杂度为O(n)且不再开辟新的内存空间?
    
    解法是将所有元素做异或运算，即a[1] XOR a[2] XOR a[3] XOR…XOR a[n]，
    所得的结果就是那个只出现一次的数字，时间复杂度为O(n)。

*5. 进阶版:有一个n个元素的数组，除了两个数只出现一次外，其余元素都出现两次，让你找出这两个只出现一次的数分别是几，要求时间复杂度为O(n)且再开辟的内存空间固定(与n无关)。

    仿照前面的算法，把所有元素异或，得到的结果就是那两个只出现一次的元素异或的结果。

    然后，重点来了，因为这两个只出现一次的元素一定是不相同的，所以这两个元素的二进制形式肯定至少有某一位是不同的，即一个为0，另一个为1，找到这一位。

    可以根据前面异或得到的数字找到这一位，怎么找呢？稍加分析就可以知道，异或得到这个数字二进制形式中任意一个为1的位都是我们要找的那一位，找到这一位就可以了(这很容易)。

    再然后，以这一位是1还是0为标准，将数组的n个元素分成了两部分，将这一位为0的所有元素做异或，得出的数就是只出现一次的数中的一个;
    将这一位为1的所有元素做异或，得出的数就是只出现一次的数中的另一个。从而解出题目。忽略寻找不同位的过程，总共遍历数组两次，时间复杂度为O(n)
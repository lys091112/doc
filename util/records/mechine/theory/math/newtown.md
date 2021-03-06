## 牛顿法和拟牛顿法

1、牛顿法
2、拟牛顿条件
3、DFP 算法
4、BFGS 算法
5、L-BFGS 算法


### 牛顿法

    牛顿法的关键性在于:切线是曲线的线性逼近

#### 牛顿法求解线性方程的根

牛顿法的核心思想是泰勒公式的一级展开式 $f(x)=f(x_0)+(x-x_0)f^{'}(x_0)$

令 $f(x)=0$, 带入上式得：

  $$x=x_0-\frac{f(x_0)}{f^{'}(x_0)}$$

然后，利用迭代方法求解，以 x 为 x0，求解下一个距离方程的根更近的位置。迭代公式可以写成：
  $$x_{n+1}=x_n-\frac{f(x_n)}{f^{'}(x_n)}$$
经过一定次数的有效迭代后，一般都能保证在方程的根处收敛。


#### 牛顿法凸优化

##### 针对于 N == 1的情况，
想要让损失函数最小化，这其实是一个最值问题，对应函数的一阶导数 f’(x) = 0。也就是说，如果我们找到了能让 f’(x) = 0 的点 x，损失函数取得最小值

对 f(x) 在 x0 处进行二阶泰勒展开

$$f(x)=f(x_0)+(x-x_0)f^{'}(x_0)+\frac{1}{2}(x-x_0)^2 f^{''}(x_0)$$

上式成立的条件是 f(x) 近似等于 f(x0)。令 f(x) = f(x0)，并对 (x - x0) 求导

$$x=x_0 - \frac{f^{'}(x_0)}{f^{''}(x_0)}$$

同样，虽然 x 并不是最优解点，但是 x 比 x0 更接近 f’(x) = 0 的根。这样，就能得到最优化的迭代公式：

$$x_{n+1}=x_n - \frac{f^{'}(x_n)}{f^{''}(x_n)}$$

通过迭代公式，就能不断地找到 f’(x) = 0 的近似根，从而也就实现了损失函数最小化的优化目标

##### 针对于N > 1 的情况， 展开二次泰勒，如下：

$$\varphi(X)=f(X_k) + \nabla f(X_k) (X-X_k) + \frac{1}{2} (X-X_k)^T \nabla^2 f(X_k) (X-X_k) $$

其中 $\nabla f$ 为梯度向量，$\nabla^2 f$ 为f的海森矩阵(Hessian matrix) ,分别定义为：

$$ \nabla f = 
     \left [
     \begin{matrix}
       \frac{\partial f}{\partial x_1}\\
       \frac{\partial f}{\partial x_2} \\
       \dots \\
       \frac{\partial f}{\partial x_n }
      \end{matrix}
      \right ] 
$$

$$ \nabla^2 f = 
     \left [
     \begin{matrix}
       \frac{\partial^2 f}{\partial x_1^2} & \frac{\partial^2 f}{\partial x_1 \partial x_2} & \dots &  \frac{\partial^2 f}{\partial x_1 \partial x_n}\\
       \frac{\partial^2 f}{ \partial x_2 \partial x_1} & \frac{\partial^2 f}{\partial x_2^2} & \dots &  \frac{\partial^2 f}{\partial x_2 \partial x_n}\\
       \dots \\
       \frac{\partial^2 f}{\partial x_n \partial x_1 } & \frac{\partial^2 f}{\partial x_n \partial x_2 } & \dots &  \frac{\partial^2 f}{\partial x_n^2}\\
      \end{matrix}
      \right ] 
$$

其中 $\nabla f$ $\nabla^2 f$ 均为x的函数，分别记为 g 和 H, 而 $ \nabla f(x_k)$,  $\nabla^2 f(x_k)$  分别为x取$x_k$时的实质向量和矩阵，记为$g_k$,  $H_k$

同样是求极值点，要求驻点为0，即 $\nabla \varphi(x) = 0$, 亦$g_k + H_k(x-x_k) = 0 $, 如果 $H_k$ 为非奇异矩阵， 则
$ x = x_k - H_k^{-1} g_k $

进一步可以得出优化公式为 $x_{k+1} = x_k - H_k^{-1} g_k , k=0,1,\dots$

其中 $d_k = H_k^{-1} g_k $ 被称谓梯度方向

#### 牛顿方法是否总是收敛

// TODO 待证明
收敛的充分条件：
若f二阶可导，那么在待求的零点x周围存在一个区域，只要起始点x_{0}位于这个邻近区域内，那么牛顿-方法必定收敛

我们不知道根点到底在哪里，所以起始点x_{0}选择就不一定在这个区域内，那么这个直觉就不可靠了

1. 驻点
2. 越来越远离的不收敛 如：$f(x)=x \frac{1}{3}$
3. 循环震荡的不收敛 如:$f(x)=|x|^ \frac{1}{2}$
4. 不能完整求出所有的根 如：$f(x)=x^4-2x^2+x$ ，有多个根，如果选择的起始点不对，可能会陷入鞍点（局部最优）




### 梯度下降 VS 牛顿法

梯度下降和牛顿法的更新公式

$$x_{n+1} = x_n - \alpha f^{'}(x_n)$$

$$x_{n+1}=x_n - \frac{f^{'}(x_n)}{f^{''}(x_n)}$$

梯度下降算法是将函数在 xn 位置进行一次函数近似，也就是一条直线。计算梯度，从而决定下一步优化的方向是梯度的反方向。而牛顿法是将函数在 xn 位置进行二阶函数近似，也就是二次曲线。计算梯度和二阶导数，从而决定下一步的优化方向

优缺点对比：

我们来看一下牛顿法的优点。第一，牛顿法的迭代更新公式中没有参数学习因子，也就不需要通过交叉验证选择合适的学习因子了。第二，牛顿法被认为可以利用到曲线本身的信息, 比梯度下降法更容易收敛（迭代更少次数）。如下图是一个最小化一个目标方程的例子, 红色曲线是利用牛顿法迭代求解, 绿色曲线是利用梯度下降法求解。显然，牛顿法最优化速度更快一些

牛顿法迭代公式中除了需要求解一阶导数之外，还要计算二阶导数。从矩阵的角度来说，一阶导数和二阶导数分别对应雅可比矩阵（Jacobian matrix）和海森矩阵（Hessian matrix）

牛顿法不仅需要计算 Hessian 矩阵，而且需要计算 Hessian 矩阵的逆。当数据量比较少的时候，运算速度不会受到大的影响。但是，当数据量很大，特别在深度神经网络中，计算 Hessian 矩阵和它的逆矩阵是非常耗时的。从整体效果来看，牛顿法优化速度没有梯度下降算法那么快。所以，目前神经网络损失函数的优化策略大多都是基于梯度下降


### 拟牛顿法

// TODO 


// TODO
 a、修正牛顿(Newton)法
 b、共轭方向法与共轭梯度法
 c、拟牛顿法（避免求解Hessian矩阵）：DFP算法、BFGS算法



### 参考资料

1. [如何通俗易懂地讲解牛顿迭代法？](https://www.matongxue.com/madocs/205.html)
2. [牛顿法收敛性定理及其证明](https://www.jianshu.com/p/7c8c902fcd75)

# 基本概念


## 1. CAP 定理(From wiki)
在理论计算机科学中，CAP定理（CAP theorem），又被称作布鲁尔定理（Brewer's theorem），它指出对于一个分布式计算系统来说，不可能同时满足以下三点：
* 一致性（Consistence) （等同于所有节点访问同一份最新的数据副本）
* 可用性（Availability）（每次请求都能获取到非错的响应——但是不保证获取的数据为最新数据）
* 分区容错性（Network partitioning）（以实际效果而言，分区相当于对通信的时限要求。系统如果不能在时限内达成数据一致性，就意味着发生了分区的情况，必须就当前操作在C和A之间做出选择。）

根据定理，分布式系统只能满足三项中的两项而不可能满足全部三项[4]。理解CAP理论的最简单方式是想象两个节点分处分区两侧。允许至少一个节点更新状态会导致数据不一致，即丧失了C性质。如果为了保证数据一致性，将分区一侧的节点设置为不可用，那么又丧失了A性质。除非两个节点可以互相通信，才能既保证C又保证A，这又会导致丧失P性质。

通俗解释：
```
一个分布式系统里面，节点组成的网络本来应该是连通的。然而可能因为一些故障，使得有些节点之间不连通了，整个网络就分成了几块区域。数据就散布在了这些不连通的区域中,这就叫分区。

当你一个数据项只在一个节点中保存，那么分区出现后，和这个节点不连通的部分就访问不到这个数据了。这时分区就是无法容忍的。

提高分区容忍性的办法就是一个数据项复制到多个节点上，那么出现分区之后，这一数据项就可能分布到各个区里。容忍性就提高了。然而，要把数据复制到多个节点，就会带来一致性的问题，就是多个节点上面的数据可能是不一致的。要保证一致，每次写操作就都要等待全部节点写成功，而这等待又会带来可用性的问题。

总的来说就是，数据存在的节点越多，分区容忍性越高，但要复制更新的数据就越多，一致性就越难保证。为了保证一致性，更新所有节点数据所需要的时间就越长，可用性就会降低。

作者：邬江
链接：https://www.zhihu.com/question/54105974/answer/139037688
来源：知乎

一般而言，P是一定要存在的，如果不存在P，那么就是很乐观的认为系统不会出现网络分区,当然我们知道这是不可能的。
```



## 分布式事务处理

### 数据一致性种类

- 强一致性

当更新操作完成之后，任何多个后续进程或者线程的访问都会返回最新的更新过的值。这种是对用户最友好的，就是用户上一次写什么，下一次就保证能读到什么。根据 CAP 理论，这种实现需要牺牲可用性。
```
保证读操作总是可以读到最新版本的数据（即可线性化）

写操作需要同步到多数派副本后才能成功提交。读操作需要多数派副本应答后才返回给客户端。读操作不会看到未提交的或者部分写操作的结果，并且总是可以读到最近的写操作的结果。

保证了全局的（会话间）单调读，读自己所写，单调写，读后写

读操作的代价比其他一致性级别都要高，读延迟最高
```



**弱一致性**

系统并不保证续进程或者线程的访问都会返回最新的更新过的值。系统在数据写入成功之后，不承诺立即可以读到最新写入的值，也不会具体的承诺多久之后可以读到。

- 有界旧一致性

```
保证读到的数据最多和最新版本差K个版本

通过维护一个滑动窗口，在窗口之外，有界旧一致性保证了操作的全局序。此外，在一个地域内，保证了单调读
```

- 会话一致性

```
在一个会话内保证单调读，单调写，和读自己所写，会话之间不保证

会话一致性把读写操作的版本信息维护在客户端会话中，在多个副本之间传递

会话一致性的读写延迟都很低
```
- 前缀一致性

```
前缀一致保证，在没有更多写操作的情况下，所有的副本最终会一致

前缀一致保证，读操作不会看到乱序的写操作。例如，写操作执行的顺序是`A, B, C`，那么一个客户端只能看到`A`, `A, B`, 或者`A, B, C`，不会读到`A, C`，或者`B, A, C`等。

在每个会话内保证了单调读
```

- 最终一致性

弱一致性的特定形式。系统保证在没有后续更新的前提下，系统最终返回上一次更新操作的值。在没有故障发生的前提下，不一致窗口的时间主要受通信延迟，系统负载和复制副本的个数影响。DNS 是一个典型的最终一致性系统。 在工程实践上，为了保障系统的可用性，互联网系统大多将强一致性需求转换成最终一致性的需求，并通过系统执行幂等性的保证，保证数据的最终一致性

```
最终一致性保证，在没有更多写操作的情况下，所有的副本最终会一致

最终一致性是很弱的一致性保证，客户端可以读到比之前发生的读更旧的数据

最终一致性可以提供最低的读写延迟和最高的可用性，因为它可以选择读取任意一个副本
```



### 二阶段提交（wo-phaseCommit）、TCC（Try-Confirm-Cancel 、 三阶段提交（Three-phase commit）

1. 二阶段提交

  不足之处：
    1. 同步阻塞问题。执行过程中，所有参与节点都是事务阻塞型的。当参与者占有公共资源时，其他第三方节点访问公共资源不得不处于阻塞状态。

    2. 单点故障。由于协调者的重要性，一旦协调者发生故障。参与者会一直阻塞下去。尤其在第二阶段，协调者发生故障，那么所有的参与者还都处于锁定事务资源的状态中，而无法继续完成事务操作。（如果是协调者挂掉，可以重新选举一个协调者，但是无法解决因为协调者宕机导致的参与者处于阻塞状态的问题）

    3. 数据不一致。在二阶段提交的阶段二中，当协调者向参与者发送commit请求之后，发生了局部网络异常或者在发送commit请求过程中协调者发生了故障，这回导致只有一部分参与者接受到了commit请求。而在这部分参与者接到commit请求之后就会执行commit操作。但是其他部分未接到commit请求的机器则无法执行事务提交。于是整个分布式系统便出现了数据部一致性的现象。

    4. 二阶段无法解决的问题：协调者再发出commit消息之后宕机，而唯一接收到这条消息的参与者同时也宕机了。那么即使协调者通过选举协议产生了新的协调者，这条事务的状态也是不确定的，没人知道事务是否被已经提交。






## 分布式一致性算法

### Paxos 、Raft 、 Gossip

用来保证数据一致性



### 分布式事务与分布式存储一致性的理解

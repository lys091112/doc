# cache系统设计

## 1. 系统概要
一个完备的缓存系统需要包含以下几个方面：
### 1.1 一致性问题

#### 1.1.1 常用策略

- 先更新数据库， 在更新缓存
- 先更新缓存，在更新数据库
- 先删除缓存，再更新数据库
- 先更新数据库，再删除缓存

单纯的更新删除策略无法满足数据一致性的要求，所以一般是几种策略的组合来保证数据的最终一致性

#### 1.1.2 数据一致性方案

##### 1.1.2.1 先更新数据库，在删除缓存方式
步骤如下：

1. 将数据写入到db中
2. 删除cache中的数据,并增加重试补偿策略
3. 若重试补偿仍然失败，发送到MQ走离线补偿策略
4. 如果通过MQ的补偿仍无法删除改cachekey，则考虑其他方案，如走缓存淘汰策略，设置过期时间等方式

> 在极端情况下，仍会出现数据不一致的情况（缓存无法删除）

### 1.2 可靠性

例如： Redis的 RDB AOF策略保证数据redis的高可用

### 1.3 缓存风暴、缓存穿透

缓存风暴和缓存穿透都会对数据库不必要的消耗，但他们产生的因素还是略有不同。

#### 1.3.1  缓存风暴
在某一时刻，大量的缓存集体失效，造成同一key大量访问到数据库层,造成数据库压力突增
解决方式：
    1. 随机过期时间，保证key不会同时失效
    2. 添加同步机制，保证key只有一次访问到数据库
    3. 不设置失效时间，起后台线程定时更新数据
    4. 设置二级缓存，一级失效后访问二级，同时更新一级缓存(TODO 待深思)
    5. 制定更策略，在缓存即将到期前，异步执行更新策略

#### 1.3.2  缓存穿透
表现为如果缓存中没有，则去查询数据库中的数据,造成数据库没必要的消耗
解决方式：
    1. 将空对象存入到缓存中，对于不存在的key，直接返回
    2. 加一层bloomfilter过滤 (如果key不存在，则一定不存在，如果key存在，则有很大的概率存在)
    3. 对于数据量较少数据，可以考虑数据预热，在启动时预先初始化到缓存

### 1.4 淘汰策略
- LRU淘汰策略
- TTL过期清理

TODO  补充常见的淘汰策略


## 2. Guava Cache 设计

### 2.1 缓存记录失效时间策略
- 基于创建时间
- 基于访问时间

### 2.2 支持缓存容量限制
- 基于缓存记录条数
- 基于缓存记录权重

### 2.3 支持自动更新原数据
- CacheLoader方式
- Callable 方式 

### 2.4 支持多种淘汰策略

- 主动淘汰 全部删除、部分删除、单独删除

- 被动淘汰 基于引用、过期时间、容量限制


### 2.5 支持缓存更新策略

- 基于写入时间

### 2.6 缓存监控

### 2.7 示例

``` java

 LoadingCache<Integer, Map<Integer, ParameterDo>> parameterCache = CacheBuilder.newBuilder()
                .maximumSize(100).expireAfterWrite(Duration.ofMinutes(30))
                .refreshAfterWrite(Duration.ofMinutes(60))
                .build(new CacheLoader<Integer, Map<Integer, ParameterDo>>() {
                    @Override
                    public Map<Integer, ParameterDo> load(Integer cateId) throws Exception {
                        // TODO
                        return null;
                    }

                    @Override
                    public ListenableFuture<Map<Integer, ParameterDo>> reload(Integer cateId, Map<Integer, ParameterDo> oldValue)
                        throws Exception {
                            // TODO
                    }
                });
```

## 3. 参考链接

1. [cache总结](https://heapdump.cn/u/1711152/article)
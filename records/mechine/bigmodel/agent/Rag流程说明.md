# Rag 处理用户数据的流程

## 1. 相关概念解释

### 1.1 检索增强器
检索增强器 ``RetrievalAugmentor`` 主要用于：1. 查询优化和改写 2. 关键词扩展 3. 上下文理解增强，他通常有一下几个部分组合而成：
- ``QueryTransformer`` 查询转化器: 将用户问题转换为更适合检索的形式，也称之为query改写，一个query最终可能会拆分从多个query
- ``QueryRouter`` 查询路由器:根据问题类型路由到不同知识库 将query改写后的结果路由到不同的知识库
- ``ContentRetriever`` 内容检索器,支持混合检索,根据问题从相关知识库中查询内容
- ``ContentAggregator`` 内容聚合 将改写后的多个query结果集合聚合为一个结果集合
- ``ContentInjector``  内容注入，将query集合转化为一个ChatMessage，供ChatModel使用

### 1.2 ``QueryTransformer``查询转化器 

``QueryTransformer`` 查询转化器主要负责将用户问题转换为更适合检索的形式，也称之为query改写，一个query最终可能会拆分从多个query，常见的实现：
- ``CompressingQueryTransformer``  将用户问难拆分为多个query。Reformulate this query into a clear, concise, and self-contained format suitable for information retrieval
- `` ExpandingQueryTransformer`` 根据用户问题，生成多个版本的新问法。 Generate {{n}} different versions of a provided user query

### 1.3 ``QueryRouter`` 查询路由器

用户的Rag系统可能有多个知识库来源，需要根据用户问题和知识库的意图描述，将用户问题映射到对应的知识库上，如查询订单相关的意图应该映射到订单相关的知识库上。 常见的实现：
- ``LanguageModelQueryRouter`` 根据用户问题和知识库的意图描述，使用语言模型生成一个概率分布，将用户问题映射到对应的知识库上

### 1.4 ``ContentRetriever`` 内容检索器

``ContentRetriever`` 内容检索器支持混合检索，根据问题从相关知识库中查询内容，常见的实现：
- ``EmbeddingStoreContentRetriever`` 从知识库中查询内容
- ``WebSearchContentRetriever`` 从web索引搜索相关知识内容

### 1.5 ``ContentAggregator`` 内容聚合

``ContentAggregator`` 内容聚合将改写后的多个query结果集合聚合为一个结果集合，常见的实现：
- ``DefaultContentAggregator`` 将改写后的多个query结果集合聚合为一个结果集合

#### 1.5.1 RRF 算法
Reciprocal Rank Fusion (RRF) 用于集合内容的权重打分，特别适用于信息检索和推荐系统领域。它通过融合不同排名系统的结果来提高检索质量，而无需进行复杂的分数归一化或校准

```
RRF_score(d) = Σ (1 / (k + rank(d, i)))
```
d：文档/项目
i：第 i 个排名列表
rank(d, i)：文档 d 在第 i 个列表中的排名 (从 1 开始)
k：调节参数 (通常设为 60，经验值)

### 1.6 ``ContentInjector`` 内容注入

将query集合转化为一个ChatMessage，供ChatModel使用

参考： [rag流程](https://docs.langchain4j.dev/img/advanced-rag.png)
      [rag 概念](https://blog.langchain.com/deconstructing-rag/)

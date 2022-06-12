# spring cache

## 1. 基本概念

1. cacheName 用于声明不同的缓存策略，缓存的key都是以 ``${cacheName}::`` 开头, 初始化示例

```java
    @Bean
    @Primary // 存在多个cacheManger时，优先使用这个
    public RedisCacheManager redisCacheManager(LettuceConnectionFactory factory) {
        return RedisCacheManager.builder(RedisCacheWriter.nonLockingRedisCacheWriter(factory))
                // 默认策略 30 minutes
                .cacheDefaults(createTtlConfiguration(Duration.ofMinutes(30)))
                // 自定义策略
                .withInitialCacheConfigurations(createInitialCacheConfig()).build();
    }

    private Map<String, RedisCacheConfiguration> createInitialCacheConfig() {
        Map<String, RedisCacheConfiguration> configs = new HashMap<>();
        configs.put(TWO_MINUTE_CACHE_KEY, createTtlConfiguration(Duration.ofMinutes(2)));
        configs.put(TWO_HOURS_CACHE_KEY, createTtlConfiguration(Duration.ofHours(2)));
        return configs;
    }

    private RedisCacheConfiguration createTtlConfiguration(Duration duration) {
        // value serializable
        Jackson2JsonRedisSerializer jackson2JsonRedisSerializer = new Jackson2JsonRedisSerializer(Object.class);
        ObjectMapper om = new ObjectMapper();
        om.enableDefaultTyping(ObjectMapper.DefaultTyping.NON_FINAL);
        om.setVisibility(PropertyAccessor.ALL, JsonAutoDetect.Visibility.ANY);
        om.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
        jackson2JsonRedisSerializer.setObjectMapper(om);

        // key serializable
        StringRedisSerializer stringRedisSerializer = new StringRedisSerializer();

        return RedisCacheConfiguration.defaultCacheConfig().serializeValuesWith(RedisSerializationContext.SerializationPair.fromSerializer(jackson2JsonRedisSerializer))
                .serializeKeysWith(RedisSerializationContext.SerializationPair.fromSerializer(stringRedisSerializer)).entryTtl(duration);
    }

```
2. key的剩余部分，优先使用注解中的 ``key``,如果为空，则会使用keyGenerator 来生成

## 2.Spring cache 基本使用

- **Cacheable**
    主要针对方法配置，能够根据方法的请求参数对其结果进行缓存

| 参数 | 含义 |
| ---: | :----: |
| value   | 缓存所属的明明空间，即前缀|
| key     | 使用spring spel表达式进行key的拼接|
| condition | @Cacheable将在执行方法之前( #result还拿不到返回值)判断condition，如果返回true，则查缓存|
| unless  | 在方法执行之后，所以可以使用result，当表达式为真时，不缓存数据|


- **CachePut**
    主要针对方法配置，能够根据方法的请求参数对其结果进行缓存，和 @Cacheable 不同的是，它每次都会触发真实方法的调用, 因此可用于数据更新

| 参数 | 含义 |
| ---: | :----: |
| condition | @CachePut将在执行完方法后（#result就能拿到返回值了）判断condition，如果返回true，则放入缓存|
| unless  | @CachePut将在执行完方法后（#result就能拿到返回值了）判断unless，如果返回false，则放入缓存；（即跟condition相反|

- **CacheEvit**
    要针对方法配置，能够根据一定的条件对缓存进行清空

| 参数 | 含义 |
| ---: | :----: |
| beforeInvocation | @CacheEvict， beforeInvocation=false表示在方法执行之后调用（#result能拿到返回值了）,且判断condition，如果返回true，则移除缓存,如果指定为 true，则在方法还没有执行的时候就清空缓存，缺省情况下，如果方法执行抛出异常，则不会清空缓存 |
| allEntries  |      是否清空所有缓存内容，缺省为 false，如果指定为 true，则方法调用后将立即清空所有缓存, 示例： @CachEvict(value=”testcache”,allEntries=true) |

- **Spel 提供的上下文数据**

| 参数 |所属对象| 含义 |
| ---: | :----:| ---- |
| methodName |	root对象|	当前被调用的方法名	|
| method |  	root对象|	当前被调用的方法	|
| target |	root对象|	当前被调用的目标对象	|
| targetClass |	root对象|	当前被调用的目标对象类	|
| args |	root对象|	当前被调用的方法的参数列表	|
| caches |	root对象|	当前方法调用使用的缓存列表（如@Cacheable(value={“cache1”, “cache2”})），则有两个cache	root.caches[0].name|
| argument | name|	执行上下文	当前被调用的方法的参数，如findById(Long id)，我们可以通过#id拿到参数	user.id|
| result |	执行上下文	|方法执行后的返回值（仅当方法执行之后的判断有效，如‘unless’，’cache evict’的beforeInvocation=false）	result|



### spring cache 的redis的序列化方式

1. JdkSerializationRedisSerializer redis 默认的序列化方式
```
    首先它要求存储的对象都必须实现java.io.Serializable接口，比较笨重

    其次，他存储的为二进制数据，这对开发者是不友好的

    优点是反序列化时不需要提供（传入）类型信息(class)

```

2. StringRedisSerializer
```
    StringRedisTemplate默认的序列化方式，key和value都会采用此方式进行序列化
```

3. Jackson2JsonRedisSerializer  GenericJackson2JsonRedisSerializer
```
Jackson2JsonRedisSerializer

    把一个对象以Json的形式存储，效率高且对调用者友好

    优点是速度快，序列化后的字符串短小精悍，不需要实现Serializable接口。

    但缺点也非常致命：那就是此类的构造函数中有一个类型参数，必须提供要序列化对象的类型信息(.class对象)。 通过查看源代发现其在反序列化过程中用到了类型信息

GenericJackson2JsonRedisSerializer

   会自带@class类信息，进入序列化对象，用于反序列化时，无序指定对象

```
对比：

    Jackson2JsonRedisSerializer: 他能实现 ``不同的Project`` 之间数据互通（因为没有@class信息，所以只要字段名相同即可），因为其实就是Json的返序列化，只要你指定了类型，就能反序列化成功
    GenericJackson2JsonRedisSerializer: 不用自己手动指定对象的Class。我们可以使用一个全局通用的序列化方式

```java 

    public void test() {
        // imap在序列化时，不会写入map的序列化对象，因此反序列化时会失败
        Map<String,String> imap= Immutable.of("key", "value"),
        jackson.wirteAsString(imap)


        // 会带有java.util.hashmap的序列化信息用于反序列化
        HashMap<String,String> map = new HashMap();
        map.put"key","value");
        jackson.wirteAsString(map)
    }

```

4. FastJsonRedisSerializer和GenericFastJsonRedisSerializer 
```
    同上
```

## 3. SpringBoot Cache 加载顺序
TODO

## 4. 实现原理

TODO
``CacheAspectSupport`` 是 springcache的实现

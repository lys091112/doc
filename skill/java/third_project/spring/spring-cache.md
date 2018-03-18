# spring cache


### Spring cache 基本使用

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

# springboot database 使用

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [springboot database 使用](#-springboot-database-使用)
  - [1. @Transaction的使用](#-1-transaction的使用)
    - [1.1 事务失效的六种情况](#-11-事务失效的六种情况)
    - [1.2 propagation属性:](#-12-propagation属性)
    - [1.3  异常处理](#-13--异常处理)
  - [4. Transactional 源码梳理](#-4-transactional-源码梳理)
    - [4.1 基本概念](#-41-基本概念)
      - [4.1.1 切面相关](#-411-切面相关)
      - [4.1.2 Transactional事务参数](#-412-transactional事务参数)
        - [4.1.2.1 隔离级别](#-4121-隔离级别)
      - [4.1.3 事务处理过程中的名词](#-413-事务处理过程中的名词)
    - [4.2 事务拦截](#-42-事务拦截)
    - [4.3 TransactionInterceptor 实现](#-43-transactioninterceptor-实现)
    - [4.4 参考链接](#-44-参考链接)

<!-- /code_chunk_output -->


## 1. @Transaction的使用

### 1.1 事务失效的六种情况

1. 同一个类中,一个 ``未标注`` @Transactional的方法去调用标有@Transactional的方法,事务会失效

2. 该注解只能应用到public可见度的方法上。如果应用在protected、private或者package可见度的方法上，也不会报错，但是事务设置不会起作用。

3. 数据库引擎本身不支持事务，比如说MySQL数据库中的myisam，事务是不起作用的。

4. Spring只会对unchecked异常进行事务回滚；如果是checked异常则不回滚。可通过 ``@Transactional(rollbackOn = Exception.class)`` 来针对所有的异常

5. @Transactional 注解属性 propagation 设置错误

6. 异常被catch导致@Transactional失效，serviceA 调用serviceB，而serviceB产生的异常被catch，serviceA 为抛出异常，认为这是一次成功的处理，从而导致serviceA和serviceB的事务状态不一致，从而抛出 ``UnexpectedRollbackException`` 异常

### 1.2 propagation属性:

- Propagation.REQUIRED：如果当前存在事务，则加入该事务，如果当前不存在事务，则创建一个新的事务。( 也就是说如果A方法和B方法都添加了注解，在默认传播模式下，A方法内部调用B方法，会把两个方法的事务合并为一个事务 ）

- Propagation.SUPPORTS：如果当前存在事务，则加入该事务；如果当前不存在事务，则以非事务的方式继续运行。

- Propagation.MANDATORY：如果当前存在事务，则加入该事务；如果当前不存在事务，则抛出异常。

- Propagation.REQUIRES_NEW：重新创建一个新的事务，如果当前存在事务，暂停当前的事务。( 当类A中的 a 方法用默认Propagation.REQUIRED模式，类B中的 b方法加上采用 Propagation.REQUIRES_NEW模式，然后在 a 方法中调用 b方法操作数据库，然而 a方法抛出异常后，b方法并没有进行回滚，因为Propagation.REQUIRES_NEW会暂停 a方法的事务 )

- Propagation.NOT_SUPPORTED：以非事务的方式运行，如果当前存在事务，暂停当前的事务。

- Propagation.NEVER：以非事务的方式运行，如果当前存在事务，则抛出异常。

- Propagation.NESTED ：如果当前存在事务，则在嵌套事务内执行。如果当前没有事务，则执行与PROPAGATION_REQUIRED类似的操作。依赖于 JDBC3.0 提供 SavePoint 技术

>  1. 事务的挂起调用的是 AbstractPlatformTransactionManager.suspend, 在事务结束或异常回滚时会在调用 ``resume(...)`` 对已经挂起的事务进行回滚
>
> 在外围方法未开启事务的情况下多个Propagation.REQUIRED修饰的内部方法会新开启自己的事务，且开启的事务相互独立，互不干扰。 原因： 每个@Transactional修饰的方法都是独立执行玩整个流程，然后事务被清理释放，所以如果未嵌套，就是两个执行流程

### 1.3  异常处理

我们把派生于Error或者RuntimeException的异常称为unchecked异常，所有其他的异常成为checked异常，Use checked exceptions for recoverable conditions and runtime exceptions for programming errors
   
 RuntimeException，常是程序员自身的问题。比如说，数组下标越界和访问空指针异常等等，只要你稍加留心这些异常都是在编码阶段可以避免的异常。

![异常继承图谱](../../pictures/java-exception) 



## 4. Transactional 源码梳理

spring定义了@Transactional注解，基于``AbstractBeanFactoryPointcutAdvisor`` 、``StaticMethodMatcherPointcut`` 、``MethodInterceptor`` 的aop编程模式，增强了添加@Transactional注解的方法。同时抽象了事务行为为 ``PlatformTransactionManager`` (事务管理器)、``TransactionStatus`` (事务状态)、``TransactionDefinition`` (事务定义)等形态。最终将事务的开启、提交、回滚等逻辑嵌入到被增强的方法的前后，完成统一的事务模型管理

### 4.1 基本概念

#### 4.1.1 切面相关

ClassFilter、MethodMatcher 共同实现了「判断是否拦截方法」的能力
Pointcut，组合ClassFilter、MethodMatcher，用于识别是否对一个类方法进行增强
Advice，承载增强能力的标签类
Advisor，承载AOP中的advice、pointcut能力的类

手动实现业务拦截的流程就是，实现PointcutAdvisor,然后集成PointCut、Advice 来进行业务处理，

其他方式实现切面的方式是通过注解

#### 4.1.2 Transactional事务参数

transactionManager：事务管理器
propagation：传播行为定义，枚举类型，是spring独有的事务行为设计，默认为PROPAGATION_REQUIRED（支持当前事务，不存在则新建）
isolation：隔离级别，对应数据库的隔离级别实现，mysql默认的隔离级别是 read-committed
timeout：超时时间，默认使用数据库的超时，mysql默认的事务等待超时为5分钟
readOnly：是否只读，默认是false
rollbackFor：异常回滚列表，默认的是RuntimeException异常回滚

##### 4.1.2.1 隔离级别
隔离性引发并发问题：脏读、不可重复读、虚读。
脏读：一个事务读取另一个事务未提交数据。
不可重复读：一个事务读取另一个事务已经提交 update 数据。
幻读：一个事务读取另一个事务已经提交 insert 数据。

ISOLATION_READ_UNCOMMITTED 这是事务最低的隔离级别，它充许别外一个事务可以看到这个事务未提交的数据。这种隔离级别会产生脏读，不可重复读和幻像读。
ISOLATION_READ_COMMITTED 保证一个事务修改的数据提交后才能被另外一个事务读取。另外一个事务不能读取该事务未提交的数据。这种事务隔离级别可以避免脏读出现，但是可能会出现不可重复读和幻像读。

ISOLATION_REPEATABLE_READ 这种事务隔离级别可以防止脏读，不可重复读。但是可能出现幻像读。它除了保证一个事务不能读取另一个事务未提交的数据外，还保证了避免下面的情况产生(不可重复读)。

ISOLATION_SERIALIZABLE 这是花费最高代价但是最可靠的事务隔离级别。事务被处理为顺序执行。除了防止脏读，不可重复读外，还避免了幻像读。



#### 4.1.3 事务处理过程中的名词

- savePoint 依赖于 JDBC3.0 提供 SavePoint 技术, 在嵌套事务PROPAGATION_NESTED 时有用，其他场景没用


### 4.2 事务拦截

1. 在ProxyTransactionManagementConfiguration中初始化 ``BeanFactoryTransactionAttributeSourceAdvisor``, 这个切面类集成了PointCut、Advice，实现了对@Transactional的拦截，具体细节如下：

- 1. ``BeanFactoryTransactionAttributeSourceAdvisor`` 继承实现了 ``PointcutAdvisor``,获取对象PointCut对象为 ``TransactionAttributeSourcePointcut`` 

- 2. ``AnnotationTransactionAttributeSource`` 内置 对象``SpringTransactionAnnotationParser`` 等注解扫描类
```java

//AnnotationTransactionAttributeSource的父类
abstract class TransactionAttributeSourcePointcut extends StaticMethodMatcherPointcut implements Serializable {
    private ClassFilter classFilter;

    public StaticMethodMatcherPointcut() {
        this.classFilter = ClassFilter.TRUE;
    }

    public void setClassFilter(ClassFilter classFilter) {
        this.classFilter = classFilter;
    }

    public ClassFilter getClassFilter() {
        return this.classFilter;
    }

    public final MethodMatcher getMethodMatcher() {
        return this;
    }
	protected TransactionAttributeSourcePointcut() {
		setClassFilter(new TransactionAttributeSourceClassFilter());
	}


	@Override
	public boolean matches(Method method, Class<?> targetClass) {
		TransactionAttributeSource tas = getTransactionAttributeSource();
		return (tas == null || tas.getTransactionAttribute(method, targetClass) != null);
	}

}
public class SpringTransactionAnnotationParser implements TransactionAnnotationParser, Serializable {

    // 对Transactional注解进行了check
	@Override
	public boolean isCandidateClass(Class<?> targetClass) {
		return AnnotationUtils.isCandidateClass(targetClass, Transactional.class);
	}

	@Override
	@Nullable
	public TransactionAttribute parseTransactionAnnotation(AnnotatedElement element) {
		AnnotationAttributes attributes = AnnotatedElementUtils.findMergedAnnotationAttributes(
				element, Transactional.class, false, false);
		if (attributes != null) {
			return parseTransactionAnnotation(attributes);
		}
		else {
			return null;
		}
	}
}
```
- 3. ``BeanFactoryTransactionAttributeSourceAdvisor`` 设置的 ``Advice`` 为 ``TransactionInterceptor``, 这个类时实现业务切面拦截的具体逻辑，继承 ``MethodIntercepter`` 在 **invoke** 方法中进行业务逻辑的实现


### 4.3 TransactionInterceptor 实现

参考业务代码，主要流程为创建事务、提交或回滚事务
```java
protected Object invokeWithinTransaction(Method method, @Nullable Class<?> targetClass,
			final InvocationCallback invocation) throws Throwable {

		// If the transaction attribute is null, the method is non-transactional.
		TransactionAttributeSource tas = getTransactionAttributeSource();
		final TransactionAttribute txAttr = (tas != null ? tas.getTransactionAttribute(method, targetClass) : null);
		final TransactionManager tm = determineTransactionManager(txAttr);

        // ... 省略异步执行业务

        if (txAttr == null || !(ptm instanceof CallbackPreferringPlatformTransactionManager)) {
			// 开启事务，中间会对事务进行绑定，以及按照@Transactoinal中的配置对事务进行初始化
			TransactionInfo txInfo = createTransactionIfNecessary(ptm, txAttr, joinpointIdentification);

			Object retVal;
			try {
                // 实际业务逻辑
				retVal = invocation.proceedWithInvocation();
			}
			catch (Throwable ex) {
				// 异常事务回滚
				completeTransactionAfterThrowing(txInfo, ex);
				throw ex;
			}
			finally {
				cleanupTransactionInfo(txInfo);
			}

			if (retVal != null && vavrPresent && VavrDelegate.isVavrTry(retVal)) {
				// Set rollback-only in case of Vavr failure matching our rollback rules...
				TransactionStatus status = txInfo.getTransactionStatus();
				if (status != null && txAttr != null) {
					retVal = VavrDelegate.evaluateTryFailure(retVal, txAttr, status);
				}
			}
            // 执行事务提交
			commitTransactionAfterReturning(txInfo);
			return retVal;
		}else {
            // .....
        }

```

// 设置隔离级别以及readOnly属性等
DataSourceUtils.prepareConnectionForTransaction

### 4.4 参考链接
1. [Spring框架之事务源码完全解析](https://www.cnblogs.com/xxkj/p/14299772.html)
2. [Dao事务分析之事务管理器DataSourceTransactionManager](https://blog.csdn.net/roberts939299/article/details/77587425)
3. [深入理解@Transactional的工作原理](https://cloud.tencent.com/developer/article/1644003)
4. [Spring事务传播行为详解](https://www.cnblogs.com/jerry-tse/p/17093171.html)


## 5. 异常映射

SQLIntegrityConstraintViolationException Sqlcode=-803 mapper抛出key重复时的异常

实现路径：SQLErrorCodeSQLExceptionTranslator -> SQLErrorCodes -> (sql-error-codes.xml) 包含了code码的映射
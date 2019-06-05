.. _records_language_java_test_mockito-use:

Mockito 基础使用
===================
    
框架引入
::::::::::

::

    way one: @RunWith(MockitoJunitRuner.class)  
    way two: MockitoAnnotations.initMocks(this);


基础使用
:::::::::

.. code-block:: java

    @RunWith(BlockJUnit4ClassRunner.class)
    public class HugCheckProviderTest {

        @InjectMocks
        private HugCheckProvider hugCheckProvider; // 要测试的服务类

        @Mock
        private IHugDisposeService service; // 服务类依赖的服务

        @Mock
        private HugServerProvider hugServerProvider; // 服务类依赖的服务

        @Before
        public void setUp() {
            MockitoAnnotations.initMocks(this);
        }

        @Test
        public void illegal() {
            hugCheckProvider.illegal();
            verify(hugServerProvider, Mockito.times(1)).getHouseIdByInfoId(Mockito.anyLong());
            verify(service, times(0)) .illegalHouse(ArgumentMatchers.eq(record.getHouseId()), anyLong(), anyString(), anyString(), ArgumentMatchers.eq(illegalType.getId()), anyMap());
        }
    }

    public class HugCheckProvider {
        private IHugDisposeService service;
        private HugServerProvider hugServerProvider;

        public voidd illegal() {
            // test
        }
    }


在上述例子中, ``HugCheckProvider`` 为要测试的服务类， ``IHugDisposeService``, ``HugServerProvider`` 为服务类内部依赖的成员变量， 通过注解 ``InjectMocks``, 服务类会自动注入依赖的有 ``Mock`` 注解的成员，通过的方式有：构造方法、setter、或者反射等方式进行注入，此时可以模拟成员的调用方法

当然也可以通过手动注入的方式，不声明 ``InjectMocks`` , 而是手动注入

常用的方法
:::::::::::

thenReturn 和 doAnswer 的使用
'''''''''''''''''''''''''''''''''

thenReturn(T value) Sets a return value to be returned when the method is called.

.. code-block:: java

    @Test
    public void test_return() throws Exception {
        Dummy dummy = mock(Dummy.class);
        int returnValue = 5;

        // choose your preferred way
        when(dummy.stringLength("dummy")).thenReturn(returnValue);
        doReturn(returnValue).when(dummy).stringLength("dummy");
    }


Use doAnswer() when you want to stub a void method with generic Answer.
Answer specifies an action that is executed and a return value that is returned when you interact with the mock

.. code-block:: java

    // 通过doAnswer获取传递的参数
    @Test
    public void test_answer() throws Exception {
        Dummy dummy = mock(Dummy.class);
        Answer<Integer> answer = new Answer<Integer>() {
            public Integer answer(InvocationOnMock invocation) throws Throwable {
                String string = invocation.getArgumentAt(0, String.class);
                return string.length() * 2;
            }
        };

        // choose your preferred way
        when(dummy.stringLength("dummy")).thenAnswer(answer);
        doAnswer(answer).when(dummy).stringLength("dummy");
    }

verify() times(1)
::::::::::::::::::::

::

    verify 用来验证方法的执行情况，包括次数验证，以及方法是否按照预定的方式进行了执行，
        例如：verify(mockObj).put(anyInt(), eq("hello")) 来验证map中是否put来value为hello的值

    times 用来统计方法的执行次数，看某方法是否按照预定的方式进行了执行


错误记录
::::::::::::

1. This exception may occur if matchers are combined with raw values:
    //incorrect:
    someMethod(anyObject(), "raw String");
    When using matchers, all arguments have to be provided by matchers.
    For example:
    //correct:
    someMethod(anyObject(), eq("String by matcher"));

::

    如果方法中有使用类似any之类的匹配时，那么那么明确的变量应该使用类似ArgumentMatchers.eq(record.getHouseId())这样的
    方法来进行统一匹配
    
    如果都使用变量，那么可以直接使用

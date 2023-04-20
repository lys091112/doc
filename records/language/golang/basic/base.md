# 入门

## 1. 内置类型

int 是个特殊的整形，所占字节与平台有关，在32位机器上占4个字节，在64位机器上在8个字节
uintprt 同上，能hold the pointer, 在32位机器上占4个字节，在64位机器上在8个字节

### 1.1 指针转化

  1. 任何类型的指针都可以被转化为Pointer
  2. Pointer可以被转化为任何类型的指针
  3. uintptr可以被转化为Pointer
  4. Pointer可以被转化为uintptr

所有unsafe.Pointer 是指针和uintprt之间的桥梁, unsafe.Pointer 底层是个int类型

参见demo:
```go
dog := Dog{"little pig"}
dogP := &dog
dogPtr := uintptr(unsafe.Pointer(dogP))

namePtr := dogPtr + unsafe.Offsetof(dogP.name)
nameP := (*string)(unsafe.Pointer(namePtr))
```


## 2. 知识点

### 2.1 方法的访问属性

| 对象 | methodReceivers |
| -- | -- |
| T  | (t T) |
| *T | (t T) (t *T) |

- 值类型的对象只有（t T) 结构的方法，虽然值类型的对象也可以调用(t *T) 方法,是因为底层把T转化为指针类型


| methodReceivers | 对象 |
| -- | -- |
| (t T)  |  T *T |
| (t *T) |  *T |

- 指针类型的receiver 方法实现接口时，只有指针类型的对象实现了该接口

### 2.2 循环依赖的解决方法

1. 新建公共接口包(父包), 将需要循环调用的函数或方法抽象为接口
2. 新建公共组合包(子包), 在组合包中组合调用 
3. 全局存储需要相互依赖的函数, 通过关键字进行调用
```go
import (
    "fmt"
    "reflect"
)
  
var callBackMap map[string]interface{}
  
func init() {
    callBackMap = make(map[string]interface{})
}
  
func RegisterCallBack(key string, callBack interface{}) {
    callBackMap[key] = callBack
}
  
func CallBackFunc(key string, args ...interface{}) []interface{} {
    if callBack, ok := callBackMap[key]; ok {
        in := make([]reflect.Value, len(args))
        for i, arg := range args {
            in[i] = reflect.ValueOf(arg)
        }
        // 通过call调用方法
        outList := reflect.ValueOf(callBack).Call(in)
        result := make([]interface{}, len(outList))
        for i, out := range outList {
            result[i] = out.Interface()
        }
        return result
    } else {
        panic(fmt.Errorf("callBack(%s) not found", key))
    }
}

```
4. 通过消息通知的方式

## 5. 参考链接:
1. [method has pointer receiverd 异常去理解interface机制](https://blog.csdn.net/timemachine119/article/details/54927121)
2.[循环依赖解决](https://www.jb51.net/article/263001.htm)




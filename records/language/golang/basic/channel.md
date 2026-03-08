# channel and select 记录


## 1. 通过代码片段学习使用

### 1.1 等待执行

```go
 // 创建一个未缓冲的channel，元素为零大小的空结构图struct{}
 allDone := make(chan struct{})

 go func() {
    // dosomething
    // 关闭通道,TIP:针对于关闭的通道，所有从该通道读取值的goroutine，都会立即返回一个零值，
    // 也意味着当通道关闭时，所有注册的从该通道读取的goroutine都将收到一个表示通道关闭的信号，即立即返回的零值
    close(allDone)
    // or allDone <- struct{}{}
 }

 for range allDone {
    // 如果allDone是关闭通过，那么每个关闭操作都会让循环迭代一次
    // 如果allDone是发送值，那么只会在第一次接收时执行循环体
 }

```

### 1.2 channel不规范使用导致的死锁或者panic整理
- 向已关闭的channel发送数据,导致panic
```go
 ch := make(chan int)
 close(ch)

 ch <- 1
```

- 重复关闭同一个channel，导致panic
```go
 ch := make(chan int)
 close(ch)
 close(ch) // panic: close of closed channel
```

- 主goruntine等待永远不会达到的channel，导致死锁
```go
   func main() {
      ch := make(chan int)
      <- ch  // 阻塞等待，程序死锁，没有任何其他goruntine会向ch发送数据
   }
```

- 多goruntine互相等待channel，导致死锁
```go
// 两个goruntine互相等待，导致死锁
 func main() {
    ch1 := make(chan int)
    ch2 := make(chan int)
    go func() {
       <- ch2
       ch <- 1
    }()

     go func()  {
      <- ch1
       ch2 <- 1
     }

   select {} // 这句的语法作用是永久等待，不会结束该goruntine
 }
```

- 不正确的读取channel
```go
func main() {
   ch := make(chan int, 2)
   ch <- 1 
   ch <- 2 
   close(ch)
   
   for{
      v := <- ch // 当channel读空后，会无限返回零值，而不是阻塞，导致死循环
      fmt.Println(v)
   }
}

```
#### 1.2.1 正确使用channel的原则
- 遵循"谁创建谁关闭"原则：通常由发送方关闭channel
- 使用带缓冲的channel：可以减少阻塞情况
- 使用select的default case：避免永久阻塞
- 使用context控制超时:
```go
   func main() {
      ctx, cancel := context.WithTimeout(context.Background(), 1*time.Second)
      defer cancel()

      ch := make(chan int)
      go func() {
         time.Sleep(2 * time.Second)
         ch <- 1
      }()

      select {
      case <-ctx.Done():
         fmt.Println("timeout")
      case v := <-ch:
         fmt.Println(v)
      }
   }
```
- 使用select的default case：避免永久阻塞
```go
   func main() {
      ch := make(chan int)
      go func() {
         time.Sleep(2 * time.Second)
         ch <- 1
      }()

      select {
      case v := <-ch:
         fmt.Println(v)
      default:
         fmt.Println("default")
      }
   }
```

### 1.3 select 使用
#### 1.3.1 default 和 time.After的区别
default 是立即返回的非阻塞选择， time.After是固定时间的阻塞（返回值为channel，但是当时间未到时，处理非就绪状态）

- select 的执行规则： 当多个 case 都就绪时，Go 会随机选择一个执行, 当只有一个 case 就绪时，就执行那个 case, 当没有 case 就绪但有 default 时，执行 default
   - 没有``default`` 分支的情况:
      行为：阻塞等待 程序会在 select 处挂起,当前 goroutine 不会轮询检查（不消耗 CPU）,当至少有一个 case 就绪时才会继续执行, 如果所有 goroutine 都这样阻塞会导致死锁错误
   - 有``default`` 分支的情况:
      行为：立即执行default分支，然后执行select之后的部分
- time.After 的特殊性： time.After 返回的是一个 channel,这个 ``channel`` 会在指定时间后收到一个值,在收到值之前，这个  ``case`` 是未就绪状态

通常和 ``for`` 一起使用来实现循环监听
```go
ch := make(chan int)

go func() {
   // do some thing
   ch <- 1
}

select {
   case <-ch:
      fmt.Println("ch")
   case <-time.After(1 * time.Second): // 1秒后才处于就绪状态
      fmt.Println("time.After")
}

// 循环监听
for {
   select {
      case <-ch:
         fmt.Println("ch")
      case <-time.After(1 * time.Second): // 1秒后才处于就绪状态
         fmt.Println("time.After")
   }
}


```
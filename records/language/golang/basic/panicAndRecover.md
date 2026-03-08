# 错误处理

## 1. 处理错误的关键字

- **panic**
    是golang一个内建函数，可以中断原有的控制流程，进入一个令人恐慌的流程中。当函数F调用panic，函数F的执行被中断，但是F中的延迟函数会正常执行，然后F返回到调用它的地方。在调用的地方，F的行为就像调用了panic。这一过程继续向上，直到发生panic的goroutine中所有调用的函数返回，此时程序退出。恐慌可以直接调用panic产生。也可以由运行时错误产生，例如访问越界的数组。

- **Recover**

    是一个内建的函数，可以让进入令人恐慌的流程中的goroutine恢复过来。recover仅在延迟函数中有效。在正常的执行过程中，调用recover会返回nil，并且没有其它任何效果。如果当前的goroutine陷入恐慌，调用recover可以捕获到panic的输入值，并且恢复正常的执行

- **defer**

    类似与java的finally,在程序结束之后执行(是否影响结果的返回值??)

## 2. panic的使用

- panic 只能在自己的goroutine中被recover，无法被父goroutine捕获

在改示例中G2产生的panic无法被G1捕获，因为G2是G1的子goroutine，G2产生的panic只能被G2捕获,从而导致传递到main，然后程序崩溃
```go
func main() {
    // Main GoRoution
	go func() {
        // G1 GoRoution
		defer func() { 
			if err := recover(); err != nil {
				fmt.Println("panic2", err)
			}
		}()
		go func() {
        // G2 GoRoution
			err = func() error {
				panic("panic test")
			}()
			if err != nil {
				fmt.Println("panic func", err)
			}
		}()
		time.Sleep(5 * time.Second)
		fmt.Println("panic func end")
	}()
    time.Sleep(10 * time.Second)
    fmt.Println("main end")
}
// output:
// panic test 
// 程序崩溃
```

因此，如果需要捕获panic，需要在panic的goroutine中捕获，然后转化为error暴露给父goroutine

Q1： 为什么不运行父goroutine捕获子goroutine的panic
A1: 
  - 并发模型的核心原则：隔离性
    独立执行单元：Goroutine 被设计为轻量级的独立执行单元，每个都有自己独立的调用栈
    失败隔离：一个 goroutine 的失败不应直接导致其他 goroutine 失败
  - 错误应该被显式处理，而不是通过隐式传播; panic 是真正的异常，应该只用于不可恢复的错误; 常规错误应该通过返回值 (error 类型) 处理
  - 允许跨 goroutine 捕获 panic会导致错误路径不清晰，资源难清理以及死锁风险
  - 鼓励使用recover+channel来处理panic
    ```go
    func main() {
        errCh := make(chan error)
        
        go func() {
            defer func() {
                if r := recover(); r != nil {
                    errCh <- fmt.Errorf("panic: %v", r)
                }
            }()
            // 业务逻辑
        }()
        
        if err := <-errCh; err != nil {
            // 处理错误
        }
    }
    ```
Q2: 既然父goroutine无法捕获子goroutine的panic，会不会导致每个子goroutine都都必须自己捕获panic，这样会导致代码冗余
A2: 技术上讲每个 goroutine 都需要自己的 panic 恢复机制，但通过良好的封装设计，我们可以避免在业务代码中"到处都是 recover" ,例如：
```go

// 带错误返回的安全启动函数
func SafeGoWithError(fn func() error, errCh chan<- error) {
	go func() {
		defer func() {
			if r := recover(); r != nil {
				err := fmt.Errorf("panic: %v", r)
				errCh <- err
			}
		}()
		
		if err := fn(); err != nil {
			errCh <- err
		}
	}()
}

// 全局错误处理中心
type ErrorHandler func(error)

var globalErrorHandler ErrorHandler

func SetGlobalErrorHandler(handler ErrorHandler) {
    globalErrorHandler = handler
}

// 安全启动 goroutine 的封装函数
func SafeGo(fn func()) {
    go func() {
        defer func() {
            if r := recover(); r != nil {
                if globalErrorHandler != nil {
                    globalErrorHandler(fmt.Errorf("%v", r))
                }
            }
        }()
        fn() // 执行业务逻辑
    }()
}
```
Q3: 在网上查资料时经常会有这种说法：panic只影响本goroutine，不影响其他goroutine，，这种说法是否正确
A3：严格来讲，当一个 goroutine 被 panic 时，它会立即终止,只要该goroutine捕获并处理该panic，不引起上游的恐慌，那么就不会影响其他的goroutine，其他 goroutine 仍然可以继续执行。 但是，如果该goroutine的恐慌没有被捕获或处理，那么它将导致整个程序崩溃，从而影响其他 goroutine 的执行。

### 2.1 errgroup示例

在该示例中中，errgroup的panic无法被父goroutine捕获，因此程序崩溃,因为 errgroup的Do方法内部并没有对panic进行recover，因此需要业务放自己对出来进行recover捕获
```go
func main() {
    go func() {
		defer func() {
			if err := recover(); err != nil {
				fmt.Println("panic1", err)
			}
		}()
		g := new(errgroup.Group)
        // 内部未捕获panic
		g.Go(func() error {
			panic("errgroup panic")
		})

		g.Go(func() error {
			fmt.Println("errgroup func")
			return nil
		})
		err := g.Wait()
		if err != nil {
			fmt.Println("errgroup err", err)
		}

	}()

	i := 10
	for i < 20 {
		time.Sleep(1 * time.Minute)
		fmt.Println("index ")
	}
}

```

### 2.2 OnceFunc双重panic的作用

defer中的panic 用于输出当时的对象汗信息,第二次之后的执行,因为 once.Do已执行过,所以直接返回panic
```go
// If f panics, the returned function will panic with the same value on every call.
func OnceFunc(f func()) func() {
	var (
		once  Once
		valid bool
		p     any
	)
	g := func() {
		defer func() {
			p = recover() // recover 返回的是 panic 传入的值（interface{} 类型），不包含堆栈信息。堆栈信息由 panic 机制本身在触发时记录和输出。
			if !valid {
				// Re-panic immediately so on the first call the user gets a
				// complete stack trace into f. 即打印原始的堆栈信息
				panic(p)
			}
		}()
		f()
		f = nil      // Do not keep f alive after invoking it.
		valid = true // Set only if f does not panic.
	}
	return func() {
		once.Do(g)
		// 用于保证第二次执行时,直接保留原始的panic
		if !valid {
			panic(p)
		}
	}

```
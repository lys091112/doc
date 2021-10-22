# Go 学习中的疑问

### 1. 为什么类似byte.Buffer 这样的结构体不需要初始化

```
As you can see here(http://golang.org/src/pkg/bytes/buffer.go?s=402:854#L7) Buffer consists just of some ints, the buf slice and some arrays. All of them need no initialization, since go has zero values(http://golang.org/ref/spec#The_zero_value).

You can read more about slices and arrays and how they work here(http://blog.golang.org/go-slices-usage-and-internals).

It is initialized. When you do not specifically initialize a variable, go will initialize it to its zero value. That means all the internal fields of a bytes.Buffer gets the value 0, or similar for the relevant types (e.g. nil for pointers).

The authors then implemented bytes.Buffer so all values being 0 is a meaningful starting point(It means an empty buffer(http://golang.org/pkg/bytes/#Buffer)), so programmers doesn't need to explicitly initialize it in order to start using a Buffer.

This due to the fact that when you call the Fprintf method, the bytes.Buffer.Write method is implicitely called, and as per the doc(https://golang.org/pkg/bytes/#Buffer.Write):

Write appends the contents of p to the buffer, growing the buffer as needed.

If you look at the source code, Write calls the grow function: func (b *Buffer) grow(n int) int.

This function recognizes that the buffer is empty, because it assumes that an empty buffer has 0 values for its internal fields, which is actually how a bytes.Buffer structure is initialized by default, just like every structure in go.
```
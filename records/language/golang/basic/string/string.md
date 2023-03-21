# 字符串

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->


## 1. 字符串常用的6种拼接方式
- ``+`` 拼接
- ``string.join(...)`` 拼接
- ``string.Builder``
- ``fmt.Sprintf("...") ``
- ``bytes.Buffer ``

性能对比下，预分配的``string.Builder`` 性能表现最好，其次是 ``join``。 一般简单的情况可以直接使用 ``+``

## 2. 实现原理对比 

### 2.1 string的定义

string类型本质上就是一个byte类型的数组，在Go语言中string类型被设计为不可变的. 尽管不可变，但是可以被替换，因为stringStruct中的str指针是可以改变的，只是指针指向的内容是不可以改变的，也就说每一个更改字符串，就需要重新分配一次内存，之前分配的空间会被gc回收
```go

// builtin/builtin.go
// string is the set of all strings of 8-bit bytes, conventionally but not
// necessarily representing UTF-8-encoded text. A string may be empty, but
// not nil. Values of string type are immutable.
type string string

// runtime/string.go
type stringStruct struct {
	str unsafe.Pointer
	len int
}

// 字符串的拷贝
//go:nosplit
func gostringnocopy(str *byte) string {
	ss := stringStruct{str: unsafe.Pointer(str), len: findnull(str)}
	s := *(*string)(unsafe.Pointer(&ss))
	return s
}

```

### 2.2 string.join(...)

底层实现是基于strings.Builder 

### 2.3 strings.Buider

buf字段是一个byte类型的切片，这个就是用来存放字符串内容的，提供的writeString()方法就是像切片buf中追加数据
, 提供的String方法就是将[]]byte转换为string类型，这里为了避免内存拷贝的问题，使用了强制转换来避免内存拷贝
```go
type Builder struct {
    addr *Builder // of receiver, to detect copies by value
    buf  []byte // 1
}

func (b *Builder) WriteString(s string) (int, error) {
 b.copyCheck()
 b.buf = append(b.buf, s...)
 return len(s), nil
}

func (b *Builder) String() string {
 return *(*string)(unsafe.Pointer(&b.buf))
}

```

### 2.4  bytes.Buffer

bytes.Buffer可以持续向Buffer尾部写入数据，从Buffer头部读取数据，所以off字段用来记录读取位置，再利用切片的cap特性来知道写入位置，这个不是本次的重点，重点看一下WriteString方法是如何拼接字符串的

切片在创建时并不会申请内存块，只有在往里写数据时才会申请，首次申请的大小即为写入数据的大小。如果写入的数据小于64字节，则按64字节申请。采用动态扩展slice的机制，字符串追加采用copy的方式将追加的部分拷贝到尾部，copy是内置的拷贝函数，可以减少内存分配。

但是在将[]byte转换为string类型依旧使用了标准类型，所以会发生内存分配


因此buffer虽然性能不如Builder性能高，但是在资源的复用上会是更合适的数据结构

```go
type Buffer struct {
 buf      []byte // contents are the bytes buf[off : len(buf)]
 off      int    // read at &buf[off], write at &buf[len(buf)]
 lastRead readOp // last read operation, so that Unread* can work correctly.
}

func (b *Buffer) WriteString(s string) (n int, err error) {
 b.lastRead = opInvalid
 m, ok := b.tryGrowByReslice(len(s))
 if !ok {
  m = b.grow(len(s))
 }
 return copy(b.buf[m:], s), nil
}

func (b *Buffer) String() string {
 if b == nil {
  // Special case, useful in debugging.
  return "<nil>"
 }
 return string(b.buf[b.off:])
}

```

### 2.5 fmt.Sprintf

 基于反射，性能不高


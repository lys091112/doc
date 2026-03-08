# 范型和反射

## 1. 范型

### 1.1 范型方法的解读
```go
func BinarySearchFunc[S ~[]E, E, T any](x S, target T, cmp func(E, T) int) (int, bool)
```
- 类型参数列表 [S ~[]E, E, T any]：
    S ~[]E：这表示S是一个切片类型，其元素类型为E。~符号用于指定S必须是一个切片。
    E：表示切片中的元素类型。
    T：表示目标值的类型，可以是任何类型（any）。

- 参数列表 (x S, target T, cmp func(E, T) int)：
    x S：这是一个类型为S的切片，即元素类型为E的切片。
    target T：这是我们要在切片x中搜索的目标值，其类型为T。
    cmp func(E, T) int： 比较函数，用于比较切片元素的大小，通常： ``返回-1表示E < T; 返回0表示E == T;返回1表示E > T``

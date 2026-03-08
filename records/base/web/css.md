# 属性记录


- opacity 透明级别 取值从 0 到 1.0(完全不透明)

- css transform 是一个用于对元素进行 2D 或 3D 几何变换 的属性，常用于实现动画、交互效果和布局微调
2D变化：
| 函数                                | 说明          | 示例                           |
| --------------------------------- | ----------- | ---------------------------- |
| `translate(x, y)`                 | 平移          | `translate(50px, -20px)`     |
| `translateX(x)` / `translateY(y)` | 单轴平移        | `translateX(100px)`          |
| `scale(x, y)`                     | 缩放          | `scale(1.5, 0.5)`            |
| `scaleX(x)` / `scaleY(y)`         | 单轴缩放        | `scaleX(2)`                  |
| `rotate(angle)`                   | 旋转（顺时针）     | `rotate(45deg)`              |
| `skew(x-angle, y-angle)`          | 倾斜          | `skew(30deg, 10deg)`         |
| `skewX(angle)` / `skewY(angle)`   | 单轴倾斜        | `skewX(-20deg)`              |
| `matrix(a, b, c, d, e, f)`        | 2D 变换矩阵（高级） | `matrix(1, 0.3, 0, 1, 0, 0)` |

3D:
| 函数                                                     | 说明            | 示例                         |
| ------------------------------------------------------ | ------------- | -------------------------- |
| `translate3d(x, y, z)`                                 | 3D 平移         | `translate3d(0, 0, 100px)` |
| `scale3d(x, y, z)`                                     | 3D 缩放         | `scale3d(1, 1, 2)`         |
| `rotateX(angle)` / `rotateY(angle)` / `rotateZ(angle)` | 绕轴旋转          | `rotateX(45deg)`           |
| `rotate3d(x, y, z, angle)`                             | 绕任意向量旋转       | `rotate3d(1, 1, 0, 45deg)` |
| `perspective(n)`                                       | 透视深度（通常写在父元素） | `perspective: 800px`       |

- css transition 是一个用于创建平滑过渡效果的属性，常用于实现动画、交互效果和布局微调
| 属性名                  | 说明                                       | 示例                           |
| --------------------- | ---------------------------------------- | ---------------------------- |
| `transition-property` | 指定要应用过渡效果的 CSS 属性               | `transition-property: width;` |
| `transition-duration` | 指定过渡效果的持续时间                      | `transition-duration: 0.5s;`  |
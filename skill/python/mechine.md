# 


- pandas 中的series对象可以使用 series == 0 返回另一个series，而不是一个bool，这是什么原理
```
python __eq__ 相当于重写 ‘==’，通过这样的方式来控制执行
详情参考：pandas -> ops.py:120


```

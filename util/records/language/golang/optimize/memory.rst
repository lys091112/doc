.. highlight: rst

.. _records_language_golang_optimize_memory:

内存相关优化
===============

Golang同一struct中field的书写顺序不同内存分配大小也会不同。因为struct内field内存分配是以4B为基础，超过4B时必须独占

.. code-block:: go

    // 首先第1个4B中放入a，a是bool型，占用1B，剩余3B
    // b是uint32，占用4B，剩余3B放不下，所以offset到下一个4B空间，这时我们会发现3B没有放东西，被浪费了
    // A1要占用28B的空间
    type A1 struct {
        a bool
        b uint32
        c bool
        d uint32
        e uint8
        f uint32
        g uint8
    }

    // 优化模型
    // 首先第1个4B中放入a，a是bool型，占用1B，剩余3B
    // c是bool，占用1B，放入后剩余2B
    // d是uint8，占用1B，放入后剩余1B
    // 依次分配
    type A2 struct {
        a bool
        c bool
        e uint8
        g uint8
        b uint32
        d uint32
        f uint32
    }

    // 详细demo 可参考： gopair/basic/unsafe_demo.go



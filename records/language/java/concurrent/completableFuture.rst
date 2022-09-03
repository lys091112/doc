.. highlight:: rst

.. _records_language_java_concurrent_completableFuture:

CompletableFuture 源码分析
==============================

基本方法
:::::::::

.. code-block:: java

    // 方法执行完时调用通知相依赖的其他future
    final void postComplete() {
        /*
         * 1. 如果当前future的栈不为空
           2. f不为 this.代表f任务没有完成，就不去激活与f相关联的任务，此时再检测 h = (f=this).stack) 即仍检测
                         当前的this.stack是否为空，如果不为空，那么遍历其他与this相关性的任务
         * 任务的链式结构为：

          completableFuture --> completion -------> completion C -------------> completion F
         *                         |                    |                         |
         *                         |                    |                         |
         *                         CF                   CF                        CF 
         *                         |                    |                         |
         *                         |                    |                         |
         *                         completion  A       completion    D         completion G
         *                         |                    |                         |
         *                         |                    |                         |
         *                         completion  B       completion    E         completion I
         *
         *
         * 如果C没有完成，那么执行到D后，会返回D的future，此时不会去检测E，而是直接检测F所在的completion并执行
         *
         */
        CompletableFuture<?> f = this; Completion h;
        while ((h = f.stack) != null ||
               (f != this && (h = (f = this).stack) != null)) {
            CompletableFuture<?> d; Completion t;
            // 设置队头元素
            if (f.casStack(h, t = h.next)) {
                if (t != null) {
                    // 如果f 不是当前任务直接关联的future，那么放入队列
                    if (f != this) {
                        pushStack(h);
                        continue;
                    }
                    h.next = null;    // detach
                }
                // 针对于NESTED， 如果h任务完成的话，那么返回 null
                // 如果任务没有完成，那么返回的是h任务自身
                f = (d = h.tryFire(NESTED)) == null ? this : d;
            }
        }
    }



thenAccept、 thenAcceptSync
::::::::::::::::::::::::::::

.. code-block:: java

   public CompletableFuture<Void> thenAccept(Consumer<? super T> action) {
       return uniAcceptStage(null, action);
   }

   private CompletableFuture<Void> uniAcceptStage(Executor e,
                                              Consumer<? super T> f) {
       if (f == null) throw new NullPointerException();
       CompletableFuture<Void> d = new CompletableFuture<Void>();
       // 如果任务赢完成，那么直接返回d(在uniAccept中已经填充结果值）
       if (e != null || !d.uniAccept(this, f, null)) {
           // 如果任务没有完成，那么创建任务关联对象
           // dep 为依赖值， src为被以来值，需要src想执行完在执行dep
           UniAccept<T> c = new UniAccept<T>(e, d, this, f);
           // 将c放置到当前comletablefuture的链表首部，创建依赖关系，用于当前任务完成时，钩子回调c
           push(c);
           // 检测c任务是否可以执行，用于当在push(c)过程中，任务已经完成，由于还没有放入创建依赖，而造成没有被调用
           // 此时 手动调用c是否检测是否可以被执行. 其中postFire用来执行通知相互依赖的其他任务执行
           c.tryFire(SYNC);
       }
       return d;
   }

   // 用于检测任务是否完成，并执行相应的consumer函数
   final <S> boolean uniAccept(CompletableFuture<S> a,
                            Consumer<? super S> f, UniAccept<S> c) {
        Object r; Throwable x;
        // 如果a（this) 没有完成，那么直接返回
        if (a == null || (r = a.result) == null || f == null)
            return false;
        tryComplete: if (result == null) {
            // 检测是否是异常结束
            if (r instanceof AltResult) {
                if ((x = ((AltResult)r).ex) != null) {
                    completeThrowable(x, r);
                    break tryComplete;
                }
                r = null;
            }
            try {
                // 这是检测，当非异步模式下，需要检测该任务是否已经执行过了
                // 如果已经执行过，那么直接返回
                if (c != null && !c.claim())
                    return false;
                @SuppressWarnings("unchecked") S s = (S) r;
                // 执行正常流程，并填充complete值
                f.accept(s);
                completeNull();
            } catch (Throwable ex) {
                completeThrowable(ex);
            }
        }
        return true;
   }


参考文档： https://www.cnblogs.com/aniao/p/aniao_cf.html

.. highlight:: rst

.. _records_bigdata_hadoop_yarn-base:

yarn
-------------

Yarn的调度过程
==================

（1） 创建一个YarnClient对象并start它，然后Client可以设置ApplicationContext，然后向ResourceManager提交Application。

（2）RM向NM发出指令，为该App启动第一个Container，并在其中启动ApplicationMaster

（3）AM向RM注册

（4）AM采用轮询的方式向RM的YARN Scheduler申请资源

（5）当AM申请到资源后（即获取到了空闲节点的信息），与NodeManagers通信（多个NodeManager），请求启动计算任务

（6）NodeManagers根据资源量的大小、所需的运行环境，在Container中启动任务。

（7）各个任务向AM汇报自己的状态和进度，以便AM掌握各个任务的执行情况

（8）APP运行完成后，AM向RM注销并关闭自己。

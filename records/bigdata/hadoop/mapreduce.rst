.. highlight:: rst

.. _records_bigdata_hadoop_mapreduce:

Map Reduce 使用
-----------------


Tip：

    1. ``Mapper`` 的初始 ``key`` 是以文件的偏移作为 ``LongWritable`` ,在处理完 ``mapper`` 后，可以自定义自己的key，用于后面的shffle操作
    2. Key 必须继承自 ``WritableComparable`` ,用于后期key的sort操作，而value则必须继承 ``Writable`` 接口

Mapper
=======


Combiner
===========

使用Combiner，那么必须是和Reducer可并的关系，即返回值要相互一致。

Reducer
=========


FileInputFormat 文件数据导入和分割
=====================================

    FileInputFormat提供了三个属性参数来控制实际的分片大小：mapreduce.input.fileinputformat.split.minsize, mapreduce.input.fileinputformat.split.maxsize以及dfs.blocksize。 这三个参数分别表示一个文件分片最小的有效字节数、最大字节数以及HDFS中块的大小。
    利用公式splitSize = max(minimumSize, min(maximumSize, blockSize))，可以通过改变上述三个参数来调节最终的分片大小



CombineFileInputFormat
::::::::::::::::::::::::::

CombineFileInputFormat的大致原理是，他会将输入多个数据文件（小文件）的元数据全部包装到CombineFileSplit类里面。也就是说，因为小文件的情况下，在HDFS中都是单Block的文件，即一个文件一个Block，一个CombineFileSplit包含了一组文件Block，包括每个文件的起始偏移（offset），长度（length），Block位置（localtions）等元数据。如果想要处理一个CombineFileSplit，很容易想到，对其包含的每个InputSplit（实际上这里面没有这个，你需要读取一个小文件块的时候，需要构造一个FileInputSplit对象）。
在执行MapReduce任务的时候，需要读取文件的文本行（简单一点是文本行，也可能是其他格式数据）。那么对于CombineFileSplit来说，你需要处理其包含的小文件Block，就要对应设置一个RecordReader，才能正确读取文件数据内容。通常情况下，我们有一批小文件，格式通常是相同的，只需要在为CombineFileSplit实现一个RecordReader的时候，内置另一个用来读取小文件Block的RecordReader，这样就能保证读取CombineFileSplit内部聚积的小文件


错误记录
===========


1.  NoSuchMethodException: org.apache.hadoop.io.ArrayWritable.<init>()

使用ArrayWritable进行Map/Reduce的数组传递时，出现以上错误

问题分析： hadoop本身没有提供对ArrayWritable默认的构造函数函数。不过，由于提供了有参的构造函数，我们可以继承ArrayWritable类，实现基于该类的其他数组子类。以字符串数组ArrayWritable为例，可以用以下方法：

- 构造自定义子类TextArrayWritable，继承于ArrayWritable：

.. code-block:: java

    public class TextArrayWritable extends ArrayWritable{
     public TextArrayWritable() {
      super(Text.class);  // 这里，根据自己要实现的数组类型，填入对应实现了writable接口的类型，比方说IntWritable
     }
    }

    /**
        使用的时候需要先取出为Writable数组，然后在获取数组中的元素的时候则可以使用类型转化，转化为自己使用的类
        Writable[] texts = finalValueOut.get();
        OpType opType = OpType.getOptype(((Text)texts[1]).toString())
    */

- 在代码中将ArrayWritable替换为TextArrayWritable


2. 传递路径时，传多个路径需要自己手动解析


3. 生成hadoop文件后，可以使用 load data inpath 'xxx' into 'xxx' 进入到hive表中

.. code-block:: sql

    load data inpath 'hdfs://xxx/*.lzo' into table ${tablename} partition (xxxx);

4. 可以在执行时，通过上下文context获取当前的执行文件o

   # 获取执行文件名称
   (FileSplit) context.getInputSplit()).getPath().getName()
   
   # 获取上上级目录
   (FileSplit) context.getInputSplit()).getPath().getParent().getParent().getName()

5. 如果输入的目录包含多级目录，默认mapper是不会读取多级目录
   添加该参数： mapreduce.input.fileinputformat.input.dir.recursive=true 可以读取多级目录

6. 在reducer中，reduce方法使用的参数 ``Iterable<V>`` 以及 ``V`` 使用的对象一直是同一个。每一次的循环，都会将这两个对象重新初始化并填充下一个将要处理的对象数据， 因此如果在 ``Reducer`` 中使用了这两个对象的数据，那么一定要使用这两个数据的镜像copy，不然可能会造成数据一致的问题

.. code-block:: java

    /** demo code
     * 场景描述： 在一个月内，对于同一个key，取logTime最新的一条数据。  
     * 假如对于同一个key，有多条数据记录，如果直接使用finalValueOut = v,那么由于v是个对象引用，而且随着values的遍历，会不停的刷新v的值，
       这样就造成了finalValueout不停的变化,知道最后一条，然后被sink处理掉
     */
    public void reduce(Text key, Iterable<TextArrayWritable> values, Context context) throws IOException, InterruptedException {
        TextArrayWritable finalValueOut = new TextArrayWritable();
        long maxTime = 0;

        for (TextArrayWritable v : values) {
            Writable[] valueIn = v.get();
            long logTime = Long.parseLong(((Text) valueIn[0]).toString());
            if (finalValueOut == null || maxTime < logTime ||
                (maxTime == logTime && OpType.getEnum(((Text) valueIn[1]).toString()) == OpType.DELETE)) {
                finalValueOut = v;
                maxTime = logTime;
            }
        }
        
        // sink
    }
    

    // 修改如下
    public void reduce(Text key, Iterable<TextArrayWritable> values, Context context) throws IOException, InterruptedException {
        TextArrayWritable finalValueOut = new TextArrayWritable();
        long maxTime = 0;

        for (TextArrayWritable v : values) {
            Writable[] valueIn = v.get();
            long logTime = Long.parseLong(((Text) valueIn[0]).toString());
            if (finalValueOut == null || maxTime < logTime ||
                (maxTime == logTime && OpType.getEnum(((Text) valueIn[1]).toString()) == OpType.DELETE)) {
                copyWritable(v,finalValueOut);
                maxTime = logTime;
            }
        }
        
        // sink
    }

    private void copyWritable(TextArrayWritable source, TextArrayWritable target) {
        Writable[] sourceValueIn = source.get();
        Writable[] targetValueIn = target.get();
        if (targetValueIn == null) {
            targetValueIn = new Text[sourceValueIn.length];
            target.set(targetValueIn);
        }
        for (int i = 0; i < sourceValueIn.length; i++) {
            targetValueIn[i] = sourceValueIn[i];
        }
    }



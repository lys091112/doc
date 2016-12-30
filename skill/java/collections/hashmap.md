# HashMap

1. **HashMap为什么是非线性安全的**
当存在多个线程同时操作map时，可能会出现死循环异常。
```java
    // 在jdk7中当map进行数据扩容时，代码如下：
    public void transfer(Entry[] newTable) {
        Entry[] src = table;                   //src引用了旧的Entry数组
        int newCapacity = newTable.length;
        for (int j = 0; j < src.length; j++) { //遍历旧的Entry数组
            Entry<K,V> e = src[j];             //取得旧Entry数组的每个元素
            if (e != null) {
                src[j] = null;//释放旧Entry数组的对象引用（for循环后，旧的Entry数组不再引用任何对象）
                do {
                    Entry<K,V> next = e.next;
                    int i = indexFor(e.hash, newCapacity); //！！重新计算每个元素在数组中的位置
                    e.next = newTable[i]; //标记[1]
                    newTable[i] = e;      //将元素放在数组上
                    e = next;             //访问下一个Entry链上的元素
                } while (e != null);
            }
        }
    }
    
    //测试代码
    public class HashMapInfiniteLoop {  
        private static HashMap<Integer,String> map = new HashMap<Integer,String>(2，0.75f);  
        public static void main(String[] args) {  
            map.put(5， "C");  
     
            new Thread("Thread1") {  
                public void run() {  
                    map.put(7, "B");  
                    System.out.println(map);  
                };  
            }.start();  
            new Thread("Thread2") {  
                public void run() {  
                    map.put(3, "A);  
                    System.out.println(map);  
                };  
            }.start();        
        }  
    }
```
问题分析：
    当thread1，thread2执行到transfer->Entry<K,V> next = e.next时，断住threa1,让thread2执行，此时

    ![logo](./logo.png)

    ![cmd-markdown-logo](https://www.zybuluo.com/static/img/logo.png)

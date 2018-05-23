# Kafka Stream 的使用过程

## 基础命令

- 创建topic
```
sh kafka-topics.sh --create --zookeeper zookeeper:2181 --replication-factor 1 --partitions 1 --topic alert-output
```   

- 查询topic中的聚合数据

```
sh kafka-console-consumer.sh --zookeeper zookeeper:2181 \
    --topic alert-output --from-beginning \ 
    --formatter kafka.tools.DefaultMessageFormatter --property print.key=true \
    --property key.deserializer=org.apache.kafka.common.serialization.StringDeserializer \
    --property value.deserializer=org.apache.kafka.common.serialization.LongDeserializer
```

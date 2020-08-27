
```mysql

127.0.0.1:6379>
127.0.0.1:6379> set s 'binary safe string'
OK
127.0.0.1:6379> get s
"binary safe string"
127.0.0.1:6379> APPEND s ', append'
(integer) 26
127.0.0.1:6379> get s
"binary safe string, append"
127.0.0.1:6379> set s1 's1'
OK
127.0.0.1:6379> set s2 's2'
OK
127.0.0.1:6379> MGET s s1 s2
1) "binary safe string, append"
2) "s1"
3) "s2"
127.0.0.1:6379> TYPE s
string
127.0.0.1:6379> exists s
(integer) 1
127.0.0.1:6379> RENAME s s0
OK
127.0.0.1:6379> MGET s0 s1 s2
1) "binary safe string, append"
2) "s1"
3) "s2"





```

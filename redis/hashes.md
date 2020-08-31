```bash
127.0.0.1:6379> hset h0 book:3 name 'cats'
(error) ERR wrong number of arguments for 'hset' command
127.0.0.1:6379> hset  book:3 name 'cats'
(integer) 1
127.0.0.1:6379> hget book:3 name
"cats"
127.0.0.1:6379> hmset book:4 name 'slaughterhous' author 'betty'
OK
127.0.0.1:6379> hmget book:4 name author
1) "slaughterhous"
2) "betty"
127.0.0.1:6379> hgetall book:4
1) "name"
2) "slaughterhous"
3) "author"
4) "betty"
127.0.0.1:6379> HEXISTS Book:4 copyrigh
(integer) 0
127.0.0.1:6379> hlen book:4
(integer) 2
127.0.0.1:6379> TYPE book:4
hash
127.0.0.1:6379>

```
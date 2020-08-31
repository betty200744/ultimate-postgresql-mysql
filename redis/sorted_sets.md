
* 因为是set， 所有value unique
* scope可相同， 相同情况下， 按照string排序新增
* value存在， scope不同， 则update scope

```mysql

127.0.0.1:6379>
127.0.0.1:6379> ZADD zs1 1 "a"
(integer) 1
127.0.0.1:6379> ZRANGE zs1 0 -1
1) "a"
127.0.0.1:6379> ZADD zs1 1 "a"
(integer) 0
127.0.0.1:6379> ZRANGE zs1 0 -1
1) "a"
127.0.0.1:6379> ZADD zs1 1 "b"
(integer) 1
127.0.0.1:6379> ZRANGE zs1 0 -1
1) "a"
2) "b"
127.0.0.1:6379> ZRANGEBYSCORE zs1 0 -1
(empty list or set)
127.0.0.1:6379>
127.0.0.1:6379> ZRANGE zs1 0 -1 withscores
1) "a"
2) "1"
3) "b"
4) "1"
127.0.0.1:6379> ZADD zs1 1 "c"
(integer) 1
127.0.0.1:6379> ZRANGE zs1 0 -1 withscores
1) "a"
2) "1"
3) "b"
4) "1"
5) "c"
6) "1"
127.0.0.1:6379> ZADD zs1 2 "aa"
(integer) 1
127.0.0.1:6379> ZADD zs1 2 "bb"
(integer) 1
127.0.0.1:6379> ZADD zs1 2 "cc"
(integer) 1
127.0.0.1:6379> ZRANGE zs1 0 -1 withscores
 1) "a"
 2) "1"
 3) "b"
 4) "1"
 5) "c"
 6) "1"
 7) "aa"
 8) "2"
 9) "bb"
10) "2"
11) "cc"
12) "2"
127.0.0.1:6379> ZADD zs1 5 "aaaaa"
(integer) 1
127.0.0.1:6379> ZRANGE zs1 0 -1 withscores
 1) "a"
 2) "1"
 3) "b"
 4) "1"
 5) "c"
 6) "1"
 7) "aa"
 8) "2"
 9) "bb"
10) "2"
11) "cc"
12) "2"
13) "aaaaa"
14) "5"
127.0.0.1:6379> ZADD zs1 4 "aaaa"
(integer) 1
127.0.0.1:6379> ZRANGE zs1 0 -1 withscores
 1) "a"
 2) "1"
 3) "b"
 4) "1"
 5) "c"
 6) "1"
 7) "aa"
 8) "2"
 9) "bb"
10) "2"
11) "cc"
12) "2"
13) "aaaa"
14) "4"
15) "aaaaa"
16) "5"
127.0.0.1:6379> ZADD zs1 4 "bbb"
(integer) 1
127.0.0.1:6379> ZRANGE zs1 0 -1 withscores
 1) "a"
 2) "1"
 3) "b"
 4) "1"
 5) "c"
 6) "1"
 7) "aa"
 8) "2"
 9) "bb"
10) "2"
11) "cc"
12) "2"
13) "aaaa"
14) "4"
15) "bbb"
16) "4"
17) "aaaaa"
18) "5"
127.0.0.1:6379> ZADD zs1 1 "au"
(integer) 1
127.0.0.1:6379> ZRANGE zs1 0 -1 withscores
 1) "a"
 2) "1"
 3) "au"
 4) "1"
 5) "b"
 6) "1"
 7) "c"
 8) "1"
 9) "aa"
10) "2"
11) "bb"
12) "2"
13) "cc"
14) "2"
15) "aaaa"
16) "4"
17) "bbb"
18) "4"
19) "aaaaa"
20) "5"

```

* Lists: collections of string elements sorted according to the order of insertion. They are basically linked lists.
* 本质是一个linked list

```bash
127.0.0.1:6379> lpush l0 1
(integer) 1
127.0.0.1:6379> linsert l0 before 1 0
(integer) 2
127.0.0.1:6379> linsert l0 after 1 2
(integer) 3
127.0.0.1:6379> lrange l0 0 -1
1) "0"
2) "1"
3) "2"
127.0.0.1:6379> RPUSH l0 3
(integer) 4
127.0.0.1:6379> RPUSH l0 3
(integer) 5
127.0.0.1:6379> lrange l0 0 -1
1) "0"
2) "1"
3) "2"
4) "3"
5) "3"
127.0.0.1:6379> lset l0 6 6
(error) ERR index out of range
127.0.0.1:6379> lset l0 4 4
OK
127.0.0.1:6379> lrange l0 0 -1
1) "0"
2) "1"
3) "2"
4) "3"
5) "4"
127.0.0.1:6379> lindex l0 4
"4"
127.0.0.1:6379> TYPE l0
list

```
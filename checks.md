# ClickHouse и проверки PostgreSQL / Redis

## ClickHouse

- Web GUI доступен на порту `:8123`

---

## Проверки PostgreSQL

```sql
app=# \l
                                                List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    | ICU Locale | Locale Provider |   Access privileges
-----------+----------+----------+------------+------------+------------+-----------------+-----------------------
 app       | postgres | UTF8     | en_US.utf8 | en_US.utf8 |            | libc            |
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |            | libc            |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 |            | libc            | =c/postgres          +
           |          |          |            |            |            |                 | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 |            | libc            | =c/postgres          +
           |          |          |            |            |            |                 | postgres=CTc/postgres
(4 rows)

app=# \c app
You are now connected to database "app" as user "postgres".

app=# \dt
         List of relations
 Schema |  Name  | Type  |  Owner
--------+--------+-------+----------
 public | market | table | postgres
(1 row)

app=# SELECT * FROM market LIMIT 10;
    id    | symbol |  price  |             ts
----------+--------+---------+----------------------------
 bitcoin  | btc    |  116227 | 2025-07-25 17:20:48.642729
 ethereum | eth    | 3639.94 | 2025-07-25 17:20:48.642729
```

---

## Проверки Redis

```bash
root@255423:~# docker exec -it redis redis-cli
127.0.0.1:6379> keys *
1) "coin:ethereum"
2) "coin:bitcoin"

127.0.0.1:6379> HGETALL coin:bitcoin
1) "symbol"
2) "btc"
3) "price"
4) "116227"

127.0.0.1:6379> HGETALL coin:ethereum
1) "symbol"
2) "eth"
3) "price"
4) "3639.94"
```

---

## Примечания

- Добавлено **три self-hosted runner-а** для ускорения деплоя.
- Удалены **main.tf**, **providers.tf**, **outputs.tf** из корня fork, в виду ненадобности, так как запуск из github actions использует именно поддиректории `run: terraform -chdir=${{ matrix.path }} fmt -check -recursive`



host=127.0.0.1
port=3306
user="sysbench"
password="sysbench@123"
table_size=100000
tables=10
rate=20
ps_mode='disable'
threads=1
events=0
time=5
trx=100
path=$PWD
counter=1

sysbench --test=cpu run


IN Mysql User:
================
CREATE USER 'sysbench'@'%' IDENTIFIED BY 'sysbench@123';
GRANT ALL PRIVILEGES ON *.* to 'sysbench'@'%';
flush privileges;


Sysbench testing on MySQL
==========================
/usr/share/sysbench/oltp_read_write.lua --db-driver=mysql --events=$events --threads=$threads --time=$time --mysql-host=127.0.0.1 --mysql-user=$user --mysql-password=$password --mysql-port=$port --report-interval=1 --skip-trx=on --tables=$tables --table-size=$table_size --rate=$rate --delete_inserts=$trx --order_ranges=$trx --range_selects=on --range-size=$trx --simple_ranges=$trx --db-ps-mode=$ps_mode --mysql-ignore-errors=all run | tee -a $host-sysbench.log


prepare data 
========================
sysbench /usr/share/sysbench/oltp_read_only.lua --db-driver=mysql --threads=4 --mysql-host=127.0.0.1 --mysql-user=sysbenc
h --mysql-password=sysbench@123 --mysql-port=3306 --tables=10 --table-size=1000000 prepare


Read trx benchmarking
=========================
sysbench /usr/share/sysbench/oltp_read_only.lua --db-driver=mysql --threads=4 --mysql-host=127.0.0.1 --mysql-user=sysbench --mysql-password=sysbench@123 --mysql-port=3306 --threads=16 --events=0 --time=300 --tables=10 --table-size=1000000 --range_selects=off --db-ps-mode=disable --report-interval=1 run

Clean Up sbtest data
======================
sysbench /usr/share/sysbench/oltp_read_only.lua --db-driver=mysql --threads=16 --events=0 --time=150 --mysql-host=127.0.0.1 --mysql-user=sysbench --mysql-password=sysbench@123 --mysql-port=3306 --tables=10 --table-size=1000000 --range_selects=off --db-ps-mode=disable --report-interval=1 cleanup

Write data 
======================
sysbench /usr/share/sysbench/oltp_write_only.lua --db-driver=mysql --threads=4 --events=0 --time=150 --mysql-host=127.0.0.1 --mysql-user=sysbench --mysql-password=sysbench@123 --mysql-port=3306 --tables=20 --table-size=2000000 prepare


mixed dml operation
=====================
sysbench /usr/share/sysbench/oltp_write_only.lua --threads=16 --events=0 --db-driver=mysql --time=300 --mysql-host=127.0.0.1 --mysql-user=sysbench --mysql-password=sysbench@123 --mysql-port=3306 --tables=20 --delete_inserts=10 --index_updates=10 --non_index_updates=10 --table-size=10000000 --db-ps-mode=disable --report-interval=1 run

sh mysqldumpsplitter.sh --source filename --extract DB --match_str database-name

sh mysqldumpsplitter.sh --source filename --extract TABLE --match_str table-name

sh mysqldumpsplitter.sh --source filename --extract REGEXP --match_str regular-expression

sh mysqldumpsplitter.sh --source filename --extract ALLDBS

sh mysqldumpsplitter.sh --source filename --extract ALLTABLES

sh mysqldumpsplitter.sh --source filename --extract REGEXP --match_str '(table1|table2|table3)'

sh mysqldumpsplitter.sh --source filename.sql.gz --extract DB --match_str 'dbname' --decompression gzip

sh mysqldumpsplitter.sh --source filename.sql.gz --extract DB --match_str 'dbname' --decompression gzip --compression none

sh mysqldumpsplitter.sh --source filename --extract ALLTABLES --output_dir /path/to/extracts/

mysqldumpsplitter.sh --source filename --extract DBTABLE --match_str "DBNAME.*" --compression none

mysqldumpsplitter.sh --source filename --desc

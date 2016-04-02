SHOW VARIABLES LIKE 'innodb_buffer_pool_size';
SHOW VARIABLES LIKE 'innodb_additional_mem_pool_size';
SHOW VARIABLES LIKE 'innodb_log_buffer_size';
SHOW VARIABLES LIKE 'thread_stack';
SET @kilo_bytes = 1024;
SET @mega_bytes = @kilo_bytes * 1024;
SET @giga_bytes = @mega_bytes * 1024;
SET @innodb_buffer_pool_size = 2 * @giga_bytes;
SET @innodb_additional_mem_pool_size = 16 * @mega_bytes;
SET @innodb_log_buffer_size = 8 * @mega_bytes;
SET @thread_stack = 192 * @kilo_bytes;
SELECT
( @@key_buffer_size + @@query_cache_size + @@tmp_table_size
+ @innodb_buffer_pool_size + @innodb_additional_mem_pool_size
+ @innodb_log_buffer_size
+ @@max_connections * (
@@read_buffer_size + @@read_rnd_buffer_size + @@sort_buffer_size
+ @@join_buffer_size + @@binlog_cache_size + @thread_stack
) ) / @giga_bytes AS MAX_MEMORY_GB;
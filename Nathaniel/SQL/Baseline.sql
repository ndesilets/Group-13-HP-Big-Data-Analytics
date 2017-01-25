/* This script will serve as an automated way to reset the Capstone Demo
        DB to it's default initialization parameter values               */
        

alter system set pga_aggregate_limit = 256G;
alter system set pga_aggregate_target = 64G;

--Calculated on the fly from above parameters
alter system reset "_pga_max_size" scope=spfile;

--Default 256M
alter system reset db_cache_size scope=spfile;

--Deafult 128
alter system reset db_file_multiblock_read_count scope=spfile;


/* Parameters of interest:
 - db_file_multiblock_read_count = 128 (Increase to reduce time for full table scans)\
 - optimizer_index_cost_adj
 
 SQL> show parameter optimizer_

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
optimizer_adaptive_features          boolean     TRUE
optimizer_adaptive_reporting_only    boolean     FALSE
optimizer_capture_sql_plan_baselines boolean     FALSE
optimizer_dynamic_sampling           integer     2
optimizer_features_enable            string      12.1.0.2
optimizer_index_caching              integer     0
optimizer_index_cost_adj             integer     100
optimizer_inmemory_aware             boolean     TRUE
optimizer_mode                       string      ALL_ROWS
optimizer_secure_view_merging        boolean     TRUE
optimizer_use_invisible_indexes      boolean     FALSE

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
optimizer_use_pending_statistics     boolean     FALSE
optimizer_use_sql_plan_baselines     boolean     TRUE
*/
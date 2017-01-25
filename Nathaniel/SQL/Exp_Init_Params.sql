/* This script will serve as an automated way to set the Capstone Demo
        DB to it's default initialization parameter values               */
        

-- PGA params
alter system set pga_aggregate_limit = &pga_aggregate_limit;
alter system set pga_aggregate_target = &pga_aggregate_target;
alter system set "_pga_max_size" = &_pga_max_size;

-- Block and Cache params
alter system set db_cache_size = &db_cache_size;
alter system set db_file_multiblock_read_count = &db_file_multiblock_read_count;

-- Talk with everyone during the meeting today about what else to add. Also,
-- think about incorporating with passed arguments rather than substition
-- variables
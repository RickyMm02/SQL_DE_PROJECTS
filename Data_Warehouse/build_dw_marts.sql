-- duckdb dw_marts.duckdb -c ".read build_dw_marts.sql"

-- Step 1: DW - Create star schema tables
.read create_tables_dw.sql

-- Step 2: DW - Load data from CSV files into tables
.read load_schema_dw.sql

-- Step 3: Mart - Create flat mart
.read create_flat_mart.sql

-- Step 4: Mart - Create skills demand mart
.read create_skills_mart.sql

-- Step 5: Mart - Create Priority Mart
.read create_priority_mart.sql

-- Step 6: Mart - Update priority mart
.read update_priority_mart.sql
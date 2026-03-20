## ETL Decisions

### Decision 1 — Date Format Standardization
**Problem**: The raw CSV contained inconsistent date formats across records:
- `29/08/2023` (DD/MM/YYYY)
- `12-12-2023` (DD-MM-YYYY)
- `2023-02-05` (YYYY-MM-DD)
- `20-02-2023` (DD-MM-YYYY)
- `15/08/2023` (DD/MM/YYYY)

This inconsistency would cause date sorting, filtering, and time-based analytics to fail.

**Resolution**: Created a standardized date parsing approach that:
1. Detects the date format pattern in the raw data
2. Converts all dates to ISO format (YYYY-MM-DD) before loading
3. Populated the dim_date dimension table with standardized dates
4. Used the integer date_id (YYYYMMDD format) for efficient joins

This ensures all time-based queries (month-over-month trends, quarterly aggregations) work correctly and consistently.

### Decision 2 — Category Name Standardization
**Problem**: The product category field had inconsistent casing and spelling:
- `electronics` (lowercase)
- `Electronics` (capitalized)
- `Grocery` (singular)
- `Groceries` (plural)
- `Clothing` (consistent but could vary)

Without standardization, GROUP BY queries would treat "electronics" and "Electronics" as different categories, leading to inaccurate aggregations.

**Resolution**: 
1. Applied UPPER() case conversion to all category names
2. Standardized singular/plural forms to use plural form consistently
3. Created a lookup mapping in the ETL process:
   - 'electronics' → 'Electronics'
   - 'grocery' → 'Groceries'
   - 'groceries' → 'Groceries'
4. Loaded only the standardized values into dim_product.category

This ensures accurate category-based aggregations and simplifies BI tool reporting.

### Decision 3 — NULL Store City Handling
**Problem**: Several records had NULL or empty store_city values:
- Row TXN5033: `Mumbai Central,,` (empty store_city)
- Row TXN5044: `Chennai Anna,,` (empty store_city)
- Row TXN5082: `Delhi South,,` (empty store_city)
- Multiple records with missing city in Pune and other locations

NULL cities would cause incomplete geographical analysis and inaccurate regional reporting.

**Resolution**:
1. Implemented a data cleansing rule: If store_city is NULL or empty, infer city from store_name
2. Created mapping logic:
   - Stores containing "Chennai" → city = 'Chennai'
   - Stores containing "Delhi" → city = 'Delhi'
   - Stores containing "Bangalore" → city = 'Bangalore'
   - Stores containing "Pune" → city = 'Pune'
   - Stores containing "Mumbai" → city = 'Mumbai'
3. Added region mapping for enriched analytics:
   - 'Chennai', 'Bangalore' → 'South'
   - 'Delhi' → 'North'
   - 'Mumbai', 'Pune' → 'West'
4. Logged all inferred values for data quality auditing

This ensures complete geographical dimension data, enabling accurate store performance analysis by city and region.

### Additional ETL Considerations

**Data Type Validation**: 
- Verified unit_price values are positive numbers
- Checked units_sold are integers > 0
- Rejected records with negative quantities or prices

**Duplicate Detection**:
- Implemented checks for duplicate transaction_ids
- Used a staging table to validate before final load

**Referential Integrity**:
- Ensured all foreign key references exist in dimension tables
- Created unknown member records for handling orphaned facts
- Validated customer_id existence before loading facts

**Performance Optimization**:
- Created indexes on fact table foreign keys after initial load
- Used bulk insert operations for better performance
- Implemented incremental load strategy for production
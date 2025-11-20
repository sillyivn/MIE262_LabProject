set SHOE_TYPE;

param shoe;

table ShoeTable IN "CSV" "Product.Master.csv":
	SHOE_TYPE <- Product_Num
	
	

set MACHINE_TYPE;
set RAW_MATERIAL_TYPE;
set FORECASTED_DEMAND;
set WAREHOUSE_TYPE;


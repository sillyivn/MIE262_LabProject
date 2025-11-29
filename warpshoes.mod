#Sunny_Wu_wusunny1_1010978239
#Ivan_Zhuo_zhuoiva1_1011039984

# Indices for shoes, machines, raw materials, and warehouse,
set SHOE_TYPE;              # Set of Shoe Type Indices
set MACHINE_TYPE;         	# Set of Machine Type Indices
set RAW_MATERIAL_TYPE;  	# Set of Raw Material Type Indices
set WAREHOUSE_TYPE;			# Set of Warehouse Type Indices

# Parameters (could be thought of as sets associated with the sets above)
# Make these "sets" dependent on the indices above 
param P {SHOE_TYPE}; # Set of Selling Price Per Pair of Product i
param D {SHOE_TYPE}; # Set of Forecasted Product Demands in February for Product i
param C_r {RAW_MATERIAL_TYPE}; # Set of Costs per Unit of Raw Material 
param A {SHOE_TYPE, RAW_MATERIAL_TYPE} default 0; # Set of Units of Raw Material r to make 1 Pair of Product I
param Q_r {RAW_MATERIAL_TYPE}; # Set of Total Raw Material Quantities
param t {SHOE_TYPE, MACHINE_TYPE} default 0; # Set of Processing Times on Machine M for 1 Pair of Product I
param C_m {MACHINE_TYPE}; # Set of Operating Cost of Machine M for 1 Pair of Product I
param C_w {WAREHOUSE_TYPE}; # Set of Warehouse Costs 
param W {WAREHOUSE_TYPE}; # Set of Warehouse Capacities 

# Constant Parameters (not changing:
param s_p := 10; # shortage penalty
param B := 10000000; # raw material budget
param L := 25; # fixed labour rate
param T_avail := 20160; # available run time per machine in February 
 
# Main Decision Variables. RELAX
var x {SHOE_TYPE} >= 0; # number of shoes produced
var z {WAREHOUSE_TYPE} binary; # binary variable to include warehouse i or not

# Objective Function																 
maximize Profit: (sum{i in SHOE_TYPE} P[i]*x[i]) # Revenue
- (sum{r in RAW_MATERIAL_TYPE} C_r[r] * (sum{i in SHOE_TYPE} A[i,r] * x[i])) # Raw Material Cost
- (sum{m in MACHINE_TYPE} C_m[m] * sum{i in SHOE_TYPE} (t[i,m]/60) * x[i]) # Machine Operating Cost (/60 to convert to minutes)
- (L * sum{m in MACHINE_TYPE, i in SHOE_TYPE} (t[i,m]/3600) * x[i]) # Labour cost (/3600 to convert to hours)
- (s_p * sum{i in SHOE_TYPE} max(0,D[i]-x[i])) # Shortage penalty, only occurs if sales don't meet demand
- (sum {j in WAREHOUSE_TYPE} C_w[j] * z[j]); # Warehouse cost

# Constraints
subject to warehouse_capacity: sum{i in SHOE_TYPE} x[i] <=  sum{j in WAREHOUSE_TYPE} W[j] * z[j]; # Warehouse capacity is additive
subject to machine_time_availability {m in MACHINE_TYPE}: sum {i in SHOE_TYPE} (t[i,m]/60) * x[i] <= T_avail;
subject to raw_materials_budget: sum{r in RAW_MATERIAL_TYPE} C_r[r]* (sum {i in SHOE_TYPE} A[i,r] * x[i]) <= B;
subject to raw_materials_availability {r in RAW_MATERIAL_TYPE}: (sum{i in SHOE_TYPE} A[i,r] * x[i]) <= Q_r[r];



library(sgsR)
library(terra)
library(raster)
library(sf)

#Load landcover raster
landcover = rast("CCDC_Image.tif")

# Remove bounding box
landcover[landcover == 0] = NA

plot(landcover)
barplot(landcover, maxcell = 1000000000)

# Define strata for land cover (all classes in seperate bins)
lc_breaks = c(seq(1, 16, 1))
landcover_strat = strat_breaks(mraster = landcover, breaks = lc_breaks, plot = TRUE)

# Calculate allocation
# Proportional
calculate_allocation(sraster = landcover_strat, nSamp = 200, allocation = "prop")

#Create proportional sample points
prop_points = sample_strat(sraster = landcover_strat, nSamp = 200, allocation = "prop", plot = TRUE)

#View number of sample points for each class (nSamp column) 
prop_points_rep = calculate_representation(sraster = landcover_strat, existing = prop_points, plot = TRUE)


#Number of sampling points needed for class to have at least 10 points
#Classes not listed already have 10+ points

#3 = 5
#6 = 9
#7 = 9
#10 = 5
#12 = 9
#13 = 9
#15 = 7
#16 = 9

#Total points needed = 62

#Create (approximate) weight vector of classes (sum = 1)
weights_vector = c(0, 0, 0.08, 0, 0, 0.145, 0.145, 0, 0, 0.08, 0, 0.145, 0.145, 0, 0.115, 0.145)

#Add the needed sample points (nSamp=71 instead of 62 since nSamp=62 had a few classes off by 1 sample point from 10)
final_points = sample_strat(sraster = landcover_strat, nSamp = 71, allocation = "manual", weights = weights_vector, existing = prop_points, plot = TRUE)

#View final number of sample points for each class (nSamp column)
final_points_rep = calculate_representation(sraster = landcover_strat, existing = final_points, plot = TRUE)

#Create shapefile of sample points to verify accuracy
st_write(final_points, "samplepoints.shp")

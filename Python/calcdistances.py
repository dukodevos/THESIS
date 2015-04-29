#-------------------------------------------------------------------------------
# Name:         Calculate Ramp, Higway and Soundbarrier distance
# Purpose:	
#
# Author:      	Duco de Vos
#
# Created:     22-04-2016
#-------------------------------------------------------------------------------

import arcpy

# Add "Wegvakken" shapefiles
for i in range(2008,2016):
	mxd = arcpy.mapping.MapDocument("CURRENT")
	df = arcpy.mapping.ListDataFrames(mxd,"*")[0]
	newlayer = arcpy.mapping.Layer("C:\Users\Pieter\Documents\StreemMaster\THESIS\Data\ArcGisProjects\HighwayDistance\data\Wegvakken"+str(i)+".shp")
	arcpy.mapping.AddLayer(df, newlayer,"BOTTOM")

# Add "NVM" housing shapefiles
for i in range(2006,2014):
	mxd = arcpy.mapping.MapDocument("CURRENT")
	df = arcpy.mapping.ListDataFrames(mxd,"*")[0]
	newlayer = arcpy.mapping.Layer("C:\Users\Pieter\Documents\StreemMaster\THESIS\Data\ArcGisProjects\HighwayDistance\data\NVM"+str(i)+".shp")
	arcpy.mapping.AddLayer(df, newlayer,"BOTTOM")


# Add "Soundbarrier" shapefiles
for i in range(2008,2016):
	mxd = arcpy.mapping.MapDocument("CURRENT")
	df = arcpy.mapping.ListDataFrames(mxd,"*")[0]
	newlayer = arcpy.mapping.Layer("C:\Users\Pieter\Documents\StreemMaster\THESIS\Data\ArcGisProjects\HighwayDistance\data\Soundb"+str(i)+".shp")
	arcpy.mapping.AddLayer(df, newlayer,"BOTTOM")

# Add "Wegen" shapefiles
for i in range(2008,2016):
	mxd = arcpy.mapping.MapDocument("CURRENT")
	df = arcpy.mapping.ListDataFrames(mxd,"*")[0]
	newlayer = arcpy.mapping.Layer("C:\Users\Pieter\Documents\StreemMaster\THESIS\Data\ArcGisProjects\HighwayDistance\data\Wegen"+str(i)+".shp")
	arcpy.mapping.AddLayer(df, newlayer,"BOTTOM")


# select highway ramp stretches
for i in range(2008:2016):
    wegvakken = "Wegvakken"+str(i)
    ramps = "Ramps"+str(i)+"Line.shp"
    expression = '"BAANSUBSRT" = \'OPR\''
    arcpy.Select_analysis(wegvakken, ramps, expression)

# convert highway ramp lines into points
for i in range(2008:2016):
    rampsline = "Ramps"+str(i)+"Line"
    ramps = "Ramps"+str(i)
    method = "CENTROID"
    arcpy.FeatureToPoint_management(rampsline, ramps, method)

#########################################################################################
# Calculate distance from each house sold in year t to nearest Highway ramp in year t+2 #
# ******Note: No data from 2009 on highway ramps, i used 2008 data for this part.****** #
#########################################################################################
for i in range(2006:2013):
    nvm = "NVM_"+str(i)
    ramps = "Ramps"+str(i)
    arcpy.Near_analysis(nvm, ramps)

# Add RampDist Field
for i in range(2006:2013):
    nvm = "NVM_"+str(i)
    fieldName = "rampdDist"
    fieldType = "LONG"
    arcpy.AddField_management(nvm, fieldName, fieldType)

# Replace a layer/table view name with a path to a dataset (which can be a layer file) or create the layer/table view within the script
for i in range(2006:2013):
    nvm = "NVM_"+str(i)
    field = "rampDist"
    expression = "!NEAR_DIST!"
    language = "PYTHON_9.3"
    arcpy.CalculateField_management(nvm, field, expression, language, "#")

# Replace a layer/table view name with a path to a dataset (which can be a layer file) or create the layer/table view within the script
for i in range(2006:2013):
    feature = "NVM"+str(i)
    fields = "NEAR_DIST,NEAR_FID"
    arcpy.DeleteField_management(feature, fields)

#############################################################################################################################
# after adding Wegen2008-Wegen2016 layers: Calculate distance from each house sold in year t to nearest Highway in year t+2 #
#############################################################################################################################
for i in range(2006:2013):
    feature = "NVM_"+str(i)
    near = "Wegen"+str(i+2)
    arcpy.Near_analysis(feature, near)

# Add HwDist Field
for i in range(2006:2013):
    feature = "NVM_"+str(i)
    fieldName ="highwayDist"
    fieldType = "LONG"
    arcpy.AddField_management(feature, fieldName, fieldType)

# Replace a layer/table view name with a path to a dataset (which can be a layer file) or create the layer/table view within the script
for i in range(2006:2013):
    nvm = "NVM_"+str(i)
    field = "highwayDist"
    expression = "!NEAR_DIST!"
    language = "PYTHON_9.3"
    arcpy.CalculateField_management(nvm,field,expression,language,"#")

# Replace a layer/table view name with a path to a dataset (which can be a layer file) or create the layer/table view within the script
for i in range(2006:2013):
    feature = "NVM_"+str(i)
    fields = "NEAR_DIST,NEAR_FID"
    arcpy.DeleteField_management(feature, fields)

##################################################################################################################################
# after adding Wegen2008-Wegen2016 layers: Calculate distance from each house sold in year t to nearest soundbarrier in year t+2 #
##################################################################################################################################
for i in range(2006:2013):
    feature = "NVM_"+str(i)
    near = "Sounb"+str(i+2)
    arcpy.Near_analysis(feature, near)

# Add SoundbDist Field
for i in range(2006:2013):
    feature = "NVM_"+str(i)
    fieldName ="soundbDist"
    fieldType = "LONG"
    arcpy.AddField_management(feature, fieldName, fieldType)

# Replace a layer/table view name with a path to a dataset (which can be a layer file) or create the layer/table view within the script
for i in range(2006:2013):
    nvm = "NVM_"+str(i)
    field = "soundbDist"
    expression = "!NEAR_DIST!"
    language = "PYTHON_9.3"
    arcpy.CalculateField_management(nvm,field,expression,language,"#")

# Replace a layer/table view name with a path to a dataset (which can be a layer file) or create the layer/table view within the script
for i in range(2006:2013):
    feature = "NVM_"+str(i)
    fields = "NEAR_DIST,NEAR_FID"
    arcpy.DeleteField_management(feature, fields)

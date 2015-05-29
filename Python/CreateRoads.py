#-------------------------------------------------------------------------------
# Name:         CreateRoads
# Purpose:      Create Roads shapefile and add tarmac and speed fields
#
# Author:       Duco
#
# Created:      21-05-2015
#-------------------------------------------------------------------------------

import arcpy

# Add wegcat_beleving Shapefiles
for i in range(2005,2016):
	mxd = arcpy.mapping.MapDocument("CURRENT")
	df = arcpy.mapping.ListDataFrames(mxd,"*")[0]
	newlayer = arcpy.mapping.Layer("C:\Users\Pieter\Documents\StreemMaster\THESIS\Data\OriginalData\Weggeg\wegcat_beleving"+str(i)+".shp")
	arcpy.mapping.AddLayer(df, newlayer,"BOTTOM")

# Add max_snelheden Shapefiles
for i in range(2005,2016):
	mxd = arcpy.mapping.MapDocument("CURRENT")
	df = arcpy.mapping.ListDataFrames(mxd,"*")[0]
	newlayer = arcpy.mapping.Layer("C:\Users\Pieter\Documents\StreemMaster\THESIS\Data\OriginalData\Weggeg\max_snelheden"+str(i)+".shp")
	arcpy.mapping.AddLayer(df, newlayer,"BOTTOM")

# Add verhardingen Shapefiles
for i in range(2005,2016):
	mxd = arcpy.mapping.MapDocument("CURRENT")
	df = arcpy.mapping.ListDataFrames(mxd,"*")[0]
	newlayer = arcpy.mapping.Layer("C:\Users\Pieter\Documents\StreemMaster\THESIS\Data\OriginalData\Weggeg\verhardingen"+str(i)+".shp")
	arcpy.mapping.AddLayer(df, newlayer,"BOTTOM")

# Join fields Type of tarmac
for i in range (2005,2016):
    inFeatures = "wegcat_beleving"+str(i)
    joinField = "WVK_ID"
    joinTable = "verhardingen"+str(i)
    fieldList ="OMSCHR"
    arcpy.JoinField_management(inFeatures,joinField,joinTable,joinField,fieldList)

# Join fields max_snelheden
for i in range (2005,2016):
    inFeatures = "wegcat_beleving"+str(i)
    joinField = "WVK_ID"
    joinTable = "max_snelheden"+str(i)
    fieldList ="OMSCHR"
    arcpy.JoinField_management(inFeatures,joinField,joinTable,joinField,fieldList)

#Remove verhardingen layer
for i in range(2005,2016):
	mxd = arcpy.mapping.MapDocument("CURRENT")
	for df in arcpy.mapping.ListDataFrames(mxd):
            for lyr in arcpy.mapping.ListLayers(mxd, "", df):
                if lyr.name.lower() == "verhardingen"+str(i):
                    arcpy.mapping.RemoveLayer(df,lyr)

#Remove max_snelheden layer
for i in range(2005,2016):
	mxd = arcpy.mapping.MapDocument("CURRENT")
	for df in arcpy.mapping.ListDataFrames(mxd):
            for lyr in arcpy.mapping.ListLayers(mxd, "", df):
                if lyr.name.lower() == "max_snelheden"+str(i):
                    arcpy.mapping.RemoveLayer(df,lyr)










arcpy.Select_analysis("Wegvakken","Snelwegen.shp",'"Wegvakken.BAANSUBSRT" <> \'OPR\' AND "Wegvakken.BAANSUBSRT" <> \'AFR\'')
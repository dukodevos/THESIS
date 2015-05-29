#-------------------------------------------------------------------------------
# Name:        CreateRamps
# Purpose:
#
# Author:      Pieter
#
# Created:     21-05-2015
# Copyright:   (c) Pieter 2015
# Licence:     <your licence>
#-------------------------------------------------------------------------------

# select highway ramp stretches
for i in range(2014,2016):
    wegvakken = "Wegvakken"+str(i)
    ramps = "Ramps"+str(i)+"Line.shp"
    expression = '"BAANSUBSRT" = \'OPR\''
    arcpy.Select_analysis(wegvakken, ramps, expression)

# convert highway ramp lines into points
for i in range(2008,2016):
    rampsline = "Ramps"+str(i)+"Line"
    ramps = "Ramps"+str(i)
    method = "CENTROID"
    arcpy.FeatureToPoint_management(rampsline, ramps, method)

# calculate mean point for each ramp pair with the same name
for i in range(2008,2016):
    feat = "Ramps"+str(i)
    output ="Opritten"+str(i)+".shp"
    casefield = "STT_NAAM"
    arcpy.MeanCenter_stats(feat,output,"#",casefield)
#-------------------------------------------------------------------------------
# Name:        CalculateHighwayDistance
# Purpose:
#
# Author:      Pieter
#
# Created:     21-05-2015
# Copyright:   (c) Pieter 2015
# Licence:     <your licence>
#-------------------------------------------------------------------------------

import arcpy


##################################################################################
# Calculate distance from each house sold in year t to nearest Highway in year t #
##################################################################################
for i in range(2005,2014):
    feature = "NVM"+str(i)
    near = "wegcat_beleving"+str(i)
    arcpy.Near_analysis(feature, near)

# Add HwDist Field
for i in range(2005,2014):
    feature = "NVM"+str(i)
    fieldName ="hwDist"
    fieldType = "LONG"
    arcpy.AddField_management(feature, fieldName, fieldType)

#Replace a layer/table view name with a path to a dataset (which can be a layer file) or create the layer/table view within the script
for i in range(2005,2014):
    nvm = "NVM"+str(i)
    field = "hwDist"
    expression = "!NEAR_DIST!"
    language = "PYTHON_9.3"
    arcpy.CalculateField_management(nvm,field,expression,language,"#")

# Add hwFID field
for i in range(2005,2014):
    feature = "NVM"+str(i)
    fieldName ="hwFID"
    fieldType = "LONG"
    arcpy.AddField_management(feature, fieldName, fieldType)

#Replace a layer/table view name with a path to a dataset (which can be a layer file) or create the layer/table view within the script
for i in range(2005,2014):
    nvm = "NVM"+str(i)
    field = "hwFID"
    expression = "!NEAR_FID!"
    language = "PYTHON_9.3"
    arcpy.CalculateField_management(nvm,field,expression,language,"#")



##################################################################################
# Calculate distance from each house sold in year t to nearest Noisebarrier in year t #
##################################################################################
for i in range(2005,2014):
    feature = "NVM"+str(i)
    near = "gel_beperkingen"+str(i)
    arcpy.Near_analysis(feature, near)

# Add HwDist Field
for i in range(2005,2014):
    feature = "NVM"+str(i)
    fieldName ="barDist"
    fieldType = "LONG"
    arcpy.AddField_management(feature, fieldName, fieldType)

#Replace a layer/table view name with a path to a dataset (which can be a layer file) or create the layer/table view within the script
for i in range(2005,2014):
    nvm = "NVM"+str(i)
    field = "barDist"
    expression = "!NEAR_DIST!"
    language = "PYTHON_9.3"
    arcpy.CalculateField_management(nvm,field,expression,language,"#")

# Add barFID field
for i in range(2005,2014):
    feature = "NVM"+str(i)
    fieldName ="barFID"
    fieldType = "LONG"
    arcpy.AddField_management(feature, fieldName, fieldType)

#Replace a layer/table view name with a path to a dataset (which can be a layer file) or create the layer/table view within the script
for i in range(2005,2014):
    nvm = "NVM"+str(i)
    field = "barFID"
    expression = "!NEAR_FID!"
    language = "PYTHON_9.3"
    arcpy.CalculateField_management(nvm,field,expression,language,"#")




##################################################################################
# Calculate distance from each house sold in year t to nearest Highway Ramp in year t #
##################################################################################
for i in range(2005,2008):
    feature = "NVM"+str(i)
    near = "Opritten2008"
    arcpy.Near_analysis(feature, near)

for i in range(2008,2014):
    feature = "NVM"+str(i)
    near = "Opritten"+str(i)
    arcpy.Near_analysis(feature, near)

# Add HwDist Field
for i in range(2005,2014):
    feature = "NVM"+str(i)
    fieldName ="rampDist"
    fieldType = "LONG"
    arcpy.AddField_management(feature, fieldName, fieldType)

#Replace a layer/table view name with a path to a dataset (which can be a layer file) or create the layer/table view within the script
for i in range(2005,2014):
    nvm = "NVM"+str(i)
    field = "rampDist"
    expression = "!NEAR_DIST!"
    language = "PYTHON_9.3"
    arcpy.CalculateField_management(nvm,field,expression,language,"#")

#AddJoin NVM to wegcat_beleving
for i in range(2005,2014):
    in_layer_or_view = "NVM"+str(i)
    in_field = "hwFID"
    join_table = "wegcat_beleving"+str(i)
    join_field = "FID"
    join_type = "KEEP_COMMON"
    arcpy.AddJoin_management(in_layer_or_view, in_field, join_table, join_field, join_type)

#AddJoin NVM to gel_beperkingen
for i in range(2005,2014):
    in_layer_or_view = "NVM"+str(i)
    in_field = "barFID"
    join_table = "gel_beperkingen"+str(i)
    join_field = "FID"
    join_type = "KEEP_COMMON"
    arcpy.AddJoin_management(in_layer_or_view, in_field, join_table, join_field, join_type)

# Replace a layer/table view name with a path to a dataset (which can be a layer file) or create the layer/table view within the script
for i in range(2005,2014):
    feature = "NVM_"+str(i)
    fields = ["NEAR_DIST","NEAR_FID","FID","KANTCODE","WVK_ID","WVK_BEGDAT","BEGAFSTAND","ENDAFSTAND","FK_VELD1","FK_VELD4","IZI_SIDE",""]
    arcpy.DeleteField_management(feature, fields)



##################################################################################
# Calculate distance from each house sold in year t to nearest Highway in year t+1 #
##################################################################################
for i in range(2005,2014):
    feature = "NVM"+str(i)
    near = "wegcat_beleving"+str(i+1)
    arcpy.Near_analysis(feature, near)

# Add HwDist Field
for i in range(2005,2014):
    feature = "NVM"+str(i)
    fieldName ="hwDist1"
    fieldType = "LONG"
    arcpy.AddField_management(feature, fieldName, fieldType)

# Replace a layer/table view name with a path to a dataset (which can be a layer file) or create the layer/table view within the script
for i in range(2005,2014):
    nvm = "NVM"+str(i)
    field = "hwDist1"
    expression = "!NEAR_DIST!"
    language = "PYTHON_9.3"
    arcpy.CalculateField_management(nvm,field,expression,language,"#")

# Add hwFID field
for i in range(2005,2014):
    feature = "NVM"+str(i)
    fieldName ="hwFID1"
    fieldType = "LONG"
    arcpy.AddField_management(feature, fieldName, fieldType)

#Replace a layer/table view name with a path to a dataset (which can be a layer file) or create the layer/table view within the script
for i in range(2005,2014):
    nvm = "NVM"+str(i)
    field = "hwFID1"
    expression = "!NEAR_FID!"
    language = "PYTHON_9.3"
    arcpy.CalculateField_management(nvm,field,expression,language,"#")

##################################################################################
# Calculate distance from each house sold in year t to nearest Noisebarrier in year t+1 #
##################################################################################
for i in range(2005,2014):
    feature = "NVM"+str(i)
    near = "gel_beperkingen"+str(i+1)
    arcpy.Near_analysis(feature, near)

# Add HwDist Field
for i in range(2005,2014):
    feature = "NVM"+str(i)
    fieldName ="barDist1"
    fieldType = "LONG"
    arcpy.AddField_management(feature, fieldName, fieldType)

#Replace a layer/table view name with a path to a dataset (which can be a layer file) or create the layer/table view within the script
for i in range(2005,2014):
    nvm = "NVM"+str(i)
    field = "barDist1"
    expression = "!NEAR_DIST!"
    language = "PYTHON_9.3"
    arcpy.CalculateField_management(nvm,field,expression,language,"#")

# Add barFID field
for i in range(2005,2014):
    feature = "NVM"+str(i)
    fieldName ="barFID1"
    fieldType = "LONG"
    arcpy.AddField_management(feature, fieldName, fieldType)

#Replace a layer/table view name with a path to a dataset (which can be a layer file) or create the layer/table view within the script
for i in range(2005,2014):
    nvm = "NVM"+str(i)
    field = "barFID1"
    expression = "!NEAR_FID!"
    language = "PYTHON_9.3"
    arcpy.CalculateField_management(nvm,field,expression,language,"#")

##################################################################################
# Calculate distance from each house sold in year t to nearest Highway Ramp in year t+1 #
##################################################################################
for i in range(2005,2007):
    feature = "NVM"+str(i)
    near = "Opritten2008"
    arcpy.Near_analysis(feature, near)

for i in range(2008,2014):
    feature = "NVM"+str(i)
    near = "Opritten"+str(i+1)
    arcpy.Near_analysis(feature, near)

# Add HwDist Field
for i in range(2005,2014):
    feature = "NVM"+str(i)
    fieldName ="rampDist1"
    fieldType = "LONG"
    arcpy.AddField_management(feature, fieldName, fieldType)

#Replace a layer/table view name with a path to a dataset (which can be a layer file) or create the layer/table view within the script
for i in range(2005,2014):
    nvm = "NVM"+str(i)
    field = "rampDist1"
    expression = "!NEAR_DIST!"
    language = "PYTHON_9.3"
    arcpy.CalculateField_management(nvm,field,expression,language,"#")

# Replace a layer/table view name with a path to a dataset (which can be a layer file) or create the layer/table view within the script
for i in range(2005,2014):
    feature = "NVM"+str(i)
    fields = ["NEAR_DIST","NEAR_FID"]
    arcpy.DeleteField_management(feature, fields)

#AddJoin NVM to wegcat_beleving
for i in range(2005,2014):
    in_layer_or_view = "NVM"+str(i)
    in_field = "hwFID1"
    join_table = "wegcat_beleving"+str(i+1)
    join_field = "FID"
    join_type = "KEEP_COMMON"
    arcpy.AddJoin_management(in_layer_or_view, in_field, join_table, join_field, join_type)

#AddJoin NVM to gel_beperkingen
for i in range(2005,2014):
    in_layer_or_view = "NVM"+str(i)
    in_field = "barFID1"
    join_table = "gel_beperkingen"+str(i+1)
    join_field = "FID"
    join_type = "KEEP_COMMON"
    arcpy.AddJoin_management(in_layer_or_view, in_field, join_table, join_field, join_type)
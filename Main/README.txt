-------------------------------------------------------------------
Description of the Output
-------------------------------------------------------------------
All dataset information is stored in <OutputDir>/iminfo_*.mat files
where the * represents one of the following:
-Train1
-Train2
-Train2Subset
-Train
-Validation
-TestSubset
-Test

NOTE- Whether iminfo_Train2.mat is used or iminfo_Train2Subset.mat is
used depends on whether features are being extracted from a subset of
Train2 or the complete Train2 set. 
Similary whether iminfo_Test.mat is used or iminfo_TestSubset.mat is
used depends on whether tests are being being run on a subset of Test 
or the complete Test set.

NOTE- If you already have these precomputed then copy them into
<OutputDir> to avoid re-computation. 

Other useful data stored in <OutputDir> by different files are listed
below 

/* train.m */
- RF_Model_Train1
- matches_Train2Subset
- deformation_Train2Subset
- features_labels_Train2Subset
- voxel_classifier_BASIC/voxel_classifier_model
- voxel_classifier_SIMILARITY/voxel_classifier_model

# Resource requirements
In the tutorial for the standard analysis track we utilized scRNAbox to analyze a snRNAseq dataset comprising of 11 samples and 53,998 high quality nuclei. The following job configurations were used for the analysis:

|Step |THREADS_ARRAY|MEM_ARRAY|WALLTIME_ARRAY|
|:--|:--|:--|:--|
|Step2|4|40g|00-05:00|
|Step3|4|40g|00-05:00|
|Step4|4|40g|00-05:00|
|Step5|4|100g|00-05:00|
|Step6|4|100g|00-05:00|
|Step7 MarkerGSEA|4|40g|00-05:00|
|Step7 KnownMarkers|4|40g|00-02:00|
|Step7 ReferenceAnnotation|4|200g|00-12:00|
|Step7 Annotate|4|40g|00-01:00|
|Step8 AddMeta|4|40g|00-02:00|
|Step8 RunDGE|4|40g|00-12:00|

Users should use the above configurations as a reference to determine the required resource configurations for their own analyses. 

# Common error messages

## Step 5
**Error message:** <br />
 Error: Cannot find 'Sample_ID' in this Seurat object

**Solution:** <br />
 This error occurs when users initiate the pipeline at Step 5 (without running Steps 1 to 4). The 'Sample_ID' column of the metadata defines the identities of the individual samples which are being merged or integrated. In the scRNAbox pipeline, the 'Sample_ID' metadata column is added in Step 4. Therefore, to avoid this issue users should initiate the pipeline at Step 4 in order to obtain the required information for Step 5. Otherwise, users 
can manually add a 'Sample_ID' metadata column corresponding to their sample identities prior to initiating the pipeline at Step 5. The following code can be used to add meta data to the Seurat object:
 
```
Seu_object <- AddMetadata(Seu_object, Sample_ID)

# Seu_object: Seurat object to be used in Step 5 of scRNAbox
# Sample_ID: Dataframe with rownames corresponding to the rownames of the Seurat object metadata and a "Sample_ID" column defining the sample identities of each cell. 

```

If the error persists please [contact](contributing.md) the development team. 
 - - - -

## Step 6
**Error message:** <br />
Error in FindClusters.Seurat(seu_int, resolution = par_FindClusters_resolution) :
  Provided graph.name not present in Seurat object
Calls: <Anonymous> -> FindClusters.Seurat

**Solution:** <br />
This error occurs in Step 6 when users incorrectly define the "par_skip_integration" parameter. If you did not perform integration in Step 5 and simply merged the samples, set "par_skip_integration" to "Yes". Otherwise, if you performed sample integration in Step 5, set "par_skip_integration" to "No". After adjusting the  "par_skip_integration" parameter to accurately reflect the analysis, re-run step 6. If the error persists please [contact](contributing.md) the development team. 

 - - - -






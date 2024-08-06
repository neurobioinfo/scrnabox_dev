# Installation
To use the scRNAbox pipeline, the folowing must be installed on your High-Performance Computing (HPC) system:

- [scrnabox.slurm](#scrnaboxslurm-installation)

 - - - -

### scrnabox.slurm installation

`scrnabox.slurm` is written in bash and can be used with any Slurm system. To download the latest version of scRNAbox run the following command: 
```
## Download the scRNAbox container
curl "https://zenodo.org/records/12751010/files/scrnabox.slurm.zip?download=1" --output scrnabox.slurm.zip

## Unzip the scRNAbox container
unzip scrnabox.slurm.zip
```

For a description of the options for running `scrnabox.slurm` run the following command:
```
export SCRNABOX_HOME=/path/to/scrnabox.slurm
bash $SCRNABOX_HOME/launch_scrnabox.sh -h 

```

If `scrnabox.slurm` has been installed properly, the above command should return the folllowing:
```
scrnabox pipeline version 0.1.53.01

------------------- 
Usage:  launch_scrnabox.sh [arguments]
        mandatory arguments:
                -d  (--dir)  = Working directory (where all the outputs will be printed) (give full path)
                --steps  =  Specify what steps, e.g., 2 to run step 2. 2-6, run steps 2 through 6

        optional arguments:
                -h  (--help)  = See helps regarding the pipeline arguments. 
                --method  = Select your preferred method: HTO and SCRNA for hashtag, and Standard scRNA, respectively. 
                --jobmode  = The default for the pipeline is Slurm. If you want to run the pipeline locally, use local as the argument. 
                --container  = The option to instruct the pipeline to utilize the container: --container TRUE. 
                --msd  = You can get the hashtag labels by running the following code (HTO Step 4). 
                --markergsea  = Identify marker genes for each cluster and run marker gene set enrichment analysis (GSEA) using EnrichR libraries (Step 7). 
                --knownmarkers  = Profile the individual or aggregated expression of known marker genes. 
                --referenceannotation  = Generate annotation predictions based on the annotations of a reference Seurat object (Step 7). 
                --annotate  = Add clustering annotations to Seurat object metadata (Step 7). 
                --addmeta  = Add metadata columns to the Seurat object (Step 8). 
                --rundge  = Perform differential gene expression contrasts (Step 8). 
                --seulist  = You can directly call the list of Seurat objects to the pipeline. 
                --rcheck  = You can identify which libraries are not installed.  
 
 ------------------- 
 For a comprehensive help, visit  https://neurobioinfo.github.io/scrnabox/site/ for documentation.

```
 - - - -


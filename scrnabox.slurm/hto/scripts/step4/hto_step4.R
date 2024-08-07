#!/usr/bin/env Rscript

####################
# step4 -- demultiplexing and doublet detection
####################
stepp0="Step IV"
cat("##########################################################################\n")
start_time0 <- Sys.time()
cat(stepp0,"has commenced.\n")
cat("##########################################################################\n")

stepp="Loading libraries and configuring parameters"
cat("#####################################\n")
cat(stepp, "started\n")
start_time <- Sys.time()

## load parameters
args = commandArgs(trailingOnly=TRUE)
output_dir=args[1]
r_lib_path=args[2]
.libPaths(r_lib_path)

## set seed for reproducibility
set.seed(1234)

## load library
packages<-c('Seurat','ggplot2', 'dplyr','foreach', 'doParallel','Matrix','tidyverse')
invisible(lapply(packages, library, character.only = TRUE))

## load parameters
source(paste(output_dir,'/job_info/parameters/step4_par.txt',sep=""))

## load Seurat object


if (exists("par_seurat_object")) {                                                  
    sample_name<-list.files(path = par_seurat_object)
    sample_nameb<-gsub(".rds","",sample_name)
    if(length(sample_name)<1) {
    print("You do not have any existing Seurat object")
    }
for (i in 1:length(sample_name)) {
    if (!grepl(".rds",tolower(sample_name[i]), fixed = TRUE)){
        print(c(sample_name[i],"is not R rds"))
    }
    }  
} else {
    sample_name<-list.files(path = paste(output_dir, "/step3/objs3",sep=""))
    sample_nameb<-gsub(".rds","",sample_name)
    if(length(sample_name)<1) {
    print("You do not have any object from step 3 ")
    }
for (i in 1:length(sample_name)) {
    if (!grepl(".rds",tolower(sample_name[i]), fixed = TRUE)){
        print(c(sample_name[i],"is not R rds"))
    }
    }
}
cat(stepp,"has been achieved. Total time:",as.numeric (Sys.time() - start_time, units = "mins"),"minutes\n")
cat("#####################################\n")

## load old and new antibody labels
# old.names<-par_old_antibody_label
# new.names<-par_new_antibody_label

par_old_new<-FALSE
if (exists("par_old_antibody_label")) {
    if (exists("par_new_antibody_label")) {
        old.names<-par_old_antibody_label
        new.names<-par_new_antibody_label
        par_old_new<-TRUE
    }
}

stepp="Doublet detection and demultiplexing"
cat("#####################################\n")
cat(stepp, "started\n")
start_time <- Sys.time()
## detect number of available cores
numCores <- detectCores()
cl <- makeCluster(numCores-1)
registerDoParallel(cl) 

## perform doublet detection and demultiplexing for each Seurat object
foreach (i_s=1:length(sample_name)) %do% {  
    set.seed(1234)
    seu<-readRDS(paste(output_dir,'/step3/objs3/',sample_name[i_s], sep=""))
    DefaultAssay(seu) <- "HTO"
    
    ## normalize and scale HTO assay
        seu <- NormalizeData(seu, assay = "HTO", normalization.method = par_normalization.method,scale.factor =par_scale.factor)
        seu <- FindVariableFeatures(seu, selection.method = par_selection.method, nfeatures = par_nfeatures)
        seu <- ScaleData(seu)
    
    ## linear dimensional reduction on HTO assay (optional)
    if (tolower(par_dimensionality_reduction)=='yes'){
        seu <- RunPCA(seu, npcs = par_npcs_pca, verbose = FALSE)
        DimPlot(seu, reduction = "pca")
        ggsave(paste(output_dir,'/step4/figs4/',sample_nameb[i_s],"_HTO_dimplot_pca",".pdf",sep=""))
        seu <- RunUMAP(seu, dims = 1:par_dims_umap, n.neighbors =par_n.neighbors)
        Seurat::DimPlot(seu, reduction = "umap")
        ggsave(paste(output_dir,'/step4/figs4/',sample_nameb[i_s],"_HTO_dimplot_umap", ".pdf",sep=""))
    }
    
    ## doublet detection and demultiplexing with MULTIseqDemux
    seu <- MULTIseqDemux(seu, assay = "HTO", quantile = par_quantile, autoThresh = par_autoThresh, maxiter = par_maxiter) 
    write.csv(table(seu$MULTI_ID), paste(output_dir,'/step4/info4/',sample_nameb[i_s],"_MULTIseqDemuxHTOcounts.csv",sep=""))
    
    ## rename droplet identities
    Idents(seu) <- "MULTI_ID"
    
    ## rename identies with new antibody label
    # multi.names <- unique(seu@meta.data$MULTI_ID)
    # # Idents(seu)  <- "MULTI_ID"
    # levels(seu@meta.data$MULTI_ID)
    # for (i in 1:length(old.names)){
    #     newIdent <- new.names[i]
    #     names(newIdent) <- old.names[i]
    #     seu <- RenameIdents(object = seu, newIdent)
    # }
    # seu[["MULTI_ID_Lables"]] <- Idents(seu)
    # # seu[['MULTI_classification']] <- NULL
    if(par_old_new){
        multi.names <- unique(seu@meta.data$MULTI_ID)
        levels(seu@meta.data$MULTI_ID)
        for (i in 1:length(old.names)){
            newIdent <- new.names[i]
            names(newIdent) <- old.names[i]
            seu <- RenameIdents(object = seu, newIdent)
        }
        seu[["MULTI_ID_Lables"]] <- Idents(seu)
    } else {
    seu[["MULTI_ID_Lables"]] <- Idents(seu)
    }
    ## print ridge plot
    RidgePlot(seu, assay = "HTO", features = rownames(seu[["HTO"]]), group.by = "MULTI_ID_Lables", ncol =par_RidgePlot_ncol) 
    ggsave(paste(output_dir,'/step4/figs4/',sample_nameb[i_s],"_Ridgeplot_HTO_MSD.pdf",sep=""),dpi = 300, height = 9, width = 9, unit = 'in' )
    
    ## print violin plot for ncount_RNA
    Idents(seu) <- "HTO_classification.global"
    VlnPlot(seu, features = "nCount_RNA", pt.size = 0.01, log = TRUE, group.by = "MULTI_ID_Lables")
    ggsave(paste(output_dir,'/step4/figs4/',sample_nameb[i_s],"_nCounts_RNA_MSD.pdf",sep=""))
    
    ## print heatmap
    DoHeatmap(seu, features = rownames(seu[["HTO"]]), group.by = "MULTI_ID_Lables")
    ggsave(paste(output_dir,'/step4/figs4/',sample_nameb[i_s],"_Heatmap_HTO_MSD.pdf",sep=""))
    
    ## print dotplot
    DotPlot(seu, features = rownames(seu[["HTO"]]), group.by = "MULTI_ID_Lables") + theme(axis.text.x = element_text(angle=45, hjust=1, vjust=1))
    ggsave(paste(output_dir,'/step4/figs4/',sample_nameb[i_s],"_DotPlot_HTO_MSD.pdf",sep=""))
    
    
    ## eliminate doublet droplets from downstream analyses
    if (tolower(par_dropDN)=='yes') {
        print('The following are deleted')
        print(par_label_dropDN)
            DefaultAssay(seu) <- "RNA"
            aa<-as.character(unique(seu$MULTI_ID))[!as.character(unique(seu$MULTI_ID)) %in% par_label_dropDN]
            Idents(seu) <- "MULTI_ID"
            seu=subset(seu,idents=aa)
    }  

    ## save rna expression matrix
    if (tolower(par_save_RNA)=='yes') {
       mat <- GetAssayData(object = seu, assay = "RNA", slot = "data")
      writeMM(mat,file= paste(output_dir,'/step4/info4/',sample_nameb[i_s],"_RNA.txt", sep=""))
    }

    ## save metadata dataframe
    if (tolower(par_save_metadata)=='yes') {
      write.csv(seu[[]], file = paste(output_dir,'/step4/info4/',sample_nameb[i_s],'_MetaData.txt', sep=""), quote = TRUE)
    }

    ## save available meta info
    write.csv(colnames(seu[[]]), file= paste(output_dir,'/step4/info4/',sample_nameb[i_s],'_meta_info_',".txt", sep=""))
    
    ## save RDS seurat object
    saveRDS(seu, paste(output_dir,'/step4/objs4/',sample_nameb[i_s],".rds", sep=""))

    ## HTO counts after doublet removal 
    write.csv(table(seu$MULTI_ID), paste(output_dir,'/step4/info4/',sample_nameb[i_s],"_filtered_MULTIseqDemuxHTOcounts.csv",sep=""))
}

cat(stepp,"has been achieved. Total time:",as.numeric (Sys.time() - start_time, units = "mins"),"minutes\n")
cat("#####################################\n")

## save session information
writeLines(capture.output(sessionInfo()), paste(output_dir,'/step4/info4/sessionInfo.txt', sep=""))

cat("##########################################################################\n")
cat(stepp0,"successfully completed. Total time:",as.numeric (Sys.time() - start_time0, units = "mins"),"minutes\n")
cat("##########################################################################\n")


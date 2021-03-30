# 2. Install BiocManager
.cran_packages  <-  c("BiocManager")
.inst <- .cran_packages %in% installed.packages()
if (any(!.inst)) {
  install.packages(.cran_packages[!.inst], repos = "http://cran.rstudio.com/")
}

# 3. Download packages from biocLite
.bioc_packages <- c("phyloseq", "genefilter", "impute", "Biostrings", "GenomeInfoDbData", "dada2==1.6")
.inst <- .bioc_packages %in% installed.packages()
if (any(!.inst)) {
  BiocManager::install(.bioc_packages[!.inst])
}

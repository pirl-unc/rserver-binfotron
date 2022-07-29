FROM rocker/verse:4.2.1
# OS: GNU/Linux Ubuntu 20.04 LTS (focal)

# For adding metadata to pdfs
RUN apt-get update && apt-get install -y pdftk
RUN apt-get clean

RUN R -e "install.packages('pzfx', ref = '0.3.0')"

# Adding common R Packages that aren't in rocker/verse
RUN R -e "install.packages(c('pzfx', 'R6', 'checkmate', 'cowplot', 'ggrepel', 'pryr'))" #removed viridis and BiocManager as they are already installed in the base verse:4.2.1
# 
RUN R -e "BiocManager::install('DESeq2')"
# 
RUN R -e "devtools::install_github('jokergoo/ComplexHeatmap@2bb14c911d31c8c39514e0a6d33a01017d8b3721')" #version 2.13.1, untagged, using last commit for which all testing checks passed
# For making quality png rasters for ComplexHeatmaps
# RUN apt-get update && apt-get install -y libmagick++-dev #comes pre-installed in verse:4.2.1
RUN R -e "install.packages('magick', ref = '2.7.3')"
# 
# add xlsx
RUN R CMD javareconf
# RUN R -e "devtools::install_version('rJava', '1.0.6')" #this version of rJava is already installed in base verse:4.2.1
RUN R -e "devtools::install_version('xlsxjars', '0.6.1')"
RUN R -e "devtools::install_version('xlsx', '0.6.5')"
# 
# for doing mtb elastic net
# RUN apt-get update && apt-get -y install tcl8.6-dev tk8.6-dev #tcl/tk is already built into verse:4.2.1
RUN R -e "BiocManager::install('survcomp')" #installs 1.46.0
RUN R -e "BiocManager::install('sm')" #installs 2.2.5.7.1 ( longest version number ever ... )
RUN R -e "install.packages('Epi', ref='2.47')"
# 
# For converting genes
# RUN R -e "BiocManager::install('annotate')" #already installed at version 1.74.0 with a previously installed package
RUN R -e "BiocManager::install('org.Hs.eg.db')" #installs 3.15.0
# 
# For diversity metrics
RUN R -e "devtools::install_github('vegandevs/vegan', ref = 'v2.6-2')" 
# 
# Add tabulizer for getting tables out of pdf's. Melero_GBM_2019 dataset
RUN R -e "devtools::install_github('leeper/tabulizerjars', ref='v1.0.1')"
RUN R -e "devtools::install_github('ropensci/tabulizer', ref = 'v0.2.2')"
# 
# add glmnet to allow use of corrected metrics
RUN R -e "devtools::install_github('cran/glmnet', ref = '4.1-4')"
# 
# for viewing pca: autoplot, prcomp and fviz_eig, respectively
RUN R -e "install.packages('ggfortify', ref = '0.4.14')"
RUN R -e "install.packages('cluster', ref = '2.1.3')"
RUN R -e "install.packages('factoextra', ref = '1.0.7')"
# 
# Provides a parallel backend for the %dopar% function using the multicore functionality of the parallel package.
RUN R -e "install.packages('doMC', ref = '1.3.8')"
# 
# For using caret package to build models
RUN R -e "install.packages('xgboost', ref = '1.6.0.1')"
RUN R -e "install.packages('caret', ref = '6.0-92')"
# 
# Packages for running MIRACLE 
RUN R -e "devtools::install_github('miccec/yaGST@56227df3ae183070c9d156af11c306ee799435e6')" # 2017.08.25 not tagged
RUN R -e "devtools::install_github('tolgaturan-github/Miracle@f984931102a631fd20d67a80a9b40f080681dba5')" #untagged version 0.0.0.9000
# Need to add Hmisc and ggnewscale
RUN R -e "install.packages('Hmisc',ref='4.7-0')"
RUN R -e "install.packages('ggnewscale', ref='0.4.7')"
# RUN R -e "devtools::install_github('sjmgarnier/viridisLite', ref = 'v0.4.0')" # Already exists in verse:4.2.1
#
#add survminer, ggpubr for making kmplots
RUN R -e "install.packages('survminer',ref='0.4-9')"
RUN R -e "install.packages('ggpubr', ref='0.4.0')"
RUN R -e "devtools::install_version('VennDiagram', version='1.7.3')"
#
# Lab packages last because we update them often
RUN R -e "devtools::install_github('benjamin-vincent-lab/housekeeping', ref = '0.3.1')"
RUN R -e "devtools::install_github('benjamin-vincent-lab/datasetprep', ref = '0.3.2')"
RUN R -e "devtools::install_github('benjamin-vincent-lab/binfotron', ref = '0.6-15')"
# 
# PostRNASeqAlign needs to go after binfotron
RUN R -e "devtools::install_github('benjamin-vincent-lab/PostRNASeqAlign', ref = '0.4-13')"

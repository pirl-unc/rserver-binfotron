FROM rocker/verse:4.0.3
# OS: GNU/Linux Ubuntu 20.04 LTS (focal)

# For adding metadata to pdfs
RUN apt-get update && apt-get install -y pdftk
RUN apt-get clean

# Adding common R Packages that aren't in rocker/verse
RUN R -e "install.packages(c('pzfx', 'R6', 'checkmate', 'BiocManager', 'cowplot', 'ggrepel', 'pryr', 'viridis'))"
RUN R -e "BiocManager::install('DESeq2')"

RUN R -e "devtools::install_github('jokergoo/ComplexHeatmap')"
# For making quality png rasters for ComplexHeatmaps
RUN apt-get update && apt-get install -y libmagick++-dev
RUN R -e "install.packages('magick', ref = '2.3')"

# add xlsx
RUN R CMD javareconf
RUN R -e "devtools::install_version('rJava')"
RUN R -e "devtools::install_version('xlsxjars')"
RUN R -e "devtools::install_version('xlsx')"

# for doing mtb elastic net
RUN apt-get update && apt-get -y install tcl8.6-dev tk8.6-dev
RUN R -e "BiocManager::install('survcomp')"
RUN R -e "BiocManager::install('sm')"
RUN R -e "install.packages('Epi')"

# For converting genes
RUN R -e "BiocManager::install('annotate')"
RUN R -e "BiocManager::install('org.Hs.eg.db')"

# For diversity metrics
RUN R -e "devtools::install_github('vegandevs/vegan', ref = 'v2.5-3')" 

# Add tabulizer for getting tables out of pdf's. Melero_GBM_2019 dataset
RUN R -e "devtools::install_github('ropensci/tabulizer', ref = 'v0.2.2')"

# add glmnet to allow use of corrected metrics
RUN R -e "devtools::install_github('cran/glmnet', ref = '2.0-18')"

# for viewing pca: autoplot, prcomp and fviz_eig, respectively
RUN R -e "install.packages('ggfortify', ref = '0.4.11')"
RUN R -e "install.packages('cluster', ref = '2.1.0')"
RUN R -e "install.packages('factoextra', ref = '1.0.7')"

# Provides a parallel backend for the %dopar% function using the multicore functionality of the parallel package.
RUN R -e "install.packages('doMC', ref = '1.3.7')"

# For using caret package to build models
RUN R -e "install.packages('xgboost', ref = '1.3.2.1')"
RUN R -e "install.packages('caret', ref = '6.0-86')"

# Packages for running MIRACLE 
RUN R -e "devtools::install_github('miccec/yaGST@56227df3ae183070c9d156af11c306ee799435e6')" # 2017.08.25 not tagged
RUN R -e "devtools::install_github('tolgaturan-github/Miracle@fec34ca2a55a45d68de291b9b1481b3deeca1d01')" # 0.0.0.9000 not tagged

# Lab packages last because we update them often
RUN R -e "devtools::install_github('benjamin-vincent-lab/binfotron', ref = '0.6-00')"
RUN R -e "devtools::install_github('benjamin-vincent-lab/housekeeping', ref = '0.2-11')"

# PostRNASeqAlign needs to go after binfotron
RUN R -e "devtools::install_github('benjamin-vincent-lab/PostRNASeqAlign', ref = '0.4-11')"
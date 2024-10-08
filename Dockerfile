FROM rocker/verse:4.4.1
# OS: GNU/Linux Ubuntu 20.04 LTS (focal fossa)

# For adding metadata to pdfs and generating LATEX reports
RUN \
  apt-get update && apt-get install -y \
    pdftk \
    texlive-base \
    texlive-binaries \
    texlive-pictures \
    texlive-latex-base \
    texlive-latex-recommended \
    texlive-latex-extra

# for making nice trees of directory structures
RUN \
  apt-get install -y tree

RUN \
  apt-get clean

RUN R -e "install.packages('pzfx', ref = '0.3.0')"

# Adding common R Packages that aren't in rocker/verse
RUN \
  R -e "install.packages(c('R6', 'checkmate', 'cowplot', 'ggrepel', 'pryr'))" && \
  R -e "BiocManager::install('DESeq2')" && \
  R -e "devtools::install_github('jokergoo/ComplexHeatmap@ae0ec42cd2e4e0446c114d23dcf43cf2c2f585c8')" #version 2.15.4, untagged, using last commit for which all testing checks passed

# For making quality png rasters for ComplexHeatmaps
RUN R -e "install.packages('magick', ref = '2.8.5')"

# Tried for a Java free version, but readxl needs libxls,
#   which doesn't look like an easy install 
#   and openxlsx doesn't open 'xls' files.
RUN \
  R CMD javareconf && \ 
  R -e "devtools::install_version('xlsxjars', '0.6.1')" && \
  R -e "devtools::install_version('xlsx', '0.6.5')"

# Getting lots of bugs from xlsx package so added openxlsx as well
# Keeping xlsx for .xls files
RUN R -e "install.packages('openxlsx', ref = '4.2.7.1')"

# For doing mtb elastic net
#   BiocManager versions controlled by BiocManager
RUN \
  R -e "BiocManager::install('survcomp')" && \
  R -e "BiocManager::install('sm')" && \
  R -e "install.packages('Epi', ref='2.55')"

# For converting genes
RUN R -e "BiocManager::install('org.Hs.eg.db')" #installs 3.19.0

# For diversity metrics
RUN R -e "devtools::install_github('vegandevs/vegan', ref = 'v2.6-8')"

# Add tabulizer for getting tables out of pdf's. Melero_GBM_2019 dataset
RUN \
  R -e "devtools::install_github('leeper/tabulizerjars', ref = 'v1.0.1')" && \
  R -e "devtools::install_github('ropensci/tabulizer', ref = 'v0.2.2')"

# add glmnet to allow use of corrected metrics
RUN R -e "devtools::install_github('cran/glmnet', ref = '4.1-8')"

# for viewing pca: autoplot, prcomp and fviz_eig, respectively
RUN \
  R -e "install.packages('ggfortify', ref = '0.4.17')" && \
  R -e "install.packages('cluster', ref = '2.1.6')" && \
  R -e "install.packages('factoextra', ref = '1.0.7')"

# Provides a parallel backend for the %dopar% function using the multicore functionality of the parallel package.
RUN R -e "install.packages('doMC', ref = '1.3.8')"

# For using caret package to build models
# DiagrammeRsvg & rsvg for making xgbtrees into pdfs.
# RhpcBLASctl for allowing xgbtree to set it's threads to 1 
#   so that caret can do multithreading with xgbtree
RUN \
  R -e "install.packages('xgboost', ref = '1.7.8.1')" && \
  R -e "install.packages('caret', ref = '6.0-94')" && \
  R -e "install.packages('DiagrammeRsvg', ref = '0.1')" && \
  R -e "install.packages('rsvg', ref = '2.6.1')" && \
  R -e "install.packages('RhpcBLASctl', ref = '0.23-42')"

# Packages for running MIRACLE
#   miccec 2017.08.25 not tagged
#   Miracle untagged version 0.0.0.9000
RUN \
  R -e "devtools::install_github('miccec/yaGST@56227df3ae183070c9d156af11c306ee799435e6')" && \ 
  R -e "devtools::install_github('tolgaturan-github/Miracle@f984931102a631fd20d67a80a9b40f080681dba5')" 

# Need to add Hmisc and ggnewscale
RUN \ 
  R -e "install.packages('Hmisc',ref='5.1-3')" && \ 
  R -e "install.packages('ggnewscale', ref='0.5.0')"

# For making kmplots
RUN \
  R -e "install.packages('survminer',ref='0.4.9')" && \ 
  R -e "install.packages('ggpubr', ref='0.6.0')" && \ 
  R -e "devtools::install_version('VennDiagram', version='1.7.3')"

# Needed for ROC curves
RUN R -e "install.packages('pROC', ref='1.18.5')"

# Specific to modeling
RUN R -e "install.packages('caretEnsemble', ref = '4.0.1')"
RUN R -e "install.packages('forestmodel', ref = '0.6.2')"
RUN R -e "install.packages('survival', ref = '3.7-0')"

RUN R -e "install.packages('dgof', ref='1.4')"  # Discrete Goodness-of-Fit Tests
RUN R -e "install.packages('pls', ref='2.8-5')"

# Calculating gsva & ssgsea scores
RUN R -e "BiocManager::install('GSVA')"

RUN R -e "install.packages('DescTools', ref='0.99.57')" # Lin's numeric concordance
RUN R -e "install.packages('vcd', ref='1.4.13')"  	# Ordinal concordance
RUN R -e "install.packages('ggforce', ref = '0.4.2')"  	# for geom_mark_ellipse

# For stratifying sets based on multiple columns
RUN R -e "install.packages('splitstackshape', ref='1.4.8')"

# For 3D plots
RUN R -e "install.packages('plotly', ref='4.10.4')"

# For sequence logos
RUN \
  R -e "BiocManager::install('msa')" && \
  R -e "install.packages('ggseqlogo', ref='0.2')"

# for random-effects model meta-analysis
RUN \
  R -e "install.packages('metafor', ref='4.6-0')"

# for double-density plots
RUN \
  R -e "install.packages('ggridges', ref='0.5.6')"

# updating some packages that were already on tidyverse
RUN \
  R -e "install.packages('ggplot2', ref='3.5.1')" && \
  R -e "install.packages('tidyselect', ref='1.2.1')" && \
  R -e "install.packages('tidyr', ref='1.3.1')"

RUN R -e "install.packages('argparse', ref='2.2.3')"
RUN R -e "install.packages('NMF', ref='0.28')"
RUN R -e "install.packages('config', ref='0.3.2')"

# Adding the lab packages last because we update them often
RUN R -e "devtools::install_github('benjamin-vincent-lab/housekeeping', ref = '0.3.7')" # needs to go first as the others use it
RUN R -e "devtools::install_github('benjamin-vincent-lab/datasetprep', ref = '0.4.13')"
RUN R -e "devtools::install_github('benjamin-vincent-lab/binfotron', ref = '0.11.2')"

# Needs to go after binfotron
RUN R -e "devtools::install_github('benjamin-vincent-lab/PostRNASeqAlign', ref = '0.6.0')" 


# Need to allow access to libraries so the user can upgrade over it for temp fixes
#   This is one place where the Docker-run container is different than Singularity.
#   Docker will run as root and allow the changes, Singularity will run as $USER 
#   and won't allow the change unless we update the permissions.
# RUN \
#   find /usr/local/lib/R/site-library -type d -exec chmod 2777 {} \; && \
#   find /usr/local/lib/R/site-library -type f -exec chmod 666 {} \; && \
#   find /usr/local/lib/R/library -type d -exec chmod 2777 {} \; && \
#   find /usr/local/lib/R/library -type f -exec chmod 666 {} \;
# Here we also need to set up an overlay in singularity, which I haven't figured 
# out yet.  See:
# https://docs.sylabs.io/guides/3.5/user-guide/persistent_overlays.html
# https://pawseysc.github.io/singularity-containers/32-writable-trinity/index.html
# ^^^ problem I ran in to here was '-d' not being a valid flag for mkfs.ext3

# to test, run image, log in to rstudio and do:
# pkgs <- c('org.Hs.eg.db', 'vegan', 'glmnet', 'ggfortify', 'cluster', 'xgboost', 'caret', 'rsvg', 'ggnewscale', 'survminer', 'ggpubr', 'pROC', 'caretEnsemble', 'survival', 'pls', 'DescTools', 'vcd', 'ggforce', 'plotly', 'openxlsx', 'Epi', 'Hmisc')
# v <- installed.packages()[ pkgs, 3] # this gets the version numbers as a named character vector
# now compare to the versions that should be showing up


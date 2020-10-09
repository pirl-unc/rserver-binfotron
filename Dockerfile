FROM benjaminvincentlab/rserver:4.0.0.2
# OS: Debian GNU/Linux 9 (stretch)

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

# add glmnet to allow use of corrected 
RUN R -e "devtools::install_github('cran/glmnet', ref = '2.0-18')"

# for viewing pca: autoplot, prcomp and fviz_eig, respectively
RUN R -e "install.packages('ggfortify', ref = '0.4.11')"
RUN R -e "install.packages('cluster', ref = '2.1.0')"
RUN R -e "install.packages('factoextra', ref = '1.0.7')"

# Lab packages last because we update them often
RUN R -e "devtools::install_github('benjamin-vincent-lab/housekeeping', ref = '0.2-01')"
RUN R -e "devtools::install_github('benjamin-vincent-lab/binfotron', ref = '0.3-20')"

# needs to go after binfotron
RUN R -e "devtools::install_github('benjamin-vincent-lab/StarSalmon', ref = '0.2-02')"

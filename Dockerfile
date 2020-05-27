FROM benjaminvincentlab/rserver:3.6.1.4
# OS: Debian GNU/Linux 9 (stretch)


# Should move this before StarSalmon next time

# For converting genes
RUN R -e "BiocManager::install('annotate')"
RUN R -e "BiocManager::install('org.Hs.eg.db')"

# For diversity metrics
RUN R -e "devtools::install_github('vegandevs/vegan', ref = 'v2.5-3')" 

# Add tabulizer for getting tables out of pdf's. Melero_GBM_2019 dataset
RUN R -e "devtools::install_github('ropensci/tabulizer', ref = 'v0.2.2')"

# add glmnet to allow use of corrected 
RUN R -e "devtools::install_github('cran/glmnet', ref = '2.0-18')"

# Lab packages last because we update them often
RUN R -e "devtools::install_github('benjamin-vincent-lab/housekeeping', ref = '0.2-00')" 
RUN R -e "devtools::install_github('benjamin-vincent-lab/binfotron', ref = '0.3-12')" 
RUN R -e "devtools::install_github('benjamin-vincent-lab/StarSalmon', ref = '0.1-04')" 

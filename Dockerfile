FROM benjaminvincentlab/rserver:3.6.1.4
# OS: Debian GNU/Linux 9 (stretch)

RUN R -e "devtools::install_github('benjamin-vincent-lab/housekeeping', ref = '0.2-00')"
RUN R -e "devtools::install_github('benjamin-vincent-lab/binfotron', ref = '0.3-03')"
RUN R -e "BiocManager::install('annotate')"
RUN R -e "BiocManager::install('org.Hs.eg.db')"
RUN R -e "devtools::install_github('benjamin-vincent-lab/StarSalmon', ref = '0.1-04')"

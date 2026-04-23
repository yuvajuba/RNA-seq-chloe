-rw-rw-r-- 1 bioinfo bioinfo     2041 avril 23 16:47 data_prep.R
-rw-rw-r-- 1 bioinfo bioinfo 67486451 avril 23 11:51 featurecounts_results.txt
-rw-rw-r-- 1 bioinfo bioinfo     6432 avril 23 11:51 featurecounts_results.txt.summary
-rw-rw-r-- 1 bioinfo bioinfo     3715 avril 23 16:34 FeatureCount_summary.csv
-rw-rw-r-- 1 bioinfo bioinfo 58235395 avril 23 16:34 Genomic_coordinates.csv
-rw-rw-r-- 1 bioinfo bioinfo 11621083 avril 23 16:34 Raw_counts.csv
-rw-rw-r-- 1 bioinfo bioinfo  8170225 avril 23 16:43 Raw_counts_prefiltered.csv


    #################
  #####################
#######  Details  #######
  #####################
    #################


# data_prep.R :
# -------------
script pour la préparation de données

# featureCounts_out.txt : 
# -----------------------
fichier de sortie de featureCounts (fichier brut) correspondant au comptes brutes ainsi que les coordonnés génomiques des génes


# featureCounts_out.txt.summary :
# -------------------------------
fichier de sortie de featureCounts correspondant aux résumer de l'analyse (featureCounts) 


# FeatureCount_summary.csv :
# --------------------------
résumer de featureCounts bien formaté + converie en csv  


# Genomic_coordinates.csv :
# -------------------------
Coordonnées génomique bien formater



# Raw_counts.csv :
# ----------------
Table de compte, bien formaté


# Raw_counts_prefiltered.csv :
# ----------------------------
Table des comptes pré-filtré = retiré que les génes non exprimé dans tous les échantillons (rowSums des compte de gènes < 5)

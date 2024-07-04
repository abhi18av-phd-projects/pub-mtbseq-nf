
rm *dateremoved.tab
rm *formatted.tab

awk '{sub(/[^\t]*/,"");sub(/\t/,"")} 1' Mapping_and_Variant_Statistics.tab >> Mapping_and_Variant_Statistics.dateremoved.tab
awk '{sub(/[^\t]*/,"");sub(/\t/,"")} 1' Strain_Classification.tab >> Strain_Classification.dateremoved.tab

awk '{gsub(/'\''/,"")} 1' Mapping_and_Variant_Statistics.dateremoved.tab >> Mapping_and_Variant_Statistics.formatted.tab
awk '{gsub(/'\''/,"")} 1' Strain_Classification.dateremoved.tab >> Strain_Classification.formatted.tab

python make_symmetric_matrix.py


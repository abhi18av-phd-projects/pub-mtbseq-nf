param (
    $filename
)

$parentPath = Split-Path $filename -Parent
$fileLeaf = Split-Path $filename -Leaf

cd $parentPath 

echo "iqtree.$($filename)" 

micromamba run -p ~/.micromamba/envs/iqtree-env `
    iqtree  `
    -T AUTO `
    --fast `
    --prefix "iqtree.$($filename)" `
    -s  $filename

<#
 iqtree `
     -s mtbseqnf_joint_cf4_cr4_fr75_ph4_samples90_amended_u95_phylo_w12.fasta `
     -T AUTO `
     -fast `
     --prefix iqtol.mtbseqnf_joint_cf4_cr4_fr75_ph4_samples91_amended_u95_phylo

#>

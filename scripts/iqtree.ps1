param (
    $path,
    $filename
)

cd $path 

micromamba run -p ~/.micromamba/envs/iqtree-env `
    iqtree  `
    -T AUTO `
    --fast `
    --prefix "iqtree.$($filename)" `
    -s  $filename

cd /Users/abhi/projects/MTBseq-nf/_resources/publication/analysis


# iqtree \
#     -s mtbseqnf_joint_cf4_cr4_fr75_ph4_samples91_amended_u95_phylo.fasta \
#     -T AUTO \
#     -fast \
#     --prefix iqtol


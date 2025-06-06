param (
    $fileName,
    $dirName
)

<#
 iqtree `
     -s mtbseqnf_joint_cf4_cr4_fr75_ph4_samples90_amended_u95_phylo_w12.fasta `
     -T AUTO `
     -fast `
     --prefix iqtol.mtbseqnf_joint_cf4_cr4_fr75_ph4_samples91_amended_u95_phylo

#>

function Run-IqtreeInFolder {
    param (
        [string]$filename
    )

    # Get the current directory
    $originalDirectory = Get-Location

    # Navigate to the file's directory
    $parentPath = $dirName
    Set-Location $parentPath

    # Run iqtree
    $fileLeaf = (Split-Path $filename -Leaf).Split('.')[0]
    echo "iqtree.$($fileLeaf)" 

    micromamba run -p ~/.micromamba/envs/iqtree-env `
        iqtree  `
        -T AUTO `
        --fast `
        --prefix "iqtree.$($fileLeaf)" `
        -s  $filename

    # Return to the original directory
    Set-Location $originalDirectory
}


Run-IqtreeInFolder -filename $fileName
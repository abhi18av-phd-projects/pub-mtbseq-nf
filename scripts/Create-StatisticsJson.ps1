<#Usage

./Create-Statistics.ps1 `
    -FoldersPrefix mtbseq `
    -OutputName Statistics.json 

# IMPORTANT: convert to json module is required to run this SCRIPT
# Where FoldersPrefix is the initial prefix of each folder for this script look at statistics TSV files
# OutputName is the final JSON file containing the statistics for each sample

#>


#==============================
# Parameters
#==============================



# Add 2 parameteres for the input
param(
    $FoldersPrefix,
    $OutputName
)


#==============================
# Functions
#==============================

function Add-Experiment {
    param (
        [string]$Name
    )
    $experiment = [PSCustomObject]@{
        statistics     = @{}
        classification = @{}
        group          = @{}
    }
    $results.experiments[$Name] = $experiment
    return $experiment
}

#==============================
# MAIN
#==============================



$results = [PSCustomObject]@{
    Experiments = @{}
}

$folders = Get-ChildItem -Path $foldersPrefix*
foreach ($folder in $folders) {
    $experimentName = $folder.name
    $experiment = Add-Experiment -Name $experimentName
    

        ## Add Statistics
        if ($folder.ToString().Contains("parallel")) {
            $finalFolder = "tbstats/Statistics"
        } elseif ($folder.ToString().Contains("standard")) {
            $finalFolder = "Statistics"
        } else {
            $finalFolder = "tbfull/Statistics"
        }

    Write-Host "Processing: $experimentName Statistics"
    Write-Host "$folder => $finalFolder"
    $experimentStatistics = Get-Content "$folder/$finalFolder/Mapping_and_Variant_Statistics.tab" | Select-Object -Skip 1
    foreach ($line in $experimentStatistics) {
	    
        $sampleID = $line.split("`t")[1].replace("`'", "")
             
        $statisticsObject = @{
            "Date"                         = $line.split("`t")[0].replace("`'", "")
            "SampleID"                     = $line.split("`t")[1].replace("`'", "")
            "LibraryID"                    = $line.split("`t")[2].replace("`'", "")
            "FullID"                       = $line.split("`t")[3].replace("`'", "")
            "TotalReads"                   = $line.split("`t")[4].replace("`'", "")
            "MappedReads"                  = $line.split("`t")[5].replace("`'", "")
            "MappedReadsPercent"           = $line.split("`t")[6].replace("`'", "")
            "GenomeSize"                   = $line.split("`t")[7].replace("`'", "")
            "GenomeGC"                     = $line.split("`t")[8].replace("`'", "")
            "TotalBases"                   = $line.split("`t")[9].replace("`'", "")
            "TotalBasesPercent"            = $line.split("`t")[10].replace("`'", "")
            "GCContent"                    = $line.split("`t")[11].replace("`'", "")
            "CoverageMean"                 = $line.split("`t")[12].replace("`'", "")
            "CoverageMedian"               = $line.split("`t")[13].replace("`'", "")
            "TotalBasesUnambiguous"        = $line.split("`t")[14].replace("`'", "")
            "TotalBasesPercentUnambiguous" = $line.split("`t")[15].replace("`'", "")
            "GCContentUnambiguous"         = $line.split("`t")[16].replace("`'", "")
            "CoverageMeanUnambiguous"      = $line.split("`t")[17].replace("`'", "")
            "CoverageMedianUnambiguous"    = $line.split("`t")[18].replace("`'", "")
            "SNPs"                         = $line.split("`t")[19].replace("`'", "")
            "Deletions"                    = $line.split("`t")[20].replace("`'", "")
            "Insertions"                   = $line.split("`t")[21].replace("`'", "")
            "Uncovered"                    = $line.split("`t")[22].replace("`'", "")
            "Substitutions"                = $line.split("`t")[23].replace("`'", "")
        }

        $experiment.statistics[$sampleID] += $statisticsObject

    }


        ## Add Classification
        Write-Host "Processing: $experimentName Classifications"
        if ($folder.ToString().Contains("parallel")) {
            $finalFolder = "tbstrains/Classification"
        } elseif ($folder.ToString().Contains("standard")) {
            $finalFolder = "Classification"
        } else {
            $finalFolder = "tbfull/Classification"
        }

    Write-Host "$folder => $finalFolder"
    $experimentClassification = Get-Content "$folder/$finalFolder/Strain_Classification.tab" | Select-Object -Skip 1
    foreach ($line in $experimentClassification) {
        $sampleID = $line.split("`t")[1].replace("`'", "")

        $classificationObject = @{
            "Date"                  = $line.split("`t")[0].replace("`'", "")
            "SampleID"              = $line.split("`t")[1].replace("`'", "")
            "LibraryID"             = $line.split("`t")[2].replace("`'", "")
            "FullID"                = $line.split("`t")[3].replace("`'", "")
            "HomolkaSpecies"        = $line.split("`t")[4].replace("`'", "")
            "HomolkaLineage"        = $line.split("`t")[5].replace("`'", "")
            "HomolkaGroup"          = $line.split("`t")[6].replace("`'", "")
            "Quality"               = $line.split("`t")[7].replace("`'", "")
            "CollLineageBranch"     = $line.split("`t")[8].replace("`'", "")
            "CollLineageNameBranch" = $line.split("`t")[9].replace("`'", "")
            "CollQualityBranch"     = $line.split("`t")[10].replace("`'", "")
            "CollLineageEasy"       = $line.split("`t")[11].replace("`'", "")
            "CollLineageNameEasy"   = $line.split("`t")[12].replace("`'", "")
            "CollQualityEasy"       = $line.split("`t")[13].replace("`'", "")
            "BeijingLineageEasy"    = $line.split("`t")[14].replace("`'", "")
            "BeijingQualityEasy"    = $line.split("`t")[15].replace("`'", "")
        }


        $experiment.classification[$sampleID] += $classificationObject
    }

    ## Add Group (clusters)
        Write-Host "Processing: $experimentName Group"
        if ($folder.ToString().Contains("parallel")) {
            $finalFolder = "tbgroups/Groups"
        } elseif ($folder.ToString().Contains("standard")) {
            $finalFolder = "Groups"
        } else {
            $finalFolder = "tbgroups/Groups"
        }

    Write-Host "$folder => $finalFolder"
    
    $experimentGroup = Get-Content "$folder/$finalFolder/*_joint_*.groups"
    $trimAt = ($experimentGroup | Select-String "### Output as lists").LineNumber 
    foreach ($line in ($experimentGroup | Select-Object -Skip $trimAt)) {
        $sampleID = $line.split("`t")[0].replace("`'", "")
        $groupObject = @{
            "Group" = $line.split("`t")[1].replace("`'", "")
        }
        $experiment.group[$sampleID] += $groupObject
    }


    # ## Add Group (Matrix)
        Write-Host "Processing: $experimentName Matrix"
        if ($folder.ToString().Contains("parallel")) {
            $finalFolder = "tbgroups/Groups"
        } elseif ($folder.ToString().Contains("standard")) {
            $finalFolder = "Groups"
        } else {
            $finalFolder = "tbgroups/Groups"
        }

    Write-Host "$folder => $finalFolder"
    
    $experimentMatrix = Get-Content "$folder/$finalFolder/*_joint_*.matrix"  | Select-Object -Skip 1
    foreach ($line in $experimentMatrix ) {
        $sampleID = $line.split("`t")[0].replace("`'", "").split("_")[0]
         
        $matrixObject = @{
            "matrix" = ($line.split("`t") | Select-Object -Skip 1)  -join "`t"
        }
        $experiment.group[$sampleID] += $matrixObject
    }



}


$results | ConvertTo-Json -Depth 5 | Out-File $outputName


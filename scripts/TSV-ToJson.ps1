<#Usage

./TSV-ToJson.ps1 `
    -FoldersPrefix mtbseq-nf-normal `
    -OutputName result.json 

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
        samples = @{}
    }
    $results.experiments[$Name] = $experiment
    return $experiment
}

function Add-Sample {
    param (
        [PSCustomObject]$Experiment,
        [string]$SampleID,
        [hashtable]$Data
    )
    $Experiment.samples[$SampleID] = $Data
}

#==============================
# MAIN
#==============================





$results = [PSCustomObject]@{
    Experiments = @{}
}



$folders = Get-ChildItem -Path $foldersPrefix*
foreach($folder in $folders){
	$experimentName = $folder.name

	Write-Host "Processing: $experimentName"

        $experiment = Add-Experiment -Name $experimentName

	$experimentStatistics = Get-Content "$folder/Statistics/Mapping_and_Variant_Statistics.tab" | Select-Object -Skip 1
	
	foreach($line in $experimentStatistics){
	
	$sampleID = $line.split("`t")[1].replace("`'","")
             
	$sampleObject = @{
            "Date"                         = $line.split("`t")[0].replace("`'","")
            "SampleID"                     = $line.split("`t")[1].replace("`'","")
            "LibraryID"                    = $line.split("`t")[2].replace("`'","")
            "FullID"                       = $line.split("`t")[3].replace("`'","")
            "TotalReads"                   = $line.split("`t")[4].replace("`'","")
            "MappedReads"                  = $line.split("`t")[5].replace("`'","")
            "MappedReadsPercent"           = $line.split("`t")[6].replace("`'","")
            "GenomeSize"                   = $line.split("`t")[7].replace("`'","")
            "GenomeGC"                     = $line.split("`t")[8].replace("`'","")
            "TotalBases"                   = $line.split("`t")[9].replace("`'","")
            "TotalBasesPercent"            = $line.split("`t")[10].replace("`'","")
            "GCContent"                    = $line.split("`t")[11].replace("`'","")
            "CoverageMean"                 = $line.split("`t")[12].replace("`'","")
            "CoverageMedian"               = $line.split("`t")[13].replace("`'","")
            "TotalBasesUnambiguous"        = $line.split("`t")[14].replace("`'","")
            "TotalBasesPercentUnambiguous" = $line.split("`t")[15].replace("`'","")
            "GCContentUnambiguous"         = $line.split("`t")[16].replace("`'","")
            "CoverageMeanUnambiguous"      = $line.split("`t")[17].replace("`'","")
            "CoverageMedianUnambiguous"    = $line.split("`t")[18].replace("`'","")
            "SNPs"                         = $line.split("`t")[19].replace("`'","")
            "Deletions"                    = $line.split("`t")[20].replace("`'","")
            "Insertions"                   = $line.split("`t")[21].replace("`'","")
            "Uncovered"                    = $line.split("`t")[22].replace("`'","")
            "Substitutions"                = $line.split("`t")[23].replace("`'","")
         }
       Add-Sample -Experiment $experiment -SampleID $sampleID -Data $sampleObject

       $results | ConvertTo-Json -Depth 5 | Out-File $outputName
       

	}



}


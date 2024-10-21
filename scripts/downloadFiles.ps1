rclone ls oci-s3-phd-af:MTBSEQ-NF/results/pub-05-samples-parallel/tbstats/Statistics

#=====================================================
# PARALLEL results
#=====================================================

$parallelResults = @(
    "pub-05samples-parallel",
    "pub-10samples-parallel",
    "pub-20samples-parallel",
    "pub-40samples-parallel",
    "pub-80samples-parallel",

    "pub-90samples-parallel-run1",
    "pub-90samples-parallel-run2",
    "pub-90samples-parallel-run3"

)

foreach ($fldr in $parallelResults) {


     rclone copy "oci-s3-phd-af:MTBSEQ-NF/results/$fldr/misc" v2/$fldr/misc -P
     rclone copy "oci-s3-phd-af:MTBSEQ-NF/results/$fldr/multiqc" v2/$fldr/multiqc -P
     rclone copy "oci-s3-phd-af:MTBSEQ-NF/results/$fldr/pipeline_info" v2/$fldr/pipeline_info -P
     rclone copy "oci-s3-phd-af:MTBSEQ-NF/results/$fldr/tbamend/Amend" v2/$fldr/tbamend/Amend -P
     rclone copy "oci-s3-phd-af:MTBSEQ-NF/results/$fldr/tbgroups/Groups" v2/$fldr/tbgroups/Groups -P
     rclone copy "oci-s3-phd-af:MTBSEQ-NF/results/$fldr/tbjoin/Joint" v2/$fldr/tbjoin/Joint -P

    rclone copy "oci-s3-phd-af:MTBSEQ-NF/results/$fldr/tbstats/Statistics" v2/$fldr/tbstats/Statistics  -P
    rclone copy "oci-s3-phd-af:MTBSEQ-NF/results/$fldr/tbstrains/Classification" v2/$fldr/tbstrains/Classification  -P

}


#=====================================================
# STANDARD results
#=====================================================
$defaultResults = @(
    "pub-05samples",
    "pub-10samples",
    "pub-20samples",
    "pub-40samples",
    "pub-80samples",
    "pub-90samples-run1",
    "pub-90samples-run2",
    "pub-90samples-run3"
)

foreach ($fldr in $defaultResults) {


    #rclone copy "oci-s3-phd-af:MTBSEQ-NF/results/$fldr/misc" v2/$fldr/misc -P
    #rclone copy "oci-s3-phd-af:MTBSEQ-NF/results/$fldr/multiqc" v2/$fldr/multiqc -P
    #rclone copy "oci-s3-phd-af:MTBSEQ-NF/results/$fldr/pipeline_info" v2/$fldr/pipeline_info -P
    #rclone copy "oci-s3-phd-af:MTBSEQ-NF/results/$fldr/tbamend/Amend" v2/$fldr/tbamend/Amend -P
    #rclone copy "oci-s3-phd-af:MTBSEQ-NF/results/$fldr/tbgroups/Groups" v2/$fldr/tbgroups/Groups -P
    #rclone copy "oci-s3-phd-af:MTBSEQ-NF/results/$fldr/tbjoin/Joint" v2/$fldr/tbjoin/Joint -P


    rclone copy "oci-s3-phd-af:MTBSEQ-NF/results/$fldr/tbfull/Statistics" v2/$fldr/tbfull/Statistics  -P
    rclone copy "oci-s3-phd-af:MTBSEQ-NF/results/$fldr/tbfull/Classification" v2/$fldr/tbfull/Classification  -P

}




#=====================================================
# BASELINE results
#=====================================================

$standardResults = @(
    "pub-90samples-standard-run1",
    "pub-90samples-standard-run2",
    "pub-90samples-standard-run3"
)

foreach ($fldr in $standardResults) {


    rclone copy "oci-s3-phd-af:MTBSEQ-NF/results/$fldr/Amend" v2/$fldr/Amend -P
    rclone copy "oci-s3-phd-af:MTBSEQ-NF/results/$fldr/Groups" v2/$fldr/Groups -P
    rclone copy "oci-s3-phd-af:MTBSEQ-NF/results/$fldr/Statistics" v2/$fldr/Statistics  -P
    rclone copy "oci-s3-phd-af:MTBSEQ-NF/results/$fldr/Classification" v2/$fldr/Classification  -P

   
}



rclone copy "oci-s3-phd-af:MTBSEQ-NF/results/pub-90samples-standard-run1/MTBseq_2024-09-23_.log" v2/pub-90samples-standard-run1/ -P
rclone copy "oci-s3-phd-af:MTBSEQ-NF/results/pub-90samples-standard-run1/MTBseq_2024-10-14_root.log" v2/pub-90samples-standard-run1/ -P
rclone copy "oci-s3-phd-af:MTBSEQ-NF/results/pub-90samples-standard-run1/MTBseq_2024-10-14_root.tbjoin.log" v2/pub-90samples-standard-run1/ -P
rclone copy "oci-s3-phd-af:MTBSEQ-NF/results/pub-90samples-standard-run1/MTBseq_2024-10-15_root.log" v2/pub-90samples-standard-run1/ -P
rclone copy "oci-s3-phd-af:MTBSEQ-NF/results/pub-90samples-standard-run1/MTBseq_2024-10-15_.log" v2/pub-90samples-standard-run1/ -P


rclone copy "oci-s3-phd-af:MTBSEQ-NF/results/pub-90samples-standard-run2/MTBseq_2024-09-24_root.log" v2/pub-90samples-standard-run2/ -P
rclone copy "oci-s3-phd-af:MTBSEQ-NF/results/pub-90samples-standard-run2/MTBseq_2024-10-15_root.log" v2/pub-90samples-standard-run2/ -P
rclone copy "oci-s3-phd-af:MTBSEQ-NF/results/pub-90samples-standard-run2/MTBseq_2024-10-16_.log" v2/pub-90samples-standard-run2/ -P
rclone copy "oci-s3-phd-af:MTBSEQ-NF/results/pub-90samples-standard-run2/MTBseq_2024-10-16_root.log" v2/pub-90samples-standard-run2/ -P



rclone copy "oci-s3-phd-af:MTBSEQ-NF/results/pub-90samples-standard-run3/MTBseq_2024-09-26_root.log" v2/pub-90samples-standard-run3/ -P
rclone copy "oci-s3-phd-af:MTBSEQ-NF/results/pub-90samples-standard-run3/MTBseq_2024-10-16_root.log" v2/pub-90samples-standard-run3/ -P

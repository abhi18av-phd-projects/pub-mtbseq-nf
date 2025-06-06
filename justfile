import "analysis/analysis.just"

# mtbseq-nf - Data Science Project Tasks

module_name := ""

# list commands
default:
    @just --list

# update pre-commit file
pc-update:
  uvx pre-commit-update

# Run full pipeline with DVC
pipeline:
    dvc repro

# Visualize pipeline
pipeline-dag:
    dvc dag

# Clean intermediate files
clean:
    rm -rf data/processed/*
    rm -rf outputs/*

project-fish:
    ./.fish/run_fish.sh

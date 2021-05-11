#!/bin/bash
#SBATCH --job-name=fmriprep_ica-1    
#SBATCH --mail-type=ALL     
#SBATCH --mail-user=<username>@du.edu
#SBATCH --ntasks=1            
#SBATCH --cpus-per-task=8     
#SBATCH --mem=70gb                      # Job memory request
#SBATCH --time=14-00:00:00              # Time limit dd-hrs:min:sec (max is 14 days)
#SBATCH --output=fmriprep_ica%A_%a.log  # Standard output and error log
                                        # %A for parent array and %a for sub array
#SBATCH --array=1-3                     # specify rows we want this script to look for in ids.txt
                                        # ids.txt is a text file with subject ID in each row

# subject ID is dynamic and will change based on array specification above
SUBJECT=$(sed -n "${SLURM_ARRAY_TASK_ID}p" ids.txt)

# Load modules below
module purge # good practice for clearing existing modules
module load singularity/3.4.1

# Execute commands for application below
# This input runs fMRIprep using a singularity container for one participant at a time
singularity run --cleanenv -B vniBIDS/:/data1:ro -B /data/psychology/sokol-hessnerlab/VNI/fmriPrepOutput_ica/:/out \
 /data/psychology/sokol-hessnerlab/VNI/FMRIPREPsing/fmriprep_20.2.1.simg \
 --participant_label $SUBJECT \
 -v \
 --dummy-scans 32 \
 --use-aroma --aroma-melodic-dimensionality -100 \
 --fs-license-file /data/psychology/sokol-hessnerlab/VNI/FSlicense/license.txt \
 --nthreads 1 --omp-nthreads 1 \
 /data1 /out participant



# Step 0: scRNAbox pipeline set up
Step 0 initiates the pipeline and sets up the working directory by depositing the required files. In Step 0, users must determine whether they want to use the scRNAbox container (`--container TRUE`), whether to use the SLURM workload manager (`--jobmode Slurm`) or a stand alone system (`--jobmode local`), and whether to use the standard analysis track (`--method SCRNA`) or HTO analysis track (`--method HTO`).
 - - - -
## Running Step 0
Create a dedicated folder for the analysis (hereafter referred to as the working directory). Then, export the path to the working directory and the path to `scrnabox.slurm`:
```
mkdir working_directory
cd /pathway/to/working_directory

export SCRNABOX_HOME=/pathway/to/scrnabox.slurm
export SCRNABOX_PWD=/pathway/to/working_directory

```

Next, run Step 0. In this example, we are electing to use the scRNAbox container (`--container TRUE`), the Slurm workload manager (`--jobmode Slurm`), and the standard analysis track (`--method SCRNA`):
```
cd /pathway/to/working_directory 

bash $SCRNABOX_HOME/launch_scrnabox.sh -d ${SCRNABOX_PWD} --steps 0 --container TRUE --jobmode Slurm --method SCRNA 
```

After running Step 0, the structure of the working directory should be:
```
 working_directory
 └── job_info
     ├── configs
     ├── logs
     └── parameters
```
- The `configs/` directory contains the `scrnabox_config.ini` file which allows users to specify their job allocations (memory, threads, and walltime) for each analytical step using the Slurm Workload Manager; <br /> 
- The `logs/` directory records the events of each analytical step; <br />
- The `parameters/` directory contains adjustable, step-specific text files which allow users to define the execution parameters for each analytical step. <br />

Next, navigate to the `scrnabox_config.ini` file in `~/working_directory/job_info/configs` to define the HPC account holder (**ACCOUNT**), the path to the environmental module (**MODULEUSE**), the path to CellRanger from the environmental module directory (**CELLRANGER**), CellRanger version (**CELLRANGER_VERSION**), R version (**R_VERSION**), and the path to the R library (**R_LIB_PATH**):

```
ACCOUNT=account-name
MODULEUSE=/path/to/environmental/module (e.g. /cvmfs/soft.mugqic/CentOS6/modulefiles)
CELLRANGER=/path/to/cellranger/from/module/directory (e.g. mugqic/cellranger)
CELLRANGER_VERSION=5.0.1
R_VERSION=4.2.1
R_LIB_PATH=/path/to/R/library
```
**Note:** The text files can be opened and modified through nano, vim, or a file manager system like cyberduck. <br />
**Note:** For more information regarding the configuration file, please see the [Job cofigurations](config.md) sections of the scRNAbox documentation.






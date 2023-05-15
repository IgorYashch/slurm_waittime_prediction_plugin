#!/bin/bash

# Check if parameter is provided
if [ -z "$1" ]
then
  echo "No test_plugin.c file provided. Usage: ./script.sh <test_plugin.c>"
  exit 1
fi

# Compile the shared library
gcc -shared -I /home/slurm/slurm_simulator_tools/slurm_simulator -o job_submit_log.so "$1" -fPIC

# Move the shared library to desired location
mv job_submit_log.so /home/slurm/slurm_simulator_tools/install/slurm_programs/lib/slurm/

# Append line to the slurm.conf.template file 
# (ONLY ONE TIME!!!)
echo 'JobSubmitPlugins=job_submit/log' >> /home/slurm/slurm_simulator_tools/install/slurm_conf/slurm.conf.template

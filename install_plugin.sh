#!/bin/bash

gcc --shared \
    -I /home/slurm/slurm_sim_ws/slurm_simulator \
    -I /home/slurm/slurm_sim_ws/bld/opt \
    /home/slurm/workdir/plugin/plugin.c /home/slurm/workdir/plugin/utils.c \
    -lcurl -fPIC -w \
    -o /home/slurm/workdir/job_submit_predict.so

mv /home/slurm/workdir/job_submit_predict.so \
   /home/slurm/slurm_sim_ws/slurm_opt/lib/slurm

echo "The plugin has been successfully installed!"


# Далее необходимо добавить JobSubmitPlugins=job_submit/predict в файл конфигурации
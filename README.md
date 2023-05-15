### Запуск симулятора
**(Осторожно, dev docker окгружение весит 9.5 Гб)**
- docker build . -t bsc_slurm_simulator_dev
- docker run -it -v "$PWD":/home/slurm/workdir -p 8888:8888 --name slurm_simulator -h ubccr_slurm_simulator bsc_slurm_simulator_dev
- jupyter lab --ip 0.0.0.0 --no-browser --allow-root

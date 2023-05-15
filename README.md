### Создание окружения
**(Осторожно, dev docker окгружение весит 9.5 Гб)**
- docker build . -t bsc_slurm_simulator_dev
- docker run -it -v "$PWD":/home/slurm/workdir -p 8888:8888 --name slurm_simulator -h ubccr_slurm_simulator bsc_slurm_simulator_dev

### Компиляция плагина и его добавление в Slurm
- cd workdir
- chmod +x install_plugin_to_simulator.sh
- ./install_plugin_to_simulator.sh test_plugin.c

### Структура окружения
```
/home/slurm                   - Домашняя директория
      ├── slurm_simulator     - Директория с симулятором
      │   ├── ...
      │   └── ...
      └── workdir             - Рабочая директория (это и есть корень репозитория на github)
```
### Создание окружения
**(Осторожно, dev docker окгружение весит 9.5 Гб)**
- docker build . -t ubccr-slurm-sim
- docker run -it -v "$PWD":/home/slurm/workdir -p 8888:8888 --name slurm-sim-env -h slurm_sim-env ubccr-slurm-sim
- jupyter lab --ip 0.0.0.0 --no-browser --allow-root

### Компиляция плагина и его добавление в Slurm
- cd workdir
- chmod +x install_plugin.sh
- ./install_plugin.sh

### Структура окружения
```
/home/slurm                             - Домашняя директория
      ├── slurm_sim-ws                  - Директория с симулятором
      │   └── slurm_sim_ws              - Рабочая область симулятора Slurm
      │         ├── bld/opt             - Каталог для сборки симулятора Slurm
      │         ├── sim                 - Каталог, в котором будет проводиться симуляция
      │         │    └── micro          - Каталог для конкретного кластера
      │         ├── slurm_opt           - Каталог установки бинарных файлов Slurm
      │         ├── slurm_sim_tools     - Набор инструментов симулятора Slurm
      │         └── slurm_simulator     - Исходный код симулятора Slurm
      │
      │
      └── workdir                       - Рабочая директория (это и есть корень репозитория на github)
           ├── plugin                   - Директория с плагином, использующим Slurm Submit Job API
           ├── server                   - Сервер на python, обрабатывающий запросы от плагина и возвращающий прогноз
           ├── scripts                  - Дополнительные скрипты
           
           └── Dockerfile               - Файл для создания окружения
           
```
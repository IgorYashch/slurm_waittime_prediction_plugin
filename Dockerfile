# Остотрожно, обрал весит около 5ГБ

# Используем окружение slurm симулятора
FROM nsimakov/ub-slurm-sim:v1.2

# Добавим еще один внешний порт
EXPOSE 8888
RUN sudo yum install curl-devel -y

# Установим JupyterLab и ядро для языка R
RUN sudo python3 -m pip install --upgrade pip && \
    sudo python3 -m pip install jupyter jupyterlab
RUN sudo Rscript -e 'install.packages(c("repr", "IRdisplay", "IRkernel"), type = "source", repos="https://cran.rstudio.com");'
RUN Rscript -e 'IRkernel::installspec()'

RUN sudo python3 -m pip install mysqlclient numpy Flask

# Установим библиотеку, чтобы запускать R в JУстановим JupyterLab и ядро для языка R
# Пример:
#       import rpy2
#       %load_ext rpy2.ipython
#       %%R s <- "Hello world"
RUN sudo python3 -m pip install rpy2


# Изначально в симуляторе убрана опция вызова slurm submit job API плагинов
RUN sudo yum install patch -y
COPY ./simulator.diff /home/slurm/simulator.diff
RUN patch /home/slurm/slurm_sim_ws/slurm_simulator/src/slurmctld/simulator.c < /home/slurm/simulator.diff
RUN cd /home/slurm/slurm_sim_ws/bld/opt && \
    ../../slurm_simulator/configure --prefix=/home/slurm/slurm_sim_ws/slurm_opt --enable-simulator \
    --enable-pam --without-munge --enable-front-end --with-mysql-config=/usr/bin/ --disable-debug \
    CFLAGS="-g -O3 -D NDEBUG=1" && \
    make -j install

ENV SHELL=/bin/bash
CMD ["jupyter", "lab", "--ip", "0.0.0.0", "--no-browser", "--allow-root"]


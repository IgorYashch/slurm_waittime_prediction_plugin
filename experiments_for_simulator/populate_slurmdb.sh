#!/bin/bash

# Считываем файл со всеми пользователями
if [ $# -ne 1 ]; then
    echo "Usage: $0 <users.sim>"
    exit 1
fi
users_file="$1"

# Запускаем slurmdbd в фоновом режиме
SLURM_CONF=/home/slurm/slurm_sim_ws/sim/micro/baseline/etc/slurm.conf
SLURMDBD=/home/slurm/slurm_sim_ws/slurm_opt/sbin/slurmdbd
SACCTMGR=/home/slurm/slurm_sim_ws/slurm_opt/bin/sacctmgr

$SLURMDBD -Dvvvv &

# Ждем, когда стартанет slurmdbd
sleep 5

export SLURM_CONF

# Добавляем приоритеты (оставим всем одинаково)
$SACCTMGR -i modify QOS set normal Priority=0
# $SACCTMGR -i add QOS Name=supporters Priority=100

# Добавляем наш кластер
# Назовем его MiniLomonosov :)
$SACCTMGR -i add cluster Name=MiniLomonosov Fairshare=1 QOS=normal

# Add account
$SACCTMGR -i add account name=account1
# Read users from file and add them to the first account
while IFS=: read -r user_name user_uid
do
    $SACCTMGR -i add user name="$user_name" DefaultAccount=account1 MaxSubmitJobs=1000
done < "$users_file"

$SACCTMGR -i modify user set qoslevel="normal,supporters"

# Unset environment variable
unset SLURM_CONF

# Terminate slurmdbd
kill %1

library(RSlurmSimTools)

# Чтение swf файла
read_swf <- function(filename) {
    header <- c('job_number', 'submit_time', 'wait_time', 'run_time', 'num_procs',
                'avg_cpu_time', 'used_memory', 'req_procs', 'req_time', 'req_memory',
                'status', 'user_id', 'group_id', 'exec_id', 'queue_id',
                'partition_id', 'orig_site', 'last_run_site')

    read.csv(filename, comment.char = ";", sep='', header=FALSE, col.names=header)
}


# Запись users.sim
write_users <- function(data, output_file) {
    unique_users <- unique(data$user_id)
    unique_users <- sort(unique_users)
    users_data <- data.frame(username = paste0("User", unique_users),
                             user_id = unique_users + 1000)
    write.table(users_data, file = output_file, sep = ":", row.names = FALSE, col.names = FALSE, quote = FALSE)
}


# Запись .trace файла
swf_to_sim_job <- function(row) {
    sim_job(
        job_id = row$job_number,
        submit = as.POSIXct(row$submit_time, origin = "1970-01-01", tz = "UTC"),
        wclimit = as.integer(row$req_time) / 60,
        duration = as.integer(row$run_time) / 60,
        tasks = as.integer(row$num_procs),
        user_id = paste0("User", row$user_id),
        # account = 'account1'
        # cpus_per_task - ?
    )
}


# Аргументы
# Пример:
# Rscript swf_to_trace.R input.swf output.trace users.sim [100] [200]
args <- commandArgs(trailingOnly = TRUE)
input_file <- args[1]
output_trace_file <- args[2]
output_users_file <- args[3]
start_job_num <- ifelse(length(args) >= 4, as.integer(args[4]), 1)
finish_job_num <- ifelse(length(args) >= 5, as.integer(args[5]), Inf)


# Считываем данные и фильтруем
data <- read_swf(input_file)
data <- data[data$job_number >= start_job_num & data$job_number <= finish_job_num,]


# Пишем trace
trace <- lapply(data$job_number, function(i) swf_to_sim_job(data[data$job_number == i,]))
trace <- do.call(rbind, lapply(trace, data.frame))
write_trace(output_trace_file, trace)


# Пишем users.sim
write_users(data, output_users_file)
cat("Writing users to", output_users_file, "\n")

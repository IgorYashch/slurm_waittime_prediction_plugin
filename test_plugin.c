#include <stdio.h>
#include <stdlib.h>
#include <slurm/slurm.h>
#include <slurm/slurm_errno.h>

const char plugin_name[]        = "Job submit logging plugin";
const char plugin_type[]        = "job_submit/log";
const uint32_t plugin_version   = SLURM_VERSION_NUMBER;

extern int job_submit(struct job_descriptor *job_desc, uint32_t submit_uid, char **err_msg)
{
    FILE *log_file = fopen("home/slurm/workdir/logfile.log", "a");
    if (!log_file) {
        fprintf(stderr, "Failed to open log file\n");
        return SLURM_ERROR;
    }

    fprintf(log_file, "Job submitted:\n");
    fprintf(log_file, "User ID: %u\n", job_desc->user_id);
    fprintf(log_file, "Job ID: %u\n", job_desc->job_id);
    fprintf(log_file, "Number of tasks: %u\n", job_desc->num_tasks);


    fclose(log_file);

    return SLURM_SUCCESS;
}


extern int job_modify(struct job_descriptor *job_desc, struct job_record *job_ptr, uint32_t submit_uid)
{
    info("Job %u modified by user %u", job_desc->job_id, submit_uid);
    return SLURM_SUCCESS;
}


extern int init(void)
{
    info("job_submit plugin loaded");
    return SLURM_SUCCESS;
}

extern int fini(void)
{
    info("job_submit plugin unloaded");
    return SLURM_SUCCESS;
}


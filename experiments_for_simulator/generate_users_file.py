import pandas as pd
import sys


import sys
import argparse

def print_users(input_file, output_file):
    """
    Читает swf файл, записывает файл формата User:UID (users.sim)
    """
    
    def read_swf_file(file_path):
        col_names = ['job_number', 'submit_time', 'wait_time', 'run_time', 'num_procs',
                     'avg_cpu_time', 'used_memory', 'req_procs', 'req_time', 'req_memory',
                     'status', 'user_id', 'group_id', 'exec_id', 'queue_id',
                     'partition_id', 'orig_site', 'last_run_site']

        df = pd.read_csv(file_path, comment=';', header=None, names=col_names, delim_whitespace=True)
        return df
    
    data = read_swf_file(input_file)
    
    with open(output_file, 'w') as f:
        for idx in data['user_id'].unique():
            f.write(f'User{idx}:{1000 + idx}\n')

            
if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Generate users file for simulation from swf file.')
    parser.add_argument('-i', '--input_file', required=True, help='Path to the input file')
    parser.add_argument('-o', '--output_file', default='users.sim', help='Path to the output file (default: users.sim)')

    args = parser.parse_args()

    print(args.input_file, args.output_file)
    print_users(args.input_file, args.output_file)
    print(f"File {args.output_file} was created")

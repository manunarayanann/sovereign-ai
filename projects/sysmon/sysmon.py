import os
def memory_usage(pid):
    try:
        with open(f'/proc/{pid}/status') as f:
            for line in f:
                if line.startswith('VmRSS:'):
                    mem_usage = int(line.split()[1])
                    return mem_usage  # Return memory usage in KB
    except (FileNotFoundError, PermissionError):
        return None

def cpu_time(pid):
    clock_ticks = os.sysconf('SC_CLK_TCK')  # Get the number of clock ticks per second
    try:
        with open(f'/proc/{pid}/stat') as f:
            fields = f.read().split()
            utime = int(fields[13])  
            stime = int(fields[14]) 
            total_time = utime + stime
            cpu_time=total_time / clock_ticks  # cpu seconds
            return cpu_time  # Return total CPU time in seconds
    except (FileNotFoundError, PermissionError):
        return None

def list_processes():
    pids=[p for p in os.listdir('/proc') if p.isdigit()]
    processes=[]
    for pid in pids:
        try:
            with open(f'/proc/{pid}/comm') as f:
               name=f.read().strip()
            processes.append((pid, name, memory_usage(pid), cpu_time(pid)))   
        except (FileNotFoundError, PermissionError):
            continue
    return processes

#Whether this program is started by the user or another python file    
if __name__ == "__main__":
    processes = list_processes()
    processes.sort(key=lambda x: x[3], reverse=True)  # Sort by CPU time
    for pid, name, mem, cpu in processes:
        print(f"PID: {pid}, Name: {name}, Memory Usage: {mem} KB, CPU Time: {cpu} Seconds")
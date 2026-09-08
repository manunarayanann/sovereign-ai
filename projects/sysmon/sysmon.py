import os

def list_processes():
    pids=[p for p in os.listdir('/proc') if p.isdigit()]
    processes=[]
    for pid in pids:
        try:
            with open(f'/proc/{pid}/comm') as f:
               name=f.read().strip()
            processes.append((pid, name))
        except (FileNotFoundError, PermissionError):
            continue
    return processes
if __name__ == "__main__":
    for pid, name in list_processes():
        print(f"PID: {pid:>7}, Name: {name}")
import re
from collections import Counter

PATTERN=r"Failed password for (\S+) from (\d+\.\d+\.\d+\.\d+)"


def find_failed_login(path):
    hits=[]
    with open(path) as f:
        for line in f:
            match=re.search(PATTERN, line)
            if match:
                hits.append((match.group(1), match.group(2)))
    return hits

hits=find_failed_login("sample.log")

ip_counts = Counter(ip for user, ip in hits)

for ip, count in ip_counts.most_common(5):
    print(f"{ip:>15} has {count} failed attempt(s)")

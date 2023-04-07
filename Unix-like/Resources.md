Random Access Memory (RAM)
```sh
# mebibytes
free -m

# human-readable, SI units
# since RAM is usually sold in GB (Gigabytes--base 1000), 
# NOT GiB (Gibibytes), `free -h --si` is usually better,
free -h --si

# A traditional way
grep MemTotal /proc/meminfo
```

CPU
```
lscpu
```

OS
```
less /etc/os-release
```

Mounts
```
df -h
```

## `ping`

TODO
## `ssh`

Securely connect to operating network services over unsecured networks using the Secure Shell Protocol. Allows remote login and remote code execution within a CLI.
## `scp`

TODO
## `traceroute`

Trace the path of traffic to a destination, displaying statistics at each stop.
## `nslookup`

Query DNS information for a domain name to obtain any mappings to IP addresses and other DNS records

## `nz`

TODO: What is this
`nc -zv 10.10.7.177 443`

## `ss` / `netstat`

`ss` investigates sockets. More modern compared to `netstat`. Currently ships with Linux but not macOS.

See what process is using port 5678:
`sudo ss -ltnp | grep ':5678'

This same command works with `netstat` as well. Flags explained:
* `-l` list listening sockets
* `-t` show TCP sockets
* `-n` display addresses and ports as numbers
* `-p` list processes using a socket

## `ipconfig`

##
## `curl`

`-vvv`: Very very verbose mode
`--resolve <domain>:<port>:<ip address>`: Force curl to resolve to using a specific port and IP address

## `wget`

TODO
# AWS Storage Gateway
#aws #storagegateway #s3 #ebs #nfs #smb #nas #san

Normally runs as a virtual machine (or less commonly as hardware appliance)
A bridge between storage on premises and AWS.
Presents storage using iSCSI (SAN/NAS protocol), NFS (Unix-like), and SMB (Windows).
Integrates with EBS, S3, and Glacier within AWS
Migrations (on-prem to AWS), extensions of data centers into AWS, storage tiering, Disaster recovery, and replacement of (legacy, tape media) backups systems.

For the exam you gotta be able to pick the right mode of Storage Gateway for a scenario.
Volume stored

Architecture:
Can be run as a virtual appliance on premises.
On premises might have Network-Attached Service (NAS) and a Storage Area Network (SAN) or a Storage Gateway VM
Servers on premises have local disks but for primary storage may be able to attach to SAN or NAS using iSCSI protocol which presents raw block storage over the network as block devices to these servers. Services just see them as a storage device to create a file system on.
Business may have little funds for little funds for backups/effective backup recovery so look to AWS as a solution.

Volume Gateway works in 2 modes:
1) Stored
1) Cached 
### Stored: 

Virtual appliance presents volumes over iSCSI to servers running on premises just like NAS/SAM hardware. 
Volumes look identical and can have identical interaction (file system creation). 
In gateway stored mode, these volumes consume capacity on premises. So storage gateway has local storage that is the primarily used location for all volumes that Storage Gateway presents over iSCSI. 
When using Storage Gateway in Volume Stored mode, everything stored locally. 
There is a separate area of storage called upload buffer. Any data written to any of the volumes in local storage is also written to this buffer as well 
Then its async copied to AWS at the Storage Gateway Endpoint: a public endpoint. Can be over public internet or public VIF running on Direct Connect. 
Copied into form of EBS snapshots.
EBS snapshots can be used to create new EBS volumes. Assists with disaster recovery.
Great for full disk backup of servers.
Doesn't allow for extending on-prem data center capacity since primary location for data is on-prem on the gateway.
But that on-prem primary storage location is low-latency.
Volume stored mode offers 32 volumes per gateway, 16 TB per volume = 512 TB per Gateway.
So in summary: provides backups, DR, and migration capabilities, local area network speed access
# Cached

Most useful for different set of scenarios. Shares same basic architecture as above, but the main location for the data is no longer on premises. It's on AWS within S3.
Instead of having a local storage volume, the Storage Gateway has cache storage which stores frequently accessed data.
The S3 bucket is AWS-managed! Only visible from Storage Gateway console.
Since it's raw data from a volume and not file/objects, it makes sense that you can't look at it like a normal S3 bucket.
Can still create EBS snapshots fromwhat's stored on the S3 bucket.
Data center extension: Because of cached storage location, we can have much larger volumes of data (100s of TB) being stored and managed by storage gateway and only have a fraction of that stored locally on the cache.
Also has local area network speed for cached data, but there is slower access to less frequently used data. That's the cost of extension.
A single gateway can handle 32 TB per volume, 32 volumes maximum = 1 PB of storage!
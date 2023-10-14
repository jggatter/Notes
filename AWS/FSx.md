## FSx for Windows

Windows native file system accessed over SMB (Server Message Block). Used for Windows native environments within AWS.
## FSx for Lustre

Managed implementation of Lustre file system. Designed for High Performance Computating, specifically Linux clients (POSIX-style permissions)
Used for ML, Big Data, and Financial Modeling.
Can scale to hundreds of GB per second. Sub-millisecond latency.
Can be provisioned using two different deployment types:
1) Scratch: optimized for really high end performance in short term, but not much resilience or availability. No replication and fast.
2) Persistent: Longer-term storage, high availability within one availability zone, and resilience in self-healing aka auto-healing (If any hardware fails, it will be automatically recovered by AWS within that single availability zone).
Both can backup to S3! Manual or automatic 0-35 day retention.
For Lustre (and for Windows) are accessible over VPN or Direct Connect from on-prem locations.

Managed file system created by you within a VPC, just like EFS or FSx for Windows. You can connect to it with private networking.
The filesystem is where the data lives while processing occurs.
You can associate a created filesystem with a repository (e.g. S3 bucket). The objects are visible within the file system, but are not actually stored within it.
When first accessed by a client, the data is "lazy loaded" from S3 into the file system as needed. There is no built-in automatic synchronization, it's completely separate and uses the repository as a foundation.
Changes made within FSx filesystem can be synced back to the repository using hsm_archive command.

Lustre splits up data when it stores it to disks. Many different elements/types whens storing it.
Metadata is stored on Metadata Targets (MST)
The data itself is split over multiple Object Storage Targets (OSTs) each about 1.17 TiB in size. This splitting is how Lustre achieves performance.
Baseline performance based on size of file system. Minimum size is 1.2 TiB and can be expanded in increments of 2.4 TiB.
For Scratch - Base 200 MB/s per TiB of storage.
Persistent offers 50 MB/s, 100 MB/s, and 200 MB/s per TiB of storage
Burst up to 1,300 MB/s per TiB (credit system - earn credits when you consume below baseline performance and spend when you go above)

Architecture:
Client VPC contains clients (EC2 instances with Lustre file system installed)
An FSx for Lustre File System and a S3 bucket associated.
A number of lustre file servers handle storage requests placed against it and each provide an in-memory cache which allows faster access to frequently used data.
The more storage provisioned, the more servers and more aggregate throughput and IOPS that FSx Lustre can deliver to the VPC.
Since it's running from one available from one availability zone, only a single Elastic Network Interface (ENI) is needed to provide access.
Any writes to Lustre will go through ENI directly to disk. Dependent on disk throughput and IO characteristics. 



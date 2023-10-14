Might not be an exam question on this.

Data transfer service to and from AWS. Manages the process from end to end.
Used for migrations, data processing transfers, archival, cost effective storage, or disaster recovery/business continuation.
Scalable: Each agent can handle 10 Gbps and up to 50 million files!
Also handles transfer of metadata such as permissions and timestamps.
It handles built-in data validation: Makes sure destination copy matches the source.
Bandwitdth limiters (avoid link saturation)
Supports incremental and scheduled transfer options
Supports compression and encryption
Also supports automatic recovery from transit erros
AWS Service integration with S3, EFS, FSx (even cross region)
Pay as you use: per GB cost for data moved

Architecture example:
Install data sync agent on on-prem SAN/NAS storage system within a virtualization platform such as VMWare and it communicates with the AWS DataSync Endpoint using NFS or SMB protocols.
DataSync agent communicates with us-east-1 region Endpoint using Encryption in-transit (TLS). Bidirectional transfer is supported! The Endpoint can include destinations such as S3, EFS, and FSx For Windows Server.
Schedules can be set to ensure the transfer of data occurs during or avoiding specific time periods.
Customer impact can be minimized by setting bandwidth limit in MiB/s. Can throttle rate to prevent AWS environment from being overwhelmed in case of performance issues.

Task - A job within DataSync that defines what is being synced, how quickly, FROM where and TO where. Also scheduling and throttling.
Agent - Software used to read or write to on-premises data store using NFS or SMB.
Location - Every task has a source and destination location. E.g. Network File System (NFS), Server Message Block (SMB), Amazon EFS, Amazon FSx, and Amazon S3.

Traditional file protocols: NFS is more common with Unix-like systems while SMB is more common in Windows environments.

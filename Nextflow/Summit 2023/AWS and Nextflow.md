Choices and considerations
#aws #nextflow 

I want to run my nextflow workflow on AWS? Best way?
considerations
- your expertise with job scheduling
- what workloads
- configuration (ec2?)
- integrations with your other tools and business logic

## Options

AWS Batch
fully managed job scheduler

AWS ParallelCluster
slurm based clusters on ec2

Amazon EKS
managed Kubernetes

## Architecture

AWS Batch example:
workflow.nf -> config -> Batch -> Queue -> comp env -> EC2s
ECR -> EC2 containers
EC2 containers <-> S3

The nextflow conf uses awsbatch eecurtor, tool dependency is containers, sotrage is FSx for luster/efx/ebs/s3. Nextlfow run: login nodes.

AWS ParallelCLuster:
Open source too
define cluster in YAML
create slurm on ec2
treaditional HPC setup

Nextflow conf
executor is slurm
tool deps are containers, conda, spac(?)k, modules, etc.
storage is the same as batch
nextflow run: login nodes

Amazon EKS
managed kubernetes
multi-avalaibility zone control plane
managed node groups
additional tools and kubernetes workloads

nextflow conf:
executor k8s
tool deps: containers,
storage same but also CSI drivers
nextflow run: local, kuberun, or k8s pod

### ECR

Docker and OCI compliant to pull anywhere.
Container images, helm charts, OCI artifacts

## Reviewing considerations 
Slurm and K8s require expertise
workloads depend on your workflows and services
confs require instance types + storage
integrations such as connecting with other aws services

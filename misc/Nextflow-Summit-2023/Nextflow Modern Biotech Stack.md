
Flexibility: Integration with different compute and storage platforms across AWS, GCP, Azure, and HPC environments.
Reproducibility. Containers provide portability. GitHub and competitors provides source code management
Processing at scale is difficult.
Collaboration: with the community

By stack we mean set of software tools used together.
- MultiQC for reporting and analytics
- Wave for provisioning containers
- Fusion for cloud native file system
- Nextflow for workflows
	- Core tools

Seqera Cloud
data studios looks good
data explorer also might be good

# Enabling converged computing with Nextflow ecosystem

Want to enable scientists to focus on more their direct work

The above tech stack seeks to solve this.

Fusion filesystem for cloud-native data (nextflow) pipelines.
sotrage is the bottleneck for scalable data pipelines
data-intensive pipelines are heavily I/O bound. Lot of money wasted waiting for files to pull/push.
Legacy shared and dist file-systems can be expensive, haved fixed allocation, or are an extra maintenance burden.
Object storage is scalable and "cheap" but it cannot operate natively with data pipeline toolss mostly based on POSIX file interface.
Fusion aims to remove the barrier to access cloud native stoage.
```bash
mytool --in /fusion/s3/bucket/some/file.txt \
       --out /fusion/s3/bucket/some/result.txt
```
Nextflow on a head compute nopde launches a job on a compute node with a job container running the job. The job communicates with the fusion driver. The fusion driver interacts with S3 etc. and the linux kernel to store and fetch objects.
I guess the difference is the driver is independent from the job so it can pull/push independently of the running job.

Optimized for nf data pipelines, single job execution,  runs in the job container.
Pre-fetching parallel download, async parallel upload.
Support for file links over object storage.
Ease data transfer pressure
...?

## Fusion vs AWS Mountpoint
Similar performance for reading small files sequentially or randomly (5 MB), but Fusion execels at large (100GB) sequential and random reads. Writes are supported by fusion but not by aws mountpoint.

## Fusion vs AWS S3 vs FSx for Lustre
FSx for Lustre is much faster than S3, but about the same as Fusion.
The sotrage cost for S3 is a ~2.5x cheaper than lustre, but Fusion is ~2x cheaper than S3.
The storage useage is much smaller for Fusion across nf-core pipelines.
Fusion is supported for AWS S3 right now.

## Wave
On-demand container provisioning service.

Core ideas:
Provision container as dispossable resource (instead of static assets)
Deliver on-demand opt containers for a specific target arch (e.g. Graviton, Apple silicon, etc.)
Define the container by specifying WHAT not HOW.

Wave arch

Nextflow sends container spec to Wave controller which triggers image builders which push images to be available for container jobs.

What's new
Container freeze allows creation of non-ephemeral ...?
Support for ARM64 arch (Graviton, Apple Silicon) provides cost-efficient computing capacity.
Support for Spack package manager which allows wave to provision containers optimised for specific CPU arch.
Up to 2x performance gain in some specific arch

```bash
wave -i ubuntu --layer myscripts/
# spits out image handle for image built in the cloud

docker run -it wave.seqera.io/wt/..../ubuntu:latest sh -c "./hello.sh"
# Hello world
```

```bash
wave -f Dockerfile --context myscripts/
# spits out image handle for image built in the cloud
```
An email is also sent to notify the status of the image built in the cloud

Can also:
build for different archs
build singularity images
build docker images from conda packages
Be used within nextflow.config

will be available through enterprise Q1 2024

Spack package manager is supported within Nextflow
Both for local spack installations and remote buiild containers
Support for multi-CPU archs. Specific CPU arch specifiable at job level.
Fusion is now supported by most nextflow executors (including AWS Batch and local!)
nextflow now has channels! (like Go kinda?)

DSL3 will not really be a new language but rather an iteration that is a better experience.
support for job arrays
etc.

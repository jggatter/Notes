#kafka #nextflow

Raw -> LIMS -> Samplesheet -> Nextflow -> aws -> results

The imporatnce of automation
We need an event-drive architecture to automate the movement of our data
A change in state is ane event. 
wrrapped in a message with descr

pipeline is a series of events:
subworkflows,tassks,errors,workflow completion
how do we react?

Apache kafka facilitiates communication through Kafka borker, organizaes message logs into topics
services can publish mesages into topic??

Kafka dispatcher is an interface to broker with single point of conf
a dockerized microservice that can both publish and sub to messages
can trigger actions based on message contents. Api calls, bash commands, nextflow run, tower luanch, etc.

Looks like:
LIMS dispatcher 
dispatcher responds to event in lims and sends to broker to start
broker sends message to dispatcher to trigger an action to start a nextflow pipeline

what about integration with nextflow?

Zero-mess is a groovy library for interacting with kafkadispatcher. used by main nf process andeach task
enables publishing messages for workflow events
pipeline start and end
task start and end
critical errors
any other logging info

analytical environment (AWS)
job submit node (has nextflow) and zero mess and dispatcher
then we have the broker that has kafka and ...?
other systems have dispatcher to trigger actions

what can we do with this framework?
start pipelines automatically with accumulated data
update lims and ehr as results are produced.
contact multiple stakeholders on pipeline failure
add data to local installation of cbioportal
complex chaining of separate pipelines

roadmap
already in use by WCM clinical genomics weill cornell medicine
they aim to release the kafka dispatcher as OSS nexdt year
create a plugin nf-events to publish events in Nextflow
initially wrapper around zeromess and kafkadispatcher
examples:
eipm/hello-mess-nf
eipm/rnaseq-messaging
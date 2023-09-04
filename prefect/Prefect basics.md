#prefect #workflows #python 

Maybe move to Python folder?

## Setup
[Guide](https://docs.prefect.io/getting-started/installation/)

`pip install -U prefect`

Then [create an API key in the UI](https://docs.prefect.io/ui/cloud-getting-started/#create-an-api-key) and:
`prefect cloud login --key <key>`

Changing workspaces:
`prefect cloud workspace set --workspace <organization>/<workspace>`

## Basics
[Guide](https://docs.prefect.io/tutorials/first-steps/#first-steps)

A [flow](https://docs.prefect.io/concepts/flows/) is the basis of all Prefect workflows. A flow is a Python function decorated with a `@flow` decorator.

A [task](https://docs.prefect.io/concepts/tasks/) is a Python function decorated with a `@task` decorator. Tasks represent distinct pieces of work executed within a flow. It's basically a flow 

```python
from prefect import flow, task

@flow
def my_flow() -> int:
	print("Hello world")
	return 42

def main():
	my_flow()

if __name__ == "__main__":
	main()
```

### Running with parameters

## Orion
Orion is Prefect 2's execution engine. To start it on EC2:

```sh
screen -S orion

prefect orion start --host 0.0.0.0

# ^A^D to detach

# Send a health request
curl -X GET \
  -H "Accept: application/json" \
  -H "Content-Type: application/json" \
  http://0.0.0.0:4200/api/health
  # Might be 127.0.0.1?

# To reattach
screen -r 
# or list then reattach to specific screen
screen -ls
screen -r orion
```

`PREFECT_API_URL` specifies the API endpoint of your Prefect Cloud workspace or Prefect Orion API server instance.
```sh
# set to local Orion instance
prefect config set PREFECT_API_URL="http://0.0.0.0:4200/api"

# set to Prefect Cloud workspace:
# automatically
prefect cloud login --workspace "<organization>/sandbox-jgatter"
# or manually
prefect config set PREFECT_API_URL="https://api.prefect.cloud/api/accounts/[ACCOUNT-ID]/workspaces/[WORKSPACE-ID]"

# Reset to default:
prefect config unset PREFECT_API_URL
```
[Note](https://docs.prefect.io/concepts/settings/#prefect_api_url): When using agents and work queues that can create flow runs for deployments in remote environments, `PREFECT_API_URL` must be set for the environment in which your agent is running. If you want the agent to communicate with Prefect Cloud or a Prefect Orion API server instance from a remote execution environment such as a VM or Docker container, you must configure `PREFECT_API_URL` in that environment.

## Deployments

make sure you have s3fs installed via pip
`prefect deployment build test/vl49_s3.py:vl49_s3 -sb s3/cyflows-prod -q cyflows -v test2 -a -t cyflows -n cyflows -o vl49_s3.yaml -ib ecs-task/cyflows-prod`

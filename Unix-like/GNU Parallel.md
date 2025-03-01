#bash #unixlike #concurrency
## What is `parallel`?

GNU `parallel` is a shell tool for executing jobs in parallel using one or more computers.

A job can be a single command or small script that has to be run for each of the lines in the input. Commands can also be read from a pipe.

## Why `parallel` vs. `xargs`?

The manual for `parallel` mentions `xargs` and `tee`:
	"If you use xargs and tee today you will find GNU parallel very easy to use  
	as GNU parallel is written to have the same options as xargs."

`xargs` is more available across UNIX-like systems and is simpler and more portable.

`parallel` offers concurrency and control over the orchestration of commands.

E.g.
The following command is slightly more simple in appearance and execution:
	`find . -name "*.txt" | xargs rm`
compared to:
	`find . -name "*.txt" -print | parallel rm`

## Summary of most useful flags

### Basic
- `--jobs` / `-j <number of jobs>` : Specifies maximum number of jobs to run simultaneously.  
- `--keep-order` / `-k`: Keep the output order the same as the input order

### Input handling
- `:::` or `::::` operator: specify input items or input files as arguments
- `--pipe`: Takes input from the standard input, divides it into blocks, and passes each block as input to a command.
- `--arg-file` / `-a <file>`: Read input from a file
- `-I{} --max-args N`: Replaces `{}` in the command with up to `N` arguments read from the input source.

### Special Replacement Strings
-   `{}`: Replaced by the input line.
-   `{.}`: Replaced by the input line with the extension removed.
-   `{#}`: Replaced by the job number.

### Output handling
- `--results <directory>`: Saves the output in files under a specified directory
- `--files`: Generates file names for stdout and stderr and passes those arguments as arguments to the command

### Control Flags

- `--dry-run`: Prints the commands that would be run without actually running them.  
- `--halt now,fail=1`: Halts all jobs immediately if one job fails.
- `--retry-failed`: Retry failed jobs.
- `--timeout DURATION`: Kills jobs that exceed a specified duration.

### Progress and Monitoring
-   `--progress`: Shows progress during execution.
-   `--eta`: Shows estimated time of arrival for remaining jobs.
-   `--joblog FILE`: Logs the status of completed jobs to `FILE`.

### Scripting

#### 1. `--shebang`
Allows for the creation of parallel scripts. Example:

```bash
#!/usr/bin/parallel --shebang
echo "Processing argument: {}"
```

In this example, `./parallel_script.txt 1 2 3` can execute the script in parallel for the provided arguments.

#### 2. `--shebang-wrap <program>`
GNU parallel can also parallelize scripts by wrapping the shebang line. 

If the program can be run like this:  
	`cat arguments | parallel the_program `
then the script can be changed to:  
	`#!/usr/bin/parallel --shebang-wrap /original/parser --options`
E.g.  
	`#!/usr/bin/parallel --shebang-wrap /usr/bin/python`
  
If the program can be run with piping input from stdout:  
	`cat data | parallel --pipe the_program`
then the script can be changed to:  
	`#!/usr/bin/parallel --shebang-wrap --pipe /orig/parser --opts`
E.g.  
	`#!/usr/bin/parallel --shebang-wrap --pipe /usr/bin/perl -w` 

An example using Python 3:
```
#!/usr/bin/parallel --shebang-wrap /usr/bin/python3
import sys

arg = sys.argv[1]
print(f"Processing argument: {arg}")
```

In this example, `./parallel_python.py 1 2 3` can execute the Python script in parallel for the provided arguments

## GNU Parallel 2018: Chapter 2 Learn in 15 minutes

### Input sources

Parallel reads values from input sources. One input source is the command line. The values are specified after the `:::` operator.

```bash
# Parallelize `echo` from different input sources `1`, `2`, ... and `5`
parallel echo ::: 1 2 3 4 5

# Output (order may be different):
1
2
3
4
5
```

Can parallelize any program, like `wc`:
```bash
# Here we take on all files in the pwd beginning with "example."
parallel wc ::: example.*

# Output (order may be different):
1 1 2 example.1
2 2 4 example.2
3 3 6 example.3
4 4 8 example.4
5 5 10 example.5
```

Multiple `:::` operators will generate all combinations:
```bash
parallel echo ::: S M L ::: Green Red

# Output (order may be different):
S Green
S Red
M Green
M Red
L Green
L Red
```

GNU parallel can also read values from stdin:
```bash
find example.* -print | parallel echo File

# Output (order may be different):
File example.1
File example.2
File example.3
File example.4
File example.5
```

## Build the command line

The command line is put before the `:::` operator. It can contain a command and options for the command:
```bash
parallel wc -l ::: example.*

# Output (order may be different):
1 example.1
2 example.2
3 example.3
4 example.4
5 example.5
```

The command can contain multiple programs, just remember to quote characters that interpreted by the shell (such as `;`):
```bash
parallel echo counting lines';' wc -l ::: example.*

# Output (order may be different):
counting lines
1 example.1
counting lines
2 example.2
counting lines
3 example.3
counting lines
4 example.4
counting lines
5 example.5
```

The value will normally be appended to the command but can be placed anywhere by using the replacement string `{}`:
```bash
parallel echo counting {}';' wc -l {} ::: example.*

# Output (order may be different):
counting example.1
1 example.1
counting example.2
2 example.2
counting example.3
3 example.3
counting example.4
4 example.4
counting example.5
5 example.5
```

When using multiple inptu sources, you can use positional replacement strings `{1}` and `{2}`:
```bash
parallel echo count {1} in {2}';' wc {1} {2} ::: -l -c ::: example.*

# For each matching file, 
# print "count -l/-c in example.X"
# and output wc -l/-c example.X

# Output (order may be different):
count -l in example.1
1 example.1
count -l in example.2
2 example.2
count -l in example.3
3 example.3
count -l in example.4
4 example.4
count -l in example.5
5 example.5
count -c in example.1
2 example.1
count -c in example.2
4 example.2
count -c in example.3
6 example.3
count -c in example.4
8 example.4
count -c in example.5
10 example.5
```

You can check what will be run with `--dry-run`:
```bash
parallel --dry-run echo count {1} in {2}';' wc {1} {2} ::: -l -c ::: example.*

# Output (order may be different):
echo count -l in example.1; wc -l example.1
echo count -l in example.2; wc -l example.2
echo count -l in example.3; wc -l example.3
echo count -l in example.4; wc -l example.4
echo count -l in example.5; wc -l example.5
echo count -c in example.1; wc -c example.1
echo count -c in example.2; wc -c example.2
echo count -c in example.3; wc -c example.3
echo count -c in example.4; wc -c example.4
echo count -c in example.5; wc -c example.5
```

### Control the output:

Output will be printed as soon as the command completes. This means the output may come in a different order than the input:

```bash
parallel sleep {}';' echo {} done ::: 5 4 3 2 1

Output (order may be different):
1 done
2 done
3 done
4 done
5 done
```

You can force GNU parallel to print in the order of the values using the `-k` / `--keep-order` flag. The commands will still run in parallel.

```bash
parallel --keep-order sleep {}';' echo {} done ::: 5 4 3 2 1

# Ouput
5 done
4 done
3 done
2 done
1 done
```


## Control the execution

If your jobs are compute intensive, you will most likely run one job for each core in the system. This is the default for GNU parallel.

But sometimes, you want more jobs running You control the number of job slots with the `-j` / `--jobs` flag. Give this flag the number of jobs you want to run in parallel. Here we run 2 in parallel:

```bash
parallel --jobs 2 sleep {}';' echo {} done ::: 5 4 3 2 1

# Output:
4 done
5 done
1 done
3 done
2 done
```

The two job slots have to run 5 jobs that take 1-5 seconds: `55555 4444 333 1 22`. They happen to run in this sequence:

Job slot 1: `55555122`
Job slot 2: `4444333`

If you instead run 5 jobs in parallel, all the jobs start at the same time and finish at different times:
```bash
parallel --jobs 5 sleep {}';' echo {} done ::: 5 4 3 1 2

# Output:
1 done
2 done
3 done
4 done
5 done
```

The jobs are all run in parallel:
Job slot 1: 55555
Job slot 2: 4444
Job slot 3: 333
Job slot 4: 1
Job slot 5: 22

Also, instead of giving the number of jobs to run, you can pass `--jobs 0` which will run as many jobs in parallel as possible.

## Pipe mode

GNU Parallel can also pass blocks of data to commands on stdin:
```bash
seq 1000000 | parallel --pipe wc

# Output (the order may be different):
165668 165668 1048571
149796 149796 1048572
149796 149796 1048572
149796 149796 1048572
149796 149796 1048572
149796 149796 1048572
85352 85352 597465
```

This can be used to process big text files. By default, GNU Parallel splits on newlines `\n` and passes a block of around 1 MB to each job.


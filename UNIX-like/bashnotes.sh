#!/bin/bash
# Above is the Bourne-Again Shell shebang used to tell the the OS to execute this script using Bash shell.
#chmod +x bashnotes.sh # In terminal, gives user ability to execute this script
#~/path/to/bashnotes.sh # executes the script with whatever lines are uncommented (Lines that do not start with #)
#Uncomment lines and run the script to test them!

##### Bourne-Again Shell and UNIX Command Notes

#### UNIX 

### COMMANDS
# man [command] # Manual command. Show manual information for command. 'q' to quit.
# bash # Open bash command-line interface. Good for testing lines of code.
# sh # Execute bash commands, very useful with find -exec for doing multiple commands, example from a cromwell script:
#	find . -type d -exec sh -c '[ -z "$(ls -A '"'"'{}'"'"')" ] && touch '"'"'{}'"'"'/.file' \;
#	Learning what this line does can teach you a lot about bash/unix.
# sudo [command] # Super-do a command with superuser privileges.
# set [flag] # Set certain Bash-specific variables.
#	set -e # Terminate the program upon encountering errors that exit with non-zero status.
# export [env variable] # Change environment variables
# pwd # Lists present working directory
# history # Shows all commands used during terminal session.
# clear # Clear terminal window.
# cd [dir] # Change directory. ./ = current dir, ../ = back one dir from current, ~/ = home. Recommended use TAB to autocomplete directories.
# chmod [owner/user flag][add/remove +/- flag][read/write/execute flag] [filename] # Changes permissions on a file.
#	chmod o+r [file] # gives owner ability to read a file
#	chmod o-r [file] # takes away owner's ability to read file
#	chmod u+x [bash/python script] # adds executing permission to the user for that script
# echo [text] #Prints whatever text to console
# ls [optional flag] # List all files in current directory
#	ls -l # for long format
#	ls -a # all files, even hidden ones (hidden by .)
#	ls -al # Detailed format
#	ls -R # Lists files in subdirectories too
# du [file/dirname] # tells disc usage.
#	du -sh [file/dirname] # Give disc usage in human-readable format for each specified file.
# more [file] # Displays in terminal as much as the file that can fit on screen.
# less [file] # Shows only a scrolls-worth of content at a time.
# find [file/dir] # Find file/dir and print to console.
# 	find [location] -name [file/dir] --execf {} + \; ???? # Find and execute a function on file/dir #TODO: fix this?
#	find . -name *.txt -maxdepth 1 -exec echo {} \; #Find starting here all text files limited to this directory and echo each as separate commands. (echo 1; echo 2; ...)
#	find . -name *.txt -maxdepth 1 -exec echo {} + #Find starting here all text files limited to this directory and echo with each as a command argument (echo 1 2 3 ...)
# grep [flags] [pattern] [filename] # Searches line by line for lines that match a pattern indicated by basic regular expressions. 
#	grep -v	# Shows all the lines that do not match the searched string
#	grep -c	# Displays only the count of matching lines
#	grep -n	# Shows the matching line and its number
#	grep -i	# Ignore case. Match both (upper and lower) case
#	grep -l	# Shows just the name of the file with the string
#	grep -w # forces the pattern to match an entire word.
# 	grep -x # forces patterns to match the whole line.
#	grep --color # colors the matched text.
#	grep -F # interprets the pattern as a literal string.
#	grep -H, -h # print (or don't print) the matched filename
# 	EXAMPLE: grep [string] [filename(s)] # Looks for string within file(s).
# egrep for extended regex. 
# fgrip is quick but doesn't do regex, only fixed patterns.
# zgrep, zegrep, and zfgrep all work like their respective counterpart but work on files zipped by compress/gzip.
# awk [???] # Text processor. Data extraction/reporting in a .CSV kinda way. Record-oriented rather than line-oriented.
#	awk { $1, $2, $NF } #Print first, second, and last columns of a comma/tab separated file.
# sed [???] # Text processor. Stream editor, reads a file line-by-line, conditionally applying a sequence of operations to each line.
#	sed 's/[regex what to substitute]/[regex replace with]/' # slashes can be commas or other delimiter?
# cut [list?] [file] # Cuts out selected portions of each line (as specified by list) from each file and writes them to the stdout
# touch [filename] # Create file if doesn't exist, updates time last accessed.
# cat [filename] # View file.
# cat > [filename] # Create a new file of this name
# cat [filename1] [filename2] > [filename3] # Combine 1 and 2 in a new file 3
# sort [filename] # Sorts file alphabetically.
#	sort -r #Reverses  sorting
#	sort -n # Sorts numerically
#	sort -f # Case insensitive sorting 
# mv [filename] [newfilename] # Rename file.
# mv [filename] [dir] # Move file to dir
# cp [filename] [dir] # Copy and pastes file to dir
# cp [filename1] [filename2] # Overrides file2 contents with file1 contents. No name change.
# rm [filename] # remove file.
#	rm -i # asks for confirmation first!
# rmdir [path/dirname] # Removes directory if not empty
# mkdir [path/dirname] # Makes directory.
# diff [filename1] [filename2] # Compares files and shows where they differ
# wc [filename] # Word count, tells you how many lines, words, and characters there are in a file
#	wc -c # how many characters
#	wc -w # how many words
#	wc -l # how many lines
# gzip [filename] # Compresses file to zip file
# gunzip [zip filename] # Uncompresses zip file
# gzcat [zip filename] # Allows you to peek in zip files without uncompressing them.
# sync #TODO
# rsync #TODO
# trap #TODO 
# tee #TODO
##SERVER-RELATED COMMANDS
# scp [path to local file] jgatter@gold.broadinstitute.org:/[path to server dir] #Copy local/server file to server.
# ssh jgatter@gold.broadinstitute.org "[command]" #do commands on the server, can pipe into a local file.
# use UGER # necessary below ANY of the following. Use Univa Grid Engine Resources?
# qsub [script] # Queue a script to run
# qstat # view job status
#	qstat -u \* # View job statuses for jobs run by all users 
# qdel [jobID] # Delete a job!

### OPERATORS
# > # Stdout redirection to a new file or devices.
# >> # Stdout redirection for appending files.
# < # Stdin redirection. File contents to certain commands.
# 2> #StdErr redirection. Puts error stream to a new file.
# >& # Will redirect output to target of another output:
#	EX: ls Documents ABC> dirlist 2>&1 # Redirects Stderr to target of Stdout, which is file dirlist.
# [command] | [command2] # Pipe operator pipes the output of the first command to be the input of the second command
# [command] & [command2] # Run first command in parallel with a following command.
# 	for x in ${x[@]}; do [command] & done # Run for loop command in parallel. Make command call to a function to run code chunk in parallel.
## Arithmetic
# All are pretty standard. != and == for does not equal and for equals.
## Relational, Spaces are critical.
# -eq	Checks if the value of two operands are equal or not; if yes, then the condition becomes true.	[ $a -eq $b ] is not true.
# -ne	Checks if the value of two operands are equal or not; if values are not equal, then the condition becomes true.	[ $a -ne $b ] is true.
# -gt	Checks if the value of left operand is greater than the value of right operand; if yes, then the condition becomes true.	[ $a -gt $b ] is not true.
# -lt	Checks if the value of left operand is less than the value of right operand; if yes, then the condition becomes true.	[ $a -lt $b ] is true.
# -ge	Checks if the value of left operand is greater than or equal to the value of right operand; if yes, then the condition becomes true.	[ $a -ge $b ] is not true.
# -le	Checks if the value of left operand is less than or equal to the value of right operand; if yes, then the condition becomes true.	[ $a -le $b ] is true.
## Boolean
# !		This is logical negation. This inverts a true condition into false and vice versa.	[ ! false ] is true.
# -o 	This is logical OR. If one of the operands is true, then the condition becomes true.	[ $a -lt 20 -o $b -gt 100 ] is true.
# -a	This is logical AND. If both the operands are true, then the condition becomes true otherwise false.	[ $a -lt 20 -a $b -gt 100 ] is false.
## String
# =		Checks if the value of two operands are equal or not; if yes, then the condition becomes true.	[ $a = $b ] is not true.
# !=	Checks if the value of two operands are equal or not; if values are not equal then the condition becomes true.	[ $a != $b ] is true.
# -z	Checks if the given string operand size is zero; if it is zero length, then it returns true.	[ -z $a ] is not true.
# -n	Checks if the given string operand size is non-zero; if it is nonzero length, then it returns true.	[ -n $a ] is not false.
# str	Checks if str is not the empty string; if it is empty, then it returns false.	[ $a ] is not false.
## File test
# -d file	Checks if file is a directory; if yes, then the condition becomes true.	[ -d $file ] is not true.
# -f file	Checks if file is an ordinary file as opposed to a directory or special file; if yes, then the condition becomes true.	[ -f $file ] is true.
# -k file	Checks if file has its sticky bit set; if yes, then the condition becomes true.	[ -k $file ] is false.
# -t file	Checks if file descriptor is open and associated with a terminal; if yes, then the condition becomes true.	[ -t $file ] is false.
# -r file	Checks if file is readable; if yes, then the condition becomes true.	[ -r $file ] is true.
# -w file	Checks if file is writable; if yes, then the condition becomes true.	[ -w $file ] is true.
# -x file	Checks if file is executable; if yes, then the condition becomes true.	[ -x $file ] is true.
# -s file	Checks if file has size greater than 0; if yes, then condition becomes true.	[ -s $file ] is true.
# -e file	Checks if file exists; is true even if file is a directory but exists.	[ -e $file ] is true.

### POSIX REGULAR EXPRESSIONS
# MATH 	# POSIX	# MEANING
# c 	# c 	# matches "c"
# L1∘L2	# p1p2	# matches p1 then p2
# L1∪L2	# p1\|p2# matches p1 or p2
# L⋆	# p*	# matches "" or p repeated
# L+	# p\+	# matches p repeated, but not ""
# L?	# p\?	# matches p or ""
# Ln	# p\{n\}# matches p repeated n times
# L[n,m]# p\{n,m\} # matches p repeated n to m times
# Σ 	# .			# matches any character
# {c1,…,cn} # [c1…cn] # matches c1 or c2 or … or cn
# Σ−{c1,…,cn} # [^c1…cn] # matches any char but c1 or … or cn
# (L)	# \(p\)	# matches p, remembers submatch
# no eq # \n	# matches string from nth submatch
# no eq	# \b	# matches a word boundary
# no eq	# [[:word:]]	# matches a word character, e.g., alphanumeric
# no eq	# [[:space:]]	# matches a whitespace character, e.g., space, tab, return
# no eq	# [[:digit:]]	# matches a digit character, i.e., 0-9
# no eq	# [[:xdigit:]]	# matches a hex digit character, i.e., A-F, a-f, 0-9
# no eq	# [[:upper:]]	# matches a upperspaced character
# no eq	# [[:lower:]]	# matches a lowerspaced character
# no eq	# ^	# matches start of line/string
# no eq	# $ # matches end of line/string
# no eq # [c1-c2]	# matches c1 through c2


echo Examples of print statements using echo and printf
echo \"Hello world\" # Escape character \ before " to print the quotation marks
echo "Hello world"
echo Hello world #Quotation marks are optional.


### BASH
## POSITIONAL PARAMETERS
# $0, $1, $2, etc. #Positional parameters, passed from command line to script, passed to a function, or set to a variable (see Example 4-5 and Example 15-16)
# $# # Number of command-line arguments [4] or positional parameters (see Example 36-2)
# $* # All of the positional parameters, seen as a single word. "$*" must be quoted.
# $@ # Same as $*, but each parameter is a quoted string, that is, the parameters are passed on intact, without interpretation or expansion. 
#	This means, among other things, that each parameter in the argument list is seen as a separate word. Of course, "$@" should be quoted.

## INSTRUCTIONS/INTERPOLATION/EXPRESSIONS/ETC.
# single brackets versus double brackets, etc
# TODO: Take notes on this
# https://stackoverflow.com/questions/6270440/simple-logical-operators-in-bash

echo Hello world
printf "Okay\n" # New line via \n 
#Todo show other stuff than \n
printf No quotations #???


echo Example of variable declaration
foo=3 # No spaces allowed
((foo = 5)) # Spaces are allowed if you use double parentheses
echo $foo # Prints value of the variable
unset foo # Deallocates the variable

echo Further examples
foo=3
bar=7
foo=$bar 
echo foo is $foo
bar="string time"
foo=$bar
echo $bar
echo $foo
unset foo
unset bar

#Arrays
foo[0]=a
foo[1]=b
foo[2]=c
echo ${foo[@]} #print all: "a b c"
echo ${foo[*]} #same thing
bar=("a a a" "b b" "c")
echo ${bar[@]}
foo2=("${foo[@]}") #array copying using ("")
echo ${foo2[@]}


files=(~/Documents/Code\ for\ practice/*)
echo ${files[0]}
echo ${files[1]}
files2=(*.seq)
echo "ok ${files2[0]}"
echo ${files2[1]}

echo For Loops
#for i in ${files2[@]}; do
#	echo item: $i
#	#wc -m $i
#done

#while
#charcount=0
#linecount=1
#while IFS= read -r line
#do
#	if [ $linecount -gt 1 ]
#	then
#		(( charcount = $charcount + ${#line} ))
#	fi
#	(( linecount = $linecount + 1 ))
#done < "$1"
#echo "charcount is $charcount

strings=("30-63724354_ab1" "30-63724354_seq" "30-63724354_seq.zip")
echo ${strings[1]}
for i in strings; do
	if [ egrep ]
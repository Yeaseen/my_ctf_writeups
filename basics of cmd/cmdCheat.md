# Command Line Cheat Sheet

## Navigation

- `~`: Home
- `$`: Path end of Regular User Prompt
- `#`: Path end of Root User Prompt
- `/`: Root Directory
- `..`: Parent Directory
- `./`: Current Directory
- `*`: Wildcard (Matches any character or group of characters)

### Example Path:

```bash
~/Y_E_@_S_E_EN/SEU/CSE3032/Folder1$
```

### Variables

```bash
seu@seu:~/Documents/YAT_OS/first_D$ abc=7
seu@seu:~/Documents/YAT_OS/first_D$ echo "$abc"
7
```

# List all files and folders in the current location

- `*`: all files and folders in the current location

```bash
myfiles=(\*)
echo "$myfiles"
echo "{myfiles[0]}"
echo "${myfiles[0]}"

#see the user name
whoami

# Clear terminal
clear

# Print current directory
pwd

# List files and folders
ls

# List all files and folders (including hidden ones)
ls -A

# Create a folder
mkdir Folder1

# Change directory
cd Folder1

# Move back to the parent directory
cd ..

# Create a folder with spaces
mkdir "child number three"
mkdir child\ number\ three
mkdir "my tree speaks as if I didn't"
mkdir a\'b
mkdir a\*b
mkdir a\\b

# Remove a directory
rmdir my

# Remove a file
rm abc.txt

#Multiple folder creation and deletion
mkdir a b c d e f g h i j
rmdir a b c d e f h g j i

#Recursively delete a folder and its children
rm -r childOfFolder1
```

# File manipulation

```bash
# Open a text file in the nano editor
nano abc.txt
#If you want to write something, then type what you want to write at this step.
#Press ctrl+X
#Type 'y'
#Press 'Enter' Button

# Open a text file in the vim editor
vim newfile.txt
#follow vim's features

# Move a file
mv abc.txt LocationToMove
mv full_path_of_SOURCE_FILE full_path_where_to_move

# Rename a file
mv abc.txt superman.txt

# Copy a file
cp abc.txt LocationToMove
cp full_path_of_SOURCE_FILE full_path_where_to_move

# Display file content
cat superman.txt

# Display line numbers in a file
cat -n superman.txt

# Display end-of-line characters in a file
cat -e superman.txt

# Display both line numbers and end-of-line characters
cat -ne superman.txt
```

# Text Manipulation

## Concatenation and Appending

```bash
# Concatenate files
cat batman.txt superman.txt > batmanvssuperman.txt

# Append content to a file
cat wonderwoman.txt >> batmanvssuperman.txt

# Print lines 10 to 15 of a file
sed -n '10,15p' file1.txt

# Append lines 10 to 15 of file1.txt to file2.txt
sed -n '10,15p' file1.txt >> file2.txt

#* == all files in a folder
cat *
ls *
#: Copies all files and folders in the current directory to the specified destination.
cp * destination_path
```

## Word Count

```bash
# Count lines, words, characters, and bytes in a file
wc -lwmc filename

# Count lines, words, and characters in a file but using parallelism
cat filename | wc -lwmc

# Count lines, words, and characters in all files in the current directory
cat * | wc -lwmc
```

## File Search

```bash
# Find files with a specific name
#here * is for pattern matching

find . -type f -name abc.txt
find . -type f -name 'm*l.txt'
find . -type f -iname 'p*m*l.*'

# Delete all PDF files in a directory
find . -type f -name "*.pdf" -exec rm -f {} \;

#find: This command is used to search for files and directories in a directory hierarchy.
#.: Specifies the starting directory for the find command. In this case, it starts the search from the current directory.
#-type f: Specifies the type of the found items. In this case, it looks for regular files.
#-name "*.pdf": Filters the search based on the name of the files. Here, it's looking for files with names ending in ".pdf".
#-exec: Executes a command on the files found by find.
#rm -f {}: The command to be executed. It removes files forcefully (-f). {} is a placeholder for each file found by find, and it gets replaced by the actual file names.
#\;: Indicates the end of the -exec command. It needs to be terminated with a semicolon.


# Display the content of all text files
find . -type f -name "*.txt" -exec cat {} \; | wc -lw
```

### Searching Patterns

# rg command

```bash
#The rg command is a fast, ripgrep line-oriented search tool that recursively searches your current directory for a regex pattern.
#You may need to install it

#Searches for the specified pattern in the file.txt file.
rg "pattern" file.txt

#Recursive Search in Current Directory:
rg "pattern"

#Case-Insensitive Search:
rg -i "pattern"

#Search for Whole Words Only:
rg -w "pattern"

#Search for Lines Not Matching a Pattern:
rg -v "pattern"

#Count the Number of Matches:
rg -c "pattern"

#Search for Files Containing the Pattern:
rg -l "pattern"

#Search for a Specific File Type with a pattern:
rg --type md "pattern"

#Search for Multiple Patterns (OR): Searches for lines containing either pattern1 or pattern2.
rg "pattern1|pattern2"

#Search for Multiple Patterns (AND): Searches for lines containing both pattern1 and pattern2.
rg -e "pattern1" -e "pattern2"

#Exclude Files or Directories: Excludes files listed in skip.txt and the directory named exclude_folder from the search.
rg "pattern" --ignore-file=skip.txt --ignore-dir=exclude_folder

```

# Grep commands

```bash
#-o == only matched part will be portrayed
#-i == case insensetive
#-w == only for matched WORD
# Grep command with options
grep -oi 'c' batman.txt | wc -w
grep -owi 'man' batman.txt | wc -w

# Grep with head and tail
head -n 3 superman.txt | grep -o 'o' | wc -w
tail -n 3 superman.txt | grep -o 'o' | wc -w

# Combined Grep
{ grep -ow 'ASUS' batman.txt && grep -owi 'ASUS' superman.txt } | wc -w

#Q. Find the number of the occurences of 'man' in the first seven lines of the superman.txt file.
head -n 7 superman.txt | grep -o 'man' | wc -l

#Q1. Write a command line that can print the frequencies of a string that starts with ‘p’
and ends with ‘t’ in the last 20 lines of abc.txt file and the first seven
lines of pqr.txt file. [Use regex]

{ tail -n 20 abc.txt | grep -oi 'p*t' && head -n 7 superman.txt | grep -o 'p*t'} | wc -w


# Count occurrences in the first seven lines
head -n 7 superman.txt | grep -o 'man' | wc -l

```

### Permissions and Operations

```bash
# Change file permissions
#Permission:: r = read; w = write; x = execute
#Owner's Permission	 group's permission         random users' permission
#     Current:    rwx rwx rwx
#                 111 111 111
#      After:      -wx r-x ---
#		  011 101 000
chmod 350 filename

#      After:      rwx r-x ---
#		  111 101 000
chmod 750 filename

#recursively change on all subdirectories as well
chmod -R 744 folderName

#to give all permission
chmod +x script.sh
```

# Process Commands Cheat Sheet

## Display Process Information

```bash
#Display information about active processes.
ps -ef

#Display detailed information about all processes.
ps aux

#Display processes owned by the current user
ps -u whoami

# Count instances of 'Google Chrome' processes
pgrep 'chrome' | wc -w

#List process IDs based on the current user name.
pgrep -u whoami

#Signal processes based on a pattern in the command line.
pkill -f "java app"

```

## Process Management

```bash
#Terminate a process by its process ID.
kill 1234

#Terminate all processes with a specific name.
killall firefox

#Signal processes based on their name.
pkill chrome

#Display and update sorted information about system processes.
top

#An interactive process viewer.
htop

#Forcefully terminate a process.
kill -9 5678
```

## Resource Usages

```bash
#Display disk space usage of file systems.
df -h
# Display disk usage of files and directories.
du -h
```

## Job Scheduling

```bash
#o schedule a job using command lines in Unix-like systems (including Linux), you can use the cron service. cron is a time-based job scheduler in Unix-like operating systems.
#Use the following command to open the crontab editor:
crontab -e

#The general syntax for a cron job is as follows:
* * * * * command_to_be_executed
#Each * represents a time unit, and the five *'s correspond to minutes, hours, days of the month, months, and days of the week, respectively.

#the following cron job runs the command /path/to/your/command every day at 2:30 AM:
30 2 * * * /path/to/your/command
#30: Minutes (0-59)
#2: Hours (0-23)
#*: Every day of the month (1-31)
#*: Every month (1-12)
#*: Every day of the week (0-6, where Sunday is 0)
#Save and Exit like nano or vim editor

#View Scheduled Jobs
crontab -l

#The following rsync backup command will run every 10 minutes
*/10 * * * * rsync -a -delete -e ssh webgoat@192.168.56.102:/home/webgoat /opt/backup

#this command will run every two hours
* */2 * * * command
```

### Aliases

```bash
#Temporary alias for 'ls'
alias what='ls'
what
#what command will print the list of files and folders of the current directory

#For permanent change, append the alias to .bashrc
```

## Find & Replace with Sed

```bash
# Basic find and replace
sed 's/unix/linux/' geekfile.txt
#Here the “s” specifies the substitution operation. The “/” are delimiters. The “unix” is the search pattern and the “linux” is the replacement string.
#By default, the sed command replaces the first occurrence of the pattern in each line and it won’t replace the second, third…occurrence in the line.

# Replace second occurrence
sed 's/unix/linux/2' geekfile.txt

# Global replacement
sed 's/unix/linux/g' geekfile.txt

# Replace on a specific line number
sed '3 s/unix/linux/' geekfile.txt

#Replacing string on a range of lines :
sed '1,3 s/unix/linux/' geekfile.txt

#Here $ indicates the last line in the file.
sed '2,$ s/unix/linux/' geekfile.txt
```

## Deletion with sed

```bash
# Delete a specific line
sed '5d' filename.txt

# Delete the last line
sed '$d' filename.txt

# Delete lines in a range
sed '3,6d' filename.txt

# Delete from nth to last line
sed '12,$d' filename.txt

# Delete pattern matching line
sed '/abc/d' filename.txt

```

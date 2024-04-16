# Introduction to Linux and command lines: A recap

#### Learning outcome from this exercise

a. How to connect to remote server/virtual machine
b. 	Basic linux commands for file and folder operations

#### How to connect to your virtual machines

I used azure lab (labs.azure.com) to create individual linux virtual machines. You already got an invitation from me to join virtual lab at labs.azure.com as registration link. Once you register, you will see your machine. This portal is to start/switch off your server outside the scheduled hour (1000-1600). However, process of connecting to a server is not automatic and you need to do it yourself when you need to do some work in the server. 

When you press registration link, it will take you labs.azure.com using uit credentials. Once you are done with registration, you will see a linux virtual machine in your home page (labs.azure.com). You cannot do anything until you set a password. Press “reset password” button (one column of 3 dots) to set a password. It will take ca. two minutes to finish password setting. Then you will see computer icon close to that row of 3 dots. Click start and wait until you get “running” there. Now press that icon to get popup window with ssh command line to connect your virtual machine. Copy that command line. 

###### Following steps will apply for Mac only:

Type terminal in Launchpad and press terminal. Select terminal and paste that command there and Press enter.  Type yes in next command (fingerprint question). Type password you set. You should be in now. 

###### Following steps will apply for windows users only:

Option 1.
If you have power terminal (PowerShell) in your windows (type PowerShell in search bar), then things are easy. Open the power terminal and paste the command line you copied from labs.azure.com, type password (you won’t see any anything, it is hidden as they are passwords!!!!). You are in. 

Option 2. 
From MobaXterm also you can launch the ssh command and get into the server. 

###### for all 

We also need to install filezilla, a file transferring system for mac and windows and it comes with graphical user interface. Download your copy of that from here: https://filezilla-project.org/download.php?type=client and install. Then we need to prepare filezilla to connect to our server. we will do it together. First open the app and follow the document uploaded (configure filezilla) 

#### History of terminal

Probably Daniel might have already dwelled into this section. 
Terminal is just a tool to connect commands with the machine, just like a keyboard and mouse.  Simple!!! You have already experienced how most of the linux machine look like: there is no graphical user interface (GUI) between you and the server. GUI do exist for personal Linux based machines. We use ‘commands’ to communicate with the server/virtual machine. A 'Command' is synonymous to 'tranfer a file from one folder to another folder in a ordinary computer where you have access to mouse or touchpad.

## Basics of Linux command line

Once you are connected to the server, first thing you see is a welcome message and this: 

```
username@servers-network-name: ~ $       #it is called prompt, that is the way computer telling you that “I am ready to take your instructions”. Bring it on.

```

Run command now. 

First, we will find out where (which directory/folder) are we right now in our machine. 

```
pwd # Print Working Directory, very intuitive.

```

you will see this: /home/YOURUSERNAME. 

This is your current working directory (remember from part 1, R?). 


## Listing the content of a folder (or directory)

Use 'ls' to list what is there in your present directory. 'ls' stands for list. 

Type: man ls to read the help. use man for help. 

Mostl likely you will not see anything. Just an empty folder. Lets make some folder inside this. 

## create a new folder inside the working directory

We use 'mkdir' command to make directories. Remember about shortcuts. This is useful when you executed certian command and you want to rerun, then use up nd down keys to get that command. Also tab is very useful to complete such as file name and folder you want to read or enter into. press TAB and then write first letter, it will show you lsit of files starting with that letter in that folder.

Try all these commands after reading the manual
mkdir test_1
mkdir -p -v test/test1/test2 #asking to make directory inside the directory in one command. otherwise you have to go into the fodler you want to make another directory

Now try this inside folder you made: 
mkdir NAME_OF_A_FOLDER

and 

mkdir NAME OF A FOLDER

what do you see? 

Computer will treat space as separate folder you are asking it to make. If you want (**I discourage using space in file or folder name)** 

## Navigating between the directories

This is a routine thing we everyday do in laptop, moving files from one folder to another. 
We use a command called 'cd' **(c**hange **d**irectory). 
cd  specify which directory you want to go 
Example:  cd .. (Take you one level up toward the direcptry called **root**) or cd /

note down your current owrking directy and then run this following command.

```
cd ..

```
What did you see? 

Now type 

```
cd /  #will take you to the “root” directory

```
Yes, it is analogous to **root** from a tree. All the other directories in the server are branching from this directory. 

As I said earlier '..’ along with 'cd' to move towards directories multiple levels of parent directories

```
cd  ../  #change directory to the parent directory of the current directory

pwd
```

## Relative and absolute paths

**Relative path**: The place you end up depends on your current working directory. It doesn't start with a leading slash (/).

Try 'cd etc' or 'cd mnt'
what do you get? **No such file or directory**. 

**Absolute path:**  no matter where you are (current folder) you will still reach to the folder you want to enter. It always starts with a leading slash (/).
Try, 
cd /
cd /etc 

**BONUS:** Other way to reach your home directory is step by step using the ‘tilde’ character (”~”) at the start of your path similarly means “starting from my home directory”.

Try 
```
cd ~

```

## Creating a file and adding contents to a file

Stay in the folder you are in right now. You can use 'touch' to create a new file. But it is an empty file. Just check it using 'cat' or 'less'.

```
touch test.txt
cat test.txt

```
To add content to empty file you need to open test.txt in 'nano'. text editor for linux command line. To see and modify the content (feasible only with files with few content). 

```
nano test.txt #type texts and press control+x. it will be saved. 

`````
What we will do now is redirect the output of ls command to a file.

```
ls > ls.txt

echo "This is a test" > test_1.txt
echo "This is a second test" > test_2.txt

nano ls.txt
nano test_1.txt

head ls.txt (gives you first 10 lines of a file)

tail ls.txt (gives you last 10 lines of a file)

````

How to read multiple files together? Use cat again. cat is concatenate
cat test_1.txt test_2.txt 
cat test_1.txt test_2.txt >concatenated_file.txt

## wild cards

If there is consistent pattern in file names, you can use wild card such as *. 
Example: 

```
cat test_* > combined.txt
cat t*>combined.txt

```
### Tips to make a good fodler name and file name

1.	Don’t use spaces in the file name
2.	Don’t use capital letters in the naming: need to switch of caps lock every now and then.
3.	Use names as sensible as possible so that it gives you lot of information about the conent of the folder.
4.	Don’t use closely related file names or files names which are not very different from each other. 
5.	Always use an extension to a file. Example: .txt, .csv, .tsv 

## Moving and manipulating a file

Let’s move the file from current directory to another directory. One can use 'cp' or 'mv'. 
We use a command called mv, which stands for **move**. 

mv combined.txt newdirectory (here first make your new directory using mkdir command)

Confirm the result by 'ls dir1'. Or just run ls in the current directory. If it is not present in the current directory, then it is moved to dir1. Mv commnd physically moves file from one location to another.

You can use mv command to move more than one element from a directory. Last parameter in the mv command will be the one which gets the other elements. 

If you want to bring back combined.txt to where it was before moving, then use mv dir1/combined.txt.

Now we will keep a copy of the file before we move that file anywhere else.

```
cp combined.txt combined_copy.txt

```
mv command can also be used as renaming tool like cp. But cp will keep a copy of the original file in the destination, while mv not.

## Delete a file
 
Now will try most destructive command of all the linux commands: 'rm' (stands for **remove**).

Now remove a file. 

```
rm combined_copy.txt #removes a file

rmdir example_folder #removes a folder

```

### Tips  

1.	Think twice before you run the command rm. 
2.	Be careful with using rm command in wild card setup.
3.	rm command doesn’t move the files to thrash/recycle bin. It simply deletes file from the system with no way to recover it (it is possible the big servers).
4.	If you are unsure, try to use -i with rm command to enable interactive mode, so that you have second chance to think before you say YES. 

## Plumbing work

You want to know how many lines there in text file are. It is easy if you use a graphical interface utility (or a text editor which gives you line number, example nano). But you want to know the line number quickly, you need to use command line to figure that out. 

How many lines are there in combined.txt?
Use: 

```
wc -l combined.txt

```
wc stands for word count. When you use -l it gives you total number of lines instead of just character count (when you use wc only)

Results will be displayed on screen. We call this results on screen as 'standard output (STDOUT)'.

### Piping

How many files are there in a folder? 

Test this using: 'ls | wc -l' Here I piped an output from a command called 'ls' to another command 'wc -l'. Here wc -l takes STDOUT of ls as INPUT (STDIN). 

When you have few lines, then use less. Example ls | less.

If you want to know what a particular command does and how to use it. just type man COMMAND

man mv 
man cp
man wc 

### How to do a multiple piping
Example: 

```
sort combined.txt | uniq | wc -l

```

**Tell me what this above command do? Use man to know what sort and uniq.**


### pick some thing from a file

When you have a file with multiple columns, and you want to cut a particular column, then use 'cut'. Use man cut.  If you want to find something from a file, then use 'grep'. 

grep ‘somethingyouwantto’ filename.txt

Find and replace can be performed using 'sed'.
sed 's/findword/replaceword/' file.txt

Type “linux cheat sheet” in the google you get 100s of list.  And try those commands. 

### File permissions

In Linux everything is a file. Folders are files, files are files and external devices are files. All the files in linux system have file permissions. It says all about who can read and write and execute a file / program/comman. Each file has different level of access restrictions.

If you do 'ls -lh' in a folder 

you see drwxrwxr-x on your screen. They tell you who have permission to use this folder (or directory) and what purpose (reading, modifying/writing, executing a operation). If it is a file , then you wont see d, instead it will be rwxrwxr-x

Here are three types of access restrictions (from linux related webpages): 

| permission  | action | chmod_option|
| ------------- | ------------- |----------|
| read (view)  | r  |      4    |
| write (edit)  |w  |      2    |
| execute (command)|x|1|

There are also three types of user restrictions: 
|User |	ls output|
|-----|----------|
|owner	| rwx------|
|group	|----rwx---|
|other	|-------rwx|

Directories have directory permissions. The directory permissions restrict different actions : 

1.	read restricts or allows viewing the directories contents, i.e. ls command 
2.	write restricts or allows creating new files or deleting files in the directory. (Caution: write access for a directory allows deleting of files in the directory even if the user does not have write permissions for the file!) 
3.	execute restricts or allows changing into the directory, i.e. cd command

Look into your folder and say how these permissions are organized? 

Generally, owner of the file has permission to change the accessibility of file or folder. Thats why if you go and try to do some operations on files and filders inside '/' , it will comoplain tht you dont have permission. Another user who can override even the owner of the file is a **ROOT** user (su, sudo). Briefly, root user is owner of the system. Root user is a super user (su) and executes commands as sudo. sudo is a safety net for super user not to commit any command without second thought. First user of the system is always a root. Root user is also administrator of the system. Root will decide the functinality of the system in terms of users and permisiion. Then root can use discretion to empower other users to root level. Not all the users can become root user. Superuser power comes with super responsibilities. Super User has all the power in a system, even to destroy the system itself. 

If you are owner of the file or folder, you should use chmod to change the ownership/sharing/or to impart selective permission to other users to your folders or files. 

Type 'chmod' you will get help. 

chmod {options} filename

Options	Definition
u 	owner 
g 	group 
o 	other 
a 	all (same as ugo) 
x 	execute 
w 	write 
r 	read 
+ 	add permission 
- 	remove permission 
= 	set permission

Or you can use bit numbers. 
First number related Owner, second number related group and 3rd number related to other users (not part of the group) 
  
(from google)

TRY out the commands and their usage: ps, top, htop, zcat, unzip, gzip, history. Find out what they do. These commands will give different information about the system and unzipping a xipped folder and so on. 


## Scripting

Now we probably few things about how the Linux and command line work. Now we will go for a next level called 'scripting'. You already know little bit about scripting from data science part. Scripting is writing a set of instructions to computer.  

Scripting essentially uses shell, which is a microprocessor which allows for an interactive or non-interactive command execution in combination with nano.

Terminal is input output environment (a way to talk to computer)

Your terminal contains shell (an interface). A shell is a user interface for access to an operating system's services. 

Now we will write a very small script using bash as interpreter (interprets commands to CPU) (which is default in any unix based system, there are also python, perl and so on). An interpreter is a computer program that directly executes instructions written in a programming such as bash.

run:

```
echo $SHELL

```
Write a small script: 

Open nano. Type all small commands such as date, cal, ls in separate lines and save it as test.sh. I am using .sh because I am using bash as interpreter of my commands.  

There is small script uploaded in the bioinformatics section of the canvas which is related to the taking backup of a folder. 

Variables
Variables are the essence of programming. Variables allow a programmer to store data, alter and reuse them throughout the script. Check ***welcome.sh*** script and ***backup.sh*** script. 

****References for this exercise: Some part of this exercise comes from linux tutorials published by Linux (ubuntu) people. All resources in their tutorials are open source****

# Introduction to Linux and command lines: A recap

#### Learning outcomes from this exercise

A) How to connect to remote server/virtual machine

B) Basic Linux commands for file and folder operations

#### How to connect to your virtual machines

Shripathi used Azure lab (labs.azure.com) to create individual Linux virtual machines for all students. You already got an invitation from me to join the virtual lab at labs.azure.com with a registration link. Once you register, you will see your machine. This portal is to start/switch off your server outside the scheduled working hours (1000-1600). Connecting to your virtual machine is not automatic, so you need to do it yourself when you need to work in the server.

When you press the registration link, it will take you to labs.azure.com using UiT credentials (make sure not to sign up with your personal credentials, use UiT information). Once you are done with the registration, you will see a Linux virtual machine in your home page (labs.azure.com). You cannot do anything until you set a password. Press “reset password” button (one column of 3 dots) to set a password. It will take a couple of minutes to finish setting the password. Afterwards, you'll see a computer icon close to the row of 3 dots. Click start and wait until you get “running” there. Now press that icon to get a popup window with ssh command line to connect your virtual machine. Copy that command, and do the following depending on your operating system: 

###### Following steps will apply for Mac only:

Type terminal in Launchpad and press terminal. Select terminal and paste that command there and press enter. Type yes in next command (fingerprint question). Type password you set. You should be in now. 

###### Following steps will apply for Windows users only:

Option 1:
From MobaXterm you can launch the ssh command and get into the server.

Option 2:
Alternatively, use PowerShell (type PowerShell in search bar). Open the power terminal and paste the command line you copied from labs.azure.com, followed by the password.

###### For all

We also need to install FileZilla - a file transferring system for Mac and Windows that comes with a graphical user interface. Download your copy here and install: https://filezilla-project.org/download.php?type=client. Next, we need to prepare FileZilla to connect to our server. We will do it together. First open the app and follow the document uploaded (configure FileZilla).

#### History of the terminal

We have already dwelled a little bit on this. The terminal is just a tool to connect commands with the machine, just like a keyboard and mouse. Simple! You have already experienced how most of the linux machine look like: there is no graphical user interface (GUI) between you and the server. GUI's do exist for personal Linux based machines. We use ‘commands’ to communicate with the server/virtual machine. A 'command' can be synonymous to 'tranfer a file from one folder to another folder' in your own computer when you have access to a mouse or touchpad.

## Basics of Linux command line

Once you are connected to the server, first thing you see is a welcome message and this: 

```
username@servers-network-name: ~ $       # it is called the 'prompt'. This is the way the computer is telling you that it is ready to take on your instructions. Bring it on!
```

Now we will try to run some commands. 
First, we will try to find out where (which directory/folder) we are right now in our machine. 
```
pwd # Print Working Directory, very intuitive.
```

you will see this: /home/YOURUSERNAME.
This is your current working directory.

## Listing the content of a folder (or directory)

Use 'ls' to list what is there in your present directory. 'ls' stands for list. 

Type: man ls to read the help. use man for help.

Most likely you will not see anything. Just an empty folder. Lets make some folder inside this.

Try to use some of the parameters (or "flags") for 'ls' that showed up in the help feature, and see how they differ. Return to this at a later stage again, once we have created some more files.

## Create a new folder inside the working directory

We use 'mkdir' command to make directories. Remember about shortcuts. This is useful when you executed a certain command and you want to rerun, then use 'up' and 'down' arrows on your keyboard to get that command. Also tab is very useful to complete file names and folder names you want to read or enter into. Press TAB and then write first letter, it will show you a list of files starting with that letter in that folder.

Try all these commands after reading the manual
mkdir test_1
mkdir -p -v test/test1/test2 # asking to make directory inside the directory in one command. Otherwise you have to go inside the folder first, if you want to make folders recursively (inside another folder).
Check mkdir --help to understand how the "-p" flag works.

Now try this inside folder you made: 
mkdir NAME_OF_A_FOLDER

and 

mkdir NAME OF A FOLDER

what do you see?

The computer will treat the space as if you are asking it to create separate folders. (**NOTE: We discourage using spaces in file or folder names)** 

## Navigating between the directories

This is a routine thing we do everyday in our laptops - moving files from one folder to another. 
Here we use a command called 'cd' **(c**hange **d**irectory). 
cd specifies which directory you want to go 
Example: cd .. (Take you one level up toward the direcptry called **root**) or cd /

Note down your current working directory and then run this following command.

```
cd ..
```
What did you see? 

Now type 

```
cd /  # will take you to the “root” directory
```
Yes, it is analogous to **root** from a tree. All the other directories in the server are branching from this directory. 

As mentioned, '..' along with 'cd' is used to move "one step up" towards the root.

```
cd  ../  # change directory to the parent directory of the current directory
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

**BONUS:** Another way to reach your home directory is step by step using the ‘tilde’ character (”~”) at the start of your path. This similarly means “starting from my home directory”.

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
To add content to an empty file you need to open test.txt in 'nano'. It's a text editor for Linux command line. To see and modify the content (feasible only with files with little content). 

```
nano test.txt # Type text and, when done, press control+x. It will be saved. 
```
Now we will redirect the output of our 'ls' command to a file.

```
ls > ls.txt
echo "This is a test" > test_1.txt
echo "This is a second test" > test_2.txt
nano ls.txt
nano test_1.txt
head ls.txt # gives you first 10 lines of a file
tail ls.txt # gives you last 10 lines of a file
```

How to read multiple files together? Use cat again. The command 'cat' is used to concatenate files.
cat test_1.txt test_2.txt 

cat test_1.txt test_2.txt > concatenated_file.txt

## Wild cards

If there is a consistent pattern in your file names, you can use wild card such as '*'.
Example: 

```
cat test_* > combined.txt
cat t* > combined.txt
```

### Tips to make a good folder name and file name

1.	Don’t use spaces in the file name
2.	Don’t use capital letters in the naming: need to switch of caps lock every now and then.
3.	Use sensible names so that the name provides meaningful information about the content of the folder.
4.	Don’t use closely related file names or files names which are not very different from each other. 
5.	Always use an extension to a file. Example: .txt, .csv, .tsv 

## Moving and manipulating a file

Let’s move the file from our current directory to another directory. One can use 'cp' or 'mv'. 
We use a command called mv, which stands for **move**. 

mv combined.txt dir1 (here you'll first need to make your new directory using the 'mkdir' command)

Confirm the result by 'ls dir1'. Or just run ls in the current directory. If it is not present in the current directory, then it is moved to dir1. The mv command physically moves file from one location to another.

You can use mv command to move more than one element from a directory. Last parameter in the mv command will be the one which gets the other elements. 

If you want to bring back combined.txt to where it was before moving, then use mv dir1/combined.txt .

Now we will keep a copy of the file before we move that file anywhere else.

```
cp combined.txt combined_copy.txt
```
The 'mv' command can also be used as renaming tool like 'cp'. But 'cp' will keep a copy of the original file in the destination, while 'mv' will not.

## Delete a file
 
Now we'll try the most destructive command of all the linux commands: 'rm' (stands for **remove**).

We're going to remove a file. 

```
rm combined_copy.txt # removes a file
rmdir example_folder # removes a folder
```

### Tips  

1.	Think twice before you run the command 'rm'.
2.	Be careful with using the 'rm' command in a wild card setup.
3.	The 'rm' command doesn’t move the files to the trash or recycle bin. It simply deletes the file from the system with no way to recover it (it might be possible if working on servers/clusters with timestamped physical backups).
4.	If you are unsure, try to use -i with rm command to enable interactive mode, so that you have second chance to think before you say YES.

## Plumbing work

Now we would like to know how many lines there are in a text file (e.g. to count the number of sequences you have got). It is easy if you use a graphical interface utility (or a text editor which gives you line number, example nano). But if you want to know the line number quickly, you need to use command line to figure that out. 

How many lines are there in combined.txt?
Use: 

```
wc -l combined.txt
```

wc stands for word count. When you use -l it gives you total number of lines instead of just character count (when you use wc only).
Results will be displayed on screen. We call this behaviour, i.e. to output to screen, as 'standard output (STDOUT)'.

### Piping

How many files are there in a folder? 

Test this using: 'ls | wc -l' Here we piped an output from a command called 'ls' to another command 'wc -l'. Here wc -l takes STDOUT of ls as INPUT (STDIN). 

When you have few lines, then use less. Example ls | less.

If you want to know what a particular command does and how to use it. just type man COMMAND

```
man mv 
man cp
man wc
```

Similarly, you can also type 'COMMAND --help'

```
mv --help
cp --help
wc --help
```

### How to do multi-piping
Example: 

```
sort combined.txt | uniq | wc -l
```

**What does the above command do? Use 'man' or 'help' to find out more information about 'sort' and 'uniq'.**


### Pick something from a file

When you have a file with multiple columns, and you want to cut a particular column, then use 'cut'. Use man cut.  If you want to find something from a file, then use 'grep'. 

grep 'somethingyouwantto' filename.txt

Find and replace (substitute) can be performed using 'sed'.
sed 's/findword/replaceword/g' file.txt

Type “linux cheat sheet” in Google you get 100s of lists. And try those commands.

### File permissions

In Linux everything is a file. Folders are files, files are files and external devices are files. All the files in a Linux system have file permissions. It tells you everything you need to know about who can read, write and execute a file/program/command. Each file has its own level of access restrictions.

If you do 'ls -lh' in a folder 

you see drwxrwxr-x on your screen. They tell you who have permission to use this folder (or directory) and what purpose (reading, modifying/writing, executing a operation). If it is a file , then you wont see d, instead it will be rwxrwxr-x

Here are three types of access restrictions (from Linux related webpages): 

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

Directories have directory permissions. The directory permissions restrict different actions: 

1.	read restricts or allows viewing the directories contents, i.e. 'ls' command 
2.	write restricts or allows creating new files or deleting files in the directory. (Caution: write access for a directory allows deleting of files in the directory even if the user does not have write permissions for the file!)
3.	execute restricts or allows changing into the directory, i.e. 'cd' command

Look at your folder(s) - how are these permissions in your case?

Generally, the owner of the file has permission to change the accessibility of the file or the folder. That's why if you go and try to do some operations on files and folders inside '/' , it is likely to complain about you not having permission. Another user who can override even the owner of the file is a **ROOT** user (su, sudo). A 'root user' is the owner of the system. Root users are super users (su) and can execute commands like 'sudo'. The 'sudo' command is a safety net for super user not to commit any command without second thought. The first user of a system is always a root user, and a root user is also an administrator of the system. Root users will decide on the functionality of the system, at least in terms of users and permissions. Root users can also empower other users to root level. However, not all the users can or should become root users. Remember - super powers come with super responsibilities. Super users have all the power in a system, even to destroy the system itself.

If you are the owner of a file or a folder, you should use chmod to change the ownership/sharing/or to impart selective permission to other users to your folders or files.

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

Our goal is to make it here for today, but if we have more time, you can try out the following commands and their usage: 'ps', 'top', 'htop', 'zcat', 'unzip', 'gzip' and 'history'. Find out what they do. These commands will give different information about the system, unzip a zipped folder and so on.

Lastly, we'll look a bit into scripting if we have additional time.

## Scripting

Now we know the basics of how Linux and the command line works. Next, we will go for a very short intro to 'scripting'. You already know bits and pieces about scripting from the Data Science part. Scripting is essentially just writing a set of instructions to a computer. We here use 'shell', which is a microprocessor that allows for an interactive or non-interactive command execution in combination with nano. Your terminal contains shell (an interface). A shell is a user interface for access to an operating system's services (remember from the last lecture?)

Now we will write a very small script using bash as the interpreter (interprets commands to CPU) (which is default in any Unix based system, there are also Python, Perl and so on). An interpreter is a computer program that directly executes instructions written in a programming language such as bash.

run:

```
echo $SHELL
```

You can also try:

```
echo $HOME
```

Execute a small script: 

There is small script uploaded in the bioinformatics section of the canvas, which performs a motivational greeting for you on Monday mornings. We are using ".sh" because bash is our command interpreter. You can place this script in your folder, and try to run it:

```
bash welcome.sh
```

## Variables
Variables are the essence of programming. Variables allow a programmer to store data, alter and reuse them throughout the script. Check ***welcome.sh*** script again.

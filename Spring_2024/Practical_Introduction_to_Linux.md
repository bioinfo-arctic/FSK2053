
# Practical Introduction to Linux
### In this class you will learn how to use the basic commands in a Linux terminal and how to create a organize your own scripts.

The interface to access the Linux commands and manipulate files and directories programmatically is the `bash` programming language and the `terminal`.

MacOS users or users of any version of the Linux operating system, already have the the `bash` language and the `terminal` available to use and don't need to install a terminal interface.
Windows users need to resort of tools like the **[MobaXterm](https://mobaxterm.mobatek.net)** and the installation of **[Windows Subsystem Linux (WSL)]( https://apps.microsoft.com/detail/9mttcl66cpxj)**, to have a comfortable use of the `terminal`.

The `Mobaxterm` interface:
![Mobaxterm interface](https://raw.githubusercontent.com/bioinfo-arctic/FSK2053/21259f727920e31d7851b150695337ae69844f38/Spring_2024/images/mobaxterm_interface_picture.png)

The `Linux terminal` accessible from the start local terminal button:
![Linux terminal](https://raw.githubusercontent.com/bioinfo-arctic/FSK2053/main/Spring_2024/images/mobaxterm_terminal_picture.png)

 To begin, let's learn how to navigate the file system.
 Display the current directory using 'pwd' (print working directory).
```
pwd
```
Now, let's list all files and directories in the current location.
```
ls
```
To change to a directory where you might store fish population data, use the command `cd`.
```
cd ~/fish_population_data
```
List files with details using `ls -l`
```
ls -l
```
#### Alternative display:
```bash
# To begin, let's learn how to navigate the file system.
# Display the current directory using 'pwd' (print working directory).
pwd

# Now, let's list all files and directories in the current location.
ls

# To change to a directory where you might store fish population data, use 'cd'.
cd ~/fish_population_data

# List files with details using 'ls -l'.
ls -l
```

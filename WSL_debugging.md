## Debugging WSL installations into MobaXterm for Windows users

### Download the Windows Subsystem for Linux (WSL)

https://uit.instructure.com/courses/40818/modules/items/1272441

#### Open PowerShell in administrator mode by right-clicking and selecting "Run as administrator", enter the wsl --install command, then restart your machine.

```
wsl --install
```

You will likely need to enter an email here. Use your preferred email.

### Additional debugging notes that may be helpful

#### In the powershell, run (could be "ubuntu2004..." something instead of ubuntu, depending on your installation)
ubuntu config --default-user <preferred_username>

### Follow this up with a restart of the PC

#### Run in MobaXterm in case you're in root mode by default.

```
adduser <preferred_username>
```

### In MobaXterm, do the following:
Sessions --> New session --> WSL --> Distribution --> Select "Ubuntu" --> OK

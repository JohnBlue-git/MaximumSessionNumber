## How to execute (.py) on Linux
```console
# to install package
python3 -m pip install --upgrade pip setuptools wheel
python3 -m pip install paramiko argparse

# to execute
python3 multi_ssh_test.py
```

## How to execute (.sh) on Linux
```console
./multi_ssh_test.sh
```

## How to execute (.bat) on windows
```console
# to edit on windows (this will prompt out a GUI)
notepad multi_ssh_test.bat

# to execute
.\multi_ssh_test.bat
```

## Facts that will restrict on the maximum size of ssh session a server can handle
- openssh-server VS dropbear
  - ...
- ...

Regarding the SSH MaxCurrentConnection, it has been tested multiple times. Observations using top have shown that the impact on CPU resources is significant (excluding the possible effects of TCP somaxconn or ulimit -n). Each SSH connection generates a process called dropbear, which uses about 1-3% of the CPU. Therefore, having 50-60 idle SSH connections is reasonable.

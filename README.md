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

## Facts that will restrict on the maximum number of concurrent ssh session a server can handle
- Openssh-Server VS Dropbear
  - Openssh-Server has option to set maximum number; while Dropbear is another light-weighted ssh server that doesn't suppot limit on the amount.
  - In configuration file /etc/ssh/sshd_config
    ```console
    MaxStartups 10:30:60
    # 10 is the number of unauthenticated connections before SSH starts dropping
    # 30 is the percentage chance of dropping a connection, once the limit is reached
    # 60 is the maximum number of connections at which SSH starts dropping everything
    ```
- The number of file a program is allowed to handle at a time
  - Because every connection need **fd** (or need to open a file to describe the connection); therefore the number of file a program is allowed to handle at a time may limits the maximum concurrent connections size.
  - ```console
    ulimit -n
    ```
- TCP somaxconn
  - Because ssh relys on TCP protocal. And TCP has a restriction on the number of instant connections allowed to be established.
  - Located at /etc/sysctl.conf or in the /etc/sysctl.d/ directory
    ```console
    net.core.somaxconn = 1024
    ```
- The CPU resources
  - For example, if each SSH connection consumes about 1 - 3 % of the CPU, 50 - 60 of concurrent ssh connections is its limits. Observations using top have shown that the impact on CPU resources is significant
    <img width="568" alt="image_2024_12_11T02_30_43_547Z" src="https://github.com/user-attachments/assets/ed449cc6-f92d-4cd9-b92a-e6494a10c0a6" />


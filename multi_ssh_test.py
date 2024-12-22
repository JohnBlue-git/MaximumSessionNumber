import paramiko
import threading
import time
import argparse

attemptNum = 0
successNum = 0
failNum = 0
lock = threading.Lock()
num_connections = 0

def create_ssh_connection(hostname, username, password, duration, barrier):
    global attemptNum, successNum, failNum
    with lock:
        attemptNum += 1

    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    try:
        client.connect(hostname, username=username, password=password)
        with lock:
            successNum += 1
        # Keep the connection open for the specified duration
        time.sleep(duration)
    except Exception as e:
        with lock:
            failNum += 1
    
    # Wait for all threads to reach this point
    barrier.wait()
    
    finally:
        client.close()
        #print("Connection to {} closed".format(hostname))

# Create the parser
parser = argparse.ArgumentParser(description="Process some inputs.")
# Add arguments
parser.add_argument("hostname", type=str, help="host name")
parser.add_argument("num", type=int, help="number of connections")
parser.add_argument("duration", type=int, help="connection duration")
# Parse the arguments
args = parser.parse_args()

# Fill in
hostname = args.hostname
username = 'root'
password = '0penBmc'
num_connections = args.num
duration = args.duration

def create_connections_in_batches(hostname, username, password, duration, num_connections, batch_size=50, delay=1):
    threads = []
    barrier = threading.Barrier(num_connections)
    for i in range(0, num_connections, batch_size):
        batch_threads = []
        for j in range(batch_size):
            if i + j < num_connections:
                thread = threading.Thread(target=create_ssh_connection, args=(hostname, username, password, duration, barrier))
                batch_threads.append(thread)
                thread.start()
        threads.extend(batch_threads)
        time.sleep(delay)
        
    # Join all threads
    for thread in threads:
        thread.join()

create_connections_in_batches(hostname, username, password, duration, num_connections)

# Print
print("Connection Success: {}".format(successNum))
print("Connection Fail: {}".format(failNum))
print("All connections attempted and closed after the specified duration.")

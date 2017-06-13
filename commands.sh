To Kill processes:

for pid in $(ps -ef | grep "some search" | awk '{print $2}'); do kill -9 $pid; done
for pid in $(ps -ef | awk '/some search/ {print $2}'); do kill -9 $pid; done


adding directory to path variable:
First check if the path to add is already part of the variable:
[[ ":$PATH:" != *":/path/to/add:"* ]] && PATH="/path/to/add:${PATH}"
If /path/to/add is already in the $PATH, then nothing happens, else it is added at the beginning.
If you need it at the end use PATH=${PATH}:/path/to/add instead.

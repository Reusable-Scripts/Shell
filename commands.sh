To Kill processes:

for pid in $(ps -ef | grep "some search" | awk '{print $2}'); do kill -9 $pid; done
for pid in $(ps -ef | awk '/some search/ {print $2}'); do kill -9 $pid; done

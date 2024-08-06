#!/bin/bash

# Name of the service to monitor
SERVICE_NAME='pmd'
#declare -a PIDS=(
#[0]=731
#[1]=1667
#[2]=1656
#[3]=1673
#[4]=2053
#[5]=6759
#)


# Interval between checks (in seconds)
INTERVAL=2

# Function to get CPU usage of the service
get_cpu_usage() {
    # Get PID(s) of the service
    PIDS=$(pgrep -f "$SERVICE_NAME")

    # Check if PID was found
    if [ -z "$PIDS" ]; then
       echo "Service $SERVICE_NAME not found."
       return
    fi

    # Initialize total CPU usage
    TOTAL_CPU_USAGE=0

    # Loop through all PIDs and accumulate CPU usage
    for PID in $PIDS; do
        # Get CPU usage for each PID
        CPU_USAGE=$(ps -p $PID -o %cpu= 2>/dev/null)
        #echo $MEM_USAGE
        
        
        if [ ! -z "$CPU_USAGE" ]; then
            TOTAL_CPU_USAGE=$(echo "$TOTAL_CPU_USAGE + $CPU_USAGE" | bc)
            #TOTAL_MEM_USAGE=$(echo "$TOTAL_MEM_USAGE + $MEM_USAGE" | bc)
        fi
        
      
    done

    # Print total CPU usage
    echo "$TOTAL_CPU_USAGE"
    echo "$TOTAL_MEM_USAGE"
}

get_mem_usage() {
    # Get PID(s) of the service
    PIDS=$(pgrep -f "$SERVICE_NAME")

    # Check if PID was found
    if [ -z "$PIDS" ]; then
       echo "Service $SERVICE_NAME not found."
       return
    fi

    # Initialize total CPU usage
    TOTAL_MEM_USAGE=0

    # Loop through all PIDs and accumulate CPU usage
    for PID in $PIDS; do
        # Get CPU usage for each PID
        MEM_USAGE=$(ps -p $PID -o %mem= 2>/dev/null)
        #echo $MEM_USAGE
        
       
        
        if [ ! -z "$MEM_USAGE" ]; then
            #TOTAL_CPU_USAGE=$(echo "$TOTAL_CPU_USAGE + $CPU_USAGE" | bc)
            TOTAL_MEM_USAGE=$(echo "$TOTAL_MEM_USAGE + $MEM_USAGE" | bc)
        fi
        
    done

    # Print total CPU usage
    echo "$TOTAL_MEM_USAGE"
}

# Print header
echo "Tracking CPU utilization for service: $SERVICE_NAME"
echo "Interval: $INTERVAL seconds"
echo "Press [CTRL+C] to stop."

# Monitor loop
while true; do
    CPU_USAGE=$(get_cpu_usage)
    MEM_USAGE=$(get_mem_usage)
    if [ ! -z "$CPU_USAGE" ] || [ ! -z "$MEM_USAGE" ]; then
    #if [ ! -z "$CPU_USAGE" ]; then
        echo "$(date) - CPU Usage: $CPU_USAGE%"
        echo "$(date) - MEM Usage: $MEM_USAGE%"
    fi
    sleep $INTERVAL
done

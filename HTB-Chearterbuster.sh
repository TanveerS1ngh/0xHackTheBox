#!/bin/bash

# Check if the secret file exists, if not, prompt to create one
if [[ ! -f "secret" ]]; then
  echo "The API token file 'secret' is missing."
  echo "Please input your API token to create the 'secret' file."
  read -p "Enter your authorization Bearer token: " API_TOKEN

  # Create the secret file with the token
  echo "API_TOKEN='$API_TOKEN'" > secret
  echo "'secret' file created successfully with the provided token."
else
  # Load the API token from the secret file
  source secret
fi

# Function to refresh the API token if invalid
refresh_token() {
  echo "API token is invalid or expired. Please input a new token."
  read -p "Enter your new authorization Bearer token: " API_TOKEN
  echo "API_TOKEN='$API_TOKEN'" > secret
  echo "API token updated successfully."
}

# Check if the flag and ID are provided
if [[ -z "$1" || -z "$2" ]]; then
  echo "Usage: $0 
         -t <team_id>
         -p <user_id>
         By Divine Clown"
  exit 1
fi

FLAG="$1"
ID="$2"

# Function to calculate the max length of each column dynamically
calculate_max_lengths() {
  local response="$1"
  max_name_length=4
  max_date_diff_length=13
  max_type_length=4
  max_date_length=4
  max_time_length=4

  # Iterate through each line to find the longest string for each column
  while IFS=$'\t' read -r name date_diff type date time; do
    (( ${#name} > max_name_length )) && max_name_length=${#name}
    (( ${#date_diff} > max_date_diff_length )) && max_date_diff_length=${#date_diff}
    (( ${#type} > max_type_length )) && max_type_length=${#type}
    (( ${#date} > max_date_length )) && max_date_length=${#date}
    (( ${#time} > max_time_length )) && max_time_length=${#time}
  done < <(echo "$response" | jq -r '.[] | [.name, .date_diff, .type, (.date | split("T")[0]), (.date | split("T")[1] | split(".")[0])] | @tsv')
}

# Function to print the table header based on the calculated widths
print_header() {
  printf "%-${max_name_length}s %-${max_date_diff_length}s %-${max_type_length}s %-${max_date_length}s %-${max_time_length}s\n" "Name" "Date Difference" "Type" "Date" "Time"
  printf "%0.s-" $(seq 1 $(( max_name_length + max_date_diff_length + max_type_length + max_date_length + max_time_length + 10 )))
  echo
}

# Function to print each row dynamically formatted
print_row() {
  printf "%-${max_name_length}s %-${max_date_diff_length}s %-${max_type_length}s %-${max_date_length}s %-${max_time_length}s\n" "$1" "$2" "$3" "$4" "$5"
}

# Function to fetch and process data from either team or player API
fetch_activity() {
  local url="$1"
  local entity_type="$2"
  echo "Divine Clown is Fetching the activity of $entity_type: $ID"

  response=$(curl -s "$url" -H "authorization: Bearer $API_TOKEN" -H 'accept: application/json' -H 'user-agent: Mozilla/5.0')

  # Check if the token is invalid or expired
  if [[ "$response" == *"Invalid token"* || "$response" == *"Token expired"* ]]; then
    refresh_token
    response=$(curl -s "$url" -H "authorization: Bearer $API_TOKEN" -H 'accept: application/json' -H 'user-agent: Mozilla/5.0')
  fi

  if [[ -z "$response" ]]; then
    echo "No data received from the server for $entity_type."
    exit 1
  fi

  # Extract activity data based on whether it's for a team or player
  if [[ "$entity_type" == "team" ]]; then
    activities=$(echo "$response" | jq '.')
  else
    activities=$(echo "$response" | jq '.profile.activity')
  fi

  # Check if activities are empty
  [[ "$activities" == "[]" ]] && echo "No activity found for $entity_type." && exit 1

  # Calculate max lengths dynamically
  calculate_max_lengths "$activities"

  # Print header and rows
  print_header
  echo "$activities" | jq -r '.[] | select(.name != null and .date != null) | [.name, .date_diff, .type, (.date | split("T")[0]), (.date | split("T")[1] | split(".")[0])] | @tsv' | while IFS=$'\t' read -r name date_diff type date time; do
    print_row "$name" "$date_diff" "$type" "$date" "$time"
  done
}

# Main logic to differentiate between team and player based on the flag
case $FLAG in
  -t)
    fetch_activity "https://labs.hackthebox.com/api/v4/team/activity/$ID?n_past_days=90" "team"
    ;;
  -p)
    fetch_activity "https://labs.hackthebox.com/api/v4/user/profile/activity/$ID" "player"
    ;;
  *)
    echo "Invalid option. Use -t for team or -p for player."
    exit 1
    ;;
esac

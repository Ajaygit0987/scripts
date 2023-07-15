# Define the process name
process_name="strapi"

# Initialize the flag to track process status
process_running=false

while true; do
  # Check if the process is running
  if ps aux | grep -q "[${process_name:0:1}]${process_name:1}"; then
    if ! $process_running; then
      echo "Process $process_name is now running."
      process_running=true
    fi
  else
    if $process_running; then
      echo "Process $process_name is not running. Sending email."

      # Define the email details
      recipient="ajay24in7@gmail.com"
      subject="Process $process_name is not running"
      body="Process $process_name is not running. Please investigate."

      # Send the email using the 'mail' command (ensure the 'mailutils' package is installed)
      echo "$body" | mail -s "$subject" "$recipient"
      
      process_running=false
    fi
  fi

  # Sleep for 2 minutes
  sleep 120
done

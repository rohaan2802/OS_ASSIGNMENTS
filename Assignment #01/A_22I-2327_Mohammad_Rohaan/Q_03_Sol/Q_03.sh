#!/bin/bash

	# This sets a variable log_file_path to store the path of the log file.
	# $HOME refers to the user's home directory (/home/username).
	# app_usage.log is the file where application usage data will be logged.
	# Purpose: The script will write application usage data to this file.


log_file_path="$HOME/app_usage.log"


	# declare -A creates an associative array named app_usage.
	# Associative arrays allow you to store key-value pairs (app_name -> time_spent).
	# An associative array in Bash is like a dictionary or key-value pair storage in other programming languages.

	# Think of it Like a Contacts List:
	# You store names (keys) and their phone numbers (values).
	# Example:
	# "Alice" → "123-456"
	# "Bob" → "789-012"
	# How Associative Arrays Work in Bash
	# In a normal array, you use numbers as indexes:

	# my_array=(apple banana cherry)
	# echo "${my_array[1]}"  # Output: banana
	# In an associative array, you use custom names (keys):

	# declare -A app_usage  # Declare an associative array

	# app_usage["Chrome"]=120
	# app_usage["Firefox"]=90
	# app_usage["Terminal"]=45

	# echo "Time spent on Chrome: ${app_usage["Chrome"]} minutes"
	# Key Features
	# Stores data as key → value
	# Can use text as keys (not just numbers)
	# Good for tracking things (like app usage in your case)


declare -A app_usage  # Associative array to store usage time


	# Explanation of Each App:
	# chrome → Google Chrome (kept for web browsing tracking).
	# gnome-terminal → The default terminal in Ubuntu.
	# nautilus → The default file manager (called "Files" in Ubuntu).
	# gedit → The default text editor in Ubuntu.
	# evince → The default PDF reader in Ubuntu.

arr1=("chrome" "gnome-terminal" "nautilus" "gedit" "evince")


LIMIT=1  # Limit in minutes

	# Get the active window title
	# This runs the command inside $(), which means the output is stored in the variable ACTIVE_WIN.
	# Command Breakdown:
	# xdotool getwindowfocus → Finds the currently focused (active) window.
	# getwindowname → Retrieves the name (title) of that window.
	# 2>/dev/null → Redirects error messages (if any) to /dev/null, meaning they are ignored.

get_active_window_function() 
{
    active_var=$(xdotool getwindowfocus getwindowname 2>/dev/null)
    echo -e "\n\n\t$active_var"
}



	# Track application usage

	# Get the Active Window (Application)


	# active_app_var=$(get_active_window_function)
	# Calls the function get_active_window_function(), which retrieves the currently active window's name.
	# Stores the result in the variable active_app_var.
	# Example Output of get_active_window_function()

	# If the user is browsing in Google Chrome, then:
	# active_app_var="Google Chrome"
	# If they are coding in VS Code, then:

	# active_app_var="Visual Studio Code"



	# Check if the Application is Not Empty

	# if [[ ! -z "$active_app_var" ]]; then
	# Ensures that active_app_var is not empty before processing.
	# ! -z means "if not empty".
	
	# Increment Usage Time

	# app_usage["$active_app_var"]=$(( ${app_usage["$active_app_var"]} + 10 ))  # Increment by 10 sec
	# app_usage is an associative array (declare -A app_usage was declared earlier).
	# It stores the time spent on each application.
	# This line adds 10 seconds to the existing time for the active application.


	# Example Scenario

	# If the user starts Chrome for the first time:

	# app_usage["Google Chrome"] = 10  # (Initial time)
	# After 60 seconds (6 cycles of 10 sec each):

	# app_usage["Google Chrome"] = 60
	# After 1 hour (3600 sec):

	# app_usage["Google Chrome"] = 3600



	# Log the Usage

	# echo "$(date '+%H:%M:%S') - $active_app_var" >> "$log_file_path"
	# Appends the current timestamp and active application name to a log file.
	# Example Log (~/app_usage.log)

	# 10:00:10 - Google Chrome
	# 10:00:20 - Google Chrome
	# 10:00:30 - Google Chrome

	# Helps in tracking which app was used at what time.


	# Check if the Application is Non-Productive

	# for i in "${arr1[@]}"; do
	# Loops through the non-productive apps list stored in arr1.
	# Example Non-Productive Apps List (arr1):


	# arr1=("chrome" "firefox" "discord" "spotify" "steam")
	# These apps are considered non-productive.

	# if [[ "$active_app_var" == *"$i"* ]]; then
	# Checks if the active application contains the name of any non-productive app.




	# Check If the App Exceeds the Time Limit

	# if [[ ${app_usage["$active_app_var"]} -ge $((LIMIT * 60)) ]]; then
	# LIMIT=60 (which means 60 minutes).
	# LIMIT * 60 converts it to seconds (3600 sec).
	# This condition checks if the user has exceeded 3600 sec on the app.
	
	# Send Warning Notification

	# notify-send "Warning: Too much time on $active_app_var!"
	# Sends a desktop notification warning the user that they have spent too much time on the app.
	# Example Popup Notification:

	# [Warning] Too much time on Google Chrome!

	# 9. Kill the Non-Productive Application

	# pkill "$i"  # Kill the app if exceeds limit
	# Closes the application if the time limit is exceeded.
	# Example:

	# If the user spends more than 1 hour on Chrome, this command will forcefully close it.
	# The app is killed using pkill, which finds and stops the process.


track_usage_function() 
{
    active_app_var=$(get_active_window_function)

    if [[ ! -z "$active_app_var" ]]; then
        app_usage["$active_app_var"]=$(( ${app_usage["$active_app_var"]} + 10 ))  # Increment by 10 sec
        echo "$(date '+%H:%M:%S') - $active_app_var" >> "$log_file_path"

        # Check if non-productive apps exceed limit
        for i in "${arr1[@]}"; do
            if [[ "$active_app_var" == *"$i"* ]]; then
                if [[ ${app_usage["$active_app_var"]} -ge $((LIMIT * 60)) ]]; then
                    notify-send "Warning: Too much time on $active_app_var!"
                    pkill "$i"  # Kill the app if exceeds limit
                fi
            fi
        done   # Missing 'done' fixed here
    fi
}



	# Loop Through All Applications

	# for i in "${!app_usage[@]}"; do
	# This iterates through all the applications stored in the app_usage associative array.
	# !app_usage[@] gives all the keys (application names) in the array.
	# Print Each Application's Usage

	# echo "$i: $(( ${app_usage[$i]} / 60 )) minutes $((${app_usage[$i]} % 60)) seconds"
	# Breaks down total seconds into minutes and seconds:
	# ${app_usage[$i]} / 60 → Converts total seconds into minutes.
	# ${app_usage[$i]} % 60 → Gets the remaining seconds.
	# Example Output:

	# Google Chrome: 2 minutes 35 seconds
	# VS Code: 1 minutes 20 seconds
	# Terminal: 45 seconds


# Generate report every 10 sec
generate_report_function()
{
    clear
    printf "\n\n\t\t\t\tAPPLICATION USAGE REPORT (EVERY 10 SEC)\n"
    printf "\n\n\t\t\t\t-----------------------------------\n"
    for i in "${!app_usage[@]}"; do
        printf "%-80s %2d MINUTES %2d SECONDS\n" "$i:" $(( ${app_usage[$i]} / 60 )) $((${app_usage[$i]} % 60))
    done
    printf "\n\n\t\t\t\t-----------------------------------\n"

}



# Run tracking every 10 sec
while true; do
    track_usage_function
    generate_report_function
    sleep 10
done


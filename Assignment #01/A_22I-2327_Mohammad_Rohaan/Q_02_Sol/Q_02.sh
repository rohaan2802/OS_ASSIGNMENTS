#!/bin/bash


	# This declares a variable text_file_name and assigns it the value "text_file.txt".
	# It means that all log messages will be written to a file named text_file.txt.
	# If text_file.txt doesn’t exist, it will be created automatically when the script runs.

text_file_name="text_file.txt"


	# log() - Function Definition
	# This defines a function called log.
	# Functions in Bash allow you to reuse code without repeating it.
	# The function log takes one argument ($1), which is the message to be logged.

	# 2. echo "$1" - Print Message
	# echo "$1" prints the first argument ($1) that is passed to the function.
	# Example: If we call log "Script started", it will print:
	# Script started

	# 3. | (Pipe) - Sending Output to Another Command
	# The pipe (|) takes the output of echo "$1" and sends it to the next command (tee).

	# 4. tee -a "$text_file_name" - Append Output to Log File
	# tee is a Linux command that allows output to be displayed on the terminal and written to a file at the same time.
	# -a (append mode) ensures that new messages are added to the file without overwriting existing content.
	# "$text_file_name" specifies that the output should be written to "text_file.txt".
	# Example: If we call log "Script started", the log file will contain:
	# Script started

helper_function() 
{
    echo -e "\t\t\t$1" | tee -a "$text_file_name"
}


	# This Bash function prompts the user for a filename, displays its current permissions, modifies them, and logs the 
	# changes.





# Checking If the File Exists

# if [ -e "$file_name_var" ]; then

# -e "$file_name_var" → Checks if the file exists.

# The if statement ensures the rest of the function only runs if the file exists.

# Displaying Current Permissions

# echo -e "\n\n\t\t\t\tCURRENT PERMISSIONS --->     \c"
# ls -l "$file_name_var" | awk '{print $1}'
# ls -l "$file_name_var" → Lists file details in long format.
# Example output:

# -rw-r--r-- 1 user user 1234 Mar 12 12:34 file.txt
# awk '{print $1}' → Extracts only the first column, which contains the permission string (e.g., -rw-r--r--).
# This prints the current permissions of the file.
# Storing Permissions in a Variable

# permissions_var=$(ls -l "$file_name_var" | awk '{print $1}')
# $(...) → Command substitution, captures the output of the ls -l command.

# permissions_var now holds the permission string (e.g., -rw-r--r--).
# Extracting User, Group, and Other Permissions

# user_var=${permissions_var:1:3}
# group_var=${permissions_var:4:3}
# other_var=${permissions_var:7:3}
# ${permissions_var:1:3} → Extracts characters 1-3 (User permissions: rw-).
# ${permissions_var:4:3} → Extracts characters 4-6 (Group permissions: r--).
# ${permissions_var:7:3} → Extracts characters 7-9 (Other permissions: r--).
# Now, user_var="rw-", group_var="r--", and other_var="r--".

# Displaying Extracted Permissions

# echo -e "\n\n\t\t\t\tCURRENT USER: $user_var, GROUP: $group_var, OTHERS: $other_var"
# This prints the extracted permissions for User, Group, and Others.
# Function to Modify Permissions

# permissions_function() 
# {
#     case "$1" in
#        "rwx") echo "=" ;;
#        "rw-") echo "x" ;;
#        "r-x") echo "w" ;;
#        "r--") echo "wx" ;;
#        "-wx") echo "r" ;;
#        "-w-") echo "rx" ;;
#        "--x") echo "rw" ;;
#        "---") echo "rwx" ;;
#    esac
# }

# What This Does
# This function takes a permission string (e.g., rw-) and converts it into a new permission.
# It uses a case statement to map existing permissions to new ones:
# "rw-" → Changes to "x"
# "r-x" → Changes to "w"
# "r--" → Changes to "wx"
# etc.


# How It Works
# When called as permissions_function "$user_var", it returns the new permissions for that category.
# Modifying Permissions Using the Function

# new_user_var=$(permissions_function "$user_var")
# new_group_var=$(permissions_function "$group_var")
# new_other_var=$(permissions_function "$other_var")
# Calls permissions_function() for each permission group.
# Stores the new permissions in variables (new_user_var, new_group_var, new_other_var).

# Changing File Permissions

# chmod u="$new_user_var",g="$new_group_var",o="$new_other_var" "$file_name_var"
# chmod changes file permissions:
# u="$new_user_var" → Sets new user permissions.
# g="$new_group_var" → Sets new group permissions.
# o="$new_other_var" → Sets new others' permissions.
# This modifies the file's permission settings.
# Displaying Updated Permissions

# echo -e "\n\n\t\t\t\tUPDATED PERMISSIONS ---->    \c"
# ls -l "$file_name_var" | awk '{print $1}'
# Same as before, but now shows updated permissions after chmod.
# Calling Another Function (helper_function)

# helper_function "User=$new_user_var, Group=$new_group_var, Others=$new_other_var."
# Calls a separate function named helper_function.
# Passes a message showing the new permissions.
# The purpose of helper_function is unknown (it’s not defined in this script).
# Handling the Case Where the File Doesn't Exist

# else
#     echo -e "\n\n\t\t\t\tFILE DOES NOT EXIST."
# fi

# If the file does not exist, prints an error message.
# Complete Flow of the Script

# Asks the user for a filename.
# Checks if the file exists:
# If yes, gets current permissions.
# If no, prints an error and exits.
# Extracts user, group, and other permissions.

# Uses permissions_function() to determine new permissions.
# Changes file permissions using chmod.
# Displays the new permissions.
# Example Run
# Before Running the Script


# $ ls -l test.txt

# -rw-r--r-- 1 user user 1234 Mar 12 12:34 test.txt

# User Input

# ENTER THE FILENAME: test.txt
# Script Output (Before Changing Permissions)

# CURRENT PERMISSIONS ---> -rw-r--r--
# CURRENT USER: rw-, GROUP: r--, OTHERS: r--
# Permissions Mapped (Using permissions_function)

# New User: x
# New Group: wx
# New Others: wx
# After chmod

# $ ls -l test.txt
# --x-wx-wx 1 user user 1234 Mar 12 12:34 test.txt
# Summary
# 🔹 Extracts file permissions from ls -l.
# 🔹 Maps permissions to new values using permissions_function().
# 🔹 Modifies file permissions using chmod.
# 🔹 Displays old and new permissions.


display_permissions_function() 
{
    echo -e "\n\n\t\t\t\tENTER THE FILENAME:    \c"
            read file_name_var

            if [ -e "$file_name_var" ]; then
                echo -e "\n\n\t\t\t\tCURRENT PERMISSIONS --->     \c"
                ls -l "$file_name_var" | awk '{print $1}'
                permissions_var=$(ls -l "$file_name_var" | awk '{print $1}')  

                # Extract user, group, and other permissions separately
                user_var=${permissions_var:1:3}
                group_var=${permissions_var:4:3}
                other_var=${permissions_var:7:3}

                echo -e "\n\n\t\t\t\tCURRENT USER: $user_var, GROUP: $group_var, OTHERS: $other_var"


                permissions_function() 
                {
                    case "$1" in
                        "rwx") echo "=" ;;
                        "rw-") echo "x" ;;
                        "r-x") echo "w" ;;
                        "r--") echo "wx" ;;
                        "-wx") echo "r" ;;
                        "-w-") echo "rx" ;;
                        "--x") echo "rw" ;;
                        "---") echo "rwx" ;;
                    esac
                }

                new_user_var=$(permissions_function "$user_var")
                new_group_var=$(permissions_function "$group_var")
                new_other_var=$(permissions_function "$other_var")

                chmod u="$new_user_var",g="$new_group_var",o="$new_other_var" "$file_name_var"

                echo -e "\n\n\t\t\t\tUPDATED PERMISSIONS ---->    \c"
                ls -l "$file_name_var" | awk '{print $1}'

	helper_function "User=$new_user_var, Group=$new_group_var, Others=$new_other_var."

            else
                echo -e "\n\n\t\t\t\tFILE DOES NOT EXIST."
            fi
            
}




search_string_function() 
{
    echo -e "\n\n\t\t\t\tENTER THE FILENAME :    \c"
    read file_name
    echo -e "\n\n\t\t\t\tENTER STRING TO SEARCH: \c"
    read search_str

	# Checking if the File Exists
	# -e "$file_name" checks whether the file exists.
	# If the file exists, the script proceeds to the search operation.
	# If the file does not exist, the script prints File not found..    
    
    if [ -e "$file_name" ]; then
        helper_function "OPTION 02 SELECTED AT $(date)"
        helper_function "FILE_NAME: $file_name"
        helper_function "STRING: $search_str"

# Searching for the String
# grep is used for searching a pattern in a file.
# -E enables extended regular expressions (ERE), which allow advanced search patterns.
# "${search_str//./.}" replaces every . (dot) in the input string with a . literal.
# This ensures that if the user enters a dot (.), it is treated as a dot instead of a wildcard.


# Example:
# If search_str="hello.world", grep normally treats . as a wildcard (matches any character).
# This replacement makes it behave literally, so it will match hello.world and not helloworld or helloXworld.
# Understanding tee -a "$text_file_name"
# | (Pipe operator) passes the output of grep to tee.
# tee -a "$text_file_name":
# tee allows output to be displayed on the terminal and written to a log file simultaneously.
# -a (append mode) ensures the log file is not overwritten but appended with new search results.
# $text_file_name is assumed to be a variable storing the log file's name.


     # grep -E "${search_str//./.}" "$file_name" | tee -a "$text_file_name"
    grep -E "${search_str//./.}" "$file_name" | sed 's/^/\n\n\t\t\t OUTPUT RESULT --->  /' | tee -a "$text_file_name"

    else
        echo -e "\n\n\t\t\t\tERROR: FILE NOT FOUND\n\n"
    fi
}


copy_content_function() {
    echo -e "\n\n\t\t\t\tENTER VALUE OF N:    \c"
    read N
    helper_function "OPTION 03 SELECTED AT $(date)"

    # Get all files in the current directory
    # Explanation:
	# ls -p → Lists all files (with / for directories).
	# grep -v / → Removes directories.
	# grep -v '\.sh$' → Removes any .sh files.
	# Initializes two empty arrays:
	# even_files_var → Stores files at even indexes.
	# odd_files_var → Stores files at odd indexes.

    files_var=($(ls -p | grep -v / | grep -v '\.sh$'))
    even_files_var=()
    odd_files_var=()

    # Separate files into even and odd indexed lists
    
    # Loops through all files using for ((i=0; i<${#files_var[@]}; i++))
    # i goes from 0 to total number of files - 1.
	
	# ${#files_var[@]} → Number of files in files_var.
	# Odd-indexed files go to odd_files_var, and even-indexed files go to even_files_var.
	# Why i+1 Instead of i?

	# Since arrays in Bash start at index 0, the "first file" is at index 0, which is even.
	# By using i+1, we align with human-readable numbering.

    
    for ((i=0; i<${#files_var[@]}; i++)); do
        if (( (i+1) % 2 == 0 )); then
            even_files_var+=("${files_var[$i]}")
        else
            odd_files_var+=("${files_var[$i]}")
        fi
    done

    echo -e "\n\n\t\t\t\tFILES AT ODD LOCATIONS: ${odd_files_var[*]}"
    echo -e "\n\n\t\t\t\tFILES AT EVEN LOCATIONS: ${even_files_var[*]}"

    helper_function "FILES AT ODD LOCATIONS: ${odd_files_var[*]}"
    helper_function "FILES AT EVEN LOCATIONS: ${even_files_var[*]}"

	# > dummy_file.txt creates an empty file (or clears it if it already exists).
	# Create (or Clear) dummy_file.txt
	
    echo -e "\n\n\t\t\tCREATING dummy_file.txt ........ !"
    > dummy_file.txt  # Create or clear the dummy file

    # Copy first N lines from even-positioned files
    
	# Copy Content from Files
	# Copy First N Lines from Even-Indexed Files

	# head -n "$N" "$file" → Extracts the first N lines from each file in even_files_var.
	# >> dummy_file.txt → Appends the extracted lines to dummy_file.txt.
	# 2>/dev/null → Hides error messages if a file has fewer than N lines.
	    
    for file in "${even_files_var[@]}"; do
        head -n "$N" "$file" >> dummy_file.txt 2>/dev/null
    done



    # Copy last N lines from odd-positioned files

	# Copy Last N Lines from Odd-Indexed Files
	# tail -n "$N" "$file" → Extracts the last N lines from each file in odd_files_var.
	# >> dummy_file.txt → Appends them to dummy_file.txt.
	# 2>/dev/null → Hides errors if a file has fewer than N lines.


    for file in "${odd_files_var[@]}"; do
        tail -n "$N" "$file" >> dummy_file.txt 2>/dev/null
    done


    helper_function "dummy_file.txt IS CREATED AND $N LINES OF EACH FILE COPIED IN IT."
    echo -e "\n\n\n\t\t\t\t\c"
    cat dummy_file.txt

}




check_modified_date_function() 
{
    echo -e "\n\n\t\t\t\tENTER THE FILENAME :      \c"
    read file_name
    echo -e "\n\n\n"
    
    # Checking if the File Exists
    # [ -e "$file_name" ]: Checks if the file exists.
    # If the file exists, the script proceeds; otherwise, it prints "FILE NOT FOUND.".


    if [ -e "$file_name" ]; then
        helper_function "OPTION 04 SELECTED AT $(date)"
        helper_function "FILENAME: $file_name"

	# Getting the File's Modification Time
	# stat -c %Y "$file_name":
	# Retrieves the last modified time of the file in epoch format (seconds since 1970).
	# Stores it in var1.


        var1=$(stat -c %Y "$file_name")
        
        # Getting the Current Time
        # date +%s:
	# Gets the current time in epoch format (total seconds since 1970).
	# Stores it in var2.
        
        var2=$(date +%s)
        
        # Calculating the Time Difference
        # Subtracts the file's last modified time from the current time (result in seconds).
	# Dividing by 3600:
	# Converts seconds into hours.
	# stores result in var3

        var3=$(( (var2 - var1) / 3600 ))

	# date -d "@$mod_time":
	# Converts mod_time (epoch time) into a human-readable date.


        helper_function "CURRENT MODIFIED DATE: $(date -d @$var1)"
        
        #  Checking if the File is Older Than 24 Hours
        #  If var3 > 24, the script updates the modification time.

        # Updating the File Modification Time (if needed)
        # touch "$file_name":
	# Updates the file's modification time to the current time without changing its content.

        if [ "$var3" -gt 24 ]; then
            touch "$file_name"
	  helper_function "MODIFIED TIME UPDATED TO: $(date)"
        else
            helper_function "MODIFIED TIME NOT UPDATED"
        fi
    else
        echo -e "\n\n\t\t\t\tFILE NOT FOUND."
    fi
}



while true; do
    echo -e "\n\n\n            SOLUTION OF PROBLEM# 02 => TASK PERFORMING BASED ON USER CHOICE\n\n\n"
    echo -e "\t\t\t\tSELECT AN OPTION FROM THE GIVEN BELOW \n\n" 
    echo -e "\t\t\t\t 1. MODIFY THE FILE PERMISSIONS \n"
    echo -e "\t\t\t\t 2. SEARCH STRING FROM THE FILES\n"
    echo -e "\t\t\t\t 3. COPY CONTENT OF THE FILES\n"
    echo -e "\t\t\t\t 4. MODIFY DATE OF THE FILE\n"
    echo -e "\t\t\t\t 5. EXIT\n\n"
    echo -e "\t\t\t\tENTER YOUR CHOICE HERE :   \c"
    read choice 
    case "$choice" in
        1) display_permissions_function ;;
        2) search_string_function ;;
        3) copy_content_function ;;
        4) check_modified_date_function ;;
        5) echo -e "\t\t\t\t\n\nSCRIPT TERMINATED AT $(date)\n\n"; exit 0 ;;
        *) echo "\n\n\t\t\t\tINVALID OPTION. TRY AGAIN.\n" ;;
    esac
done




# =================================================================================================================================

	# Test Cases for display_permissions_function
	# Scenario 1: File Exists
	# Steps: --> Create a sample file:
	# echo "Hello, this is a test file" > testfile.txt
	# chmod 644 testfile.txt  # Set initial permissions to -rw-r--r--
	# Run the function and enter testfile.txt when prompted:
	# --> display_permissions_function

	# Expected output (before and after modification):
	# ENTER THE FILENAME : testfile.txt

	# OPTION 01 SELECTED AT Tue Mar 4 12:00:00 PST 2025
	# FILE NAME: testfile.txt
	# PERMISSIONS OF testfile.txt: -rw-r--r--
	# PERMISSIONS HAVE MODIFIED SUCCESSFULLY


	# MODIFIED PERMISSIONS OF testfile.txt: --w-------
	# Verify new permissions using:
	# ls -l testfile.txt
	# Expected:

	# --w------- 1 user user 30 Mar 4 12:00 testfile.txt

	# File Permissions Explained
	# When you execute chmod 644 testfile.txt, it sets the file permissions to -rw-r--r--. Let's break down what this means.

	# 1. Understanding the Permission String:
	# The permission string consists of 10 characters:

	# -rw-r--r--
	# Each section represents different aspects of file permissions.

	# Position	Symbol		Meaning
	# 1st		  -		File type (- for a regular file, d for a directory, l for a symbolic link)
	# 2-4		 rw-		Owner permissions: Read (r), Write (w), No Execute (-)
	# 5-7		 r--		Group permissions: Read (r), No Write (-), No Execute (-)
	# 8-10		 r--		Others' permissions: Read (r), No Write (-), No Execute (-)

	# 2. Breakdown of Permission Levels:
	# Owner (rw-):

	# The file owner has read (r) and write (w) permissions.
	# The owner cannot execute (x) the file.
	# Group (r--):

	# Users who belong to the file's group have read (r) permission.
	# They cannot write (w) or execute (x) the file.
	# Others (r--):

	# Everyone else (other users) has read (r) permission.
	# They cannot write (w) or execute (x) the file.
	# 3. Numeric (Octal) Representation:
	# Each permission type corresponds to a numerical value:
	 
	# Read (r) = 4
	# Write (w) = 2
	# Execute (x) = 1
	#No permission (-) = 0
	# Using these values, 644 breaks down as:

	# 6 (Owner: rw-) = 4 + 2  
	# 4 (Group: r--) = 4  
	# 4 (Others: r--) = 4  
	# So, chmod 644 sets:

	# Owner: Read (4) + Write (2) = 6 (rw-)
	# Group: Read (4) = 4 (r--)
	# Others: Read (4) = 4 (r--)

	# 4. Effect of These Permissions
	# Only the owner can modify (write) the file.
	# The group and others can only read the file but cannot modify or execute it.
	# This setting is commonly used for text files to prevent accidental modification by other users.

# =================================================================================================================================


	# Scenario 2: File Does Not Exist
	# Steps: --> Run the function with a non-existent file:

	# display_permissions_function
	# Enter any filename that doesn’t exist, e.g., nofile.txt
	# Expected output:
	# ENTER THE FILENAME : nofile.txt
	# ERROR: FILE NOT FOUND

	# Test Cases for search_string_function
	# Scenario 1: File Exists and String is Found
	# Steps: --> Create a test file:

	# echo -e "Hello World\nThis is a test file\nSearch this line" > testfile.txt
	# Run the function and enter testfile.txt and a search string:

	# search_string_function
	# Input:

	# ENTER THE FILENAME : testfile.txt
	# ENTER STRING TO SEARCH: test

	# Expected output:

	# OPTION 02 SELECTED AT Tue Mar 4 12:05:00 PST 2025
	# FILE_NAME: testfile.txt
	# STRING: test

	# This is a test file
	# Scenario 2: File Exists but String is Not Found
	# Steps:  Use the same file (testfile.txt).
	# Run the function with a non-matching string:

	# search_string_function
	# Input:

	# ENTER THE FILENAME : testfile.txt
	# ENTER STRING TO SEARCH: xyz
	# Expected output:

	# OPTION 02 SELECTED AT Tue Mar 4 12:06:00 PST 2025
	# FILE_NAME: testfile.txt
	# STRING: xyz
	# (No matching line should be displayed.)
	# Scenario 3: File Does Not Exist
	# Steps: ---> Run the function with a non-existent file:

	# search_string_function Input:

	# ENTER THE FILENAME : nofile.txt
	# ENTER STRING TO SEARCH: test

	# Expected output:
	# File not found.
# =================================================================================================================================


	# echo -e "A1\nA2\nA3\nA4\nA5" > file1.txt
	# echo -e "B1\nB2\nB3\nB4\nB5" > file2.txt
	# echo -e "C1\nC2\nC3\nC4\nC5" > file3.txt
	# echo -e "D1\nD2\nD3\nD4\nD5" > file4.txt
	# echo -e "E1\nE2\nE3\nE4\nE5" > file5.txt




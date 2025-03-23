#!/bin/bash 
# Shebang line or bashbang line

data_file="expenses.csv" # Stores the filename where transactions will be recorded.
budget=100000  # Budget limit 

touch $data_file # Creates the file if it doesn't already exist.

# Function to add data to file
add_expenses_tofile_function() 
{
    echo -n "	    ENTER THE AMOUNT:     "
    read amount_var

    echo -e "\n"
    
    echo -n "	    ENTER CATEGORY LIKE ( FOOD , BILLS , SHOPPING , OTHER ):     "
    read category_var
    
    echo -e "\n"
        
    echo -n "	    ENTER THE DATE IN FORMAT (YYYY-MM-DD):     "
    read date_var
    
    echo -e "\n"
    
    echo    "            $date_var,$category_var,$amount_var" >> $data_file # Write Data To File
    
    echo -e "\n"
    
    echo    "	    TRANSACTION RECORDED SUCESSFULY ........ !\n\n" 
    sleep 3
}


# Function to generate spending summary
summary_of_spending_function()
{
# Uses awk to sum amounts per category ($2) and prints total spending.

    echo -e "\n\n		SUMMARY OF SPENDING HABITS:\n\n                 "
    awk -F ',' '{arr[$2]+=$3} END {for (i in arr) printf "%30s = %s\n", i, arr[i]}' "$data_file"

    
    # awk sums all transactions ($3 is the amount column).
    
    # awk -F ',': Processes the file by treating , as the delimiter.
    # {arr[$2]+=$3}:
    # $2 represents the category (e.g., "FOOD", "BILLS", etc.).
    # $3 represents the amount spent.
    # This command sums up all expenses for each category.
    # END {for (i in arr) printf "%30s = %s\n", i, arr[i]}:
    # After processing all lines, it prints the category name (right-aligned in a 30-character space) along with the total 
    # spending 
    # for that category.
    
    
    # ================================================================================= #
    
    # awk -F',' '{sum+=$3} END {print sum}':
    # Extracts the third column ($3, which contains the expense amount).
    # Sums all the values in the column.
    # Prints the total expense amount.
    # total_expenses=$( ... ):
    # Stores the total amount spent in the variable total_expenses.
    
    # ================================================================================= #
        
        
    total_expenses=$(awk -F',' '{sum+=$3} END {print sum}' $data_file)
    
    # total_income is not defined in the script (potential issue).
    # Subtracts total_expenses from total_income to calculate savings.
    
    savings=$((total_income - total_expenses))
    
    # Displays the total expenses and savings.

    echo -e "\n\n		TOTAL EXPENSES  => $total_expenses"
    echo -e "\n\n		MONTHLY SAVINGS => $savings"
    
    # Checks if expenses exceed budget and issues a warning.
    
    # Compares total_expenses with budget:
    # If total_expenses is greater than budget, it prints a warning message.
    # The script then pauses for 3 seconds (sleep 3) before continuing.
    
    if [ "$total_expenses" -gt "$budget" ]; then
        echo -e "\n\n 	ALERT: BUDGET LIMIT EXCEEDED ..... ! \n\n"
            sleep 3
    fi

}


# Function to export data to CSV
export_datato_csv_function()
 {
    echo -e "\n\n		EXPORTING DATA TO Expenes.csv ....... !\n\n"
    sleep 3
  #  column -t -s ',' "$data_file" | sed 's/^/            /' | tee expenses.csv 
  
  
     # cat $data_file:
     # Reads and displays the contents of the file (expenses.csv).
     # This allows the user to see what data has been recorded before it is "exported."
     # However, this does not actually export the data anywhere new—it just prints it.
  
  
    cat $data_file
    echo -e "\n\n		EXPORT COMPLETED SUCCESSFULLY .......\n\n"
    sleep 2
}



# Function to visualize spending trend
visualize_spending_trend_function() 
{
    echo -e "\n\n		GENERATING SPENDING TREND GRAPH ......... ! \n\n"
	sleep 2
    
    
     # Check if gnuplot is installed
     
	# command -v → This is used to check if a command exists in the system.
	# gnuplot → This is the name of the command we are checking for.
	# If gnuplot is installed, command -v gnuplot returns the path to the executable (e.g., /usr/bin/gnuplot).
	# If gnuplot is not installed, the command returns nothing (an empty output).

	# &> → Redirects both stdout and stderr (standard output and error messages).
	# /dev/null → A special file that discards any output.
	# This ensures that if gnuplot is missing, no error message is displayed in the terminal.
	# Purpose:
	# If gnuplot is installed, the command returns silently without displaying anything.
	# If gnuplot is not installed, the error message is suppressed.


	# if ! → The ! negates the condition.
	# This means:
	# If gnuplot exists, the condition evaluates to false, and the script continues normally.
	# If gnuplot does not exist, the condition evaluates to true, and the script executes the error message.

     
    if ! command -v gnuplot &> /dev/null; then
        echo -e "\n\n\n\t\t\t\tERROR: GNUPLOT IS NOT INSTALLED.......!\n\n\n"
        sleep 2
        return
    fi
    
    # Ensure expenses.dat is properly formatted and sorted
    
    # This extracts, processes, and prepares the data for visualization in GNUplot.
    # Breakdown of the awk Command:

    # -F',' → Uses a comma , as the field separator.
    # NF==3 → Ensures that only rows with exactly 3 fields (date, category, amount) are processed.
    # $2!="Income" → Excludes income transactions; only expenses are considered.
    # $3 ~ /^[0-9]+$/ → Ensures the third column (amount) contains only numbers (ignoring invalid entries).
    # arr[$1]+=$3 → Aggregates spending by date ($1 refers to the date field).
    # END {for (i in arr) print i, arr[i]} → At the end, prints each date and the total spending for that date.
    # | sort → Sorts the data by date.
    # > expenses.dat → Saves the processed data into expenses.dat for plotting.
    
    awk -F',' 'NF==3 && $2!="Income" && $3 ~ /^[0-9]+$/ {arr[$1]+=$3} END {for (i in arr) print i, arr[i]}' "$data_file" | sort > expenses.dat

    # ransforms CSV into expenses.dat for plotting:
    # Uses awk to sum expenses by date ($1).
    # Ignores any incorrect entries (NF==3 ensures valid rows).

    # Verify if the file has valid data
    
    # -s expenses.dat → Checks if expenses.dat exists and is not empty.
    # If the file is empty:
    # Prints "NO VALID EXPENSE DATA TO PLOT".
    # Waits for 2 seconds.
    # Exits the function early using return.
    # Why?
    # If there is no data, there’s no point in proceeding to graph plotting.


    
    if [ ! -s expenses.dat ]; then
        echo -e "\n\n	       NO VALID EXPENSE DATA TO PLOT ..... !\n\n"
        sleep 2
        return
    fi



	#What This Does?
	#This block sends commands to GNUplot to generate a line graph of expenses over time.

	#GNUplot Commands Explained
	#set title "Spending Trend Over Time"
	#→ Sets the title of the graph.
	#set xlabel "Date"
	#→ Labels the x-axis as "Date".
	#set ylabel "Amount Spent"
	#→ Labels the y-axis as "Amount Spent".
	#set xdata time
	#→ Specifies that the x-axis contains time-based data (dates).
	#set timefmt "%Y-%m-%d"
	#→ Tells GNUplot to interpret dates in YYYY-MM-DD format.
	#set format x "%Y-%m-%d"
	#→ Ensures that the x-axis displays dates properly.
	#set xtics rotate
	#→ Rotates the x-axis labels for better readability.
	#set grid
	#→ Adds grid lines for better visualization.
	#plot "expenses.dat" using 1:2 with linespoints title "Expenses" lw 2 pt 7 ps 1.5
	#→ Plots the data from expenses.dat:
	#using 1:2 → Uses column 1 (date) for the x-axis and column 2 (amount spent) for the y-axis.
	#with linespoints → Displays both lines and points on the graph.
	#title "Expenses" → Labels the plot as "Expenses".
	#lw 2 → Sets line width to 2.
	#pt 7 → Uses point type 7 (filled circles).
	#ps 1.5 → Sets point size to 1.5.
	#pause 5
	#→ Keeps the graph open for 5 seconds before closing.
	#exit
	#→ Ensures GNUplot exits properly.



    # Plot using gnuplot
  gnuplot <<-EOFMarker
        set title "Spending Trend Over Time"
        set xlabel "Date"
        set ylabel "Amount Spent"
        set xdata time
        set timefmt "%Y-%m-%d"
        set format x "%Y-%m-%d"
        set xtics rotate
        set grid
        plot "expenses.dat" using 1:2 with linespoints title "Expenses" lw 2 pt 7 ps 1.5
        pause 5
        exit
EOFMarker
}

set_budget_function() 
{
    read -p "
    		ENTER YOUR NEW BUDGET : " new_budget
    		
    		
	# Checks if the input is a valid numeric value.
	# [[ "$new_budget" =~ ^[0-9]+$ ]] → Uses regex (^[0-9]+$) to ensure that new_budget contains only digits (no letters, 
	#spaces, or special characters).
	# If the condition is true (i.e., the input is a valid number), the budget is updated.
    		
    		
    if [[ "$new_budget" =~ ^[0-9]+$ ]]; then
        budget=$new_budget
        echo -e "\n\n	NEW BUDGET SET TO $budget.\n\n"
    else
        echo "\n\n  INVALID INPUT. PLEASE RE-ENTER A NUMERIC VALUE .... !\n\n"
        sleep 2
    fi
}



while true; do
    echo -e "\n\n\n           SOLUTION OF PROBLEM# 05 => DAILY EXPENSES & INCOME\n\n\n"
    echo -e "           1. ENTER THE EXPENSES (CATEGORY , AMOUNT , DATE)\n"
    echo -e "           2. SUMMARY OF SPENDING HABITS\n"
    echo -e "           3. EXPORT DATA TO CSV\n"
    echo -e "           4. BONUS ACTIVITY VISUALIZE SPENDING TREND\n"
    echo -e "           5. SET BUDGET\n"
    echo -e "           6. EXIT\n"
    
    read -p "           CHOOSE ONE OF THE GIVEN ABOVE OPTIONS : " choice
    echo -e "\n\n"

    case $choice in
        1) add_expenses_tofile_function ;;
        2) summary_of_spending_function ;;
        3) export_datato_csv_function ;;
        4) visualize_spending_trend_function ;;
        5) set_budget_function ;;
        6) exit 0 ;;
        *) echo -e "\n\n           INVALID OPTION. PLEASE TRY AGAIN ...... !\n\n" ;;
    esac
done


# ===============================================================================================================================
# ===============================================================================================================================
# ===============================================================================================================================
# ===============================================================================================================================
# ===============================================================================================================================
# ===============================================================================================================================

# What Does halt Do in Linux?
# halt is a system command used to stop all system processes and shut down the computer. It is typically used by system 
# administrators to turn off a machine safely.

# How halt Works
# Stops All Processes – The system first stops all running processes.
# Unmounts File Systems – It safely unmounts all storage drives.

# Shuts Down the System – Finally, it powers off or puts the system in a halted state.
# Difference Between halt, poweroff, and shutdown

# Command	What It Does	When to Use
# halt	Stops the system but may not power off (depends on OS)	When you want to stop everything but not necessarily turn 
# off  power

# poweroff	Stops the system and powers off the machine	When you want to completely turn off the system
# shutdown	Schedules or immediately shuts down the system	When you want to shut down gracefully after a delay
# Examples

# 1️⃣ Immediately halt the system:


# sudo halt
# (Stops everything but may not power off on some systems.)

# 2️⃣ Halt and power off:


# sudo halt -p
# (Equivalent to poweroff.)

# 3️⃣ Shutdown in 5 minutes:


# sudo shutdown -h +5
# (-h means halt; +5 means wait 5 minutes.)

# When Should You Use halt?
# ✔️ If you only want to stop the system (e.g., for maintenance).
# ✔️ If you don’t want to power off the machine immediately.
# ❌ Avoid using halt abruptly—it may not properly save data before stopping the system.

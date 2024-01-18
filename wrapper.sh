#!/bin/bash
RED='\033[0;31m' # Color Red
NC='\033[0m' # No Color

# Infinite loop to keep the menu running
while true; do
    # Print the menu
    echo
    echo "================================================"
    echo "1. Batch Generate Manuals"
    echo "2. Generate Manual for a Specific Command"
    echo "3. Search Manuals"
    echo "4. Recommend Commands"
    echo "5. verify"
    echo "6. exit"
    echo -n "Enter your choice: "
    echo
    echo "================================================"
    echo
    
    # Read the user's choice
    read choice
    
    # Process the user's choice
    case $choice in
        1)
            # Run the batch-generate option of the_man.sh
            ./the_man.sh batch-generate
            ;;
        2)
            # Ask the user for a command
            echo -n "Enter a command: "
            read command
            # Run the generate option of the_man.sh for the specified command
            ./the_man.sh generate "$command"
            ;;
        3)
            # Run the search option of the_man.sh
            ./the_man.sh search
            ;;
        4)
            # Run the recommend option of the_man.sh
            ./the_man.sh recommend
            ;;
        5)
            echo -n "Enter a command: "
            read command
            ./the_man.sh verify $command
            ;;
        6)
            # Exit the script
            echo "Exiting..."
            break
            ;;
        *)
            # Invalid choice
            printf "${RED}ERROR${NC}: Invalid choice\n"
            ;;
    esac
done
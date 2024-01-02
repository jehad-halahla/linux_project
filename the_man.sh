#this is the bash script for the first linux lab project
#
# MADE BY: JEHAD HALAHLA
# ID: 1201467
#
# NOTE: THIS COMMAND WILL LIKELY BE ABLE TO SUPPORT ALOT OF COMMANDS BUT I WILL ONLY USE THE ONES IN THE LIST
#
#check in the current repositry that the command list exists
RED='\033[0;31m' # Color Red
GREEN='\033[0;32m' # Color GREEN
BOLD='\033[1m' # Color BOLD
NC='\033[0m' # No Color
#we will define some keywords to be used to get related commands
########################
command_list="commands.txt"

function gen_example(){ #this function will generate an example for the command
local command=$1
#here we will try to generate an example of the given command
# i know that each command either runs freely or needs arguments
#first we will try ot run the command without arguments
if [ $command == "echo" ]
then
text="hello_world"
$command $text > /tmp/${command}.txt 2> /dev/null
res=$(cat /tmp/${command}.txt)
command=$(echo "echo $text")
elif $command > /tmp/${command}.txt 2> /dev/null
then
res=$(cat /tmp/${command}.txt)
elif [ $command == "chmod" ];then
chmod 777 /tmp/${command}.txt
res=$(ls -l /tmp/${command}.txt | cut -d' ' -f1,10)
command=$(echo "chmod 777 /tmp/${command}.txt")
elif [ $command == "chown" ];then
chown $(whoami) /tmp/${command}.txt
res=$(ls -l /tmp/${command}.txt | cut -d' ' -f3,10)
command=$(echo "chown `whoami` /tmp/${command}.txt")
elif [ $command == "chgrp" ];then
chgrp $(whoami) /tmp/${command}.txt
res=$(ls -l /tmp/${command}.txt | cut -d' ' -f4,10)
command=$(echo "chgrp $(whoami) /tmp/${command}.txt")
elif [ $command == "cp" ];then
cp /tmp/${command}.txt /tmp/${command}_copy.txt
res=$(ls -l /tmp/${command}_copy.txt | cut -d' ' -f1,10)
command=$(echo "cp /tmp/${command}.txt /tmp/${command}_copy.txt")
elif [ $command == "mv" ];then
mv /tmp/${command}.txt /tmp/${command}_moved.txt
res=$(ls -l /tmp/${command}_moved.txt | cut -d' ' -f1,10)
command=$(echo "mv /tmp/${command}.txt /tmp/${command}_moved.txt")
fi
#we will make the output at most 10 lines
# we just stick to the printing format of EXAMPLE
# Print the command name
res=$(echo "$res" | head )
printf "%-16s\t%s\n" "EXAMPLE" ">${command}" | column -t  -W 3 -s$'\t'
# Print each line of the output
while IFS= read -r line; do
    printf "%-16s\t%-s\n" "" "${line}"
done <<< "${res}" | column -t -W 2 -s$'\t'
# Print the output
}


function get_related(){ #this function will get the related commands for the parameter command
    local $command=$1
    ### here we extract certain info
if man $command | grep -A 3 "^SEE ALSO$" | tr ' ' $'\n' | grep ".*[0-9].*" | sed 's/^[ \t]*//' | grep -v ^"$command" > /dev/null
then
#now we filter the result
#printf "$command\n"
related=$(man $command | grep -A 3 "^SEE ALSO$" | tr ' ' $'\n' | grep ".*[0-9].*" | sed 's/^[ \t]*//' | sed 's/([0-9])//g' | head -5 |tr $'\n' ' ') #| grep -v $command
#command to get rid of , and . and replace then with nothing
related=$(printf "$related" | sed 's/\.//g' | sed 's/,//g' | sed 's/[ \t]$//g' | tr ' ' ',')
related=$(printf "$related" | grep ^"$command"$ -v)
if [ ! -z "$related" ]
then
printf "%-16s\t${related}" "RELATED COMMANDS" | column -t -W 2 -s$'\t'
fi
elif related=$(apropos "$command" | head | cut -d'-' -f1 | grep "^[a-z]" | sed 's/^[ \t]*//' | grep -v ^"$command" ) > /dev/null
then
related=$(printf "$related" | cut -d' ' -f1  | tr $'\n' ',' | sed 's/,$//g')
printf "%-16s\t${related}" "RELATED COMMANDS" | column -t -W 2 -s$'\t'
else
#here we will use a cheat for mkdir 
#printf "$command\n"
#ONLY mkdir will make it here so we suggest hard coded related commands
#printf "mkdir\n"
printf "%-16s\trmdir,touch" "RELATED COMMANDS" | column -t -W 2 -s$'\t'
:
fi
}

function check_command_valid(){ #this function will check if the command is valid
local command=$1
if compgen -c | grep "^$command$" > /dev/null ##if command does exist then we check if its in list
then
if cat $command_list | grep "^$command$" > /dev/null
then
return 0
else
printf "${RED}${BOLD}ERROR${NC}: command is not in the list\n"
printf "${GREEN}${BOLD}AVAILABLE COMMANDS${NC}\n"
cat $command_list | tr $'\n' ' '
printf "\n"
exit 1 # in case the command is not available!
fi
else
printf "${RED}${BOLD}ERROR${NC}: command doesn't exist\n"
exit 2 #in case the command doesn't exist
fi
}

function fetch_description(){ #this function will fetch the description of the command
local command=$1
desc=$(man $command | awk '/^DESCRIPTION$/,/^$/' | grep -v "^$" | grep -v "^DESCRIPTION$" | sed 's/^[ \t]*//')
desc=$( echo $desc | tr $'\t' ' ')
printf "%-16s\t${desc}" "DESCRIPTION" | column -t -W 2 -s$'\t'
}

function fetch_version(){ #this function will fetch the version of the command
local command=$1
if $command --version > /dev/null 2> /dev/null
then
if [ "$command" == "echo" ]
then
ver=$(uname --version | head -1 | sed 's/^[ \t]*//' )
else
ver=$($command --version | head -1| sed 's/^[ \t]*//' )
fi
elif $command -V > /dev/null 2> /dev/null
then
ver=$($command -V | head -1 | sed 's/^[ \t]*//' )
else
ver=$(uname --version | head -1 | sed 's/^[ \t]*//' )
fi
printf "%-16s\t${ver}" "VERSION" | column -t -W 2 -s$'\t'
}

##MAIN CODE##

action=$1
command=$2
if [ $# -eq 0 ];then
printf "${RED}USAGE${NC}: there should be 2 arguments -> [ACTION] [COMMAND] or One argument -> [ACTION]\n"
elif [ $# -ne 2 ];then
case $action in
[Bb][Aa][Tt][Cc][Hh]-[Gg][Ee][Nn][Ee][Rr][Aa][Tt][Ee])
./test_all.sh
;;
[Ss][Ee][Aa][Rr][Cc][Hh])
#here we will search for a command
printf "you want to search for a command or a keyword? [c/k]: "
read answer
if [ "$answer" == "c" ]
then
printf "enter the command you want to search for: \n"
read comm
if check_command_valid $comm
then
printf "${GREEN}command is valid${NC}\n\n"
if cat ${comm}_man.txt 2> /dev/null
then 
echo $comm > /tmp/history.txt
:
else
printf "command manual doesn't exist, you can generate it by running the following:\n"
printf ">${BOLD}./the_man.sh generate $comm${NC}\n"
fi
fi
elif [ "$answer" == "k" ]
then
printf "enter the keyword you want to search for: \n"
read key
if grep "$key" *_man.txt | cut -d':' -f1 | sort | uniq | tr $'\n' ' ' > /dev/null 2> /dev/null
then
printf "${GREEN}RELATED FILES${NC}\n\n"
printf "${BOLD}"
grep "\<$key\>" *_man.txt | cut -d':' -f1 | sort | uniq | nl
grep "$key" *_man.txt | cut -d':' -f1 | sort | uniq | nl > /tmp/related.txt
printf "\nto display a manual just enter the number coresponding the file\n"
printf "\nto display all manuals just enter ${BOLD}all${NC}\n"
printf "${NC}\n"
read choice
$count=$(cat /tmp/related.txt | wc -l) 2> /dev/null
if [ "$choice" == "all"  -a $count -gt 0 ] 2> /dev/null
then
cat $(cat /tmp/related.txt) 2> /dev/null
elif grep "$choice" /tmp/related.txt > /dev/null 2> /dev/null
then
cat $(grep $choice /tmp/related.txt | sed 's/^[ \t]*//' | rev | cut -d$'\t' -f1 | rev)
else
printf "${RED}${BOLD}invalid input${NC}\n"

fi
fi
else
printf "${RED}${BOLD}invalid input${NC}\n"
fi
;;
*)
 # check if a valid number of arguments is passed
printf "${GREEN}AVAILABLE ACTIONS FOR A 1 ARGUMENT RUN${NC}\n"
printf "\n${BOLD}batch-generate search recommend${NC}\n\nabove options are case insensitive\n"
exit 4 # in case not enough args
;;
esac
else
check_command_valid $command
case $action in
[Gg][Ee][Nn][Ee][Rr][Aa][Tt][Ee])
#here we generate a manual for the given command
fetch_description $command > ${command}_man.txt
printf "\n" >> ${command}_man.txt
#now we will use the function that fetches the version
fetch_version $command >> ${command}_man.txt
printf "\n" >> ${command}_man.txt
#now we will use the function that fetches the related commands
get_related $command >> ${command}_man.txt
printf "\n" >> ${command}_man.txt
#now we will use the function that generates an example
gen_example $command >> ${command}_man.txt
printf "\n" >> ${command}_man.txt
cat ${command}_man.txt 2> /dev/null
;;
[Vv][Ee][Rr][Ii][Ff][Yy])
## here we verify our results
./verify.sh $command
;;
[Vv]) #just a a script to get the verify script running 
: #do nothing
;;
*)
printf "${RED}ERROR${NC}: [ACTION] is not a valid action, a list of valid actions:\n"
printf "\n${BOLD}Generate verify${NC}\n\nabove options are case insensitive\n"
exit 3 # for a not valid action
;;
esac
#first step is to process the args
# we will work on $1 $2 and store them in action, command variables to check their validity!
fi


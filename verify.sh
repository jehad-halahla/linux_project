#this code will call functions from the_man.sh and write them to files and compare usign the diff command
command=$1 # we will pass the command here
#we will call the generate function for the command and store it in /tmp/${command}_man.txt
#first we will check if the command_man exists...if it doesn,t then we will create it
if [ -f "${command}_man.txt" -a -e "${command}_man.txt" ]
then
#we will call the functions here
source the_man.sh v $command
fetch_description $command > /tmp/verify/${command}_man.txt
printf "\n" >> /tmp/verify/${command}_man.txt
fetch_version $command >> /tmp/verify/${command}_man.txt
printf "\n" >> /tmp/verify/${command}_man.txt
get_related $command >> /tmp/verify/${command}_man.txt
printf "\n" >> /tmp/verify/${command}_man.txt
gen_example $command >> /tmp/verify/${command}_man.txt
printf "\n" >> /tmp/verify/${command}_man.txt
cat /tmp/verify/${command}_man.txt
diff --color=always -s /tmp/verify/${command}_man.txt ${command}_man.txt #this line highlights the difference 
else
printf "do you want to generate the manual for the command? [y/n]: "
read answer
if [ "$answer" == "y" ]
then
./the_man.sh generate $command #generate the command manual if it doesn't exist
else
printf "ok, your loss\n"
fi
fi

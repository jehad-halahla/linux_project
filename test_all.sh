#this is a template to test all the commands in the file commands.txt
comm="commands.txt"
while read -r command
do
./the_man.sh generate $command > manuals/${command}_man.txt
done < $comm


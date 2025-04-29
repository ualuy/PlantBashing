#!bin/bash
echo "Hello new user! What's your name?"
read username
echo "Welcome, $username"
sleep 1
echo "Do you want to plant a new seed?"
sleep 1
echo "Type y to plant and q to quit"

while true; do
	read answer1
	if [ "$answer1" == "y" || "$answer1" == "Y" ]; then
		echo "You dug a hole, and planted a small grain-sized seed."
		sleep 2
		echo "This tiny world you are spectating flies way faster than your world does. Everything passes quicker in here."
		sleep 2
		echo "Do you want to sit by and wait for the seed to grow?" 
		sleep 1
		echo "Type y to wait and q to quit."
		while true; do
			read answer2
			if [ "$answer2" == "y" || "$answer1" == "Y" ] then
				echo "The seed will always take 3 days to grow."
				echo "You waited for a whole day, but nothing happened."
				line=
			for (( i=0; i<${#line}; i++ )); do
				printf "${line:$i:1}"
				sleep 0.1
			done

	elif [ "$answer1" == "q" || "$answer1" == "Q" ]; then 
		line="The world collapses to a singularity as you fade out..."
	for (( i=0; i<${#line}; i++ )); do
		printf "${line:$i:1}"
		sleep 0.1
	done
	sleep 2
	exit
	else
	echo "Invalid answer. Please reenter."
fi
done

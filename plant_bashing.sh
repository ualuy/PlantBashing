#!bin/bash

dayn=0
dayr1=3
dayr2=6
msgwait="You waited for a whole day, but nothing happened."

wait() {
	echo "Do you want to wait even more?(y/n)"
	read ans
	if [[ $ans == "y" || $ans == "Y" ]]; then
		((dayn++))
	elif [[ $ans == "n" || $ans == "N" ]]; then
		test
	fi
}


test() {
	line="The world collapses to a singularity as you fade out..."
	for (( i=0; i<${#line}; i++ )); do
		printf "${line:$i:1 }"
		sleep 0.2
	done
	exit
}



echo "Hello new user! What's your name?"
read username
echo "Welcome, $username"
sleep 1
echo "Do you want to plant a new seed?(y/n)"

#if [[ $dayn -lt $dayr1 ]]; then  
while true; do
	read answer1
	if [[ $answer1 == "y" || $answer1 == "Y" ]]; then
		echo "You dug a hole, and planted a small grain-sized seed."
		sleep 2
		echo "This tiny world you are spectating flies way faster than your world does. Everything passes quicker in here."
		sleep 2
		echo "Do you want to sit by and wait for the seed to grow?(y/n)" 
		while true; do
			read answer2
			((dayn++))
			if [[ $answer2 == "y" || $answer1 == "Y" ]]; then
				echo "The seed will always take 3 days to grow. $msgwait "
				echo "This is day $dayn. "
				wait
			fi
		done
	elif [[ $answer1 == "n" || $answer1 == "N" ]]; then 
		test
	else
		echo "Invalid answer. Please reenter."
	fi
#elif [[ $dayn -gt $dayr2 ]]; then

done
#!bin/bash

dayn=0
msgwait="You waited for a whole day, but nothing happened."
plheight=0
plleaves=0

wait() {
	echo "Do you want to wait even more?(y/n)"
	while true; do
		read ans
		if [[ $ans == "y" || $ans == "Y" ]]; then
			((dayn++))
			echo "This is day $dayn."
			if [[ $dayn -lt 3 ]]; then
				echo "Nothing has happened yet."
				wait
			elif [[ $dayn == 3 ]]; then
				echo "Your seed germinated overnight!"
				wait
			elif [[ $dayn -gt 3 ]] && [[ $dayn -lt 6 ]]; then
				echo "Nothing happened yet..."
				wait
			elif [[ $dayn == 6 ]]; then
				echo "Your seed has grown into a green little plant!"
				wait	
			elif [[ $dayn -gt 6 ]] && [[ $dayn -lt 21 ]];then
				echo "Your plant has grown 2 cm!"
				sleep 1
				echo "And has got two leaves!"
				((plheight += 2))
				((plleaves += 2))
				sleep 1
				echo "Day count: $dayn"
				sleep 1
				echo "Your plant's current height: $plheight"
				sleep 1
				echo "Your plant's current leave count: $plleaves"
				wait
			else 
				echo "Your plant has reached the end of its lifespan."
				sleep 1
				echo "Day count: $dayn"
				sleep 1
				echo "Your plant's current height: $plheight"
				sleep 1
				echo "Your plant's current leave count: $plleaves"
				sleep 1
				echo "It has lived a happy life."
				sleep 1
				echo "Goodbye, $username!"
				sleep 1
				exit
			fi
		elif [[ $ans == "n" || $ans == "N" ]]; then
			echo "Goodbye $username!"
			sleep 0.5
			echo "It's been a great time knowing you."
			sleep 0.5
			exit
		else 
			echo "Invalid response. Please reenter."
		fi
	done
}

echo "Hello new user! What's your name?"
read username
echo "Welcome, $username"
sleep 1
echo "Do you want to plant a new seed?(y/n)"

while true; do
	read ans
	if [[ $ans == "y" || $ans == "Y" ]]; then
		echo "You dug a hole, and planted a small grain-sized seed."
		sleep 1
		echo "This tiny world you are spectating flies way faster"
		echo "than your world does. Everything passes quicker in here."
		sleep 1
		echo "Do you want to sit by and wait for the seed to grow?(y/n)" 
		while true; do
			read ans
			((dayn++))
			if [[ $ans == "y" || $ans == "Y" ]]; then
				echo "The seed will always take 3 days to grow. "
				echo "$msgwait"
				echo "This is day $dayn. "
				wait
			fi
		done
	elif [[ $ans == "n" || $ans == "N" ]]; then 
		test
	else
		echo "Invalid answer. Please reenter."
	fi
done
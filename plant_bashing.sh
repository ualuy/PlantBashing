#!/bin/bash

dayn=0
msgwait="You waited for a whole day, but nothing happened."
plheight=0
plleaves=0
usrinput=false

# Start game
play() {
    # Reset variables to start a new game
    dayn=0
    plheight=0
    plleaves=0
    if [[ $usrinput == false ]]; then
        echo "Hello new user! What's your name?"
        read username
        echo "Welcome, $username!"
        echo "You dug a hole and planted a small seed."
        sleep 1
        echo "Do you want to name your plant? (y/n)"
        usrinput=true
    else
        echo "Welcome back, $username!"
        echo "You dug a hole and planted a small seed."
        sleep 1
        echo "Do you want to rename your plant? (y/n)"
    fi
    gamecycle
}

# Starting the game cycle
gamecycle() {
    plant=true
    while [ "$plant" == true ]; do
        read ans
        if [[ $ans == "y" || $ans == "Y" ]]; then
            plant=false
            echo "What should its name be?"
            read plantname
            echo "Your plant's name will be $plantname!"
        elif [[ $ans == "n" || $ans == "N" ]]; then
            plant=false
            echo "Since you didn't name it, its name shall be Morpheus."
        else
            echo "Invalid response, please reenter."
        fi
    done
    echo "If you ever want to exit, just hit the ; key."
    sleep 0.5
    echo "Do you want to wait for $plantname to grow? (y/n)"
    playerans=true
    while [ "$playerans" = true ]; do
        read ans
        if [[ $ans == "y" || $ans == "Y" ]]; then
            playerans=false
            echo "$plantname will take 3 days to germinate."
            echo "You are waiting for the first day to pass..."
            sleep 3
            echo "The day has passed."
            echo "Nothing has happened yet..."
            ask
        elif [[ $ans == "n" || $ans == "N" ]]; then
            playerans=false
            plexit
        else
            echo "Invalid response, please reenter."
        fi
    done
}

# Game logic
ask() {
    questions=("Wanna keep waiting for $plantname to grow?" 
           "Do you want to wait for $plantname to grow?" 
           "Keep waiting?")
    size=${#questions[@]}
    rand_index=$((RANDOM % size))
    echo "${questions[$rand_index]} (y/n)"
    startloop=true
    while [ "$startloop" = true ]; do
        read ans
        if [[ $ans == "y" || $ans == "Y" ]]; then
            ((dayn++))
            sleep 2
            echo "This is day $dayn."
            if [[ $dayn -lt 3 ]]; then
                echo "Nothing has happened yet..."
                ask
            elif [[ $dayn == 3 ]]; then
                echo "$plantname germinated overnight! 🎉"
                ask
            elif [[ $dayn -gt 3 && $dayn -lt 6 ]]; then
                echo "Nothing has happened yet..."
                ask
            elif [[ $dayn == 6 ]]; then
                echo "$plantname has grown into a green little plant! 🎉"
                ask
            elif [[ $dayn -gt 6 && $dayn -lt 21 ]]; then
                echo "$plantname has grown 2 cm and sprouted two new leaves!"
                ((plheight += 2))
                ((plleaves += 2))
                echo "Height: $plheight cm, Leaves: $plleaves"
                ask
            else
                echo "$plantname has reached the end of its lifespan."
                echo "Final day count: $dayn"
                echo "Height: $plheight cm, Leaves: $plleaves"
                echo "$plantname lived a happy life."
                echo "Do you want to play again? (y/n)"
                startloop=false
                read ans
                if [[ $ans == "y" || $ans == "Y" ]]; then
                    play
                else
                    plexit
                fi
            fi
        elif [[ $ans == "n" || $ans == "N" ]]; then
            plexit
        else
            echo "Invalid response. Please reenter."
        fi
    done
}

# Exit game
plexit() {
    echo "Goodbye $username!"
    sleep 0.5
    echo "It's been a great time knowing you."
    sleep 0.5
    exit
}

play

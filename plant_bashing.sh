#!/bin/bash

survivecounter=0
dayn=0
msgwait="You waited for a whole day, but nothing happened."
plheight=0
plleaves=2
usrinput=false
namecycle=0
names=("Morpheus" "Analiea" "Izzy")
growthrate=2
resistance=0
leaves_added=0
growthmsgs=(
  "%s has grown 1.5 cm, and %s leaves!"
  "%s grew 1.5 cm and sprouted %s more leaves!" 
  "%s seems very energetic today! Height +1.5, and leaves + %0f."
)


weatherdeath() {
    diemsg
            startloop=false
                read ans
                if [[ $ans == "y" || $ans == "Y" ]]; then
                    play
                else
                    plexit
                fi
}

diemsg() {
    echo "Final day count: $dayn"
    echo "Height: $plheight cm, Leaves: $plleaves"
    echo "Windstorms survived: $survivecounter."
    echo "${names[$namecycle]} lived a happy life."
    echo "Do you want to play again? (y/n)"
}

growecho() {
    leaves_added=$(bc <<< "2 + (2.5 * $growthrate) ")
    plheight=$(bc <<< "$plheight + 1.5")
    plleaves=$(bc <<< "$plleaves + 2 + (2.5 * $growthrate) ")
    printf "${growthmsgs[$msgpick]}\n" "${names[$namecycle]}" "$leaves_added"
    printf "Current height: $plheight cm, current leaf count: $plleaves "
    leaves_added=0
}


limit0() {
    if (( $(bc -l <<< "$growthrate < 0 ") )); then
        growthrate=0
    fi
    if (( $(bc -l <<< "$plleaves < 0 ") )); then
        plleaves=0
    fi
    if (( $(bc -l <<< "$plheight < 0 ") )); then
        plheight=2
    fi
}

# Start game
play() {
    # Reset variables to start a new game
    dayn=0
    plheight=0
    plleaves=0
    if [[ $namecycle -lt 2 ]]; then
                ((namecycle++))
    else
        namecycle=0
    fi
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
            names+=("$plantname")
            namecycle=$((${#names[@]} - 1)) 
        elif [[ $ans == "n" || $ans == "N" ]]; then
            plant=false
            echo "Since you didn't name it, its name shall be ${names[$namecycle]}."
        elif [[ $ans == ";" ]]; then
            plexit
        elif [[ $ans == "-" ]]; then
            usrinput=false
            play
        else
            echo "Invalid response, please reenter."
        fi
    done
    sleep 0.5
    echo "If you ever want to exit, just wait for a question and input ';' " 
    sleep 0.5
    echo "or if you want to restart the game, just input '-' "
    sleep 0.5
    echo "Do you want to wait for ${names[$namecycle]} to grow? (y/n)"
    playerans=true
    while [ "$playerans" = true ]; do
        read ans
        if [[ $ans == "y" || $ans == "Y" ]]; then
            playerans=false
            echo "${names[$namecycle]} will take 3 days to germinate."
            echo "You are waiting for the first day to pass..."
            sleep 2
            echo "The day has passed."
            echo "Nothing has happened yet..."
            ask
        elif [[ $ans == "n" || $ans == "N" ]]; then
            playerans=false
            plexit
        elif [[ $ans == ";" ]]; then
            plexit
        elif [[ $ans == "-" ]]; then
            usrinput=false
            play
        else
            echo "Invalid response, please reenter."
        fi
    done
}

# Game logic: All loops start right about here
ask() {
    questions=("Wanna keep waiting for ${names[$namecycle]} to grow?" "Do you want to wait for ${names[$namecycle]} to grow?" "Keep waiting?")
    #random messages to say when the player has to wait
    size=${#questions[@]}
    rand_index=$((RANDOM % size))
    #choosing random weathers
    weather=("rainy" "sunny" "cloudy" "overcast" "windstorm" "foggy" "thunderstorm")
    randompick=$((RANDOM % ${#weather[@]} ))
    echo "${questions[$rand_index]} (y/n)"
    startloop=true
    while [ "$startloop" = true ]; do
        read ans
        if [[ $ans == "y" || $ans == "Y" ]]; then
            ((dayn++))
            sleep 1
            echo "This is day $dayn."
            if [[ $dayn -lt 3 ]]; then
                echo "Nothing has happened yet..."
                ask
            elif [[ $dayn == 3 ]]; then
                echo "${names[$namecycle]} germinated overnight! 🎉"
                ask
            elif [[ $dayn -gt 3 && $dayn -lt 6 ]]; then
                echo "Nothing has happened yet..."
                ask
            elif [[ $dayn == 6 ]]; then
                echo "${names[$namecycle]} has sprouted and turned into a green little plant! 🎉"
                echo "Its current height is 2 cm."
                plheight=2
                ask
            elif [[ $dayn -gt 6 ]]; then
                weathera
                if (( $(bc <<< "$plheight > 35") )); then
                    echo "${names[$namecycle]} has exceeded the height of 35 cm, and is truly independent from you!"
                    echo "It will take care of itself now."
                    diemsg
                    startloop=false
                    waitforans=true
                        while [ "$waitforans" = true ]; do 
                        read ans
                        if [[ $ans == "y" || $ans == "Y" ]]; then
                            waitforans=false
                            play
                        elif [[ $ans == "n" || $ans == "N" ]]; then
                            waitforans=false
                            plexit
                        else
                            echo "Invalid response. Answer again, please."
                        fi
                        done
                    return
                fi
                ask
            fi
        elif [[ $ans == "n" || $ans == "N" ]]; then
            diemsg
            plexit
        elif [[ $ans == ";" ]]; then
            plexit
        elif [[ $ans == "-" ]]; then
            usrinput=false
            play
        else
            echo "Invalid response. Please reenter."
        fi
    done
}

weathera() {
    msgpick=$((RANDOM % ${#growthmsgs[@]} ))
    weathertoday=${weather[$randompick]}
    echo "Today's weather is $weathertoday."
    if [[ $weathertoday == "sunny" ]]; then
        ((growthrate += 3))
        growecho
    elif [[ $weathertoday == "rainy" ]]; then
        ((growthrate += 2))
        echo "No growth today, but ${names[$namecycle]} seems to be healthy!"
    elif [[ $weathertoday == "cloudy" ]]; then
        echo "No growth today..."
    elif [[ $weathertoday == "foggy" ]]; then
        ((growthrate -= 1))
        limit0
        echo "${names[$namecycle]} seems to be a little down today..."
    elif [[ $weathertoday == "overcast" ]]; then
        growecho
    elif [[ $weathertoday == "windstorm" ]]; then
        ((growthrate -= 2))
        ((survivecounter += 1))
        limit0
        echo "${names[$namecycle]} got severely hurt..."
        echo "${names[$namecycle]} lost 3 leaves!"
        plleaves=$(bc <<< "$plleaves - 3")
    elif [[ $weathertoday == "thunderstorm" ]]; then
        possible=("very far and short" "not very far" "very close")
        rand_index=$((RANDOM % 3))
        choose="${possible[$rand_index]}"
        echo "The thunderstorm was $choose."
        if [[ $choose == "very far and short" ]]; then
            echo "${names[$namecycle]} survived with barely any harm, and grew stronger!"
            ((resistance++))
        elif [[ $choose == "not very far" && $resistance -gt 0 ]]; then
            echo "${names[$namecycle]} was not harmed at all!"
            ((resistance++))
        elif [[ $choose == "not very far" && $resistance -eq 0 ]] && (( $(bc <<< "$plheight > 2") )); then
            echo "${names[$namecycle]} was hurt by the storm!"
            plheight=$(bc <<< "$plheight - 2")
            plleaves=$(bc <<< "$plleaves - 2")
            echo "It got shredded and lost 2 cm and 2 leaves."
            ((resistance++))
        elif [[ $choose == "not very far" && $resistance -eq 0 ]] && (( $(bc <<< "$plheight < 2") )); then
            echo "${names[$namecycle]} did not survive the storm..."
            weatherdeath
        elif [[ $choose == "very close" && $resistance -lt 2 ]]; then
            echo "${names[$namecycle]} did not survive the storm..."
            weatherdeath
        elif [[ $choose == "very close" && $resistance -eq 2 ]]; then
            echo "${names[$namecycle]} was hurt by the storm!"
            plheight=$(bc <<< "$plheight - 1")
            plleaves=$(bc <<< "$plleaves - 1")
            echo "It got shredded and lost 2 cm and 2 leaves."
            ((resistance++))
        elif [[ $choose == "very close" && $resistance -gt 2 && $resistance -lt 4 ]]; then
            echo "${names[$namecycle]} was slightly hurt by the storm."
            plheight=$(bc <<< "$plheight - 1")
            plleaves=$(bc <<< "$plleaves - 1")
            echo "It got shredded and lost 1 cm and 1 leaves."
            ((resistance++))
        elif [[ $choose == "very close" && $resistance -ge 4 ]]; then
            echo "${names[$namecycle]} was unharmed from the resistance it built up!"
        fi
    fi
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

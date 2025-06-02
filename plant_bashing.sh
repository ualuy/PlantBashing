#!/bin/bash

survive=0
survivecounter=0
survivecounter2=0
dayn=0
msgwait="You waited for a whole day, but nothing happened."
plheight=0
plleaves=0
usrinput=false
namecycle=0
names=("Morpheus" "Analiea" "Izzy")
growthrate=2
resistance=0
leaves_added=0
growthmsgs=(
  "%s has grown 1.5 cm, and %s leaves!"
  "%s grew 1.5 cm and sprouted %s more leaves!" 
  "%s seems very energetic today! Height +1.5, and leaves + %.0f."
)

#when plant dies from weather conditions, run...
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

#message that is broadcasted at the end of each day
msg() {
    printf "Current height: $plheight cm, current leaf count: $plleaves "
}


#message that is broadcasted when plant dies
diemsg() {
    echo "Final day count: $dayn"
    echo "Height: $plheight cm, Leaves: $plleaves"
    echo "Windstorms survived: $survivecounter."
    echo "Thunderstorms survived: $survivecounter2"
    echo "${names[$namecycle]} lived a happy life."
    echo "Do you want to play again? (y/n)"
}

#message that echoes how much your plant grew
growecho() {
    leaves_added=$(bc <<< "2 + (2.5 * $growthrate) ")
    plheight=$(bc <<< "$plheight + 1.5")
    plleaves=$(bc <<< "$plleaves + 2 + (2.5 * $growthrate) ")
    printf "${growthmsgs[$msgpick]}\n" "${names[$namecycle]}" "$leaves_added"
    leaves_added=0
}

#limit certain variables from going past 0
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
    if [[ $namecycle -lt 2 ]]; then #cycle through names
        ((namecycle++))
    else
        namecycle=0 #restart name cycle
    fi
    if [[ $usrinput == false ]]; then #check if user has played already
        echo "Hello new user! What's your name?"
        read username
        echo "Welcome, $username!"
        echo "You dug a hole and planted a small seed."
        sleep 1
        echo "Do you want to name your plant? (y/n)"
        usrinput=true #change to true
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
        if [[ $ans == "y" || $ans == "Y" ]]; then #check for "yes" as answer
            plant=false
            echo "What should its name be?"
            read plantname
            echo "Your plant's name will be $plantname!"
            names+=("$plantname")
            namecycle=$((${#names[@]} - 1)) #add user inputted name into the array of names
        elif [[ $ans == "n" || $ans == "N" ]]; then
            plant=false
            echo "Since you didn't name it, its name shall be ${names[$namecycle]}." #choose from the first unused option
        elif [[ $ans == ";" ]]; then
            plexit #call exit function
        elif [[ $ans == "-" ]]; then
            usrinput=false
            play #restart game
        else
            echo "Invalid response, please reenter." #restart if statement if input not recognized
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
        if [[ $ans == "y" || $ans == "Y" ]]; then #if user wants to wait, then...
            playerans=false
            echo "${names[$namecycle]} will take 3 days to germinate."
            echo "You are waiting for the first day to pass..."
            sleep 2
            echo "The day has passed."
            echo "Nothing has happened yet..."
            ask #game logic loops
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
    weather=("rainy" "sunny" "cloudy" "overcast" "windstorm" "foggy" "thunderstorm" "severe rain" "heat wave" )
    randompick=$((RANDOM % ${#weather[@]} )) #small line of code to be called when choosing randomly
    echo "${questions[$rand_index]} (y/n)" #ask one of the questions from above
    startloop=true
    while [ "$startloop" = true ]; do
        read ans
        if [[ $ans == "y" || $ans == "Y" ]]; then
            ((dayn++)) #add to day amount
            sleep 1
            echo "This is day $dayn."
            if [[ $dayn -lt 3 ]]; then #before seed germinates, nothing happens.
                echo "Nothing has happened yet..."
                ask #restart loop
            elif [[ $dayn == 3 ]]; then  #plant germinates
                echo "${names[$namecycle]} germinated overnight! 🎉"
                ask #loop again
            elif [[ $dayn -gt 3 && $dayn -lt 6 ]]; then #after germination but before sprouting, nothing happens
                echo "Nothing has happened yet..."
                ask
            elif [[ $dayn == 6 ]]; then #sprouting 
                echo "${names[$namecycle]} has sprouted and turned into a green little plant! 🎉"
                echo "Its current height is 2 cm."
                echo "It has no leaves yet."
                plheight=2
                ask
            elif [[ $dayn -gt 6 ]]; then #day cycles until game ends
                weathera #call weather conditions
                if (( $(bc <<< "$plheight > 35") )); then #check if game should end
                    echo "${names[$namecycle]} has exceeded the height of 35 cm, and is truly independent from you!"
                    echo "It will take care of itself now."
                    diemsg #includes question of if user wants to play again
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
                else 
                    msg
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
    msgpick=$((RANDOM % ${#growthmsgs[@]} )) #variable to choose randomly
    weathertoday=${weather[$randompick]}
    echo "Today's weather is $weathertoday."
    if [[ $weathertoday == "sunny" ]]; then
        ((growthrate += 3)) #add to growthrate
        growecho #grow
    elif [[ $weathertoday == "rainy" ]]; then
        ((growthrate += 2))#add to growthrate
        echo "No growth today, but ${names[$namecycle]} seems to be healthy!"
    elif [[ $weathertoday == "cloudy" ]]; then
        echo "No growth today..."
    elif [[ $weathertoday == "foggy" ]]; then
        ((growthrate -= 2)) #subtract from growthrate
        limit0 #call function to limit variable to 0
        echo "${names[$namecycle]} seems to be a little down today..."
    elif [[ $weathertoday == "overcast" ]]; then
        growecho
    elif [[ $weathertoday == "windstorm" ]]; then
        ((growthrate -= 3))
        ((survivecounter += 1)) #add to the counter of number of windstorms survived
        limit0
        echo "${names[$namecycle]} got severely hurt..."
        echo "${names[$namecycle]} lost 3 leaves!"
        plleaves=$(bc <<< "$plleaves - 3") #subtract from leaves
    elif [[ $weathertoday == "severe rain" ]]; then
        ((growthrate -= 3)) #plant was washed over, bad mineral condition!
        limit0
        echo "${names[$namecycle]} was flooded over by the heavy rain, and seems to not like it at all."
        echo "The ground lost a bunch of minerals and nutrition, seems like ${names[$namecycle]} would grow slower now."
    elif [[ $weathertoday == "heat wave" ]]; then
        echo "It's too hot for {names[$namecycle]} to take!"
        echo "It got so hot it lost 3 cm and 2 leaves."
        ((growthrate -= 3))
        plheight=$(bc <<< "$plheight - 3")
        plleaves=$(bc <<< "$plleaves - 2")
        limit0
        ((survive++)) #other counter for surviving certain conditions
    elif [[ $weathertoday == "thunderstorm" ]]; then
        ((survivecounter2++)) #other surviving counter
        possible=("very far and short" "not very far" "very close") #different levels of harm
        rand_index=$((RANDOM % 3))
        choose="${possible[$rand_index]}"
        echo "The thunderstorm was $choose." #choose from random harm
        if [[ $choose == "very far and short" ]]; then
            echo "${names[$namecycle]} survived with barely any harm, and grew stronger!"
            ((resistance++)) #add resistance to thunderstorms
        elif [[ $choose == "not very far" && $resistance -gt 0 ]]; then
            echo "${names[$namecycle]} was not harmed at all!"
            ((resistance++)) #add resistance to thunderstorms
        elif [[ $choose == "not very far" && $resistance -eq 0 ]] && (( $(bc <<< "$plheight > 2") )); then #check for harm level, resistance level, and if there can be height taken away
            echo "${names[$namecycle]} was hurt by the storm!"
            plheight=$(bc <<< "$plheight - 2")
            plleaves=$(bc <<< "$plleaves - 2")
            ((growthrate -= 3))
            limit0
            echo "It got shredded and lost 2 cm and 2 leaves."
            ((resistance++))
        elif [[ $choose == "not very far" && $resistance -eq 0 ]] && (( $(bc <<< "$plheight < 2") )); then #plant can't lose any more height, dies
            echo "${names[$namecycle]} did not survive the storm..."
            weatherdeath #function for when plant dies to weather
        elif [[ $choose == "very close" && $resistance -lt 2 ]]; then #too close
            echo "${names[$namecycle]} did not survive the storm..."
            weatherdeath
        elif [[ $choose == "very close" && $resistance -eq 2 ]]; then
            echo "${names[$namecycle]} was hurt by the storm!"
            ((growthrate -= 3))
            plheight=$(bc <<< "$plheight - 4")
            plleaves=$(bc <<< "$plleaves - 4")
            limit0
            echo "It got shredded and lost 4 cm and 4 leaves."
            ((resistance++))
        elif [[ $choose == "very close" && $resistance -gt 2 && $resistance -lt 4 ]]; then
            echo "${names[$namecycle]} was slightly hurt by the storm."
            plheight=$(bc <<< "$plheight - 2")
            plleaves=$(bc <<< "$plleaves - 2")
            ((growthrate -= 2))
            limit0
            echo "It got shredded and lost 2 cm and 2 leaves."
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

play #start the actual game after everything has been declared.
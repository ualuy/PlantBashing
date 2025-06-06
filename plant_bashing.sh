#!/bin/bash

windstormssurvived=0
thundersurvived=0
heatsurvived=0
days_after_plant_grew=0
waiting_message="You waited for a whole day, but nothing happened."
height_of_plant=0
plant_leaf_count=0
user_has_played=false
namecycle=0
names=("Morpheus" "Analiea" "Izzy")
growthrate=2
resistance_to_thunderstorm=0
leaves_added=0
growing_messages=(
  "%s has grown 1.5 cm, and %s leaves!"
  "%s grew 1.5 cm and sprouted %s more leaves!" 
  "%s seems very energetic today! Height +1.5 cm, and leaves + %.0f."
)

#when plant dies from weather conditions, run...
plant_dies_from_weather() {
    plant_life_summary
            startloop=false
                read ans
                if [[ $ans == "y" || $ans == "Y" ]]; then
                    reset_restart_game_play
                else
                    exitgame
                fi
}

#message that is broadcasted at the end of each day
plant_stats() {
    printf "Current height: $height_of_plant cm, current leaf count: $plant_leaf_count "
}


#message that is broadcasted when plant dies
plant_life_summary() {
    echo "Final day count: $days_after_plant_grew"
    echo "Height: $height_of_plant cm, Leaves: $plant_leaf_count"
    echo "Windstorms survived: $thundersurvived."
    echo "Thunderstorms survived: $windstormssurvived"
    echo "Heat waves survived: heatsurvived"
    echo "${names[$namecycle]} lived a happy life."
    echo "Do you want to play again? (y/n)"
}

#message that echoes how much your plant grew
plant_growth_calculate_and_message() {
    leaves_added=$(bc <<< "2 + (2.5 * $growthrate) ")
    height_of_plant=$(bc <<< "$height_of_plant + 1.5")
    plant_leaf_count=$(bc <<< "$plant_leaf_count + 2 + (2.5 * $growthrate) ")
    printf "${growing_messages[$plant_statspick]}\n" "${names[$namecycle]}" "$leaves_added"
    leaves_added=0
}

#limit certain variables from going past 0
limit_numbers_from_0() {
    if (( $(bc -l <<< "$growthrate < 0 ") )); then
        growthrate=0
    fi
    if (( $(bc -l <<< "$plant_leaf_count < 0 ") )); then
        plant_leaf_count=0
    fi
    if (( $(bc -l <<< "$height_of_plant < 0 ") )); then
    #if $($height_of_plant < 0 | bc); then
        height_of_plant=2
    fi
}

# Start game
reset_restart_game_play () {
    # Reset variables to start a new game
    days_after_plant_grew=0
    height_of_plant=0
    plant_leaf_count=0
    if [[ $namecycle -lt 2 ]]; then #cycle through names
        ((namecycle++))
    else
        namecycle=0 #restart name cycle
    fi
    if [[ $user_has_played == false ]]; then #check if user has played already
        echo "Hello new user! What's your name?"
        read username
        echo "Welcome, $username!"
        echo "You dug a hole and planted a small seed."
        sleep 1
        echo "Do you want to name your plant? (y/n)"
        user_has_played=true #change to true
    else
        echo "Welcome back, $username!"
        echo "You dug a hole and planted a small seed."
        sleep 1
        echo "Do you want to rename your plant? (y/n)"
    fi
    name_plant_and_instructions
}

# Starting the game cycle
name_plant_and_instructions() {
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
            exitgame #call exit function
        elif [[ $ans == "-" ]]; then
            user_has_played=false
            reset_restart_game_play #restart game
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
            ask_if_player_wants_to_wait #game logic loops
        elif [[ $ans == "n" || $ans == "N" ]]; then
            playerans=false
            exitgame 
        elif [[ $ans == ";" ]]; then
            exitgame
        elif [[ $ans == "-" ]]; then
            user_has_played=false
            reset_restart_game_play
        else
            echo "Invalid response, please reenter."
        fi
    done
}

# Game logic: All loops start right about here
ask_if_player_wants_to_wait() {
    questions=("Wanna keep waiting for ${names[$namecycle]} to grow?" "Do you want to wait for ${names[$namecycle]} to grow?" "Keep waiting?")
    #random messages to say when the player has to wait
    size=${#questions[@]} # get number of elements
    rand_index=$((RANDOM % size)) #get one of the elements
    #choosing random weathers
    weather=("rainy" "sunny" "cloudy" "overcast" "windstorm" "foggy" "thunderstorm" "severe rain" "heat wave" )
    randompick=$((RANDOM % ${#weather[@]} )) #small line of code to be called when choosing randomly
    echo "${questions[$rand_index]} (y/n)" #ask one of the questions from above
    startloop=true
    while [ "$startloop" = true ]; do
        read ans
        if [[ $ans == "y" || $ans == "Y" ]]; then
            ((days_after_plant_grew++)) #add to day amount
            sleep 1
            echo "This is day $days_after_plant_grew."
            if [[ $days_after_plant_grew -lt 3 ]]; then #before seed germinates, nothing happens.
                echo "Nothing has happened yet..."
                ask_if_player_wants_to_wait #restart loop
            elif [[ $days_after_plant_grew == 3 ]]; then  #plant germinates
                echo "${names[$namecycle]} germinated overnight! 🎉"
                ask_if_player_wants_to_wait #loop again
            elif [[ $days_after_plant_grew -gt 3 && $days_after_plant_grew -lt 6 ]]; then #after germination but before sprouting, nothing happens
                echo "Nothing has happened yet..."
                ask_if_player_wants_to_wait
            elif [[ $days_after_plant_grew == 6 ]]; then #sprouting 
                echo "${names[$namecycle]} has sprouted and turned into a green little plant! 🎉"
                echo "Its current height is 2 cm."
                echo "It has no leaves yet."
                height_of_plant=2
                ask_if_player_wants_to_wait
            elif [[ $days_after_plant_grew -gt 6 ]]; then #day cycles until game ends
                weathera #call weather conditions
                if (( $(bc <<< "$height_of_plant > 35") )); then #check if game should end
                    echo "${names[$namecycle]} has exceeded the height of 35 cm, and is truly independent from you!"
                    echo "It will take care of itself now."
                    plant_life_summary #includes question of if user wants to play again
                    startloop=false
                    waitforans=true
                        while [ "$waitforans" = true ]; do 
                        read ans
                        if [[ $ans == "y" || $ans == "Y" ]]; then
                            waitforans=false
                            reset_restart_game_play
                        elif [[ $ans == "n" || $ans == "N" ]]; then
                            waitforans=false
                            exitgame
                        else
                            echo "Invalid response. Answer again, please."
                        fi
                        done
                    return
                else 
                    plant_stats
                fi
                ask_if_player_wants_to_wait
            fi
        elif [[ $ans == "n" || $ans == "N" ]]; then
            plant_life_summary
            exitgame
        elif [[ $ans == ";" ]]; then
            exitgame
        elif [[ $ans == "-" ]]; then
            user_has_played=false
            reset_restart_game_play
        else
            echo "Invalid response. Please reenter."
        fi
    done
}

weathera() {
    plant_statspick=$((RANDOM % ${#growing_messages[@]} )) #get # of elements in growing_messages
    weathertoday=${weather[$randompick]} #set variable as another variable(in this case current set variable inside weather)
    echo "Today's weather is $weathertoday."
    if [[ $weathertoday == "sunny" ]]; then
        ((growthrate += 3)) #add to growthrate
        plant_growth_calculate_and_message #grow
    elif [[ $weathertoday == "rainy" ]]; then
        ((growthrate += 2))#add to growthrate
        echo "No growth today, but ${names[$namecycle]} seems to be healthy!"
    elif [[ $weathertoday == "cloudy" ]]; then
        echo "No growth today..."
    elif [[ $weathertoday == "foggy" ]]; then
        ((growthrate -= 2)) #subtract from growthrate
        limit_numbers_from_0 #call function to limit variable to 0
        echo "${names[$namecycle]} seems to be a little down today..."
    elif [[ $weathertoday == "overcast" ]]; then
        plant_growth_calculate_and_message
    elif [[ $weathertoday == "windstorm" ]]; then
        ((growthrate -= 3))
        ((windstormssurvived += 1)) #add to the counter of number of windstorms survived
        limit_numbers_from_0
        echo "${names[$namecycle]} got severely hurt..."
        echo "${names[$namecycle]} lost 3 leaves!"
        plant_leaf_count=$(bc <<< "$plant_leaf_count - 3") #subtract from leaves
    elif [[ $weathertoday == "severe rain" ]]; then
        ((growthrate -= 3)) #plant was washed over, bad mineral condition!
        limit_numbers_from_0
        echo "${names[$namecycle]} was flooded over by the heavy rain, and seems to not like it at all."
        echo "The ground lost a bunch of minerals and nutrition, seems like ${names[$namecycle]} would grow slower now."
    elif [[ $weathertoday == "heat wave" ]]; then
        echo "It's too hot for ${names[$namecycle]} to take!"
        echo "It got so hot it lost 2 cm and 2 leaves."
        ((growthrate -= 3))
        height_of_plant=$(bc <<< "$height_of_plant - 2")
        plant_leaf_count=$(bc <<< "$plant_leaf_count - 2")
        limit_numbers_from_0
        ((heatsurvived++)) #other counter for surviving certain conditions
    elif [[ $weathertoday == "thunderstorm" ]]; then
        ((thundersurvived++)) #other surviving counter
        possible=("very far and short" "not very far" "very close") #different levels of harm
        rand_index=$((RANDOM % 3))
        choose="${possible[$rand_index]}"
        echo "The thunderstorm was $choose." #choose from random harm
        if [[ $choose == "very far and short" ]]; then
            echo "${names[$namecycle]} survived with barely any harm, and grew stronger!"
            ((resistance_to_thunderstorm++)) #add resistance_to_thunderstorm to thunderstorms
        elif [[ $choose == "not very far" && $resistance_to_thunderstorm -gt 0 ]]; then
            echo "${names[$namecycle]} was not harmed at all!"
            ((resistance_to_thunderstorm++)) #add resistance_to_thunderstorm to thunderstorms
        elif [[ $choose == "not very far" && $resistance_to_thunderstorm -eq 0 ]] && (( $(bc <<< "$height_of_plant > 2") )); then #check for harm level, resistance_to_thunderstorm level, and if there can be height taken away
            echo "${names[$namecycle]} was hurt by the storm!"
            height_of_plant=$(bc <<< "$height_of_plant - 1")
            plant_leaf_count=$(bc <<< "$plant_leaf_count - 2")
            ((growthrate -= 3))
            limit_numbers_from_0
            echo "It got shredded and lost 1 cm and 2 leaves."
            ((resistance_to_thunderstorm++))
        elif [[ $choose == "not very far" && $resistance_to_thunderstorm -eq 0 ]] && (( $(bc <<< "$height_of_plant < 2") )); then #plant can't lose any more height, dies
            echo "${names[$namecycle]} did not survive the storm..."
            plant_dies_from_weather #function for when plant dies to weather
        elif [[ $choose == "very close" && $resistance_to_thunderstorm -lt 2 ]]; then #too close
            echo "${names[$namecycle]} did not survive the storm..."
            plant_dies_from_weather
        elif [[ $choose == "very close" && $resistance_to_thunderstorm -eq 2 ]]; then
            echo "${names[$namecycle]} was hurt by the storm!"
            ((growthrate -= 3))
            height_of_plant=$(bc <<< "$height_of_plant - 2")
            plant_leaf_count=$(bc <<< "$plant_leaf_count - 4")
            limit_numbers_from_0
            echo "It got shredded and lost 2 cm and 4 leaves."
            ((resistance_to_thunderstorm++))
        elif [[ $choose == "very close" && $resistance_to_thunderstorm -gt 2 && $resistance_to_thunderstorm -lt 4 ]]; then
            echo "${names[$namecycle]} was slightly hurt by the storm."
            height_of_plant=$(bc <<< "$height_of_plant - 1")
            plant_leaf_count=$(bc <<< "$plant_leaf_count - 2")
            ((growthrate -= 2))
            limit_numbers_from_0
            echo "It got shredded and lost 1 cm and 2 leaves."
            ((resistance_to_thunderstorm++))
        elif [[ $choose == "very close" && $resistance_to_thunderstorm -ge 4 ]]; then
            echo "${names[$namecycle]} was unharmed from the resistance_to_thunderstorm it built up!"
        fi
    fi
}

# Exit game
exitgame() {
    echo "Goodbye $username!"
    sleep 0.5
    echo "It's been a great time knowing you."
    sleep 0.5
    exit
}

reset_restart_game_play #start the actual game after everything has been declared.
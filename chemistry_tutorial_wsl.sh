#!/usr/bin/env bash
# set -x
# ANSI escape codes for text formatting
t=$'\e[0m' #reset text colour and style
r=$'\e[1;31m' #Red
g=$'\e[1;32m' #Green
y=$'\e[1;33m' #Yellow
b=$'\e[1;34m' #Blue
m=$'\e[1;35m' #Magenta
c=$'\e[1;36m' #Cyan

# Ensure the script has execute permissions
chmod +x "$0"
cd "$(dirname "$0")" || exit
wait_for_a_key_press() {
    read -rsn 1 key
    if [[ "$key" == $'\x7f' ]]; then
        # Connect to internet
        geminichat
    fi
    if [[ "$key" == $'\e' ]]; then
        echo -e "\n"
        exit 1
    fi
    if [[ "$key" == $'\x0a' ]]; then
        # Do something if a key is pressed
        return 0
    fi
    # Default: Do nothing if another key is pressed
    return 1
}

clear_and_center() {
  if [ "$cleared" != "true" ]; then
    clear
    cleared="true"
  else
    wait_for_a_key_press
    clear
  fi
  local term_height
  term_height=$(tput lines)
  local text_height
  text_height=$(echo -e "$1" | wc -l)
  local start_line=$(( (term_height - text_height) / 6 ))
  tput cup $start_line 0
  echo -e "$1 \\c"
}

# Function to handle exit
quit() {
    echo -e "\nExiting... \n\c"
    exit
}

# Function to handle maximum attempts exceeded
quit1() {
    echo -e "\n\nSorry, you've exceeded the maximum number of attempts. Exiting...\n\n"
    exit 1
}

function save_state {
    echo "$sentence_count" > "$STATE_FILE"
}

function load_state {
    if [ -f "$STATE_FILE" ]; then
        sentence_count=$(<"$STATE_FILE" tr -d '[:space:]')
    else
        sentence_count=0
    fi
}

# Function to handle user input for class selection
function handle_class_input() {
    if { [ -n "$last_class" ] || [ -z "$last_topic" ]; } && [ -f .chemistry_surveyor ]; then
		while true; do
	        read -rp $'\n\nPlease enter '"${r}1 or 2 or 3 or 4${t}"' to go to your class or '"${r}x${t}"' to exit'$'\n\n> ' class
            if [ "$class" == "x" ]; then
                exit
            fi
		    # Check if .current_chemistry_class is accidentally empty
		    if [ ! -s .current_chemistry_class ]; then
		        # Echo 1 to .current_chemistry_class
		        echo "1" > .current_chemistry_class
		    fi
		    # Read the value from the file
		    current_chemistry_class=$(<.current_chemistry_class) 2>/dev/null
		    # Check if the value is equal to $class
		    if [ "$current_chemistry_class" -lt "$class" 2>/dev/null ]; then
		        echo -e "\n${y}Your progress can't be tracked.${t} ${g}You either havent completed your current class' final assignment${t} ${r}or${t}\n\nYour files have been interfered with! You need ${b}to go back${t} and progress the right way! \c"
		        wait_for_a_key_press
				continue
			else
	            rm -f ".chemistry_topic_selected"
	            # Update the state file with the class
	            if [ "$class" != "x" ]; then
	                echo "$class" > .chemistry_user_state 2>/dev/null
	            fi
				break
	    	fi
		done
    fi
}


# Function to handle S4 user input for topic selection
function handle_s4_topic_input() {
    if [ -f .resume_to_class ]; then
        rm -f .resume_to_class
        rm -f .chemistry_topic_selected
    fi
    if [ -z "$last_topic" ] || [ -f .chemistry_topic_selected ]; then
        read -rp $'\n\nChoose either topic '"${g}1 or 2 or 3 or 4 or 5 or 6${t}"' to learn'$'\nor '"${r}r${t}"' to revise or '"${r}s${t}"' to get sample_items'$'\nor '"${r}a${t}"' to get an activity of integration or '"${r}q${t}"' to get a short answer question'$'\nor '"${r}n${t}"' to do your final class assignment and if necessary, gain access to the next class'$'\nor '"${r}p${t}"' to track academic progress or '"${r}x${t}"' to exit'$'\n\n1. Oxidation and reduction reactions '"${r}Term1${t}"''$'\n\n2. Industrial processes '"${r}Term1${t}"''$'\n\n3. Trends in the periodic table '"${r}Term2${t}"''$'\n\n4. Energy changes during chemical reactions '"${r}Term2${t}"''$'\n\n5. Chemicals for consumers '"${r}Term3${t}"''$'\n\n6. Nuclear processes '"${r}Term3${t}"''$'\n\n> ' topic
        touch .chemistry_surveyor
        touch .chemistry_topic_selected
        # Update the state file with the topic
        # Check if the state file exists, and the topic is not "x"
        if [ -f .chemistry_user_state ] && [ "$topic" != "x" ]; then
            # Get the current class value from the state file
            existing_class=$(awk '{print $1}' .chemistry_user_state)
            # Update the state file with the topic, preserving the existing class value
            echo "$existing_class $topic" > .chemistry_user_state 2>/dev/null
        fi
    fi
}

# Function to handle S3 user input for topic selection
function handle_s3_topic_input() {
    if [ -f .resume_to_class ]; then
        rm -f .resume_to_class
        rm -f .chemistry_topic_selected
    fi
    if [ -z "$last_topic" ] || [ -f .chemistry_topic_selected ]; then
        read -rp $'\n\nChoose either topic '"${g}1 or 2 or 3 or 4 or 5 or 6${t}"' to learn'$'\nor '"${r}r${t}"' to revise or '"${r}s${t}"' to get sample_items'$'\nor '"${r}a${t}"' to get an activity of integration or '"${r}q${t}"' to get a short answer question'$'\nor '"${r}n${t}"' to do your final class assignment and if necessary, gain access to the next class'$'\nor '"${r}p${t}"' to track academic progress or '"${r}x${t}"' to exit'$'\n\n1. Carbon in life '"${r}Term1${t}"''$'\n\n2. Structures and bonds '"${r}Term1${t}"''$'\n\n3. Formulae, stoichiometry and mole concept '"${r}Term2${t}"''$'\n\n4. Properties and structures of substances '"${r}Term2${t}"''$'\n\n5. Fossil fuels '"${r}Term3${t}"''$'\n\n6. Chemical reactions '"${r}Term3${t}"''$'\n\n> ' topic
        touch .chemistry_surveyor
        touch .chemistry_topic_selected
        # Update the state file with the topic
        # Check if the state file exists, and the topic is not "x"
        if [ -f .chemistry_user_state ] && [ "$topic" != "x" ]; then
            # Get the current class value from the state file
            existing_class=$(awk '{print $1}' .chemistry_user_state)
            # Update the state file with the topic, preserving the existing class value
            echo "$existing_class $topic" > .chemistry_user_state 2>/dev/null
        fi
    fi
}
# Function to handle S1 class user input for topic selection
function handle_s1_topic_input() {
    if [ -f .resume_to_class ]; then
        rm -f .resume_to_class
        rm -f .chemistry_topic_selected
    fi
    if [ -z "$last_topic" ] || [ -f .chemistry_topic_selected ]; then
        read -rp $'\n\nChoose either topic '"${g}1 or 2 or 3 or 4 or 5 or 6 or 7 or 8 or 9${t}"' to learn'$'\nor '"${r}r${t}"' to revise or '"${r}s${t}"' to get sample_items'$'\nor '"${r}a${t}"' to get an activity of integration or '"${r}q${t}"' to get a short answer question'$'\nor '"${r}n${t}"' to do your final class assignment and if necessary, gain access to the next class'$'\nor '"${r}p${t}"' to track academic progress or '"${r}x${t}"' to exit'$'\n\n1. Chemistry and Society (Introduction to Chemistry and Experimental Techniques, '"${r}Term1${t}"')'$'\n\n2. Experimental Chemistry (Introduction to Chemistry and Experimental Techniques, '"${r}Term1${t}"')'$'\n\n3. States and changes of states of matter (Particle Nature of Matter, '"${r}Term1${t}"')'$'\n\n4. Using materials (Particle Nature of Matter, '"${r}Term1${t}"')'$'\n\n5. Temporary and permanent changes (Temporary and Permanent Changes to Materials, '"${r}Term2${t}"')'$'\n\n6. Mixtures, Elements, and compounds (Temporary and Permanent Changes to Materials, '"${r}Term2${t}"')'$'\n\n7. Air (Air and Environment, '"${r}Term3${t}"')'$'\n\n8. Water (Air and Environment, '"${r}Term3${t}"')'$'\n\n9. Rocks and Minerals (Earth and Space, '"${r}Term3${t}"') '$'\n\n> ' topic
        touch .chemistry_surveyor
        touch .chemistry_topic_selected
        # Update the state file with the topic
        # Check if the state file exists, and the topic is not "x"
        if [ -f .chemistry_user_state ] && [ "$topic" != "x" ]; then
            # Get the current class value from the state file
            existing_class=$(awk '{print $1}' .chemistry_user_state)
            # Update the state file with the topic, preserving the existing class value
            echo "$existing_class $topic" > .chemistry_user_state 2>/dev/null
        fi
    fi
}

# Function to handle S2 class user input for topic selection
function handle_s2_topic_input() {
    if [ -f .resume_to_class ]; then
        rm -f .resume_to_class
        rm -f .chemistry_topic_selected
    fi
    if [ -z "$last_topic" ] || [ -f .chemistry_topic_selected ]; then
        read -rp $'\n\nChoose either topic '"${g}1 or 2 or 3 or 4 or 5${t}"' to learn'$'\nor '"${r}r${t}"' to revise or '"${r}s${t}"' to get sample_items'$'\nor '"${r}a${t}"' to get an activity of integration or '"${r}q${t}"' to get a short answer question'$'\nor '"${r}n${t}"' to do your final class assignment and if necessary, gain access to the next class'$'\nor '"${r}p${t}"' to track academic progress or '"${r}x${t}"' to exit'$'\n\n1. Acids and alkalis (Acids and Alkalis, '"${r}Term1${t}"')'$'\n\n2. Salts (Acids and Alkalis, '"${r}Term1${t}"')'$'\n\n3. The Periodic table (The Periodic table, '"${r}Term1${t}"')'$'\n\n4. Carbon in the environment (Carbon in the environment, '"${r}Term2${t}"')'$'\n\n5. The reactivity series (Order of Reactivity of Metals, '"${r}Term3${t}"')'$'\n\n> ' topic
        touch .chemistry_surveyor
		touch .chemistry_topic_selected
        # Update the state file with the topic
        # Check if the state file exists, and the topic is not "x"
        if [ -f .chemistry_user_state ] && [ "$topic" != "x" ]; then
            # Get the current class value from the state file
            existing_class=$(awk '{print $1}' .chemistry_user_state)
            # Update the state file with the topic, preserving the existing class value
            echo "$existing_class $topic" > .chemistry_user_state 2>/dev/null
        fi
    fi
}

# Function to process reminders from file
process_reminders_from_file() {
    # Check if a file is provided as an argument
    if [ $# -eq 0 ]; then
        echo "Usage: $0 <filename>"
        exit 1
    fi

    # Read the file line by line
    prev_sentence=""
    echo_next=false
	echo -n > .chemistry_reminder

    while IFS= read -r line || [ -n "$line" ]; do
        # Use a semi-colon as a secondary delimiter and read into an array
        IFS=';' read -r -a sentences <<< "$line"
        # Print each element of the array on a new line
        for sentence in "${sentences[@]}"; do
            if [[ $echo_next == true ]]; then
				sentence=$(echo "$sentence" | sed -e 's/\bet[.]*c\b//gi' -e '0,/and/{s/\band\b/,/}' -e 's/\s*,\s*/,/g')
				# Remove trailing comma if present, then introduce a semicolon
				sentence="${sentence%,};"

                # Split the obtained sentence into multiple sentences using a comma as the delimiter
                IFS=',' read -ra split_sentences <<< "$sentence"
                for split_sentence in "${split_sentences[@]}"; do
					echo "$split_sentence" >> .chemistry_reminder
                done
            echo_next=false
            fi

			if [[ "$sentence" =~ (Examples\ of|examples\ of|example\ of) && "$sentence" =~ include ]]; then

                lower_cased_sentence=${sentence,}

                echo "Did you know that $lower_cased_sentence" >> .chemistry_reminder

                # Set flag to echo the next sentence
                echo_next=true


			elif [[ "$sentence" =~ (is|are)\ used\ (in|for|to|as) ]]; then

    			lower_cased_sentence=${sentence,}

 				echo "Did you know that $lower_cased_sentence;" >> .chemistry_reminder

			elif [[ "$sentence" =~ ^(An\ |A\ ) && "$sentence" =~ (\ is\ ) ]]; then

				lower_cased_sentence=${sentence,}

    			echo "Do you recall that $lower_cased_sentence;" >> .chemistry_reminder

			elif [[ "$sentence" =~ " → " ]]; then
    			echo "Hope you know that: $sentence;" >> .chemistry_reminder

            elif [[ "$sentence" =~ " ↔ " ]]; then
                echo "Hope you know that: $sentence;" >> .chemistry_reminder

            elif [[ "$sentence" =~ (Generally|general) ]]; then
                echo "Note: $sentence;" >> .chemistry_reminder

			fi
        done
        # Update the previous sentence
        prev_sentence="$sentence"
    done < "$1"
}


# Function to process random reminder
process_random_reminder() {
    # Check if a file is provided as an argument
    if [ $# -eq 0 ]; then
        echo "Usage: $0 <filename>"
        exit 1
    fi

    # Check if .chemistry_reminder exists
    if [ -f .chemistry_reminder ]; then
		# Remove empty lines from .chemistry_reminder
    	sed -i '/^[[:space:]]*$/d' .chemistry_reminder 2>/dev/null
        # Randomly select a non-empty sentence
        local reminder  # Declare the variable
		reminder=$(awk -v RS=';' 'BEGIN{srand();}{gsub(/^[[:space:]]+|[[:space:]]+$/, ""); if (length > 0) a[++n]=$0}END{if (n > 0) print a[int(rand()*n)+1]}' .chemistry_reminder)
        # Check if selected sentence is not empty and contains non-whitespace characters
        if [[ -n "$reminder" && "$reminder" =~ [[:graph:]] ]]; then
			modified_reminder="\n\n$reminder"
			current_datetime=$(date)
			whiptail --msgbox "Hey! It is $current_datetime: Welcome back dear! $modified_reminder" 20 80
			return
		fi
	fi
}

geminichat() {
    read -r API_KEY < .gemini_api
    conversation_history=""

    # Loop for interactive input
    while true; do
        # Prompt for input
        read -rp $'\nPrompt: ' prompt

        # Skip exit request
        if [[ "$prompt" == "q" ]]; then
            break
        fi

        # Combine prompt with conversation history
        combined_prompt="$conversation_history $prompt"

        # Call API and capture generated text
        generated_text=$(curl -s \
            https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$API_KEY \
            -H 'Content-Type: application/json' \
            -X POST \
            -d '{"contents": [{"parts":[{"text": "'"$combined_prompt"'"}]}]}' \
            2> /dev/null | grep "text")

        # Extract generated text
        generated_text=$(echo "$generated_text" | sed 's/^[ \t]*"text": "//g' | sed 's|\\"||g' | tr -d '*' | rev | sed 's/"//1' | rev)

        # Update conversation history
        conversation_history="$conversation_history $generated_text"

        # Print generated text
        echo -e "\n$generated_text"
    done
}

replace_prompt() {
    local prompt=$1
    local replacement_variable=$2

    read -erp $'\n'"${r}${prompt}${t}"': ' replace

    if [[ -n "$replace" ]]; then
        eval "$replacement_variable=\"$replace\""
        return 0
    else
        return 1
    fi
}

track_student_progress() {
echo -e 'School:                         ?
Class on joining:               ?
DateTime:                       ?
1   Name:                       surname given
    ID:                         ?
    contact(s):                 ?
2   Residence
             Village:           ?
             Parish:            ?
             Subcounty:         ?
             District:          ?
3   Age:                        Age
4   Sex:                        Male or Female
5   Parent/Guardian:            Surname Given
    Contact(s):                 ?
PROGRESSIVE ASSESSMENT' > student

    temp_file4=$(mktemp)
    temp_file3=$(mktemp)
    temp_file2=$(mktemp)
    temp_file=$(mktemp)
    trap 'rm -f student .temmmm "$temp_file" "$temp_file2" "$temp_file3" "$temp_file4" .student.txt' EXIT
    if [ -f .school_name ]; then
        read -r school_name < .school_name
        school_name="${school_name// /_}"
        touch ."$school_name"_students_file.txt
        sed -i '/^[[:space:]]*$/d' ."$school_name"_students_file.txt
    fi
    if [ -f .student_number.txt ]; then
        student_number=$(<.student_number.txt)
        if [ "$student_number" == "0" ]; then
            echo -e "\n\nHey! You currently have no records... Please take records \c"
            wait_for_a_key_press
        elif [ -n "$student_number" ] && [ "$student_number" -gt 1 ]; then
            echo -e "\n\nHey! You currently have records for $student_number students \c"
            wait_for_a_key_press
        fi
    else
        echo "0" > .student_number.txt
    fi

    clear
    # Initialize user_input variable
    user_input=""
    while true; do
        local user_input
        # Prompt the user for input
        if [ "$student_number" == "0" ]; then
            echo -e "\nPress "${r}Esc key${t}" to capture student details: $user_input\c"
        elif [ "$student_number" == "1" ]; then
            echo -e "\nTo track your progress, press the Tab key or Press "${r}Esc key${t}" to capture details of another student: $user_input\c"
        else
            echo -ne "\nTo search for student details, Enter "${y}Student Name${t}"\nor "${r}Esc key${t}" to capture new student details or "${r}qq${t}" to return to your session: $user_input\c"
        fi
        read -rsn1 char
        if [[ $char == $'\e' ]]; then
            break
        fi
        # Handle backspace
        if [[ $char == $'\x7f' ]]; then  # Check if the input is the backspace key
            user_input="${user_input%?}" # Remove the last character from user_input
        else
            user_input="${user_input}${char}"
        fi
        if [[ "$user_input" == "qq" ]]; then
            return
        fi

        clear
        # Define the file path
        file=."$school_name"_students_file.txt

        # Search for the pattern and capture the result
        match=$(sed 's/;/\n/g' "$file" | grep -i "Name:.*$user_input.*")
        colon_count=$(grep -o ":" <<< "$match" | wc -l)
        # Set initial flag to false
        flag=false
        if [[ $colon_count -eq 1 ]]; then
            matched="$match"
            flag=true
        else
            if [[ $char != $'\x7f' ]]; then
                if [[ $colon_count -eq 0 ]]; then
                    echo "Press the back space key and enter a "${r}Valid Name${t}"........."
                else
                    echo "${g}Close! A few more characters to refine your search.........${t}"
                fi
            fi
        fi
        if $flag; then
        awk -v user_input="$matched" 'tolower($0) ~ tolower(user_input) { print }' ."$school_name"_students_file.txt |
            while IFS= read -r line; do
                if [[ $char != $'\x7f' ]]; then
                   echo "$line" | sed 's/;/\n/g'
                fi
            done
        fi
    done

    # Prompt for user input
    echo -e "\n\n${y}By just pressing Enter; it means yes or skip${t} \c"
    echo -e ""
    if ! [ -f .school_name ]; then
        echo -e "\nPlease Enter the name of your school... This option is only available once \c"
        echo -e ""
        if replace_prompt "" replacement; then
            replacement=${replacement^^}  # Convert to uppercase
            # Store the value in the school_name file
            echo "$replacement" > .school_name
        fi
    else
        read -r replacement < .school_name
        current_datetime=$(date)
        echo -e "\nYou are at ${g}"$replacement"${t} and it is ${b}$current_datetime${t} \c"
        echo ""
    fi
    sed -i "s/School:                         ?/School:                         $replacement/" student
    current_datetime=$(date)
    sed -i "s/DateTime:                       ?/Date + Time:                    $current_datetime/" student

    if replace_prompt 'What is the '"client's"' current class (just a single digit)?' replacement; then
        sed -i "s/Class on joining:               ?/Class on joining:               S$replacement/" student
    fi
    if replace_prompt  ''"Client's"' SurName' replacement; then
        replacement=${replacement^}
        echo "$replacement" > "$temp_file"
        sed -i "s/surname/$replacement/" student
    fi

    read -r surname < "$temp_file"
    if replace_prompt  ''"Client's"' Given name' replacement; then
        replacement=${replacement^}
        sed -i "s/given/$replacement/" student
        echo -e "\nYou are highly welcome "$surname" "$replacement"... You are reminded that your education is our future \c"
        echo ""
    fi

    if replace_prompt  ''"$surname's"' Contact(s) (space separated)' replacement; then
        sed -i "s/contact(s):                 ?/Contact(s):                 $replacement/" student
    fi

    if replace_prompt  ''"$surname's"' Village' replacement; then
        replacement=${replacement^}
        sed -i "s/Village:           ?/Village:           $replacement/" student
    fi
    if replace_prompt  ''"$surname's"' Parish' replacement; then
        replacement=${replacement^}
        sed -i "s/Parish:            ?/Parish:            $replacement/" student
    fi

    if replace_prompt  ''"$surname's"' Subcounty' replacement; then
        replacement=${replacement^}
        sed -i "s/Subcounty:         ?/Subcounty:         $replacement/" student
    fi
    if replace_prompt  ''"$surname's"' District' replacement; then
        replacement=${replacement^}
        sed -i "s/District:          ?/District:          $replacement/" student
    fi

    if replace_prompt  ''"$surname's"' Age (Enter digits)' replacement; then
        sed -i "s/Age:                        Age/Age:                        $replacement/" student
    fi

    while true; do
        if replace_prompt  ''"$surname's"' Sex (M or F)' replacement; then
            replacement=${replacement^}
            if [ "$replacement" == "M" ]; then
                sed -i "s/Male or Female/"$replacement"ale/" student
                echo "him" > "$temp_file3"
                break
            elif [ "$replacement" == "F" ]; then
                sed -i "s/Male or Female/"$replacement"emale/" student
                echo "her" > "$temp_file3"
                break
            elif [ "$replacement" == "Female" ]; then
                sed -i "s/Male or Female/"$replacement"/" student
                echo "her" > "$temp_file3"
                break
            elif [ "$replacement" == "Male" ]; then
                sed -i "s/Male or Female/"$replacement"/" student
                echo "him" > "$temp_file3"
                break
            else
                echo -e "\nInvalid choice... Please choose either m or f \c"
                continue
            fi
        fi
    done

    if replace_prompt  'Please Enter the SurName of '"$surname's"' Parent/Guardian' replacement; then
        replacement=${replacement^}
        echo "$replacement" > "$temp_file2"
        sed -i "s/Surname/$replacement/" student
    fi
    read -r surname_nok < "$temp_file2"
    read -r gender < "$temp_file3"
    if [ "$gender" == "him" ]; then
        echo "his" > "$temp_file4"
    else
        echo "her" > "$temp_file4"
    fi
    read -r gender1 < "$temp_file4"
    if replace_prompt  ''"$surname_nok's"' Given name' replacement; then
        replacement=${replacement^}
        sed -i "s/Given/$replacement/" student
        echo -e "\n"$surname" is hereby reminded that "$gender1" Parent/Guardian is "$surname_nok" "$replacement" \c"
        echo ""
    fi
    if replace_prompt  ''"$surname_nok's"' Contact(s) (space separated)' replacement; then
        sed -i "s/Contact(s):                 ?/Contact(s):                 $replacement/" student
    fi

    read -r school_name < .school_name
    school_name="${school_name// /_}"
    touch ."$school_name"_students_file.txt
    sed -i '/^[[:space:]]*$/d' ."$school_name"_students_file.txt
    # Count the number of students
    student_number=$(grep -c "^School" ."$school_name"_students_file.txt)
    (( student_number++ ))
    sed -i -e 's/surname/?/gi' \
            -e 's/given/?/gi' \
            -e 's/? ?/?/gi' student
    cp student .student.txt
    sed -i "s/ID:                         ?/ID:                         $student_number/" .student.txt
    echo -e "\n"$surname"'s identification number is: "$student_number" \c"
    echo -e "\n\nYou can now make any changes to the provided details directly from the text editor. Don't edit your ID_No please! If necessary, note it down instead... \c"
    wait_for_a_key_press
    if grep -q Microsoft /proc/version; then
        explorer.exe .student.txt
    else
        xdg-open .student.txt
    fi
    wait_for_a_key_press
    sed -e ':a;N;$!ba;s/\n/;/g' .student.txt >> ."$school_name"_students_file.txt
    sort -f ."$school_name"_students_file.txt | uniq -i > .temmmm && mv .temmmm ."$school_name"_students_file.txt
    rm -f student .temmmm "$temp_file" "$temp_file2" "$temp_file3" "$temp_file4" .student.txt
    echo "$student_number" > .student_number.txt
    echo " "
}


#Function to process file
process_file() {
    # Check if a file is provided as an argument
    if [ $# -eq 0 ]; then
        echo "Usage: $0 <filename>"
        exit 1
    fi

    load_state
    sed -i "s/^\([^;]*;\)\{$sentence_count\}//" "$1" 2>/dev/null
    # Subtract 1 from sentence_count
    ((sentence_count--))
    # Read the file line by line
    while IFS= read -r line || [ -n "$line" ]; do
        # Use a semi-colon as a secondary delimiter and read into an array
        IFS=';' read -r -a sentences <<< "$line"

        # Loop through each sentence
        for sentence in "${sentences[@]}"; do
                if [[ -n "$sentence" && "$sentence" =~ [[:graph:]] ]]; then
                if [[ $sentence == *"Figure"* ]]; then
					modified_sentence=$(echo "$sentence" | sed 's/.*\(Figure.*\.jpg\).*$/\1/')
                    # Change to the "Figures/Chemistry" directory
                    cd Figures/Chemistry || { echo "Failed to change to Figures/Chemistry"; return; }
                    # Open the file using explorer.exe
                    explorer.exe "$modified_sentence" > /dev/null 2>&1 &
                    # Go back to the original directory
                    cd ../.. || { echo "Failed to change back to the original directory \c"; exit 1; }
                fi

                if [[ $sentence == *"Table"* ]]; then
                    cd Tables/Chemistry || { echo -e "\nFailed to change to Tables/Chemistry \c"; return; }
                    explorer.exe "$sentence" > /dev/null 2>&1 &
                    cd ../.. || { echo -e "\nFailed to change back to the original directory \c"; exit 1; }
                fi

                if [[ $sentence == *"Video"* ]]; then
                    cd Videos/Chemistry || { echo -e "\nFailed to change to Videos/Chemistry \c"; return; }
                    explorer.exe "$sentence" > /dev/null 2>&1 &
                    cd ../.. || { echo -e "\nFailed to change back to the original directory \c"; exit 1; }
                fi
                if [ $((sentence_count % 5)) -eq 0 ]; then
                    # Clear and center for every 5th sentence
                    clear_and_center "${y}$sentence${t} \c"
                elif [ $((sentence_count % 7)) -eq 0 ]; then
                    # Display the sentence in green for every 7th sentence
                    echo -e "\n\n${g}$sentence${t} \c"
                elif [ $((sentence_count % 6)) -eq 0 ]; then
                    # Display the sentence in magenta for every 6th sentence
                    echo -e "\n\n${m}$sentence${t} \c"
                elif [ $((sentence_count % 8)) -eq 0 ]; then
                    echo -e "\n\n${c}$sentence${t} \c"
                elif [ $((sentence_count % 3)) -eq 0 ]; then
                    # Display the sentence in blue for every 3rd sentence
                    echo -e "\n\n${b}$sentence${t} \c"
                elif [ $((sentence_count % 2)) -eq 0 ] || [ $((sentence_count % 4)) -eq 0 ]; then
                    # Display the sentence in green for every 4th sentence
                    echo -e "\n\n${g}$sentence${t} \c"
                else
                    # Display the sentence in red for other sentences
                    echo -e "\n\n${r}$sentence${t} \c"
                fi
            else
                echo -e "\n\nKind regards @OMD \c"
            fi
            ((sentence_count++))
            save_state
            # Wait for a keypress
            read -rsn 1 </dev/tty
            if [[ $REPLY == $'\x7f' ]]; then
                touch .connect_to_ai && break
            fi
            if [[ $REPLY == $'\e' ]]; then
                echo -e "\n"
		touch .skip_exercises && break
            fi
        done
    done < "$1"
}

contact_ai() {
    last_topic=$(awk -F' ' '{print $2}' .chemistry_user_state)
    if [ -f .connect_to_ai ]; then
        echo ""
        # Connect to internet
        geminichat
        rm -f .connect_to_ai
        touch .resume_to_class
    fi
}

get_and_display_pattern() {
while true; do
    # Initialize and declare user_input as a local variable
    local user_input=""
    trap 'rm -f videos.txt figures.txt tables.txt' EXIT

    # Prompt the user for input
    read -rp $'\n\nEnter '"${y}Keywords...${t}"' to search or type '"${g}cl${t}"' to get to class or '"${b}ch${t}"' to connect to chatgpt or '"${r}ge${t}"' to connect to Google AI or '"${m}zz${t}"' to update the code or '"${m}xx${t}"' to update learning materials or '"${c}nw${t}"' to create new workspace or '"${r}x${t}"' to exit: ' user_input

    # Check if user_input is not empty
    if [[ -n "$user_input" ]]; then
         if [[ "$user_input" == "cl" ]]; then
                return  # Exit the loop if the user enters 'cl'
         fi
        if [[ "$user_input" == "ch" ]]; then
                chatgpt #connect to chatgpt
                return
         fi
        if [[ "$user_input" == "ge" ]]; then
                echo -e "\nYou can quit with "${y}q${t}""
                geminichat
                return
         fi
        if [[ "$user_input" == "zz" ]]; then
            echo -e "\n"
            TEMP_FILE=$(mktemp) && curl -o "$TEMP_FILE" -L "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/chemistry_tutorial_wsl.sh" && mv "$TEMP_FILE" chemistry_tutorial_wsl.sh && chmod +x chemistry_tutorial_wsl.sh && echo -e "\n\nCode successfully updated.. You will have to restart a new session \c" && sleep 4 && exit || (echo -e "\n\nError updating code!... Please check your internet connection and try again! \c" && rm -f "$TEMP_FILE" && return)
        fi
        if [[ "$user_input" == "xx" ]]; then
            current_datetime=$(date)
            echo -e "\nIt is   ........   ""${r}$current_datetime${t}""   ........\n\nPlease understand that the content upon which the code runs is always updated on the "${y}first day of every month${t}"   ........ \c"
            read -rp $'\n\nEnsure the code is up to date and enter '"${m}y${t}"' to proceed to the update or press '"${y}Enter${t}"' to get to class   ........   '$'\n> ' input
            if [[ "$input" == "y" || "$input" == "Y" ]]; then
                echo -e "\n"
	            curl -O -L "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/update_chemistry.sh" || { echo -e "\n\n${m}Check your internet connection and try again!${t}" >&2; return; }
		        mv update_chemistry.sh .update_chemistry.sh
                bash .update_chemistry.sh
                return
            else
                return
            fi
        fi
        if [[ "$user_input" == "nw" ]]; then
                new_workspace
		return
         fi
        if [[ "$user_input" == "x" ]]; then
                quit  # Exit the loop if the user enters 'close'
         fi

        # Use grep to find the pattern in a file
        if [[ "$user_input" == "${user_input^^}" ]]; then
            # Case-sensitive search for user input
            result=$(grep -h -w -A 999999 "$user_input" Notes/Chemistry/*.txt | sed -e '1s/^/\n/' -e 's/\.\s\+/&\n\n/g' -e 's/;\s*/&\n/g' | sed '/https:/! s/^[^:]*://' | tr -d '\000' | sed 's/^ \([^ ]\)/\1/')
        else
            # Case-insensitive search for user input
		    result=$(find Notes/Chemistry -type f -name "*.txt" -exec awk '{if (gsub(/\.\s+/,"&\n\n"FILENAME":")) print ""; print FILENAME":" $0}' {} \; | grep -i -w "$user_input" | sed -e 's/: /. /g' | awk -F: 'BEGIN {file="";} {if (file != $1) { print ""; print $1; file=$1; print ""; } print $2}' | sed -e '/https:/! s/^[^:]*://' -e '/^$/N;/^\n$/D' | sed 's/\.\s\+/&\n/g' | tr -d '\000' | grep -E "$user_input|.txt" | sed 's/$/\n/' | sed 's/;\s*/&\n/g')
        fi

        # Check if the result is not empty
        if [[ -n "$result" ]]; then
            echo "$result" > search.txt  # Save the result to a file
            notepad.exe search.txt > /dev/null 2>&1  # Open the file in Notepad
            rm -f search.txt
            echo -e "\c"
            if echo "$result" | grep "Figure"; then
                echo "$result" | grep -o '\bFigure[0-9]\+.*\.jpg\(\.[0-9]\+\)*\b' > Figures/Chemistry/figures.txt
                sed -i -e '/^Figure/!d' -e '/^[[:space:]]*$/d' -e 's/^[[:space:]]*//;s/[[:space:]]*$//' Figures/Chemistry/figures.txt
                # Change to the "Figures/Chemistry" directory
                cd Figures/Chemistry || { echo "Failed to change to Figures/Chemistry"; return; }
                # Specify the path to the text file containing figure names
                text_file="figures.txt"
                # Read each line from the text file and open the corresponding figure
                while IFS= read -r figure_prefix || [ -n "$figure_prefix" ]; do
                    # Use sed to edit the figure_prefix and store it in a temporary variable
                    edited_figure_prefix=$(echo "$figure_prefix." | sed 's/.*\(Figure.*\.jpg\).*$/\1/')
                    # Open the figure file using explorer.exe
                    explorer.exe "${edited_figure_prefix}"* > /dev/null 2>&1 &
                    sleep 5
                done < "$text_file"
                # Go back to the original directory
                cd ../.. || { echo "Failed to change back to the original directory \c"; exit 1; }
                # Remove the temporary file
                rm -f Figures/Chemistry/figures.txt
            fi

            if echo "$result" | grep "Table"; then
                echo "$result" | grep -o '\bTable[0-9]\+\(\.[0-9]\+\)*\b' > Tables/Chemistry/tables.txt
                sed -i -e '/^Table/!d' -e '/^[[:space:]]*$/d' -e 's/^[[:space:]]*//;s/[[:space:]]*$//' Tables/Chemistry/tables.txt
                cd Tables/Chemistry || { echo -e "\nFailed to change to Tables/Chemistry \c"; return; }
                # Specify the path to the text file containing Table names
                text_file="tables.txt"
                # Read each line from the text file and open the corresponding table
                while IFS= read -r table_prefix || [ -n "$table_prefix" ]; do
                    # Use sed to edit the figure_prefix and store it in a temporary variable
                    edited_table_prefix=$(echo "${table_prefix}"* | sed -n 's/\([^ ]*\.odt\).*$/\1/p')
                    # Open the file
                    explorer.exe "${edited_table_prefix}"* > /dev/null 2>&1 &
                                sleep 10
                        done < "$text_file"
                # Remove the temporary file
                # Go back to the original directory
                cd ../.. || { echo -e "\nFailed to change back to the original directory \c"; exit 1; }
                rm -f Tables/Chemistry/tables.txt
            fi

            if echo "$result" | grep "Video"; then
                #echo "$result" > Videos/Chemistry/videos.txt
                echo "$result" | grep -o '\bVideo[0-9]\+\(\.[0-9]\+\)*\b' > Videos/Chemistry/videos.txt
                # Remove lines not starting with "Video" and any leading/trailing whitespaces
                sed -i -e '/^Video/!d' -e '/^[[:space:]]*$/d' -e 's/^[[:space:]]*//;s/[[:space:]]*$//' Videos/Chemistry/videos.txt
                # Change to the "Videos/Chemistry" directory
                cd Videos/Chemistry || { echo -e "\nFailed to change to Videos/Chemistry \c"; return; }
                # Specify the path to the text file containing video names
                text_file="videos.txt"
                while IFS= read -r video_prefix || [ -n "$video_prefix" ]; do
                    # Use sed to edit the figure_prefix and store it in a temporary variable
                    edited_video_prefix=$(echo "${video_prefix}"* | sed -n 's/\([^ ]*\.mp4\).*$/\1/p')
                    # Open the video file using explorer.exe
                    explorer.exe "${edited_video_prefix}"* > /dev/null 2>&1 &
                    sleep 10
                done < "$text_file"
                # Go back to the original directory
                cd ../.. || { echo -e "\nFailed to change back to the original directory \c"; exit 1; }
                # Remove the temporary file
                rm -f Videos/Chemistry/videos.txt
            fi

        else
            echo -e "\nNo items match your search \c"
        fi
    else
        echo -e "\nInput is empty. Please provide a pattern \c"
    fi
done
}

# Function to select and process a random short answer question
process_random_short_answer_question() {
    # Loop to ensure a valid, non-empty question is selected
    # Save the current working directory
    pushd . > /dev/null
    # Change to the specified directory
    cd "$question_directory" || exit
while true; do
    # Increment the attempt count
    ((attempts++))
    # Check if the maximum attempts are reached
    if ((attempts >= 100))
     then
        exit 1
    fi
    local question_directory="$1"
    local file_extension_question="$2"
    local revision_file="$3"
    # Remove empty lines from all text files
    find . -type f -name "*$file_extension_question" -exec sed -i '/^[[:space:]]*$/d' {} +
    # Find all text files and randomly select one
    local selected_file  # Declare the variable
    selected_file=$(find . -type f -name "*$file_extension_question" -print | shuf -n 1)
    # Check if the selected file exists
    if [ -f "$selected_file" ]; then
        # Randomly select a non-empty short answer question from the selected file
        local selected_question  # Declare the variable
        selected_question=$(awk -v RS=';' 'BEGIN{srand();}{gsub(/^[[:space:]]+|[[:space:]]+$/, ""); if (length > 0 && $0 ~ /\(3 scores\)/) a[++n]=$0}END{if (n > 0) print a[int(rand()*n)+1]}' "$selected_file")
        # Check if selected question is not empty and contains non-whitespace characters
        if [[ -n "$selected_question" && "$selected_question" =~ [[:graph:]] ]]; then
            if [ ! -e "$revision_file" ]; then
                touch "$revision_file"
            fi
            # Output the selected question
                current_datetime=$(date)
            echo -e "\n\nQuestion selected on ${y}$current_datetime${t}:\n$selected_question\n"

            # Append the selected question to revision_file
            echo -e "$selected_question;" >> "$revision_file"

            if echo "$selected_question" | grep "Figure"; then
                echo "$selected_question" | grep -o '\bFigure[0-9]\+[^;]*\b' > ../../Figures/Chemistry/figures.txt
                sed -i -e '/^Figure/!d' -e '/^[[:space:]]*$/d' -e 's/^[[:space:]]*//;s/[[:space:]]*$//' ../../Figures/Chemistry/figures.txt
                # Change to the "Figures/Chemistry" directory
                cd ../../Figures/Chemistry || { echo "Failed to change to Figures/Chemistry"; return; }
                # Specify the path to the text file containing figure names
                text_file="figures.txt"
                # Read each line from the selected question and open the corresponding figure
                while IFS= read -r figure_prefix || [ -n "$figure_prefix" ]; do
                    # Use sed to edit the figure_prefix and store it in a temporary variable
                    edited_figure_prefix=$(echo "${figure_prefix}"* | sed 's/.*\(Figure.*\.jpg\).*$/\1/')
                    # Open the figure file using explorer.exe
                    explorer.exe "${edited_figure_prefix}"* > /dev/null 2>&1 &
                done < "$text_file"
                # Go back to the original directory
                cd ../../Revision/Chemistry || { echo "Failed to change back to the targeted directory \c"; exit 1; }
                # Remove the temporary file
                rm -f ../../Figures/Chemistry/figures.txt
            fi

            # Create a temporary file
            temp_file=$(mktemp)

            # Use grep to find lines matching the pattern and get their line numbers
            grep -n "$selected_question" "$selected_file" | awk -F: '{ print $1 }' > "$temp_file"

            # Use sed to delete lines by line numbers
            sed -i -e "$(sed 's/$/d/' "$temp_file")" "$selected_file"
            rm -f "$temp_file"

            # Check if the file is empty after deletion and remove it
            if [ ! -s "$selected_file" ] || [ -z "$(awk 'NF' "$selected_file")" ]; then
                rm "$selected_file"
            fi

            # Return to the original working directory
            popd > /dev/null || exit
            wait_for_a_key_press
            return
        else
                        echo -e "\n\nAll the available short answer questions have been attempted. ${g}Please try the remaining activities of integration${t}... \c"
            # Return to the original working directory
            popd > /dev/null || exit
            wait_for_a_key_press
            return
        fi
    else
        echo -e "\n\nAll the available questions have most likely been attempted. ${r}To confirm, try to find an activity of integration instead${t}...\c"
                wait_for_a_key_press
        popd > /dev/null || exit
        break
    fi
done
}

# Function to select and process a random activity of integration
process_random_aoi() {
    # Loop to ensure a valid, non-empty question is selected
    # Save the current working directory
    pushd . > /dev/null
    # Change to the specified directory
    cd "$question_directory" || exit
while true; do
    # Increment the attempt count
    ((attempts++))
    # Check if the maximum attempts are reached
    if ((attempts >= 100))
     then
        exit 1
    fi
    local question_directory="$1"
    local file_extension_question="$2"
    local revision_file="$3"
    # Remove empty lines from all text files
    find . -type f -name "*$file_extension_question" -exec sed -i '/^[[:space:]]*$/d' {} +
    # Find all text files and randomly select one
    local selected_file  # Declare the variable
    selected_file=$(find . -type f -name "*$file_extension_question" -print | shuf -n 1)
    # Check if the selected file exists
    if [ -f "$selected_file" ]; then
        # Randomly select a non-empty activity of integration from the selected file
        local selected_question  # Declare the variable
                selected_question=$(awk -v RS=';' 'BEGIN{srand();}{gsub(/^[[:space:]]+|[[:space:]]+$/, ""); if (!(length == 0 || $0 ~ /\(3 scores\)/)) a[++n]=$0}END{if (n > 0) print a[int(rand()*n)+1]}' "$selected_file")
        # Check if selected question is not empty and contains non-whitespace characters
        if [[ -n "$selected_question" && "$selected_question" =~ [[:graph:]] ]]; then
            if [ ! -e "$revision_file" ]; then
                touch "$revision_file"
            fi
            echo -e "\n\nYou are advised to follow the ${r}answering format${t} and have your activity ${g}marked${t} by your teacher.\c"
            wait_for_a_key_press

            # Output the selected question
         	current_datetime=$(date)
            echo -e "\n\nQuestion selected on ${y}$current_datetime${t}:\n$selected_question\n"
            # Append the selected question to revision_file
            echo -e "$selected_question;" >> "$revision_file"

            if echo "$selected_question" | grep "Figure"; then
                echo "$selected_question" | grep -o '\bFigure[0-9]\+[^;]*\b' > ../../Figures/Chemistry/figures.txt
                sed -i -e '/^Figure/!d' -e '/^[[:space:]]*$/d' -e 's/^[[:space:]]*//;s/[[:space:]]*$//' ../../Figures/Chemistry/figures.txt
                # Change to the "Figures/Chemistry" directory
                cd ../../Figures/Chemistry || { echo "Failed to change to Figures/Chemistry"; return; }
                # Specify the path to the text file containing figure names
                text_file="figures.txt"
                # Read each line from the selected question and open the corresponding figure
                while IFS= read -r figure_prefix || [ -n "$figure_prefix" ]; do
                    # Use sed to edit the figure_prefix and store it in a temporary variable
                    edited_figure_prefix=$(echo "${figure_prefix}"* | sed 's/.*\(Figure.*\.jpg\).*$/\1/')
                    # Open the figure file using explorer.exe
                    explorer.exe "${edited_figure_prefix}"* > /dev/null 2>&1 &
                done < "$text_file"
                # Go back to the original directory
                cd ../../Revision/Chemistry || { echo "Failed to change back to the targeted directory \c"; exit 1; }
                # Remove the temporary file
                rm -f ../../Figures/Chemistry/figures.txt
            fi

            # Create a temporary file
            temp_file=$(mktemp)

            # Use grep to find lines matching the pattern and get their line numbers
            grep -n "$selected_question" "$selected_file" | awk -F: '{ print $1 }' > "$temp_file"

            # Use sed to delete lines by line numbers
            sed -i -e "$(sed 's/$/d/' "$temp_file")" "$selected_file"
            rm -f "$temp_file"

            # Check if the file is empty after deletion and remove it
            if [ ! -s "$selected_file" ] || [ -z "$(awk 'NF' "$selected_file")" ]; then
                rm "$selected_file"
            fi

            # Return to the original working directory
            popd > /dev/null || exit
            wait_for_a_key_press
            return
                else
                        echo -e "\n\nAll the available activities of integration have been attempted. ${g}Please try the remaining short answer questions${t}... \c"
            # Return to the original working directory
            popd > /dev/null || exit
            wait_for_a_key_press
            return
        fi
    else
        echo -e "\n\nNo more available questions to attempt. ${g}Opening attempted questions in the text editor${t}...\c"
                wait_for_a_key_press
                original_directory=$(pwd)
                directory_path=$(dirname "$revision_file")
                file_name=$(basename "$revision_file")

                # Change to the directory of the file
                if cd "$directory_path"; then

                        notepad.exe "$file_name" > /dev/null 2>&1

                    # Return to the original directory
                    cd "$original_directory"
                else
                    # If cd fails, return to the original directory
                    cd "$original_directory"
                    echo "Failed to change to the specified directory."
                fi
                echo -e "\n"
        popd > /dev/null || exit
        break
    fi
done
}

# Function to display a random success message
display_success_message() {
    # Array of echo statements for success
    local echo_success=(
        "You got that right!"
        "Well done!"
        "That's correct"
        "Great job darling!"
        "You really nailed that!"
        "Excellent!"
        "Bravo, champ!"
        "Amazing!"
        "Fantastic!"
        "Perfect!"
        "Superb!"
        "Impressive!"
        "Quite outstanding!"
        "Marvelous!"
        "Wonderful!"
        "You got that spot on!"
        "You are an angel!"
        "You're absolutely right!"
        "Awesome!"
        "You are a star!"
        "Keep shining!"
        "That's remarkable!"
        "Excellent!"
        "Magnificent!"
        "You won!"
        "That's top-notch!"
        "You nailed that!"
        "That's it!"
        "You're on fire!"
        "That's wonderful!"
        "Brilliant!"
        "That's cool!"
        "You did it!"
        "I knew you could do it!"
        "Proud of you!"
        "High five!"
        "That's the spirit!"
        "You're unstoppable!"
        "You are the icing on the cake!"
        "Is there anything you can't do?"
        "Watch out world, here you come!"
        "That's great!"
        "That's incredible!"
        "You're a rockstar!"
        "You're a genius!"
        "You're phenomenal!"
        "You're the best!"
        "You're a legend!"
        "You're a true talent!"
        "You're making waves!"
        "You're a real pro!"
        "You're dynamite!"
        "You're the epitome of excellence!"
        "You're a force to be reckoned with!"
        "You're a class act!"
        "You're the cream of the crop!"
        "You're a powerhouse!"
        "You're the MVP!"
        "You're one in a million!"
        "You're a champion!"
        "You're the real deal!"
        "You're second to none!"
        "You're the crème de la crème!"
        "You're in a league of your own!"
        "You're the crowning glory!"
        "You're a beacon of excellence!"
        "You're truly exceptional!"
        "You're a true standout!"
        "You're a true asset!"
        "You're destined for greatness!"
        "You're a living success story!"
        "You're a wealth of insight!"
        "Woooow!"
    )

    # Get a random index for success messages
    local random_index=$((RANDOM % ${#echo_success[@]}))

    # Select and display the success message
    echo -e "\n\n${g}${echo_success[random_index]}${t} \c"
}


# Function to display a random failure message
display_failure_message() {
    # Array of echo statements for failure
    local echo_fail=(
        "Oops! You missed that one!"
        "Quite the opposite!"
        "You got that wrong!"
        "Sorry, that's wrong!"
        "That's not true!"
        "Unfortunately you are wrong!"
        "You just failed that!"
        "That's incorrect!"
        "Oops! That's not it!"
        "Nope, that's not it!"
    )
        # Get a random index for failure messages
        random_index=$((RANDOM % ${#echo_fail[@]}))

        # Select and display the failure message
        echo -e "\n\n${g}${echo_fail[random_index]}${t} \c"
}


# Function to select and process a random question with an answer
process_question_answer() {
    # Save the current working directory
    pushd . > /dev/null
    # Change to the specified directory
    cd "$answered_directory" || exit
    # Initialize the score
    score=0
    total_questions=0
        max_questions=10

        while true; do
        local answered_directory="$1"
        local file_extension_answer="$2"
        local exercise_file="$3"
        # Increment the attempt count
        ((attempts++))
        # Check if the maximum attempts are reached
        if ((attempts >= 100))
        then
            echo -e "\n\nSorry that took quite long... ${r}Exiting${t}... ${g}Please try atleast two more times${t} \c"
            exit 1
        fi
        # Remove empty lines from all text files
        find . -type f -name "*$file_extension_answer" -exec sed -i '/^[[:space:]]*$/d' {} +
        ls *.ans.txt > rvsn.txt
        sed -i -e 's/\.ans\.txt//g' -e 's/_/ /g' -e 's/\([0-9]\+\)\.\([0-9]\+\)\./\2. /g' -e 's/^\([^a-zA-Z]*\)\([a-zA-Z]\)/\1\U\2/' rvsn.txt
        echo -e "\n\n"${y}Below is a list of chapters available for revision${t}" \n"
        cat rvsn.txt
        read -rp $'\n\nEnter a '"${m}Specific${t}"' chapter number or press '"${r}Enter${t}"' to get a random chapter'$'\n> ' input
        if [[ -n $input ]]; then
	        selected_file=$(ls | grep -E "[0-9]+\.${input}\." | grep -v "_cp")
        else
            # Find all text files and randomly select one
            local selected_file  # Declare the variable
            selected_file=$(find . -type f -name "*$file_extension_answer" -size +0 -print | shuf -n 1)
        fi
        # Check if the selected file exists
        if ! [ -f "$selected_file" ]; then
            echo -e "\n\nYou answered all the available questions. ${g}Opening them alongside their answers in the text editor${t}... \c"
                        wait_for_a_key_press
                        original_directory=$(pwd)
                        directory_path=$(dirname "$exercise_file")
                        file_name=$(basename "$exercise_file")

                        # Change to the directory of the file
                        if cd "$directory_path"; then

                                notepad.exe "$file_name" > /dev/null 2>&1

                            # Return to the original directory
                            cd "$original_directory"
                        else
                            # If cd fails, return to the original directory
                            cd "$original_directory"
                            echo "Failed to change to the specified directory."
                        fi
            echo -e "\n"
            popd > /dev/null || exit
            break 2
        fi
        # Loop to ensure a valid, non-empty question is selected
        # Record the start time
        start_time=$(date +%s)
        echo -e "\n\nIf possible, ${c}please discuss the selected questions in the quiz below in your groups to come to a${t} ${r}single conclusion${t} \c"
        while [ "$total_questions" -lt "$max_questions" ]; do
            if [ -f "$selected_file" ]; then
                # Randomly select a non-empty question from the selected file
                local selected_question  # Declare the variable
                selected_question=$(awk -v RS=';' 'BEGIN{srand();}{gsub(/^[[:space:]]+|[[:space:]]+$/, ""); if (length > 0 && $0 !~ /answered/) a[++n]=$0}END{if (n > 0) print a[int(rand()*n)+1]}' "$selected_file")
                # Check if selected question is not empty and contains non-whitespace characters
                if [[ -n "$selected_question" && "$selected_question" =~ [[:graph:]] ]]; then
                    if [ ! -e "$exercise_file" ]; then
                        touch "$exercise_file"
                    fi
                    # Output the selected question with a new line after each 'opening ('
                    clear_and_center "${b}Selected Question${t}:\n\n\c"
                    echo "${selected_question//(/$'\n'}"

                    if echo "$selected_question" | grep -q "Figure"; then
                        echo "$selected_question" | grep -o '\bFigure[0-9]\+[^;]*\b' > ../../../Figures/Chemistry/figures.txt
                        sed -i -e '/^Figure/!d' -e '/^[[:space:]]*$/d' -e 's/^[[:space:]]*//;s/[[:space:]]*$//' ../../../Figures/Chemistry/figures.txt

                        # Save the current working directory
                        pushd . > /dev/null
                        # Change to the "Figures/Chemistry" directory
                        cd ../../../Figures/Chemistry || { echo "Failed to change to Figures/Chemistry"; return; }
                        # Specify the path to the text file containing figure names
                        text_file="figures.txt"

                        while IFS= read -r figure_prefix || [ -n "$figure_prefix" ]; do
                            # Use sed to edit the figure_prefix and store it in a temporary variable
                            edited_figure_prefix=$(echo "$figure_prefix." | sed 's/.*\(Figure.*\.jpg\).*$/\1/')
                            # Open the figure file using explorer.exe
                            explorer.exe "${edited_figure_prefix}"* > /dev/null 2>&1 &
                        done < "$text_file"

                        # Remove the temporary file
                        rm -f figures.txt
                        # Go back to the original directory
                        popd > /dev/null || { echo "Failed to change back to the targeted directory \c"; exit 1; }



                            fi

                    # Create a temporary file
                    temp_file=$(mktemp)
                                        # Trap the EXIT signal to delete the temporary file on script exit
                                        trap 'rm -f "$temp_file"' EXIT
                    # Use grep to find lines matching the pattern and get their line numbers
                                        grep -n "$selected_question" "$selected_file" | awk -F: '{ print $1 }' > "$temp_file"

                    # Read the line number from the temporary file
                    read -r line_number < "$temp_file"

                                        # Check if the selected question contains the pattern (a)
                                        if [[ "$selected_question" =~ \(a\) ]]; then
                                                # Determine the selected index based on the line number
                                                selected_index=$(( (line_number - 1) % 4 ))
                                                # Use a case statement to map the index to the corresponding character
                                                case $selected_index in
                                                    0) selected_character='a' ;;
                                                    1) selected_character='b' ;;
                                                    2) selected_character='c' ;;
                                                    3) selected_character='d' ;;
                                                esac
                                        else
                                                # Check if the line number is even
                                                if ((line_number % 2 == 0)); then
                                                        selected_character=y
                                                else
                                                    selected_character=n
                                                fi
                                        fi

                    # Prompt the user for an answer and convert it to lowercase
                    # Initialize the score for each question
                    local score_per_question=0
                    while true; do
                        if [[ "$selected_question" =~ \(a\) ]]; then
                                                        read -rp $'\n'"${b}Your answer${t}"' '"${r}(a/b/c/d)${t}"' : ' user_answer
                                                else
                                                        read -rp $'\n'"${b}Your answer${t}"' '"${r}(y/n)${t}"' : ' user_answer
                                                fi
                        user_answer=${user_answer,,}  # Convert to lowercase
                        if [[ -n "$user_answer" ]]; then
                            if [ "$selected_character" = "$user_answer" ]; then
                                ((score_per_question++))
                                # Call the function to display a random success message
                                display_success_message
                            else
                                if ([ "$selected_character" = "y" ] && [ "$user_answer" = "n" ]) || ([ "$selected_character" = "n" ] && [ "$user_answer" = "y" ]); then
                                    # Call the function to display a random failure message
                                    echo -en "\007" && display_failure_message
                                else
                                    echo -en "\007"
                                    echo -e "\n\n${r}Not quite right!${t} The answer is ""${g}""$selected_character""${t}"": \c"
                                fi
                            fi

                            # Update the total score
                            ((score += score_per_question))

                            # Increment total_questions
                            ((total_questions++))

                            # Display the current score
                            echo -e "Your current score is: $score \c"
                        else
                            echo -e "\nInput is empty. Please provide an answer \n\c"
                            continue
                        fi
                        break
                    done

                    # Append the selected question to the exercise_file
                    echo -e "$selected_question; $selected_character" >> "$exercise_file"
                    # Use sed to substitute lines by line numbers
                                        sed -i -e "$(sed 's|$|s/.*/answered;/|' "$temp_file")" "$selected_file"
                    rm -f "$temp_file"
                                        # Check if all remaining non-empty lines have the pattern "answered;" and remove the file
                                        if awk '!/^$/ && $0 !~ /^answered;$/ { exit 1 }' "$selected_file"; then
                                            rm "$selected_file"
                                        fi
                fi
            else
                break
            fi
        done
        wait_for_a_key_press
        echo -e "\n\nOhh! ${b}Finally!${t} You got this covered \c"
        # Calculate percentage based on total_score and total_questions
        percentage=$((score * 100 / total_questions))
        if [ "$percentage" -lt 80 ]; then
             cd ../..
             wscript.exe //nologo sound1.vbs &
             cd - > /dev/null 2>&1 || exit
        else
             cd ../..
             wscript.exe //nologo sound.vbs &
             cd - > /dev/null 2>&1 || exit
        fi
        # Record the end time
        end_time=$(date +%s)
        # Calculate and print the elapsed time
        elapsed_time=$((end_time - start_time))
        # Convert elapsed time from seconds to minutes and seconds
        minutes=$((elapsed_time / 60))
        seconds=$((elapsed_time % 60))
        if [ $minutes -gt 0 ] && [ $seconds -gt 0 ]; then
            converted_time="${minutes}min ${seconds}s"
        else
            converted_time="${seconds}s"
        fi
        wait_for_a_key_press
        echo -e "\n\nYou have used ${b}$converted_time${t} to answer ${y}$total_questions qns${t} and your ${b}total score${t} out of $total_questions is: ${r}$score ($percentage%)${t} \c"
        if [ -f ../../../.school_name ]; then
            read -r school_name < ../../../.school_name
            school_name="${school_name// /_}"
            touch ../../../."$school_name"_students_file.txt
            sed -i '/^[[:space:]]*$/d' ../../../."$school_name"_students_file.txt
            existing_class=$(awk '{print $1}' ../../../.chemistry_user_state)
            existing_topic=$(awk '{print $2}' ../../../.chemistry_user_state)
            echo ''
            if replace_prompt  'By just pressing Enter, the obtained score will be allocated to every recorded student... If otherwise, enter your Initial(s) (space-separated) to label the score' replacement; then
                replacement=${replacement^^}  # Convert to uppercase
                names="($replacement) "
            else
                names=''
            fi
            if grep -q "Chemistry" ../../../."$school_name"_students_file.txt; then
                sed -i -E 's/;/\n/g' ../../../."$school_name"_students_file.txt
                # Find the line with the word Chemistry, replace the information below it with the already available information adding a comma existing_class_existing_topic [$percentage]
                if [ "$existing_topic" == "r" ]; then
                    sed -i '/Chemistry/{n;s/\(.*\)/\1, '"$existing_class"' '"$names"'['"$percentage%"']/}' ../../../."$school_name"_students_file.txt
                else
                    (( existing_topic-- ))
                    sed -i '/Chemistry/{n;s/\(.*\)/\1, '"$existing_class"'_'"$existing_topic"' '"$names"'['"$percentage%"']/}' ../../../."$school_name"_students_file.txt
                fi
            else
                if [ "$existing_topic" == "r" ]; then
                    sed -i -E '/^School/ i\Chemistry\n'"${existing_class} ${names}[${percentage}%]"'' ../../../."$school_name"_students_file.txt
                    echo -e "Chemistry\n"$existing_class" "$names"["$percentage%"]" >> ../../../."$school_name"_students_file.txt
                else
                    (( existing_topic-- ))
                    sed -i -E '/^School/ i\Chemistry\n'"${existing_class}_${existing_topic} ${names}[${percentage}%]"'' ../../../."$school_name"_students_file.txt
                    echo -e "Chemistry\n"$existing_class"_"$existing_topic" "$names"["$percentage%"]" >> ../../../."$school_name"_students_file.txt
                fi
                    sed -i '1,2s/.*//g' ../../../."$school_name"_students_file.txt
                    sed -i '/^[[:space:]]*$/d' ../../../."$school_name"_students_file.txt
            fi
            sed -i -e ':a;N;$!ba;s/\n/;/g' ../../../."$school_name"_students_file.txt
            sed -i -E 's/;School/\nSchool/g' ../../../."$school_name"_students_file.txt
            echo -e "\n\nThe obtained score has been recorded and allocated accordingly... \c"
        else
            echo -e "\n\nThe obtained score has not been recorded... Please visit topic options on the next visit and select the option to provide student details \c"
        fi
        wait_for_a_key_press
        # If the total score is below 80, prompt the user to retry
        if [ "$percentage" -lt 80 ]; then
            echo -e "\n\nGiven your score, ${r}let's see if there are more questions for you${t} \c"
            wait_for_a_key_press
            # Check if the are more files
                        if find . -maxdepth 2 -type f -name "*$file_extension_answer" | grep -q .; then
                echo -e "\n\n${r}Perfect!${t}. You still have questions! ${y}All the best dear one${t} \c"
                score=0
                total_questions=0
                max_questions=10
                        else
                                echo -e "\n\nYou are all ${r}good${t}. Questions are done! ${y}All the best dear one${t}. ${g}Opening answered questions alongside their answers in the text editor${t}...\c"
                wait_for_a_key_press
                                original_directory=$(pwd)
                                directory_path=$(dirname "$exercise_file")
                                file_name=$(basename "$exercise_file")

                                # Change to the directory of the file
                                if cd "$directory_path"; then

                                notepad.exe "$file_name" > /dev/null 2>&1

                                    # Return to the original directory
                                    cd "$original_directory"
                                else
                                    # If cd fails, return to the original directory
                                    cd "$original_directory"
                                    echo "Failed to change to the specified directory."
                                fi
                echo -e "\n"
                popd > /dev/null || exit
                break 2
            fi
        else
            echo -e "\n\n${g}Congratulations!${t} You have successfully completed the quiz! \c"
            wait_for_a_key_press
            read -rp $'\n\nDo you want to try other questions? '"${r}(y/n)${t}"': ' retry_input
            if [ "${retry_input,,}" != "yes" ] && [ "${retry_input,,}" != "y" ]; then
                echo -e "\n\nYou never entered y or yes... ${y}Returning to your session${t}\n"
                popd > /dev/null || exit
                wait_for_a_key_press
                break 2
            else
                                if find . -maxdepth 2 -type f -name "*$file_extension_answer" | grep -q .; then
                        echo -e "\n\n${r}Perfect!${t}. You still have questions! ${y}All the best dear one${t} \c"
                    score=0
                    total_questions=0
                    max_questions=10
                                else
                                        echo -e "\n\nYou are all ${r}good${t}. Questions are done! ${y}All the best dear one${t}. ${g}Opening answered questions alongside their answers in the text editor${t}...\c"
                                wait_for_a_key_press
                                        original_directory=$(pwd)
                                        directory_path=$(dirname "$exercise_file")
                                        file_name=$(basename "$exercise_file")

                                        # Change to the directory of the file
                                        if cd "$directory_path"; then

                                                notepad.exe "$file_name" > /dev/null 2>&1

                                            # Return to the original directory
                                            cd "$original_directory"
                                        else
                                            # If cd fails, return to the original directory
                                            cd "$original_directory"
                                            echo "Failed to change to the specified directory."
                                        fi
                                echo -e "\n"
                                popd > /dev/null || exit
                    break 2
                fi
            fi
        fi
    done
}

# Function to check the state file and resume from the last point
function resume_from_last_point() {
    if [ -f .chemistry_user_state ]; then
        last_class=$(awk -F' ' '{print $1}' .chemistry_user_state)
        last_topic=$(awk -F' ' '{print $2}' .chemistry_user_state)
                if [ -n "$last_class" ] && [ -n "$last_topic" ]; then
            echo -e "\n              Resuming from ${r}S$last_class${t} : ${g}Topic '$last_topic'${t} \c"
            rm -f .chemistry_surveyor
            clear_and_center "          ..........    Resumed from ${g}Topic $last_topic${t} (${r}S$last_class${t})    ............"
            return 0
        elif [ -n "$last_class" ] && [ -z "$last_topic" ]; then
                        echo -e "\nTaking you to ${r}class selection${t} \c"
            wait_for_a_key_press
            return 0
        elif [ -z "$last_class" ] && [ -z "$last_topic" ]; then
                        return 0
                else
            echo -e "\n${b}Unable to track your last point${t}. Starting from the beginning... \c"
                        wait_for_a_key_press
            return 1
        fi
    else
        echo -e "\n${b}Starting from the very beginning of this tutorial... \c"
        wait_for_a_key_press
        return 1
    fi
}

# Function to handle user input for resuming
function handle_resume_input() {
    # Check if the user wants to resume from the last point
    clear_and_center "${r}\n\n            Equitable, Relevant, and Quality Education for All${t}\n\n\n            ${m}Your Education is our Future${t} -------- ${g}Never despair${t}"
    read -rp $'\n\n\n   '"${y}Press Enter to resume from your last point. Otherwise, enter${t}"' (no or n) : ' resume_choice
    resume_choice=${resume_choice,,}  # Convert to lowercase
    if ! [[ "$resume_choice" == "no" || "$resume_choice" == "n" ]]; then
        rm -f .chemistry_topic_selected
        if resume_from_last_point; then
            # User wants to resume
            class=$last_class
            topic=$last_topic
        fi
        else
                touch .chemistry_surveyor
    fi
}

# Function to select and process random questions with answers
process_final_assignment() {
    # Check if .current_chemistry_class is accidentally empty
    if [ ! -s .current_chemistry_class ]; then
        # Echo 1 to .current_chemistry_class
        echo "1" > .current_chemistry_class
    fi
    # Read the value from the .current_chemistry_class file
    current_chemistry_class=$(<.current_chemistry_class) 2>/dev/null
    # Check if the value in the .chemistry_ready file is equal to $class
    # Read the value from the .chemistry_ready file
    if [ ! -s .chemistry_ready ]; then
        echo "0" > .chemistry_ready
    fi
    how.chemistry_ready=$(<.chemistry_ready) 2>/dev/null
    # Check if the value is equal to $class
    if [ "$how.chemistry_ready" -lt "$current_chemistry_class" 2>/dev/null ]; then
        read -rp $'\n\nYou havent done all the topic assignments for your current chemistry class\n\n'"${r}Proceeding from here will affect your very final score${y}"'. To go back and progress right, enter '"${y}ok${t}"'. Otherwise, press the Enter key to do the final class assignment: ' progress
        if [ "$progress" == "ok" ]; then
            return
        fi
    fi
    echo -e "\n\n${y}You are welcome to your final class session.${t}\n\n${r}You will have to use a maximum of 3600s (1hr) to obtain a minimum of 95 scores by answering 100 questions, @ carrying 1 score!${t}\n\n${g}You must get that score to move on to the next class. We wish you the very best dear...${t} \c"
    # Save the current working directory
    pushd . > /dev/null
    # Change to the specified directory
    cd "$answered_directory" || exit
    # Initialize the score
    score=0
    total_questions=0
    max_questions=100
    while true; do
        local answered_directory="$1"
        local file_extension_answer="$2"
        local exercise_file="$3"
        # Increment the attempt count
        ((attempts++))
        # Check if the maximum attempts are reached
        if ((attempts >= 100))
        then
            echo -e "\n\nSorry that took quite long... ${r}Exiting${t}... ${g}Please try atleast two more times${t} \c"
            exit 1
        fi
        if [ -s ../../chemistry_answered_ans.txt ]; then
            # Specify the temporary file name within the current working directory
            cpd="./cpd.txt"
            # Copy answered questions to the temporary file
            cp ../../chemistry_answered_ans.txt "$cpd"
            sed -i 's/\(.*\)\(.\)$/\2\1/' "$cpd"
        fi
        # Remove empty lines from all text files
        find . -type f \( -name "*$file_extension_answer" -o -name "cpd.txt" \) -exec sed -i '/^[[:space:]]*$/d' {} +
        # Find all text files and randomly select one
        local selected_file  # Declare the variable
        # Find all text files and the dynamically generated temporary file, then randomly select one
        selected_file=$(find . -type f \( -name "*$file_extension_answer" -o -name "cpd.txt" \) -size +0 -print | shuf -n 1)
        # Check if the selected file exists
        if ! [ -f "$selected_file" ]; then
            echo -e "\n\n${r}Your learning material has most likely been interfered with.${t}\nTo proceed, you will need fresh learning material from UNEB.\n${g}Returning to your current session...${t} \c"
            wait_for_a_key_press
            popd > /dev/null || exit
            break 2
        fi
        # Loop to ensure a valid, non-empty question is selected
        # Record the start time
        start_time=$(date +%s)
        while [ "$total_questions" -lt "$max_questions" ]; do
        selected_file=$(find . -type f \( -name "*$file_extension_answer" -o -name "cpd.txt" \) -size +0 -print | shuf -n 1)
            if [ -f "$selected_file" ]; then
                # Randomly select a non-empty question from the selected file
                local selected_question  # Declare the variable
                selected_question=$(awk -v RS=';' 'BEGIN{srand();}{gsub(/^[[:space:]]+|[[:space:]]+$/, ""); if (length > 0 && $0 !~ /answered/) a[++n]=$0}END{if (n > 0) print a[int(rand()*n)+1]}' "$selected_file")
                # Check if selected question is not empty and contains non-whitespace characters
                if [[ -n "$selected_question" && "$selected_question" =~ [[:graph:]] ]]; then
                    if [ ! -e "$exercise_file" ]; then
                        touch "$exercise_file"
                    fi
                    # Output the selected question with a new line after each 'opening ('
                    clear_and_center "${b}Selected Question${t}:\n\n\c"
                    if grep -q "cpd" <<< "$selected_file"; then
                            echo "${selected_question:1}"
                    else
                        echo "${selected_question//(/$'\n'}"
                    fi

                    if echo "$selected_question" | grep -q "Figure"; then
                        echo "$selected_question" | grep -o '\bFigure[0-9]\+[^;]*\b' > ../../../Figures/Chemistry/figures.txt
                        sed -i -e '/^Figure/!d' -e '/^[[:space:]]*$/d' -e 's/^[[:space:]]*//;s/[[:space:]]*$//' ../../../Figures/Chemistry/figures.txt

                        # Save the current working directory
                        pushd . > /dev/null
                        # Change to the "Figures/Chemistry" directory
                        cd ../../../Figures/Chemistry || { echo "Failed to change to Figures/Chemistry"; return; }
                        # Specify the path to the text file containing figure names
                        text_file="figures.txt"

                        while IFS= read -r figure_prefix || [ -n "$figure_prefix" ]; do
                            # Use sed to edit the figure_prefix and store it in a temporary variable
                            edited_figure_prefix=$(echo "$figure_prefix." | sed 's/.*\(Figure.*\.jpg\).*$/\1/')
                            # Open the figure file using explorer.exe
                            explorer.exe "${edited_figure_prefix}"* > /dev/null 2>&1 &
                        done < "$text_file"

                        # Remove the temporary file
                        rm -f figures.txt
                        # Go back to the original directory
                        popd > /dev/null || { echo "Failed to change back to the targeted directory \c"; exit 1; }
                    fi
                    # Create a temporary file
                    temp_file=$(mktemp)
                    # Trap the EXIT signal to delete the temporary files on script exit
                    trap 'rm -f cpd.txt; rm -f "$temp_file"' EXIT
                    # Use grep to find lines matching the pattern and get their line numbers
                    grep -n "$selected_question" "$selected_file" | awk -F: '{ print $1 }' > "$temp_file"
                    # Read the line number from the temporary file
                    read -r line_number < "$temp_file"

                    if grep -q "cpd" <<< "$selected_file"; then
                        selected_character=$(echo "$selected_question" | cut -c1)
                    else
                        # Check if the selected question contains the pattern (a)
                        if [[ "$selected_question" =~ \(a\) ]]; then
                            # Determine the selected index based on the line number
                            selected_index=$(( (line_number - 1) % 4 ))
                            # Use a case statement to map the index to the corresponding character
                            case $selected_index in
                                0) selected_character='a' ;;
                                1) selected_character='b' ;;
                                2) selected_character='c' ;;
                                3) selected_character='d' ;;
                            esac
                        else
                            # Check if the line number is even
                            if ((line_number % 2 == 0)); then
                                selected_character=y
                            else
                                selected_character=n
                            fi
                        fi
                    fi
                    # Prompt the user for an answer and convert it to lowercase
                    # Initialize the score for each question
                    local score_per_question=0
                    while true; do
                        if [[ "$selected_question" =~ \(a\) ]]; then
                                read -rp $'\n'"${b}Your answer${t}"' '"${r}(a/b/c/d)${t}"' : ' user_answer
                        else
                            read -rp $'\n'"${b}Your answer${t}"' '"${r}(y/n)${t}"' : ' user_answer
                        fi
                        user_answer=${user_answer,,}  # Convert to lowercase
                        if [[ -n "$user_answer" ]]; then
                            if [ "$selected_character" = "$user_answer" ]; then
                                ((score_per_question++))
                                # Call the function to display a random success message
                                display_success_message
                            else
                                if ([ "$selected_character" = "y" ] && [ "$user_answer" = "n" ]) || ([ "$selected_character" = "n" ] && [ "$user_answer" = "y" ]); then
                                    # Call the function to display a random failure message
                                    echo -en "\007" && display_failure_message
                                else
                                    echo -en "\007"
                                    echo -e "\n\n${r}Not quite right!${t} The answer is ""${g}""$selected_character""${t}"": \c"
                                fi
                            fi

                            # Update the total score
                            ((score += score_per_question))

                            # Increment total_questions
                            ((total_questions++))

                            # Display the current score
                            echo -e "Your current score is: $score \c"
                        else
                            echo -e "\nInput is empty. Please provide an answer \n\c"
                            continue
                        fi
                        break
                    done

                    if ! grep -q "cpd" <<< "$selected_file"; then
                        # Append the selected question to the exercise_file
                        echo -e "$selected_question; $selected_character" >> "$exercise_file"
                    fi
                    # Use sed to substitute lines by line numbers
                    sed -i -e "$(sed 's|$|s/.*/answered;/|' "$temp_file")" "$selected_file"
                    rm -f "$temp_file"
                    # Check if all remaining non-empty lines have the pattern "answered;" and remove the file
                    if awk '!/^$/ && $0 !~ /^answered;$/ { exit 1 }' "$selected_file"; then
                        rm "$selected_file"
                    fi
                fi
            else
                break
            fi
        done
        wait_for_a_key_press
        if ! [ "$total_questions" == 100 ]; then
            echo -e "\n\n${r}Sorry about this, your learning material had most likely been interfered with before this session.${t}\nTo proceed, you will need fresh learning material from UNEB.\n${g}Displaying your current progress...${t} \c"
            # Record the end time
            end_time=$(date +%s)
            # Calculate and print the elapsed time
            elapsed_time=$((end_time - start_time))
            # Convert elapsed time from seconds to minutes and seconds
            minutes=$((elapsed_time / 60))
            seconds=$((elapsed_time % 60))
            if [ $minutes -gt 0 ] && [ $seconds -gt 0 ]; then
                converted_time="${minutes}min ${seconds}s"
            else
                converted_time="${seconds}s"
            fi
            # Calculate percentage based on total_score and total_questions
            percentage=$((score * 100 / total_questions))
            wait_for_a_key_press
            echo -e "\n\nYou have used ${b}$converted_time${t} to answer ${y}$total_questions qns${t} and your ${b}total score${t} out of $total_questions is: ${r}$score ($percentage%)${t} \c"
            wait_for_a_key_press
            popd > /dev/null || exit
            break 2
        else
        # Record the end time
        end_time=$(date +%s)
        # Calculate and print the elapsed time
        elapsed_time=$((end_time - start_time))
        # Calculate percentage based on total_score and total_questions
        percentage=$((score * 100 / total_questions))
            if [ "$elapsed_time" -gt 3600 ]; then
                    echo -e "\n\nYou have used ${b}$elapsed_time seconds${t} to answer ${y}$total_questions questions${t} and your ${b}total score${t} out of $total_questions is: ${r}$score ($percentage%)${t} \c"
                    wait_for_a_key_press
                    echo -e "\n\nGiven the time you took, ${r}You will have to try just one more time!${t} \c"
                    score=0
                    total_questions=0
                    max_questions=100
            else
                echo -e "\n\nOhh! ${b}Finally!${t} You got this covered in time... \c"
                    wait_for_a_key_press
                    echo -e "\n\nYou have used ${b}$elapsed_time seconds${t} to answer ${y}$total_questions questions${t} and your ${b}total score${t} out of $total_questions is: ${r}$score ($percentage%)${t} \c"
                    wait_for_a_key_press
                    # If the total score is below 95, prompt the user to retry
                if [ "$percentage" -lt 95 ]; then
                        echo -e "\n\nGiven your score, ${r}You will have to try just one more time!${t} \c"
                        score=0
                        total_questions=0
                        max_questions=100
                    else
                        popd > /dev/null || exit
                        cd ../..
                        wscript.exe //nologo sound2.vbs &
                        cd - > /dev/null 2>&1 || exit
                        if ! [ -f .current_chemistry_class ]; then
                            # Echo the result to the file .current_class
                            echo "2" > .current_chemistry_class
                            echo -e "\n\n${g}Congratulations!${t}  You have successfully gained access to the next class (S2).\n\nHowever, if a diferrent class was expected, then something is wrong.\n\nFrom here, you will have to go back to go back to S2 and acess the next classes the right way \c"
                            wait_for_a_key_press
                        else
                                # Add 1 to $class value
                                new_class=$(($class + 1))
                                # Read the value from the file
                                current_chemistry_class=$(<.current_chemistry_class) 2>/dev/null
                                # Check if the new_class value is lt $current_chemistry_class
                                if [ "$new_class" -gt "$current_chemistry_class" 2>/dev/null ]; then
                                # Echo the result to the file .current_class
                                echo "$new_class" > .current_chemistry_class
                                fi
                                echo -e "\n\n${g}Congratulations!${t} You have successfully gained access to the next class! \c"
                                wait_for_a_key_press
                        fi
                        echo -e "\n\nYou can now choose the next class from the available options... ${y}Returning to your current session${t} \c"
                        wait_for_a_key_press
                        break 2
                fi
            fi
        fi
    done
}

new_workspace() {
# Create the Students directory if it does not exist
mkdir -p Students
while true; do
    read -rp $'\n\nTo create a '"${y}new workspace${t}"', enter unique '"${r}Initials${t}"''$'\n\n> ' initials
    # List directories in the Students folder and check for a match
    if ls Students | grep -wq "$initials"; then
        echo -e "\nThe provided initials are ${m}already${t} in use. Please choose other initials!"
    else
        mkdir "Students/$initials"
        cp -r Exercise Revision .gemini_api .openai_api *_wsl.sh "Students/$initials"
        echo -e "                                    $initials\n" > "Students/$initials/Exercise/chemistry_answered_ans.txt"
        echo -e "                                    $initials\n" > "Students/$initials/Revision/chemistry_covered_qns.txt"
        for file in "Students/$initials"/*.sh; do
            sed -i -e 's|Notes|../../Notes|g' -e 's|Videos|../../Videos|g' -e 's|Figures|../../Figures|g' -e 's|Students|../../Students|g' -e 's|Tables|../../Tables|g' -e 's#cd ../.. ||#cd - > /dev/null 2>\&1 ||#g' "$file"
            # Determining the correct path to the Desktop using the USERPROFILE environment variable
            desktop_path=""
            windows_userprofile=$(cmd.exe /C "cd /d %USERPROFILE% & echo %USERPROFILE%" 2>/dev/null | tr -d '\r')
            # Converting Windows path to WSL path
            windows_userprofile_wsl=$(wslpath -u "$windows_userprofile")
            if [ -d "$windows_userprofile_wsl/OneDrive/Desktop" ]; then
                desktop_path="$windows_userprofile_wsl/OneDrive/Desktop"
            else
                desktop_path="$windows_userprofile_wsl/Desktop"
            fi
            # Generating the batch file content
            echo -e "@echo off\nC:\\Windows\\System32\\wsl.exe -e bash -c '/home/omd/Omd/Students/$initials/${file##*/}'" > "$desktop_path/$initials $initials_${file##*/}.bat"
        done
        echo -e "\n\nBy default, ${y}new executable files${t} have been created and shortcuts named ("${g}"$initials"${t}") put on your desktop... \n"
        break
    fi
done
}

read -r key < .openai_api
export OPENAI_KEY="$key"

if [ ! -f .chemistry_user_state ]; then
	touch .chemistry_user_state
	touch .chemistry_surveyor
	echo -e "\n\nYou can search your Notes by topic using uppercase letters or just feed in key words \c"
	get_and_display_pattern
else
	process_random_reminder .chemistry_reminder
	handle_resume_input
fi

if [ -z "$class" ] && [ -s ".chemistry_user_state" ]; then
    echo -e "\n\nYou can search your Notes by topic using uppercase letters or just feed in key words \c"
    get_and_display_pattern
fi
# Check for the presence of specific directories and a file
if ! [ -d "Notes" ] || ! [ -d "Revision" ] || ! [ -d "Exercise" ] || ! [ -d "Videos" ] || ! [ -d "Figures" ] || ! [ -d "Tables" ]; then
    echo -e "\n\nTo change to your desirable font, click on the three lines in the title bar of your terminal\nFrom the menu that appears, select properties\nSelect unnamed, check custom font, click on it and choose the size you’d like\nThen click select \c"
    wait_for_a_key_press
    clear_and_center
    read -rp $'\n\nTo get started, enter a preferably'"${r} short name${t}"' for the directory or folder you will use for this tutorial or press '"${r}x${t}"' to exit'$'\n\n> ' dir_name

    # Check if the user wants to exit
    if [[ "$dir_name" == "x" ]]; then
        quit
    fi

    # Validate the directory name
    while [[ -e "$dir_name" || -z "$dir_name" ]]; do
        echo -e "\n\nError: Either a directory or file ""${r}""$dir_name""${t}"" already exists or you pressed the Enter key\n\nPlease ensure you are following the instructions\c"

        # Increment the attempt count
        ((attempts++))

        # Check if the maximum attempts are reached
        if ((attempts >= 3)); then
            quit1
        fi

        # Prompt the user again
        read -rp $'\n\nTo get started, enter a preferably'"${r} short unique name${t}"' for the directory you will use for this tutorial or press '"${r}x${t}"' to exit'$'\n\n> ' dir_name

        # Check if the user wants to exit
        if [[ "$dir_name" == "x" ]]; then
            quit
        fi
    done
    # Create the directory
    mkdir -p "$dir_name" || exit
    echo -e "\nDirectory ${r}$dir_name${t} created successfully. ${y}Now, you can note down the name you provided and proceed with your tutorial${t} \c"
    wait_for_a_key_press
    clear_and_center "Please, remember to change to the directory created on your next visit;\n\n${r}Equally always remember to press ${r}control and c${t}together or just close the terminal to exit a class session\n\nIf nothing goes wrong, you will always be able to continue from where you stopped${b}"
    wait_for_a_key_press
    # Change to the created directory
    cd "$dir_name" || exit

    # Create additional directories and files
    mkdir -p Notes Notes/Chemistry Revision Revision/Chemistry Revision/Chemistry/{S1,S2,S3,S4} Exercise Exercise/Chemistry Exercise/Chemistry/{S1,S2,S3,S4} Videos Videos/Chemistry Figures Figures/Chemistry Tables Tables/Chemistry
    touch Revision/chemistry_covered_qns.txt Exercise/chemistry_answered_ans.txt
    echo -e "\n"
    pwd
    echo -e "\n\n${t}The displayed path above is the path to your directory, please note it down \c"
    wait_for_a_key_press
    echo -e "\n\n${y}Folders to store content generated have been created for you in the background and displayed below${t}${b} \c"
    echo -e "\n"
    ls "$PWD"
    wait_for_a_key_press
    echo -e "\n\n${t}For this tutorial, you will require current learning material from UNEB in your current folder or directory\n\notherwise follow the procedure below to obtain the material \c"
    cp ../chemistry_tutorial .
    clear_and_center
    echo
fi

files=(Notes/Chemistry/*.txt)
if [ ${#files[@]} -eq 0 ]; then
    read -rp $'\n\nTo get material for this tutorial, get your internet on and press the enter key or press any character key followed by the Enter key to exit: ' user_input

    if [[ -z "$user_input" ]]; then
        echo -e "\nYou pressed the ${r}Enter${t} key... Fetching learning material \n\n\c"

        if ! command -v curl &> /dev/null; then
            sudo apt-get update
            sudo apt-get install -y curl || { echo -e "\n\nError installing curl... You can install using sudo apt-get install curl \c"; exit 1; }
        fi

        sudo apt-get install -y jq
        pip install -q -U google-generativeai

        curl -sS https://raw.githubusercontent.com/0xacx/chatGPT-shell-cli/main/install.sh | sudo -E bash > /dev/null 2>&1

        curl -O -L https://github.com/Muhumuza7325/Muhumuza7325/raw/main/1.1.chemistry_and_society.txt || echo -e "\n\nError fetching material for this tutorial \c"

        echo -e "\n\nYou got the first step covered.\n\nAs you progress, please, do all the available assignments as they will contribute to your final score.\n\nYou can get somewhere to write and we start \c"
        cp 1.1.chemistry_and_society.txt Notes/Chemistry || echo -e "\n\nError copying 1.1.chemistry_and_society.txt to the Chemistry directory in the Notes directory \c"
        wait_for_a_key_press
    else
        wait_for_a_key_press
        quit
    fi
else
    rm -f ../chemistry_tutorial 1.1.chemistry_and_society.txt
fi

while true; do

    handle_class_input

    if [[ "$class" == "1" ]]; then

        if ! find . -maxdepth 1 -name '.s_chemistry_1*' -type f -quit 2>/dev/null; then
            echo -e "\n\n${g}Welcome to S1 Chemistry class; a class that is the starting point for every chemist out there in the world${t}\n\n${y}Together, we are going to get you started${t} \c" && wait_for_a_key_press
            echo -e "\n-------------------------------------- \c"
            clear_and_center "There are ${r}nine${t} topics to be covered in Senior one.. Being the start of chemistry, You are advised to adventure into the world of chemistry and appreciate why the subject is one of the compulsory ones to do at such a level in this modern world"
        fi
        attempts=0
        max_attempts=4
        while true
        do
            while [ "$attempts" -lt "$max_attempts" ]
            do
                handle_s1_topic_input
                touch .chemistry_topic_selected

                if [[ "$topic" == "x" ]]
                then
                    quit
                elif [[ "$topic" == "q" ]]
                then
                    attempts=0
                    # Define the targeted directory
                    question_directory="Revision/Chemistry/S1"
                    # Define the file extension
                    file_extension_question=".qns.txt"
                    # Define the revision file
                    revision_file="../../chemistry_covered_qns.txt"
                    # Call the function to process a random question
                    process_random_short_answer_question "$question_directory" "$file_extension_question" "$revision_file"
                elif [[ "$topic" == "a" ]]
                then
                    attempts=0
                    # Define the targeted directory
                    question_directory="Revision/Chemistry/S1"
                    # Define the file extension
                    file_extension_question=".qns.txt"
                    # Define the revision file
                    revision_file="../../chemistry_covered_qns.txt"
                    # Call the function to process a random question
                    process_random_aoi "$question_directory" "$file_extension_question" "$revision_file"
                elif [[ "$topic" == "r" ]]
                then
                    attempts=0
                    # Define the targeted directory
                    answered_directory="Exercise/Chemistry/S1"
                    # Define the file extension
                    file_extension_answer=".ans.txt"
                    # Define the exercise file
                    exercise_file="../../chemistry_answered_ans.txt"
                    # Call the function to process a random question
                    process_question_answer "$answered_directory" "$file_extension_answer" "$exercise_file"

                elif [[ "$topic" == "s" ]]
                then
                    if [ -f Revision/.chemistry_samples ]
                    then
                        echo -e "\n\n${r}You are advised to not make any changes to the provided answers, instead, you can make a copy that you can edit${t}\n\n\n${y}Maximise the use of the find option in the text editor to get desired questions${t}\n\n\nFor a teacher willing to join us reach out to everyone of our children, please send us your questions and answers in a file labelled with your name and school to our contacts\n\n\nEmail: ${g}muhumuzaomega@gmail.com${t} \c"
                        wait_for_a_key_press
						cd Revision
						notepad.exe .chemistry_samples
						cd ..
                    else
                        echo -e "\nSorry, something wrong with your files! No sample items to display \c"
                    fi

                elif [[ "$topic" == "n" ]]
                then
                    attempts=0
                    # Define the targeted directory
                    answered_directory="Exercise/Chemistry/S1"
                    # Define the file extension
                    file_extension_answer=".ans.txt"
                    # Define the exercise file
                    exercise_file="../../chemistry_answered_ans.txt"
                    # Call the function to process a random question
                    process_final_assignment "$answered_directory" "$file_extension_answer" "$exercise_file"

                elif [[ "$topic" == "p" ]]
                then
                    track_student_progress

                elif [[ ! "$topic" =~ ^[1-9]$ || -z "$topic" ]]
                then
                    echo -e "\n\nTopic ${r}$topic not available${t}... Please choose from the available options\c"
                    wait_for_a_key_press
                else
                    case "$topic" in
                        1)

                            if ! [ -f ".s_chemistry_1_1" ]; then
                                echo -e "\n\nYou chose topic 1, proceeding with Chemistry and Society...\n\nThank you for choosing to excel with us!\n\nWe adore you ${g}darling${t} and wish you the very best! \c" && wait_for_a_key_press
                            fi
                            cp "Notes/Chemistry/1.1.chemistry_and_society.txt" . || exit 1
                            mv 1.1.chemistry_and_society.txt .1.1.chemistry_and_society.txt || exit 1
                            sed -i -e 's/\.\( \+\)/;/g' -e '/https:/! s/\([!?:]\)/\1;/g' -e 's/\([;]\) /\1/g' .1.1.chemistry_and_society.txt 
                            sed -i 's/;\([:!?]\);/\;\1/g' .1.1.chemistry_and_society.txt 
                            sed -i 's/;\([0-9]*\);/;\1. /g' .1.1.chemistry_and_society.txt 
                            sed -i -E 's/(\([^)]*);/\1/g; s/(\[[^]]*);/\1/g; s/(\{[^}]*);/\1/g' .1.1.chemistry_and_society.txt 
                            process_reminders_from_file .1.1.chemistry_and_society.txt
                            STATE_FILE=".s_chemistry_1_1"
                            process_file .1.1.chemistry_and_society.txt
                            contact_ai
                            if [ -f .resume_to_class ]; then
                                break
                            fi
                            if [ -f .skip_exercises ]; then
                            	break
                            fi
                            rm -f .1.1.chemistry_and_society.txt
                            sed -i '/1/!d' .s_chemistry_1_1

                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S1"
                            # Define the file extension
                            file_extension=".1.chemistry_and_society.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_short_answer_question "$question_directory" "$file_extension" "$revision_file"

                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S1"
                            # Define the file extension
                            file_extension_question=".1.chemistry_and_society.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_aoi "$question_directory" "$file_extension_question" "$revision_file"

                        ;;
                        2)

                            if ! [ -f ".chemistry.1.1" ]; then
                                attempts=0
                                # Define the targeted directory
                                answered_directory="Exercise/Chemistry/S1"
                                # Define the file extension
                                file_extension_answer=".1.chemistry_and_society.ans.txt"
                                # Define the exercise file
                                exercise_file="../../chemistry_answered_ans.txt"
                                # Call the function to process a random question
                                process_question_answer "$answered_directory" "$file_extension_answer" "$exercise_file"
                                touch .chemistry.1.1
                            fi

                            if ! [ -f ".s_chemistry_1_2" ]; then
                                echo -e "\n\nYou happen to have chosen to explore topic 2, proceeding with Experimental Chemistry...\n\nOnce again we treasure you ${g}dear one${t}\n\nWe promise to always be right here for you \c" && wait_for_a_key_press
                            fi
                            cp "Notes/Chemistry/1.2.experimental_chemistry.txt" . || exit 1
                            mv 1.2.experimental_chemistry.txt .1.2.experimental_chemistry.txt || exit 1
                            sed -i -e 's/\.\( \+\)/;/g' -e '/https:/! s/\([!?:]\)/\1;/g' -e 's/\([;]\) /\1/g' .1.2.experimental_chemistry.txt
                            sed -i 's/;\([:!?]\);/\;\1/g' .1.2.experimental_chemistry.txt
                            sed -i 's/;\([0-9]*\);/;\1. /g' .1.2.experimental_chemistry.txt
                            sed -i -E 's/(\([^)]*);/\1/g; s/(\[[^]]*);/\1/g; s/(\{[^}]*);/\1/g' .1.2.experimental_chemistry.txt
                            process_reminders_from_file .1.2.experimental_chemistry.txt
                            STATE_FILE=".s_chemistry_1_2"
                            process_file .1.2.experimental_chemistry.txt
                            contact_ai
                            if [ -f .resume_to_class ]; then
                                break
                            fi
                            if [ -f .skip_exercises ]; then
                                break
                            fi
                            rm -f .1.2.experimental_chemistry.txt
                            sed -i '/1/!d' .s_chemistry_1_2

                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S1"
                            # Define the file extension
                            file_extension_question=".2.experimental_chemistry.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_short_answer_question "$question_directory" "$file_extension_question" "$revision_file"

                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S1"
                            # Define the file extension
                            file_extension_question=".2.experimental_chemistry.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_aoi "$question_directory" "$file_extension_question" "$revision_file"
                        ;;
                        3)

                            if ! [ -f ".chemistry.1.2" ]; then
                                attempts=0
                                # Define the targeted directory
                                answered_directory="Exercise/Chemistry/S1"
                                # Define the file extension
                                file_extension_answer=".1.experimental_chemistry.ans.txt"
                                # Define the exercise file
                                exercise_file="../../chemistry_answered_ans.txt"
                                # Call the function to process a random question
                                process_question_answer "$answered_directory" "$file_extension_answer" "$exercise_file"
                                touch .chemistry.1.2
                            fi

                            if ! [ -f ".s_chemistry_1_3" ]; then
                                echo -e "\n\nYou happen to have chosen to explore topic 3, proceeding with States and changes of States of Matter...\n\nWe are so exited to have you with us ${g}darling${t}\n\nRemember that hard work forever pays \c" && wait_for_a_key_press
                            fi
                            cp "Notes/Chemistry/1.3.states_and_changes_of_states_of_matter.txt" . || exit 1
                            mv 1.3.states_and_changes_of_states_of_matter.txt .1.3.states_and_changes_of_states_of_matter.txt || exit 1
                            sed -i -e 's/\.\( \+\)/;/g' -e '/https:/! s/\([!?:]\)/\1;/g' -e 's/\([;]\) /\1/g' .1.3.states_and_changes_of_states_of_matter.txt
                            sed -i 's/;\([:!?]\);/\;\1/g' .1.3.states_and_changes_of_states_of_matter.txt
                            sed -i 's/;\([0-9]*\);/;\1. /g' .1.3.states_and_changes_of_states_of_matter.txt
                            sed -i -E 's/(\([^)]*);/\1/g; s/(\[[^]]*);/\1/g; s/(\{[^}]*);/\1/g' .1.3.states_and_changes_of_states_of_matter.txt
                            process_reminders_from_file .1.3.states_and_changes_of_states_of_matter.txt
                            STATE_FILE=".s_chemistry_1_3"
                            process_file .1.3.states_and_changes_of_states_of_matter.txt
                            contact_ai
                            if [ -f .resume_to_class ]; then
                                break
                            fi
                            if [ -f .skip_exercises ]; then
                                break
                            fi
                            rm -f .1.3.states_and_changes_of_states_of_matter.txt
                            sed -i '/1/!d' .s_chemistry_1_3

                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S1"
                            # Define the file extension
                            file_extension_question=".3.states_and_changes_of_states_of_matter.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_short_answer_question "$question_directory" "$file_extension_question" "$revision_file"

                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S1"
                            # Define the file extension
                            file_extension_question=".3.states_and_changes_of_states_of_matter.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_aoi "$question_directory" "$file_extension_question" "$revision_file"
			            ;;
                        4)
                            if ! [ -f ".chemistry.1.3" ]; then
                                attempts=0
                                # Define the targeted directory
                                answered_directory="Exercise/Chemistry/S1"
                                # Define the file extension
                                file_extension_answer=".3.states_and_changes_of_states_of_matter.ans.txt"
                                # Define the exercise file
                                exercise_file="../../chemistry_answered_ans.txt"
                                # Call the function to process a random question
                                process_question_answer "$answered_directory" "$file_extension_answer" "$exercise_file"
                                touch .chemistry.1.3
                            fi
                            if ! [ -f ".s_chemistry_1_4" ]; then
                                echo -e "\n\nYou did qualify to probe into the realm of Using materials ...\n\nWe do treasure you ${g}darling${t}. Just never forget, that no matter how prepared you are, to win gold, you have to follow instructions! \c" && wait_for_a_key_press
                            fi
                            cp "Notes/Chemistry/1.4.using_materials.txt" . || exit 1
                            mv 1.4.using_materials.txt .1.4.using_materials.txt || exit 1
                            sed -i -e 's/\.\( \+\)/;/g' -e '/https:/! s/\([!?:]\)/\1;/g' -e 's/\([;]\) /\1/g' .1.4.using_materials.txt
                            sed -i 's/;\([:!?]\);/\;\1/g' .1.4.using_materials.txt
                            sed -i 's/;\([0-9]*\);/;\1. /g' .1.4.using_materials.txt
                            sed -i -E 's/(\([^)]*);/\1/g; s/(\[[^]]*);/\1/g; s/(\{[^}]*);/\1/g' .1.4.using_materials.txt
                            process_reminders_from_file .1.4.using_materials.txt
                            STATE_FILE=".s_chemistry_1_4"
                            process_file .1.4.using_materials.txt
                            contact_ai
                            if [ -f .resume_to_class ]; then
                                break
                            fi
                            if [ -f .skip_exercises ]; then
                                break
                            fi
                            rm -f .1.4.using_materials.txt
                            sed -i '/^1$/!d' .s_chemistry_1_4
                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S1"
                            # Define the file extension
                            file_extension=".4.using_materials.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_short_answer_question "$question_directory" "$file_extension" "$revision_file"
                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S1"
                            # Define the file extension
                            file_extension_question=".4.using_materials.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_aoi "$question_directory" "$file_extension_question" "$revision_file"
                        ;;
                        5)
                            if ! [ -f ".chemistry.1.4" ]; then
                                attempts=0
                                # Define the targeted directory
                                answered_directory="Exercise/Chemistry/S1"
                                # Define the file extension
                                file_extension_answer=".4.using_materials.ans.txt"
                                # Define the exercise file
                                exercise_file="../../chemistry_answered_ans.txt"
                                # Call the function to process a random question
                                process_question_answer "$answered_directory" "$file_extension_answer" "$exercise_file"
                                touch .chemistry.1.4
                            fi
                            if ! [ -f ".s_chemistry_1_5" ]; then
                                echo -e "\n\nHere you are dear one... Stay organised as you explore Temporary and permanent changes ...\n\n${g}Just know we are not going to leave you alone${t}\n\nWe promise to always be right here for you \c" && wait_for_a_key_press
                            fi
                            cp "Notes/Chemistry/1.5.temporary_and_permanent_changes.txt" . || exit 1
                            mv 1.5.temporary_and_permanent_changes.txt .1.5.temporary_and_permanent_changes.txt || exit 1
                            sed -i -e 's/\.\( \+\)/;/g' -e '/https:/! s/\([!?:]\)/\1;/g' -e 's/\([;]\) /\1/g' .1.5.temporary_and_permanent_changes.txt
                            sed -i 's/;\([:!?]\);/\;\1/g' .1.5.temporary_and_permanent_changes.txt
                            sed -i 's/;\([0-9]*\);/;\1. /g' .1.5.temporary_and_permanent_changes.txt
                            sed -i -E 's/(\([^)]*);/\1/g; s/(\[[^]]*);/\1/g; s/(\{[^}]*);/\1/g' .1.5.temporary_and_permanent_changes.txt
                            process_reminders_from_file .1.5.temporary_and_permanent_changes.txt
                            STATE_FILE=".s_chemistry_1_5"
                            process_file .1.5.temporary_and_permanent_changes.txt
                            rm -f .1.5.temporary_and_permanent_changes.txt
                            contact_ai
                            if [ -f .resume_to_class ]; then
                                break
                            fi
                            if [ -f .skip_exercises ]; then
                                break
                            fi
                            sed -i '/^1$/!d' .s_chemistry_1_5
                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S1"
                            # Define the file extension
                            file_extension_question=".5.temporary_and_permanent_changes.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_short_answer_question "$question_directory" "$file_extension_question" "$revision_file"
                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S1"
                            # Define the file extension
                            file_extension_question=".5.temporary_and_permanent_changes.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_aoi "$question_directory" "$file_extension_question" "$revision_file"
                        ;;
                        6)
                            if ! [ -f ".chemistry.1.5" ]; then
                                attempts=0
                                # Define the targeted directory
                                answered_directory="Exercise/Chemistry/S1"
                                # Define the file extension
                                file_extension_answer=".5.temporary_and_permanent_changes.ans.txt"
                                # Define the exercise file
                                exercise_file="../../chemistry_answered_ans.txt"
                                # Call the function to process a random question
                                process_question_answer "$answered_directory" "$file_extension_answer" "$exercise_file"
                                touch .chemistry.1.5
                            fi
                            if ! [ -f ".s_chemistry_1_6" ]; then
                                echo -e "\n\nYou have managed to make it to Mixtures elements and compounds ...\n\n${g}Remember to pray always${t}\n\nThe fear of the Lord is the beginning of wisdom \c" && wait_for_a_key_press
                            fi
                            cp "Notes/Chemistry/1.6.mixtures_elements_and_compounds.txt" . || exit 1
                            mv 1.6.mixtures_elements_and_compounds.txt .1.6.mixtures_elements_and_compounds.txt || exit 1
                            sed -i -e 's/\.\( \+\)/;/g' -e '/https:/! s/\([!?:]\)/\1;/g' -e 's/\([;]\) /\1/g' .1.6.mixtures_elements_and_compounds.txt
                            sed -i 's/;\([:!?]\);/\;\1/g' .1.6.mixtures_elements_and_compounds.txt
                            sed -i 's/;\([0-9]*\);/;\1. /g' .1.6.mixtures_elements_and_compounds.txt
                            sed -i -E 's/(\([^)]*);/\1/g; s/(\[[^]]*);/\1/g; s/(\{[^}]*);/\1/g' .1.6.mixtures_elements_and_compounds.txt
                            process_reminders_from_file .1.6.mixtures_elements_and_compounds.txt
                            STATE_FILE=".s_chemistry_1_6"
                            process_file .1.6.mixtures_elements_and_compounds.txt
                            contact_ai
                            if [ -f .resume_to_class ]; then
                                break
                            fi
                            if [ -f .skip_exercises ]; then
                                break
                            fi
                            rm -f .1.6.mixtures_elements_and_compounds.txt
                            sed -i '/^1$/!d' .s_chemistry_1_6
                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S1"
                            # Define the file extension
                            file_extension_question=".6.mixtures_elements_and_compounds.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_short_answer_question "$question_directory" "$file_extension_question" "$revision_file"
                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S1"
                            # Define the file extension
                            file_extension_question=".6.mixtures_elements_and_compounds.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_aoi "$question_directory" "$file_extension_question" "$revision_file"
                        ;;
                        7)
                            if ! [ -f ".chemistry.1.6" ]; then
                                attempts=0
                                # Define the targeted directory
                                answered_directory="Exercise/Chemistry/S1"
                                # Define the file extension
                                file_extension_answer=".6.mixtures_elements_and_compounds.ans.txt"
                                # Define the exercise file
                                exercise_file="../../chemistry_answered_ans.txt"
                                # Call the function to process a random question
                                process_question_answer "$answered_directory" "$file_extension_answer" "$exercise_file"
                                touch .chemistry.1.6
                            fi
                            if ! [ -f ".s_chemistry_1_7" ]; then
                                echo -e "\n\nFrom here, you will be proceeding with Air ...\n\n${g}Please never ever forget that your education is your future${t}\n\nFocus dear \c" && wait_for_a_key_press
                            fi
                            cp "Notes/Chemistry/1.7.air.txt" . || exit 1
                            mv 1.7.air.txt .1.7.air.txt || exit 1
                            sed -i -e 's/\.\( \+\)/;/g' -e '/https:/! s/\([!?:]\)/\1;/g' -e 's/\([;]\) /\1/g' .1.7.air.txt
                            sed -i 's/;\([:!?]\);/\;\1/g' .1.7.air.txt
                            sed -i 's/;\([0-9]*\);/;\1. /g' .1.7.air.txt
                            sed -i -E 's/(\([^)]*);/\1/g; s/(\[[^]]*);/\1/g; s/(\{[^}]*);/\1/g' .1.7.air.txt
                            process_reminders_from_file .1.7.air.txt
                            STATE_FILE=".s_chemistry_1_7"
                            process_file .1.7.air.txt
                            contact_ai
                            if [ -f .resume_to_class ]; then
                                break
                            fi
                            if [ -f .skip_exercises ]; then
                                break
                            fi
                            rm -f .1.7.air.txt
                            sed -i '/^1$/!d' .s_chemistry_1_7
                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S1"
                            # Define the file extension
                            file_extension_question=".7.air.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_short_answer_question "$question_directory" "$file_extension_question" "$revision_file"
                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S1"
                            # Define the file extension
                            file_extension_question=".7.air.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_aoi "$question_directory" "$file_extension_question" "$revision_file"
                        ;;
                        8)
                            if ! [ -f ".chemistry.1.7" ]; then
                                attempts=0
                                # Define the targeted directory
                                answered_directory="Exercise/Chemistry/S1"
                                # Define the file extension
                                file_extension_answer=".7.air.ans.txt"
                                # Define the exercise file
                                exercise_file="../../chemistry_answered_ans.txt"
                                # Call the function to process a random question
                                process_question_answer "$answered_directory" "$file_extension_answer" "$exercise_file"
                                touch .chemistry.1.7
                            fi
                            if ! [ -f ".s_chemistry_1_8" ]; then
                                echo -e "\n\nYou are to cover Water ...\n\n${g}Please never ever settle for less${t}\n\nPromise yourself that you wont give up \c" && wait_for_a_key_press
                            fi
                            cp "Notes/Chemistry/1.8.water.txt" . || exit 1
                            mv 1.8.water.txt .1.8.water.txt || exit 1
                            sed -i -e 's/\.\( \+\)/;/g' -e '/https:/! s/\([!?:]\)/\1;/g' -e 's/\([;]\) /\1/g' .1.8.water.txt
                            sed -i 's/;\([:!?]\);/\;\1/g' .1.8.water.txt
                            sed -i 's/;\([0-9]*\);/;\1. /g' .1.8.water.txt
                            sed -i -E 's/(\([^)]*);/\1/g; s/(\[[^]]*);/\1/g; s/(\{[^}]*);/\1/g' .1.8.water.txt
                            process_reminders_from_file .1.8.water.txt
                            STATE_FILE=".s_chemistry_1_8"
                            process_file .1.8.water.txt
                            contact_ai
                            if [ -f .resume_to_class ]; then
                                break
                            fi
                            if [ -f .skip_exercises ]; then
                                break
                            fi
                            rm -f .1.8.water.txt
                            sed -i '/^1$/!d' .s_chemistry_1_8
                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S1"
                            # Define the file extension
                            file_extension_question=".8.water.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_short_answer_question "$question_directory" "$file_extension_question" "$revision_file"
                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S1"
                            # Define the file extension
                            file_extension_question=".8.water.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_aoi "$question_directory" "$file_extension_question" "$revision_file"
                        ;;
                        9)
                            if ! [ -f ".chemistry.1.8" ]; then
                                attempts=0
                                # Define the targeted directory
                                answered_directory="Exercise/Chemistry/S1"
                                # Define the file extension
                                file_extension_answer=".8.water.ans.txt"
                                # Define the exercise file
                                exercise_file="../../chemistry_answered_ans.txt"
                                # Call the function to process a random question
                                process_question_answer "$answered_directory" "$file_extension_answer" "$exercise_file"
                                touch .chemistry.1.8
                            fi
                            if ! [ -f ".s_chemistry_1_9" ]; then
                                echo -e "\n\nI am so happy for you dear one. You are here to cover the the 9th topic (Rocks and minerals)...\n\n${g}Just never underestimate the value of a single second${t}\n\nThat extra one second maybe all you need to fully understand a given concept \c" && wait_for_a_key_press
                            fi
                            cp "Notes/Chemistry/1.9.rocks_and_minerals.txt" . || exit 1
                            mv 1.9.rocks_and_minerals.txt .1.9.rocks_and_minerals.txt || exit 1
                            sed -i -e 's/\.\( \+\)/;/g' -e '/https:/! s/\([!?:]\)/\1;/g' -e 's/\([;]\) /\1/g' .1.9.rocks_and_minerals.txt
                            sed -i 's/;\([:!?]\);/\;\1/g' .1.9.rocks_and_minerals.txt
                            sed -i 's/;\([0-9]*\);/;\1. /g' .1.9.rocks_and_minerals.txt
                            sed -i -E 's/(\([^)]*);/\1/g; s/(\[[^]]*);/\1/g; s/(\{[^}]*);/\1/g' .1.9.rocks_and_minerals.txt
                            process_reminders_from_file .1.9.rocks_and_minerals.txt
                            STATE_FILE=".s_chemistry_1_9"
                            process_file .1.9.rocks_and_minerals.txt
                            contact_ai
                            if [ -f .resume_to_class ]; then
                                break
                            fi
                            if [ -f .skip_exercises ]; then
                                break
                            fi
                            rm -f .1.9.rocks_and_minerals.txt
                            sed -i '/^1$/!d' .s_chemistry_1_9
                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S1"
                            # Define the file extension
                            file_extension_question=".9.rocks_and_minerals.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_short_answer_question "$question_directory" "$file_extension_question" "$revision_file"
                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S1"
                            # Define the file extension
                            file_extension_question=".9.rocks_and_minerals.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_aoi "$question_directory" "$file_extension_question" "$revision_file"

                        ;;
                        # Additional cases for other topics can be added here

                        *)
                            echo -e "\n\nInvalid topic number \c"
                            continue
                        ;;
                    esac

                    break  # Exit the inner loop after successfully handling user input
                fi
                ((attempts++))
            done

            # If the loop exits due to max_attempts, handle it
            if [ "$attempts" -eq "$max_attempts" ]; then
                quit1
            fi
        done

    elif [[ "$class" == "2" ]]; then

        if ! find . -maxdepth 1 -name '.s_chemistry_2*' -type f -quit 2>/dev/null; then
            echo -e "\n\n${g}Welcome to S2 Chemistry class; the class that really matters alot${t}\n\n${y}Together, nothing is impossible${t} \c" && wait_for_a_key_press
	    	echo -e "\n-------------------------------------- \c"
            clear_and_center "There are ${r}five complex${t} topics to be covered in Senior two.. Being the basis of chemistry, You are advised to cover each topic to the finest details"
        fi
        attempts=0
        max_attempts=4
        while true
        do
            while [ "$attempts" -lt "$max_attempts" ]
            do
				handle_s2_topic_input
        		touch .chemistry_topic_selected

                if [[ "$topic" == "x" ]]
                then
                    quit
                elif [[ "$topic" == "q" ]]
                then
                    attempts=0
                    # Define the targeted directory
                    question_directory="Revision/Chemistry/S2"
                    # Define the file extension
                    file_extension_question=".qns.txt"
                    # Define the revision file
                    revision_file="../../chemistry_covered_qns.txt"
                    # Call the function to process a random question
                    process_random_short_answer_question "$question_directory" "$file_extension_question" "$revision_file"
                elif [[ "$topic" == "a" ]]
                then
		    		attempts=0
                    # Define the targeted directory
                    question_directory="Revision/Chemistry/S2"
                    # Define the file extension
                    file_extension_question=".qns.txt"
                    # Define the revision file
                    revision_file="../../chemistry_covered_qns.txt"
                    # Call the function to process a random question
                    process_random_aoi "$question_directory" "$file_extension_question" "$revision_file"
                elif [[ "$topic" == "r" ]]
                then
                    attempts=0
                    # Define the targeted directory
                    answered_directory="Exercise/Chemistry/S2"
                    # Define the file extension
                    file_extension_answer=".ans.txt"
                    # Define the exercise file
                    exercise_file="../../chemistry_answered_ans.txt"
                    # Call the function to process a random question
    		    	process_question_answer "$answered_directory" "$file_extension_answer" "$exercise_file"

                elif [[ "$topic" == "s" ]]
                then
					if [ -f Revision/.chemistry_samples ]
					then
						echo -e "\n\n${r}You are advised to not make any changes to the provided answers, instead, you can make a copy that you can edit${t}\n\n\n${y}Maximise the use of the find option in the text editor to get desired questions${t}\n\n\nFor a teacher willing to join us reach out to everyone of our children, please send us your questions and answers in a file labelled with your name and school to our contacts\n\n\nEmail: ${g}muhumuzaomega@gmail.com${t} \c"
						wait_for_a_key_press
						cd Revision
						notepad.exe .chemistry_samples
						cd ..
					else
						echo -e "\nSorry, something wrong with your files! No sample items to display \c"
					fi

                elif [[ "$topic" == "n" ]]
                then
					attempts=0
					# Define the targeted directory
					answered_directory="Exercise/Chemistry/S2"
					# Define the file extension
					file_extension_answer=".ans.txt"
					# Define the exercise file
					exercise_file="../../chemistry_answered_ans.txt"
					# Call the function to process a random question
					process_final_assignment "$answered_directory" "$file_extension_answer" "$exercise_file"

                elif [[ "$topic" == "p" ]]
                then
                    track_student_progress

                elif [[ ! "$topic" =~ ^[1-5]$ || -z "$topic" ]]
                then
                    echo -e "\n\nTopic ${r}$topic not available${t}... Please choose from the available options\c"
		    		wait_for_a_key_press
                else
                    case "$topic" in
                        1)

                            if ! [ -f ".s_chemistry_2_1" ]; then
                                echo -e "\n\nYou chose topic 1, proceeding with Acids and alkalis...\n\nThank you for choosing to excel with us!\n\nWe adore you ${g}darling${t} and wish you all the best! \c" && wait_for_a_key_press
                            fi
                            cp "Notes/Chemistry/2.1.acids_and_alkalis.txt" . || exit 1
			    			mv 2.1.acids_and_alkalis.txt .2.1.acids_and_alkalis.txt || exit 1
                            sed -i -e 's/\.\( \+\)/;/g' -e '/https:/! s/\([!?:]\)/\1;/g' -e 's/\([;]\) /\1/g' .2.1.acids_and_alkalis.txt
                            sed -i 's/;\([:!?]\);/\;\1/g' .2.1.acids_and_alkalis.txt
                            sed -i 's/;\([0-9]*\);/;\1. /g' .2.1.acids_and_alkalis.txt
                            sed -i -E 's/(\([^)]*);/\1/g; s/(\[[^]]*);/\1/g; s/(\{[^}]*);/\1/g' .2.1.acids_and_alkalis.txt
                            process_reminders_from_file .2.1.acids_and_alkalis.txt
                            STATE_FILE=".s_chemistry_2_1"
                            process_file .2.1.acids_and_alkalis.txt
                            contact_ai
                            if [ -f .resume_to_class ]; then
                                break
                            fi
                            if [ -f .skip_exercises ]; then
                                break
                            fi
                            rm -f .2.1.acids_and_alkalis.txt
                            sed -i '/1/!d' .s_chemistry_2_1

                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S2"
                            # Define the file extension
                            file_extension=".1.acids_and_alkalis.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_short_answer_question "$question_directory" "$file_extension" "$revision_file"

							attempts=0
	                    	# Define the targeted directory
	                    	question_directory="Revision/Chemistry/S2"
	                    	# Define the file extension
	                    	file_extension_question=".1.acids_and_alkalis.qns.txt"
	                    	# Define the revision file
	                    	revision_file="../../chemistry_covered_qns.txt"
	                    	# Call the function to process a random question
	                    	process_random_aoi "$question_directory" "$file_extension_question" "$revision_file"

                        ;;

                        2)

                            if ! [ -f ".chemistry.2.1" ]; then
				    			attempts=0
                        	    # Define the targeted directory
                        	    answered_directory="Exercise/Chemistry/S2"
                        	    # Define the file extension
                        	    file_extension_answer=".1.acids_and_alkalis.ans.txt"
                        	    # Define the exercise file
                        	    exercise_file="../../chemistry_answered_ans.txt"
                        	    # Call the function to process a random question
                        	    process_question_answer "$answered_directory" "$file_extension_answer" "$exercise_file"
				    			touch .chemistry.2.1
			    			fi

                            if ! [ -f ".s_chemistry_2_2" ]; then
                                echo -e "\n\nYou happen to have chosen to explore topic 2, proceeding with Salts...\n\nOnce again we treasure you ${g}dear one${t}\n\nYou got our prayers \c" && wait_for_a_key_press
                            fi
                            cp "Notes/Chemistry/2.2.salts.txt" . || exit 1
                            mv 2.2.salts.txt .2.2.salts.txt || exit 1
                            sed -i -e 's/\.\( \+\)/;/g' -e '/https:/! s/\([!?:]\)/\1;/g' -e 's/\([;]\) /\1/g' .2.2.salts.txt
                            sed -i 's/;\([:!?]\);/\;\1/g' .2.2.salts.txt
                            sed -i 's/;\([0-9]*\);/;\1. /g' .2.2.salts.txt
                            sed -i -E 's/(\([^)]*);/\1/g; s/(\[[^]]*);/\1/g; s/(\{[^}]*);/\1/g' .2.2.salts.txt
                            process_reminders_from_file .2.2.salts.txt
                            STATE_FILE=".s_chemistry_2_2"
                            process_file .2.2.salts.txt
                            contact_ai
                            if [ -f .resume_to_class ]; then
                                break
                            fi
                            if [ -f .skip_exercises ]; then
                                break
                            fi
                            rm -f .2.2.salts.txt
                            sed -i '/1/!d' .s_chemistry_2_2

                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S2"
                            # Define the file extension
                            file_extension_question=".2.salts.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_short_answer_question "$question_directory" "$file_extension_question" "$revision_file"

                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S2"
                            # Define the file extension
                            file_extension_question=".2.salts.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_aoi "$question_directory" "$file_extension_question" "$revision_file"

                        ;;

		    			3)

                            if ! [ -f ".chemistry.2.2" ]; then
                                attempts=0
                                # Define the targeted directory
                                answered_directory="Exercise/Chemistry/S2"
                                # Define the file extension
                                file_extension_answer=".2.salts.ans.txt"
                                # Define the exercise file
                                exercise_file="../../chemistry_answered_ans.txt"
                                # Call the function to process a random question
                                process_question_answer "$answered_directory" "$file_extension_answer" "$exercise_file"
                                touch .chemistry.2.2
                            fi

                            if ! [ -f ".s_chemistry_2_3" ]; then
                                echo -e "\n\nYou happen to have chosen to explore topic 3, proceeding with The Periodic table...\n\nOnce again we treasure you ${g}darling${t}\n\nRemember that you have to work really hard \c" && wait_for_a_key_press
                            fi
							cp "Notes/Chemistry/2.3.the_periodic_table.txt" . || exit 1
                            mv 2.3.the_periodic_table.txt .2.3.the_periodic_table.txt || exit 1
                            sed -i -e 's/\.\( \+\)/;/g' -e '/https:/! s/\([!?:]\)/\1;/g' -e 's/\([;]\) /\1/g' .2.3.the_periodic_table.txt
                            process_reminders_from_file .2.3.the_periodic_table.txt
                            STATE_FILE=".s_chemistry_2_3"
                            process_file .2.3.the_periodic_table.txt
                            contact_ai
                            if [ -f .resume_to_class ]; then
                                break
                            fi
                            if [ -f .skip_exercises ]; then
                                break
                            fi
                            rm -f .2.3.the_periodic_table.txt
                            sed -i '/1/!d' .s_chemistry_2_3

                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S2"
                            # Define the file extension
                            file_extension_question=".3.the_periodic_table.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_short_answer_question "$question_directory" "$file_extension_question" "$revision_file"

                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S2"
                            # Define the file extension
                            file_extension_question=".3.the_periodic_table.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_aoi "$question_directory" "$file_extension_question" "$revision_file"
                        ;;

                        4)

                            if ! [ -f ".chemistry.2.3" ]; then
				    			attempts=0
                        	    # Define the targeted directory
                        	    answered_directory="Exercise/Chemistry/S2"
                        	    # Define the file extension
                        	    file_extension_answer=".3.the_periodic_table.ans.txt"
                        	    # Define the exercise file
                        	    exercise_file="../../chemistry_answered_ans.txt"
                        	    # Call the function to process a random question
                        	    process_question_answer "$answered_directory" "$file_extension_answer" "$exercise_file"
				    			touch .chemistry.2.3
			    			fi

                            if ! [ -f ".s_chemistry_2_4" ]; then
                                echo -e "\n\nYou happen to have chosen to explore topic 4, proceeding with Carbon in the environment...\n\nOnce again we treasure you ${g}dear one${t}\n\nYou got our prayers \c" && wait_for_a_key_press
                            fi
                            cp "Notes/Chemistry/2.4.carbon_in_the_environment.txt" . || exit 1
                            mv 2.4.carbon_in_the_environment.txt .2.4.carbon_in_the_environment.txt || exit 1
                            sed -i -e 's/\.\( \+\)/;/g' -e '/https:/! s/\([!?:]\)/\1;/g' -e 's/\([;]\) /\1/g' .2.4.carbon_in_the_environment.txt
                            sed -i 's/;\([:!?]\);/\;\1/g' .2.4.carbon_in_the_environment.txt
                            sed -i 's/;\([0-9]*\);/;\1. /g' .2.4.carbon_in_the_environment.txt
                            sed -i -E 's/(\([^)]*);/\1/g; s/(\[[^]]*);/\1/g; s/(\{[^}]*);/\1/g' .2.4.carbon_in_the_environment.txt
                            process_reminders_from_file .2.4.carbon_in_the_environment.txt
                            STATE_FILE=".s_chemistry_2_4"
                            process_file .2.4.carbon_in_the_environment.txt
                            contact_ai
                            if [ -f .resume_to_class ]; then
                                break
                            fi
                            if [ -f .skip_exercises ]; then
                                break
                            fi
                            rm -f .2.4.carbon_in_the_environment.txt
                            sed -i '/1/!d' .s_chemistry_2_4

                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S2"
                            # Define the file extension
                            file_extension_question=".4.carbon_in_the_environment.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_short_answer_question "$question_directory" "$file_extension_question" "$revision_file"

                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S2"
                            # Define the file extension
                            file_extension_question=".4.carbon_in_the_environment.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_aoi "$question_directory" "$file_extension_question" "$revision_file"

                        ;;

		    			5)

                            if ! [ -f ".chemistry.2.4" ]; then
                                attempts=0
                                # Define the targeted directory
                                answered_directory="Exercise/Chemistry/S2"
                                # Define the file extension
                                file_extension_answer=".4.carbon_in_the_environment.ans.txt"
                                # Define the exercise file
                                exercise_file="../../chemistry_answered_ans.txt"
                                # Call the function to process a random question
                                process_question_answer "$answered_directory" "$file_extension_answer" "$exercise_file"
                                touch .chemistry.2.4
                            fi

                            if ! [ -f ".s_chemistry_2_5" ]; then
                                echo -e "\n\nYou happen to have chosen to explore topic 5, proceeding with The reactivity series...\n\nOnce again we treasure you ${g}darling${t}\n\nRemember that you have to work really hard \c" && wait_for_a_key_press
                            fi
							cp "Notes/Chemistry/2.5.the_reactivity_series.txt" . || exit 1
                            mv 2.5.the_reactivity_series.txt .2.5.the_reactivity_series.txt || exit 1
                            sed -i -e 's/\.\( \+\)/;/g' -e '/https:/! s/\([!?:]\)/\1;/g' -e 's/\([;]\) /\1/g' .2.5.the_reactivity_series.txt
                            process_reminders_from_file .2.5.the_reactivity_series.txt
                            STATE_FILE=".s_chemistry_2_5"
                            process_file .2.5.the_reactivity_series.txt
                            contact_ai
                            if [ -f .resume_to_class ]; then
                                break
                            fi
                            if [ -f .skip_exercises ]; then
                                break
                            fi
                            rm -f .2.5.the_reactivity_series.txt
                            sed -i '/1/!d' .s_chemistry_2_5

                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S2"
                            # Define the file extension
                            file_extension_question=".5.the_reactivity_series.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_short_answer_question "$question_directory" "$file_extension_question" "$revision_file"

                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S2"
                            # Define the file extension
                            file_extension_question=".5.the_reactivity_series.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_aoi "$question_directory" "$file_extension_question" "$revision_file"

		    			;;
                        # Additional cases for other topics can be added here

                        *)
                            echo -e "\n\nInvalid topic number \c"
                            continue
                        ;;
                    esac

                    break  # Exit the inner loop after successfully handling user input
                fi
                ((attempts++))
            done

            # If the loop exits due to max_attempts, handle it
            if [ "$attempts" -eq "$max_attempts" ]; then
                quit1
            fi
        done

    elif [[ "$class" == "3" ]]; then
        if ! find . -maxdepth 1 -name '.s_chemistry_3*' -type f -quit 2>/dev/null; then
            echo -e "\n\n${g}Welcome to S3 Chemistry class${t}\n\n${y}Together, we are going to get you started${t} \c" && wait_for_a_key_press
            echo -e "\n-------------------------------------- \c"
            clear_and_center "There are ${r}6${t} topics to be covered. Your tasks will always expand or shrink to fit in the time you give them. For that reason, never procrastinate darling!"
        fi
        attempts=0
        max_attempts=4
        while true
        do
            while [ "$attempts" -lt "$max_attempts" ]
            do
                handle_s3_topic_input
                touch .chemistry_topic_selected
                if [[ "$topic" == "x" ]]
                then
                    quit
                elif [[ "$topic" == "q" ]]
                then
                    attempts=0
                    # Define the targeted directory
                    question_directory="Revision/Chemistry/S3"
                    # Define the file extension
                    file_extension_question=".qns.txt"
                    # Define the revision file
                    revision_file="../../chemistry_covered_qns.txt"
                    # Call the function to process a random question
                    process_random_short_answer_question "$question_directory" "$file_extension_question" "$revision_file"
                elif [[ "$topic" == "a" ]]
                then
                    attempts=0
                    # Define the targeted directory
                    question_directory="Revision/Chemistry/S3"
                    # Define the file extension
                    file_extension_question=".qns.txt"
                    # Define the revision file
                    revision_file="../../chemistry_covered_qns.txt"
                    # Call the function to process a random question
                    process_random_aoi "$question_directory" "$file_extension_question" "$revision_file"
                elif [[ "$topic" == "r" ]]
                then
                    attempts=0
                    # Define the targeted directory
                    answered_directory="Exercise/Chemistry/S3"
                    # Define the file extension
                    file_extension_answer=".ans.txt"
                    # Define the exercise file
                    exercise_file="../../chemistry_answered_ans.txt"
                    # Call the function to process a random question
                    process_question_answer "$answered_directory" "$file_extension_answer" "$exercise_file"
                elif [[ "$topic" == "s" ]]
                then
                    if [ -f Revision/.chemistry_samples ]
                    then
                        echo -e "\n\n${r}You are advised to not make any changes to the provided answers, instead, you can make a copy that you can edit${t}\n\n${y}Maximise the use of the find option in the text editor to get desired questions${t}\n\nFor a teacher willing to join us reach out to everyone of our children, please send us your questions and answers in a file labelled with your name and school to our contacts\n\n\nEmail: ${g}muhumuzaomega@gmail.com${t} \c"
                        wait_for_a_key_press
						cd Revision
                    explorer.exe .chemistry_samples
                    cd ..
                    else
                        echo -e "\nSorry, something wrong with your files! No sample items to display \c"
                    fi
                elif [[ "$topic" == "n" ]]
                then
                    attempts=0
                    # Define the targeted directory
                    answered_directory="Exercise/Chemistry/S3"
                    # Define the file extension
                    file_extension_answer=".ans.txt"
                    # Define the exercise file
                    exercise_file="../../chemistry_answered_ans.txt"
                    # Call the function to process a random question
                    process_final_assignment "$answered_directory" "$file_extension_answer" "$exercise_file"
                elif [[ "$topic" == "p" ]]
                then
                    track_student_progress
                elif [[ ! "$topic" =~ ^[1-6]$ || -z "$topic" ]]
                then
                    echo -e "\n\nTopic ${r}$topic not available${t}... Please choose from the available options\c"
                    wait_for_a_key_press
                else
                    case "$topic" in
                        1)
                            if ! [ -f ".s_chemistry_3_1" ]; then
                                echo -e "\n\nYou chose to explore Carbon in life ...\n\nThank you for choosing to educate yourself!\n\nWe adore you ${g}darling${t} and wish you the very best! \c" && wait_for_a_key_press
                            fi
                            cp "Notes/Chemistry/3.1.carbon_in_life.txt" . || exit 1
                            mv 3.1.carbon_in_life.txt .3.1.carbon_in_life.txt || exit 1
                            sed -i -e 's/\.\( \+\)/;/g' -e '/https:/! s/\([!?:]\)/\1;/g' -e 's/\([;]\) /\1/g' .3.1.carbon_in_life.txt
                            sed -i 's/;\([:!?]\);/\;\1/g' .3.1.carbon_in_life.txt
                            sed -i 's/;\([0-9]*\);/;\1. /g' .3.1.carbon_in_life.txt
                            sed -i -E 's/(\([^)]*);/\1/g; s/(\[[^]]*);/\1/g; s/(\{[^}]*);/\1/g' .3.1.carbon_in_life.txt
                            process_reminders_from_file .3.1.carbon_in_life.txt
                            STATE_FILE=".s_chemistry_3_1"
                            process_file .3.1.carbon_in_life.txt
                            contact_ai
                            if [ -f .resume_to_class ]; then
                                break
                            fi
                            if [ -f .skip_exercises ]; then
                                break
                            fi
                            rm -f .3.1.carbon_in_life.txt
                            sed -i '/^1$/!d' .s_chemistry_3_1
                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S3"
                            # Define the file extension
                            file_extension=".1.carbon_in_life.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_short_answer_question "$question_directory" "$file_extension" "$revision_file"
                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S3"
                            # Define the file extension
                            file_extension_question=".1.carbon_in_life.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_aoi "$question_directory" "$file_extension_question" "$revision_file"
                        ;;
                        2)
                            if ! [ -f ".chemistry.3.1" ]; then
                                attempts=0
                                # Define the targeted directory
                                answered_directory="Exercise/Chemistry/S3"
                                # Define the file extension
                                file_extension_answer=".1.carbon_in_life.ans.txt"
                                # Define the exercise file
                                exercise_file="../../chemistry_answered_ans.txt"
                                # Call the function to process a random question
                                process_question_answer "$answered_directory" "$file_extension_answer" "$exercise_file"
                                touch .chemistry.3.1
                            fi
                            if ! [ -f ".s_chemistry_3_2" ]; then
                                echo -e "\n\nYou happen to have decided to delve into Structures and bonds ...\n\nOnce again we treasure you ${g}dear one${t}\n\nWe promise to always be right here for you \c" && wait_for_a_key_press
                            fi
                            cp "Notes/Chemistry/3.2.structures_and_bonds.txt" . || exit 1
                            mv 3.2.structures_and_bonds.txt .3.2.structures_and_bonds.txt || exit 1
                            sed -i -e 's/\.\( \+\)/;/g' -e '/https:/! s/\([!?:]\)/\1;/g' -e 's/\([;]\) /\1/g' .3.2.structures_and_bonds.txt
                            sed -i 's/;\([:!?]\);/\;\1/g' .3.2.structures_and_bonds.txt
                            sed -i 's/;\([0-9]*\);/;\1. /g' .3.2.structures_and_bonds.txt
                            sed -i -E 's/(\([^)]*);/\1/g; s/(\[[^]]*);/\1/g; s/(\{[^}]*);/\1/g' .3.2.structures_and_bonds.txt
                            process_reminders_from_file .3.2.structures_and_bonds.txt
                            STATE_FILE=".s_chemistry_3_2"
                            process_file .3.2.structures_and_bonds.txt
                            contact_ai
                            if [ -f .resume_to_class ]; then
                                break
                            fi
                            if [ -f .skip_exercises ]; then
                                break
                            fi
                            rm -f .3.2.structures_and_bonds.txt
                            sed -i '/^1$/!d' .s_chemistry_3_2
                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S3"
                            # Define the file extension
                            file_extension_question=".2.structures_and_bonds.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_short_answer_question "$question_directory" "$file_extension_question" "$revision_file"
                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S3"
                            # Define the file extension
                            file_extension_question=".2.structures_and_bonds.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_aoi "$question_directory" "$file_extension_question" "$revision_file"
                        ;;
                        3)
                            if ! [ -f ".chemistry.3.2" ]; then
                                attempts=0
                                # Define the targeted directory
                                answered_directory="Exercise/Chemistry/S3"
                                # Define the file extension
                                file_extension_answer=".2.structures_and_bonds.ans.txt"
                                # Define the exercise file
                                exercise_file="../../chemistry_answered_ans.txt"
                                # Call the function to process a random question
                                process_question_answer "$answered_directory" "$file_extension_answer" "$exercise_file"
                                touch .chemistry.3.2
                            fi
                            if ! [ -f ".s_chemistry_3_3" ]; then
                                echo -e "\n\nYou have made a choice to cover Formulae, stoichiometry and mole concept ...\n\nWe are so exited to have you with us ${g}darling${t}\n\nRemember that hard work forever pays \c" && wait_for_a_key_press
                            fi
                            cp "Notes/Chemistry/3.3.formulae_stoichiometry_and_mole_concept.txt" . || exit 1
                            mv 3.3.formulae_stoichiometry_and_mole_concept.txt .3.3.formulae_stoichiometry_and_mole_concept.txt || exit 1
                            sed -i -e 's/\.\( \+\)/;/g' -e '/https:/! s/\([!?:]\)/\1;/g' -e 's/\([;]\) /\1/g' .3.3.formulae_stoichiometry_and_mole_concept.txt
                            sed -i 's/;\([:!?]\);/\;\1/g' .3.3.formulae_stoichiometry_and_mole_concept.txt
                            sed -i 's/;\([0-9]*\);/;\1. /g' .3.3.formulae_stoichiometry_and_mole_concept.txt
                            sed -i -E 's/(\([^)]*);/\1/g; s/(\[[^]]*);/\1/g; s/(\{[^}]*);/\1/g' .3.3.formulae_stoichiometry_and_mole_concept.txt
                            process_reminders_from_file .3.3.formulae_stoichiometry_and_mole_concept.txt
                            STATE_FILE=".s_chemistry_3_3"
                            process_file .3.3.formulae_stoichiometry_and_mole_concept.txt
                            contact_ai
                            if [ -f .resume_to_class ]; then
                                break
                            fi
                            if [ -f .skip_exercises ]; then
                                break
                            fi
                            rm -f .3.3.formulae_stoichiometry_and_mole_concept.txt
                            sed -i '/^1$/!d' .s_chemistry_3_3
                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S3"
                            # Define the file extension
                            file_extension_question=".3.formulae_stoichiometry_and_mole_concept.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_short_answer_question "$question_directory" "$file_extension_question" "$revision_file"
                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S3"
                            # Define the file extension
                            file_extension_question=".3.formulae_stoichiometry_and_mole_concept.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_aoi "$question_directory" "$file_extension_question" "$revision_file"
						;;
                        4)
                            if ! [ -f ".chemistry.3.3" ]; then
                                attempts=0
                                # Define the targeted directory
                                answered_directory="Exercise/Chemistry/S3"
                                # Define the file extension
                                file_extension_answer=".3.formulae_stoichiometry_and_mole_concept.ans.txt"
                                # Define the exercise file
                                exercise_file="../../chemistry_answered_ans.txt"
                                # Call the function to process a random question
                                process_question_answer "$answered_directory" "$file_extension_answer" "$exercise_file"
                                touch .chemistry.3.3
                            fi
                            if ! [ -f ".s_chemistry_3_4" ]; then
                                echo -e "\n\nYou did qualify to probe into the realm of Properties and structures of substances ...\n\nWe do treasure you ${g}darling${t}. Just never forget, that no matter how prepared you are, to win gold, you have to follow instructions! \c" && wait_for_a_key_press
                            fi
                            cp "Notes/Chemistry/3.4.properties_and_structures_of_substances.txt" . || exit 1
                            mv 3.4.properties_and_structures_of_substances.txt .3.4.properties_and_structures_of_substances.txt || exit 1
                            sed -i -e 's/\.\( \+\)/;/g' -e '/https:/! s/\([!?:]\)/\1;/g' -e 's/\([;]\) /\1/g' .3.4.properties_and_structures_of_substances.txt
                            sed -i 's/;\([:!?]\);/\;\1/g' .3.4.properties_and_structures_of_substances.txt
                            sed -i 's/;\([0-9]*\);/;\1. /g' .3.4.properties_and_structures_of_substances.txt
                            sed -i -E 's/(\([^)]*);/\1/g; s/(\[[^]]*);/\1/g; s/(\{[^}]*);/\1/g' .3.4.properties_and_structures_of_substances.txt
                            process_reminders_from_file .3.4.properties_and_structures_of_substances.txt
                            STATE_FILE=".s_chemistry_3_4"
                            process_file .3.4.properties_and_structures_of_substances.txt
                            contact_ai
                            if [ -f .resume_to_class ]; then
                                break
                            fi
                            if [ -f .skip_exercises ]; then
                                break
                            fi
                            rm -f .3.4.properties_and_structures_of_substances.txt
                            sed -i '/^1$/!d' .s_chemistry_3_4
                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S3"
                            # Define the file extension
                            file_extension=".4.properties_and_structures_of_substances.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_short_answer_question "$question_directory" "$file_extension" "$revision_file"
                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S3"
                            # Define the file extension
                            file_extension_question=".4.properties_and_structures_of_substances.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_aoi "$question_directory" "$file_extension_question" "$revision_file"
                        ;;
                        5)
                            if ! [ -f ".chemistry.3.4" ]; then
                                attempts=0
                                # Define the targeted directory
                                answered_directory="Exercise/Chemistry/S3"
                                # Define the file extension
                                file_extension_answer=".4.properties_and_structures_of_substances.ans.txt"
                                # Define the exercise file
                                exercise_file="../../chemistry_answered_ans.txt"
                                # Call the function to process a random question
                                process_question_answer "$answered_directory" "$file_extension_answer" "$exercise_file"
                                touch .chemistry.3.4
                            fi
                            if ! [ -f ".s_chemistry_3_5" ]; then
                                echo -e "\n\nHere you are dear one... Stay organised as you explore Fossil fuels ...\n\n${g}Just know we are not going to leave you alone${t}\n\nWe promise to always be right here for you \c" && wait_for_a_key_press
                            fi
                            cp "Notes/Chemistry/3.5.fossil_fuels.txt" . || exit 1
                            mv 3.5.fossil_fuels.txt .3.5.fossil_fuels.txt || exit 1
                            sed -i -e 's/\.\( \+\)/;/g' -e '/https:/! s/\([!?:]\)/\1;/g' -e 's/\([;]\) /\1/g' .3.5.fossil_fuels.txt
                            sed -i 's/;\([:!?]\);/\;\1/g' .3.5.fossil_fuels.txt
                            sed -i 's/;\([0-9]*\);/;\1. /g' .3.5.fossil_fuels.txt
                            sed -i -E 's/(\([^)]*);/\1/g; s/(\[[^]]*);/\1/g; s/(\{[^}]*);/\1/g' .3.5.fossil_fuels.txt
                            process_reminders_from_file .3.5.fossil_fuels.txt
                            STATE_FILE=".s_chemistry_3_5"
                            process_file .3.5.fossil_fuels.txt
                            contact_ai
                            if [ -f .resume_to_class ]; then
                                break
                            fi
                            if [ -f .skip_exercises ]; then
                                break
                            fi
                            rm -f .3.5.fossil_fuels.txt
                            sed -i '/^1$/!d' .s_chemistry_3_5
                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S3"
                            # Define the file extension
                            file_extension_question=".5.fossil_fuels.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_short_answer_question "$question_directory" "$file_extension_question" "$revision_file"
                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S3"
                            # Define the file extension
                            file_extension_question=".5.fossil_fuels.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_aoi "$question_directory" "$file_extension_question" "$revision_file"
                        ;;
                        6)
                            if ! [ -f ".chemistry.3.5" ]; then
                                attempts=0
                                # Define the targeted directory
                                answered_directory="Exercise/Chemistry/S3"
                                # Define the file extension
                                file_extension_answer=".5.fossil_fuels.ans.txt"
                                # Define the exercise file
                                exercise_file="../../chemistry_answered_ans.txt"
                                # Call the function to process a random question
                                process_question_answer "$answered_directory" "$file_extension_answer" "$exercise_file"
                                touch .chemistry.3.5
                            fi
                            if ! [ -f ".s_chemistry_3_6" ]; then
                                echo -e "\n\nYou have managed to make it to Chemical reactions ...\n\n${g}Remember to pray always${t}\n\nThe fear of the Lord is the beginning of wisdom \c" && wait_for_a_key_press
                            fi
                            cp "Notes/Chemistry/3.6.chemical_reactions.txt" . || exit 1
                            mv 3.6.chemical_reactions.txt .3.6.chemical_reactions.txt || exit 1
                            sed -i -e 's/\.\( \+\)/;/g' -e '/https:/! s/\([!?:]\)/\1;/g' -e 's/\([;]\) /\1/g' .3.6.chemical_reactions.txt
                            sed -i 's/;\([:!?]\);/\;\1/g' .3.6.chemical_reactions.txt
                            sed -i 's/;\([0-9]*\);/;\1. /g' .3.6.chemical_reactions.txt
                            sed -i -E 's/(\([^)]*);/\1/g; s/(\[[^]]*);/\1/g; s/(\{[^}]*);/\1/g' .3.6.chemical_reactions.txt
                            process_reminders_from_file .3.6.chemical_reactions.txt
                            STATE_FILE=".s_chemistry_3_6"
                            process_file .3.6.chemical_reactions.txt
                            contact_ai
                            if [ -f .resume_to_class ]; then
                                break
                            fi
                            if [ -f .skip_exercises ]; then
                                break
                            fi
                            rm -f .3.6.chemical_reactions.txt
                            sed -i '/^1$/!d' .s_chemistry_3_6
                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S3"
                            # Define the file extension
                            file_extension_question=".6.chemical_reactions.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_short_answer_question "$question_directory" "$file_extension_question" "$revision_file"
                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S3"
                            # Define the file extension
                            file_extension_question=".6.chemical_reactions.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_aoi "$question_directory" "$file_extension_question" "$revision_file"
                            if ! [ -f ".chemistry.3.6" ]; then
	                            attempts=0
	                            # Define the targeted directory
	                            answered_directory="Exercise/Chemistry/S3"
	                            # Define the file extension
	                            file_extension_answer=".6.chemical_reactions.ans.txt"
	                            # Define the exercise file
	                            exercise_file="../../chemistry_answered_ans.txt"
	                            # Call the function to process a random answer
	                            process_question_answer "$answered_directory" "$file_extension_answer" "$exercise_file"
								touch .chemistry.3.6
								echo "3" > .chemistry_ready
							fi
                        ;;

                        # Additional cases for other topics can be added here
                        *)
                            echo -e "\n\nInvalid topic number \c"
                            continue
                        ;;
                    esac
                    break  # Exit the inner loop after successfully handling user input
                fi
                ((attempts++))
            done
            # If the loop exits due to max_attempts, handle it
            if [ "$attempts" -eq "$max_attempts" ]; then
                quit1
            fi
        done
    elif [[ "$class" == "4" ]]; then
        if ! find . -maxdepth 1 -name '.s_chemistry_4*' -type f -quit 2>/dev/null; then
            echo -e "\n\n${g}Welcome to S4 Chemistry class${t}\n\n${y}Together, we are going to get you started${t} \c" && wait_for_a_key_press
            echo -e "\n-------------------------------------- \c"
            clear_and_center "There are ${r}6${t} topics to be covered. Your tasks will always expand or shrink to fit in the time you give them. For that reason, never procrastinate darling!"
        fi
        attempts=0
        max_attempts=4
        while true
        do
            while [ "$attempts" -lt "$max_attempts" ]
            do
                handle_s4_topic_input
                touch .chemistry_topic_selected
                if [[ "$topic" == "x" ]]
                then
                    quit
                elif [[ "$topic" == "q" ]]
                then
                    attempts=0
                    # Define the targeted directory
                    question_directory="Revision/Chemistry/S4"
                    # Define the file extension
                    file_extension_question=".qns.txt"
                    # Define the revision file
                    revision_file="../../chemistry_covered_qns.txt"
                    # Call the function to process a random question
                    process_random_short_answer_question "$question_directory" "$file_extension_question" "$revision_file"
                elif [[ "$topic" == "a" ]]
                then
                    attempts=0
                    # Define the targeted directory
                    question_directory="Revision/Chemistry/S4"
                    # Define the file extension
                    file_extension_question=".qns.txt"
                    # Define the revision file
                    revision_file="../../chemistry_covered_qns.txt"
                    # Call the function to process a random question
                    process_random_aoi "$question_directory" "$file_extension_question" "$revision_file"
                elif [[ "$topic" == "r" ]]
                then
                    attempts=0
                    # Define the targeted directory
                    answered_directory="Exercise/Chemistry/S4"
                    # Define the file extension
                    file_extension_answer=".ans.txt"
                    # Define the exercise file
                    exercise_file="../../chemistry_answered_ans.txt"
                    # Call the function to process a random question
                    process_question_answer "$answered_directory" "$file_extension_answer" "$exercise_file"
                elif [[ "$topic" == "s" ]]
                then
                    if [ -f Revision/.chemistry_samples ]
                    then
                        echo -e "\n\n${r}You are advised to not make any changes to the provided answers, instead, you can make a copy that you can edit${t}\n\n${y}Maximise the use of the find option in the text editor to get desired questions${t}\n\nFor a teacher willing to join us reach out to everyone of our children, please send us your questions and answers in a file labelled with your name and school to our contacts\n\n\nEmail: ${g}muhumuzaomega@gmail.com${t} \c"
                        wait_for_a_key_press
						cd Revision
                    explorer.exe .chemistry_samples
                    cd ..
                    else
                        echo -e "\nSorry, something wrong with your files! No sample items to display \c"
                    fi
                elif [[ "$topic" == "n" ]]
                then
                    attempts=0
                    # Define the targeted directory
                    answered_directory="Exercise/Chemistry/S4"
                    # Define the file extension
                    file_extension_answer=".ans.txt"
                    # Define the exercise file
                    exercise_file="../../chemistry_answered_ans.txt"
                    # Call the function to process a random question
                    process_final_assignment "$answered_directory" "$file_extension_answer" "$exercise_file"
                elif [[ "$topic" == "p" ]]
                then
                    track_student_progress
                elif [[ ! "$topic" =~ ^[1-6]$ || -z "$topic" ]]
                then
                    echo -e "\n\nTopic ${r}$topic not available${t}... Please choose from the available options\c"
                    wait_for_a_key_press
                else
                    case "$topic" in
                        1)
                            if ! [ -f ".s_chemistry_4_1" ]; then
                                echo -e "\n\nYou chose to explore Oxidation and reduction reactions ...\n\nThank you for choosing to educate yourself!\n\nWe adore you ${g}darling${t} and wish you the very best! \c" && wait_for_a_key_press
                            fi
                            cp "Notes/Chemistry/4.1.oxidation_and_reduction_reactions.txt" . || exit 1
                            mv 4.1.oxidation_and_reduction_reactions.txt .4.1.oxidation_and_reduction_reactions.txt || exit 1
                            sed -i -e 's/\.\( \+\)/;/g' -e '/https:/! s/\([!?:]\)/\1;/g' -e 's/\([;]\) /\1/g' .4.1.oxidation_and_reduction_reactions.txt
                            sed -i 's/;\([:!?]\);/\;\1/g' .4.1.oxidation_and_reduction_reactions.txt
                            sed -i 's/;\([0-9]*\);/;\1. /g' .4.1.oxidation_and_reduction_reactions.txt
                            sed -i -E 's/(\([^)]*);/\1/g; s/(\[[^]]*);/\1/g; s/(\{[^}]*);/\1/g' .4.1.oxidation_and_reduction_reactions.txt
                            process_reminders_from_file .4.1.oxidation_and_reduction_reactions.txt
                            STATE_FILE=".s_chemistry_4_1"
                            process_file .4.1.oxidation_and_reduction_reactions.txt
                            contact_ai
                            if [ -f .resume_to_class ]; then
                                break
                            fi
                            if [ -f .skip_exercises ]; then
                                break
                            fi
                            rm -f .4.1.oxidation_and_reduction_reactions.txt
                            sed -i '/^1$/!d' .s_chemistry_4_1
                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S4"
                            # Define the file extension
                            file_extension=".1.oxidation_and_reduction_reactions.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_short_answer_question "$question_directory" "$file_extension" "$revision_file"
                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S4"
                            # Define the file extension
                            file_extension_question=".1.oxidation_and_reduction_reactions.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_aoi "$question_directory" "$file_extension_question" "$revision_file"
                        ;;
                        2)
                            if ! [ -f ".chemistry.4.1" ]; then
                                attempts=0
                                # Define the targeted directory
                                answered_directory="Exercise/Chemistry/S4"
                                # Define the file extension
                                file_extension_answer=".1.oxidation_and_reduction_reactions.ans.txt"
                                # Define the exercise file
                                exercise_file="../../chemistry_answered_ans.txt"
                                # Call the function to process a random question
                                process_question_answer "$answered_directory" "$file_extension_answer" "$exercise_file"
                                touch .chemistry.4.1
                            fi
                            if ! [ -f ".s_chemistry_4_2" ]; then
                                echo -e "\n\nYou happen to have decided to delve into Industrial processes ...\n\nOnce again we treasure you ${g}dear one${t}\n\nWe promise to always be right here for you \c" && wait_for_a_key_press
                            fi
                            cp "Notes/Chemistry/4.2.industrial_processes.txt" . || exit 1
                            mv 4.2.industrial_processes.txt .4.2.industrial_processes.txt || exit 1
                            sed -i -e 's/\.\( \+\)/;/g' -e '/https:/! s/\([!?:]\)/\1;/g' -e 's/\([;]\) /\1/g' .4.2.industrial_processes.txt
                            sed -i 's/;\([:!?]\);/\;\1/g' .4.2.industrial_processes.txt
                            sed -i 's/;\([0-9]*\);/;\1. /g' .4.2.industrial_processes.txt
                            sed -i -E 's/(\([^)]*);/\1/g; s/(\[[^]]*);/\1/g; s/(\{[^}]*);/\1/g' .4.2.industrial_processes.txt
                            process_reminders_from_file .4.2.industrial_processes.txt
                            STATE_FILE=".s_chemistry_4_2"
                            process_file .4.2.industrial_processes.txt
                            contact_ai
                            if [ -f .resume_to_class ]; then
                                break
                            fi
                            if [ -f .skip_exercises ]; then
                                break
                            fi
                            rm -f .4.2.industrial_processes.txt
                            sed -i '/^1$/!d' .s_chemistry_4_2
                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S4"
                            # Define the file extension
                            file_extension_question=".2.industrial_processes.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_short_answer_question "$question_directory" "$file_extension_question" "$revision_file"
                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S4"
                            # Define the file extension
                            file_extension_question=".2.industrial_processes.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_aoi "$question_directory" "$file_extension_question" "$revision_file"
                        ;;
                        3)
                            if ! [ -f ".chemistry.4.2" ]; then
                                attempts=0
                                # Define the targeted directory
                                answered_directory="Exercise/Chemistry/S4"
                                # Define the file extension
                                file_extension_answer=".2.industrial_processes.ans.txt"
                                # Define the exercise file
                                exercise_file="../../chemistry_answered_ans.txt"
                                # Call the function to process a random question
                                process_question_answer "$answered_directory" "$file_extension_answer" "$exercise_file"
                                touch .chemistry.4.2
                            fi
                            if ! [ -f ".s_chemistry_4_3" ]; then
                                echo -e "\n\nYou have made a choice to cover Trends in the periodic table ...\n\nWe are so exited to have you with us ${g}darling${t}\n\nRemember that hard work forever pays \c" && wait_for_a_key_press
                            fi
                            cp "Notes/Chemistry/4.3.trends_in_the_periodic_table.txt" . || exit 1
                            mv 4.3.trends_in_the_periodic_table.txt .4.3.trends_in_the_periodic_table.txt || exit 1
                            sed -i -e 's/\.\( \+\)/;/g' -e '/https:/! s/\([!?:]\)/\1;/g' -e 's/\([;]\) /\1/g' .4.3.trends_in_the_periodic_table.txt
                            sed -i 's/;\([:!?]\);/\;\1/g' .4.3.trends_in_the_periodic_table.txt
                            sed -i 's/;\([0-9]*\);/;\1. /g' .4.3.trends_in_the_periodic_table.txt
                            sed -i -E 's/(\([^)]*);/\1/g; s/(\[[^]]*);/\1/g; s/(\{[^}]*);/\1/g' .4.3.trends_in_the_periodic_table.txt
                            process_reminders_from_file .4.3.trends_in_the_periodic_table.txt
                            STATE_FILE=".s_chemistry_4_3"
                            process_file .4.3.trends_in_the_periodic_table.txt
                            contact_ai
                            if [ -f .resume_to_class ]; then
                                break
                            fi
                            if [ -f .skip_exercises ]; then
                                break
                            fi
                            rm -f .4.3.trends_in_the_periodic_table.txt
                            sed -i '/^1$/!d' .s_chemistry_4_3
                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S4"
                            # Define the file extension
                            file_extension_question=".3.trends_in_the_periodic_table.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_short_answer_question "$question_directory" "$file_extension_question" "$revision_file"
                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S4"
                            # Define the file extension
                            file_extension_question=".3.trends_in_the_periodic_table.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_aoi "$question_directory" "$file_extension_question" "$revision_file"
						;;
                        4)
                            if ! [ -f ".chemistry.4.3" ]; then
                                attempts=0
                                # Define the targeted directory
                                answered_directory="Exercise/Chemistry/S4"
                                # Define the file extension
                                file_extension_answer=".3.trends_in_the_periodic_table.ans.txt"
                                # Define the exercise file
                                exercise_file="../../chemistry_answered_ans.txt"
                                # Call the function to process a random question
                                process_question_answer "$answered_directory" "$file_extension_answer" "$exercise_file"
                                touch .chemistry.4.3
                            fi
                            if ! [ -f ".s_chemistry_4_4" ]; then
                                echo -e "\n\nYou did qualify to probe into the realm of Energy changes during chemical reactions ...\n\nWe do treasure you ${g}darling${t}. Just never forget, that no matter how prepared you are, to win gold, you have to follow instructions! \c" && wait_for_a_key_press
                            fi
                            cp "Notes/Chemistry/4.4.energy_changes_during_chemical_reactions.txt" . || exit 1
                            mv 4.4.energy_changes_during_chemical_reactions.txt .4.4.energy_changes_during_chemical_reactions.txt || exit 1
                            sed -i -e 's/\.\( \+\)/;/g' -e '/https:/! s/\([!?:]\)/\1;/g' -e 's/\([;]\) /\1/g' .4.4.energy_changes_during_chemical_reactions.txt
                            sed -i 's/;\([:!?]\);/\;\1/g' .4.4.energy_changes_during_chemical_reactions.txt
                            sed -i 's/;\([0-9]*\);/;\1. /g' .4.4.energy_changes_during_chemical_reactions.txt
                            sed -i -E 's/(\([^)]*);/\1/g; s/(\[[^]]*);/\1/g; s/(\{[^}]*);/\1/g' .4.4.energy_changes_during_chemical_reactions.txt
                            process_reminders_from_file .4.4.energy_changes_during_chemical_reactions.txt
                            STATE_FILE=".s_chemistry_4_4"
                            process_file .4.4.energy_changes_during_chemical_reactions.txt
                            contact_ai
                            if [ -f .resume_to_class ]; then
                                break
                            fi
                            if [ -f .skip_exercises ]; then
                                break
                            fi
                            rm -f .4.4.energy_changes_during_chemical_reactions.txt
                            sed -i '/^1$/!d' .s_chemistry_4_4
                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S4"
                            # Define the file extension
                            file_extension=".4.energy_changes_during_chemical_reactions.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_short_answer_question "$question_directory" "$file_extension" "$revision_file"
                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S4"
                            # Define the file extension
                            file_extension_question=".4.energy_changes_during_chemical_reactions.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_aoi "$question_directory" "$file_extension_question" "$revision_file"
                        ;;
                        5)
                            if ! [ -f ".chemistry.4.4" ]; then
                                attempts=0
                                # Define the targeted directory
                                answered_directory="Exercise/Chemistry/S4"
                                # Define the file extension
                                file_extension_answer=".4.energy_changes_during_chemical_reactions.ans.txt"
                                # Define the exercise file
                                exercise_file="../../chemistry_answered_ans.txt"
                                # Call the function to process a random question
                                process_question_answer "$answered_directory" "$file_extension_answer" "$exercise_file"
                                touch .chemistry.4.4
                            fi
                            if ! [ -f ".s_chemistry_4_5" ]; then
                                echo -e "\n\nHere you are dear one... Stay organised as you explore Chemicals for consumers ...\n\n${g}Just know we are not going to leave you alone${t}\n\nWe promise to always be right here for you \c" && wait_for_a_key_press
                            fi
                            cp "Notes/Chemistry/4.5.chemicals_for_consumers.txt" . || exit 1
                            mv 4.5.chemicals_for_consumers.txt .4.5.chemicals_for_consumers.txt || exit 1
                            sed -i -e 's/\.\( \+\)/;/g' -e '/https:/! s/\([!?:]\)/\1;/g' -e 's/\([;]\) /\1/g' .4.5.chemicals_for_consumers.txt
                            sed -i 's/;\([:!?]\);/\;\1/g' .4.5.chemicals_for_consumers.txt
                            sed -i 's/;\([0-9]*\);/;\1. /g' .4.5.chemicals_for_consumers.txt
                            sed -i -E 's/(\([^)]*);/\1/g; s/(\[[^]]*);/\1/g; s/(\{[^}]*);/\1/g' .4.5.chemicals_for_consumers.txt
                            process_reminders_from_file .4.5.chemicals_for_consumers.txt
                            STATE_FILE=".s_chemistry_4_5"
                            process_file .4.5.chemicals_for_consumers.txt
                            contact_ai
                            if [ -f .resume_to_class ]; then
                                break
                            fi
                            if [ -f .skip_exercises ]; then
                                break
                            fi
                            rm -f .4.5.chemicals_for_consumers.txt
                            sed -i '/^1$/!d' .s_chemistry_4_5
                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S4"
                            # Define the file extension
                            file_extension_question=".5.chemicals_for_consumers.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_short_answer_question "$question_directory" "$file_extension_question" "$revision_file"
                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S4"
                            # Define the file extension
                            file_extension_question=".5.chemicals_for_consumers.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_aoi "$question_directory" "$file_extension_question" "$revision_file"
                        ;;
                        6)
                            if ! [ -f ".chemistry.4.5" ]; then
                                attempts=0
                                # Define the targeted directory
                                answered_directory="Exercise/Chemistry/S4"
                                # Define the file extension
                                file_extension_answer=".5.chemicals_for_consumers.ans.txt"
                                # Define the exercise file
                                exercise_file="../../chemistry_answered_ans.txt"
                                # Call the function to process a random question
                                process_question_answer "$answered_directory" "$file_extension_answer" "$exercise_file"
                                touch .chemistry.4.5
                            fi
                            if ! [ -f ".s_chemistry_4_6" ]; then
                                echo -e "\n\nYou have managed to make it to Nuclear processes ...\n\n${g}Remember to pray always${t}\n\nThe fear of the Lord is the beginning of wisdom \c" && wait_for_a_key_press
                            fi
                            cp "Notes/Chemistry/4.6.nuclear_processes.txt" . || exit 1
                            mv 4.6.nuclear_processes.txt .4.6.nuclear_processes.txt || exit 1
                            sed -i -e 's/\.\( \+\)/;/g' -e '/https:/! s/\([!?:]\)/\1;/g' -e 's/\([;]\) /\1/g' .4.6.nuclear_processes.txt
                            sed -i 's/;\([:!?]\);/\;\1/g' .4.6.nuclear_processes.txt
                            sed -i 's/;\([0-9]*\);/;\1. /g' .4.6.nuclear_processes.txt
                            sed -i -E 's/(\([^)]*);/\1/g; s/(\[[^]]*);/\1/g; s/(\{[^}]*);/\1/g' .4.6.nuclear_processes.txt
                            process_reminders_from_file .4.6.nuclear_processes.txt
                            STATE_FILE=".s_chemistry_4_6"
                            process_file .4.6.nuclear_processes.txt
                            contact_ai
                            if [ -f .resume_to_class ]; then
                                break
                            fi
                            if [ -f .skip_exercises ]; then
                                break
                            fi
                            rm -f .4.6.nuclear_processes.txt
                            sed -i '/^1$/!d' .s_chemistry_4_6
                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S4"
                            # Define the file extension
                            file_extension_question=".6.nuclear_processes.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_short_answer_question "$question_directory" "$file_extension_question" "$revision_file"
                            attempts=0
                            # Define the targeted directory
                            question_directory="Revision/Chemistry/S4"
                            # Define the file extension
                            file_extension_question=".6.nuclear_processes.qns.txt"
                            # Define the revision file
                            revision_file="../../chemistry_covered_qns.txt"
                            # Call the function to process a random question
                            process_random_aoi "$question_directory" "$file_extension_question" "$revision_file"
                            if ! [ -f ".chemistry.4.6" ]; then
	                            attempts=0
	                            # Define the targeted directory
	                            answered_directory="Exercise/Chemistry/S4"
	                            # Define the file extension
	                            file_extension_answer=".6.nuclear_processes.ans.txt"
	                            # Define the exercise file
	                            exercise_file="../../chemistry_answered_ans.txt"
	                            # Call the function to process a random answer
	                            process_question_answer "$answered_directory" "$file_extension_answer" "$exercise_file"
								touch .chemistry.4.6
								echo "4" > .chemistry_ready
							fi
                        ;;

                        # Additional cases for other topics can be added here
                        *)
                            echo -e "\n\nInvalid topic number \c"
                            continue
                        ;;
                    esac
                    break  # Exit the inner loop after successfully handling user input
                fi
                ((attempts++))
            done
            # If the loop exits due to max_attempts, handle it
            if [ "$attempts" -eq "$max_attempts" ]; then
                quit1
            fi
        done


    elif [[ "$class" == "3" || "$class" == "4" ]]; then
    echo -e "\n\nLessons for your class are still being developed.. Keep in touch \n"
	wait_for_a_key_press
	echo -e "\n\nYou could choose to fund the initiative by contacting us through our gmail \n"
	wait_for_a_key_press
    continue
    else
        echo -e "\n\nYou entered a wrong number, please choose from the available options \c"
		wait_for_a_key_press
        continue
    fi
done

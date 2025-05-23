#!/usr/bin/env bash
# set -x
# List of URLs for each section
section1=(
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/1.1.family.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/1.2.life_at_home.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/1.3.crops_plants_and_foods_in_our_area.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/1.4.animal_rearing.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/1.5.personal_and_community_hygiene.txt"
)
section1a=(
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/1.1.family.ans.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/1.2.life_at_home.ans.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/1.3.crops_plants_and_foods_in_our_area.ans.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/1.4.animal_rearing.ans.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/1.5.personal_and_community_hygiene.ans.txt"
)
section1b=(
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/1.1.family.qns.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/1.2.life_at_home.qns.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/1.3.crops_plants_and_foods_in_our_area.qns.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/1.4.animal_rearing.qns.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/1.5.personal_and_community_hygiene.qns.txt"
)
section2=(
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/2.1.establishing_and_managing_relationships.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/2.2.school_environment.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/2.3.public_places.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/2.4.traditional_ceremonies_naming.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/2.5.occupations_and_careers.txt"
)
section2a=(
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/2.1.establishing_and_managing_relationships.ans.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/2.2.school_environment.ans.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/2.3.public_places.ans.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/2.4.traditional_ceremonies_naming.ans.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/2.5.occupations_and_careers.ans.txt"
)
section2b=(
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/2.1.establishing_and_managing_relationships.qns.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/2.2.school_environment.qns.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/2.3.public_places.qns.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/2.4.traditional_ceremonies_naming.qns.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/2.5.occupations_and_careers.qns.txt"
)
section3=(
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/3.1.games_sports_and_leisure.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/3.2.indigenous_tourism.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/3.3.clans.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/3.4.wealth_creation.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/3.5.environmental_awareness.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/3.6.water.txt"
)
section3a=(
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/3.1.games_sports_and_leisure.ans.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/3.2.indigenous_tourism.ans.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/3.3.clans.ans.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/3.4.wealth_creation.ans.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/3.5.environmental_awareness.ans.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/3.6.water.ans.txt"
)
section3b=(
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/3.1.games_sports_and_leisure.qns.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/3.2.indigenous_tourism.qns.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/3.3.clans.qns.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/3.4.wealth_creation.qns.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/3.5.environmental_awareness.qns.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/3.6.water.qns.txt"
)
section4=(
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/4.1.migration_and_settlement.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/4.2.traditional_ceremonies_marriage_initiation_and_funeral_rites.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/4.3.cultural_values_morals_and_ethics.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/4.4.leadership_and_citizenship.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/4.5.human_rights.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/4.6.examinations_preparation_and_examinations.txt"
)
section4a=(
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/4.1.migration_and_settlement.ans.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/4.2.traditional_ceremonies_marriage_initiation_and_funeral_rites.ans.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/4.3.cultural_values_morals_and_ethics.ans.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/4.4.leadership_and_citizenship.ans.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/4.5.human_rights.ans.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/4.6.examinations_preparation_and_examinations.ans.txt"
)
section4b=(
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/4.1.migration_and_settlement.qns.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/4.2.traditional_ceremonies_marriage_initiation_and_funeral_rites.qns.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/4.3.cultural_values_morals_and_ethics.qns.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/4.4.leadership_and_citizenship.qns.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/4.5.human_rights.qns.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/4.6.examinations_preparation_and_examinations.qns.txt"
)
section5=(
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/runyankore-rukiga_samples.docx"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/e_o_c_runyankore-rukiga.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/e_o_c_runyankore-rukiga_1.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/e_o_c_runyankore-rukiga_1_samples_1.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/e_o_c_runyankore-rukiga_2.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/e_o_c_runyankore-rukiga_2_samples_1.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/e_o_c_runyankore-rukiga_3.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/e_o_c_runyankore-rukiga_3_samples_1.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/e_o_c_runyankore-rukiga_4.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/e_o_c_runyankore-rukiga_4_samples_1.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/e_o_c_runyankore-rukiga_5.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/RR/e_o_c_runyankore-rukiga_5_samples_1.txt"
)
# Function to download files from a list of URLs
download_files() {
    local urls=("$@")
    for url in "${urls[@]}"; do
        curl -O -L "$url" || echo -e "\n\nError fetching material for this tutorial: $url \c"
    done
}
# Download files for each section
cd Notes/Runyankore-rukiga/ || exit
download_files "${section1[@]}"
cd - > /dev/null 2>&1 || exit
# For Class 1
mkdir -p Students/Omd/Exercise/Runyankore-rukiga/S1/Downloads
cd Students/Omd/Exercise/Runyankore-rukiga/S1/Downloads || exit
download_files "${section1a[@]}"
# Loop through all .txt files in the current directory
for file in *.txt; do
    # Define the similar file in the previous directory
    similar_file="../$file"
    # Check if the similar file exists in the previous directory
    if [ -f "$similar_file" ]; then
        # Compare the current file with the similar one and capture new lines
        new_lines=$(diff --new-line-format="%L" --unchanged-line-format="" "$file" "$similar_file")
        # If there are new lines, append them to the target files
        if [ -n "$new_lines" ]; then
            # Define base directory for searching
            base_directory="$HOME/Omd"
            # Find target directories to append new lines
            find "$base_directory" -type d -path "*/Exercise/Runyankore-rukiga/S1" | while read -r target; do
                if [ "$target" != "$HOME/Omd/Students/Omd/Exercise/Runyankore-rukiga/S1" ]; then
                    echo "$new_lines" >> "$target/$file"
                fi
            done
        fi
    fi
done
cp ./*.txt "$HOME/Omd/Students/Omd/Exercise/Runyankore-rukiga/S1"
cd - > /dev/null 2>&1 || exit
rm -rf Students/Omd/Exercise/Runyankore-rukiga/S1/Downloads
mkdir -p Students/Omd/Revision/Runyankore-rukiga/S1/Downloads
cd Students/Omd/Revision/Runyankore-rukiga/S1/Downloads || exit
download_files "${section1b[@]}"
# Loop through all .txt files in the current directory
for file in *.txt; do
    # Define the similar file in the previous directory
    similar_file="../$file"
    # Check if the similar file exists in the previous directory
    if [ -f "$similar_file" ]; then
        # Compare the current file with the similar one and capture new lines
        new_lines=$(diff --new-line-format="%L" --unchanged-line-format="" "$file" "$similar_file")
        # If there are new lines, append them to the target files
        if [ -n "$new_lines" ]; then
            # Define base directory for searching
            base_directory="$HOME/Omd"
            # Find target directories to append new lines
            find "$base_directory" -type d -path "*/Revision/Runyankore-rukiga/S1" | while read -r target; do
                if [ "$target" != "$HOME/Omd/Students/Omd/Revision/Runyankore-rukiga/S1" ]; then
                    echo "$new_lines" >> "$target/$file"
                fi
            done
        fi
    fi
done
cp ./*.txt "$HOME/Omd/Students/Omd/Revision/Runyankore-rukiga/S1"
cd - > /dev/null 2>&1 || exit
rm -rf Students/Omd/Revision/Runyankore-rukiga/S1/Downloads
cd Notes/Runyankore-rukiga/ || exit
download_files "${section2[@]}"
cd - > /dev/null 2>&1 || exit
# For Class 2
mkdir -p Students/Omd/Exercise/Runyankore-rukiga/S2/Downloads
cd Students/Omd/Exercise/Runyankore-rukiga/S2/Downloads || exit
download_files "${section2a[@]}"
# Loop through all .txt files in the current directory
for file in *.txt; do
    similar_file="../$file"
    if [ -f "$similar_file" ]; then
        new_lines=$(diff --new-line-format="%L" --unchanged-line-format="" "$file" "$similar_file")
        if [ -n "$new_lines" ]; then
            base_directory="$HOME/Omd"
            find "$base_directory" -type d -path "*/Exercise/Runyankore-rukiga/S2" | while read -r target; do
                if [ "$target" != "$HOME/Omd/Students/Omd/Exercise/Runyankore-rukiga/S2" ]; then
                    echo "$new_lines" >> "$target/$file"
                fi
            done
        fi
    fi
done
cp ./*.txt "$HOME/Omd/Students/Omd/Exercise/Runyankore-rukiga/S2"
cd - > /dev/null 2>&1 || exit
rm -rf Students/Omd/Exercise/Runyankore-rukiga/S2/Downloads
mkdir -p Students/Omd/Revision/Runyankore-rukiga/S2/Downloads
cd Students/Omd/Revision/Runyankore-rukiga/S2/Downloads || exit
download_files "${section2b[@]}"
for file in *.txt; do
    similar_file="../$file"
    if [ -f "$similar_file" ]; then
        new_lines=$(diff --new-line-format="%L" --unchanged-line-format="" "$file" "$similar_file")
        if [ -n "$new_lines" ]; then
            base_directory="$HOME/Omd"
            find "$base_directory" -type d -path "*/Revision/Runyankore-rukiga/S2" | while read -r target; do
                if [ "$target" != "$HOME/Omd/Students/Omd/Revision/Runyankore-rukiga/S2" ]; then
                    echo "$new_lines" >> "$target/$file"
                fi
            done
        fi
    fi
done
cp ./*.txt "$HOME/Omd/Students/Omd/Revision/Runyankore-rukiga/S2"
cd - > /dev/null 2>&1 || exit
rm -rf Students/Omd/Revision/Runyankore-rukiga/S2/Downloads
cd Notes/Runyankore-rukiga/ || exit
download_files "${section3[@]}"
cd - > /dev/null 2>&1 || exit
# For Class 3
mkdir -p Students/Omd/Exercise/Runyankore-rukiga/S3/Downloads
cd Students/Omd/Exercise/Runyankore-rukiga/S3/Downloads || exit
download_files "${section3a[@]}"
for file in *.txt; do
    similar_file="../$file"
    if [ -f "$similar_file" ]; then
        new_lines=$(diff --new-line-format="%L" --unchanged-line-format="" "$file" "$similar_file")
        if [ -n "$new_lines" ]; then
            base_directory="$HOME/Omd"
            find "$base_directory" -type d -path "*/Exercise/Runyankore-rukiga/S3" | while read -r target; do
                if [ "$target" != "$HOME/Omd/Students/Omd/Exercise/Runyankore-rukiga/S3" ]; then
                    echo "$new_lines" >> "$target/$file"
                fi
            done
        fi
    fi
done
cp ./*.txt "$HOME/Omd/Students/Omd/Exercise/Runyankore-rukiga/S3"
cd - > /dev/null 2>&1 || exit
rm -rf Students/Omd/Exercise/Runyankore-rukiga/S3/Downloads
mkdir -p Students/Omd/Revision/Runyankore-rukiga/S3/Downloads
cd Students/Omd/Revision/Runyankore-rukiga/S3/Downloads || exit
download_files "${section3b[@]}"
for file in *.txt; do
    similar_file="../$file"
    if [ -f "$similar_file" ]; then
        new_lines=$(diff --new-line-format="%L" --unchanged-line-format="" "$file" "$similar_file")
        if [ -n "$new_lines" ]; then
            base_directory="$HOME/Omd"
            find "$base_directory" -type d -path "*/Revision/Runyankore-rukiga/S3" | while read -r target; do
                if [ "$target" != "$HOME/Omd/Students/Omd/Revision/Runyankore-rukiga/S3" ]; then
                    echo "$new_lines" >> "$target/$file"
                fi
            done
        fi
    fi
done
cp ./*.txt "$HOME/Omd/Students/Omd/Revision/Runyankore-rukiga/S3"
cd - > /dev/null 2>&1 || exit
rm -rf Students/Omd/Revision/Runyankore-rukiga/S3/Downloads
cd Notes/Runyankore-rukiga/ || exit
download_files "${section4[@]}"
cd - > /dev/null 2>&1 || exit
# For Class 4
mkdir -p Students/Omd/Exercise/Runyankore-rukiga/S4/Downloads
cd Students/Omd/Exercise/Runyankore-rukiga/S4/Downloads || exit
download_files "${section4a[@]}"
for file in *.txt; do
    similar_file="../$file"
    if [ -f "$similar_file" ]; then
        new_lines=$(diff --new-line-format="%L" --unchanged-line-format="" "$file" "$similar_file")
        if [ -n "$new_lines" ]; then
            base_directory="$HOME/Omd"
            find "$base_directory" -type d -path "*/Exercise/Runyankore-rukiga/S4" | while read -r target; do
                if [ "$target" != "$HOME/Omd/Students/Omd/Exercise/Runyankore-rukiga/S4" ]; then
                    echo "$new_lines" >> "$target/$file"
                fi
            done
        fi
    fi
done
cp ./*.txt "$HOME/Omd/Students/Omd/Exercise/Runyankore-rukiga/S4"
cd - > /dev/null 2>&1 || exit
rm -rf Students/Omd/Exercise/Runyankore-rukiga/S4/Downloads
mkdir -p Students/Omd/Revision/Runyankore-rukiga/S4/Downloads
cd Students/Omd/Revision/Runyankore-rukiga/S4/Downloads || exit
download_files "${section4b[@]}"
for file in *.txt; do
    similar_file="../$file"
    if [ -f "$similar_file" ]; then
        new_lines=$(diff --new-line-format="%L" --unchanged-line-format="" "$file" "$similar_file")
        if [ -n "$new_lines" ]; then
            base_directory="$HOME/Omd"
            find "$base_directory" -type d -path "*/Revision/Runyankore-rukiga/S4" | while read -r target; do
                if [ "$target" != "$HOME/Omd/Students/Omd/Revision/Runyankore-rukiga/S4" ]; then
                    echo "$new_lines" >> "$target/$file"
                fi
            done
        fi
    fi
done
cp ./*.txt "$HOME/Omd/Students/Omd/Revision/Runyankore-rukiga/S4"
cd - > /dev/null 2>&1 || exit
rm -rf Students/Omd/Revision/Runyankore-rukiga/S4/Downloads
# The Items
cd Students/Omd/Revision/Runyankore-rukiga/ || exit
download_files "${section5[@]}"
mv runyankore-rukiga_samples.docx .runyankore-rukiga_samples.docx
for file in e_o_c_runyankore-rukiga.txt e_o_c_runyankore-rukiga_1.txt e_o_c_runyankore-rukiga_1_samples_1.txt e_o_c_runyankore-rukiga_2.txt e_o_c_runyankore-rukiga_2_samples_1.txt e_o_c_runyankore-rukiga_3.txt e_o_c_runyankore-rukiga_3_samples_1.txt e_o_c_runyankore-rukiga_4.txt e_o_c_runyankore-rukiga_4_samples_1.txt e_o_c_runyankore-rukiga_5.txt e_o_c_runyankore-rukiga_5_samples_1.txt; do
    hidden_file=".$file"
    if [ -f "$hidden_file" ]; then
        # Compare the current file with the hidden one and capture new lines
        new_lines=$(diff --new-line-format="%L" --unchanged-line-format="" "$file" "$hidden_file")
        # If there are new lines, append them to the target files
        if [ -n "$new_lines" ]; then
            # Define base directory for searching
            base_directory="$HOME/Omd"
            # Find target directories and append new lines
            find "$base_directory" -type d -path "*/Revision/Runyankore-rukiga" | while read -r target; do
                # Ensure we are not appending to the source directory
                if [ "$target" != "$HOME/Omd/Students/Omd/Revision/Runyankore-rukiga" ]; then
                    echo "$new_lines" >> "$target/$hidden_file"
                fi
            done
        fi
    fi
    # Move the current file to make it hidden
    mv "$file" "$hidden_file"
done
cd - > /dev/null 2>&1 || exit

SRC1="$HOME/Omd/Students/Omd/Exercise/Runyankore-rukiga"
DEST1="$HOME/Omd/Exercise/Runyankore-rukiga"
SRC2="$HOME/Omd/Students/Omd/Revision/Runyankore-rukiga"
DEST2="$HOME/Omd/Revision/Runyankore-rukiga"
if ! find "$DEST1" -type f -name "*.ans.txt" | grep -q .; then
  cp -r "$SRC1"/. "$DEST1" > /dev/null 2>&1
fi
if find "$DEST2" -type f -name "*.qns.txt" | grep -q .; then
  read -rp $'\n\nExisting exercise and revision files have been detected.\n\nUpdating them now may overwrite your current progress.\n\nIf you want to continue and overwrite, type "yes" or "y".\nOtherwise, press Enter to cancel: ' prompt
  if [[ "$prompt" == "yes" || "$prompt" == "y" ]]; then
    cp -r "$SRC1"/. "$DEST1" > /dev/null 2>&1
    cp -r "$SRC2"/. "$DEST2" > /dev/null 2>&1
    echo -e "\nExercise and revision files successfully updated!"
  else
    echo -e "\nUpdate cancelled. Existing exercise and revision files remain untouched!"
  fi
else
  cp -r "$SRC2"/. "$DEST2" > /dev/null 2>&1
fi
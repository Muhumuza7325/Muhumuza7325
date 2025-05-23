#!/usr/bin/env bash
# set -x
# List of URLs for each section
section1=(
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/MSBT/1.2.bioconductor_and_r.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/MSBT/1.3.biounix_and_shell_scripting.txt"
)
section1a=(
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/MSBT/1.2.bioconductor_and_r.ans.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/MSBT/1.3.biounix_and_shell_scripting.ans.txt"
)
section1b=(
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/MSBT/1.2.bioconductor_and_r.qns.txt"
    "https://github.com/Muhumuza7325/Muhumuza7325/raw/main/MSBT/1.3.biounix_and_shell_scripting.qns.txt"
)
# Function to download files from a list of URLs
download_files() {
    local urls=("$@")
    for url in "${urls[@]}"; do
        curl -O -L "$url" || echo -e "\n\nError fetching material for this tutorial: $url \c"
    done
}
# Download files for each section
cd Notes/Msbt/ || exit
download_files "${section1[@]}"
cd - > /dev/null 2>&1 || exit
# For Class 1
mkdir -p Students/Omd/Exercise/Msbt/Sem1_Yr1/Downloads
cd Students/Omd/Exercise/Msbt/Sem1_Yr1/Downloads || exit
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
            find "$base_directory" -type d -path "*/Exercise/Msbt/Sem1_Yr1" | while read -r target; do
                if [ "$target" != "$HOME/Omd/Students/Omd/Exercise/Msbt/Sem1_Yr1" ]; then
                    echo "$new_lines" >> "$target/$file"
                fi
            done
        fi
    fi
done
cp ./*.txt "$HOME/Omd/Students/Omd/Exercise/Msbt/Sem1_Yr1"
cd - > /dev/null 2>&1 || exit
rm -rf Students/Omd/Exercise/Msbt/Sem1_Yr1/Downloads
mkdir -p Students/Omd/Revision/Msbt/Sem1_Yr1/Downloads
cd Students/Omd/Revision/Msbt/Sem1_Yr1/Downloads || exit
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
            find "$base_directory" -type d -path "*/Revision/Msbt/Sem1_Yr1" | while read -r target; do
                if [ "$target" != "$HOME/Omd/Students/Omd/Revision/Msbt/Sem1_Yr1" ]; then
                    echo "$new_lines" >> "$target/$file"
                fi
            done
        fi
    fi
done
cp ./*.txt "$HOME/Omd/Students/Omd/Revision/Msbt/Sem1_Yr1"
cd - > /dev/null 2>&1 || exit
rm -rf Students/Omd/Revision/Msbt/Sem1_Yr1/Downloads
cd Notes/Msbt/ || exit
exit

SRC1="$HOME/Omd/Students/Omd/Exercise/Msbt"
DEST1="$HOME/Omd/Exercise/Msbt"
SRC2="$HOME/Omd/Students/Omd/Revision/Msbt"
DEST2="$HOME/Omd/Revision/Msbt"
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
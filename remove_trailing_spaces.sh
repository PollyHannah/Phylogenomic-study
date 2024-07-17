
#!/bin/bash

# Directory containing .fa files
directory="/data/polly/megalocytivirus-project/orthofinder/Results_Jul15/MultipleSequenceAlignments"

# Loop through files in the directory
for filename in "$directory"/*.fa; do
    # Check if filename ends with .fa
    if [ -f "$filename" ]; then
        # Read file contents
        content=$(<"$filename")

        # Check and remove trailing space if present
        if [[ "$content" == *' '* ]]; then
            content=$(echo "$content" | sed 's/[[:space:]]*$//')

            # Write modified content back to file
            echo "$content" > "$filename"

            echo "Trailing space removed from: $(basename "$filename")"
        else
            echo "No trailing space found in: $(basename "$filename")"
        fi
    fi
done
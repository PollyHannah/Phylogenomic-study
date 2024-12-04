#!/bin/bash

# Output directory
output_dir="/scratch3/han394/mcv/prokka_outputs/proteome"

# Loop through all .txt files in the current directory
for input_file in *.txt; do
    # Generate the output filename by replacing .txt with .faa
    output_file="$output_dir/${input_file%.txt}.faa"

    # Initialize the output file
    > "$output_file"

    # Read the input file line by line
    while IFS=, read -r locus_tag product sequence; do
        # Trim leading/trailing spaces
        locus_tag=$(echo "$locus_tag" | xargs)
        product=$(echo "$product" | xargs)
        sequence=$(echo "$sequence" | xargs)

        # Append the FASTA formatted string to the output file
        echo ">$locus_tag $product" >> "$output_file"

        # Wrap the sequence to 80 characters per line
        echo "$sequence" | fold -w 80 >> "$output_file"
    done < "$input_file"

    echo "Processed $input_file into $output_file"
done

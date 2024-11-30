#!/bin/bash

# Input files
TAXONOMY_FILE="./taxonomy.csv"  # Taxonomy file in the current directory
ORTHOGROUPS_FILE="./orthofinder_1/Results_Nov29/Orthogroups/Orthogroups.tsv"  # Path to Orthogroups.tsv
OUTPUT_FILE="1_results_summary.csv"  # Output file

# Temporary files
SORTED_TAXONOMY="sorted_taxonomy.csv"
FILTERED_ORTHOGROUPS="filtered_orthogroups.tsv"

# Step 1: Preprocess taxonomy.csv to map Accession to "Genus_Species_Accession"
awk -F',' 'NR > 1 {print $1 "," $2 "_" $3 "_" $1}' "$TAXONOMY_FILE" > "$SORTED_TAXONOMY"

# Step 2: Filter orthogroups with 100% genome representation
awk -F'\t' '
NR == 1 {
    total_genomes = NF - 1; # First column is Orthogroup
    print $0; # Keep the header row
}
NR > 1 {
    filled_count = 0;
    for (i = 2; i <= NF; i++) {
        if ($i != "") {
            filled_count++;
        }
    }
    if (filled_count == total_genomes) {
        print $0;
    }
}' "$ORTHOGROUPS_FILE" > "$FILTERED_ORTHOGROUPS"

# Step 3: Generate output headers
echo -n "Orthogroups" > "$OUTPUT_FILE"
awk -F',' '{print "," $2}' "$SORTED_TAXONOMY" | tr '\n' ',' | sed 's/,$/\n/' >> "$OUTPUT_FILE"

# Step 4: Process orthogroups and map locus tags
tail -n +2 "$FILTERED_ORTHOGROUPS" | \
while IFS=$'\t' read -r line; do
    # Extract the orthogroup and tags
    orthogroup=$(echo "$line" | cut -f1)
    tags=$(echo "$line" | cut -f2-)

    # Start the row with the orthogroup name
    echo -n "$orthogroup" >> "$OUTPUT_FILE"

    # Append locus tags for each genome
    for accession in $(cut -d',' -f1 "$SORTED_TAXONOMY"); do
        tag=$(echo "$tags" | awk -v FS='\t' -v OFS=',' -v acc="$accession" '$1 == acc {print $2}')
        echo -n ",$tag" >> "$OUTPUT_FILE"
    done

    # Newline at the end of the row
    echo "" >> "$OUTPUT_FILE"
done

# Cleanup
rm -f "$SORTED_TAXONOMY" "$FILTERED_ORTHOGROUPS"
echo "Processing complete. Output saved to $OUTPUT_FILE."
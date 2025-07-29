#!/bin/bash

# === CONFIGURATION ===
ALIGNMENT="whole_genome_alignment_mauve_rdp.fasta"   # Main alignment file
SET_FILE="extract_sets.txt"                          # Tab-delimited input file
OUTDIR="alignments"                                  # Output directory for both trimmed & subsampled alignments
STEP_SIZE=10                                          # Subsampling step size
SNIPIT_OUTDIR="snipit"                               # Directory to store snipit PNGs

# Create necessary directories
mkdir -p "$OUTDIR"
mkdir -p "$SNIPIT_OUTDIR"

# === FUNCTIONS ===
extract_and_trim_sequences() {
    local setname="$1"
    shift
    local start="${@: -2:1}"  # Second last argument
    local end="${@: -1}"      # Last argument
    local outfile="${OUTDIR}/${setname}.fasta"
    local tmpfile="${outfile}.tmp"
    local ids=("${@:1:$#-2}") # All except last two

    # Step 1: Extract untrimmed sequences to a temporary file
    awk -v id1="${ids[0]}" -v id2="${ids[1]}" -v id3="${ids[2]}" -v id4="${ids[3]}" -v num_ids="${#ids[@]}" '
        BEGIN {
            if (num_ids >= 1) wanted[1] = id1;
            if (num_ids >= 2) wanted[2] = id2;
            if (num_ids >= 3) wanted[3] = id3;
            if (num_ids >= 4) wanted[4] = id4;
        }
        /^>/ {
            name = substr($0, 2);
            current = "";
            for (i = 1; i <= num_ids; i++) {
                if (index(name, wanted[i]) > 0) {
                    matchname[wanted[i]] = name;
                    current = name;
                    break;
                }
            }
            next;
        }
        current != "" {
            seq[current] = seq[current] $0;
        }
        END {
            for (i = 1; i <= num_ids; i++) {
                id = wanted[i];
                if (id in matchname) {
                    name = matchname[id];
                    split(name, parts, "_");
                    label = (length(parts) >= 2) ? parts[1] "|" parts[2] : name;
                    printf(">%s\n%s\n", label, seq[name]);
                } else {
                    printf("Warning: %s not found in alignment.\n", id) > "/dev/stderr";
                }
            }
        }
    ' "$ALIGNMENT" > "$tmpfile"

    # Step 2: Trim to specified start–end coordinates and overwrite final output
    awk -v start="$start" -v end="$end" '
        /^>/ {
            print; next
        }
        {
            print substr($0, start, end - start + 1)
        }
    ' "$tmpfile" > "$outfile"

    # Step 3: Clean up
    rm -f "$tmpfile"
}

# === MAIN ===
while read -r line; do
    # Skip comments and blank lines
    [[ "$line" =~ ^#.*$ || -z "$line" ]] && continue

    # Split line by both tabs and spaces
    IFS=$'\t ' read -ra fields <<< "$line"

    setname="${fields[0]}"
    start="${fields[-2]}"
    end="${fields[-1]}"
    genomes=("${fields[@]:1:${#fields[@]}-3}")  # Skip setname, start, and end

    echo "?? Processing $setname: [${genomes[*]}] from $start to $end"
    extract_and_trim_sequences "$setname" "${genomes[@]}" "$start" "$end"

done < "$SET_FILE"


echo "? All trimmed alignments saved in ./${OUTDIR}/"
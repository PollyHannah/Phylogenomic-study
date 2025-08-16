#!/bin/bash

# Define source and target directory pairs
declare -A dir_pairs=(
  ["alignments_family_muscle5_edited_trimmed"]="alignments_family_muscle5_edited_trimmed_concatenation"
  ["alignments_genus_muscle5_edited_trimmed"]="alignments_genus_muscle5_edited_trimmed_concatoenation"
  ["alignments_species_muscle5_edited_trimmed"]="alignments_species_muscle5_edited_trimmed_concatenation"
)

# Define OG lists
family_ogs=(
  OG0000001 OG0000003 OG0000004 OG0000005 OG0000006 OG0000008 OG0000009
  OG0000010 OG0000011 OG0000012 OG0000013 OG0000014 OG0000015 OG0000016 OG0000018
  OG0000020 OG0000022 OG0000023 OG0000025 OG0000026 OG0000027
)

genus_ogs=(
  OG0000000 OG0000001 OG0000002 OG0000003 OG0000004 OG0000006 OG0000007 OG0000009 OG0000010
  OG0000011 OG0000012 OG0000013 OG0000014 OG0000015 OG0000016 OG0000017 OG0000019 OG0000020
  OG0000021 OG0000022 OG0000023 OG0000024 OG0000025 OG0000028 OG0000029 OG0000030 OG0000031
  OG0000032 OG0000033 OG0000034 OG0000035 OG0000037 OG0000038 OG0000039 OG0000040 OG0000041
  OG0000043 OG0000045 OG0000047 OG0000048 OG0000049 OG0000052 OG0000053 OG0000055
  OG0000056 OG0000060 OG0000061 OG0000109
)

species_ogs=(
  OG0000002 OG0000004 OG0000005 OG0000011 OG0000012 OG0000016 OG0000018 OG0000019 OG0000020
  OG0000023 OG0000024 OG0000041 OG0000051 OG0000056 OG0000057 OG0000059 OG0000060 OG0000061
  OG0000062 OG0000063 OG0000064 OG0000065 OG0000066 OG0000067 OG0000068 OG0000069 OG0000070
  OG0000074 OG0000075 OG0000077 OG0000078 OG0000079 OG0000083 OG0000084 OG0000085 OG0000088
  OG0000092 OG0000093 OG0000097 OG0000101 OG0000103 OG0000109 OG0000110 OG0000111
)

# Function to copy files
copy_files() {
  local src_dir=$1
  local dst_dir=$2
  shift 2
  local og_list=("$@")

  mkdir -p "$dst_dir"

  for og in "${og_list[@]}"; do
    matches=("$src_dir"/"$og"*.fa)
    if compgen -G "${matches[0]}" > /dev/null; then
      for f in "${matches[@]}"; do
        cp "$f" "$dst_dir"
        echo "Copied $f to $dst_dir"
      done
    else
      echo "Warning: No file found for $og in $src_dir"
    fi
  done
}

# Run the copy for each set
copy_files "alignments_family_muscle5_edited_trimmed" \
           "alignments_family_muscle5_edited_trimmed_concatenation" "${family_ogs[@]}"

copy_files "alignments_genus_muscle5_edited_trimmed" \
           "alignments_genus_muscle5_edited_trimmed_concatenation" "${genus_ogs[@]}"

copy_files "alignments_species_muscle5_edited_trimmed" \
           "alignments_species_muscle5_edited_trimmed_concatenation" "${species_ogs[@]}"

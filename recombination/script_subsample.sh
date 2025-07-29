input="alignments/34.fasta"
output="alignments/34.fasta"
step=10
tmpfile="${output}.tmp"

awk -v step="$step" '
    /^>/ {
        print; next
    }
    {
        seq = ""
        for (i = 1; i <= length($0); i += step) {
            seq = seq substr($0, i, 1)
        }
        print seq
    }
' "$input" > "$tmpfile"

mv "$tmpfile" "$output"

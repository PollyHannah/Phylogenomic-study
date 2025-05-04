#!/usr/bin/env python3

import os
import sys
from collections import defaultdict
from Bio import SeqIO

# List of known accession IDs that contain underscores
known_accessions_with_underscores = {
    "PQ335173_PQ335174",
    "NC_003494",
    "NC_005946"
}

def get_accession(header):
    # Extract the accession portion from the header
    parts = header.split("_")
    for i in range(len(parts), 0, -1):
        candidate = "_".join(parts[:i])
        if candidate in known_accessions_with_underscores:
            return candidate
    return parts[0]  # Fallback for general case

def read_alignments(folder):
    alignments = []
    taxa = set()
    for fname in sorted(os.listdir(folder)):
        if fname.endswith((".fasta", ".fa", ".aln")):
            path = os.path.join(folder, fname)
            seqs = {}
            for record in SeqIO.parse(path, "fasta"):
                acc = get_accession(record.id)
                seqs[acc] = str(record.seq)
                taxa.add(acc)
            alignments.append(seqs)
    return alignments, sorted(taxa)

def concatenate_alignments(alignments, taxa):
    concatenated = defaultdict(str)
    for aln in alignments:
        length = max(len(seq) for seq in aln.values())
        for taxon in taxa:
            concatenated[taxon] += aln.get(taxon, "-" * length)
    return concatenated

def write_fasta(concatenated, output_file):
    with open(output_file, "w") as out:
        for taxon, seq in concatenated.items():
            out.write(f">{taxon}\n{seq}\n")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python concatenate_alignments.py <input_folder> <output_fasta>")
        sys.exit(1)

    folder = sys.argv[1]
    output = sys.argv[2]

    alignments, taxa = read_alignments(folder)
    concatenated = concatenate_alignments(alignments, taxa)
    write_fasta(concatenated, output)

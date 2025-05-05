#!/usr/bin/env python3

import os
import sys
from collections import defaultdict
from Bio import SeqIO

def read_alignments(folder):
    alignments = []
    taxa = set()
    for fname in sorted(os.listdir(folder)):
        if fname.endswith((".fasta", ".fa", ".aln")):
            path = os.path.join(folder, fname)
            seqs = {}
            for record in SeqIO.parse(path, "fasta"):
                taxon = record.id  # Use full sequence name
                seqs[taxon] = str(record.seq)
                taxa.add(taxon)
            alignments.append(seqs)
    return alignments, sorted(taxa)

def concatenate_alignments(alignments, taxa):
    concatenated = defaultdict(str)
    for aln in alignments:
        length = max(len(seq) for seq in aln.values()) if aln else 0
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

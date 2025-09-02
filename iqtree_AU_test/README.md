# AU Test

In one locus (OG0000002 at the family level), the MCV genomes were not monophyletic, and this had high bootstrap support.

In this analysis I first copied the alignment and treefile for this locus:

* `OG0000002.fa`
* `OG0000002.fa.treefile`

I then made a constraint file that specifies that MCV genomes are monophyletic:

* `OG0000002_constraints.txt`


I then ran IQ-TREE on the constraint file in the same was as it was run to get the original tree, and then compared the two trees with an AU test. Note that the original analysis selected the model `Q.iridoviridae+I+G4` so I use that here too. 

```bash
iqtree2 -s OG0000002.fa -B 1000 -m Q.iridoviridae+I+G4 -g OG0000002_constraints.txt -pre OG0000002_constrained

cat OG0000002.fa.treefile OG0000002_constrained.treefile > trees.treefile 

iqtree2 -s OG0000002.fa -m Q.iridoviridae+I+G -z trees.treefile -n 0 -zb 1000000 -au
```

## Results

The results are in the .iqtree file, reproduced below. They show that we cannot reject the monophyletic tree in favour of the non-monophyletic tree, suggesting that the non-monophyly is more likely to be due to stochastic error in the tree. Consistent with this, the difference in likelihoods between the trees is extremely small (just 1.29 units).

```
Tree      logL    deltaL  bp-RELL    p-KH     p-SH       c-ELW       p-AU
-------------------------------------------------------------------------
  1 -13065.14626       0   0.606 +  0.607 +      1 +       0.6 +    0.606 + 
  2 -13066.43516  1.2889   0.394 +  0.393 +  0.393 +       0.4 +    0.394 + 

deltaL  : logL difference from the maximal logl in the set.
bp-RELL : bootstrap proportion using RELL method (Kishino et al. 1990).
p-KH    : p-value of one sided Kishino-Hasegawa test (1989).
p-SH    : p-value of Shimodaira-Hasegawa test (2000).
c-ELW   : Expected Likelihood Weight (Strimmer & Rambaut 2002).
p-AU    : p-value of approximately unbiased (AU) test (Shimodaira, 2002).

Plus signs denote the 95% confidence sets.
Minus signs denote significant exclusion.
All tests performed 1000000 resamplings using the RELL method.
```


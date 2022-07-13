# BaseInstances
Repository with instances to use as a base for checking implementations

## How to use this repository

This repository is mainly intended to be used with the **MatHH** framework but we also seek to provide support for other alternatives. So, most datasets are given in a dual format. One of them is Matlab-based and MatHH-compatible, and we called it **mat**. The other is usually a raw text format related to the original source of the dataset. So, it may be called **txt**, **data**, or **xml**, just to name a few. Within these folders you should find a folder called **Instances**, which contains a subfolder for each dataset. 

## How to contribute

1. Define a folder per combinatorial problem and put information inside. Matlab files (*.mat) are preferred but raw text instances are also welcome. 
2. Update this Readme with information about the new set of instances.

**Note: Provide instance data and expected solution (with/without heuristics), and as much information as possible. If feasible, provide instance as a loadable file and as a text file. In the former, provide a readme with information about how to read such a file.**

## Available datasets

The following datasets are currently available: 

### Job Shop Scheduling Problems
| **Dataset** | **Description**		| **Available formats** | **Folder names** | **Total instances**|
| ---- | ---- |---- | ---- | ---- |
|Taillard | Traditional dataset published by Taillard using a random number generator | mat txt | TaillardWeb1515, TaillardWeb2015, TaillardWeb2020, TaillardWeb3015, TaillardWeb3020, TaillardWeb5015, TaillardWeb5020, TaillardWeb10020 | 80 |
|OR-Library | Traditional dataset that compiles instances from Adams, Balas, and Zawack, from Fisher and Thompson, from Lawrence, from Applegate and Cook, from Storer, Wu, and Vaccari, and from Yamada and Nakano | mat  txt| ORLibrary | 82 |
|Known Optima | Dataset proposed by Giacomo Da Col, Erich Teppan about instances with known optimal solutions | mat data | KnownOptima_Benchmark | 24 |
|Large TA | Dataset proposed by Giacomo Da Col, Erich Teppan about large instances that are supposed to resemble real-life scenarios | mat data | LargeTA_Benchmark | 90 |

### Balanced Partition Problems

## References
- Taillard instances: http://mistic.heig-vd.ch/taillard/problemes.dir/ordonnancement.dir/ordonnancement.html
- OR-Library instances: http://people.brunel.ac.uk/~mastjjb/jeb/orlib/files/jobshop1.txt
- Known Optima and Large TA instances: https://arxiv.org/src/2102.08778v2/anc

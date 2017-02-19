# Minimal-Pair-Counts
A survey of minimal pair counts in a range of languages

![Graphs of minimal pair counts](https://github.com/kaplanas/Minimal-Pair-Counts/blob/master/nonzero_model_illustration.png)

## About
This is an ongoing project that surveys the number of minimal pairs in languages with varying levels of documentation.  The basic idea is to predict the number of minimal pairs observed in a given language from the following factors:

+ The recorded vocabulary size of the language.
+ The average word length in the language.
+ The number of distinct segments in the language.

## Databases
We have collected wordlists from the following databases:

+ *CHIRILA:* ~300 indigenous Australian languages (more information [here](http://www.pamanyungan.net/chirila/about-the-chirila-database/))
+ *POLLEX:* 67 Polynesian languages (more information [here](https://pollex.shh.mpg.de/))
+ *The Tower of Babel:* ~800 languages (more information [here](http://starling.rinet.ru/cgi-bin/main.cgi?root=config))
+ *"CELEX+":* English/German/Dutch from CELEX, plus 5 other major languages from other databases

## Preliminary Conclusions
+ There is a roughly linear relationship between the log recorded vocabulary of a language and the log number of minimal pairs.
+ Compared to spoken languages, Kenyan Sign Language (KSL) has somewhat fewer minimal pairs than expected for a language of its size, but it is within the range of observed variation.
+ Major world languages such as English have far fewer minimal pairs than expected.

For more detail, see [this](https://github.com/kaplanas/Minimal-Pair-Counts/blob/master/minimal_pair_counts.pdf).

## Sample Code
The code samples here illustrate how the data was cleaned and analyzed, *for the Tower of Babel data only*.  To replicate the procedure, do the following:

+ Download the Tower of Babel data
  1. Save all the .py files to the same directory.
  2. Run `download_all_starling.py`.
+ Clean and transform the Tower of Babel data in R.
  1. Run `load_starling.R`.  
     This will load the raw data and strip out a few unwanted characters.
  2. Run `load_segs_starling.R`.  
     This will identify and normalize the unique segments that occur in each language.
  3. Run `remove_homs_starling.R`.  
     This will remove homophones within each language.
  4. Run `load_min_pairs_starling.R`.  
     This will identify all the minimal pairs within each language.
+ Analyze and plot the data in R.
  1. Run `plot_all_distributions.R`.  
     This plots the distribution of vocab size, minimal pair count, etc.
  2. Run `analyze_and_plot.R`.  
     This builds a model and plots it (similar to the graph above).

source("min_pair_functions.R")

# create a data frame to hold minimal pairs and populate it
starling.min.pairs =  data.frame(Language = c(), Seg1 = c(), Phon1 = c(), Seg2 = c(), Phon2 = c(), stringsAsFactors = F)
# for each language,
for(i in 1:nrow(starling.segs)) {
  # get the language data
  lang.id = starling.segs$Language[i]
  lang = starling.segs$Language[i]
  subtable = starling.nohoms[starling.nohoms$Language == lang.id & starling.nohoms$PhonStrip != "",]
  current.segs = as.character(unlist(strsplit(starling.segs$Segs[i], " ")))
  # tokenize all the words into characters (so that this isn't done repeatedly
  # inside the following loop)
  tokenized.words = list()
  for(j in 1:nrow(subtable)) {
    tokenized.words[[j]] = tokenize.word(subtable$PhonStrip[j], segs = current.segs)
    subtable$Length[j] = length(tokenized.words[[j]])
  }
  # for each word length of the language,
  for(j in as.numeric(names(table(subtable$Length)[as.numeric(table(subtable$Length)) > 1]))) {
    subsubtable = subtable[subtable$Length == j,]
    sub.tokenized.words = tokenized.words[unlist(lapply(tokenized.words, length)) == j]
    # for each word of that length in the language,
    for(k in 1:(nrow(subsubtable) - 1)) {
      phon1 = sub.tokenized.words[[k]]
      phonString1 = subsubtable$PhonStrip[k]
      # for each other word of that length in the language,
      for(l in (k + 1):nrow(subsubtable)) {
        phon2 = sub.tokenized.words[[l]]
        phonString2 = subsubtable$PhonStrip[l]
        # check whether the words are a minimal pair
        starling.min.segs = min.pair(phon1, phon2)
        # if so,
        if(starling.min.segs[1] != "" & starling.min.segs[2] != "") {
          # print the minimal pair and store it in the data frame
          print(paste(lang, phonString1, phonString2))
          starling.min.pairs = rbind(starling.min.pairs, data.frame(Language = lang.id, Seg1 = starling.min.segs[1], Phon1 = phonString1, Seg2 = starling.min.segs[2], Phon2 = phonString2, stringsAsFactors = F))
        }
      }
    }
  }
}
rm(i, lang.id, lang, subtable, current.segs, tokenized.words, j, subsubtable, sub.tokenized.words, k, phon1, phonString1, l, phon2, phonString2, starling.min.segs)
# add one more field to the data frame, which pastes together the two
# contrasting segments of each minimal pair - for any pair of segments, it
# always combines them in the same order, which makes this field useful for
# getting overall counts
starling.min.pairs$Contrast = ""
for(s in starling.all.segs) {
  starling.min.pairs$Contrast = ifelse(starling.min.pairs$Seg1 == s | starling.min.pairs$Seg2 == s, ifelse(starling.min.pairs$Contrast == "", s, paste(starling.min.pairs$Contrast, "_", s, sep = "")), starling.min.pairs$Contrast)
}
rm(s)
# write the data frame to a csv file (just in case)
write.csv(starling.min.pairs, "starling_min_pairs.csv")

# create a data frame for storing total minimal pair counts by language; include
# separate counts for all minimal pairs and for minimal pairs that are at least
# 3 characters long (to avoid counting affixes that are listed by themselves)
starling.min.pair.counts = data.frame(Language = names(table(starling$Language)))
starling.min.pair.counts$StdLangName = ""
starling.min.pair.counts$Vocab = 0
starling.min.pair.counts$MinPairs = 0
starling.min.pair.counts$LongMinPairs = 0

# for each language,
for(i in 1:nrow(starling.min.pair.counts)) {
  # get the total recorded vocabulary size for the language
  starling.min.pair.counts$Vocab[i] = nrow(starling[starling$Language == starling.min.pair.counts$Language[i],])
  # get the size of the segment inventory
  starling.min.pair.counts$NumSegs[i] = length(unlist(strsplit(starling.segs$Segs[i], " ")))
  # get the mean and median word length
  starling.min.pair.counts$MeanWordLength[i] = mean(starling.nohoms$Length[starling.nohoms$Language == starling.min.pair.counts$Language[i]])
  starling.min.pair.counts$MedianWordLength[i] = median(starling.nohoms$Length[starling.nohoms$Language == starling.min.pair.counts$Language[i]])
  # get the number of minimal pairs observed for the language
  starling.min.pair.counts$MinPairs[i] = nrow(starling.min.pairs[starling.min.pairs$Language == starling.min.pair.counts$Language[i],])
  starling.min.pair.counts$LongMinPairs[i] = nrow(starling.min.pairs[starling.min.pairs$Language == starling.min.pair.counts$Language[i] & nchar(starling.min.pairs$Phon1) > 2 & nchar(starling.min.pairs$Phon2) > 2,])
}
rm(i)

# write the results to a csv file (just in case)
write.csv(starling.min.pair.counts, "starling_min_pair_counts.csv")

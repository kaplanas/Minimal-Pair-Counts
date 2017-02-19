library(stringr)
source("min_pair_functions.R")

# combining diacritics to be united with preceding characters
starling.combos = c("̀", "̆", "́", "̄", "̣", "̂", "̯", "̇", "̨", "̈", "̥", "̃", "̌", "̮", "̋", "̊", "̑", "͔", "͕", "̰", "̏", "̩", "ː", "ʷ", "ʰ", "ˤ")
# bubble sort adjacent diacritics (so that all unique sets of diacritics are
# counted as the same)
sorted = F
while(!sorted) {
  print("*** DOING A ROUND OF SORT ***")
  sorted = T
  for(i in 1:(length(starling.combos) - 1)) {
    print(starling.combos[i])
    for(j in (i + 1):length(starling.combos)) {
      if(sum(grepl(paste0(starling.combos[j], starling.combos[i]), starling.nohoms$PhonStrip)) > 0) {
        sorted = F
        starling.nohoms$PhonStrip = gsub(paste0(starling.combos[j], starling.combos[i]), paste0(starling.combos[i], starling.combos[j]), starling.nohoms$PhonStrip)
      }
    }
  }
}
rm(sorted, i, j)

# make a data frame to hold the segment inventory of each language
starling.segs = data.frame(Language = names(table(starling$Language)), stringsAsFactors = F)
starling.segs$Segs = NA
starling.nohoms$Length = NA

# for each language,
for(i in 1:nrow(starling.segs)) {
  print(starling.segs$Language[i])
  subtable = starling.nohoms[as.character(starling.nohoms$Language) == as.character(starling.segs$Language[i]),]
  # get all the words for that language
  starling.words = subtable$PhonStrip
  single.segs = c()
  double.segs = c()
  triple.segs = c()
  quadruple.segs = c()
  all.segs = c()
  # for each combining diacritic,
  for(j in 1:length(starling.combos)) {
    # for each other diacritic,
    for(k in j:length(starling.combos)) {
      # for each other diacritic,
      for(l in k:length(starling.combos)) {
        # check whether the three diacritics occur in sequence; if so, add the
        # three diacritics plus preceding character to the list of quadruples
        sequences = unique(unlist(str_extract_all(starling.words, paste0(".", starling.combos[j], starling.combos[k], starling.combos[l], ""))))
        quadruple.segs = c(quadruple.segs, sequences)
        # remove these sequences from the word list
        starling.words = gsub(paste0("(.", starling.combos[j], starling.combos[k], starling.combos[l], ")"), "", starling.words, perl = T)
      }
      # now check whether the two diacritics occur in sequence; if so, add the
      # two diacritics plus preceding character to the list of triples
      sequences = unique(unlist(str_extract_all(starling.words, paste0(".", starling.combos[j], starling.combos[k], ""))))
      triple.segs = c(triple.segs, sequences)
      # remove these sequences from the word list
      starling.words = gsub(paste0("(.", starling.combos[j], starling.combos[k], ")"), "", starling.words, perl = T)
    }
    # now check for combinations of the diacritic with a single ordinary segment
    sequences = unique(unlist(str_extract_all(starling.words, paste0(".", starling.combos[j]))))
    double.segs = c(double.segs, sequences)
    # remove these sequences from the word list
    starling.words = gsub(paste0("(.", starling.combos[j], ")"), "", starling.words, perl = T)
  }
  # now all the remaining characters should be singletons
  single.segs = unique(unlist(strsplit(starling.words, "")))
  all.segs = c(single.segs, double.segs, triple.segs, quadruple.segs)
  starling.segs$Segs[i] = paste(all.segs, collapse = " ")
  # now that we know what the segments are, record the length of each word
  for(j in 1:nrow(starling.nohoms)) {
    if(starling.nohoms$Language[j] == starling.segs$Language[i]) {
      starling.nohoms$Length[j] = length(tokenize.word(starling.nohoms$PhonStrip[j], segs = all.segs))
    }
  }
}
rm(i, subtable, starling.words, single.segs, double.segs, triple.segs, quadruple.segs, j, k, l, sequences)

# write the new and revised tables to csv files (just in case)
write.csv(starling.segs, "starling_segs.csv")
write.csv(starling, "starling_nohoms.csv")

# make a list of all the segments that occur anywhere
starling.all.segs = unique(unlist(strsplit(starling.segs$Segs, " ")))

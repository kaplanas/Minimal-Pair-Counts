# get all the languages
starling.languages = unique(starling$Language)

# add a unique identifier to each word
rownames(starling) = 1:nrow(starling)
starling$ID = rownames(starling)

# iterate through languages and check for homophones
starling.words.to.delete = c()
# for each language,
for(l in starling.languages) {
  subtable = starling[starling$Language == l,]
  # for each word length that is attested for at least two words,
  for(i in as.numeric(names(table(nchar(subtable$PhonStrip)))[as.numeric(table(nchar(subtable$PhonStrip))) > 1])) {
    subsubtable = subtable[nchar(subtable$PhonStrip) == i,]
    print(paste0(l, ": ", i, " / ", max(nchar(subtable$PhonStrip))))
    # for each word of that length, check for homophones among words of the same
    # length (starting with the second word, because with the first word we
    # can't possibly have found any homophones yet
    for(j in 2:nrow(subsubtable)) {
      subsubsubtable = subsubtable[1:(j - 1),]
      phon.strip = subsubsubtable$PhonStrip
      # if the current word is the same as any previous word, mark it for
      # deletion
      if(is.element(subsubtable$PhonStrip[j], phon.strip)) {
        starling.words.to.delete = c(starling.words.to.delete, subsubtable$ID[j])
      }
    }
  }
}
rm(l, subtable, i, subsubtable, j, subsubsubtable, phon.strip)
starling.nohoms = starling[!is.element(starling$ID, starling.words.to.delete),]
# write the revised table to a csv file (just in case)
write.csv(starling, "starling_nohoms.csv")

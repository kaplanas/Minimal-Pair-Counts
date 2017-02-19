# this function takes a word and splits it into segments, given the segment
# inventory provided
tokenize.word <- function(word, segs = c()) {
  raw.chars = unlist(strsplit(word, ""))
  word.chars = c()
  while(length(raw.chars) > 0) {
    if(length(raw.chars) > 3 & is.element(paste0(raw.chars[1], raw.chars[2], raw.chars[3], raw.chars[4]), segs)) {
      word.chars = c(word.chars, paste0(raw.chars[1], raw.chars[2], raw.chars[3], raw.chars[4]))
      if(length(raw.chars) > 4) {
        raw.chars = raw.chars[5:length(raw.chars)]
      }
      else {
        raw.chars = c()
      }
    }
    else if(length(raw.chars) > 2 & is.element(paste0(raw.chars[1], raw.chars[2], raw.chars[3]), segs)) {
      word.chars = c(word.chars, paste0(raw.chars[1], raw.chars[2], raw.chars[3]))
      if(length(raw.chars) > 3) {
        raw.chars = raw.chars[4:length(raw.chars)]
      }
      else {
        raw.chars = c()
      }
    }
    else if(length(raw.chars) > 1 & is.element(paste0(raw.chars[1], raw.chars[2]), segs)) {
      word.chars = c(word.chars, paste0(raw.chars[1], raw.chars[2]))
      if(length(raw.chars) > 2) {
        raw.chars = raw.chars[3:length(raw.chars)]
      }
      else {
        raw.chars = c()
      }
    }
    else {
      word.chars = c(word.chars, raw.chars[1])
      if(length(raw.chars) > 1) {
        raw.chars = raw.chars[2:length(raw.chars)]
      }
      else {
        raw.chars = c()
      }
    }
  }
  return(word.chars)
}

# this function checks whether two words form a minimal pair; if so, it returns
# the pair of segments that distinguishes them
min.pair <- function(w1.chars, w2.chars) {
  not.min.pair = c("", "")
  subIndex = 0
  for(i in 1:length(w1.chars)) {
    if(w1.chars[i] != w2.chars[i]) {
      if(subIndex == 0) {
        subIndex = i
      }
      else {
        return(not.min.pair)
      }
    }
  }
  if(subIndex != 0) {
    return(c(w1.chars[subIndex], w2.chars[subIndex]))
  }
  else {
    return(not.min.pair)
  }
}

# this function is the same as the previous one, except that it checks whether
# the two arguments are the same length (the previous function is called in a
# context where this check has already been done, so that step is omitted for
# efficiency)
min.pair.check.length <- function(w1.chars, w2.chars) {
  not.min.pair = c("", "")
  if(length(w1.chars) > 0 & length(w1.chars) == length(w2.chars)) {
    return(min.pair(w1.chars, w2.chars))
  }
  else {
    return(not.min.pair)
  }
}

# plotting symbols, colors, etc.
all.parameters = data.frame(
  PrettyName = c("CHIRILA", "POLLEX", "Tower of Babel", "CELEX+", "KSL"),
  Symbol = c(1, 3, 46, 2, 19),
  Color = c("darkgray", "darkgray", "lightgray", "lightgray", "red"),
  LineType = c(1, 2, 1, NA, NA),
  row.names = c("chirila", "pollex", "starling", "celex", "ksl"),
  stringsAsFactors = F
)

# take logs and create variables tracking whether there are any minimal pairs at
# all
log.zero = log(.5)
starling.min.pair.counts$AnyMinPairs = starling.min.pair.counts$MinPairs > 0
starling.min.pair.counts$LogVocab = log(starling.min.pair.counts$Vocab)
starling.min.pair.counts$LogMinPairs = ifelse(starling.min.pair.counts$AnyMinPairs, log(starling.min.pair.counts$MinPairs), log.zero)

# density plots of the distribution of raw and logged vocabulary and minimal
# pair counts

starling.vocab.density = density(starling.min.pair.counts$Vocab, bw = 150)
starling.log.vocab.density = density(starling.min.pair.counts$LogVocab)
starling.min.pair.density = density(starling.min.pair.counts$MinPairs, bw = 150)
starling.log.min.pair.density = density(starling.min.pair.counts$LogMinPairs)
starling.word.length.density = density(starling.min.pair.counts$MeanWordLength)
starling.num.segs.density = density(starling.min.pair.counts$NumSegs)
vocab.density.xrange = range(starling.vocab.density$x)
vocab.density.yrange = c(0, 0.0009)
log.vocab.density.xrange = range(starling.log.vocab.density$x)
log.vocab.density.yrange = range(starling.log.vocab.density$y)
min.pair.density.xrange = range(starling.min.pair.density$x)
min.pair.density.yrange = c(0, 0.0005)
log.min.pair.density.xrange = range(starling.log.min.pair.density$x)
log.min.pair.density.yrange = range(starling.log.min.pair.density$y)
word.length.density.xrange = range(starling.word.length.density$x)
word.length.density.yrange = range(starling.word.length.density$y)
num.segs.density.xrange = range(starling.num.segs.density$x)
num.segs.density.yrange = range(starling.num.segs.density$y)

pdf("counts_distribution.pdf", height = 7, width = 8)
par(mfrow = c(3, 2), mar = c(3, 3, 1, 1))

# raw vocabulary size
plot(starling.vocab.density, xlim = vocab.density.xrange, ylim = vocab.density.yrange, main = "Vocabulary size", xlab = "", ylab = "", col = all.parameters["starling","Color"], lty = all.parameters["starling","LineType"])

# raw minimal pair counts
plot(starling.min.pair.density, xlim = min.pair.density.xrange, ylim = min.pair.density.yrange, main = "Minimal pairs", xlab = "", ylab = "", col = all.parameters["starling","Color"], lty = all.parameters["starling","LineType"])

# log vocabulary size
plot(starling.log.vocab.density, xlim = log.vocab.density.xrange, ylim = log.vocab.density.yrange, main = "Log vocabulary size", xlab = "", ylab = "", col = all.parameters["starling","Color"], lty = all.parameters["starling","LineType"])

# log minimal pair counts
plot(starling.log.min.pair.density, xlim = log.min.pair.density.xrange, ylim = log.min.pair.density.yrange, main = "Log minimal pairs", xlab = "", ylab = "", col = all.parameters["starling","Color"], lty = all.parameters["starling","LineType"])

# mean word length
plot(starling.word.length.density, xlim = word.length.density.xrange, ylim = word.length.density.yrange, main = "Mean word length", xlab = "", ylab = "", col = all.parameters["starling","Color"], lty = all.parameters["starling","LineType"])

# segment inventory size
plot(starling.num.segs.density, xlim = num.segs.density.xrange, ylim = num.segs.density.yrange, main = "Segment inventory size", xlab = "", ylab = "", col = all.parameters["starling","Color"], lty = all.parameters["starling","LineType"])

dev.off()

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
plot(starling.vocab.density, xlim = vocab.density.xrange, ylim = vocab.density.yrange, main = "Vocabulary size", xlab = "", ylab = "", col = starling.color, lty = starling.linetype)

# raw minimal pair counts
plot(starling.min.pair.density, xlim = min.pair.density.xrange, ylim = min.pair.density.yrange, main = "Minimal pairs", xlab = "", ylab = "", col = starling.color, lty = starling.linetype)

# log vocabulary size
plot(starling.log.vocab.density, xlim = log.vocab.density.xrange, ylim = log.vocab.density.yrange, main = "Log vocabulary size", xlab = "", ylab = "", col = starling.color, lty = starling.linetype)

# log minimal pair counts
plot(starling.log.min.pair.density, xlim = log.min.pair.density.xrange, ylim = log.min.pair.density.yrange, main = "Log minimal pairs", xlab = "", ylab = "", col = starling.color, lty = starling.linetype)

# mean word length
plot(starling.word.length.density, xlim = word.length.density.xrange, ylim = word.length.density.yrange, main = "Mean word length", xlab = "", ylab = "", col = starling.color, lty = starling.linetype)

# segment inventory size
plot(starling.num.segs.density, xlim = num.segs.density.xrange, ylim = num.segs.density.yrange, main = "Segment inventory size", xlab = "", ylab = "", col = starling.color, lty = starling.linetype)

dev.off()

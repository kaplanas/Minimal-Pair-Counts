library(lme4)
library(lmerTest)

# sign language data
ksl.minpairs = 405
ksl.log.minpairs = log(ksl.minpairs)
ksl.vocab = 1690
ksl.log.vocab = log(ksl.vocab)

# an initial regression to get residuals for mitigating collinearity involving
# segment inventory size
starling.seg.lm = lm(NumSegs ~ LogVocab + MeanWordLength, data = starling.min.pair.counts)

# center and standardize some predictors
mean.log.vocab = mean(starling.min.pair.counts$LogVocab)
sd.log.vocab = sd(starling.min.pair.counts$LogVocab)
starling.min.pair.counts$CS.LogVocab = (starling.min.pair.counts$LogVocab - mean.log.vocab) / sd.log.vocab
mean.log.min.pairs = mean(starling.min.pair.counts$LogMinPairs)
sd.log.min.pairs = sd(starling.min.pair.counts$LogMinPairs)
starling.min.pair.counts$CS.LogMinPairs = (starling.min.pair.counts$LogMinPairs - mean.log.min.pairs) / sd.log.min.pairs
mean.word.length = mean(starling.min.pair.counts$MeanWordLength)
sd.word.length = sd(starling.min.pair.counts$MeanWordLength)
starling.min.pair.counts$CS.MeanWordLength = (starling.min.pair.counts$MeanWordLength - mean.word.length) / sd.word.length
mean.num.segs = mean(starling.min.pair.counts$NumSegs)
sd.num.segs = sd(starling.min.pair.counts$NumSegs)
starling.min.pair.counts$CS.NumSegs = (starling.min.pair.counts$NumSegs - mean.num.segs) / sd.num.segs
starling.min.pair.counts$NumSegsResid = starling.seg.lm$resid
mean.num.segs.resid = mean(starling.min.pair.counts$NumSegsResid)
sd.num.segs.resid = sd(starling.min.pair.counts$NumSegsResid)
starling.min.pair.counts$CS.NumSegsResid = (starling.min.pair.counts$NumSegsResid - mean.num.segs.resid) / sd.num.segs.resid

# get data subsets that will be useful later
nonzero.min.pair.counts = starling.min.pair.counts[starling.min.pair.counts$MinPairs > 0,]

# show collinearity involving predictors
pdf("collinearity.pdf", height = 3, width = 8)
par(mfrow = c(1, 3), mar = c(4.5, 4, 1, 1))
plot(starling.min.pair.counts$NumSegs ~ starling.min.pair.counts$LogVocab, xlim = range(starling.min.pair.counts$LogVocab), xlab = "Log vocabulary size", ylim = range(starling.min.pair.counts$NumSegs), ylab = "Segment inventory size", main = "Seg inv and log vocab", col = all.parameters["starling","Color"], pch = all.parameters["starling","Symbol"])
plot(starling.min.pair.counts$NumSegs ~ starling.min.pair.counts$MeanWordLength, xlim = range(starling.min.pair.counts$MeanWordLength), xlab = "Mean word length", ylim = range(starling.min.pair.counts$NumSegs), ylab = "Segment inventory size", main = "Seg inv and word length", col = all.parameters["starling","Color"], pch = all.parameters["starling","Symbol"])
plot(starling.min.pair.counts$LogVocab ~ starling.min.pair.counts$MeanWordLength, xlim = range(starling.min.pair.counts$MeanWordLength), xlab = "Mean word length", ylim = range(starling.min.pair.counts$LogVocab), ylab = "Log vocabulary size", main = "Log vocab and word length", col = all.parameters["starling","Color"], pch = all.parameters["starling","Symbol"])
dev.off()

# MODEL FOR LANGUAGES WITH AT LEAST SOME MINIMAL PAIRS #

# build the model
nonzero.model = lm(CS.LogMinPairs ~ CS.LogVocab + CS.MeanWordLength + CS.NumSegsResid, data = nonzero.min.pair.counts)

# set up output device
pdf("nonzero_model.pdf", height = 3, width = 8)
par(mfrow = c(1, 3), mar = c(4.5, 4, 1, 1))

# add data points for minimal pairs by vocab
plot(nonzero.min.pair.counts$LogMinPairs ~ nonzero.min.pair.counts$LogVocab, xlim = range(nonzero.min.pair.counts$LogVocab), xlab = "Log vocabulary size", ylim = range(nonzero.min.pair.counts$LogMinPairs), ylab = "Log minimal pairs", main = "Log vocabulary size", col = all.parameters["starling","Color"], pch = all.parameters["starling","Symbol"])

# add curves for minimal pairs by vocab
curve(((cbind(1, (x - mean.log.vocab) / sd.log.vocab, mean(starling.min.pair.counts$CS.MeanWordLength), mean(starling.min.pair.counts$CS.NumSegs)) %*% unlist(coef(nonzero.model))) * sd.log.min.pairs) + mean.log.min.pairs, add = T, col = all.parameters["starling","Color"], lty = all.parameters["starling","LineType"])
points(ksl.log.minpairs ~ ksl.log.vocab, col = all.parameters["ksl","Color"], pch = all.parameters["ksl","Symbol"])

# add data points for minimal pairs by word length
plot(nonzero.min.pair.counts$LogMinPairs ~ nonzero.min.pair.counts$MeanWordLength, xlim = range(nonzero.min.pair.counts$MeanWordLength), xlab = "Mean word length", ylim = range(nonzero.min.pair.counts$LogMinPairs), ylab = "Log minimal pairs", main = "Mean word length", col = all.parameters["starling","Color"], pch = all.parameters["starling","Symbol"])

# add curves for minimal pairs by word length
curve(((cbind(1, mean(nonzero.min.pair.counts$CS.LogVocab), (x - mean.word.length) / sd.word.length, mean(nonzero.min.pair.counts$CS.NumSegs)) %*% unlist(coef(nonzero.model))) * sd.log.min.pairs) + mean.log.min.pairs, add = T, col = all.parameters["starling","Color"], lty = all.parameters["starling","LineType"])

# add data points for minimal pairs by segment inventory size
plot(nonzero.min.pair.counts$LogMinPairs ~ nonzero.min.pair.counts$NumSegsResid, xlim = range(nonzero.min.pair.counts$NumSegsResid), xlab = "Residualized segment inventory size", ylim = range(nonzero.min.pair.counts$LogMinPairs), ylab = "Log minimal pairs", main = "Segment inventory size", col = all.parameters["starling","Color"], pch = all.parameters["starling","Symbol"])

# add curves for minimal pairs by segment inventory size
curve(((cbind(1, mean(nonzero.min.pair.counts$CS.LogVocab), mean(nonzero.min.pair.counts$CS.MeanWordLength), (x - mean.num.segs.resid) / sd.num.segs.resid) %*% unlist(coef(nonzero.model))) * sd.log.min.pairs) + mean.log.min.pairs, add = T, col = all.parameters["starling","Color"], lty = all.parameters["starling","LineType"])

dev.off()

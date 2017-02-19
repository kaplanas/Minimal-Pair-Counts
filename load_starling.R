# load the data and rename some fields
nostratic = read.table("nostratic.txt", sep = '\t', quote = "", header = F, stringsAsFactors = F, col.names = c("Language", "Phon"))
nostratic$Language = ifelse(substr(nostratic$Language, nchar(nostratic$Language) - 9, nchar(nostratic$Language)) == " derivates", substr(nostratic$Language, 1, nchar(nostratic$Language) - 10), nostratic$Language)
afro.asiatic = read.table("afro_asiatic.txt", sep = '\t', quote = "", header = F, stringsAsFactors = F, col.names = c("Language", "Phon"))
sino.caucasian = read.table("sino_caucasian.txt", sep = '\t', quote = "", header = F, stringsAsFactors = F, col.names = c("Language", "Phon"))
sino.caucasian$Language = ifelse(substr(sino.caucasian$Language, nchar(sino.caucasian$Language) - 4, nchar(sino.caucasian$Language)) == " form", substr(sino.caucasian$Language, 1, nchar(sino.caucasian$Language) - 5), sino.caucasian$Language)
austric = read.table("austric.txt", sep = '\t', quote = "", header = F, stringsAsFactors = F, col.names = c("Language", "Phon"))
austric$Language = ifelse(substr(austric$Language, nchar(austric$Language) - 4, nchar(austric$Language)) == " form", substr(austric$Language, 1, nchar(austric$Language) - 5), austric$Language)
austric = austric[austric$Phon != "Old",]
macro.khoisan = read.table("macro_khoisan.txt", sep = '\t', quote = "", header = F, stringsAsFactors = F, col.names = c("Language", "Phon"))
starling = rbind(nostratic, afro.asiatic, sino.caucasian, austric, macro.khoisan, stringsAsFactors = F)

# get rid of reconstructed languages that have slipped through
starling$Language = trimws(starling$Language)
starling = starling[starling$Language != "Meaning",]
starling = starling[substr(starling$Language, 1, 5) != "Proto",]
starling = starling[!grepl("[*]", starling$Phon),]
starling = starling[starling$Phon != "~",]
starling = starling[starling$Phon != "?",]
starling$Phon = gsub("<.*", "", starling$Phon)

# strip unwanted characters from IPA representations
starling.strip.chars = "[-;,()<>+=]"
starling$PhonStrip = gsub(starling.strip.chars, "", starling$Phon)
starling$PhonStrip = gsub("/.*", "", starling$PhonStrip)
starling$PhonStrip = gsub("\\[.*\\]", "", starling$PhonStrip)
starling$PhonStrip = gsub("\\[", "", starling$PhonStrip)
starling$PhonStrip = gsub("\\]", "", starling$PhonStrip)
starling$PhonStrip = gsub("\\{", "", starling$PhonStrip)
starling$PhonStrip = gsub("\\}", "", starling$PhonStrip)
starling$PhonStrip = gsub(":", "ː", starling$PhonStrip)

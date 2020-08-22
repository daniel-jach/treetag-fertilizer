treetag.fertilizer<-function(pathToTreeTagger, pathToCorpus, language, sentence_delim = c("!", "?", ".", ":", ";")){
  
  # path to language-specific treetagger executable
  treetagger<-paste(pathToTreeTagger, "cmd/", "tree-tagger-", language, sep = "") 
  
  # generate system command
  systemCmd<-paste(treetagger, pathToCorpus) 
  
  # launch treetagger 
  corpus<-as.data.frame(do.call(rbind, strsplit(system(systemCmd, intern = TRUE), "\t")), stringsAsFactors = FALSE) 
  
  # set column names
  colnames(corpus)<-c("TOKEN", "POS", "LEMMA") 
  
  # if corpus files does not end on sentence delimiter...
  if(!(corpus$TOKEN[nrow(corpus)] %in% sentence_delim)){ 
    corpus<-rbind(corpus, c(".", "$.", ".")) # ...add full stop at end of corpus file
  }
  # find position of sentence boundaries
  x<-which(corpus$TOKEN %in% sentence_delim) 
  
  # calculate length of each sentence
  y<-x[-length(x)] 
  y<-append(0,y)
  
  # length of each sentence
  z<-x-y
  
  # produce vector of sequences of numbers for each sentence length
  vc<-rep(1:length(z), z) 
  
  # assign vector to tagged corpus
  corpus$SENTENCE<-vc 
  
  return(corpus)
}
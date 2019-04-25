# Setup script for extracting results outputted from FSL
# -------------------------------
# Contains two functions detailed below
#
# readStatistics()
#   I/P: two strings (one of a text file, another of how to label the data from it)
#   O/P: a dataframe of what was in the textfile
#       -- will also add a variable "title" that is the label you fed it
# -------------------------------
# AX -- written 04/01/2019

# readStatistics() reads in each textfile and creates a dataframe
#   I/P: string that is the name of a text file (e.g., "thermal.txt")
#   O/P: string that is the name of how the data will be labeled (e.g., "thermal")
readStatistics <- function(textfile, effectLabel){
  # read the textfile
  a <- read.delim(textfile)
  # if there is nothing in the textfile, return NA
  if (dim(a)[1]==0){
    return(NA)
  } else {
    # otherwise, return a dataframe with the data and label
    a$title <- effectLabel
    return(a)
  }
}

# statsTable() calls readStatistics() to create a dataframe with all the text files in a directory
#   I/P: none (just call the function)
#   O/P: a dataframe that binds all the text files
# NB.1: Only works for the cluster text outputs from FSL (as shown by how it names curDf)
# NB.2: Make sure to be in the proper directory before running the function (by using setwd())
statsTable <- function(){
  # 1. list all the files in the current directory that are .txt files
  curFiles <- list.files(path=".", pattern="*_*.txt")
  # 2. Initialize a dataframe with the same variables from FSL output
  curDf <- data.frame(matrix(ncol = 10, nrow = 1))
  names(curDf) <- c("Cluster.Index", "Voxels","MAX","MAX.X..mm.","MAX.Y..mm.","MAX.Z..mm.","COG.X..mm.","COG.Y..mm.","COG.Z..mm.","title")
  # 3. Create the dataframe
  for (i in 1:length(curFiles)){
    # A) Get the contrast name from the text file
    fileNameSplit <- strsplit(curFiles[i], split=".", fixed="T") # splits the name of the file
    contrastName <- fileNameSplit[[1]][1] # and gets the effect of interest name
    # B) Bind what was read in that text file (via readStatistics()) to a larger dataframe
    curDf <- rbind(curDf, readStatistics(curFiles[i], contrastName))  
  }
  # C) Output that dataframe
  return(curDf)
}







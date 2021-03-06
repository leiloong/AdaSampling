context("adaB-scriptcompare")

skip("Run this test locally, working directory not set up according to system.file() in CMD CHECK")

#Pengyi's breast cancer data from toRun.R in clean code
# read in dataset, should output data.mat, data.cls, and data.cls.truth
{breast.raw <- read.delim(system.file("tests", "breast-w.txt", package = "AdaSampling"),
                         sep = ",", head=FALSE)
breast <- rbind(breast.raw[which(breast.raw[,10]!="benign"), ], breast.raw[which(breast.raw[,10]=="benign"), ])
breast.filtered <- breast[which(rowSums(breast == "?") == 0), ] #this is called brca in the package

breast.dat <- apply(breast.filtered[,-10], 2, as.numeric) #training data features
rownames(breast.dat) <- paste("i", c(1:nrow(breast.dat)), sep="")
breast.cls <- rep(0, nrow(breast.dat)) #initiating all classes as 0
breast.cls[breast.filtered[,10] != 'benign'] <- 1 #then assigning all benign ones to 1
data.cls.truth <- as.factor(breast.cls)
data.mat <- breast.dat

# introduce class label noise
set.seed(1)
pos <- which(data.cls.truth == 1)
neg <- which(data.cls.truth == 0)
data.cls <- data.cls.truth
data.cls[sample(pos, floor(length(pos) * 0.4))] <- 0
data.cls[sample(neg, floor(length(neg) * 0.2))] <- 1 }

testthat::test_that("brca inbuilt dataset behaves same as script dataset", {

  expect_equal(
    adaBenchmark(data.mat, data.cls, data.cls.truth),
    adaBenchmark(features.brca, labels.brca.noisy, labels.brca)
  )

})



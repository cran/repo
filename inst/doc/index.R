## ----include=FALSE-------------------------------------------------------
library(knitr)
knitr::opts_chunk$set(fig.width=7, fig.height=7, comment="")

## ------------------------------------------------------------------------
library(repo)

## ------------------------------------------------------------------------
src <- "repodemo.R"

## ------------------------------------------------------------------------
repo <- repo_open(tempdir(), force=T)

## ------------------------------------------------------------------------
myiris <- scale(as.matrix(iris[,1:4]))

## ------------------------------------------------------------------------
repo$put(
    obj = myiris,    
    name = "myiris",    
    description = paste(
        "A normalized version of the iris dataset coming with R.",
        "Normalization is made with the scale function",
        "with default parameters."
    ),
    tags = c("dataset", "iris", "repodemo"),    
    src = src,    
    replace=T
)

## ------------------------------------------------------------------------
repo$put(iris$Species, "irisLabels", "The Iris class lables.",
         c("labels", "iris", "repodemo"), src, replace=T)

## ------------------------------------------------------------------------
irispca <- princomp(myiris)        
iris2d <- irispca$scores[,c(1,2)]
plot(iris2d, main="2D visualization of the Iris dataset",
     col=repo$get("irisLabels"))

## ------------------------------------------------------------------------
fpath <- file.path(repo$root(), "iris2D.pdf")
pdf(fpath)
plot(iris2d, main="2D visualization of the Iris dataset",
     col=repo$get("irisLabels"))
invisible(dev.off())
repo$attach(fpath, "Iris 2D visualization obtained with PCA.",
            c("visualization", "iris", "repodemo"), src, replace=T, to="myiris")

## ------------------------------------------------------------------------
invisible(file.remove(fpath))

## ---- eval=FALSE---------------------------------------------------------
#  repo$sys("iris2D.pdf", "evince")

## ------------------------------------------------------------------------
plot(irispca)

## ------------------------------------------------------------------------
fpath <- file.path(repo$root(), "irispca.pdf")
pdf(fpath)
plot(irispca)
invisible(dev.off())
repo$attach(fpath, "Variance explained by the PCs of the Iris dataset",
            c("visualization", "iris", "repodemo"), src, replace=T, to="iris2D.pdf")
invisible(file.remove(fpath))

## ------------------------------------------------------------------------
kiris <- kmeans(myiris, 5)$cluster
repo$put(kiris, "iris_5clu", "Kmeans clustering of the Iris data, k=5.",
         c("metadata", "iris", "kmeans", "clustering", "repodemo"), src,
         depends="myiris", T)

## ------------------------------------------------------------------------
plot(iris2d, main="Iris dataset kmeans clustering", col=kiris)

## ------------------------------------------------------------------------
fpath <- file.path(repo$root(), "iris2Dkm.pdf")
pdf(fpath)
plot(iris2d, main="Iris dataset kmeans clustering", col=kiris)
invisible(dev.off())
repo$attach(fpath, "Iris K-means clustering.",
            c("visualization", "iris", "clustering", "kmeans", "repodemo"), src,
            replace=T, to="iris_5clu")
invisible(file.remove(fpath))

## ------------------------------------------------------------------------
res <- table(repo$get("irisLabels"), kiris)
repo$put(res, "iris_cluVsSpecies",
         paste("Contingency table of the kmeans clustering versus the",
               "original labels of the Iris dataset."),
         c("result", "iris","validation", "clustering", "repodemo", "hide"),
         src, c("myiris", "irisLabels", "iris_5clu"), T)

## ------------------------------------------------------------------------
repo$info()

## ------------------------------------------------------------------------
repo ## by default resolves to print(repo)

## ------------------------------------------------------------------------
print(repo, all=T)

## ------------------------------------------------------------------------
print(repo, tags="clustering", all=T)

## ------------------------------------------------------------------------
print(repo, tags="attachment", all=T)

## ------------------------------------------------------------------------
print(repo, tags="hide", all=T)

## ------------------------------------------------------------------------
repo$print(show="t", all=T)

## ------------------------------------------------------------------------
depgraph <- repo$dependencies(plot=F)
rownames(depgraph) <- colnames(depgraph) <- basename(rownames(depgraph))
library(knitr)
kable(depgraph)

## ------------------------------------------------------------------------
repo$dependencies()

## ------------------------------------------------------------------------
repo$dependencies(generated=F)

## ------------------------------------------------------------------------
x <- repo$get("myiris")

## ------------------------------------------------------------------------
repo$info("myiris")

## ------------------------------------------------------------------------
kiris2 <- kmeans(myiris, 5)$cluster
repo$put(kiris, "iris_5clu",
         "Kmeans clustering of the Iris data, k=5. Today's version!",
         c("metadata", "iris", "kmeans", "clustering", "repodemo"), src,
         depends="myiris", addversion=T)

## ------------------------------------------------------------------------
repo

## ------------------------------------------------------------------------
repo$info("iris_5clu")

## ------------------------------------------------------------------------
repo$print(all=T)

## ------------------------------------------------------------------------
repo$info("iris_5clu#1")

## ----include=FALSE-------------------------------------------------------
dorun <- FALSE
result <- "This took 10 seconds to compute"
repo$stash("result")

## ------------------------------------------------------------------------
if(dorun) {
    Sys.sleep(10)
    result <- "This took 10 seconds to compute"
    repo$stash("result")
} else result <- repo$get("result")

## ------------------------------------------------------------------------
repo$info("result")

## ------------------------------------------------------------------------
h <- repo$handlers()
names(h)

## ------------------------------------------------------------------------
print(h$iris_cluVsSpecies())

## ------------------------------------------------------------------------
h$iris_cluVsSpecies("tag", "onenewtag")
h$iris_cluVsSpecies("info")

## ------------------------------------------------------------------------
h <- repo_open(repo$root())$handlers()

## ------------------------------------------------------------------------
h$repo

## ------------------------------------------------------------------------
h <- h$repo$handlers()

## ------------------------------------------------------------------------
unlink(repo$root(), recursive=TRUE)

## ---- eval=FALSE---------------------------------------------------------
#  help(repo)

## ---- eval=FALSE---------------------------------------------------------
#  help(repo_func)


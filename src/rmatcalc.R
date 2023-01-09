#!/usr/bin/env Rscript

## =======================================
## CREDIT
## functions: getIndex, append_VecOrList, extend_VecOrList, remove_vecOrList,
##     insert_VecOrList, pop_VecOrList, getCount
## used in "rmatcalc.R" are
## from: GitHub - usagi-san-dayo/UsagiSan/R/UsagiSan.R
## url1: https://github.com/usagi-san-dayo/UsagiSan
## url2: https://multivariate-statistics.com/2021/01/29/r-programming-vector-list/
## 
## MIT License
## 
## Copyright (c) 2020 UsagiSan
## 
## Permission is hereby granted, free of charge, to any person obtaining a copy
## of this software and associated documentation files (the "Software"), to deal
## in the Software without restriction, including without limitation the rights
## to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
## copies of the Software, and to permit persons to whom the Software is
## furnished to do so, subject to the following conditions:
## 
## The above copyright notice and this permission notice shall be included in all
## copies or substantial portions of the Software.
## 
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
## IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
## FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
## AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
## LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
## OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
## SOFTWARE.
## =======================================

# args
#args <- commandArgs(trailingOnly=TRUE)

# load file
#install.packages("optparse", dependencies = T)
#install.packages("Rtools", dependencies = T)
#install.packages("sketcher", dependencies = T)
suppressWarnings(library('optparse'))

# check opt
argv = commandArgs(TRUE)
if ( is.na(argv[1])){
    cat("rmat.R -- calc matrix", "\n", sep="")
    cat("", "\n", sep="")
    cat("Synopsis:", "\n", sep="")
    cat("", "\n", sep="")
    cat("Usage: Rscript rmatcalc.R -f <formula> [-d <delim>] [opts...]", "\n", sep="")
    cat("  --formula,    -f :formula", "\n", sep="")
    cat("  --delim,      -d :delimiter", "\n", sep="")
    cat("  --input,      -i :input data from file", "\n", sep="")
    cat("  --dtype          :array data type. defalut=numeric", "\n", sep="")
    cat("  --nowrap         :no wrap", "\n", sep="")
    cat("  --debug          :print debug", "\n", sep="")
    cat("", "\n", sep="")
    cat("Thanks:", "\n", sep="")
    cat("  Ryuichi Ueda and CIT Autonomous Robot Lab", "\n", sep="")
    cat("  https://b.ueda.tech/?post=00674", "\n", sep="")
    cat("", "\n", sep="")
    cat("Inspired by:", "\n", sep="")
    cat("  GitHub - ryuichiueda/PMAT: Pipe Oriented Matrix Calculator", "\n", sep="")
    cat("  https://github.com/ryuichiueda/PMAT", "\n", sep="")
    cat("", "\n", sep="")
    cat("About", "\n", sep="")
    cat("  A+B-A%*%B : sum, difference, product", "\n", sep="")
    cat("  A * B     : Multiply element by element", "\n", sep="")
    cat("  A %o% B   : cross product", "\n", sep="")
    cat("  A %x% B   : kronecker product", "\n", sep="")
    cat("", "\n", sep="")
    cat("Funcs", "\n", sep="")
    cat("  t(A)", "\n", sep="")
    cat("  solve(A)", "\n", sep="")
    cat("  eigen(A)", "\n", sep="")
    cat("  det(A)", "\n", sep="")
    cat("  diag(n)", "\n", sep="")
    cat("  diag(a1:an)", "\n", sep="")
    cat("  sum(x^n)", "\n", sep="")
    cat("  crossprod(A)", "\n", sep="")
    cat("  crossprod(x,y)", "\n", sep="")
    cat("  rowSums(A)", "\n", sep="")
    cat("  solSums(A)", "\n", sep="")
    cat("  rowMeans(A)", "\n", sep="")
    cat("  colMeans(A)", "\n", sep="")
    cat("  x[upper.tri(A)] <- n", "\n", sep="")
    cat("  x[lower.tri(A)] <- n", "\n", sep="")
    cat("", "\n", sep="")
    cat("", "\n", sep="")
    cat("Examples:", "\n", sep="")
    cat("input example:", "\n", sep="")
    cat("$ cat matrix", "\n", sep="")
    cat("A 1 2", "\n", sep="")
    cat("A 3 4", "\n", sep="")
    cat("B 4 3", "\n", sep="")
    cat("B 2 1", "\n", sep="")
    cat("", "\n", sep="")
    cat("calc example:", "\n", sep="")
    cat("$ cat matrix | Rscript rmatcalc.R -f 'A%*%B'", "\n", sep="")
    cat("A 1 2", "\n", sep="")
    cat("A 3 4", "\n", sep="")
    cat("B 4 3", "\n", sep="")
    cat("B 2 1", "\n", sep="")
    cat("C 8 5", "\n", sep="")
    cat("C 20 13", "\n", sep="")
    cat("", "\n", sep="")
    cat("$ cat matrix | Rscript rmatcalc.R -f 'A*B'", "\n", sep="")
    cat("A 1 2", "\n", sep="")
    cat("A 3 4", "\n", sep="")
    cat("B 4 3", "\n", sep="")
    cat("B 2 1", "\n", sep="")
    cat("C 4 6", "\n", sep="")
    cat("C 6 4", "\n", sep="")
    cat("", "\n", sep="")
    cat("$ cat matrix | Rscript rmatcalc.R -f 't(A)'", "\n", sep="")
    cat("A 1 2", "\n", sep="")
    cat("A 3 4", "\n", sep="")
    cat("B 1 3", "\n", sep="")
    cat("B 2 4", "\n", sep="")
    cat("", "\n", sep="")
    cat("solve:", "\n", sep="")
    cat("$ cat matrix | Rscript rmatcalc.R -f 'A%*%solve(A)'", "\n", sep="")
    cat("A 1 1", "\n", sep="")
    cat("A 2 4", "\n", sep="")
    cat("B 1 0", "\n", sep="")
    cat("B 0 1", "\n", sep="")
    cat("", "\n", sep="")
    cat("add new label to ans:", "\n", sep="")
    cat("$ cat matrix | Rscript rmatcalc.R -f 'C=A*B'", "\n", sep="")
    cat("A 1 2", "\n", sep="")
    cat("A 3 4", "\n", sep="")
    cat("B 4 3", "\n", sep="")
    cat("B 2 1", "\n", sep="")
    cat("C 4 6", "\n", sep="")
    cat("C 6 4", "\n", sep="")
    cat("", "\n", sep="")
    cat("determinant:", "\n", sep="")
    cat(" To output a single non-matrix return value,", "\n", sep="")
    cat(" multiply by diag(1)", "\n", sep="")
    cat("$ cat matrix | Rscript rmatcalc.R -f 'C=det(A)*diag(1)'", "\n", sep="")
    cat("A 2 -6 4", "\n", sep="")
    cat("A 7 2 3", "\n", sep="")
    cat("A 8 5 -1", "\n", sep="")
    cat("C -144", "\n", sep="")
    cat("", "\n", sep="")
    cat("rank:", "\n", sep="")
    cat("$ cat matrix | Rscript rmatcalc.R -f 'C=qr(A)$rank*diag(1)'", "\n", sep="")
    cat("A 2 -6 4", "\n", sep="")
    cat("A 7 2 3", "\n", sep="")
    cat("A 8 5 -1", "\n", sep="")
    cat("C 3", "\n", sep="")
    cat("", "\n", sep="")
    cat("chain calc using pipe:", "\n", sep="")
    cat("$ cat matrix | Rscript rmatcalc.R -f 'C=A*B' | Rscript rmatcalc.R -f 'E=C%*%A'", "\n", sep="")
    cat("A 1 2", "\n", sep="")
    cat("A 3 4", "\n", sep="")
    cat("B 4 3", "\n", sep="")
    cat("B 2 1", "\n", sep="")
    cat("C 4 6", "\n", sep="")
    cat("C 6 4", "\n", sep="")
    cat("E 22 32", "\n", sep="")
    cat("E 18 28", "\n", sep="")
    cat("", "\n", sep="")
    quit(status=1)
}

optslist <- list(
    #make_option("--flag1", action="store_true", default=FALSE, help="A Flag"),
    make_option(c("-f", "--formula")  ,type="character",    default=NA,        help="formula"),
    make_option(c("-d", "--delim")    ,type="character",    default=' ',       help="delimiter"),
    make_option(c("-i", "--input")    ,type="character",    default=NA,        help="An input image"),
    make_option("--dtype"             ,type="character",    default="numeric", help="column classes"),
    make_option("--nowrap"            ,action="store_true", default=FALSE,     help="no wrap output"),
    make_option("--debug"             ,action="store_true", default=FALSE,     help="debug print")
    )
parser <- OptionParser(option_list=optslist)
opts <- parse_args(parser)
# test opts
## check input is provided
if (is.na(opts$formula)) {
    warning("formula(-f, --formula) parameter must be provided. See script usage (--help)")
    quit(status=1)
}

# debug print
if (opts$debug){
    if(!is.na(opts$formula)){cat("formula   :", opts$formula, "\n")}
    if(!is.na(opts$input))  {cat("input     :", opts$input, "\n")}
    if(!is.na(opts$delim))  {cat("delim     :", opts$delim, "\n")}
    if(!is.na(opts$output)) {cat("dtype     :", opts$dtype, "\n")}
    cat("debug     :", opts$debug,      "\t[bool, default: FALSE]\n")
}


# funcs
getIndex <- function(x, item) {
    if (!is.vector(x)) {
        stop("The Argument x must be a vector or list type object")
    }
    if (is.list(x)) {
        isItem <- unlist(lapply(x, function(y) {
            return(all(y == item))
        }))
        return(seq_len(length(isItem))[isItem])
    }
    else {
        names(x) <- seq_len(length(x))
        return(as.numeric(names(x[x == item])))
    }
}
append_VecOrList <- function (x, item) {
    if (! is.vector(x)){
        stop("The argument x must be a vector or list type object.")
    }
    if (is.list(x) & ! is.list(item)){
        item <- list(item)
    }
    return(c(x, item))
}
extend_VecOrList <- function (x, item) {
    if (! is.vector(x)) {
        stop("The argument x must be a vector or list type object.")
    }
    return(c(x, item))
}
remove_vecOrList <- function(x, item) {
    indices <- getIndex(x, item)
    return(x[- indices])
}
insert_VecOrList <- function (x, i, item) {
    ## insert item at the i-th posision of x
    if (! is.vector(x)) {
        stop("The argument x must be a vector or list type object.")
    }
    if (is.list(x) & ! is.list(item)) {
        item <- list(item)
    }
    return(c(x[seq_len(i - 1)], item, x[i : length(x)]))
}
pop_VecOrList <- function (x, i) {
    if (! is.vector(x)) {
        stop("The argument x must be a vector or list type object.")
    }
    if (i < 1 | i > length(x)) {
        stop("The argument i must greater than 1 and less than length of x.")
    }
    if (i + 1 <= length(x)) {
        poppedX <- c(x[seq_len(i - 1)], x[(i + 1) : length(x)])
    }
    else {
        poppedX <- x[seq_len(i - 1)]
    }
    return(list(poppedX = poppedX, xi = x[i]))
}
getCount <- function(x, item) {
  return(length(getIndex(x, item)))
}


eval_formula <- function (evstr){
    ffile  = opts$formula
    ffile  = gsub("\\\\", "/", ffile)
    if (file.exists(ffile)) {
        ## if formula is R script file
        source(ffile)
    } else {
        eval(parse(text=(evstr)))
    }
}

out_table <- function (lab) {
    x <- eval_formula(lab)
    write.table(x, "", sep=opts$delim, fileEncoding='UTF-8', quote=F, row.names=T, col.names=F, append=F)
}

# main
if ( ! is.na(opts$input)){
    ifile = opts$input
    ifile = gsub("\\\\", "/", ifile)
    # test input
    if ( ! file.exists(ifile)) {
        warning(sprintf("Specified file ( %s ) does not exist", ifile))
        quit(status=1)
    }
    con = file(ifile, open="r")
}else{
    con = file("stdin", open="r")
}

## read data
ndat <- 0
labpref <- "ANS"
while (TRUE) {
    line <- readLines(con, n=1)
    if (length(line) == 0){
        #print(vallist)
        assign(lastlab, matrix(vallist,nrow=nrow,ncol=ncol,byrow=T))
        eval(parse(text=(paste0("rownames(",lastlab,") <- make.names(rep('",lastlab,"',",nrow,"), unique=F)"))))
        out_table(lastlab)
        break
    }
    #print(line)
    if (line == ""){
        next
    }
    splines <- unlist(strsplit(line, split = opts$delim))
    ndat <- ndat + 1
    lab <- splines[1]
    len <- length(splines)
    if (len <= 1){
        warning(sprintf("short cols."))
        quit(status=1)
    }
    if (opts$dtype == "numeric"){
        vals <- as.numeric(as.vector(splines[-1]))
    } else if (opts$dtype == "integer") {
        vals <- as.integer(as.vector(splines[-1]))
    } else {
        vals <- as.factor(as.vector(splines[-1]))
    }
    if (ndat == 1) {
        ## init var
        lablist <- c(lab)
        vallist <- c(vals)
        ncol <- len - 1
        nrow <- 1
        lastlab <- lab
        labcnt <- 1
    } else if ( lab == lastlab) {
        nrow <- nrow + 1
        vallist <- c(vallist, vals)
        lastlab <- lab
    } else {
        ## output matrix
        #print(vallist)
        assign(lastlab, matrix(vallist,nrow=nrow,ncol=ncol,byrow=T))
        #print(paste0("rownames(",lastlab,") <- make.names(c('A','A'), unique=F)"))
        eval(parse(text=(paste0("rownames(",lastlab,") <- make.names(rep('",lastlab,"',",nrow,"), unique=F)"))))
        out_table(lastlab)
        ## init var
        lablist <- c(lablist, lab)
        vallist <- c(vals)
        ncol <- len - 1
        nrow <- 1
        lastlab <- lab
        labcnt <- labcnt + 1
    }
}
close(con)
#var_A <- "A"
#var_B <- "B"
#assign(var_A, matrix(c(1,2,3,4),nrow=2,ncol=2,byrow=T))
#assign(var_B, matrix(c(4,3,2,1),nrow=2,ncol=2,byrow=T))

## calc and output data
spformula <- unlist(strsplit(opts$formula, split='='))
if (length(spformula) == 1){
    lab <- lastlab
    while (getCount(lablist, lab) != 0) {
        labcnt <- labcnt + 1
        lab = LETTERS[labcnt]
    }
    frm <- trimws(spformula[1])
} else {
    lab <- trimws(spformula[1])
    if (getCount(lablist, lab) != 0){
        warning(sprintf("duplicated label: '%s'", lab))
        quit(status=1)
    }
    frm <- trimws(spformula[2])
}
#print(lab)
#print(frm)
assign(lab, eval_formula(frm))
eval(parse(text=(paste0("rownames(",lab,") <- make.names(rep('",lab,"',nrow(",lab,")), unique=F)"))))
out_table(lab)

quit(status=0)

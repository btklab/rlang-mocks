#!/usr/bin/env Rscript

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
    cat("rcalc.R -- exec/eval rscript from cli", "\n", sep="")
    cat("", "\n", sep="")
    cat("Synopsis:", "\n", sep="")
    cat("", "\n", sep="")
    cat("Usage: Rscript rcalc.R -f <formula> [-d <delim>] [opts...]", "\n", sep="")
    cat("  --delim,      -d :delimiter", "\n", sep="")
    cat("  --formula,    -f :formula", "\n", sep="")
    cat("  --input,      -i :input data file", "\n", sep="")
    cat("  --noheader       :no heder input", "\n", sep="")
    cat("  --colnames,   -c :data column names separated with comma", "\n", sep="")
    cat("  --colclasses     :data column clasees (character,integer,numeric,factor,etc...)", "\n", sep="")
    cat("  --library,    -l :import libraries separated with comma", "\n", sep="")
    cat("  --plot,       -p :show plot", "\n", sep="")
    cat("  --output,     -o :output plot image", "\n", sep="")
    cat("  --factor         :stringsAsFactors = TRUE", "\n", sep="")
    cat("  --debug          :print debug", "\n", sep="")
    cat("", "\n", sep="")
    cat("Examples:", "\n", sep="")
    cat("# simple usage", "\n", sep="")
    cat("cat iris.csv | Rscript rcalc.R -f 'summary(df)' -d ','", "\n", sep="")
    cat("", "\n", sep="")
    cat("# rename column names", "\n", sep="")
    cat("cat iris.csv | Rscript rcalc.R -f 'df |> head()' -d ',' -l 'tidyverse' -c sl,sw,pl,pw,sp", "\n", sep="")
    cat("", "\n", sep="")
    cat("# set colnames and colclasses", "\n", sep="")
    cat("Rscript rcalc.R -f 'sapply(df, class)' -i iris.csv -d ',' -c 'sl,sw,pl,pw,sp' --colclasses 'numeric,numeric,numeric,numeric,factor'", "\n", sep="")
    cat('         sl          sw          pl          pw          sp',"\n", sep="")
    cat('  "numeric"   "numeric"   "numeric"   "numeric" "character"',"\n", sep="")
    cat("", "\n", sep="")
    cat("", "\n", sep="")
    cat("# use built-in examples", "\n", sep="")
    cat("echo 1 | Rscript rcalc.R -f 'letters'", "\n", sep="")
    cat("", "\n", sep="")
    cat("# import libraries", "\n", sep="")
    cat("cat iris.csv | Rscript rcalc.R -f 'summary(df)' -d ',' -l ggplot2,optparse", "\n", sep="")
    cat("echo 1 | Rscript rcalc.R -f 'iris %>% group_by(Species) %>% summarise(mean = mean(Petal.Length))' -d ',' -l dplyr", "\n", sep="")
    cat("", "\n", sep="")
    cat("# output package startup message (-m | --message)", "\n", sep="")
    cat("echo 1 | Rscript rcalc.R -f 'letters' -l tidyverse -m", "\n", sep="")
    cat("", "\n", sep="")
    cat("# output csv", "\n", sep="")
    cat("cat iris.csv | Rscript rcalc.R -f 'summary(df);write.csv(df,'',quote=FALSE)' -d ','", "\n", sep="")
    cat("", "\n", sep="")
    cat("# plot", "\n", sep="")
    cat("cat iris.csv | Rscript rcalc.R -f 'plot(df)' -d ',' --plot", "\n", sep="")
    cat("", "\n", sep="")
    cat("# ggplot2 : using print() and --plot", "\n", sep="")
    cat("cat iris.csv | Rscript rcalc.R -d ',' -f \"p <- ggplot(data=df,mapping=aes(x=sepal_length,y=sepal_width))+layer(geom='point',stat='identity',position='identity');print(p)\" -l ggplot2 --plot", "\n", sep="")
    cat("", "\n", sep="")
    cat("    the above is equivalent to the following Rscript (RScript a.R)", "\n", sep="")
    cat("    note that unavailable multibyte character in rscript", "\n", sep="")
    cat("", "\n", sep="")
    cat("    library(ggplot2)", "\n", sep="")
    cat("    X11()", "\n", sep="")
    cat("    p <- ggplot(data=iris,mapping=aes(x=Sepal.Length,y=Sepal.Width))+", "\n", sep="")
    cat("        layer(geom='point',stat='identity',position='identity')", "\n", sep="")
    cat("    print(p)", "\n", sep="")
    cat("    Sys.sleep(1000)", "\n", sep="")
    cat("    dev.off()", "\n", sep="")
    cat("", "\n", sep="")
    cat("## ggplot2 another example: histogram", "\n", sep="")
    cat("cat iris.csv | Rscript rcalc.R -d ',' -f \"p <- ggplot(iris)+geom_histogram(aes(Petal.Length, fill=Species), binwidth=0.5)+facet_wrap(~Species);print(p)\" -l ggplot2 --plot", "\n", sep="")
    cat("", "\n", sep="")
    cat("## ggplot2 another example: histogram using gghighlight", "\n", sep="")
    cat("cat iris.csv | Rscript rcalc.R -d ',' -f \"p <- ggplot(iris)+geom_histogram(aes(Petal.Length, fill = Species), binwidth = 0.5)+gghighlight()+facet_wrap(~ Species);print(p)\" -l ggplot2,gghighlight --plot", "\n", sep="")
    cat("", "\n", sep="")
    cat("## ggplot2 another example: geom_point using gghighlight", "\n", sep="")
    cat("cat iris.csv | Rscript rcalc.R -d ',' -f \"p <- ggplot(data=df,mapping=aes(x=sepal_length,y=sepal_width,colour=species))+geom_point()+gghighlight(grepl('^v',species));print(p)\" -l ggplot2,gghighlight --plot", "\n", sep="")
    cat("", "\n", sep="")
    cat("", "\n", sep="")
    cat("# save plot as image file", "\n", sep="")
    cat("cat iris.csv | Rscript rcalc.R -f 'hist(df$sepal_length)' -d ',' -o a.png", "\n", sep="")
    cat("cat iris.csv | Rscript rcalc.R -f 'hist(df$sepal_length)' -d ',' -o a.png -s 400,300", "\n", sep="")
    cat("cat iris.csv | Rscript rcalc.R -f 'hist(df$sepal_length)' -d ',' -o a.jpg -s 400,300", "\n", sep="")
    cat("cat iris.csv | Rscript rcalc.R -f 'hist(df$sepal_length)' -d ',' -o a.bmp -s 6,4", "\n", sep="")
    cat("cat iris.csv | Rscript rcalc.R -f 'hist(df$sepal_length)' -d ',' -o a.pdf", "\n", sep="")
    cat("cat iris.csv | Rscript rcalc.R -f 'hist(df$sepal_length)' -d ',' -o a.eps", "\n", sep="")
    cat("", "\n", sep="")
    cat("", "\n", sep="")
    cat("# eval external R source file", "\n", sep="")
    cat("echo 1 | Rscript rcalc.R -f a.R -l 'palmerpenguins,ggplot2' --plot", "\n", sep="")
    cat("         Rscript rcalc.R -f a.R -l 'palmerpenguins,ggplot2' --plot -i penguins.csv -d ','", "\n", sep="")
    cat("", "\n", sep="")
    cat("", "\n", sep="")
    cat("## palmer penguins by allison horst", "\n", sep="")
    cat("echo 1 | Rscript rcalc.R -f 'penguins %>% count(species)' -l 'palmerpenguins,tidyverse'", "\n", sep="")
    cat("## # A tibble: 3 x 2", "\n", sep="")
    cat("##   species       n", "\n", sep="")
    cat("##   <fct>     <int>", "\n", sep="")
    cat("## 1 Adelie      152", "\n", sep="")
    cat("## 2 Chinstrap    68", "\n", sep="")
    cat("## 3 Gentoo      124", "\n", sep="")
    cat("", "\n", sep="")
    cat("", "\n", sep="")
    cat("echo 1 | Rscript rcalc.R -f 'penguins %>% group_by(species) %>% summarize(across(where(is.numeric), mean, na.rm = TRUE))' -l 'palmerpenguins,tidyverse'", "\n", sep="")
    cat("## # A tibble: 3 x 6", "\n", sep="")
    cat("##   species   bill_length_mm bill_depth_mm flipper_length_mm body_mass_g  year", "\n", sep="")
    cat("##   <fct>              <dbl>         <dbl>             <dbl>       <dbl> <dbl>", "\n", sep="")
    cat("## 1 Adelie              38.8          18.3              190.       3701. 2008.", "\n", sep="")
    cat("## 2 Chinstrap           48.8          18.4              196.       3733. 2008.", "\n", sep="")
    cat("## 3 Gentoo              47.5          15.0              217.       5076. 2008.", "\n", sep="")
    cat("", "\n", sep="")
    cat("", "\n", sep="")
    cat("echo 1 | Rscript rcalc.R -f \"flipper_hist <- ggplot(data=penguins, aes(x=flipper_length_mm))+geom_histogram(aes(fill=species), alpha = 0.5, position='identity')+scale_fill_manual(values=c('darkorange','purple','cyan4'))+theme_minimal()+labs(x='Flipper length (mm)', y='Frequency', title='Penguin flipper lengths');print(flipper_hist)\" -l 'palmerpenguins,ggplot2' --plot", "\n", sep="")
    cat(" `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.", "\n", sep="")
    cat("Warning message:", "\n", sep="")
    cat("Removed 2 rows containing non-finite values (stat_bin).", "\n", sep="")
    cat("", "\n", sep="")
    cat("", "\n", sep="")
    quit(status=1)
}

optslist <- list(
    #make_option("--flag1", action="store_true", default=FALSE, help="A Flag"),
    make_option(c("-f", "--formula"),  type="character",    default=NA,    help="formula"),
    make_option(c("-d", "--delim"),    type="character",    default=' ',   help="delimiter"),
    make_option(c("-i", "--input"),    type="character",    default=NA,    help="An input image"),
    make_option(c("-c", "--colnames"), type="character",    default=NA,    help="column names"),
    make_option("--colclasses"       , type="character",    default=NA,    help="column classes"),
    make_option("--factor"           , action="store_true", default=FALSE, help="stringsAsFactors"),
    make_option(c("-o", "--output"),   type="character",    default=NA,    help="output file"),
    make_option(c("-l", "--library"),  type="character",    default=' ',   help="import libraries"),
    make_option(c("-p", "--plot"),     action="store_true", default=FALSE, help="no header input"),
    make_option(c("-s", "--size"),     type="character",    default=NA,    help="plot size"),
    make_option("--skip",              type="integer",      default=0,     help="skip rows"),
    make_option("--noheader",          action="store_true", default=FALSE, help="no header input"),
    make_option("--nowrap",            action="store_true", default=FALSE, help="no wrap output"),
    make_option("--na",                type="character",    default='NA',  help="na string"),
    make_option(c("-m", "--message"),  action="store_true", default=FALSE, help="output package startup message"),
    make_option("--debug",             action="store_true", default=FALSE, help="debug print")
    )
parser <- OptionParser(option_list=optslist)
opts <- parse_args(parser)
# test opts
## check input is provided
if (is.na(opts$formula)) {
    warning("formula(-f, --formula) parameter must be provided. See script usage (--help)")
    quit(status=1)
}

# check if output is provided
ofile = NA
if ( ! is.na(opts$output)){
    ## get extension of image file
    ofile  = opts$output
    ofile  = gsub("\\\\", "/", ofile)
    ofname = gsub("\\.[^.]+$", "", ofile)
    ofext  = tolower(gsub("^.*\\.", "", ofile))
    ## set image size
    if( ! is.na(opts$size)){
        s <- unlist(strsplit(opts$size, split=","))
        if(length(s) == 1){
            im_width  = strtoi(s[1])
            im_height = strtoi(s[1])
        }else{
            im_width  = strtoi(s[1])
            im_height = strtoi(s[2])
        }
    }else if (ofext == "png" || ofext == "jpg" || ofext == "jpeg") {
        im_width  = 600
        im_height = 600
    }else{
        im_width  = 6
        im_height = 6
    }

    im_comstr = NA
    if (ofext == "png") {
        im_comstr <- paste0(
        "png(file='", ofile, "'",
        ", width=", im_width,
        ", height=", im_height,
        ')')
    } else if (ofext == "jpg" || ofext == "jpeg") {
        im_comstr <- paste0(
        "jpeg(file='", ofile, "'",
        ", width=", im_width,
        ", height=", im_height,
        ')')
    } else if (ofext == "bmp") {
        im_width  = 7
        im_height = 7
        im_comstr <- paste0(
        "bmp(file='", ofile, "'",
        ", width=", im_width,
        ", height=", im_height,
        ')')
    } else if (ofext == "pdf") {
        im_comstr <- paste0(
        "pdf(file='", ofile, "'",
        #", width=", im_width,
        #", height=", im_height,
        ')')
    } else if (ofext == "eps") {
        im_width  = 7
        im_height = 7
        im_comstr <- paste0(
        "postscript(file='", ofile, "'",
        ', horizontal=F',
        ', onefile=F',
        ', paper="special"',
        ')')
    } else if (ofext == "txt" || ofext == "csv" || ofext == "tsv") {
        im_comstr <- NA
    } else {
        warning(paste(ofile, " is not available image format. jpg,png,bmp,pdf,eps is available.", sep = ""))
        quit(status=1)
    }
}

# debug print
if (opts$debug){
    if(!is.na(opts$formula)){cat("formula   :", opts$formula, "\n")}
    if(!is.na(opts$input))  {cat("input     :", opts$input, "\n")}
    if(!is.na(opts$output)) {cat("output    :", opts$output, "\t[output image file(.jpg or .png)]\n")}
    if(!is.na(opts$library)){cat("library   :", opts$library, "\n")}
    cat("debug     :", opts$debug,      "\t[bool, default: FALSE]\n")
}

# import libraries
import_libraries <- function (libstr){
    lopts <- ", warn.conflicts=FALSE"
    if (opts$message){
        pre <- ""
        suc <- ')'
    }else{
        pre <- "suppressPackageStartupMessages("
        suc <- '))'
    }
    eval(parse(text=paste0(
        pre,
        "suppressWarnings(",
        "library(", libstr, lopts, ")",
        suc
        )))
}
if ( ! is.na(opts$library)){
    libs = unlist(strsplit(opts$library, split=","))
    import_libraries(libs)
}

# main
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
if (opts$noheader){
    hflag = FALSE
}else{
    hflag = TRUE
}

# read table from file or stdin
if ( ! is.na(opts$colclasses)){
    colclasses = unlist(strsplit(opts$colclasses, split=","))
    df <- read.table(con, sep = opts$delim, header = hflag, quote = "",
        skip = opts$skip,
        na.strings = opts$na,
        colClasses = colclasses,
        stringsAsFactors = FALSE,
        fileEncoding = 'utf-8')
} else {
    df <- read.table(con, sep = opts$delim, header = hflag, quote = "",
        skip = opts$skip,
        na.strings = opts$na,
        stringsAsFactors = FALSE,
        fileEncoding = 'utf-8')
}
close(con)

# change column names
if ( ! is.na(opts$colnames)){
    colnames = unlist(strsplit(opts$colnames, split=","))
    colnames(df) <- colnames
}
if ((opts$plot) & (is.na(ofile))){
    # show plot
    X11()
    eval_formula(opts$formula)
    cat("Press Ctrl+c to continue...")
    Sys.sleep(1000)
    dev.off()
} else if (! is.na(ofile)){
    if (ofext == "txt" || ofext == "csv" || ofext == "tsv") {
        x <- eval_formula(opts$formula)
        write.table(x, ofile, sep=opts$delim, fileEncoding='UTF-8', quote=F, row.names=F, col.names=T, append=F)
    } else {
        # save plot as image file
        eval_formula(im_comstr)
        #print(im_comstr)
        eval_formula(opts$formula)
        dev.off()
        # check output file
        if (file.exists(ofile)) {
            print(paste("output:", ofile, sep = " "))
        } else {
            warning(paste("error: can't export to", ofile, sep = " "))
            quit(status=1)
        }
    }
} else if (opts$nowrap){
        x <- eval_formula(opts$formula)
        ofile = ""
        write.table(x, ofile, sep=opts$delim, fileEncoding='UTF-8', quote=F, row.names=F, col.names=T, append=F)
}else{
    eval_formula(opts$formula)
}

quit(status=0)

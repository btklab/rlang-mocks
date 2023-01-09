#!/usr/bin/env Rscript

# sketch.R - A wrapper script of "sketcher" library
#
# load file
#install.packages("optparse", dependencies = T)
#install.packages("Rtools", dependencies = T)
#install.packages("sketcher", dependencies = T)
suppressWarnings(library('optparse'))
suppressWarnings(library('sketcher'))

## =======================================
## CREDIT
## library: sketcher
## used in: "sketch.R"
## from: GitHub - https://github.com/tsuda16k/sketcher
## blog: https://htsuda.net/sketcher/
## 
## MIT License
##
## Copyright (c) 2020 Hiroyuki Tsuda
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


GET_SKETCH = function(ifile,  style = 1, lineweight = 1, smooth = ceiling(lineweight),
					gain = .02, contrast = NULL, shadow = 0, max.size = 2048) {

	# sketch.R
	# 	The default param setting is
	# 	sketch(im, style = 1, lineweight = 1, smooth = ceiling(lineweight),
	# 		gain = .02, contrast = NULL, shadow = 0, max.size = 2048). 
	im <- im_load(ifile)
	im2 <- sketcher::sketch(im, style=style, lineweight=lineweight, smooth=smooth,
							gain=gain, contrast=contrast, shadow=shadow, max.size=max.size)
	return(im2)

	# from: GitHub - https://github.com/tsuda16k/sketcher/
	# Arguments of the sketch() function
	# A table of arguments of the sketch() function:
	#   Argument 	Meaning 	Value 	Default
	#   im 	An input image 	image 	
	#   style 	Sketch style 	1 or 2 	1
	#   lineweight 	Strength of lines 	a numeric, >= 0.3 	1
	#   smooth 	Smoothness of texture 	an integer, >= 0 	1
	#   gain 	Gain parameter 	a numeric betw 0 and 1 	0.02
	#   contrast 	Contrast parameter 	a numeric, >= 0 	20 (for style1) or 4 (for style2)
	#   shadow 	Shadow threshold 	a numeric betw 0 and 1 	0.0
	#   max.size 	Max resolution of output 	an integer, > 0 	2048
	#
	#  - im: an image, obtained by using the im_load() function.
	#  - style: while style 1 focuses on edges, style 2 also retains shading.
	#  - lineweight: as the name suggests. set a numeric value equal to or larger than 0.3.
	#  - smooth: noise/blob smoother. set an integer value equal to or larger than 0.
	#  - gain: this parameter may be useful for noise reduction in the dim region of a photograph.
	#  - contrast: contrast of the sketch image is adjusted by this parameter.
	#  - shadow: if given a value larger than 0 (e.g., 0.3), shadows are added to sketch.
	#  - max.size: the size (image resolution) of output sketch is constrained by this parameter. if the input image has a very high resolution, such as 20000 x 10000 pixels, sketch processing will take a long time. In such cases, the algorithm first downscales the input image to 2048 x 1024 pixels, in this case, and then apply the sketch effect. 
}

# check opt
argv = commandArgs(TRUE)
if ( is.na(argv[1])){
	cat("sketch.R", "\n")
	cat("  using sketcher::sketch, https://github.com/tsuda16k/sketcher", "\n")
	cat("", "\n")
	cat("Usage: Rscript.exe sketch.R -i in.png [--debug] [[param] [param] ... [param]]", "\n")
	cat("  --input, -i  :An input image", "\n")
	cat("  --style      :Sketch style: 1 or 2, defalut: 1", "\n")
	cat("  --lineweight :Strength of lines: >=0.3, default: 1", "\n")
	cat("  --smooth     :Smoothness of texture: >=0, default: 1", "\n")
	cat("  --gain,      :Gain parameter: betw 0 and 1, default: 0.02", "\n")
	cat("  --contrast   :Contrast parameter: >=0, default: 20(for style1) or 4(for style2)", "\n")
	cat("  --shadow     :Shadow threshold: betw 0 and 1, defalut 0.0", "\n")
	cat("  --maxsize    :Max resolution of output: >0, default: 2048", "\n")
	cat("  --output, -o :output file, default: NA", "\n")
	cat("  --debug      :print debug, default: FALSE", "\n")
	cat("", "\n")
	cat("Case1: Outline is missing and texture is lacking", "\n")
	cat("  --style 2 --shadow 0.4", "\n")
	cat("", "\n")
	cat("Case2: Due to the lack of edges in the dark region of the face", "\n")
	cat("  --shadow 0.4", "\n")
	cat("", "\n")
	cat("Case3: Neko. objects have unclear edges/outlines", "\n")
	cat("  --smooth 0", "\n")
	quit(status=1)
}

# get opt
# GET_SKETCH = function(ifile,  style = 1, lineweight = 1, smooth = ceiling(lineweight),
#					gain = .02, contrast = NULL, shadow = 0, max.size = 2048) {
optslist <- list(
	#make_option("--flag1", action="store_true", default=FALSE, help="A Flag"),
	make_option(c("-i", "--input"), type="character", default=NA, help="An input image"),
	make_option("--style", type="integer", default=1, help="Sketch style: 1 or 2, defalut: 1"),
	make_option("--lineweight", type="double", default=1, help="Strength of lines: >=0.3, default: 1"),
	make_option("--smooth", type="integer", default=NA, help="Smoothness of texture: >=0, default: 1"),
	make_option("--gain", type="double", default=0.02, help="Gain parameter: betw 0 and 1, default: 0.02"),
	make_option("--contrast", type="double", default=NULL, help="Contrast parameter: >=0, default: 20(for style1) or 4(for style2)"),
	make_option("--shadow", type="double", default=0.0, help="Shadow threshold: betw 0 and 1, defalut 0.0"),
	make_option("--maxsize", type="integer", default=2048, help="Max resolution of output: >0, default: 2048"),
	make_option(c("-o", "--output"), type="character", default=NA, help="output file, default: NA"),
	make_option("--debug", action="store_true", default=FALSE, help="debug print")
	)
parser <- OptionParser(option_list=optslist)
opts <- parse_args(parser)
# test opts
## check input is provided
if (is.na(opts$input)) {
	warning("input(-i, --input) parameter must be provided. See script usage (--help)")
	quit(status=1)
}
ifile = opts$input
ifile = gsub("\\\\", "/", ifile)
# test input
if ( ! file.exists(ifile)) {
	warning(sprintf("Specified file ( %s ) does not exist", ifile))
	quit(status=1)
}

## check output is provided
ofile = NA
if (!is.na(opts$output)){
	ofile  = opts$output
	ofile  = gsub("\\\\", "/", ofile)
	ofname = gsub("\\.[^.]+$", "", ofile)
	ofext  = tolower(gsub("^.*\\.", "", ofile))
	if (ofext == "png" || ofext == "jpg") {
		ofile = ofile
	} else {
		warning(paste(ofile, " is not available image format. jpg or png is available.", sep = ""))
		quit(status=1)
	}
}
if(is.na(opts$smooth)){
	optSmooth = opts$lineweight
} else {
	optSmooth = opts$smooth
}
# debug print
if (opts$debug){
	cat("input     :", ifile,           "\t[input image file]\n")
	cat("style     :", opts$style,      "\t[ 1 or 2, default: 1]\n")
	cat("lineweight:", opts$lineweight, "\t[ >=0.3, default: 1]\n")
	cat("smooth    :", optSmooth,       "\t[ >=0, default: 1]\n")
	cat("gain      :", opts$gain,       "\t[ betw 0 and 1, default: 0.02]\n")
	cat("contrast  :", opts$contrast,   "\t[ >=0, default: NULL]\n")
	cat("shadow    :", opts$shadow,     "\t[ betw 0 and 1, default: 0.0]\n")
	cat("maxsize   :", opts$maxsize,    "\t[ >0, default: 2048]\n")
	cat("output    :", ofile,           "\t[output image file(.jpg or .png)]\n")
	cat("debug     :", opts$debug,      "\t[bool, default: FALSE]\n")
	cat("", "\n")
	cat("Case1: Outline is missing and texture is lacking", "\n")
	cat("  --style 2 --shadow 0.4", "\n")
	cat("", "\n")
	cat("Case2: Due to the lack of edges in the dark region of the face", "\n")
	cat("  --shadow 0.4", "\n")
	cat("", "\n")
	cat("Case3: Neko. objects have unclear edges/outlines", "\n")
	cat("  --smooth 0", "\n")
	cat("", "\n")
	cat("using sketcher::sketch, https://github.com/tsuda16k/sketcher", "\n")
}

#ifile,  style = 1, lineweight = 1, smooth = ceiling(lineweight),
#					gain = .02, contrast = NULL, shadow = 0, max.size = 2048) {
#im2 <- sketcher::sketch(im)
im2 <- GET_SKETCH(
	ifile,
	style = opts$style,
	lineweight = opts$lineweight,
	smooth = ceiling(optSmooth),
	gain = opts$gain,
	contrast = opts$contrast,
	shadow = opts$shadow,
	max.size = opts$maxsize
	)

# show image
if (is.na(ofile)) {
	# show sketch
	X11()
	plot(im2)
	cat("Press Ctrl+c to continue...")
	Sys.sleep(1000)
	dev.off()
} else {
	# save as file
	if (ofext == "png"){
		im_save(im2, name = ofname, path = getwd())
	} else if (ofext == "jpg"){
		im_save(im2, name = ofname, path = getwd(), format = "jpg", quality = .95)
	} else{
		warning("Incorrect imaeg format. Use either jpg or png.")
		quit(status=1)
	}
	# check output file
	if (file.exists(ofile)) {
		print(paste("output:", ofile, sep = " "))
	} else {
		warning(paste("error: can't export to", ofile, sep = " "))
		quit(status=1)
	}
}
quit(status=0)
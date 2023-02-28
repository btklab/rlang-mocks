# rlang-mocks

A mock-up cli script set of [R: The R Project for Statistical Computing](https://www.r-project.org/) that filter text-object input from the pipeline(stdin) and return text-object.

- For use in UTF-8 Japanese environments on windows.
- For my personal work and hobby use.
- Note that the code is spaghetti (due to my technical inexperience).
- Insufficient tests and error handlings.

script list:

```powershell
# one-liner to create function list
(cat README.md | sls '^#### \[[^[]+\]').Matches.Value.Replace('#### ','') -join ", " | Set-Clipboard
```

- [rcalc.R], [rmatcalc.R], [sketch.R]


コード群にまとまりはないが、事務職（非技術職）な筆者の毎日の仕事（おもに文字列処理）を、より素早くさばくための道具としてのコマンドセットを想定している（毎日使用する関数は1個に満たないが）。

基本的に入力としてUTF-8で半角スペース区切り、行指向の文字列データ（テキストオブジェクト）を期待する、主にパターンマッチング処理を行うためのフィルタ群。Windows上でしか動かない関数も、ある。

`src`下のファイルは1ファイル1関数。基本的に他の関数には依存しないようにしているので、関数ファイル単体を移動して利用することもできる。（一部の関数は他の関数ファイルに依存しているものもある）

**充分なエラー処理をしていない**モックアップ。


## Install functions

1. Put `*.R` files under the `src` directory at any location.
2. Set terminal input/output encoding to `UTF-8`
    - The functions expect `UTF-8` encoded input, so if you want to run them on PowerShell in a Japanese environment, make sure the encoding is ready in advance.
    - if you use PowerShell, run the following dot sourcing command
        - `. path/to/rlang-mocks/operator.ps1`

関数群はUTF-8エンコードされた入力を期待するので、
関数実行前にカレントプロセスのエンコードを`UTF-8`にしておくとよい。

```powershell
# install favorite functions for japanese environment
# set encode
if ($IsWindows){
    chcp 65001
    [System.Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding("utf-8")
    [System.Console]::InputEncoding  = [System.Text.Encoding]::GetEncoding("utf-8")
    # compartible with multi byte code
    $env:LESSCHARSET = "utf-8"
}
```

```powershell
# or sourcing dot files
. path/to/rlang-mocks/operator.ps1
```

## Description of each functions

各関数の挙動と作った動機と簡単な説明。

### Show functions

None

### Multipurpose

#### [rcalc.R] - Cli rscript executer

[rcalc.R]: src/rcalc.R

- Usage
    - man: `Rscript rcalc.R [-h]`
    - `Rscript rcalc.R -f <formula> [-d <delim>] [opts...]`
- Library
    - require: `optparse`
    - optional: `ggplot2`, `tidyverse`

Synopsis:

```powershell
$ Rscript rcalc.R
Usage: Rscript rcalc.R -f <formula> [-d <delim>] [opts...]
  --delim,      -d :delimiter
  --formula,    -f :formula
  --input,      -i :input data file
  --noheader       :no heder input
  --colnames,   -c :data column names separated with comma
  --colclasses     :data column clasees (character,integer,numeric,factor,etc...)
  --library,    -l :import libraries separated with comma
  --plot,       -p :show plot
  --output,     -o :output plot image
  --factor         :stringsAsFactors = TRUE
  --debug          :print debug
```

Examples:

```powershell
# simple usage
cat iris.csv | Rscript rcalc.R -f 'summary(df)' -d ','
```

```powershell
# rename column names
cat iris.csv | Rscript rcalc.R -f 'df |> head()' -d ',' -l 'tidyverse' -c sl,sw,pl,pw,sp
```

```powershell
# set colnames and colclasses
Rscript rcalc.R -f 'sapply(df, class)' -i iris.csv -d ',' -c 'sl,sw,pl,pw,sp' --colclasses 'numeric,numeric,numeric,numeric,factor'
         sl          sw          pl          pw          sp
  "numeric"   "numeric"   "numeric"   "numeric" "character"
```

```powershell
# use built-in examples
echo 1 | Rscript rcalc.R -f 'letters'
```

```powershell
# import libraries
cat iris.csv | Rscript rcalc.R -f 'summary(df)' -d ',' -l ggplot2,optparse
echo 1 | Rscript rcalc.R -f 'iris %>% group_by(Species) %>% summarise(mean = mean(Petal.Length))' -d ',' -l dplyr

# install libraries
Rscript -e 'install.packages("palmerpenguins", repos="https://cran.r-project.org/")'
echo 1 | Rscript rcalc.R -f 'install.packages("palmerpenguins", repos="https://cran.r-project.org/")'
```

```powershell
# output package startup message (-m|--message)
echo 1 | Rscript rcalc.R -f 'letters' -l tidyverse -m
```

```powershell
# output csv
cat iris.csv | Rscript rcalc.R -f 'summary(df);write.csv(df,"",quote=FALSE)' -d ','
```

```powershell
# plot
cat iris.csv | Rscript rcalc.R -f 'plot(df)' -d ',' --plot
```

```powershell
# ggplot2 : using print() and --plot
cat iris.csv | Rscript rcalc.R -d ',' -f "p <- ggplot(data=df,mapping=aes(x=sepal_length,y=sepal_width))+layer(geom='point',stat='identity',position='identity');print(p)" -l ggplot2 --plot
```

the above is equivalent to the following Rscript (RScript a.R).
note that unavailable multibyte character in rscript

```r
library(ggplot2)
X11()
p <- ggplot(data=iris,mapping=aes(x=Sepal.Length,y=Sepal.Width))+
    layer(geom='point',stat='identity',position='identity')
print(p)
Sys.sleep(1000)
dev.off()
```

```powershell
## ggplot2 another example: histogram
cat iris.csv | Rscript rcalc.R -d ',' -f "p <- ggplot(iris)+geom_histogram(aes(Petal.Length, fill=Species), binwidth=0.5)+facet_wrap(~Species);print(p)" -l ggplot2 --plot

## ggplot2 another example: histogram using gghighlight
cat iris.csv | Rscript rcalc.R -d ',' -f "p <- ggplot(iris)+geom_histogram(aes(Petal.Length, fill = Species), binwidth = 0.5)+gghighlight()+facet_wrap(~ Species);print(p)" -l ggplot2,gghighlight --plot

## ggplot2 another example: geom_point using gghighlight
cat iris.csv | Rscript rcalc.R -d ',' -f "p <- ggplot(data=df,mapping=aes(x=sepal_length,y=sepal_width,colour=species))+geom_point()+gghighlight(grepl('^v',species));print(p)" -l ggplot2,gghighlight --plot
```

```powershell
# save plot as image file
cat iris.csv | Rscript rcalc.R -f 'hist(df$sepal_length)' -d ',' -o a.png
cat iris.csv | Rscript rcalc.R -f 'hist(df$sepal_length)' -d ',' -o a.png -s 400,300
cat iris.csv | Rscript rcalc.R -f 'hist(df$sepal_length)' -d ',' -o a.jpg -s 400,300
cat iris.csv | Rscript rcalc.R -f 'hist(df$sepal_length)' -d ',' -o a.bmp -s 6,4
cat iris.csv | Rscript rcalc.R -f 'hist(df$sepal_length)' -d ',' -o a.pdf
cat iris.csv | Rscript rcalc.R -f 'hist(df$sepal_length)' -d ',' -o a.eps
```

```powershell
# eval external R source file

# install.packages("palmerpenguins")
# from: https://allisonhorst.github.io/palmerpenguins/
echo 1 | Rscript rcalc.R -f 'install.packages("palmerpenguins", repos="https://cran.r-project.org/")'

# eval palmerpenguins
echo 1 | Rscript rcalc.R -f a.R -l 'palmerpenguins,ggplot2' --plot
         Rscript rcalc.R -f a.R -l 'palmerpenguins,ggplot2' --plot -i penguins.csv -d ','
```

```powershell
## palmer penguins by allison horst
echo 1 | Rscript rcalc.R -f 'penguins %>% count(species)' -l 'palmerpenguins,tidyverse'
## # A tibble: 3 x 2
##   species       n
##   <fct>     <int>
## 1 Adelie      152
## 2 Chinstrap    68
## 3 Gentoo      124
```

```powershell
echo 1 | Rscript rcalc.R -f 'penguins %>% group_by(species) %>% summarize(across(where(is.numeric), mean, na.rm = TRUE))' -l 'palmerpenguins,tidyverse'
## # A tibble: 3 x 6
##   species   bill_length_mm bill_depth_mm flipper_length_mm body_mass_g  year
##   <fct>              <dbl>         <dbl>             <dbl>       <dbl> <dbl>
## 1 Adelie              38.8          18.3              190.       3701. 2008.
## 2 Chinstrap           48.8          18.4              196.       3733. 2008.
## 3 Gentoo              47.5          15.0              217.       5076. 2008.
```

```powershell
echo 1 | Rscript rcalc.R -f "flipper_hist <- ggplot(data=penguins, aes(x=flipper_length_mm))+geom_histogram(aes(fill=species), alpha = 0.5, position='identity')+scale_fill_manual(values=c('darkorange','purple','cyan4'))+theme_minimal()+labs(x='Flipper length (mm)', y='Frequency', title='Penguin flipper lengths');print(flipper_hist)" -l 'palmerpenguins,ggplot2' --plot
 `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
Warning message:
Removed 2 rows containing non-finite values (stat_bin).
```

### Math

#### [rmatcalc.R] - Cli matrix calculator by connecting with pipes

[rmatcalc.R]: src/rmatcalc.R

- Usage
    - man: `Rscript rmatcalc.R [-h]`
    - `Rscript rmatcalc.R -f <formula> [-d <delim>] [opts...]`
- Inspired by
    - [Ryuichi Ueda and CIT Autonomous Robot Lab](https://b.ueda.tech/?post=00674)
        - [GitHub - ryuichiueda/PMAT: Pipe Oriented Matrix Calculator](https://github.com/ryuichiueda/PMAT)
    - Command: `matcalc`, `pmat`
- Dependency
    - require: `optparse`

Synopsis:

```powershell
$ Rscript rmatcalc.R
Usage: Rscript rmatcalc.R -f <formula> [-d <delim>] [opts...]
  --formula,    -f :formula
  --delim,      -d :delimiter
  --input,      -i :input data from file
  --dtype          :array data type. defalut=numeric
  --nowrap         :no wrap
  --debug          :print debug
```

```
# Frequentry use
  A+B-A%*%B : sum, difference, product
  A * B     : Multiply element by element
  A %o% B   : cross product
  A %x% B   : kronecker product

# Functionss
  t(A)
  solve(A)
  eigen(A)
  det(A)
  diag(n)
  diag(a1:an)
  sum(x^n)
  crossprod(A)
  crossprod(x,y)
  rowSums(A)
  solSums(A)
  rowMeans(A)
  colMeans(A)
  x[upper.tri(A)] <- n
  x[lower.tri(A)] <- n
```

Examples:

```powershell
# input example:
$ cat matrix
A 1 2
A 3 4
B 4 3
B 2 1

# calc example:
$ cat matrix | Rscript rmatcalc.R -f 'A%*%B'
A 1 2
A 3 4
B 4 3
B 2 1
C 8 5
C 20 13

$ cat matrix | Rscript rmatcalc.R -f 'A*B'
A 1 2
A 3 4
B 4 3
B 2 1
C 4 6
C 6 4
```

```powershell
# transpose:
$ cat matrix | Rscript rmatcalc.R -f 't(A)'
A 1 2
A 3 4
B 1 3
B 2 4

# solve:
$ cat matrix | Rscript rmatcalc.R -f 'A%*%solve(A)'
A 1 1
A 2 4
B 1 0
B 0 1

# add new label to ans:
$ cat matrix | Rscript rmatcalc.R -f 'C=A*B'
A 1 2
A 3 4
B 4 3
B 2 1
C 4 6
C 6 4
```

```powershell
# determinant:
#   To output a single (non-matrix) value,
#   multiply by diag(1)
$ cat matrix | Rscript rmatcalc.R -f 'C=det(A)*diag(1)'
A 2 -6 4
A 7 2 3
A 8 5 -1
C -144

# rank:
$ cat matrix | Rscript rmatcalc.R -f 'C=qr(A)$rank*diag(1)'
A 2 -6 4
A 7 2 3
A 8 5 -1
C 3

# chain calc using pipe:
$ cat matrix | Rscript rmatcalc.R -f 'C=A*B' | Rscript rmatcalc.R -f 'E=C%*%A'
A 1 2
A 3 4
B 4 3
B 2 1
C 4 6
C 6 4
E 22 32
E 18 28
```

### Image processing

#### [sketch.R] - A wrapper script of "sketcher" library

[sketch.R]: src/sketch.R

- Usage
    - man: `Rscript sketch.R [-h]`
    - `Rscript sketch.R -i a.png [--debug] [[param] [param] ... [param]]`
        - `--input, -i  :An input image`
        - `--style      :Sketch style: 1 or 2, defalut: 1`
        - `--lineweight :Strength of lines: >=0.3, default: 1`
        - `--smooth     :Smoothness of texture: >=0, default: 1`
        - `--gain,      :Gain parameter: betw 0 and 1, default: 0.02`
        - `--contrast   :Contrast parameter: >=0, default: 20(for style1) or 4(for style2)`
        - `--shadow     :Shadow threshold: betw 0 and 1, defalut 0.0`
        - `--maxsize    :Max resolution of output: >0, default: 2048`
        - `--output, -o :output file, default: NA`
        - `--debug      :print debug, default: FALSE`
- Dependency
    - require: `optparse`, `sketcher`

Examples:

```powershell
# Case1: Outline is missing and texture is lacking
Rscript sketch.R -i a.png --style 2 --shadow 0.4

# Case2: Due to the lack of edges in the dark region of the face
Rscript sketch.R -i a.png --shadow 0.4

# Case3: Neko. objects have unclear edges/outlines
Rscript sketch.R -i a.png --smooth 0
```

## CREDITS

### [rmatcalc.R]

- used functions:
    - `getIndex`, `append_VecOrList`, `extend_VecOrList`, `remove_vecOrList`, `insert_VecOrList`, `pop_VecOrList`, `getCount`
- from:
    - GitHub - usagi-san-dayo/UsagiSan/R/UsagiSan.R
        - <https://github.com/usagi-san-dayo/UsagiSan>
    - blog - usagi-san no toukeigaku salon
        - <https://multivariate-statistics.com/2021/01/29/r-programming-vector-list/>
- license:
    - MIT License: Copyright (c) 2020 UsagiSan

### [sketch.R]

- used library:
    - `sketcher`
- from:
    - GitHub - <https://github.com/tsuda16k/sketcher>
    - Blog - <https://htsuda.net/sketcher/>
- license:
    - MIT License: Copyright (c) 2020 Hiroyuki Tsuda


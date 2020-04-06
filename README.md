# docker-termextract

This is a Dockerfile that creates Docker images to easily use the Perl module "TermExtract" for automatic extraction of technical terms. 

* Perl term "TermExtract" for automatic extraction of technical terms. 
http://gensen.dl.itc.u-tokyo.ac.jp/termextract.html

This Dockerfile builds containers for the following environment.

| Item        | Version | Remarks |
|:-----------|:------------|:------------|
| CentOS     | 7 | ja_JP.UTF-8|
| perl | 5.16.3 | yum base |
| MeCab     | 0.996 | --enable-utf8-only|
| MeCab IPAdic | 2.7.0-20070801 |--with-charset=utf8|
| MeCab IPAdic model | 2.7.0-20070801 ||
| MeCab perl | 0.996 ||
| TermExtract | 4_10 ||

## Construction

```bash
$ git clone git@github.com:chauapple/termextract-docker.git
$ cd termextract-docker
$ docker-compose build
$ docker-compose up -d
```

## How to use
* When connecting a terminal to a container  
```bash
% docker-compose exec termextract bash
bash-4.1#termextract_mecab.pl
不動産鑑定評価は、客観的立場で不動産の適正な価格を把握することを目的としています。
EOS
客観的立場                                                          1.59
不動産鑑定評価                                                    1.59
```

Enter EOS to end the input.  

* When extracting technical terms from analyzed text files

```bash
$docker-compose exec termextract termextract_mecab.pl --input file/test.txt
```

* Input format  
Only text with UTF8 character code is supported.

| Argument        | Explanation       |Default   |
|:-----------|:------------|:------------|
| --input Or no argument | standard input or analysis target file name (in container)|Standard input|
| --output | 1: technical terms + importance, 2: technical terms only, 3: comma delimited, 4: IPAdic dictionary format (cost estimation), 5: IPAdic dictionary format (string length)|1|
| --limit | Output count|-1(all)|
| --threshold | Threshold|-1(all)|
| --is_mecab | Take input as morphologically analyzed||
| --no_dic_filter | Output technical terms registered in the MeCab dictionary||
| --no_term_extract | Perform only cost estimation without morphological analysis and technical term extraction||
| --stat_db |Database file name when using cumulative statistics of past documents(<code>/var/lib/termextract/</code>Subordinate)|"stat_db"|
| --comb_db |Database file name when using cumulative statistics of past documents(<code>/var/lib/termextract/</code>Subordinate)|"comb_db"|
| --no_stat |Do not use learning function in importance calculation||
| --no_storage |Do not accumulate data in the learning function DB||
| --average_rate |Whether to place more importance on "frequency of terms in the document" or "importantness of connected words" in the importance calculation. The higher the value, the higher the weight of the term frequency in the document|1|
| --pre_filter |File name listing regular expression patterns to remove from plain text before morphological analysis(<code>/var/lib/termextract/</code>Subordinate)|"pre_filter.txt"|
| --post_filter |File name that lists the regular expression patterns that are not output after compound word extraction(<code>/var/lib/termextract/</code>Subordinate)|"post_filter.txt"|
| --use_total |Take the total number of connected words in importance calculation|ON|
| --use_uniq |Take the number of different conjuncts in importance calculation||
| --use_Perplexity |Take perplexity of connected words in importance calculation||
| --no_LR |Don't use adjacency information in importance calculation||
| --use_TF |Term appearance frequency information TF multiplied by concatenation information in importance calculation TF||
| --use_frq |Term frequency multiplied by concatenation information in importance calculation Term frequency by Frequency|ON|
| --no_frq |Term occurrence frequency information to be multiplied with concatenated information is not used in importance calculation||
| --use_SDBM |Specify DBM used for learning function DB in SDBM_File||
| --lock_dir |Specify temporary directory for exclusive lock of database|Do not lock|

* Output result  
<code>--output</code>The text of the analysis result according to the mode specified in is output to the standard output in UTF8 character code.



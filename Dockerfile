FROM centos:centos7
MAINTAINER Chau Apple <ledinhtuan@fabercompany.co.jp>

RUN localedef -f UTF-8 -i ja_JP ja_JP.utf8
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8

RUN yum install -y wget tar vi bzip2
RUN yum install -y gcc make gcc-c++
RUN yum install -y perl perl-devel
RUN yum localinstall -y http://ftp.iij.ad.jp/pub/linux/centos-vault/6.7/os/x86_64/Packages/nkf-2.0.8b-6.2.el6.x86_64.rpm

# for debian
#RUN apt-get update
#RUN apt-get install locales
#RUN apt-get install -y wget tar vim nkf bzip2
#RUN apt-get install -y gcc make g++
#RUN apt-get install -y perl libperl-dev

# Mecab
RUN wget -O mecab-0.996.tar.gz "https://raw.githubusercontent.com/chauapple/publish-lib/master/mecab-0.996.tar.gz" && \
    tar -xzf mecab-0.996.tar.gz && \
    cd mecab-0.996 && ./configure --enable-utf8-only && make && make install && ldconfig && \
    rm -rf mecab-0.996.tar.gz*

# Ipadic
RUN wget -O mecab-ipadic-2.7.0-20070801.tar.gz "https://raw.githubusercontent.com/chauapple/publish-lib/master/mecab-ipadic-2.7.0-20070801.tar.gz" && \
    tar -xzf mecab-ipadic-2.7.0-20070801.tar.gz && \
    cd mecab-ipadic-2.7.0-20070801 && ./configure --with-charset=utf8 && make && make install && \
    echo "dicdir = /usr/local/lib/mecab/dic/ipadic" > /usr/local/etc/mecabrc && \
    rm -rf mecab-ipadic-2.7.0-20070801.tar.gz*

# Ipadic_model
RUN wget -O mecab-ipadic-2.7.0-20070801.model.bz2 "https://raw.githubusercontent.com/chauapple/publish-lib/master/mecab-ipadic-2.7.0-20070801.model.bz2" && \
    bzip2 -d mecab-ipadic-2.7.0-20070801.model.bz2 && \
    nkf --overwrite -Ew mecab-ipadic-2.7.0-20070801.model && \
    sed -i -e "s/euc-jp/utf-8/g" mecab-ipadic-2.7.0-20070801.model && \
    rm -rf mecab-ipadic-2.7.0-20070801.tar.gz*

# Mecab-perl
RUN wget -O mecab-perl-0.996.tar.gz "https://raw.githubusercontent.com/chauapple/publish-lib/master/mecab-perl-0.996.tar.gz" && \
    tar -xzf mecab-perl-0.996.tar.gz && \
    cd mecab-perl-0.996 && perl Makefile.PL && make && make install && \
    echo "/usr/local/lib" > /etc/ld.so.conf.d/mecab.conf && \
    ldconfig && rm -rf mecab-perl-0.996.tar.gz* 

# TermExtract
RUN wget http://gensen.dl.itc.u-tokyo.ac.jp/soft/TermExtract-4_11.tar.gz && \
    tar -xzf TermExtract-4_11.tar.gz && \
    nkf --overwrite -Ew /TermExtract-4_11/TermExtract/MeCab.pm && \
    cd TermExtract-4_11 && perl Makefile.PL && make && make install && \
    rm -rf TermExtract-4_11.tar.gz*

# Add perl script
ADD MeCabVerb.pm /usr/local/share/perl5/TermExtract/
ADD MeCabVerbAll.pm /usr/local/share/perl5/TermExtract/

ADD termextract_mecab.pl /usr/local/bin/termextract_mecab.pl
RUN chmod 755 /usr/local/bin/termextract_mecab.pl

ADD termextract_english_text_frequency.pl /usr/local/bin/termextract_english_text_frequency.pl
RUN chmod 755 /usr/local/bin/termextract_english_text_frequency.pl

ADD termextract_english_text_score.pl /usr/local/bin/termextract_english_text_score.pl
RUN chmod 755 /usr/local/bin/termextract_english_text_score.pl

ADD termextract_mecab_frequency.pl /usr/local/bin/termextract_mecab_frequency.pl
RUN chmod 755 /usr/local/bin/termextract_mecab_frequency.pl

ADD termextract_mecab_score.pl /usr/local/bin/termextract_mecab_score.pl
RUN chmod 755 /usr/local/bin/termextract_mecab_score.pl

ADD termextract_mecab_verball_frequency.pl /usr/local/bin/termextract_mecab_verball_frequency.pl
RUN chmod 755 /usr/local/bin/termextract_mecab_verball_frequency.pl

ADD termextract_mecab_verball_score.pl /usr/local/bin/termextract_mecab_verball_score.pl
RUN chmod 755 /usr/local/bin/termextract_mecab_verball_score.pl

ADD termextract_mecab_verb_frequency.pl /usr/local/bin/termextract_mecab_verb_frequency.pl
RUN chmod 755 /usr/local/bin/termextract_mecab_verb_frequency.pl

ADD termextract_mecab_verb_score.pl /usr/local/bin/termextract_mecab_verb_score.pl
RUN chmod 755 /usr/local/bin/termextract_mecab_verb_score.pl

ADD data/pre_filter.txt /var/lib/termextract/pre_filter.txt
ADD data/post_filter.txt /var/lib/termextract/post_filter.txt

WORKDIR /var/lib/termextract

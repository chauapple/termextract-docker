#!/usr/bin/perl -w

#  termextract_english_text_frequency.pl
#  Chau Apple <ledinhtuan@fabercompany.co.jp>

use TermExtract::EnglishPlainText;
my $data = new TermExtract::EnglishPlainText;

my $InputFile = $ARGV[0];
$SIG{INT} = $SIG{QUIT} = $SIG{TERM} = 'sigexit';

my $output_mode = 1;
$data->no_LR;

my @noun_list = $data->get_imp_word($InputFile);
foreach (@noun_list) {
   next if $_->[0] =~ /^(昭和)*(平成)*(\d+年)*(\d+月)*(\d+日)*(午前)*(午後)*(\d+時)*(\d+分)*(\d+秒)*$/;   # 日付・時刻
   next if $_->[0] =~ /^\d+$/;    # 数値のみ
   printf "%s\t%.0f\n", $_->[0], $_->[1] if $output_mode == 1;
}

sub sigexit {
   $data->unlock_db;
}

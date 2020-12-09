#!/usr/bin/perl -w

#  termextract_english_text_score.pl
#  Chau Apple <ledinhtuan@fabercompany.co.jp>

use TermExtract::EnglishPlainText;
my $data = new TermExtract::EnglishPlainText;

$SIG{INT} = $SIG{QUIT} = $SIG{TERM} = 'sigexit';

my $output_mode = 1;

# -i : Input File
# -t : Text
my $opt = $ARGV[0];
my $text_input = '';
if ($opt eq '-i') {
   my $command_read_text = 'cat ' . $ARGV[1];
   $text_input = `$command_read_text`;
} else {
   $text_input = $ARGV[1];
}

my @noun_list = $data->get_imp_word($text_input, 'var');
foreach (@noun_list) {
   next if $_->[0] =~ /^(昭和)*(平成)*(\d+年)*(\d+月)*(\d+日)*(午前)*(午後)*(\d+時)*(\d+分)*(\d+秒)*$/;   # 日付・時刻
   next if $_->[0] =~ /^\d+$/;    # 数値のみ
   printf "%s\t%.2f\n", $_->[0], $_->[1] if $output_mode == 1;
}

sub sigexit {
   $data->unlock_db;
}

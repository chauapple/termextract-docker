#!/usr/bin/perl -w
use TermExtract::MeCab;
my $data = new TermExtract::MeCab;

my $InputFile = $ARGV[0];
$SIG{INT} = $SIG{QUIT} = $SIG{TERM} = 'sigexit';

my $output_mode = 1;
$data->no_LR;

my $command_mecab = 'cat ' . $InputFile . ' | mecab';
my $mecab_output = `$command_mecab`;

my @noun_list = $data->get_imp_word($mecab_output, 'var');
foreach (@noun_list) {
   next if $_->[0] =~ /^(昭和)*(平成)*(\d+年)*(\d+月)*(\d+日)*(午前)*(午後)*(\d+時)*(\d+分)*(\d+秒)*$/;   # 日付・時刻
   next if $_->[0] =~ /^\d+$/;    # 数値のみ
   printf "%s\t%.0f\n", $_->[0], $_->[1] if $output_mode == 1;
}

sub sigexit {
   $data->unlock_db;
}

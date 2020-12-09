#!/usr/bin/perl -w
use TermExtract::MeCab;
my $data = new TermExtract::MeCab;

my $InputFile = $ARGV[0];
$SIG{INT} = $SIG{QUIT} = $SIG{TERM} = 'sigexit';

my $output_mode = 1;
$data->no_LR;

my $command_mecab = 'cat ' . $InputFile . ' | mecab';
my $mecab_output = `$command_mecab`;
   printf $mecab_output;

sub sigexit {
   $data->unlock_db;
}

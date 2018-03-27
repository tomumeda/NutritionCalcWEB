#!/usr/bin/perl
use warnings;
#use strict;
use Fcntl;
use DB_File;
use Time::Local;
use URI::Escape;

my $filelist=`cat filelist.txt`;
my @files=split(/\s+/,$filelist);
print "@files";

foreach my $files (@files) 
{ my ($file,$keylength)=split(/=/,$files);
  next if(! $file);
  my $dbName=$file;
  $dbName=~s/.txt//;
  my $dbFile="./DB/$dbName.db";
  unlink $dbFile;
  print "\nHELLO: $dbName ===\n";
  my %db=%{$dbName};
  tie %db,"DB_File",$dbFile,O_CREAT|O_RDWR,0666,$DB_BTREE;
  open L2,"../$file";
  while(<L2>)
  { 
    chop;
    my $l0;
    my $l=$l0=$_;
    my @l=&splitLine($l);
    my @key=@l;
    $#key=$keylength-1;
    my $key=join "^",@key;

    $db{ $key }=$l0;
    print "$key ";
    print length($db{ $key });
    print "\n";
    #  print "> ",$db{$key},"\n";
  }
  my @keys=keys %db;
  print "Number of keys ",$#keys,"\n";
  untie %db;
  # last;
  # die;
}

# removes ~ delimitors from $item
# 
sub noDelim
{ my ($item)=@_;
  $item =~s/^\~//;
  $item =~s/\~$//;
  $item =~s/\~ *$//;
  $item
}

sub splitLine
{ my ($l)=@_;
  $l=~s/\t/ /g;
  my @l=split(/\^/,$l);
#  @l = map {&noDelim($_)} @l;
  @l
} 

#!/usr/bin/perl
use warnings;
#use strict;
use DB_File;
use Time::Local;
use URI::Escape;

my $filelist=`cat filelist.txt`;
my @files=split(/\s+/,$filelist);
print " ::: @files\n\n";
my @dbName=();
my $dbName;
my $dbFile;
foreach my $files (@files) 
{ next if( $files !~ m/FOOD_DES/);
  my ($file,$keylength)=split(/=/,$files);
  next if(!$file);
  print "$file\n";
  $dbName=$file;
  $dbName=~s/\.txt//;
  push(@dbName,$dbName);
  $dbFile="../DB/$dbName.db";
  print "$dbName $dbFile\n";
  print "\nHELLO: $dbName ===\n";
  my %db;
  tie %db,"DB_File","$dbFile",O_RDWR,0666,$DB_BTREE || die "!!! can't open $dbFile !!!";
  %{$dbName}=%db;
  my @keys  = keys %db;
  my @values  = values  %db;
  print "number of keys $dbName: ",$#keys," keys\n";
  for($i=0;$i<=$#values;$i++)
  { 
    next if( $values[$i] !~ m/soy/i);
    next if( $values[$i] !~ m/isol/i);
    print "$values[$i]","\n";
  }
 }
# die "@dbName";

foreach $dbName (@dbName) 
{ 
  print "\nHELLO: $dbName ===\n";
  my %db=%{$dbName};
  my @keys  =keys %db;
  print "keys length $#keys \n";
#  print length(@values=values %db),"\n";
#  print "@keys";
}

# removes ~ delimitors from $item
# 
sub noDelim
{ my ($item)=@_;
  $item =~s/^\~//;
  $item =~s/\~$//;
  $item =~s/\~ $//;
  $item
}

sub splitLine
{ my ($l)=@_;
  $l=~s/\t/ /g;
  my @l=split(/\^/,$l);
#  @l = map {&noDelim($_)} @l;
  @l
} 

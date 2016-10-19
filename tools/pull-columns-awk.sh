#!/bin/csh 
# UNIX shell extract two columns from pipe-delimited-file MRCONSO.RRF
# files are at /Users/dmccrear/Documents/MarkLogic/ML-Projects/Healthcare-Datasets/RXNorm/RxNorm_full_10032016/rrf
# data dictionary for https://www.ncbi.nlm.nih.gov/books/NBK9685/table/ch03.T.concept_names_and_sources_file_mr/?report=objectonly
# -F is the field delimiter
# -F "|"
# CUI|LAT|TS|LUI|STT|SUI|ISPREF|AUI|SAUI|SCUI|SDUI|SAB|TTY|CODE|STR|SRL|SUPPRESS|CVF
# 2|ENG||||||3091081||N0000007747||NDFRT|SY|N0000007747|1,2-Dihexadecyl-sn-Glycerophosphocholine||N||
# 11|ENG||||||3236635||N0000171048||NDFRT|SY|N0000171048|Sarile||N||
# filed $8 is 3091081
# field $10 is N0000007747
# field $12 is N0000007747
# $8, $10, $11
cat 100.rrf | awk -F "|" 'BEGIN { print "id1|id2|10|11|12" } { print $8"|"$10"|"$11"|"$12"|"$13}	END  { print " - DONE -" }'
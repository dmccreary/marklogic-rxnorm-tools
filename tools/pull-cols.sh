#!/bin/sh
cat 100.rrf \
| awk -F "|" 'BEGIN {print "CUI|LAT|TS|LUI|STT|SUI|ISPREF|AUI|SAUI|SCUI|SDUI|SAB|TTY|CODE|STR|SRL|SUPPRESS|CVF"} {print $1 "|" $10 "|" $12}'
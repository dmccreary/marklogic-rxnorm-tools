# Concept Names and Sources
# Import Command Line Options https://docs.marklogic.com/guide/mlcp/import#id_23879
# -mode local
# the following line must be added
# CUI|LAT|TS|LUI|STT|SUI|ISPREF|AUI|SAUI|SCUI|SDUI|SAB|TTY|CODE|STR|SRL|SUPPRESS|CVF
# we are adding the Atom ID into the document URI which should be unique in the file
/Users/dmccrear/lib/mlcp/mlcp-8.0-5/bin/mlcp.sh IMPORT \
-host localhost \
-username admin \
-password admin \
-port 8030 \
-input_file_type delimited_text \
-delimiter "|" \
-output_uri_prefix '/reference-data/rxnorm/concept-and-name/' \
-output_uri_replace "/Users/dmccrear/Documents/workspace/marklogic-rxnorm-tools/tools,''" \
-output_uri_suffix '.xml' \
-uri_id AUI \
-input_file_path 101.rrf

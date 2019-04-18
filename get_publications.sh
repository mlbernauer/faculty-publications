#!/bin/bash

# Michael L. Bernauer
# pubmed_query.sh
#
# This script is used to query PubMed and return a CSV of results
# 
# Usage: ./pubmed_query.sh <query_file> <output_file>

echo Submiting $1 to PubMed...
query=$(cat $1 | egrep -v '^#|^$' | tr -d '\n' | sed -e 's/( \{1,\}/(/g' -e 's/ \{1,\})/)/g' -e 's/ \{1,\}/%20/g')
esearch_url="https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&term=${query}&usehistory=y$retmax=100000"
esearch_result=$(curl -s -g $esearch_url)
key=$(echo $esearch_result | sed -n 's/.*<QueryKey>\([0-9]*\)<\/QueryKey>.*/\1/p')
env=$(echo $esearch_result | sed -n 's/.*<WebEnv>\(.*\)<\/WebEnv>.*/\1/p')
efetch_url="https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&query_key=${key}&WebEnv=${env}&retmode=text&rettype=csv&retmax=100000"

read -r -d '' sql << EOM
with tmp as
(
  select
    *
  , last_name || ' ' || substr(first_name,1,1) || middle_initial as abbr1
  , last_name || ' ' || substr(first_name,1,1) as abbr2
  from faculty
)
select

  department
  , last_name
  , first_name
  , middle_initial
  , substr(pubmed.shortdetails, 1, instr(pubmed.shortdetails,'. ')-1) journal
  , description as authors
  , title
  , url
  , details
  , resource
  , type
  , identifiers
  , db
  , entrezuid
  , properties
from tmp
inner join pubmed
on pubmed.description like abbr1 || '%'
or pubmed.description like abbr2 || '%'
or pubmed.description like '% ' || abbr1 || '%'
or pubmed.description like '% ' || abbr2 || '%'
where substr(pubmed.shortdetails, 1, instr(pubmed.shortdetails,'. ')-1) not in
(
  select
    *
  from blacklist
)
order by department, last_name
EOM

echo Retrieving query results from PubMed...
curl -s -g $efetch_url | sed 's/,$//g' | tr [:lower:] [:upper:] > pubmed

echo Merging PubMed results to faculty list and saving results to $2...
csvsql --query "${sql}" blacklist pubmed faculty.csv > $2
rm pubmed

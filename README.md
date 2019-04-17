_Michael L. Bernauer_
_April 17, 2019_

# Faculty Publications

This script queries PubMed using a user defined query and merges the results
with department information for faculty at the University of New Mexico School
of Medicine.

```
# usage
./get_publications.sh <query_file> <output_file>
```

```
# retrieve faculty publication list for UNM SOM
./get_publications.sh query unm_faculty.csv
```

Several journals unrelated to health and medicine are listed in `blacklist` this
this list is used to exclude records that are out of scope for the school of
medicine.

The file `query` can be edited to include any valid pubmed query. Right now, it
contains a query to retrieve all indexed articles published by faculty at the
University of New Mexico from 01/01/2016 to present.

The file `faculty.csv` contains fields for author/faculty `first_name`,
`middle_initial`, `last_name` and `department`. Faculty may appear multiple
times, once for each department they are appointed.

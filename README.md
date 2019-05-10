_Michael L. Bernauer_
_April 17, 2019_

# Faculty Publications
The purpose of this script is to allow users to quickly and easily create
faculty bibliographies using PubMed.

# Requirements
`csvkit v1.0.4` which can be obtained [here](https://csvkit.readthedocs.io/en/latest/)

```
# usage
./create-bibs.sh <query_file> <output_file>
```

# Example

```
# retrieve faculty publication list for UNM SOM
./create-bibs.sh query.txt output.csv 
```

The `faculty.csv` file should contain faculty specific to your institution. At a
minimum, last names and first initials should be included. However, adding
middle initials in addition to last names and first initials will improve
specificity of the match.

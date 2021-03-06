# zn2021
CodeQL snippets for ZeroNights 2021 "Company wide SAST" presentation.
Link to program: https://zeronights.ru/en/reports-en/company-wide-sast/

### javascript-taint-fails-on-middlware
Example of javascript app when taint tracking fails on data flow through request context.  
There are also two example queries that find xss in that project.  
And also codeql library that extend all queries to taint flow through request context.
<br><img src="https://user-images.githubusercontent.com/15655261/130971190-73ab1ecc-9dbd-4897-af01-3fcc04228fa8.png" width="350">

### extend-standard-library
This is and example how to extend standard library with custom queries and libraries.  
It duplicates the structure of original repository https://github.com/github/codeql.  
The main idea of extending standard library is to create custom library and import it in `Customizations.qll`.  
To extend query suite with custom queries, add new qls file to `codeql-suites` folder.

### python-taint-fails-on-class-attr
This example shows that TypeTracking fails on tracking through class self's attribute assignments on sql.  
To workaround this drawback replace standard `codeql/python/ql/src/semmle/python/frameworks/PEP249.qll` implementation.  
Also copy custom predicate to `codeql/python/ql/src/semmle/python/SelfAttribute.qll` file.
<br>
<br><img src="https://user-images.githubusercontent.com/15655261/130983887-a525a4e6-5db0-4c57-8840-969020a7d2f7.png" width="500">


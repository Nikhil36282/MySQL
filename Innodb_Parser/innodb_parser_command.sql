

# prerequisite

sudo gem install innodb_ruby

#Installing from Source Repository
git clone https://github.com/jeremycole/innodb_ruby.git
cd innodb_ruby
ruby -r rubygems -I lib bin/innodb_space ...


#List all tablespaces available from the system, including some basic stats. This is basically a list of tables:
innodb_space -s ibdata1 system-spaces

#List all indexes available from the space (system space or file-per-table space):
innodb_space -s ibdata1 -T sakila/film space-indexes

#Iterate through all pages in a space and print a summary of page types coalesced into “regions” of same-type pages:
innodb_space -s ibdata1 -T sakila/film space-page-type-regions

#Iterate through all pages and print a summary of total counts of pages by type
innodb_space -s ibdata1 -T sakila/film space-page-type-summary

#Illustrate all pages in all extents in the space, showing a colorized block (colored by index/purpose) for each page, sized based on the amount of data in the page:
innodb_space -s ibdata1 -T sakila/film space-extents-illustrate

#Illustrate all pages in all extents in the space, showing a colorized block (colored by the age of the modification LSN for the page):
innodb_space -s ibdata1 -T sakila/payment space-lsn-age-illustrate

#Given any page number, explain what the page is used for (for most structures):
innodb_space -s ibdata1 -T sakila/film -p 3 page-account

#Intelligently dump the contents of a page including a representation of most structures that innodb_ruby understands:
innodb_space -s ibdata1 -T sakila/film -p 3 page-dump

#Summarize all records within the page:
innodb_space -s ibdata1 -T sakila/film -p 3 page-records

#Dump the contents of the page directory for a page
innodb_space -s ibdata1 -T sakila/film -p 7 page-directory-summary

#Illustrate the content of a page:
innodb_space -s ibdata1 -T sakila/film -p 7 page-illustrate

#Recurse an index (perform a full index scan) by following the entire B+Tree (scanning all pages by recursion, not just the leaf pages by list):
innodb_space -s ibdata1 -T sakila/film -I PRIMARY index-recurse

#Recurse an index as index-recurse does, but print the offset of each record within the index pages:
innodb_space -s ibdata1 -T sakila/film -I PRIMARY index-record-offsets

#Print a summary of all index pages at a given level:
innodb_space -s ibdata1 -T sakila/film -I PRIMARY -l 0 index-level-summary

#Given a record offset, dump a detailed description of a record and the data it contains:
innodb_space -s ibdata1 -T sakila/film -p 7 -R 128 record-dump

#Summarize the history (undo logs) of a record:
innodb_space -s ibdata1 -T sakila/film -p 7 -R 128 record-history

#Show a summary of the lists (free, free_frag, full_frag, free_inodes, and full_inodes) for the space, including the list length and the list node information of the first and last pages in the list:
innodb_space -s ibdata1 space-lists

#Iterate through all extents in a list and show the extents or inodes in the list:
innodb_space -s ibdata1 space-list-iterate -L free_frag

#Print summary information for each inode in the space:
innodb_space -s ibdata1 space-inodes-summary

#Print a summary of all records in the history list (undo logs):
innodb_space -s ibdata1 undo-history-summary

#Print a detailed description of an undo record and the data it contains:
innodb_space -s ibdata1 -p page -R offset undo-record-dump



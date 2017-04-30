<h1>HP Big Data Analytics: Effects of Memory Management and Parallelism on Query Performance</h1>

<h2>Group Thirteen</h2>

This repository will act as the version control system that our team will use to document changes made in our class documentation
throughout the next three terms. The development process of our toolkit will be trackable back to the initialization of the file,
we will also use the GitHub Wiki feature to keep a blog of our progress.

Any TeX files will have both the source code (.tex) and a copy of the pdf for ease of access.

Main experiments consist of:
PGA experiment: Attempt to prevent workarea spillover to disk
BT Cache: Look at temperature controlled large object cache
IMCS: In-Memory processing and compressed data store

Side Experiments:
Ramdisk: Results from pointing temporary tablespace to a segment of RAM provided as much performance increase as we saw in the PGA experiments. Clients were not really interested in this option
		 because available resources were available.
External tablespace for app reporting: Set up to read flat files produced by tkprof output when we were looking more in trace files. This was going to be used for the initial web app that we
		 were putting together.
Test automation suite: Series of shell scripts that were used to facilitate the exexution of our experiments, a resource monitoring loop was run in the background to collect data reguarding the
		 user observed and database execution run time. Command line tool that accepts the snapshot time and a series of directory names in the exp_scripts directory. 
Index experiments

	Global experiments
	* No index
	* Primary Key
	* Uniqued
	* Non-unique
	
	Local Index
	* Unique
	* Non-unique
	Evaluated for each test type
	* Prefix/Non-Prefix
	
Partition/subpartition strategies
	* Partition by date
	* Partition by date subpartition by ID
	* Partition by ID
	* Partition by ID subpartition by date
	
Insertion methods
	* Traditional
	* No duplicates hint
	* Merge
	* Merge w/ error logging
	

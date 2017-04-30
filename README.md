<h1>HP Big Data Analytics: Effects of Memory Management and Parallelism on Query Performance</h1>

<h2>Group Thirteen</h2>

This repository will act as the version control system that our team will use to document changes made in our class documentation
throughout the next three terms. The development process of our toolkit will be trackable back to the initialization of the file,
we will also use the GitHub Wiki feature to keep a blog of our progress.

Any TeX files will have both the source code (.tex) and a copy of the pdf for ease of access.

<h3>Folders to consider for grading:</h3>
<ul>
	<li>Production</li>
	<li>... Talk to Nic about organization</li>

</ul>

----------------------------------------------------------------------------------------------------------------------------------------


<h2>Main experiments:</h2>
<ul>
	<li> PGA experiment: Attempt to prevent workarea spillover to disk</li>
	<li> BT Cache: Look at temperature controlled large object cache</li>
	<li> IMCS: In-Memory processing and compressed data store</li>
</ul>

<h2>Side Experiments:</h2>
<ul>
	<li>Ramdisk: Results from pointing temporary tablespace to a segment of RAM provided as much performance increase as we saw in the PGA experiments. Clients were not really interested in this option because available resources were available.</li>
	<li>External tablespace for app reporting: Set up to read flat files produced by tkprof output when we were looking more in trace files. This was going to be used for the initial web app that we were putting together.</li>
	<li>Test automation suite: Series of shell scripts that were used to facilitate the exexution of our experiments, a resource monitoring loop was run in the background to collect data reguarding the user observed and database execution run time. Command line tool that accepts the snapshot time and a series of directory names in the exp_scripts directory</li>
</ul>

<h2>Index experiments:</h2>
<h3>Global experiments:</h3>
<ul>
	<li>No index</li>
	<li>Primary Key</li>
	<li>Uniqued</li>
	<li>Non-unique</li>
</ul>
	
<h3>Local Index:</h3>
<ul>
	<li>Unique</li>
	<li>Non-unique</li>
</ul>

<h3>Evaluated for each test type</h3>
<ul>
	<li>Prefix/Non-Prefix</li>
</ul>
	
<h2>Partition/subpartition strategies</h2>
<ul>
	<li>Partition by date</li>
	<li>Partition by date subpartition by ID</li>
	<li>Partition by ID</li>
	<li>Partition by ID subpartition by date</li>
</ul>

<h2>Insertion methods</h2>
<ul>
	<li>Traditional</li>
	<li>No duplicates hint</li>
	<li>Merge</li>
	<li>Merge w/ error logging</li>
</ul>	

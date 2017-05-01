<h1>HP Big Data Analytics: Effects of Memory Management and Parallelism on Query Performance</h1>

<h2>Group Thirteen</h2>

This repository will act as the version control system that our team will use to document changes made in our class documentation
throughout the next three terms. The development process of our toolkit will be trackable back to the initialization of the file,
we will also use the GitHub Wiki feature to keep a blog of our progress.

Any TeX files will have both the source code (.tex) and a copy of the pdf for ease of access.

<h3>Folders to consider for grading:</h3>
<ul>
	<li>Production/Test_Automation (contains test automation suite, main experiments)</li>
	<li>Production/Index_Experiment (contains index experiment, stretch goal)</li>
</ul>

----------------------------------------------------------------------------------------------------------------------------------------


<h2>Project Deliverables:</h2>
<ul>
	<li>Main Experiments:</li>
	<ul>
		<li> Program Global Area (PGA) experiment: Attempt to prevent workarea spillover to disk.</li>
		<li> Big Table Cache: Look at temperature controlled large object cache.</li>
		<li> In-Memory Column Store (IMCS): In-Memory processing and compressed columnar data store.</li>
	</ul>
	<li>Test Automation Suite: Series of shell scripts that were used to facilitate the exexution of our experiments, a resource monitoring loop was run in the background to collect data reguarding the user observed and database execution run time. Command line tool that accepts the snapshot time and a series of directory names in the exp_scripts directory</li>
</ul>

<h2>Side Experiments:</h2>
<ul>
	<li>Ramdisk: Results from pointing temporary tablespace to a segment of RAM provided as much performance increase as we saw in the PGA experiments. Clients were not really interested in this option because available resources were available.</li>
	<li>Indexing/partitioning: Testing performance of bulk inserts using a variety of table indexing and partitioning strategies to find optimal configuration for our client's use cases.</li>
	<li>External tablespace for app reporting: Set up to read flat files produced by tkprof output when we were looking more in trace files. This was going to be used for the initial web app that we were putting together.</li>
</ul>

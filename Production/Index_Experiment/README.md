This directory represents each test within our index/partitioning experiment

Files 1-4 is where Data Loader has only rows not in Data Reader:
1: partition by date
2: partition by id
3. partition by date sub by id
4. partition by id sub by date

Files 5-8 have overlapping data
5: partition by date
6: partition by id
7. partition by date sub by id
8. partition by id sub by date

---

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

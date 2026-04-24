// GRAPH DATABASE LAB - NEO4J

//start (delete everything)
MATCH (n)
DETACH DELETE n;

// ===============================
// 1. CREATE NODES & RELATIONSHIPS
// ===============================

// Create Persons
CREATE (:Person {name:'Alice', age:25});
CREATE (:Person {name:'Bob', age:30});
CREATE (:Person {name:'Charlie', age:28});

// Create Cities
CREATE (:City {name:'Kozhikode'});
CREATE (:City {name:'Delhi'});
CREATE (:City {name:'Mumbai'});

// Create relationships
MATCH (a:Person {name:'Alice'}), (c:City {name:'Kozhikode'})
CREATE (a)-[:LIVES_IN]->(c);

MATCH (b:Person {name:'Bob'}), (d:City {name:'Delhi'})
CREATE (b)-[:LIVES_IN]->(d);

MATCH (c1:Person {name:'Charlie'}), (m:City {name:'Mumbai'})
CREATE (c1)-[:LIVES_IN]->(m);

// Friend relationships
MATCH (a:Person {name:'Alice'}), (b:Person {name:'Bob'}), (c:Person {name:'Charlie'})
CREATE 
(a)-[:FRIEND]->(b),
(b)-[:FRIEND]->(c),
(c)-[:FRIEND]->(a);

// ===============================
// 2. RETRIEVE DATA
// ===============================

// All nodes
MATCH (n)
RETURN n;

// All nodes + relationships
MATCH (n)-[r]->(m)
RETURN n,r,m;

// All Persons
MATCH (p:Person)
RETURN p;

// ===============================
// 3. UPDATE
// ===============================

// Update age
MATCH (p:Person {name:'Alice'})
SET p.age = 26;

// Add new property
MATCH (p:Person)
SET p.gender = 'Female';

// ===============================
// 4. DELETE
// ===============================

// Delete relationship only
MATCH (a:Person {name:'Alice'})-[r:LIVES_IN]->(c:City)
DELETE r;

// Recreate it
MATCH (a:Person {name:'Alice'}), (c:City {name:'Kozhikode'})
CREATE (a)-[:LIVES_IN]->(c);

// ===============================
// 5. QUERY OPERATIONS
// ===============================

// Persons in Kozhikode
MATCH (p:Person)-[:LIVES_IN]->(c:City {name:'Kozhikode'})
RETURN p.name;

// All relationships
MATCH ()-[r]->()
RETURN r;

// FRIEND pattern
MATCH (p1:Person)-[:FRIEND]->(p2:Person)
RETURN p1,p2;

// Bidirectional
MATCH (a)-[r]-(b)
RETURN a,r,b;

// ===============================
// 6. TRAVERSAL
// ===============================

// 1-hop (friends)
MATCH (p:Person {name:'Alice'})-[:FRIEND]->(f)
RETURN f;

// 2-hop (friends of friends)
MATCH (p:Person {name:'Alice'})-[:FRIEND]->()-[:FRIEND]->(fof)
RETURN fof;

// Depth 3
MATCH (p:Person {name:'Alice'})-[*1..3]->(n)
RETURN n;

// Limit depth 2
MATCH (p:Person {name:'Alice'})-[*1..2]->(n)
RETURN n;

// ===============================
// 7. PATH QUERIES
// ===============================

// Shortest path
MATCH p = shortestPath(
 (a:Person {name:'Alice'})-[*]-(b:Person {name:'Charlie'})
)
RETURN p;

// All paths
MATCH p = (a:Person {name:'Alice'})-[*]-(b:Person {name:'Charlie'})
RETURN p;

// Paths length <= 3
MATCH p = (a:Person {name:'Alice'})-[*..3]-(b:Person {name:'Charlie'})
RETURN p;


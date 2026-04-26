// GRAPH DB COMPLETE LAB (1–28)

// CLEAN START
MATCH (n) DETACH DELETE n;

// ======================================
// 1. BASIC GRAPH CREATION
CREATE (:Person {name:'Alice', age:25}),
       (:Person {name:'Bob', age:30}),
       (:Person {name:'Charlie', age:28}),
       (:City {name:'Kochi'}),
       (:City {name:'Delhi'}),
       (:City {name:'Mumbai'});

MATCH (a:Person {name:'Alice'}), (c:City {name:'Kochi'})
CREATE (a)-[:LIVES_IN]->(c);

MATCH (b:Person {name:'Bob'}), (d:City {name:'Delhi'})
CREATE (b)-[:LIVES_IN]->(d);

MATCH (c1:Person {name:'Charlie'}), (m:City {name:'Mumbai'})
CREATE (c1)-[:LIVES_IN]->(m);

// ======================================
// 2. RETRIEVE ALL
MATCH (n) RETURN n;

// ======================================
// 3. PERSON NODES
MATCH (p:Person) RETURN p;

// ======================================
// 4. UPDATE
MATCH (p:Person {name:'Alice'})
SET p.age = 26;


// ======================================
// 5. DELETE
MATCH (p:Person {name:'Charlie'})
DETACH DELETE p;


// ======================================
// 6. ADD PROPERTY
MATCH (p:Person)
SET p.gender = 'Female';


// ======================================
// 7. PERSONS IN CITY
MATCH (p:Person)-[:LIVES_IN]->(c:City {name:'Kochi'})
RETURN p;


// ======================================
// 8. ALL RELATIONSHIPS
MATCH ()-[r]->() RETURN r;


// ======================================
// 9–10. FRIEND RELATION
MATCH (a:Person {name:'Alice'}), (b:Person {name:'Bob'})
CREATE (a)-[:FRIEND]->(b);

MATCH (p1:Person)-[:FRIEND]->(p2:Person)
RETURN p1,p2;


// ======================================
// 11. BIDIRECTIONAL
MATCH (a)-[r]-(b)
RETURN a,r,b;


// ======================================
// 12. 1-HOP
MATCH (p:Person {name:'Alice'})-[:FRIEND]->(f)
RETURN f;


// ======================================
// 13. 2-HOP
MATCH (b:Person {name:'Bob'}), (a:Person {name:'Alice'})
CREATE (b)-[:FRIEND]->(a);

MATCH (p:Person {name:'Alice'})-[:FRIEND]->()-[:FRIEND]->(fof)
RETURN fof;


// ======================================
// 14–15. TRAVERSAL
MATCH (p:Person {name:'Alice'})-[*1..3]->(n)
RETURN n;

MATCH (p:Person {name:'Alice'})-[*1..2]->(n)
RETURN n;


// ======================================
// 16. SIMPLE PATH (NO REPEAT)
MATCH p = (a:Person {name:'Alice'})-[*]->(b)
WHERE ALL(n IN nodes(p) WHERE single(x IN nodes(p) WHERE x = n))
RETURN p;


// ======================================
// 17. AGE FILTER
MATCH (p:Person)
WHERE p.age > 25
RETURN p;


// ======================================
// 18. WHERE RELATION
MATCH (p:Person)-[:LIVES_IN]->(c:City)
WHERE c.name = 'Kochi'
RETURN p,c;


// ======================================
// 19. PROPERTY MATCH
MATCH (p:Person {name:'Alice'})
RETURN p;


// ======================================
// 20. IN + AND
MATCH (p:Person)
WHERE p.name IN ['Alice','Bob'] AND p.age > 20
RETURN p;


// ======================================
// 21. COUNT FRIENDS
MATCH (p:Person)-[:FRIEND]->(f)
RETURN p.name, COUNT(f);


// ======================================
// 22. MAX CONNECTION
MATCH (n)-[r]-()
RETURN n, COUNT(r) AS connections
ORDER BY connections DESC LIMIT 1;


// ======================================
// 23. AVG AGE
MATCH (p:Person)
RETURN AVG(p.age);


// ======================================
// 24. GROUP BY CITY
MATCH (p:Person)-[:LIVES_IN]->(c:City)
RETURN c.name, COUNT(p);


// ======================================
// 25. HIGHEST DEGREE
MATCH (n)-[r]-()
RETURN n, COUNT(r) AS degree
ORDER BY degree DESC LIMIT 1;


// ======================================
// 26. CYCLE DETECTION
MATCH p = (n)-[*]->(n)
RETURN p;


// ======================================
// 27. SCC (SAFE VERSION)
// OPTIONAL: ONLY IF GDS AVAILABLE
CALL gds.graph.project(
  'graph',
  'Person',
  {FRIEND: {type:'FRIEND', orientation:'UNDIRECTED'}}
);

CALL gds.scc.stream('graph')
YIELD nodeId, componentId
RETURN gds.util.asNode(nodeId).name, componentId;


// ======================================
// 28. CENTRAL NODES
MATCH (n)-[r]-()
RETURN n, COUNT(r) AS degree
ORDER BY degree DESC;


// ======================================
MATCH (n)-[r]->(m)
RETURN n,r,m;

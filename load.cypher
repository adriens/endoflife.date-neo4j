// Load all products
CALL apoc.load.json("https://endoflife.date/api/all.json")
YIELD value
UNWIND value.result AS product
MERGE (p:EOLProduct {name: product, url: 'https://endoflife.date/' + product});

// create unique index
CREATE CONSTRAINT EOL_UNIQUE_PRODUCTS ON (p:EOLProduct) ASSERT p.product IS UNIQUE;

MATCH (p:EOLProduct) RETURN p;

// load cycles https://github.com/endoflife-date/endoflife.date/issues/2079
MATCH (p:EOLProduct) 
    CALL apoc.load.json('https://endoflife.date/api/' + p.name + '.json')
    YIELD value
    MERGE (c:EOLCycle {product: p.name,
                    cycle: value.cycle,
                    //eol: value.eol,
                    //support: value.support,
                    //latest: value.latest,
                    //latestReleaseDate: value.latestReleaseDate,
                    //releaseDate: value.releaseDate,
                    lts: value.lts//, link: value.link
                    }
            );


// link cycles with products
MATCH
  (c:EOLCycle),
  (p:EOLProduct)
WHERE c.product = p.name
CREATE (c)-[r:EOL_CYCLE_OF]->(p)
RETURN type(r);

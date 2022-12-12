// purge
// TODO

###########################################################


// Load all products
CALL apoc.load.json("https://endoflife.date/api/all.json")
YIELD value
UNWIND value.result AS product
MERGE (p:Product {name: product, url: 'https://endoflife.date/' + product});

MATCH (p:Product) RETURN p;

// load cycles
MATCH (p:Product) 
    CALL apoc.load.json('https://endoflife.date/api/' + p.name + '.json')
    YIELD value
    MERGE (c:Cycle {product: p.name,
                    cycle: value.cycle,
                    eol: value.eol,
                    support: value.support,
                    latest: value.latest,
                    latestReleaseDate: value.latestReleaseDate,
                    releaseDate: value.releaseDate,
                    lts: value.lts,
                    link: value.link
                    }
            );


// link cycles with products
MATCH
  (c:Cycle),
  (p:Product)
WHERE c.product = p.name
CREATE (c)-[r:CYCLE_OF]->(p)
RETURN type(r);



// link editors
//Amazon% # https://github.com/endoflife-date/endoflife.date/pull/2010
//Apache%
//Google%
//Microsoft%
//vmware%
//Linux

// API enhacement
//category
//product url

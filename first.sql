SELECT categories.categoryid AS CategoryID, categories.categoryname AS Category, Count(notregained.nodeid) AS ErrorNodes

FROM categories INNER JOIN (category_node INNER JOIN notregained ON category_node.node_id = notregained.nodeid) ON categories.categoryid = category_node.category_id

GROUP BY categories.categoryid, categories.categoryname;

SELECT node.nodeid, node.nodelabel

FROM node RIGHT JOIN outages ON node.nodeid = outages.nodeid

WHERE (((outages.svregainedeventid) Is Null) AND ((outages.serviceid)=1) AND ((node.nodetype)="A"));

SELECT categories.categoryid AS CategoryID, categories.categoryname AS CategoryName, Count(category_node.node_id) AS TotalNodes

FROM categories LEFT JOIN category_node ON categories.categoryid = category_node.category_id

GROUP BY categories.categoryid, categories.categoryname;

SELECT totalnodes.CategoryID, totalnodes.CategoryName, errornodes.ErrorNodes, totalnodes.TotalNodes

FROM totalnodes LEFT JOIN errornodes ON totalnodes.CategoryID = errornodes.CategoryID;

SELECT totalnodes.CategoryID, totalnodes.CategoryName, errornodes.ErrorNodes, totalnodes.TotalNodes

FROM

(SELECT categories.categoryid AS CategoryID, categories.categoryname AS CategoryName, Count(category_node.node_id) AS TotalNodes FROM categories LEFT JOIN category_node ON categories.categoryid=category_node.category_id GROUP BY categories.categoryid, categories.categoryname) AS totalnodes

LEFT JOIN

(SELECT categories.categoryid AS CategoryID, categories.categoryname AS Category, Count(notregained.nodeid) AS ErrorNodes

FROM categories INNER JOIN (category_node INNER JOIN (SELECT node.nodeid, node.nodelabel FROM node RIGHT JOIN outages ON node.nodeid=outages.nodeid WHERE (((outages.svregainedeventid) Is Null) AND ((node.nodetype)="A") AND ((outages.serviceid)=1))) AS notregained

ON category_node.node_id=notregained.nodeid) ON categories.categoryid=category_node.category_id GROUP BY categories.categoryid, categories.categoryname) AS errornodes ON totalnodes.CategoryID = errornodes.CategoryID

WHERE (((totalnodes.CategoryName)<>"Development")) AND (((totalnodes.CategoryName)<>"Production")) AND (((totalnodes.CategoryName)<>"Test"));

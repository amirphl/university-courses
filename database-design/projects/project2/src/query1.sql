use store;
SELECT DISTINCT *
FROM (
       SELECT *
       FROM h1
       UNION SELECT *
             FROM h2
       UNION SELECT *
             FROM h3
       UNION SELECT *
             FROM h4
       UNION SELECT *
             FROM h5
     ) AS h


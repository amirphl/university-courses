USE store;
SELECT
  id,
  average
FROM transmitteraverageall
WHERE average >= ALL (SELECT R.average
                      FROM transmitteraverageall AS R) 
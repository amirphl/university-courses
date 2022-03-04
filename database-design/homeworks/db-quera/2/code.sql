select DISTINCT year
from Movie NATIONAL JOIN Rating
where stars = 4 or stars = 5
ORDER BY year ASC

select title,max(stars)
from Movie NATURAL JOIN Rating
GROUP BY title
ORDER BY title

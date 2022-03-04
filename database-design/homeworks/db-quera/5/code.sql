select name,title,stars,ratingDate
from Movie NATURAL JOIN Reviewer NATURAL JOIN Rating
ORDER BY name,title,stars

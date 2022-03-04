select name,title
from Movie
INNER JOIN Rating R1 USING(mID)
INNER JOIN Rating R2 USING(mID,rID)
INNER JOIN Reviewer USING(rID)
WHERE R1.ratingDate < R2.ratingDate and R1.stars < R2.stars

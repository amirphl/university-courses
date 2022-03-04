select name
from Reviewer NATURAL JOIN Rating
where ratingDate is null

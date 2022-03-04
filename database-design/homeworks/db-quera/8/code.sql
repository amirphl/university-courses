select title,(maxRate - minRate) as 'rating spread'
from (select title , max(stars) as maxRate
      from Movie NATURAL JOIN Rating
      GROUP BY title
      ) as T
      NATURAL JOIN
     (select title , min(stars) as minRate
      from Movie NATURAL JOIN Rating
      GROUP BY title
      ) as R
ORDER BY 'rating spread' DESC, title ASC

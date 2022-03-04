delete FROM Student
where sID in (select sID
              from (select * from Student) as S
              where 2 < ( select count(DISTINCT major) from Apply as A where S.sID = A.sID ) )

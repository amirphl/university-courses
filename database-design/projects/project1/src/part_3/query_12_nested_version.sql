with t1 as (select
              ProductID,
              sum(Amount) as total
            from OrderProduct
            group by ProductID)

with r1(FirstProductID, SecondProductID, total) as (select
                                                      s1.ProductID,
                                                      s2.ProductID,
                                                      (s1.total + s2.total) as total
                                                    from t1 as s1, t1 as s2
                                                    where s1.ProductID != s2.ProductID
                                                    group by (s1.ProductID, s2.ProductID)
)

select *
from r1
where total >= all (select total
                    from r1)
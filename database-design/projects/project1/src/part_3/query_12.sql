select *
from (select
        s1.ProductID          as FirstProductID,
        s2.ProductID          as SecondProductID,
        (s1.total + s2.total) as total
      from (select
              ProductID,
              sum(Amount) as total
            from OrderProduct
            group by ProductID) as s1, (select
                                          ProductID,
                                          sum(Amount) as total
                                        from OrderProduct
                                        group by ProductID) as s2
      where s1.ProductID != s2.ProductID
      group by s1.ProductID, s2.ProductID
     ) as poi1
where total >= all (select total
                    from (select
                            s1.ProductID          as FirstProductID,
                            s2.ProductID          as SecondProductID,
                            (s1.total + s2.total) as total
                          from (select
                                  ProductID,
                                  sum(Amount) as total
                                from OrderProduct
                                group by ProductID) as s1, (select
                                                              ProductID,
                                                              sum(Amount) as total
                                                            from OrderProduct
                                                            group by ProductID) as s2
                          where s1.ProductID != s2.ProductID
                          group by s1.ProductID, s2.ProductID
                         ) as poi2)
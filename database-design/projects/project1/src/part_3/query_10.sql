select *
from (select *
      from (select *
            from (
                   select
                     ProductID,
                     sum(Amount) as total_amount
                   from Vendor, Orders, OrderProduct
                   where VendorID = Vendor.ID and OrderID = Orders.ID and
                         Title = 'laborum'
                   group by ProductID) as a
            where total_amount < some (select total_amount
                                       from (
                                              select
                                                ProductID,
                                                sum(Amount) as total_amount
                                              from Vendor, Orders, OrderProduct
                                              where
                                                VendorID = Vendor.ID and OrderID = Orders.ID and
                                                Title = 'laborum'
                                              group by ProductID) as a2)
           ) as a3
      where total_amount < some (select total_amount
                                 from (select *
                                       from (
                                              select
                                                ProductID,
                                                sum(Amount) as total_amount
                                              from Vendor, Orders, OrderProduct
                                              where
                                                VendorID = Vendor.ID and OrderID = Orders.ID and
                                                Title = 'laborum'
                                              group by ProductID) as a
                                       where total_amount < some (select total_amount
                                                                  from (
                                                                         select
                                                                           ProductID,
                                                                           sum(Amount) as total_amount
                                                                         from Vendor, Orders, OrderProduct
                                                                         where VendorID = Vendor.ID and
                                                                               OrderID = Orders.ID and
                                                                               Title =
                                                                               'laborum'
                                                                         group by ProductID) as a2)
                                      ) as a4)
     ) as a32, Product
where total_amount >= all (select total_amount
                           from (select *
                                 from (select *
                                       from (
                                              select
                                                ProductID,
                                                sum(Amount) as total_amount
                                              from Vendor, Orders, OrderProduct
                                              where VendorID = Vendor.ID and OrderID = Orders.ID and
                                                    Title = 'laborum'
                                              group by ProductID) as a
                                       where total_amount < some (select total_amount
                                                                  from (
                                                                         select
                                                                           ProductID,
                                                                           sum(Amount) as total_amount
                                                                         from Vendor, Orders, OrderProduct
                                                                         where
                                                                           VendorID = Vendor.ID and OrderID = Orders.ID
                                                                           and Title =
                                                                               'laborum'
                                                                         group by ProductID) as a2)
                                      ) as a3
                                 where total_amount < some (select total_amount
                                                            from (select *
                                                                  from (
                                                                         select
                                                                           ProductID,
                                                                           sum(Amount) as total_amount
                                                                         from Vendor, Orders, OrderProduct
                                                                         where
                                                                           VendorID = Vendor.ID and OrderID = Orders.ID
                                                                           and Title =
                                                                               'laborum'
                                                                         group by ProductID) as a
                                                                  where total_amount < some (select total_amount
                                                                                             from (
                                                                                                    select
                                                                                                      ProductID,
                                                                                                      sum(
                                                                                                          Amount) as total_amount
                                                                                                    from Vendor, Orders,
                                                                                                      OrderProduct
                                                                                                    where VendorID =
                                                                                                          Vendor.ID and
                                                                                                          OrderID =
                                                                                                          Orders.ID and
                                                                                                          Title =
                                                                                                          'laborum'
                                                                                                    group by
                                                                                                      ProductID) as a2)
                                                                 ) as a4)
                                ) as a33)
select *
from Customer, Orders
where CustomerID = Customer.ID
      and CreatedAt > date_sub(now(), interval 1 month)
      and CustomerID not in (select CustomerID
                             from Customer, Orders
                             where CustomerID = Customer.ID
                                   and CreatedAt < date_sub(now(), interval 1 month))
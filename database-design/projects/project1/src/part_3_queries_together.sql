select *
from Vendor
where City = 'Lake Dereck';

select
  C.ID,
  C.Email,
  C.Password,
  C.FirstName,
  C.LastName,
  C.Sex,
  C.Credit,
  C.CallPhone,
  C.Address
from Customer as C, Orders as O
where C.ID = O.CustomerID and PaymentType = 'DameDar';

select
  ID,
  count(distinct ProductID) as number_of_products
from Vendor as V, VendorProduct as P
where VendorID = ID
group by ID
having number_of_products > 3;

select
  T.ID,
  T.number_of_delivered,
  Product.ID,
  Product.Title,
  Product.Price
from
  (select
     V.ID,
     sum(Amount) as number_of_delivered
   from Vendor as V, Orders as T, OrderProduct as S
   where T.VendorID = V.ID and S.OrderID = T.ID
   group by V.ID
   having sum(Amount) > 10
  ) as T, Orders, OrderProduct, Product
where T.ID = Orders.VendorID and OrderProduct.OrderID = Orders.ID
      and OrderProduct.ProductID = Product.ID;

select
  C.*,
  mC.*,
  P.ProductID
from Customer as C, Orders as O, OrderProduct as P, Customer as mC, Orders as mO, OrderProduct as mP
where C.ID = O.CustomerID and O.ID = P.OrderID and
      mC.ID = mO.CustomerID and mO.ID = mP.OrderID and
      P.ProductID = mP.ProductID and
      C.ID != mC.ID;

select Customer.*
from Customer, Orders
where CustomerID = Customer.ID and Address = DeliveryAddress;

select
  ProductID,
  count(distinct CustomerID) as clients
from Customer, Orders, OrderProduct
where Customer.ID = CustomerID and Orders.ID = OrderID
group by ProductID
having clients > 10;


select
  Customer.*,
  count(distinct VendorID) as froushgah
from Customer, Orders, Vendor
where Customer.ID = CustomerID and Vendor.ID = VendorID
      and CreatedAt < date_sub(now(), interval 1 month)
group by Customer.ID
having froushgah > 1;


select
  VendorID,
  avg(sabadKharid)
from (
       select
         CustomerID,
         VendorID,
         sum(Amount * Price) as sabadKharid
       from Customer, Orders, Vendor, OrderProduct, Product
       where CustomerID = Customer.ID and VendorID = Vendor.ID and OrderID = Orders.ID and ProductID = Product.ID
       group by CustomerID, VendorID
     ) as K
group by VendorID
having avg(sabadKharid) > 100000;





select *
from (select *
      from (select *
            from (
                   select
                     ProductID,
                     sum(Amount) as total_amount
                   from Vendor, Orders, OrderProduct
                   where VendorID = Vendor.ID and OrderID = Orders.ID and
                         Title = 'Repellendus odio maiores temporibus cupiditate arc'
                   group by ProductID) as a
            where total_amount < some (select total_amount
                                       from (
                                              select
                                                ProductID,
                                                sum(Amount) as total_amount
                                              from Vendor, Orders, OrderProduct
                                              where
                                                VendorID = Vendor.ID and OrderID = Orders.ID and
                                                Title = 'Repellendus odio maiores temporibus cupiditate arc'
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
                                                Title = 'Repellendus odio maiores temporibus cupiditate arc'
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
                                                                               'Repellendus odio maiores temporibus cupiditate arc'
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
                                                    Title = 'Repellendus odio maiores temporibus cupiditate arc'
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
                                                                               'Repellendus odio maiores temporibus cupiditate arc'
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
                                                                               'Repellendus odio maiores temporibus cupiditate arc'
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
                                                                                                          'Repellendus odio maiores temporibus cupiditate arc'
                                                                                                    group by
                                                                                                      ProductID) as a2)
                                                                 ) as a4)
                                ) as a33);








select *
from Customer, Orders
where CustomerID = Customer.ID
      and CreatedAt > date_sub(now(), interval 1 month)
      and CustomerID not in (select CustomerID
                             from Customer, Orders
                             where CustomerID = Customer.ID
                                   and CreatedAt < date_sub(now(), interval 1 month));






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
                         ) as poi2);




with t1 as (select
              ProductID,
              sum(Amount) as total
            from OrderProduct
            group by ProductID);

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
                    from r1);
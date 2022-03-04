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
      and OrderProduct.ProductID = Product.ID
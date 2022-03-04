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
having avg(sabadKharid) > 200
select
  VendorID,
  count(distinct ProductID) as number_of_products
from VendorProduct as P
group by VendorID
having number_of_products > 9
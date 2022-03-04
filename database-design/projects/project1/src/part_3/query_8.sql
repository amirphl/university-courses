select
  Customer.*,
  count(distinct VendorID) as froushgah
from Customer, Orders, Vendor
where Customer.ID = CustomerID and Vendor.ID = VendorID
      and CreatedAt < date_sub(now(), interval 1 month)
group by Customer.ID
having froushgah > 1
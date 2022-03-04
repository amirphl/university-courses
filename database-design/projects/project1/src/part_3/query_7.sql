select
  ProductID,
  count(distinct CustomerID) as clients
from Customer, Orders, OrderProduct
where Customer.ID = CustomerID and Orders.ID = OrderID
group by ProductID
having clients > 3
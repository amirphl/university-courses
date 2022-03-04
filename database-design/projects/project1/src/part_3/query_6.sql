select Customer.*
from Customer, Orders
where CustomerID = Customer.ID and Address = DeliveryAddress
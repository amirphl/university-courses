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
where C.ID = O.CustomerID and PaymentType = 'CreditPayment'
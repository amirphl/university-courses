select
  C.*,
  mC.*,
  P.ProductID
from Customer as C, Orders as O, OrderProduct as P, Customer as mC, Orders as mO, OrderProduct as mP
where C.ID = O.CustomerID and O.ID = P.OrderID and
      mC.ID = mO.CustomerID and mO.ID = mP.OrderID and
      P.ProductID = mP.ProductID and
      C.ID != mC.ID
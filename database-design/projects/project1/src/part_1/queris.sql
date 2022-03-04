create table Customer (
  ID        INT(15)      NOT NULL auto_increment,
  Email     VARCHAR(100) NOT NULL,
  Password  INT(15)      NOT NULL,
  FirstName VARCHAR(50)  NOT NULL,
  LastName  VARCHAR(50)  NOT NULL,
  Sex       ENUM('Male' , 'Female'),
  Credit    INT(15)      NOT NULL,
  CallPhone CHAR(10)     NOT NULL,
  Address   VARCHAR(100) NOT NULL,
  PRIMARY KEY (id)
);

create table Manager (
  ID        INT(15)      NOT NULL auto_increment,
  Email     VARCHAR(100) NOT NULL,
  Password  INT(15)      NOT NULL,
  FirstName VARCHAR(50)  NOT NULL,
  LastName  VARCHAR(50)  NOT NULL,
  Sex       ENUM('Male' , 'Female'),
  CallPhone CHAR(10)     NOT NULL,
  Address   VARCHAR(100) NOT NULL,
  PRIMARY KEY (ID)
);

create table Product (
  ID    INT(15)     NOT NULL auto_increment,
  Title VARCHAR(50) NOT NULL,
  Price INT(20)     NOT NULL,
  PRIMARY KEY (ID)
);

create table Vendor (
  ID        INT(15)      NOT NULL auto_increment,
  Title     VARCHAR(50)  NOT NULL,
  City      VARCHAR(50)  NOT NULL,
  ManagerID INT(15)      NOT NULL,
  Phone     CHAR(10)     NOT NULL,
  Address   VARCHAR(100) NOT NULL,
  PRIMARY KEY (ID, ManagerID),
  FOREIGN KEY (ManagerID) REFERENCES Manager (ID)
);

create table Orders (
  ID              INT(15)                         NOT NULL auto_increment,
  VendorID        INT(15)                         NOT NULL,
  CustomerID      INT(15)                         NOT NULL,
  Status          ENUM ('Registered', 'Sending', 'Delivered') NOT NULL,
  PaymentType     ENUM ('CreditPayment', 'OnlinePayment')        NOT NULL,
  CreatedAt       TIMESTAMP                       NOT NULL,
  DeliveryAddress VARCHAR(100)                    NOT NULL,
  PRIMARY KEY (ID, VendorID, CustomerID),
  FOREIGN KEY (VendorID) REFERENCES Vendor (ID),
  FOREIGN KEY (CustomerID) REFERENCES Customer (ID)
);


create table VendorProduct (
  VendorID  INT(15) NOT NULL,
  ProductID INT(15) NOT NULL,
  Amount    INT(10) NOT NULL,
  PRIMARY KEY (ProductID, VendorID),
  FOREIGN KEY (ProductID) REFERENCES Product (ID),
  FOREIGN KEY (VendorID) REFERENCES Vendor (ID)
);

create table OrderProduct (
  OrderID   INT(15) NOT NULL,
  ProductID INT(15) NOT NULL,
  Amount    INT(10) NOT NULL,
  PRIMARY KEY (ProductID, OrderID),
  FOREIGN KEY (ProductID) REFERENCES Product (ID),
  FOREIGN KEY (OrderID) REFERENCES Orders (ID)
);
USE store;
CREATE TABLE Customers (
  username    VARCHAR(100) PRIMARY KEY,
  password    VARCHAR(512),
  email       VARCHAR(150) NOT NULL,
  first_name  VARCHAR(100),
  last_name   VARCHAR(100),
  postal_code CHAR(10)     NOT NULL,
  gender      ENUM ('man', 'woman'),
  credit      INT UNSIGNED NOT NULL DEFAULT 0
);

CREATE TABLE TemporaryCustomers (
  email        VARCHAR(150) PRIMARY KEY,
  first_name   VARCHAR(100),
  last_name    VARCHAR(100),
  postal_code  CHAR(10)     NOT NULL,
  gender       ENUM ('man', 'woman') DEFAULT 'man',
  address      VARCHAR(200) NOT NULL,
  phone_number VARCHAR(14)  NOT NULL
);


CREATE TABLE CustomerAddresses (
  address          VARCHAR(200),
  CustomerUsername VARCHAR(100),
  PRIMARY KEY (address, CustomerUsername),
  FOREIGN KEY (CustomerUsername) REFERENCES Customers (username)
    ON DELETE CASCADE
);

CREATE TABLE CustomerPhoneNumbers (
  phone_number     VARCHAR(14),
  CustomerUsername VARCHAR(100),
  PRIMARY KEY (phone_number, CustomerUsername),
  FOREIGN KEY (CustomerUsername) REFERENCES Customers (username)
    ON DELETE CASCADE
);

CREATE TABLE Shop (
  id           INT UNSIGNED PRIMARY KEY,
  title        VARCHAR(100) NOT NULL,
  city         VARCHAR(100),
  address      VARCHAR(200) NOT NULL,
  phone_number VARCHAR(14)  NOT NULL,
  owner        VARCHAR(100),
  start_time   TIME         NOT NULL,
  end_time     TIME         NOT NULL
);

CREATE TABLE Product (
  id     INT UNSIGNED,
  shopId INT UNSIGNED,
  title  VARCHAR(100)               NOT NULL,
  price  INTEGER UNSIGNED           NOT NULL,
  value  INTEGER UNSIGNED DEFAULT 1 NOT NULL,
  offer  FLOAT UNSIGNED DEFAULT 0,
  PRIMARY KEY (id, shopId),
  FOREIGN KEY (shopId) REFERENCES Shop (id)
    ON DELETE CASCADE
);

CREATE TABLE CustomerOrders (
  purchase_time    TIMESTAMP DEFAULT current_timestamp,
  customerUsername VARCHAR(100),
  shopId           INT UNSIGNED,
  productId        INT UNSIGNED,
  value            INTEGER UNSIGNED DEFAULT 1                                                                  NOT NULL,
  status           ENUM ('accepted', 'rejected', 'sending', 'done') DEFAULT 'accepted'                         NOT NULL,
  payment_type     ENUM ('online', 'offline') DEFAULT 'online'                                                 NOT NULL,
  address          VARCHAR(200)                                                                                NOT NULL,
  phone_number     VARCHAR(14)                                                                                 NOT NULL,
  PRIMARY KEY (purchase_time, customerUsername, shopId, productId),
  FOREIGN KEY (customerUsername) REFERENCES Customers (username),
  FOREIGN KEY (shopId) REFERENCES Shop (id),
  FOREIGN KEY (productId, shopId) REFERENCES Product (id, shopId),
  FOREIGN KEY (customerUsername, address) REFERENCES CustomerAddresses (customerUsername, address),
  FOREIGN KEY (customerUsername, phone_number) REFERENCES CustomerPhoneNumbers (customerUsername, phone_number)
);

CREATE TABLE TemporaryCustomerOrders (
  purchase_time TIMESTAMP DEFAULT current_timestamp,
  customerEmail VARCHAR(150),
  shopId        INT UNSIGNED,
  productId     INT UNSIGNED,
  value         INTEGER UNSIGNED DEFAULT 1                                           NOT NULL,
  status        ENUM ('accepted', 'rejected', 'sending', 'done') DEFAULT 'accepted'  NOT NULL,
  PRIMARY KEY (purchase_time, customerEmail, shopId, productId),
  FOREIGN KEY (customerEmail) REFERENCES TemporaryCustomers (email),
  FOREIGN KEY (shopId) REFERENCES Shop (id),
  FOREIGN KEY (productId, shopId) REFERENCES Product (id, shopId)
);

CREATE TABLE Supporter (
  id           INT UNSIGNED,
  shopId       INT UNSIGNED,
  first_name   VARCHAR(100),
  last_name    VARCHAR(100),
  address      VARCHAR(200) NOT NULL,
  phone_number VARCHAR(14)  NOT NULL,
  PRIMARY KEY (id, shopId),
  FOREIGN KEY (shopId) REFERENCES Shop (id)
);

CREATE TABLE Operators (
  id         INT UNSIGNED,
  shopId     INT UNSIGNED,
  first_name VARCHAR(100),
  last_name  VARCHAR(100),
  PRIMARY KEY (id, shopId),
  FOREIGN KEY (shopId) REFERENCES Shop (id)
);

CREATE TABLE Transmitters (
  id           INT UNSIGNED,
  shopId       INT UNSIGNED,
  first_name   VARCHAR(100),
  last_name    VARCHAR(100),
  phone_number VARCHAR(14)                                NOT NULL,
  status       ENUM ('free', 'sending') DEFAULT 'sending' NOT NULL,
  credit       INTEGER UNSIGNED DEFAULT 0                 NOT NULL,
  PRIMARY KEY (id, shopId),
  FOREIGN KEY (shopId) REFERENCES Shop (id)
);

CREATE TABLE Shipment (
  transmitterId    INT UNSIGNED,
  purchase_time    TIMESTAMP,
  customerUsername VARCHAR(100),
  shopId           INT UNSIGNED,
  productId        INT UNSIGNED,
  PRIMARY KEY (purchase_time, customerUsername, shopId, productId),
  FOREIGN KEY (transmitterId, shopId) REFERENCES Transmitters (id, shopId),
  FOREIGN KEY (purchase_time, customerUsername, shopId, productId) REFERENCES CustomerOrders (purchase_time, customerUsername, shopId, productId)
);

CREATE TABLE TemporaryShipment (
  transmitterId INT UNSIGNED,
  purchase_time TIMESTAMP,
  customerEmail VARCHAR(150),
  shopId        INT UNSIGNED,
  productId     INT UNSIGNED,
  PRIMARY KEY (purchase_time, customerEmail, shopId, productId),
  FOREIGN KEY (transmitterId, shopId) REFERENCES Transmitters (id, shopId),
  FOREIGN KEY (purchase_time, customerEmail, shopId, productId) REFERENCES TemporaryCustomerOrders (purchase_time, customerEmail, shopId, productId)
);

#------------- log tables

CREATE TABLE UpdateCustomerLog (
  username     VARCHAR(100),
  pre_password VARCHAR(512),
  new_password VARCHAR(512),
  pre_email    VARCHAR(150) NOT NULL,
  new_email    VARCHAR(150) NOT NULL,
  pre_credit   INT UNSIGNED NOT NULL,
  new_credit   INT UNSIGNED NOT NULL,
  update_time  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (username, update_time),
  FOREIGN KEY (username) REFERENCES Customers (username)
);

CREATE TABLE UpdateTransmitterLog (
  transmitterId INT UNSIGNED,
  dat           TIMESTAMP DEFAULT current_timestamp,
  pre_status    ENUM ('free', 'sending') NOT NULL,
  new_status    ENUM ('free', 'sending') NOT NULL,
  PRIMARY KEY (transmitterId, dat),
  FOREIGN KEY (transmitterId) REFERENCES Transmitters (id)
);

CREATE TABLE UpdateCustomerOrderLog (
  purchase_time    TIMESTAMP,
  customerUsername VARCHAR(100),
  shopId           INT UNSIGNED,
  productId        INT UNSIGNED,
  dat              TIMESTAMP DEFAULT current_timestamp,
  pre_status       ENUM ('accepted', 'rejected', 'sending', 'done'),
  new_status       ENUM ('accepted', 'rejected', 'sending', 'done'),
  PRIMARY KEY (purchase_time, customerUsername, shopId, productId, dat),
  FOREIGN KEY (purchase_time, customerUsername, shopId, productId) REFERENCES CustomerOrders (purchase_time, customerUsername, shopId, productId)
);

CREATE TABLE UpdateTemporaryCustomerOrderLog (
  purchase_time TIMESTAMP,
  customerEmail VARCHAR(150),
  shopId        INT UNSIGNED,
  productId     INT UNSIGNED,
  dat           TIMESTAMP DEFAULT current_timestamp,
  pre_status    ENUM ('accepted', 'rejected', 'sending', 'done'),
  new_status    ENUM ('accepted', 'rejected', 'sending', 'done'),
  PRIMARY KEY (purchase_time, customerEmail, shopId, productId, dat),
  FOREIGN KEY (purchase_time, customerEmail, shopId, productId) REFERENCES TemporaryCustomerOrders (purchase_time, customerEmail, shopId, productId)
);

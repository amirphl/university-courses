USE store;
CREATE PROCEDURE add_customer(IN us VARCHAR(100), #username
                              IN pa VARCHAR(30), #password
                              IN em VARCHAR(150), #email
                              IN fi VARCHAR(100), #first_name
                              IN la VARCHAR(100), #last_name
                              IN po CHAR(10), #postal_code
                              IN ge ENUM ('man', 'woman'), #gender
                              IN cr INT UNSIGNED # credit
)
  BEGIN
    INSERT INTO customers (username, password, email, first_name, last_name, postal_code, gender, credit)
    VALUES (us, sha1(pa), em, fi, la, po, ge, cr);
  END;

CREATE PROCEDURE update_customer(IN us VARCHAR(100), #username
                                 IN pa VARCHAR(30), #password
                                 IN em VARCHAR(150), #email
                                 IN fi VARCHAR(100), #first_name
                                 IN la VARCHAR(100), #last_name
                                 IN po CHAR(10), #postal_code
                                 IN ge ENUM ('man', 'woman')#gender
)
  BEGIN
    UPDATE customers
    SET password = sha1(pa), email = em, first_name = fi, last_name = la, postal_code = po, gender = ge
    WHERE username = us;
  END;

# This is an example of a bullshit query, remember, never use session variable, instead, use procedure variable(local variable)
# www.stackoverflow.com/questions/1009954/mysql-variable-vs-variable-whats-the-difference
CREATE PROCEDURE add_order_by_customer(IN cu VARCHAR(100), # customerUsername
                                       IN sh INT UNSIGNED, # shopId
                                       IN pr INT UNSIGNED, # productId
                                       IN va INTEGER, # value
                                       IN pa ENUM ('online', 'offline'), # payment_type
                                       IN ad VARCHAR(200), # address
                                       IN ph VARCHAR(14) # phone_number
)
  BEGIN

    SELECT @price_of_product := P.price
    FROM product AS P
    WHERE P.shopId = sh AND P.id = pr;

    SELECT @offer_of_product := P.offer
    FROM product AS P
    WHERE P.shopId = sh AND P.id = pr;

    SELECT @supply_of_product := P.value
    FROM product AS P
    WHERE P.shopId = sh AND P.id = pr;

    SELECT @cu_cred := C.credit
    FROM customers AS C
    WHERE C.username = cu;

    SELECT @shop_start_time := S.start_time
    FROM shop AS S
    WHERE S.id = sh;

    SELECT @shop_end_time := S.end_time
    FROM shop AS S
    WHERE S.id = sh;

    IF @supply_of_product < va OR @cu_cred < ((1.0 - @offer_of_product) * @price_of_product * va) OR
       @shop_start_time > current_time OR
       current_time > @shop_end_time
    THEN

      INSERT INTO customerorders (customerUsername, shopId, productId, value, status, payment_type, address, phone_number)
        VALUE (cu, sh, pr, va, 'rejected', pa, ad, ph);

    ELSE

      UPDATE customers AS C
      SET C.credit = C.credit - (1.0 - @offer_of_product) * @price_of_product * va
      WHERE C.username = cu AND pa = 'online';

      UPDATE product AS P
      SET P.value = P.value - va
      WHERE P.id = pr AND P.shopId = sh;

      INSERT INTO customerorders (customerUsername, shopId, productId, value, payment_type, address, phone_number)
        VALUE (cu, sh, pr, va, pa, ad, ph);

    END IF;

  END;

# This is an example of a bullshit query, remember, never use session variable, instead, use procedure variable(local variable)
# www.stackoverflow.com/questions/1009954/mysql-variable-vs-variable-whats-the-difference
CREATE PROCEDURE add_order_by_temporary_customer(IN cu VARCHAR(150), # customerEmail
                                                 IN sh INT UNSIGNED, # shop id
                                                 IN pr INT UNSIGNED, # product id
                                                 IN va INTEGER # value
)
  BEGIN
    DECLARE `_rollback` BOOL DEFAULT 0;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
    START TRANSACTION;

    SELECT @supply_of_product := P.value
    FROM product AS P
    WHERE P.shopId = sh AND P.id = pr;

    SELECT @shop_start_time := S.start_time
    FROM shop AS S
    WHERE S.id = sh;

    SELECT @shop_end_time := S.end_time
    FROM shop AS S
    WHERE S.id = sh;

    IF @shop_start_time <= current_time AND current_time <= @shop_end_time AND @supply_of_product >= va
    THEN

      INSERT INTO temporarycustomerorders (customerEmail, shopId, productId, value)
        VALUE (cu, sh, pr, va);

      UPDATE product AS P
      SET P.value = P.value - va
      WHERE P.id = pr AND P.shopId = sh;

    ELSE
      INSERT INTO temporarycustomerorders (customerEmail, shopId, productId, value, status)
        VALUE (cu, sh, pr, va, 'rejected');
    END IF;

    IF `_rollback`
    THEN
      ROLLBACK;
    ELSE
      COMMIT;
    END IF;
  END;

CREATE PROCEDURE deliver_to_customer(tid INT UNSIGNED, # transmitterID
                                     pt  TIMESTAMP, # purchase_time
                                     cu  VARCHAR(100), # customerUsername
                                     sh  INT UNSIGNED, # shopId
                                     pr  INT UNSIGNED # productId
)
  BEGIN
    DECLARE state ENUM ('accepted', 'rejected', 'sending', 'done');

    SELECT status
    INTO state
    FROM customerorders AS C
    WHERE C.purchase_time = pt AND C.customerUsername = cu AND C.shopId = sh AND C.productId = pr;

    IF state != 'done'
    THEN
      UPDATE customerorders AS C
      SET C.status = 'done'
      WHERE C.purchase_time = pt AND C.customerUsername = cu AND C.shopId = sh AND C.productId = pr;

      UPDATE transmitters AS T
      SET T.status = 'free', T.credit = T.credit + 0.05 * (SELECT P.price
                                                           FROM product AS P
                                                           WHERE P.id = pr AND P.shopId = sh)
      WHERE T.id = tid AND T.shopId = sh;
    END IF;
  END;

CREATE PROCEDURE deliver_to_temporary_customer(tid INT UNSIGNED, # transmitterID
                                               pt  TIMESTAMP, # purchase_time
                                               ce  VARCHAR(100), # customerEmail
                                               sh  INT UNSIGNED, # shopId
                                               pr  INT UNSIGNED # productId
)
  BEGIN
    DECLARE state ENUM ('accepted', 'rejected', 'sending', 'done');

    SELECT status
    INTO state
    FROM temporarycustomerorders AS C
    WHERE C.purchase_time = pt AND C.customerEmail = ce AND C.shopId = sh AND C.productId = pr;

    IF state != 'done'
    THEN
      UPDATE temporarycustomerorders AS C
      SET C.status = 'done'
      WHERE C.purchase_time = pt AND C.customerEmail = ce AND C.shopId = sh AND C.productId = pr;

      UPDATE transmitters AS T
      SET T.status = 'free', T.credit = T.credit + 0.05 * (SELECT P.price
                                                           FROM product AS P
                                                           WHERE P.id = pr AND P.shopId = sh)
      WHERE T.id = tid AND T.shopId = sh;
    END IF;
  END;

CREATE PROCEDURE charge_account(IN us VARCHAR(100), #username
                                IN cr INT UNSIGNED #credit
)
  BEGIN
    IF cr > 0
    THEN
      UPDATE customers
      SET credit = credit + cr
      WHERE username = us;
    END IF;
  END;











CREATE DATABASE  IF NOT EXISTS `store` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `store`;
-- MySQL dump 10.13  Distrib 5.7.9, for Win64 (x86_64)
--
-- Host: localhost    Database: store
-- ------------------------------------------------------
-- Server version	5.7.11-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `customerorders`
--

DROP TABLE IF EXISTS `customerorders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customerorders` (
  `purchase_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `customerUsername` varchar(100) NOT NULL,
  `shopId` int(10) unsigned NOT NULL,
  `productId` int(10) unsigned NOT NULL,
  `value` int(10) unsigned NOT NULL DEFAULT '1',
  `status` enum('accepted','rejected','sending','done') NOT NULL DEFAULT 'accepted',
  `payment_type` enum('online','offline') NOT NULL DEFAULT 'online',
  `address` varchar(200) NOT NULL,
  `phone_number` varchar(14) NOT NULL,
  PRIMARY KEY (`purchase_time`,`customerUsername`,`shopId`,`productId`),
  KEY `shopId` (`shopId`),
  KEY `productId` (`productId`,`shopId`),
  KEY `customerUsername` (`customerUsername`,`address`),
  KEY `customerUsername_2` (`customerUsername`,`phone_number`),
  CONSTRAINT `customerorders_ibfk_1` FOREIGN KEY (`customerUsername`) REFERENCES `customers` (`username`),
  CONSTRAINT `customerorders_ibfk_2` FOREIGN KEY (`shopId`) REFERENCES `shop` (`id`),
  CONSTRAINT `customerorders_ibfk_3` FOREIGN KEY (`productId`, `shopId`) REFERENCES `product` (`id`, `shopId`),
  CONSTRAINT `customerorders_ibfk_4` FOREIGN KEY (`customerUsername`, `address`) REFERENCES `customeraddresses` (`CustomerUsername`, `address`),
  CONSTRAINT `customerorders_ibfk_5` FOREIGN KEY (`customerUsername`, `phone_number`) REFERENCES `customerphonenumbers` (`CustomerUsername`, `phone_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customerorders`
--

LOCK TABLES `customerorders` WRITE;
/*!40000 ALTER TABLE `customerorders` DISABLE KEYS */;
INSERT INTO `customerorders` VALUES ('1970-02-20 18:55:59','josiah.smith',2,2,6,'sending','online','188 Ondricka Gateway\nNorth Breannaton, WY 70916','(147)907-5614x'),('1970-03-14 22:53:29','mya.conroy',1,7,5,'sending','online','452 Amina Circles\nLake Sandra, MN 76574-8750','996.859.8073x0'),('1970-03-19 11:49:42','mya.conroy',1,10,7,'sending','online','452 Amina Circles\nLake Sandra, MN 76574-8750','996.859.8073x0'),('1970-07-07 12:27:58','schimmel.cicero',2,13,6,'sending','online','0763 Dibbert Terrace Apt. 521\nDonnyfort, FL 38204-4714','1-756-592-1278'),('1970-11-10 19:06:35','josiah.smith',2,17,8,'rejected','online','188 Ondricka Gateway\nNorth Breannaton, WY 70916','(147)907-5614x'),('1971-07-14 17:25:15','mya.conroy',1,10,4,'rejected','online','452 Amina Circles\nLake Sandra, MN 76574-8750','996.859.8073x0'),('1972-06-28 07:02:00','schimmel.cicero',3,9,8,'rejected','online','0763 Dibbert Terrace Apt. 521\nDonnyfort, FL 38204-4714','1-756-592-1278'),('1972-07-13 23:05:35','schimmel.cicero',3,21,2,'rejected','online','0763 Dibbert Terrace Apt. 521\nDonnyfort, FL 38204-4714','1-756-592-1278'),('1977-02-22 22:34:21','schimmel.cicero',3,3,5,'accepted','online','0763 Dibbert Terrace Apt. 521\nDonnyfort, FL 38204-4714','1-756-592-1278'),('1978-03-23 22:15:22','mya.conroy',1,10,5,'rejected','online','452 Amina Circles\nLake Sandra, MN 76574-8750','996.859.8073x0'),('1978-04-04 23:09:51','josiah.smith',2,20,9,'rejected','online','188 Ondricka Gateway\nNorth Breannaton, WY 70916','(147)907-5614x'),('1978-08-01 14:17:33','mya.conroy',1,7,7,'rejected','online','452 Amina Circles\nLake Sandra, MN 76574-8750','996.859.8073x0'),('1978-08-19 13:59:43','josiah.smith',2,2,7,'rejected','online','188 Ondricka Gateway\nNorth Breannaton, WY 70916','(147)907-5614x'),('1978-11-13 13:16:53','mya.conroy',1,10,6,'rejected','online','452 Amina Circles\nLake Sandra, MN 76574-8750','996.859.8073x0'),('1979-06-12 12:36:41','schimmel.cicero',3,21,7,'accepted','online','0763 Dibbert Terrace Apt. 521\nDonnyfort, FL 38204-4714','1-756-592-1278'),('1979-08-30 16:30:12','josiah.smith',2,17,10,'rejected','online','188 Ondricka Gateway\nNorth Breannaton, WY 70916','(147)907-5614x'),('1979-11-09 23:53:00','mya.conroy',1,7,9,'rejected','online','452 Amina Circles\nLake Sandra, MN 76574-8750','996.859.8073x0'),('1981-09-04 09:22:05','schimmel.cicero',3,21,2,'accepted','online','0763 Dibbert Terrace Apt. 521\nDonnyfort, FL 38204-4714','1-756-592-1278'),('1981-12-01 17:55:14','mya.conroy',1,7,4,'rejected','online','452 Amina Circles\nLake Sandra, MN 76574-8750','996.859.8073x0'),('1982-04-11 04:02:30','josiah.smith',2,17,8,'rejected','online','188 Ondricka Gateway\nNorth Breannaton, WY 70916','(147)907-5614x'),('1982-06-19 21:50:26','josiah.smith',2,20,10,'rejected','online','188 Ondricka Gateway\nNorth Breannaton, WY 70916','(147)907-5614x'),('1982-07-20 09:01:26','schimmel.cicero',3,9,4,'rejected','online','0763 Dibbert Terrace Apt. 521\nDonnyfort, FL 38204-4714','1-756-592-1278'),('1983-05-21 09:51:51','josiah.smith',2,2,8,'rejected','online','188 Ondricka Gateway\nNorth Breannaton, WY 70916','(147)907-5614x'),('1983-08-04 10:43:41','josiah.smith',2,20,3,'rejected','online','188 Ondricka Gateway\nNorth Breannaton, WY 70916','(147)907-5614x'),('1984-01-30 11:00:52','schimmel.cicero',3,9,5,'rejected','online','0763 Dibbert Terrace Apt. 521\nDonnyfort, FL 38204-4714','1-756-592-1278'),('1984-02-10 14:30:52','schimmel.cicero',3,21,7,'rejected','online','0763 Dibbert Terrace Apt. 521\nDonnyfort, FL 38204-4714','1-756-592-1278'),('1984-04-16 07:52:24','mya.conroy',1,7,9,'rejected','online','452 Amina Circles\nLake Sandra, MN 76574-8750','996.859.8073x0'),('1989-12-05 00:26:47','mya.conroy',1,10,2,'rejected','online','452 Amina Circles\nLake Sandra, MN 76574-8750','996.859.8073x0'),('1989-12-23 14:12:43','schimmel.cicero',3,9,4,'rejected','online','0763 Dibbert Terrace Apt. 521\nDonnyfort, FL 38204-4714','1-756-592-1278'),('1990-02-28 01:04:16','mya.conroy',1,10,7,'rejected','online','452 Amina Circles\nLake Sandra, MN 76574-8750','996.859.8073x0'),('1990-06-10 15:33:36','josiah.smith',2,2,6,'rejected','online','188 Ondricka Gateway\nNorth Breannaton, WY 70916','(147)907-5614x'),('1990-07-01 19:17:59','mya.conroy',1,10,9,'rejected','online','452 Amina Circles\nLake Sandra, MN 76574-8750','996.859.8073x0'),('1990-09-23 18:14:58','schimmel.cicero',3,3,9,'rejected','online','0763 Dibbert Terrace Apt. 521\nDonnyfort, FL 38204-4714','1-756-592-1278'),('1991-01-31 01:07:21','josiah.smith',2,2,3,'rejected','online','188 Ondricka Gateway\nNorth Breannaton, WY 70916','(147)907-5614x'),('1991-10-05 23:26:10','schimmel.cicero',3,3,1,'rejected','online','0763 Dibbert Terrace Apt. 521\nDonnyfort, FL 38204-4714','1-756-592-1278'),('1991-10-06 06:24:29','schimmel.cicero',3,9,5,'rejected','online','0763 Dibbert Terrace Apt. 521\nDonnyfort, FL 38204-4714','1-756-592-1278'),('1991-12-05 14:32:38','josiah.smith',2,20,2,'rejected','online','188 Ondricka Gateway\nNorth Breannaton, WY 70916','(147)907-5614x'),('1993-01-09 01:09:43','schimmel.cicero',3,21,5,'accepted','online','0763 Dibbert Terrace Apt. 521\nDonnyfort, FL 38204-4714','1-756-592-1278'),('1993-12-31 04:59:04','josiah.smith',2,17,2,'rejected','online','188 Ondricka Gateway\nNorth Breannaton, WY 70916','(147)907-5614x'),('1994-10-11 13:52:31','schimmel.cicero',3,9,6,'rejected','online','0763 Dibbert Terrace Apt. 521\nDonnyfort, FL 38204-4714','1-756-592-1278'),('1995-03-29 18:46:51','schimmel.cicero',3,9,7,'rejected','online','0763 Dibbert Terrace Apt. 521\nDonnyfort, FL 38204-4714','1-756-592-1278'),('1995-07-07 07:22:46','mya.conroy',1,10,10,'rejected','online','452 Amina Circles\nLake Sandra, MN 76574-8750','996.859.8073x0'),('1995-07-08 07:47:31','schimmel.cicero',3,3,5,'rejected','online','0763 Dibbert Terrace Apt. 521\nDonnyfort, FL 38204-4714','1-756-592-1278'),('1995-12-13 23:42:56','mya.conroy',1,10,7,'rejected','online','452 Amina Circles\nLake Sandra, MN 76574-8750','996.859.8073x0'),('1996-09-01 17:41:52','josiah.smith',2,20,8,'rejected','online','188 Ondricka Gateway\nNorth Breannaton, WY 70916','(147)907-5614x'),('1997-02-04 10:03:29','schimmel.cicero',3,3,6,'accepted','online','0763 Dibbert Terrace Apt. 521\nDonnyfort, FL 38204-4714','1-756-592-1278'),('1997-12-02 00:41:18','josiah.smith',2,17,2,'rejected','online','188 Ondricka Gateway\nNorth Breannaton, WY 70916','(147)907-5614x'),('1999-05-10 22:11:26','josiah.smith',2,20,4,'rejected','online','188 Ondricka Gateway\nNorth Breannaton, WY 70916','(147)907-5614x'),('1999-11-11 11:56:13','mya.conroy',1,7,1,'rejected','online','452 Amina Circles\nLake Sandra, MN 76574-8750','996.859.8073x0'),('2000-05-27 02:48:21','josiah.smith',2,17,2,'rejected','online','188 Ondricka Gateway\nNorth Breannaton, WY 70916','(147)907-5614x'),('2000-08-25 10:13:39','josiah.smith',2,20,3,'rejected','online','188 Ondricka Gateway\nNorth Breannaton, WY 70916','(147)907-5614x'),('2000-09-25 16:26:21','josiah.smith',2,20,7,'rejected','online','188 Ondricka Gateway\nNorth Breannaton, WY 70916','(147)907-5614x'),('2002-02-10 15:43:09','mya.conroy',1,7,7,'rejected','online','452 Amina Circles\nLake Sandra, MN 76574-8750','996.859.8073x0'),('2002-02-12 02:34:25','josiah.smith',2,17,10,'rejected','online','188 Ondricka Gateway\nNorth Breannaton, WY 70916','(147)907-5614x'),('2002-06-18 01:30:36','schimmel.cicero',3,9,1,'accepted','online','0763 Dibbert Terrace Apt. 521\nDonnyfort, FL 38204-4714','1-756-592-1278'),('2002-10-01 15:52:11','mya.conroy',1,7,2,'rejected','online','452 Amina Circles\nLake Sandra, MN 76574-8750','996.859.8073x0'),('2005-01-02 12:12:54','josiah.smith',2,17,4,'rejected','online','188 Ondricka Gateway\nNorth Breannaton, WY 70916','(147)907-5614x'),('2005-08-09 12:52:10','josiah.smith',2,17,6,'rejected','online','188 Ondricka Gateway\nNorth Breannaton, WY 70916','(147)907-5614x'),('2005-09-13 19:28:26','josiah.smith',2,20,3,'rejected','online','188 Ondricka Gateway\nNorth Breannaton, WY 70916','(147)907-5614x'),('2006-02-27 02:51:51','schimmel.cicero',3,9,4,'rejected','online','0763 Dibbert Terrace Apt. 521\nDonnyfort, FL 38204-4714','1-756-592-1278'),('2006-03-11 17:31:46','mya.conroy',1,7,2,'rejected','online','452 Amina Circles\nLake Sandra, MN 76574-8750','996.859.8073x0'),('2006-06-11 05:37:31','josiah.smith',2,20,9,'rejected','online','188 Ondricka Gateway\nNorth Breannaton, WY 70916','(147)907-5614x'),('2006-10-21 17:26:48','mya.conroy',1,10,7,'rejected','online','452 Amina Circles\nLake Sandra, MN 76574-8750','996.859.8073x0'),('2007-04-23 23:40:54','schimmel.cicero',3,3,1,'accepted','online','0763 Dibbert Terrace Apt. 521\nDonnyfort, FL 38204-4714','1-756-592-1278'),('2007-05-31 00:20:33','josiah.smith',2,20,4,'rejected','online','188 Ondricka Gateway\nNorth Breannaton, WY 70916','(147)907-5614x'),('2008-10-30 17:51:01','schimmel.cicero',3,9,9,'rejected','online','0763 Dibbert Terrace Apt. 521\nDonnyfort, FL 38204-4714','1-756-592-1278'),('2009-07-16 20:00:53','mya.conroy',1,10,6,'rejected','online','452 Amina Circles\nLake Sandra, MN 76574-8750','996.859.8073x0'),('2010-02-16 08:53:37','schimmel.cicero',3,21,1,'rejected','online','0763 Dibbert Terrace Apt. 521\nDonnyfort, FL 38204-4714','1-756-592-1278'),('2010-10-03 23:32:33','josiah.smith',2,2,1,'rejected','online','188 Ondricka Gateway\nNorth Breannaton, WY 70916','(147)907-5614x'),('2011-06-02 22:14:27','mya.conroy',1,7,6,'rejected','online','452 Amina Circles\nLake Sandra, MN 76574-8750','996.859.8073x0'),('2011-06-29 16:56:44','josiah.smith',2,17,1,'rejected','online','188 Ondricka Gateway\nNorth Breannaton, WY 70916','(147)907-5614x'),('2012-07-25 12:50:44','josiah.smith',2,2,1,'rejected','online','188 Ondricka Gateway\nNorth Breannaton, WY 70916','(147)907-5614x'),('2012-12-18 22:19:03','josiah.smith',2,17,1,'rejected','online','188 Ondricka Gateway\nNorth Breannaton, WY 70916','(147)907-5614x'),('2013-02-15 03:59:36','schimmel.cicero',3,3,10,'rejected','online','0763 Dibbert Terrace Apt. 521\nDonnyfort, FL 38204-4714','1-756-592-1278'),('2013-08-13 16:50:46','josiah.smith',2,2,6,'rejected','online','188 Ondricka Gateway\nNorth Breannaton, WY 70916','(147)907-5614x'),('2014-01-28 19:51:06','josiah.smith',2,20,8,'rejected','online','188 Ondricka Gateway\nNorth Breannaton, WY 70916','(147)907-5614x'),('2014-04-15 23:58:14','josiah.smith',2,2,2,'rejected','online','188 Ondricka Gateway\nNorth Breannaton, WY 70916','(147)907-5614x'),('2015-07-03 14:35:20','josiah.smith',2,2,1,'rejected','online','188 Ondricka Gateway\nNorth Breannaton, WY 70916','(147)907-5614x'),('2015-12-14 16:13:29','josiah.smith',2,2,9,'rejected','online','188 Ondricka Gateway\nNorth Breannaton, WY 70916','(147)907-5614x'),('2017-01-08 18:16:36','josiah.smith',2,2,1,'rejected','online','188 Ondricka Gateway\nNorth Breannaton, WY 70916','(147)907-5614x'),('2017-07-10 15:05:37','josiah.smith',2,2,2,'rejected','online','188 Ondricka Gateway\nNorth Breannaton, WY 70916','(147)907-5614x'),('2017-11-18 02:51:59','schimmel.cicero',3,9,5,'rejected','online','0763 Dibbert Terrace Apt. 521\nDonnyfort, FL 38204-4714','1-756-592-1278'),('2018-01-22 09:55:35','mya.conroy',1,10,8,'rejected','online','452 Amina Circles\nLake Sandra, MN 76574-8750','996.859.8073x0'),('2018-08-03 19:21:32','schimmel.cicero',3,3,8,'rejected','online','0763 Dibbert Terrace Apt. 521\nDonnyfort, FL 38204-4714','1-756-592-1278'),('2018-10-26 04:12:00','schimmel.cicero',3,9,6,'rejected','online','0763 Dibbert Terrace Apt. 521\nDonnyfort, FL 38204-4714','1-756-592-1278'),('2019-01-09 15:27:43','schimmel.cicero',3,3,4,'accepted','online','0763 Dibbert Terrace Apt. 521\nDonnyfort, FL 38204-4714','1-756-592-1278');
/*!40000 ALTER TABLE `customerorders` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER add_order_by_customer
BEFORE INSERT ON customerorders
FOR EACH ROW
  BEGIN

    DECLARE transmitter INT UNSIGNED;

    SELECT P.price
    INTO @price_of_product
    FROM product AS P
    WHERE P.shopId = NEW.shopId AND P.id = NEW.productId;

    SELECT P.offer
    INTO @offer_of_product
    FROM product AS P
    WHERE P.shopId = NEW.shopId AND P.id = NEW.productId;

    SELECT P.value
    INTO @supply_of_product
    FROM product AS P
    WHERE P.shopId = NEW.shopId AND P.id = NEW.productId;

    SELECT C.credit
    INTO @cu_cred
    FROM customers AS C
    WHERE C.username = NEW.customerUsername;

    SELECT S.start_time
    INTO @shop_start_time
    FROM shop AS S
    WHERE S.id = NEW.shopId;

    SELECT S.end_time
    INTO @shop_end_time
    FROM shop AS S
    WHERE S.id = NEW.shopId;

    IF @supply_of_product < NEW.value OR @cu_cred < ((1.0 - @offer_of_product) * @price_of_product * NEW.value) OR
       @shop_start_time > current_time OR
       current_time > @shop_end_time
    THEN
      SET NEW.status = 'rejected';
    ELSE

      UPDATE customers AS C
      SET C.credit = C.credit - (1.0 - @offer_of_product) * @price_of_product * NEW.value
      WHERE C.username = NEW.customerUsername AND NEW.payment_type = 'online';

      UPDATE product AS P
      SET P.value = P.value - NEW.value
      WHERE P.id = NEW.productId AND P.shopId = NEW.shopId;

      SELECT T.id
      INTO transmitter
      FROM transmitters AS T
      WHERE T.status = 'free' AND T.shopId = NEW.shopId
      LIMIT 1;

      IF transmitter
      THEN
        SET NEW.status = 'sending';
      END IF;

    END IF;
  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER deliver_to_transmitter
AFTER INSERT ON customerorders
FOR EACH ROW
  BEGIN

    DECLARE transmitter INT UNSIGNED;

    IF NEW.status != 'rejected'
    THEN

      SELECT T.id
      INTO transmitter
      FROM transmitters AS T
      WHERE T.status = 'free' AND T.shopId = NEW.shopId
      LIMIT 1;

      IF transmitter
      THEN
        UPDATE transmitters AS T
        SET status = 'sending'
        WHERE T.id = transmitter;
        INSERT INTO shipment (transmitterId, purchase_time, customerUsername, shopId, productId)
        VALUES (transmitter, NEW.purchase_time, NEW.customerUsername, NEW.shopId, NEW.productId);

      END IF;
    END IF;
  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER log_update_on_customer_orders
AFTER UPDATE ON customerorders
FOR EACH ROW
  BEGIN
    INSERT INTO updatecustomerorderlog (purchase_time, customerUsername, shopId, productId, pre_status, new_status)
    VALUES (NEW.purchase_time, NEW.customerUsername, NEW.shopId, NEW.productId, OLD.status, NEW.status);
  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-01-17 20:26:59

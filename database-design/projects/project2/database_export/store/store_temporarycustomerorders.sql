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
-- Table structure for table `temporarycustomerorders`
--

DROP TABLE IF EXISTS `temporarycustomerorders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `temporarycustomerorders` (
  `purchase_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `customerEmail` varchar(150) NOT NULL,
  `shopId` int(10) unsigned NOT NULL,
  `productId` int(10) unsigned NOT NULL,
  `value` int(10) unsigned NOT NULL DEFAULT '1',
  `status` enum('accepted','rejected','sending','done') NOT NULL DEFAULT 'accepted',
  PRIMARY KEY (`purchase_time`,`customerEmail`,`shopId`,`productId`),
  KEY `customerEmail` (`customerEmail`),
  KEY `shopId` (`shopId`),
  KEY `productId` (`productId`,`shopId`),
  CONSTRAINT `temporarycustomerorders_ibfk_1` FOREIGN KEY (`customerEmail`) REFERENCES `temporarycustomers` (`email`),
  CONSTRAINT `temporarycustomerorders_ibfk_2` FOREIGN KEY (`shopId`) REFERENCES `shop` (`id`),
  CONSTRAINT `temporarycustomerorders_ibfk_3` FOREIGN KEY (`productId`, `shopId`) REFERENCES `product` (`id`, `shopId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `temporarycustomerorders`
--

LOCK TABLES `temporarycustomerorders` WRITE;
/*!40000 ALTER TABLE `temporarycustomerorders` DISABLE KEYS */;
INSERT INTO `temporarycustomerorders` VALUES ('1970-02-20 18:55:59','milo.abbott@example.net',2,2,6,'rejected'),('1970-03-14 22:53:29','coleman45@example.org',1,7,5,'rejected'),('1970-03-19 11:49:42','coleman45@example.org',1,10,7,'rejected'),('1970-07-07 12:27:58','ufay@example.com',3,3,6,'sending'),('1970-11-10 19:06:35','milo.abbott@example.net',2,17,8,'rejected'),('1971-07-14 17:25:15','coleman45@example.org',1,10,4,'rejected'),('1972-06-28 07:02:00','ufay@example.com',3,9,8,'sending'),('1972-07-13 23:05:35','ufay@example.com',3,21,2,'rejected'),('1972-11-11 17:32:03','ufay@example.com',3,21,2,'rejected'),('1972-12-27 20:07:29','coleman45@example.org',1,7,9,'rejected'),('1973-07-05 22:34:11','ufay@example.com',3,21,4,'rejected'),('1973-07-19 22:56:17','coleman45@example.org',1,10,8,'rejected'),('1973-10-05 15:31:47','milo.abbott@example.net',2,20,3,'rejected'),('1974-01-27 07:00:25','coleman45@example.org',1,7,8,'rejected'),('1976-02-20 10:01:26','milo.abbott@example.net',2,2,4,'rejected'),('1976-07-27 00:09:44','coleman45@example.org',1,10,6,'rejected'),('1976-09-26 17:36:00','milo.abbott@example.net',2,2,3,'rejected'),('1976-11-06 07:34:55','coleman45@example.org',1,7,6,'rejected'),('1976-11-26 16:51:07','ufay@example.com',3,9,2,'accepted'),('1976-12-02 21:20:40','milo.abbott@example.net',2,17,6,'rejected'),('1977-02-22 22:34:21','ufay@example.com',3,3,5,'accepted'),('1978-03-23 22:15:22','coleman45@example.org',1,10,5,'rejected'),('1978-04-04 23:09:51','milo.abbott@example.net',2,20,9,'rejected'),('1978-08-01 14:17:33','coleman45@example.org',1,7,7,'rejected'),('1978-08-19 13:59:43','milo.abbott@example.net',2,2,7,'rejected'),('1978-11-13 13:16:53','coleman45@example.org',1,10,6,'rejected'),('1979-06-12 12:36:41','ufay@example.com',3,21,7,'accepted'),('1979-08-30 16:30:12','milo.abbott@example.net',2,17,10,'rejected'),('1979-11-09 23:53:00','coleman45@example.org',1,7,9,'rejected'),('1981-09-04 09:22:05','ufay@example.com',3,21,2,'accepted'),('1981-12-01 17:55:14','coleman45@example.org',1,7,4,'rejected'),('1982-04-11 04:02:30','milo.abbott@example.net',2,17,8,'rejected'),('1982-06-19 21:50:26','milo.abbott@example.net',2,20,10,'rejected'),('1982-07-20 09:01:26','ufay@example.com',3,9,4,'accepted'),('1983-05-21 09:51:51','milo.abbott@example.net',2,2,8,'rejected'),('1983-08-04 10:43:41','milo.abbott@example.net',2,20,3,'rejected'),('1984-01-30 11:00:52','ufay@example.com',3,9,5,'rejected'),('1984-02-10 14:30:52','ufay@example.com',3,21,7,'rejected'),('1984-04-16 07:52:24','coleman45@example.org',1,7,9,'rejected'),('1985-01-29 18:27:08','ufay@example.com',3,21,5,'accepted'),('1986-03-18 13:35:28','milo.abbott@example.net',2,17,7,'rejected'),('1987-03-22 10:18:32','ufay@example.com',3,21,8,'accepted'),('1987-05-17 00:42:34','coleman45@example.org',1,7,5,'rejected'),('1989-09-01 00:52:35','ufay@example.com',3,9,8,'sending'),('1989-12-05 00:26:47','coleman45@example.org',1,10,2,'rejected'),('1989-12-23 14:12:43','ufay@example.com',3,9,4,'rejected'),('1990-02-28 01:04:16','coleman45@example.org',1,10,7,'rejected'),('1990-06-10 15:33:36','milo.abbott@example.net',2,2,6,'rejected'),('1990-07-01 19:17:59','coleman45@example.org',1,10,9,'rejected'),('1990-09-23 18:14:58','ufay@example.com',3,3,9,'rejected'),('1991-01-31 01:07:21','milo.abbott@example.net',2,2,3,'rejected'),('1991-03-04 18:23:53','ufay@example.com',3,21,1,'rejected'),('1991-06-09 23:31:25','ufay@example.com',3,3,5,'sending'),('1991-10-05 23:26:10','ufay@example.com',3,3,1,'rejected'),('1991-10-06 06:24:29','ufay@example.com',3,9,5,'accepted'),('1991-12-05 14:32:38','milo.abbott@example.net',2,20,2,'rejected'),('1992-03-06 01:46:01','ufay@example.com',3,21,8,'rejected'),('1992-03-20 21:15:36','ufay@example.com',3,3,6,'accepted'),('1992-11-12 00:56:11','milo.abbott@example.net',2,17,3,'rejected'),('1993-01-09 01:09:43','ufay@example.com',3,21,5,'accepted'),('1993-02-03 21:08:20','ufay@example.com',1,5,9,'sending'),('1993-10-11 00:39:32','milo.abbott@example.net',2,20,5,'rejected'),('1993-12-24 11:31:24','ufay@example.com',3,3,8,'accepted'),('1993-12-31 04:59:04','milo.abbott@example.net',2,17,2,'rejected'),('1994-10-11 13:52:31','ufay@example.com',3,9,6,'accepted'),('1995-03-29 18:46:51','ufay@example.com',3,9,7,'rejected'),('1995-07-07 07:22:46','coleman45@example.org',1,10,10,'rejected'),('1995-07-08 07:47:31','ufay@example.com',3,3,5,'rejected'),('1995-12-13 23:42:56','coleman45@example.org',1,10,7,'rejected'),('1996-09-01 17:41:52','milo.abbott@example.net',2,20,8,'rejected'),('1997-02-04 10:03:29','ufay@example.com',3,3,6,'accepted'),('1997-12-02 00:41:18','milo.abbott@example.net',2,17,2,'rejected'),('1999-05-10 22:11:26','milo.abbott@example.net',2,20,4,'rejected'),('1999-11-11 11:56:13','coleman45@example.org',1,7,1,'rejected'),('2000-04-03 12:27:17','ufay@example.com',3,21,8,'rejected'),('2000-05-27 02:48:21','milo.abbott@example.net',2,17,2,'rejected'),('2000-08-25 10:13:39','milo.abbott@example.net',2,20,3,'rejected'),('2000-09-25 16:26:21','milo.abbott@example.net',2,20,7,'rejected'),('2002-02-10 15:43:09','coleman45@example.org',1,7,7,'rejected'),('2002-02-12 02:34:25','milo.abbott@example.net',2,17,10,'rejected'),('2002-06-18 01:30:36','ufay@example.com',3,9,1,'accepted'),('2002-08-04 14:28:20','ufay@example.com',3,21,1,'accepted'),('2002-10-01 15:52:11','coleman45@example.org',1,7,2,'rejected'),('2005-01-02 12:12:54','milo.abbott@example.net',2,17,4,'rejected'),('2005-08-09 12:52:10','milo.abbott@example.net',2,17,6,'rejected'),('2005-09-13 19:28:26','milo.abbott@example.net',2,20,3,'rejected'),('2006-02-27 02:51:51','ufay@example.com',3,9,4,'rejected'),('2006-03-11 17:31:46','coleman45@example.org',1,7,2,'rejected'),('2006-06-11 05:37:31','milo.abbott@example.net',2,20,9,'rejected'),('2006-10-21 17:26:48','coleman45@example.org',1,10,7,'rejected'),('2007-04-23 23:40:54','ufay@example.com',3,3,1,'accepted'),('2007-05-31 00:20:33','milo.abbott@example.net',2,20,4,'rejected'),('2008-10-30 17:51:01','ufay@example.com',3,9,9,'rejected'),('2009-07-16 20:00:53','coleman45@example.org',1,10,6,'rejected'),('2010-02-16 08:53:37','ufay@example.com',3,21,1,'rejected'),('2010-10-03 23:32:33','milo.abbott@example.net',2,2,1,'rejected'),('2011-06-02 22:14:27','coleman45@example.org',1,7,6,'rejected'),('2011-06-29 16:56:44','milo.abbott@example.net',2,17,1,'rejected'),('2012-07-25 12:50:44','milo.abbott@example.net',2,2,1,'rejected'),('2012-12-18 22:19:03','milo.abbott@example.net',2,17,1,'rejected'),('2013-02-15 03:59:36','ufay@example.com',3,3,10,'rejected'),('2013-08-13 16:50:46','milo.abbott@example.net',2,2,6,'rejected'),('2014-01-28 19:51:06','milo.abbott@example.net',2,20,8,'rejected'),('2014-04-15 23:58:14','milo.abbott@example.net',2,2,2,'rejected'),('2015-01-22 11:30:42','ufay@example.com',3,3,8,'rejected'),('2015-07-03 14:35:20','milo.abbott@example.net',2,2,1,'rejected'),('2015-12-14 16:13:29','milo.abbott@example.net',2,2,9,'rejected'),('2017-01-08 18:16:36','milo.abbott@example.net',2,2,1,'rejected'),('2017-07-10 15:05:37','milo.abbott@example.net',2,2,2,'rejected'),('2017-11-18 02:51:59','ufay@example.com',3,9,5,'rejected'),('2018-01-22 09:55:35','coleman45@example.org',1,10,8,'rejected'),('2018-08-03 19:21:32','ufay@example.com',3,3,8,'rejected'),('2018-10-26 04:12:00','ufay@example.com',3,9,6,'rejected'),('2019-01-09 15:27:43','ufay@example.com',3,3,4,'accepted');
/*!40000 ALTER TABLE `temporarycustomerorders` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER add_order_by_temporary_customer
BEFORE INSERT ON temporarycustomerorders
FOR EACH ROW
  BEGIN

    DECLARE transmitter INT UNSIGNED;

    SELECT P.value
    INTO @supply_of_product
    FROM product AS P
    WHERE P.shopId = NEW.shopId AND P.id = NEW.productId;

    SELECT S.start_time
    INTO @shop_start_time
    FROM shop AS S
    WHERE S.id = NEW.shopId;

    SELECT S.end_time
    INTO @shop_end_time
    FROM shop AS S
    WHERE S.id = NEW.shopId;

    IF @supply_of_product < NEW.value OR
       @shop_start_time > current_time OR
       current_time > @shop_end_time
    THEN
      SET NEW.status = 'rejected';
    ELSE

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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER deliver_temporary_customer_order_to_transmitter
AFTER INSERT ON temporarycustomerorders
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
        INSERT INTO temporaryshipment (transmitterId, purchase_time, customerEmail, shopId, productId)
        VALUES (transmitter, NEW.purchase_time, NEW.customerEmail, NEW.shopId, NEW.productId);

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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER log_update_on_temporary_customer_orders
AFTER UPDATE ON temporarycustomerorders
FOR EACH ROW
  BEGIN
    INSERT INTO updatetemporarycustomerorderlog (purchase_time, customerEmail, shopId, productId, pre_status, new_status)
    VALUES (NEW.purchase_time, NEW.customerEmail, NEW.shopId, NEW.productId, OLD.status, NEW.status);
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

-- Dump completed on 2019-01-17 20:26:58

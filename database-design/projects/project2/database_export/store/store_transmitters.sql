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
-- Table structure for table `transmitters`
--

DROP TABLE IF EXISTS `transmitters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `transmitters` (
  `id` int(10) unsigned NOT NULL,
  `shopId` int(10) unsigned NOT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `phone_number` varchar(14) NOT NULL,
  `status` enum('free','sending') NOT NULL DEFAULT 'sending',
  `credit` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`,`shopId`),
  KEY `shopId` (`shopId`),
  CONSTRAINT `transmitters_ibfk_1` FOREIGN KEY (`shopId`) REFERENCES `shop` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transmitters`
--

LOCK TABLES `transmitters` WRITE;
/*!40000 ALTER TABLE `transmitters` DISABLE KEYS */;
INSERT INTO `transmitters` VALUES (1,1,'Lance','Raynor','(624)662-5245x','sending',9202980),(2,3,'Amanda','Weimann','1-764-593-3910','sending',9970566),(3,2,'Brittany','Hodkiewicz','337.040.5166','sending',8146626),(4,3,'Haven','Windler','239.060.9454x4','sending',99458),(5,1,'Nat','Stokes','405-213-7433x7','sending',8351239),(6,2,'Elijah','Koelpin','(396)377-4131','sending',7286728),(7,1,'Pansy','Connelly','835-759-2005','sending',2120590),(8,2,'Salvador','Kovacek','1-071-458-8055','sending',8257145),(9,1,'Ceasar','Gibson','1-753-666-2179','sending',9695873),(10,3,'Casandra','King','1-959-439-5952','sending',1798218),(11,3,'Paige','Dickens','1-694-035-6246','sending',8213997),(12,2,'Timmy','Metz','(946)965-9404','sending',2859275);
/*!40000 ALTER TABLE `transmitters` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER log_update_on_transmitters
AFTER UPDATE ON transmitters
FOR EACH ROW
  BEGIN
    INSERT INTO updatetransmitterlog (transmitterId, pre_status, new_status)
    VALUES (NEW.id, OLD.status, NEW.status);
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

-- Dump completed on 2019-01-17 20:26:57

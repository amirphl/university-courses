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
-- Table structure for table `temporaryshipment`
--

DROP TABLE IF EXISTS `temporaryshipment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `temporaryshipment` (
  `transmitterId` int(10) unsigned DEFAULT NULL,
  `purchase_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `customerEmail` varchar(150) NOT NULL,
  `shopId` int(10) unsigned NOT NULL,
  `productId` int(10) unsigned NOT NULL,
  PRIMARY KEY (`purchase_time`,`customerEmail`,`shopId`,`productId`),
  KEY `transmitterId` (`transmitterId`,`shopId`),
  CONSTRAINT `temporaryshipment_ibfk_1` FOREIGN KEY (`transmitterId`, `shopId`) REFERENCES `transmitters` (`id`, `shopId`),
  CONSTRAINT `temporaryshipment_ibfk_2` FOREIGN KEY (`purchase_time`, `customerEmail`, `shopId`, `productId`) REFERENCES `temporarycustomerorders` (`purchase_time`, `customerEmail`, `shopId`, `productId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `temporaryshipment`
--

LOCK TABLES `temporaryshipment` WRITE;
/*!40000 ALTER TABLE `temporaryshipment` DISABLE KEYS */;
INSERT INTO `temporaryshipment` VALUES (2,'1970-07-07 12:27:58','ufay@example.com',3,3),(4,'1972-06-28 07:02:00','ufay@example.com',3,9),(7,'1993-02-03 21:08:20','ufay@example.com',1,5),(10,'1991-06-09 23:31:25','ufay@example.com',3,3),(11,'1989-09-01 00:52:35','ufay@example.com',3,9);
/*!40000 ALTER TABLE `temporaryshipment` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-01-17 20:26:58

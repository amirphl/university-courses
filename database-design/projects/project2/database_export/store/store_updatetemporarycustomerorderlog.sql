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
-- Table structure for table `updatetemporarycustomerorderlog`
--

DROP TABLE IF EXISTS `updatetemporarycustomerorderlog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `updatetemporarycustomerorderlog` (
  `purchase_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `customerEmail` varchar(150) NOT NULL,
  `shopId` int(10) unsigned NOT NULL,
  `productId` int(10) unsigned NOT NULL,
  `dat` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `pre_status` enum('accepted','rejected','sending','done') DEFAULT NULL,
  `new_status` enum('accepted','rejected','sending','done') DEFAULT NULL,
  PRIMARY KEY (`purchase_time`,`customerEmail`,`shopId`,`productId`,`dat`),
  CONSTRAINT `updatetemporarycustomerorderlog_ibfk_1` FOREIGN KEY (`purchase_time`, `customerEmail`, `shopId`, `productId`) REFERENCES `temporarycustomerorders` (`purchase_time`, `customerEmail`, `shopId`, `productId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `updatetemporarycustomerorderlog`
--

LOCK TABLES `updatetemporarycustomerorderlog` WRITE;
/*!40000 ALTER TABLE `updatetemporarycustomerorderlog` DISABLE KEYS */;
INSERT INTO `updatetemporarycustomerorderlog` VALUES ('1979-06-12 12:36:41','ufay@example.com',3,21,'2019-01-17 15:24:50','done','accepted'),('1985-01-29 18:27:08','ufay@example.com',3,21,'2019-01-17 15:24:50','done','accepted'),('1987-03-22 10:18:32','ufay@example.com',3,21,'2019-01-17 15:24:50','done','accepted'),('1991-10-06 06:24:29','ufay@example.com',3,9,'2019-01-17 15:24:50','done','accepted'),('1992-03-20 21:15:36','ufay@example.com',3,3,'2019-01-17 15:24:50','done','accepted'),('1993-01-09 01:09:43','ufay@example.com',3,21,'2019-01-17 15:24:50','done','accepted'),('1993-02-03 21:08:20','ufay@example.com',1,5,'2019-01-17 15:21:51','sending','sending'),('1997-02-04 10:03:29','ufay@example.com',3,3,'2019-01-17 15:24:50','done','accepted');
/*!40000 ALTER TABLE `updatetemporarycustomerorderlog` ENABLE KEYS */;
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

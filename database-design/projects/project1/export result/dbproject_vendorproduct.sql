-- MySQL dump 10.13  Distrib 5.7.9, for Win64 (x86_64)
--
-- Host: localhost    Database: dbproject
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
-- Table structure for table `vendorproduct`
--

DROP TABLE IF EXISTS `vendorproduct`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vendorproduct` (
  `VendorID` int(15) NOT NULL,
  `ProductID` int(15) NOT NULL,
  `Amount` int(10) NOT NULL,
  PRIMARY KEY (`ProductID`,`VendorID`),
  KEY `VendorID` (`VendorID`),
  CONSTRAINT `VendorProduct_ibfk_1` FOREIGN KEY (`ProductID`) REFERENCES `product` (`ID`),
  CONSTRAINT `VendorProduct_ibfk_2` FOREIGN KEY (`VendorID`) REFERENCES `vendor` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vendorproduct`
--

LOCK TABLES `vendorproduct` WRITE;
/*!40000 ALTER TABLE `vendorproduct` DISABLE KEYS */;
INSERT INTO `vendorproduct` VALUES (1,1,9),(6,1,2),(11,1,4),(2,2,6),(7,2,4),(12,2,2),(3,3,6),(8,3,3),(13,3,2),(4,4,5),(9,4,7),(14,4,5),(5,5,1),(10,5,1),(15,5,7),(1,6,1),(6,6,5),(11,6,9),(2,7,3),(7,7,5),(12,7,1),(3,8,5),(8,8,2),(13,8,9),(4,9,2),(9,9,7),(14,9,6),(5,10,3),(10,10,4),(15,10,8),(1,11,7),(6,11,1),(11,11,7),(2,12,6),(7,12,5),(12,12,4),(3,13,7),(8,13,6),(13,13,9),(4,14,6),(9,14,7),(14,14,1),(5,15,8),(10,15,7),(15,15,1),(1,16,3),(6,16,3),(11,16,2),(2,17,9),(7,17,5),(12,17,6),(3,18,3),(8,18,5),(13,18,6),(4,19,5),(9,19,2),(14,19,9),(5,20,5),(10,20,4),(15,20,5),(1,21,2),(6,21,1),(11,21,4),(2,22,4),(7,22,4),(12,22,2),(3,23,6),(8,23,4),(13,23,5),(4,24,4),(9,24,4),(14,24,1),(5,25,3),(10,25,2),(15,25,5),(1,26,9),(6,26,3),(11,26,1),(2,27,1),(7,27,7),(12,27,1),(3,28,3),(8,28,6),(13,28,1),(4,29,5),(9,29,1),(14,29,3),(5,30,9),(10,30,3),(15,30,9),(1,31,9),(6,31,6),(11,31,6),(2,32,3),(7,32,8),(12,32,5),(3,33,5),(8,33,5),(13,33,6),(4,34,7),(9,34,8),(14,34,6),(5,35,7),(10,35,8),(15,35,5),(1,36,3),(6,36,6),(11,36,8),(2,37,2),(7,37,6),(12,37,2),(3,38,1),(8,38,1),(13,38,4),(4,39,9),(9,39,8),(14,39,4),(5,40,5),(10,40,3),(15,40,3),(1,41,2),(6,41,7),(11,41,1),(2,42,4),(7,42,7),(12,42,2),(3,43,5),(8,43,6),(13,43,2),(4,44,4),(9,44,4),(14,44,4),(5,45,1),(10,45,3),(15,45,7),(1,46,3),(6,46,4),(11,46,3),(2,47,6),(7,47,6),(12,47,7),(3,48,3),(8,48,9),(13,48,3),(4,49,9),(9,49,4),(14,49,3),(5,50,2),(10,50,1),(15,50,4);
/*!40000 ALTER TABLE `vendorproduct` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-11-25 23:13:41

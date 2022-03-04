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
-- Table structure for table `vendor`
--

DROP TABLE IF EXISTS `vendor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vendor` (
  `ID` int(15) NOT NULL AUTO_INCREMENT,
  `Title` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `City` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `ManagerID` int(15) NOT NULL,
  `Phone` char(10) COLLATE utf8_unicode_ci NOT NULL,
  `Address` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`ID`,`ManagerID`),
  KEY `ManagerID` (`ManagerID`),
  CONSTRAINT `Vendor_ibfk_1` FOREIGN KEY (`ManagerID`) REFERENCES `manager` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vendor`
--

LOCK TABLES `vendor` WRITE;
/*!40000 ALTER TABLE `vendor` DISABLE KEYS */;
INSERT INTO `vendor` VALUES (1,'eos','West Claudia',1,'+47(2)7578','44767 Bailey Loop Apt. 140\nGoodwintown, CO 13399-3588'),(2,'laborum','Koleview',2,'+43(4)7685','5703 Pagac Corner Suite 023\nEast Jamir, SD 98916-4544'),(3,'libero','New Lorna',3,'+32(8)6461','47503 Kuhlman Trail\nNorth Dejonside, MS 42975-4482'),(4,'dolorem','Yeseniaville',4,'(488)401-9','5086 Hauck Forges Apt. 660\nBertamouth, SD 89667'),(5,'modi','East Carol',5,'1-101-063-','4932 Robel Lakes Suite 300\nSouth Deontae, NE 20298-0278'),(6,'officiis','Maribelmouth',1,'1-640-385-','71759 Taryn Bypass\nPort Kathlynville, AZ 42117'),(7,'non','East Otiliachester',2,'0081661894','1178 Mauricio Grove Suite 088\nMayerfurt, DE 89038-8602'),(8,'ipsum','West Ubaldoview',3,'745-376-39','218 Rohan Rue\nWest Graceport, UT 32992-5437'),(9,'ducimus','Murazikbury',4,'(613)134-5','500 Jeffry Dale\nNorth Easterchester, VT 77622-0841'),(10,'quae','Jessiechester',5,'297-719-49','7182 Vivian Parkways Apt. 271\nWolfftown, NH 12337'),(11,'quas','East Justuschester',1,'+88(0)0511','595 Kuhn Street Suite 697\nAbeberg, SC 86128'),(12,'deleniti','Jaychester',2,'571-581-73','00715 Schaefer Hill Apt. 304\nSchneiderfort, NC 70060'),(13,'et','North Donatoville',3,'+61(2)2768','288 Martine Orchard Apt. 014\nEast Mireya, AZ 94318'),(14,'similique','South Luellamouth',4,'520.797.98','657 Parker Trail Suite 972\nNew Chaz, DC 60639'),(15,'itaque','Port Kenyon',5,'+86(2)7906','61053 Howell Drives\nLefflerland, LA 03738');
/*!40000 ALTER TABLE `vendor` ENABLE KEYS */;
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

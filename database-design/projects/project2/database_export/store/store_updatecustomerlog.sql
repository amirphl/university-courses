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
-- Table structure for table `updatecustomerlog`
--

DROP TABLE IF EXISTS `updatecustomerlog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `updatecustomerlog` (
  `username` varchar(100) NOT NULL,
  `pre_password` varchar(512) DEFAULT NULL,
  `new_password` varchar(512) DEFAULT NULL,
  `pre_email` varchar(150) NOT NULL,
  `new_email` varchar(150) NOT NULL,
  `pre_credit` int(10) unsigned NOT NULL,
  `new_credit` int(10) unsigned NOT NULL,
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`username`,`update_time`),
  CONSTRAINT `updatecustomerlog_ibfk_1` FOREIGN KEY (`username`) REFERENCES `customers` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `updatecustomerlog`
--

LOCK TABLES `updatecustomerlog` WRITE;
/*!40000 ALTER TABLE `updatecustomerlog` DISABLE KEYS */;
INSERT INTO `updatecustomerlog` VALUES ('schimmel.cicero','6cff7cf8a443c8a2ac962f78171faaad4efdddf3','0e99e11c23f4b7836b1a6ecceba0c5ea68eeead0','virginie.rowe@example.org','virginie.rowe@example.org',4245387,4215616,'2019-01-17 15:11:59'),('schimmel.cicero','0e99e11c23f4b7836b1a6ecceba0c5ea68eeead0','b586012607737757606244ee823566b8522a97a8','virginie.rowe@example.org','virginie.rowe@example.org',4215616,4213954,'2019-01-17 15:12:00'),('schimmel.cicero','b586012607737757606244ee823566b8522a97a8','c71fe5a54c29bb87d89fc92c476f6948fe087da5','virginie.rowe@example.org','virginie.rowe@example.org',4213954,4189145,'2019-01-17 15:12:27'),('schimmel.cicero','c71fe5a54c29bb87d89fc92c476f6948fe087da5','e9b396865d8f0d52086d215ea94ebfe68ae90794','virginie.rowe@example.org','virginie.rowe@example.org',4189145,4183328,'2019-01-17 15:12:28'),('schimmel.cicero','e9b396865d8f0d52086d215ea94ebfe68ae90794','f3721839a4d99f4b24dd95727e3f85d382d61909','virginie.rowe@example.org','virginie.rowe@example.org',4183328,4181666,'2019-01-17 15:12:36'),('schimmel.cicero','f3721839a4d99f4b24dd95727e3f85d382d61909','fe8ac3f4f3580205f5e47bbf6392c1a7912f5ae3','virginie.rowe@example.org','virginie.rowe@example.org',4181666,4175849,'2019-01-17 15:12:37'),('schimmel.cicero','fe8ac3f4f3580205f5e47bbf6392c1a7912f5ae3','69db12045160c4555eac2c8f28e71efa52a04492','virginie.rowe@example.org','virginie.rowe@example.org',4175849,4170032,'2019-01-17 15:12:43'),('schimmel.cicero','69db12045160c4555eac2c8f28e71efa52a04492','36c848156ae1374a86d734fac777ff1c4c42c893','virginie.rowe@example.org','virginie.rowe@example.org',4170032,4125375,'2019-01-17 15:12:58'),('schimmel.cicero','36c848156ae1374a86d734fac777ff1c4c42c893','732a58ccf72d3ed6b79dcd8186301d188510d32a','virginie.rowe@example.org','virginie.rowe@example.org',4125375,4120413,'2019-01-17 15:13:04'),('schimmel.cicero','732a58ccf72d3ed6b79dcd8186301d188510d32a','44b5a88b44e35fa4e9fe7373c596df5b5dca479b','virginie.rowe@example.org','virginie.rowe@example.org',4120413,4116258,'2019-01-17 15:13:12'),('schimmel.cicero','44b5a88b44e35fa4e9fe7373c596df5b5dca479b','0926516609a96b866a780acc69afd7702a4fbee8','virginie.rowe@example.org','virginie.rowe@example.org',4116258,4091449,'2019-01-17 15:13:19'),('schimmel.cicero','0926516609a96b866a780acc69afd7702a4fbee8','cd8643b873bfd246e5e4c6ba9151e1e99f984615','virginie.rowe@example.org','virginie.rowe@example.org',4091449,4061678,'2019-01-17 15:13:20'),('schimmel.cicero','cd8643b873bfd246e5e4c6ba9151e1e99f984615','4e683b27c3a7a90e8c1ac15fd8e4dfcd964a295c','virginie.rowe@example.org','virginie.rowe@example.org',4061678,4054399,'2019-01-17 15:13:30'),('schimmel.cicero','4e683b27c3a7a90e8c1ac15fd8e4dfcd964a295c','d839d4f440e40d9419ea44e82064242a7bb29d07','virginie.rowe@example.org','virginie.rowe@example.org',4054399,4049437,'2019-01-17 15:13:37'),('schimmel.cicero','d839d4f440e40d9419ea44e82064242a7bb29d07','cfdb851372a82f468556d44d3b5f825503be9eb3','virginie.rowe@example.org','virginie.rowe@example.org',4049437,4048606,'2019-01-17 15:13:38'),('schimmel.cicero','cfdb851372a82f468556d44d3b5f825503be9eb3','4dc464b2364bd961e22ae391461b56115dcff6b4','virginie.rowe@example.org','virginie.rowe@example.org',4048606,4047775,'2019-01-17 15:13:51'),('schimmel.cicero','4dc464b2364bd961e22ae391461b56115dcff6b4','49a96b3ffc4f21882a7713e427fe9d8f202bbc4e','virginie.rowe@example.org','virginie.rowe@example.org',4047775,3998157,'2019-01-17 15:13:52'),('schimmel.cicero','49a96b3ffc4f21882a7713e427fe9d8f202bbc4e','c48e912727953288e8acef64463d0448d36631c6','virginie.rowe@example.org','virginie.rowe@example.org',3998157,3958462,'2019-01-17 15:13:59'),('schimmel.cicero','c48e912727953288e8acef64463d0448d36631c6','adbe3d49e0d1bff05df278713ad15712704b6849','virginie.rowe@example.org','virginie.rowe@example.org',3958462,3938615,'2019-01-17 15:14:00'),('schimmel.cicero','adbe3d49e0d1bff05df278713ad15712704b6849','8b8adf1cc41c2d643f8cfb775b8898b0fc3289af','virginie.rowe@example.org','virginie.rowe@example.org',3938615,3898920,'2019-01-17 15:14:06');
/*!40000 ALTER TABLE `updatecustomerlog` ENABLE KEYS */;
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

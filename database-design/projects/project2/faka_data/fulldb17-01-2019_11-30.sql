






# ATTENTION: this is just an example, never use this data because it is incompatible with tables.











#
# TABLE STRUCTURE FOR: CustomerAddresses
#

DROP TABLE IF EXISTS `CustomerAddresses`;

CREATE TABLE `CustomerAddresses` (
  `address` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `CustomerUsername` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`address`,`CustomerUsername`),
  KEY `CustomerUsername` (`CustomerUsername`),
  CONSTRAINT `CustomerAddresses_ibfk_1` FOREIGN KEY (`CustomerUsername`) REFERENCES `Customers` (`username`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `CustomerAddresses` (`address`, `CustomerUsername`) VALUES ('0763 Dibbert Terrace Apt. 521\nDonnyfort, FL 38204-4714', 'schimmel.cicero');
INSERT INTO `CustomerAddresses` (`address`, `CustomerUsername`) VALUES ('110 Hartmann Canyon Apt. 570\nLake Daishaland, LA 38569', 'schimmel.cicero');
INSERT INTO `CustomerAddresses` (`address`, `CustomerUsername`) VALUES ('188 Ondricka Gateway\nNorth Breannaton, WY 70916', 'josiah.smith');
INSERT INTO `CustomerAddresses` (`address`, `CustomerUsername`) VALUES ('452 Amina Circles\nLake Sandra, MN 76574-8750', 'mya.conroy');
INSERT INTO `CustomerAddresses` (`address`, `CustomerUsername`) VALUES ('472 Hintz Knoll Apt. 247\nPort Orpha, TN 47753', 'josiah.smith');
INSERT INTO `CustomerAddresses` (`address`, `CustomerUsername`) VALUES ('6368 Smith Rapids\nLubowitzton, MT 04698-3530', 'mya.conroy');


#
# TABLE STRUCTURE FOR: CustomerOrders
#

DROP TABLE IF EXISTS `CustomerOrders`;

CREATE TABLE `CustomerOrders` (
  `purchase_time` timestamp NOT NULL DEFAULT current_timestamp(),
  `customerUsername` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `shopId` int(10) unsigned NOT NULL,
  `productId` int(10) unsigned NOT NULL,
  `value` int(10) unsigned NOT NULL DEFAULT 1,
  `status` enum('accepted','rejected','sending','done') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'accepted',
  `payment_type` enum('online','offline') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'online',
  `dat` timestamp NOT NULL DEFAULT current_timestamp(),
  `address` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `phone_number` varchar(14) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`purchase_time`,`customerUsername`,`shopId`,`productId`),
  KEY `shopId` (`shopId`),
  KEY `productId` (`productId`,`shopId`),
  KEY `customerUsername` (`customerUsername`,`address`),
  KEY `customerUsername_2` (`customerUsername`,`phone_number`),
  CONSTRAINT `CustomerOrders_ibfk_1` FOREIGN KEY (`customerUsername`) REFERENCES `Customers` (`username`),
  CONSTRAINT `CustomerOrders_ibfk_2` FOREIGN KEY (`shopId`) REFERENCES `Shop` (`id`),
  CONSTRAINT `CustomerOrders_ibfk_3` FOREIGN KEY (`productId`, `shopId`) REFERENCES `Product` (`id`, `shopId`),
  CONSTRAINT `CustomerOrders_ibfk_4` FOREIGN KEY (`customerUsername`, `address`) REFERENCES `CustomerAddresses` (`CustomerUsername`, `address`),
  CONSTRAINT `CustomerOrders_ibfk_5` FOREIGN KEY (`customerUsername`, `phone_number`) REFERENCES `CustomerPhoneNumbers` (`CustomerUsername`, `phone_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

#
# TABLE STRUCTURE FOR: CustomerPhoneNumbers
#

DROP TABLE IF EXISTS `CustomerPhoneNumbers`;

CREATE TABLE `CustomerPhoneNumbers` (
  `phone_number` varchar(14) COLLATE utf8_unicode_ci NOT NULL,
  `CustomerUsername` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`phone_number`,`CustomerUsername`),
  KEY `CustomerUsername` (`CustomerUsername`),
  CONSTRAINT `CustomerPhoneNumbers_ibfk_1` FOREIGN KEY (`CustomerUsername`) REFERENCES `Customers` (`username`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `CustomerPhoneNumbers` (`phone_number`, `CustomerUsername`) VALUES ('(147)907-5614x', 'josiah.smith');
INSERT INTO `CustomerPhoneNumbers` (`phone_number`, `CustomerUsername`) VALUES ('1-756-592-1278', 'schimmel.cicero');
INSERT INTO `CustomerPhoneNumbers` (`phone_number`, `CustomerUsername`) VALUES ('308-785-1872x0', 'schimmel.cicero');
INSERT INTO `CustomerPhoneNumbers` (`phone_number`, `CustomerUsername`) VALUES ('373.394.8965x9', 'mya.conroy');
INSERT INTO `CustomerPhoneNumbers` (`phone_number`, `CustomerUsername`) VALUES ('728-807-2546', 'josiah.smith');
INSERT INTO `CustomerPhoneNumbers` (`phone_number`, `CustomerUsername`) VALUES ('996.859.8073x0', 'mya.conroy');


#
# TABLE STRUCTURE FOR: Customers
#

DROP TABLE IF EXISTS `Customers`;

CREATE TABLE `Customers` (
  `username` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `password` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(150) COLLATE utf8_unicode_ci NOT NULL,
  `first_name` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_name` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `postal_code` char(10) COLLATE utf8_unicode_ci NOT NULL,
  `gender` enum('man','woman') COLLATE utf8_unicode_ci DEFAULT NULL,
  `credit` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `Customers` (`username`, `password`, `email`, `first_name`, `last_name`, `postal_code`, `gender`, `credit`) VALUES ('josiah.smith', 'ba8e6bf9bd6cb7559f9693bc84b5dc0bcaddefba', 'ostiedemann@example.org', 'Cecil', 'Gerlach', 'iokq', 'woman', 9247837);
INSERT INTO `Customers` (`username`, `password`, `email`, `first_name`, `last_name`, `postal_code`, `gender`, `credit`) VALUES ('mya.conroy', '2840bfc290c7200cac7f22a6c3d8c087c10165fc', 'walker35@example.org', 'Candace', 'Roob', 'kmpy', 'man', 1089251);
INSERT INTO `Customers` (`username`, `password`, `email`, `first_name`, `last_name`, `postal_code`, `gender`, `credit`) VALUES ('schimmel.cicero', '6cff7cf8a443c8a2ac962f78171faaad4efdddf3', 'virginie.rowe@example.org', 'Maximilian', 'Rowe', 'rsrs', 'woman', 4245387);


#
# TABLE STRUCTURE FOR: Operators
#

DROP TABLE IF EXISTS `Operators`;

CREATE TABLE `Operators` (
  `id` int(10) unsigned NOT NULL,
  `shopId` int(10) unsigned NOT NULL,
  `first_name` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_name` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`,`shopId`),
  KEY `shopId` (`shopId`),
  CONSTRAINT `Operators_ibfk_1` FOREIGN KEY (`shopId`) REFERENCES `Shop` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `Operators` (`id`, `shopId`, `first_name`, `last_name`) VALUES (1, 3, 'Lenora', 'Hyatt');
INSERT INTO `Operators` (`id`, `shopId`, `first_name`, `last_name`) VALUES (2, 1, 'Turner', 'Schuppe');
INSERT INTO `Operators` (`id`, `shopId`, `first_name`, `last_name`) VALUES (3, 1, 'Jena', 'Tremblay');
INSERT INTO `Operators` (`id`, `shopId`, `first_name`, `last_name`) VALUES (4, 2, 'Aurelie', 'Trantow');
INSERT INTO `Operators` (`id`, `shopId`, `first_name`, `last_name`) VALUES (5, 2, 'Hyman', 'Dach');
INSERT INTO `Operators` (`id`, `shopId`, `first_name`, `last_name`) VALUES (6, 3, 'Lamar', 'O\'Conner');


#
# TABLE STRUCTURE FOR: Product
#

DROP TABLE IF EXISTS `Product`;

CREATE TABLE `Product` (
  `id` int(10) unsigned NOT NULL,
  `shopId` int(10) unsigned NOT NULL,
  `title` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `price` int(10) unsigned NOT NULL,
  `value` int(10) unsigned NOT NULL DEFAULT 1,
  `offer` float unsigned DEFAULT 0,
  PRIMARY KEY (`id`,`shopId`),
  KEY `shopId` (`shopId`),
  CONSTRAINT `Product_ibfk_1` FOREIGN KEY (`shopId`) REFERENCES `Shop` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `Product` (`id`, `shopId`, `title`, `price`, `value`, `offer`) VALUES (1, 2, 'architecto', 1813, 105, '0.3128');
INSERT INTO `Product` (`id`, `shopId`, `title`, `price`, `value`, `offer`) VALUES (2, 2, 'expedita', 2109, 172, '0.2');
INSERT INTO `Product` (`id`, `shopId`, `title`, `price`, `value`, `offer`) VALUES (3, 3, 'quia', 9542, 271, '0.48');
INSERT INTO `Product` (`id`, `shopId`, `title`, `price`, `value`, `offer`) VALUES (4, 3, 'autem', 9190, 289, '0.0401158');
INSERT INTO `Product` (`id`, `shopId`, `title`, `price`, `value`, `offer`) VALUES (5, 1, 'nihil', 8845, 237, '0.02424');
INSERT INTO `Product` (`id`, `shopId`, `title`, `price`, `value`, `offer`) VALUES (6, 2, 'molestiae', 2880, 202, '0');
INSERT INTO `Product` (`id`, `shopId`, `title`, `price`, `value`, `offer`) VALUES (7, 1, 'repellendus', 8231, 286, '0.25444');
INSERT INTO `Product` (`id`, `shopId`, `title`, `price`, `value`, `offer`) VALUES (8, 3, 'at', 5820, 99, '0');
INSERT INTO `Product` (`id`, `shopId`, `title`, `price`, `value`, `offer`) VALUES (9, 3, 'voluptates', 8453, 45, '0.138868');
INSERT INTO `Product` (`id`, `shopId`, `title`, `price`, `value`, `offer`) VALUES (10, 1, 'aut', 5484, 249, '0.01');
INSERT INTO `Product` (`id`, `shopId`, `title`, `price`, `value`, `offer`) VALUES (11, 1, 'quo', 4081, 124, '0.173832');
INSERT INTO `Product` (`id`, `shopId`, `title`, `price`, `value`, `offer`) VALUES (12, 1, 'et', 9023, 172, '0.237003');
INSERT INTO `Product` (`id`, `shopId`, `title`, `price`, `value`, `offer`) VALUES (13, 2, 'commodi', 4878, 32, '0.14701');
INSERT INTO `Product` (`id`, `shopId`, `title`, `price`, `value`, `offer`) VALUES (14, 1, 'error', 3899, 169, '0.1746');
INSERT INTO `Product` (`id`, `shopId`, `title`, `price`, `value`, `offer`) VALUES (15, 1, 'nisi', 8872, 276, '0.25');
INSERT INTO `Product` (`id`, `shopId`, `title`, `price`, `value`, `offer`) VALUES (16, 3, 'consequatur', 9259, 47, '0.1');
INSERT INTO `Product` (`id`, `shopId`, `title`, `price`, `value`, `offer`) VALUES (17, 2, 'atque', 7827, 226, '0.47518');
INSERT INTO `Product` (`id`, `shopId`, `title`, `price`, `value`, `offer`) VALUES (18, 2, 'exercitationem', 8572, 89, '0.09477');
INSERT INTO `Product` (`id`, `shopId`, `title`, `price`, `value`, `offer`) VALUES (19, 3, 'in', 4361, 74, '0.227194');
INSERT INTO `Product` (`id`, `shopId`, `title`, `price`, `value`, `offer`) VALUES (20, 2, 'odio', 5770, 79, '0.0154');
INSERT INTO `Product` (`id`, `shopId`, `title`, `price`, `value`, `offer`) VALUES (21, 3, 'non', 986, 177, '0.157248');


#
# TABLE STRUCTURE FOR: Shipment
#

DROP TABLE IF EXISTS `Shipment`;

CREATE TABLE `Shipment` (
  `transmitterId` int(10) unsigned NOT NULL,
  `purchase_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `customerUsername` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `shopId` int(10) unsigned NOT NULL,
  `productId` int(10) unsigned NOT NULL,
  PRIMARY KEY (`transmitterId`,`purchase_time`,`customerUsername`,`shopId`,`productId`),
  KEY `transmitterId` (`transmitterId`,`shopId`),
  KEY `purchase_time` (`purchase_time`,`customerUsername`,`shopId`,`productId`),
  CONSTRAINT `Shipment_ibfk_1` FOREIGN KEY (`transmitterId`, `shopId`) REFERENCES `Transmitters` (`id`, `shopId`),
  CONSTRAINT `Shipment_ibfk_2` FOREIGN KEY (`purchase_time`, `customerUsername`, `shopId`, `productId`) REFERENCES `CustomerOrders` (`purchase_time`, `customerUsername`, `shopId`, `productId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

#
# TABLE STRUCTURE FOR: Shop
#

DROP TABLE IF EXISTS `Shop`;

CREATE TABLE `Shop` (
  `id` int(10) unsigned NOT NULL,
  `title` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `city` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `phone_number` varchar(14) COLLATE utf8_unicode_ci NOT NULL,
  `owner` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `Shop` (`id`, `title`, `city`, `address`, `phone_number`, `owner`, `start_time`, `end_time`) VALUES (1, 'odio', 'North Edisontown', '434 Hodkiewicz Mission\nPurdyshire, SC 59466', '1-492-269-1072', 'fugit', '16:11:04', '04:52:24');
INSERT INTO `Shop` (`id`, `title`, `city`, `address`, `phone_number`, `owner`, `start_time`, `end_time`) VALUES (2, 'quia', 'East Ottilie', '6099 Annamarie Underpass Apt. 293\nLeilaniview, SC 33836-5009', '340-004-9668x3', 'sunt', '01:58:10', '17:51:09');
INSERT INTO `Shop` (`id`, `title`, `city`, `address`, `phone_number`, `owner`, `start_time`, `end_time`) VALUES (3, 'iure', 'Lake Curtville', '0888 Steuber Mount\nPort Troyfort, MN 18045-1868', '09808390637', 'ab', '18:18:17', '19:51:36');


#
# TABLE STRUCTURE FOR: Supporter
#

DROP TABLE IF EXISTS `Supporter`;

CREATE TABLE `Supporter` (
  `id` int(10) unsigned NOT NULL,
  `shopId` int(10) unsigned NOT NULL,
  `first_name` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_name` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `phone_number` varchar(14) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`,`shopId`),
  KEY `shopId` (`shopId`),
  CONSTRAINT `Supporter_ibfk_1` FOREIGN KEY (`shopId`) REFERENCES `Shop` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `Supporter` (`id`, `shopId`, `first_name`, `last_name`, `address`, `phone_number`) VALUES (1, 2, 'Urban', 'Lakin', '794 Legros Via\nLake Jarrett, PA 62853-2048', '(375)025-5759');
INSERT INTO `Supporter` (`id`, `shopId`, `first_name`, `last_name`, `address`, `phone_number`) VALUES (2, 1, 'Carolyne', 'Cassin', '5510 Macie Neck\nSouth Rylan, TN 16816', '1-202-957-1295');
INSERT INTO `Supporter` (`id`, `shopId`, `first_name`, `last_name`, `address`, `phone_number`) VALUES (3, 2, 'Corrine', 'Romaguera', '8125 Alvina Valley\nDaishabury, KS 07457-3230', '1-387-165-5962');
INSERT INTO `Supporter` (`id`, `shopId`, `first_name`, `last_name`, `address`, `phone_number`) VALUES (4, 3, 'Ray', 'Russel', '053 Brian Cliff\nTimmyport, FL 83452-5556', '651-558-9592x9');
INSERT INTO `Supporter` (`id`, `shopId`, `first_name`, `last_name`, `address`, `phone_number`) VALUES (5, 1, 'Kayley', 'Parker', '1183 Goodwin Burg\nLoishaven, WV 30721', '1-776-536-0545');
INSERT INTO `Supporter` (`id`, `shopId`, `first_name`, `last_name`, `address`, `phone_number`) VALUES (6, 3, 'Marianne', 'Mayert', '24724 Gregoria Estate\nWest Faustinostad, CO 90140-7645', '305.479.3183');


#
# TABLE STRUCTURE FOR: TemporaryCustomerOrders
#

DROP TABLE IF EXISTS `TemporaryCustomerOrders`;

CREATE TABLE `TemporaryCustomerOrders` (
  `purchase_time` timestamp NOT NULL DEFAULT current_timestamp(),
  `customerEmail` varchar(150) COLLATE utf8_unicode_ci NOT NULL,
  `shopId` int(10) unsigned NOT NULL,
  `productId` int(10) unsigned NOT NULL,
  `value` int(10) unsigned NOT NULL DEFAULT 1,
  `status` enum('accepted','rejected','sending','done') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'accepted',
  `dat` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`purchase_time`,`customerEmail`,`shopId`,`productId`),
  KEY `customerEmail` (`customerEmail`),
  KEY `shopId` (`shopId`),
  KEY `productId` (`productId`,`shopId`),
  CONSTRAINT `TemporaryCustomerOrders_ibfk_1` FOREIGN KEY (`customerEmail`) REFERENCES `TemporaryCustomers` (`email`),
  CONSTRAINT `TemporaryCustomerOrders_ibfk_2` FOREIGN KEY (`shopId`) REFERENCES `Shop` (`id`),
  CONSTRAINT `TemporaryCustomerOrders_ibfk_3` FOREIGN KEY (`productId`, `shopId`) REFERENCES `Product` (`id`, `shopId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1970-02-20 22:25:59', 'milo.abbott@example.net', 2, 2, 6, 'sending', '2014-08-11 18:18:47');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1970-03-15 02:23:29', 'coleman45@example.org', 1, 7, 5, 'rejected', '1998-07-13 12:33:45');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1970-03-19 15:19:42', 'coleman45@example.org', 1, 10, 7, 'accepted', '2007-08-29 00:54:55');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1970-07-07 16:57:58', 'ufay@example.com', 3, 3, 6, 'rejected', '2006-08-29 07:00:57');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1970-11-10 22:36:35', 'milo.abbott@example.net', 2, 17, 8, 'accepted', '1994-10-10 23:02:55');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1971-07-14 21:55:15', 'coleman45@example.org', 1, 10, 4, 'rejected', '1985-09-20 02:34:36');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1972-06-28 11:32:00', 'ufay@example.com', 3, 9, 8, 'sending', '1973-09-17 09:13:22');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1972-07-14 03:35:35', 'ufay@example.com', 3, 21, 2, 'rejected', '2012-04-19 17:51:08');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1972-11-11 21:02:03', 'ufay@example.com', 3, 21, 2, 'rejected', '1999-01-28 23:59:41');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1972-12-27 23:37:29', 'coleman45@example.org', 1, 7, 9, 'sending', '2007-07-31 07:19:17');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1973-07-06 03:04:11', 'ufay@example.com', 3, 21, 4, 'rejected', '1988-06-25 13:59:51');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1973-07-20 03:26:17', 'coleman45@example.org', 1, 10, 8, 'rejected', '2018-02-02 03:14:14');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1973-10-05 19:01:47', 'milo.abbott@example.net', 2, 20, 3, 'accepted', '2003-06-01 16:27:08');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1974-01-27 10:30:25', 'coleman45@example.org', 1, 7, 8, 'accepted', '2012-06-08 02:07:28');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1976-02-20 13:31:26', 'milo.abbott@example.net', 2, 2, 4, 'sending', '1998-11-09 20:45:24');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1976-07-27 04:39:44', 'coleman45@example.org', 1, 10, 6, 'done', '1995-06-26 04:47:13');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1976-09-26 21:06:00', 'milo.abbott@example.net', 2, 2, 3, 'rejected', '2013-11-17 15:46:48');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1976-11-06 11:04:55', 'coleman45@example.org', 1, 7, 6, 'accepted', '1987-02-20 18:31:00');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1976-11-26 20:21:07', 'ufay@example.com', 3, 9, 2, 'accepted', '2002-07-12 13:02:53');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1976-12-03 00:50:40', 'milo.abbott@example.net', 2, 17, 6, 'accepted', '2007-09-17 12:30:44');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1977-02-23 02:04:21', 'ufay@example.com', 3, 3, 5, 'accepted', '1972-07-08 13:58:26');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1978-03-24 02:45:22', 'coleman45@example.org', 1, 10, 5, 'done', '1999-07-27 03:07:21');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1978-04-05 03:39:51', 'milo.abbott@example.net', 2, 20, 9, 'accepted', '1977-09-05 02:07:23');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1978-08-01 18:47:33', 'coleman45@example.org', 1, 7, 7, 'done', '1990-09-01 18:46:19');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1978-08-19 18:29:43', 'milo.abbott@example.net', 2, 2, 7, 'accepted', '1979-02-27 13:03:25');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1978-11-13 16:46:53', 'coleman45@example.org', 1, 10, 6, 'rejected', '1975-03-04 12:40:13');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1979-06-12 17:06:41', 'ufay@example.com', 3, 21, 7, 'done', '1985-11-27 12:37:26');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1979-08-30 21:00:12', 'milo.abbott@example.net', 2, 17, 10, 'rejected', '1989-07-13 04:31:50');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1979-11-10 03:23:00', 'coleman45@example.org', 1, 7, 9, 'rejected', '2007-08-16 07:29:25');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1981-09-04 13:52:05', 'ufay@example.com', 3, 21, 2, 'accepted', '1993-12-31 18:37:51');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1981-12-01 21:25:14', 'coleman45@example.org', 1, 7, 4, 'rejected', '1982-11-18 15:52:38');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1982-04-11 08:32:30', 'milo.abbott@example.net', 2, 17, 8, 'accepted', '1978-02-11 11:23:36');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1982-06-20 02:20:26', 'milo.abbott@example.net', 2, 20, 10, 'done', '2011-02-24 03:15:49');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1982-07-20 13:31:26', 'ufay@example.com', 3, 9, 4, 'accepted', '1996-09-26 15:10:52');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1983-05-21 14:21:51', 'milo.abbott@example.net', 2, 2, 8, 'accepted', '2014-06-07 08:18:08');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1983-08-04 15:13:41', 'milo.abbott@example.net', 2, 20, 3, 'sending', '1995-10-11 13:11:24');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1984-01-30 14:30:52', 'ufay@example.com', 3, 9, 5, 'rejected', '2015-11-29 05:38:17');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1984-02-10 18:00:52', 'ufay@example.com', 3, 21, 7, 'rejected', '1977-08-18 03:15:09');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1984-04-16 12:22:24', 'coleman45@example.org', 1, 7, 9, 'accepted', '2016-08-16 03:05:31');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1985-01-29 21:57:08', 'ufay@example.com', 3, 21, 5, 'done', '2012-04-05 20:04:50');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1986-03-18 17:05:28', 'milo.abbott@example.net', 2, 17, 7, 'rejected', '1991-09-28 06:27:31');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1987-03-22 13:48:32', 'ufay@example.com', 3, 21, 8, 'done', '1994-09-17 05:53:11');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1987-05-17 05:12:34', 'coleman45@example.org', 1, 7, 5, 'accepted', '1980-05-13 08:35:12');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1989-09-01 05:22:35', 'ufay@example.com', 3, 9, 8, 'sending', '2000-01-17 17:18:56');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1989-12-05 03:56:47', 'coleman45@example.org', 1, 10, 2, 'rejected', '2010-05-10 03:09:29');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1989-12-23 17:42:43', 'ufay@example.com', 3, 9, 4, 'rejected', '2017-03-23 12:55:19');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1990-02-28 04:34:16', 'coleman45@example.org', 1, 10, 7, 'accepted', '2002-02-15 10:31:35');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1990-06-10 20:03:36', 'milo.abbott@example.net', 2, 2, 6, 'accepted', '2005-07-03 13:00:50');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1990-07-01 23:47:59', 'coleman45@example.org', 1, 10, 9, 'sending', '1997-01-09 06:29:37');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1990-09-23 21:44:58', 'ufay@example.com', 3, 3, 9, 'rejected', '1973-02-19 13:33:22');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1991-01-31 04:37:21', 'milo.abbott@example.net', 2, 2, 3, 'sending', '1999-11-08 02:00:08');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1991-03-04 21:53:53', 'ufay@example.com', 3, 21, 1, 'rejected', '2005-10-29 04:39:24');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1991-06-10 04:01:25', 'ufay@example.com', 3, 3, 5, 'sending', '2002-06-18 07:31:32');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1991-10-06 02:56:10', 'ufay@example.com', 3, 3, 1, 'rejected', '2000-11-15 22:51:55');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1991-10-06 09:54:29', 'ufay@example.com', 3, 9, 5, 'done', '1987-02-18 03:44:18');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1991-12-05 18:02:38', 'milo.abbott@example.net', 2, 20, 2, 'rejected', '1974-08-23 09:36:00');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1992-03-06 05:16:01', 'ufay@example.com', 3, 21, 8, 'rejected', '2012-12-31 17:01:10');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1992-03-21 00:45:36', 'ufay@example.com', 3, 3, 6, 'done', '2013-03-15 03:54:12');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1992-11-12 04:26:11', 'milo.abbott@example.net', 2, 17, 3, 'rejected', '1978-09-16 15:50:44');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1993-01-09 04:39:43', 'ufay@example.com', 3, 21, 5, 'done', '1991-03-26 08:55:21');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1993-02-04 00:38:20', 'ufay@example.com', 3, 3, 9, 'sending', '2008-06-04 06:26:02');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1993-10-11 04:09:32', 'milo.abbott@example.net', 2, 20, 5, 'accepted', '1981-01-23 11:22:37');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1993-12-24 15:01:24', 'ufay@example.com', 3, 3, 8, 'accepted', '1976-05-16 06:34:19');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1993-12-31 08:29:04', 'milo.abbott@example.net', 2, 17, 2, 'done', '2007-07-01 06:33:21');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1994-10-11 17:22:31', 'ufay@example.com', 3, 9, 6, 'accepted', '1981-03-26 16:10:01');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1995-03-29 23:16:51', 'ufay@example.com', 3, 9, 7, 'sending', '2010-05-20 21:10:16');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1995-07-07 11:52:46', 'coleman45@example.org', 1, 10, 10, 'rejected', '2006-06-19 12:27:03');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1995-07-08 12:17:31', 'ufay@example.com', 3, 3, 5, 'rejected', '1995-08-29 14:08:01');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1995-12-14 03:12:56', 'coleman45@example.org', 1, 10, 7, 'accepted', '2006-06-24 07:49:14');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1996-09-01 22:11:52', 'milo.abbott@example.net', 2, 20, 8, 'rejected', '2005-01-05 20:43:14');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1997-02-04 13:33:29', 'ufay@example.com', 3, 3, 6, 'done', '1978-07-27 13:02:23');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1997-12-02 04:11:18', 'milo.abbott@example.net', 2, 17, 2, 'rejected', '1999-06-11 07:25:46');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1999-05-11 02:41:26', 'milo.abbott@example.net', 2, 20, 4, 'done', '1983-07-14 13:42:01');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('1999-11-11 15:26:13', 'coleman45@example.org', 1, 7, 1, 'rejected', '1992-09-02 04:34:22');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('2000-04-03 16:57:17', 'ufay@example.com', 3, 21, 8, 'rejected', '2001-12-13 21:56:15');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('2000-05-27 07:18:21', 'milo.abbott@example.net', 2, 17, 2, 'rejected', '2003-04-21 05:28:56');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('2000-08-25 14:43:39', 'milo.abbott@example.net', 2, 20, 3, 'done', '2013-10-01 04:05:40');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('2000-09-25 19:56:21', 'milo.abbott@example.net', 2, 20, 7, 'rejected', '1987-07-07 06:05:03');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('2002-02-10 19:13:09', 'coleman45@example.org', 1, 7, 7, 'rejected', '2000-08-30 19:22:11');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('2002-02-12 06:04:25', 'milo.abbott@example.net', 2, 17, 10, 'rejected', '1972-05-25 03:05:16');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('2002-06-18 06:00:36', 'ufay@example.com', 3, 9, 1, 'accepted', '1973-07-04 23:34:03');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('2002-08-04 18:58:20', 'ufay@example.com', 3, 21, 1, 'accepted', '2002-06-25 06:51:52');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('2002-10-01 19:22:11', 'coleman45@example.org', 1, 7, 2, 'rejected', '1996-07-29 04:04:44');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('2005-01-02 15:42:54', 'milo.abbott@example.net', 2, 17, 4, 'done', '2007-10-26 20:27:20');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('2005-08-09 17:22:10', 'milo.abbott@example.net', 2, 17, 6, 'accepted', '1996-12-28 10:07:26');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('2005-09-13 23:58:26', 'milo.abbott@example.net', 2, 20, 3, 'rejected', '2015-09-18 12:47:07');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('2006-02-27 06:21:51', 'ufay@example.com', 3, 9, 4, 'sending', '1998-09-23 23:08:01');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('2006-03-11 21:01:46', 'coleman45@example.org', 1, 7, 2, 'accepted', '2009-02-12 21:17:29');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('2006-06-11 10:07:31', 'milo.abbott@example.net', 2, 20, 9, 'accepted', '1975-06-24 07:18:06');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('2006-10-21 20:56:48', 'coleman45@example.org', 1, 10, 7, 'accepted', '2012-02-10 09:22:20');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('2007-04-24 04:10:54', 'ufay@example.com', 3, 3, 1, 'accepted', '1985-05-10 02:22:48');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('2007-05-31 04:50:33', 'milo.abbott@example.net', 2, 20, 4, 'accepted', '1991-09-30 00:29:02');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('2008-10-30 21:21:01', 'ufay@example.com', 3, 9, 9, 'rejected', '2013-11-23 05:36:00');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('2009-07-17 00:30:53', 'coleman45@example.org', 1, 10, 6, 'accepted', '2004-11-01 10:32:54');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('2010-02-16 12:23:37', 'ufay@example.com', 3, 21, 1, 'rejected', '1979-01-04 15:11:42');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('2010-10-04 03:02:33', 'milo.abbott@example.net', 2, 2, 1, 'rejected', '1988-10-11 18:28:54');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('2011-06-03 02:44:27', 'coleman45@example.org', 1, 7, 6, 'accepted', '1986-12-08 21:29:11');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('2011-06-29 21:26:44', 'milo.abbott@example.net', 2, 17, 1, 'sending', '1997-05-29 06:07:18');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('2012-07-25 17:20:44', 'milo.abbott@example.net', 2, 2, 1, 'done', '2014-05-07 00:27:39');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('2012-12-19 01:49:03', 'milo.abbott@example.net', 2, 17, 1, 'rejected', '2008-01-15 22:11:53');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('2013-02-15 07:29:36', 'ufay@example.com', 3, 3, 10, 'rejected', '1986-02-23 04:13:31');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('2013-08-13 21:20:46', 'milo.abbott@example.net', 2, 2, 6, 'done', '2006-03-17 14:05:31');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('2014-01-28 23:21:06', 'milo.abbott@example.net', 2, 20, 8, 'done', '1974-11-02 03:14:40');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('2014-04-16 04:28:14', 'milo.abbott@example.net', 2, 2, 2, 'accepted', '2009-03-23 18:24:48');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('2015-01-22 15:00:42', 'ufay@example.com', 3, 3, 8, 'rejected', '2005-05-05 23:36:10');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('2015-07-03 19:05:20', 'milo.abbott@example.net', 2, 2, 1, 'sending', '1975-11-24 05:24:23');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('2015-12-14 19:43:29', 'milo.abbott@example.net', 2, 2, 9, 'sending', '1999-10-15 21:22:55');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('2017-01-08 21:46:36', 'milo.abbott@example.net', 2, 2, 1, 'rejected', '2008-02-22 05:36:59');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('2017-07-10 19:35:37', 'milo.abbott@example.net', 2, 2, 2, 'rejected', '1991-07-28 05:45:55');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('2017-11-18 06:21:59', 'ufay@example.com', 3, 9, 5, 'rejected', '1975-02-11 23:32:04');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('2018-01-22 13:25:35', 'coleman45@example.org', 1, 10, 8, 'accepted', '1986-03-18 10:10:20');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('2018-08-03 23:51:32', 'ufay@example.com', 3, 3, 8, 'rejected', '2014-01-07 16:05:39');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('2018-10-26 07:42:00', 'ufay@example.com', 3, 9, 6, 'sending', '1991-06-25 19:24:30');
INSERT INTO `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`, `value`, `status`, `dat`) VALUES ('2019-01-09 18:57:43', 'ufay@example.com', 3, 3, 4, 'accepted', '2002-08-15 23:50:54');


#
# TABLE STRUCTURE FOR: TemporaryCustomers
#

DROP TABLE IF EXISTS `TemporaryCustomers`;

CREATE TABLE `TemporaryCustomers` (
  `email` varchar(150) COLLATE utf8_unicode_ci NOT NULL,
  `first_name` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_name` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `postal_code` char(10) COLLATE utf8_unicode_ci NOT NULL,
  `gender` enum('man','woman') COLLATE utf8_unicode_ci DEFAULT 'man',
  `address` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `phone_number` varchar(14) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `TemporaryCustomers` (`email`, `first_name`, `last_name`, `postal_code`, `gender`, `address`, `phone_number`) VALUES ('coleman45@example.org', 'Kali', 'Schmidt', 'pmgb', 'man', '245 Hoeger Estate\nSouth Jailynfurt, OR 86320-0286', '057.961.3195x6');
INSERT INTO `TemporaryCustomers` (`email`, `first_name`, `last_name`, `postal_code`, `gender`, `address`, `phone_number`) VALUES ('milo.abbott@example.net', 'Hosea', 'Botsford', 'kmav', 'woman', '1699 Hahn Skyway Suite 543\nReynoldshaven, ID 89834', '1-395-911-0992');
INSERT INTO `TemporaryCustomers` (`email`, `first_name`, `last_name`, `postal_code`, `gender`, `address`, `phone_number`) VALUES ('ufay@example.com', 'Ewell', 'Johnson', 'szoa', 'man', '704 Watsica Locks Suite 729\nEast Ila, MI 98434', '1-080-682-4780');


#
# TABLE STRUCTURE FOR: TemporaryShipment
#

DROP TABLE IF EXISTS `TemporaryShipment`;

CREATE TABLE `TemporaryShipment` (
  `transmitterId` int(10) unsigned NOT NULL,
  `purchase_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `customerEmail` varchar(150) COLLATE utf8_unicode_ci NOT NULL,
  `shopId` int(10) unsigned NOT NULL,
  `productId` int(10) unsigned NOT NULL,
  PRIMARY KEY (`transmitterId`,`purchase_time`,`customerEmail`,`shopId`,`productId`),
  KEY `transmitterId` (`transmitterId`,`shopId`),
  KEY `purchase_time` (`purchase_time`,`customerEmail`,`shopId`,`productId`),
  CONSTRAINT `TemporaryShipment_ibfk_1` FOREIGN KEY (`transmitterId`, `shopId`) REFERENCES `Transmitters` (`id`, `shopId`),
  CONSTRAINT `TemporaryShipment_ibfk_2` FOREIGN KEY (`purchase_time`, `customerEmail`, `shopId`, `productId`) REFERENCES `TemporaryCustomerOrders` (`purchase_time`, `customerEmail`, `shopId`, `productId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

#
# TABLE STRUCTURE FOR: Transmitters
#

DROP TABLE IF EXISTS `Transmitters`;

CREATE TABLE `Transmitters` (
  `id` int(10) unsigned NOT NULL,
  `shopId` int(10) unsigned NOT NULL,
  `first_name` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_name` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phone_number` varchar(14) COLLATE utf8_unicode_ci NOT NULL,
  `status` enum('free','sending') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'sending',
  `credit` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`,`shopId`),
  KEY `shopId` (`shopId`),
  CONSTRAINT `Transmitters_ibfk_1` FOREIGN KEY (`shopId`) REFERENCES `Shop` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `Transmitters` (`id`, `shopId`, `first_name`, `last_name`, `phone_number`, `status`, `credit`) VALUES (1, 1, 'Lance', 'Raynor', '(624)662-5245x', 'free', 9202980);
INSERT INTO `Transmitters` (`id`, `shopId`, `first_name`, `last_name`, `phone_number`, `status`, `credit`) VALUES (2, 3, 'Amanda', 'Weimann', '1-764-593-3910', 'sending', 9970566);
INSERT INTO `Transmitters` (`id`, `shopId`, `first_name`, `last_name`, `phone_number`, `status`, `credit`) VALUES (3, 2, 'Brittany', 'Hodkiewicz', '337.040.5166', 'sending', 8146626);
INSERT INTO `Transmitters` (`id`, `shopId`, `first_name`, `last_name`, `phone_number`, `status`, `credit`) VALUES (4, 3, 'Haven', 'Windler', '239.060.9454x4', 'sending', 99458);
INSERT INTO `Transmitters` (`id`, `shopId`, `first_name`, `last_name`, `phone_number`, `status`, `credit`) VALUES (5, 1, 'Nat', 'Stokes', '405-213-7433x7', 'sending', 8351239);
INSERT INTO `Transmitters` (`id`, `shopId`, `first_name`, `last_name`, `phone_number`, `status`, `credit`) VALUES (6, 2, 'Elijah', 'Koelpin', '(396)377-4131', 'sending', 7286728);
INSERT INTO `Transmitters` (`id`, `shopId`, `first_name`, `last_name`, `phone_number`, `status`, `credit`) VALUES (7, 1, 'Pansy', 'Connelly', '835-759-2005', 'sending', 2120590);
INSERT INTO `Transmitters` (`id`, `shopId`, `first_name`, `last_name`, `phone_number`, `status`, `credit`) VALUES (8, 2, 'Salvador', 'Kovacek', '1-071-458-8055', 'free', 8257145);
INSERT INTO `Transmitters` (`id`, `shopId`, `first_name`, `last_name`, `phone_number`, `status`, `credit`) VALUES (9, 1, 'Ceasar', 'Gibson', '1-753-666-2179', 'free', 9695873);
INSERT INTO `Transmitters` (`id`, `shopId`, `first_name`, `last_name`, `phone_number`, `status`, `credit`) VALUES (10, 3, 'Casandra', 'King', '1-959-439-5952', 'free', 1798218);
INSERT INTO `Transmitters` (`id`, `shopId`, `first_name`, `last_name`, `phone_number`, `status`, `credit`) VALUES (11, 3, 'Paige', 'Dickens', '1-694-035-6246', 'sending', 8213997);
INSERT INTO `Transmitters` (`id`, `shopId`, `first_name`, `last_name`, `phone_number`, `status`, `credit`) VALUES (12, 2, 'Timmy', 'Metz', '(946)965-9404', 'free', 2859275);
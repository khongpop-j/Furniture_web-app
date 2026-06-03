-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host: localhost    Database: furniture_office
-- ------------------------------------------------------
-- Server version	8.0.43

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `_prisma_migrations`
--

DROP TABLE IF EXISTS `_prisma_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_prisma_migrations` (
  `id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `checksum` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `finished_at` datetime(3) DEFAULT NULL,
  `migration_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `logs` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `rolled_back_at` datetime(3) DEFAULT NULL,
  `started_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `applied_steps_count` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `_prisma_migrations`
--

LOCK TABLES `_prisma_migrations` WRITE;
/*!40000 ALTER TABLE `_prisma_migrations` DISABLE KEYS */;
INSERT INTO `_prisma_migrations` VALUES ('026014b9-bd10-4992-b5fe-c6506707e214','18b0688fd674f1f53e4c85435a1dd432c350526e733d37f2af4bfa32eb4ba68a','2025-10-09 12:56:11.650','20250731101451_',NULL,NULL,'2025-10-09 12:56:10.690',1),('3077a016-8177-42f1-94b5-4fad103712c0','34808e246df4884f5f4dfd872a8e5287f078b01cfc78ecd062a345430ca147c1','2025-10-12 08:57:10.082','20251012085710_add_favorites',NULL,NULL,'2025-10-12 08:57:10.057',1),('8bcb9570-9a70-4e79-b00a-bc0e31a7b466','8292b0ef5936ec2e837653c79466414b664cf02ba9216fc6ecbe691e17fba8c9','2025-10-09 12:56:11.886','20251001053820_add_password_reset_fields',NULL,NULL,'2025-10-09 12:56:11.784',1),('9a30bd9c-b6af-4bd7-9c60-d782d730b8d1','cef4944b8e9a87b5bda0728673b6bbaf7f743e22360ebe552b82a759f0b7319f','2025-10-09 13:01:33.043','20251009130132_add_user_fields_and_favorites',NULL,NULL,'2025-10-09 13:01:32.668',1),('a741ccdb-2d54-4c82-b69e-c9f59554458b','233837a47bd97dcbf2900dfd56a2453271e63af9f3b9b4a0246c0b0edd72d432','2025-10-14 07:53:47.115','20251014075347_add_payment_table',NULL,NULL,'2025-10-14 07:53:47.068',1),('f10526db-0ca6-49f2-8472-2fd2ddb12b2c','69ffcbb8f18f48e0a27686b0d1c679f7a6a1e9559aa7d8f05510ee3f4b1ba299','2025-10-09 12:56:11.780','20250919052746_add_password_to_users',NULL,NULL,'2025-10-09 12:56:11.655',1);
/*!40000 ALTER TABLE `_prisma_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart_items`
--

DROP TABLE IF EXISTS `cart_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `productId` int NOT NULL,
  `quantity` int NOT NULL DEFAULT '1',
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  `userId` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `cart_items_productId_fkey` (`productId`),
  KEY `cart_items_userId_fkey` (`userId`),
  CONSTRAINT `cart_items_productId_fkey` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `cart_items_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=104 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_items`
--

LOCK TABLES `cart_items` WRITE;
/*!40000 ALTER TABLE `cart_items` DISABLE KEYS */;
INSERT INTO `cart_items` VALUES (83,3,2,'2025-10-28 09:25:07.202','2025-10-28 09:25:07.202',9);
/*!40000 ALTER TABLE `cart_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contacts`
--

DROP TABLE IF EXISTS `contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contacts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contacts`
--

LOCK TABLES `contacts` WRITE;
/*!40000 ALTER TABLE `contacts` DISABLE KEYS */;
INSERT INTO `contacts` VALUES (1,'nattapat kluabthong','nattapatntp2@gmail.com','096-399-1916','แก้','2025-10-12 09:48:51.060'),(2,'nattapat kluabthong','nattapatntp2@gmail.com','081-234-5678','ฟก','2025-10-12 09:49:35.802'),(3,'nattapat kluabthong','potae.monkeyking@gmail.com','081-234-5678','ฟไกฟไ','2025-10-12 09:51:10.937'),(4,'nattapat kluabthong','nattapatntp2@gmail.com','081-234-5678','ฟไกฟไก','2025-10-12 09:57:16.877'),(5,'nattapat kluabthong','potae.monkeyking@gmail.com','0984435124','ฟไกฟไ','2025-10-12 09:59:56.724'),(6,'nattapat kluabthong','potae.monkeyking@gmail.com','0984435124','ฟไกฟไ','2025-10-12 09:59:58.867'),(7,'nattapat kluabthong','nattapatntp2@gmail.com','0984435124','เว็บกากๆ','2025-10-12 10:00:30.746'),(8,'nattapat kluabthong','potae.monkeyking@gmail.com','0984435124','awdawdawd','2025-10-12 10:35:03.261'),(9,'wda','nattapatntp2@gmail.com','123','123','2025-10-27 10:39:24.538');
/*!40000 ALTER TABLE `contacts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `favorites`
--

DROP TABLE IF EXISTS `favorites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `favorites` (
  `id` int NOT NULL AUTO_INCREMENT,
  `userId` int NOT NULL,
  `productId` int NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `favorites_userId_productId_key` (`userId`,`productId`),
  KEY `favorites_userId_fkey` (`userId`),
  KEY `favorites_productId_fkey` (`productId`),
  CONSTRAINT `favorites_productId_fkey` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `favorites_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favorites`
--

LOCK TABLES `favorites` WRITE;
/*!40000 ALTER TABLE `favorites` DISABLE KEYS */;
INSERT INTO `favorites` VALUES (22,2,1,'2025-10-24 15:47:10.399'),(23,2,21,'2025-10-24 16:25:17.371'),(26,9,1,'2025-10-28 09:24:33.944'),(31,1,1,'2025-10-28 10:08:52.195'),(33,1,3,'2025-10-28 10:09:04.698');
/*!40000 ALTER TABLE `favorites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `orderId` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `productId` int NOT NULL,
  `name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `quantity` int NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `order_items_orderId_fkey` (`orderId`),
  KEY `order_items_productId_fkey` (`productId`),
  CONSTRAINT `order_items_orderId_fkey` FOREIGN KEY (`orderId`) REFERENCES `orders` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `order_items_productId_fkey` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES (26,'cmh524lqp0001vpowwh0pe25f',1,'ตู้เอกสารเตี้ย',3500.00,6,'2025-10-24 16:20:14.731'),(27,'cmh536klp0001vp4sv9bwbecs',2,'ตู้เอกสารสูง',4450.00,3,'2025-10-24 16:49:46.185'),(28,'cmh53fcxi0001vp1ogislecpm',2,'ตู้เอกสารสูง',4450.00,2,'2025-10-24 16:56:36.150'),(29,'cmh8u3tin0001vpyw8c5v8tne',1,'ตู้เอกสารเตี้ย',3500.00,4,'2025-10-27 07:46:45.933'),(30,'cmh8yo1f20001ve9sklhbaqeo',1,'ตู้เอกสารเตี้ย',3500.00,4,'2025-10-27 09:54:27.758'),(31,'cmh8ysl0m0003ve9sdedjxpoq',1,'ตู้เอกสารเตี้ย',3500.00,3,'2025-10-27 09:57:59.782'),(32,'cmh8ysl0m0003ve9sdedjxpoq',4,'ตู้ล็อกเกอร์ 18 ช่อง',7500.00,4,'2025-10-27 09:57:59.782'),(33,'cmh8yvk750005ve9sme6f1pof',2,'ตู้เอกสารสูง',4450.00,2,'2025-10-27 10:00:18.689'),(34,'cmh8yxyls0001vekcr0sde4fe',2,'ตู้เอกสารสูง',4450.00,1,'2025-10-27 10:02:10.672'),(35,'cmh8z08k00003vekcjap0d4du',1,'ตู้เอกสารเตี้ย',3500.00,1,'2025-10-27 10:03:56.881'),(36,'cmh8z3fh50001ve7o2mqvq33t',1,'ตู้เอกสารเตี้ย',3500.00,1,'2025-10-27 10:06:25.818'),(37,'cmh8z4nck0003ve7oenjl5qb0',2,'ตู้เอกสารสูง',4450.00,1,'2025-10-27 10:07:22.677'),(38,'cmh8z87in0001ve24x7ulrb05',1,'ตู้เอกสารเตี้ย',3500.00,1,'2025-10-27 10:10:08.784'),(39,'cmh8zg15o0001veu8n2yzsoh2',2,'ตู้เอกสารสูง',4450.00,1,'2025-10-27 10:16:13.788'),(40,'cmh8zhvhu0001vepoozk5enqb',3,'ตู้เอกสาร 2 บานเปิด',2350.00,2,'2025-10-27 10:17:39.763'),(41,'cmh8ztzr10001veto5tfie30i',4,'ตู้ล็อกเกอร์ 18 ช่อง',7500.00,1,'2025-10-27 10:27:05.149'),(42,'cmh8ztzr10001veto5tfie30i',3,'ตู้เอกสาร 2 บานเปิด',2350.00,1,'2025-10-27 10:27:05.149'),(43,'cmh9050uq0001vegsr4sj0bjk',3,'ตู้เอกสาร 2 บานเปิด',2350.00,1,'2025-10-27 10:35:39.794'),(44,'cmh9082mn0003vegszzp847ei',20,'เก้าอี้ทำงาน KFT',3400.00,1,'2025-10-27 10:38:02.063'),(45,'cmhd663w40001veu0b1fio1eo',19,'เก้าอี้ทำงาน KFT',3600.00,1,'2025-10-30 08:35:32.788'),(46,'cmhd9ck6y0001veb4xdtc0dtd',3,'ตู้เอกสาร 2 บานเปิด',2350.00,6,'2025-10-30 10:04:32.698'),(47,'cmhd9hyog0001vegwcw328py1',4,'ตู้ล็อกเกอร์ 18 ช่อง',7500.00,1,'2025-10-30 10:08:44.753'),(48,'cmhd9iqcd0003vegwyaot8gxt',4,'ตู้ล็อกเกอร์ 18 ช่อง',7500.00,1,'2025-10-30 10:09:20.605'),(49,'cmhd9k5a40005vegw6t0wl2d2',4,'ตู้ล็อกเกอร์ 18 ช่อง',7500.00,1,'2025-10-30 10:10:26.621'),(50,'cmhd9nnyx0001vedg6n99celw',4,'ตู้ล็อกเกอร์ 18 ช่อง',7500.00,1,'2025-10-30 10:13:10.809'),(51,'cmhd9w0cg0001ve9k1pfesfyi',4,'ตู้ล็อกเกอร์ 18 ช่อง',7500.00,1,'2025-10-30 10:19:40.096'),(52,'cmhd9ym5s0001vee0bedj7hoq',4,'ตู้ล็อกเกอร์ 18 ช่อง',7500.00,2,'2025-10-30 10:21:41.681'),(53,'cmhda18cy0001ve7skcb8j1zp',4,'ตู้ล็อกเกอร์ 18 ช่อง',7500.00,1,'2025-10-30 10:23:43.762'),(54,'cmhda3jo00001ve9ckq3zbl1u',4,'ตู้ล็อกเกอร์ 18 ช่อง',7500.00,1,'2025-10-30 10:25:31.728'),(55,'cmhdaaq5h0001ve88j5delz3x',4,'ตู้ล็อกเกอร์ 18 ช่อง',7500.00,1,'2025-10-30 10:31:06.725'),(56,'cmhdaepph0001ve7ckky3ewuc',4,'ตู้ล็อกเกอร์ 18 ช่อง',7500.00,1,'2025-10-30 10:34:12.773'),(57,'cmhdak9gw0003ve7c2u81zaig',4,'ตู้ล็อกเกอร์ 18 ช่อง',7500.00,1,'2025-10-30 10:38:31.664'),(58,'cmhdaluj00005ve7c32h71vq9',4,'ตู้ล็อกเกอร์ 18 ช่อง',7500.00,1,'2025-10-30 10:39:45.613'),(59,'cmhdaqgj80001ve28vtyswld3',4,'ตู้ล็อกเกอร์ 18 ช่อง',7500.00,1,'2025-10-30 10:43:20.756');
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `userId` int NOT NULL,
  `total` decimal(10,2) NOT NULL,
  `status` enum('PENDING','CONFIRMED','SHIPPED','DELIVERED','CANCELLED') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING',
  `shippingAddress` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  `deliveryDetails` text COLLATE utf8mb4_unicode_ci,
  `deliveryMethod` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `orders_userId_fkey` (`userId`),
  CONSTRAINT `orders_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES ('cmgnhr5l50001vphos5235p4a',1,3500.00,'SHIPPED','ที่อยู่จัดส่ง (กรุณาไปแก้ไขในโปรไฟล์)','2025-10-12 09:17:49.960','2025-10-12 09:25:43.729',NULL,NULL),('cmgnhu7ap0003vphoahth0o94',1,7950.00,'DELIVERED','ที่อยู่จัดส่ง (กรุณาไปแก้ไขในโปรไฟล์)','2025-10-12 09:20:12.145','2025-10-12 09:25:40.389',NULL,NULL),('cmgnhv2gj0005vpho95wxna79',1,13850.00,'CONFIRMED','ที่อยู่จัดส่ง (กรุณาไปแก้ไขในโปรไฟล์)','2025-10-12 09:20:52.532','2025-10-12 09:25:36.192',NULL,NULL),('cmgnj05qe0001vppg6kesiy1n',3,4450.00,'SHIPPED','ที่อยู่จัดส่ง (กรุณาไปแก้ไขในโปรไฟล์)','2025-10-12 09:52:49.670','2025-10-12 09:58:01.841',NULL,NULL),('cmgnjiis90001vp6o9mlp326s',3,17500.00,'CONFIRMED','ที่อยู่จัดส่ง (กรุณาไปแก้ไขในโปรไฟล์)','2025-10-12 10:07:06.393','2025-10-12 10:07:32.250',NULL,NULL),('cmgnjmpj50003vp6ofahggp1j',3,10500.00,'PENDING','ที่อยู่จัดส่ง (กรุณาไปแก้ไขในโปรไฟล์)','2025-10-12 10:10:21.761','2025-10-12 10:10:21.761',NULL,NULL),('cmgnjre9j0005vp6orzm5val9',3,14000.00,'PENDING','ที่อยู่จัดส่ง (กรุณาไปแก้ไขในโปรไฟล์)','2025-10-12 10:14:00.440','2025-10-12 10:14:00.440',NULL,NULL),('cmgnjxklq0001vpao7weu8dgd',3,17500.00,'PENDING','ที่อยู่จัดส่ง (กรุณาไปแก้ไขในโปรไฟล์)','2025-10-12 10:18:48.590','2025-10-12 10:18:48.590',NULL,NULL),('cmgnjy56o0003vpaoe8kw6dlz',3,40050.00,'PENDING','ที่อยู่จัดส่ง (กรุณาไปแก้ไขในโปรไฟล์)','2025-10-12 10:19:15.265','2025-10-12 10:19:15.265',NULL,NULL),('cmgnk2s410001vp54eysjgfqq',3,7000.00,'PENDING','ที่อยู่จัดส่ง (กรุณาไปแก้ไขในโปรไฟล์)','2025-10-12 10:22:51.601','2025-10-12 10:22:51.601',NULL,NULL),('cmgnk2s470003vp5462ads1tk',3,7000.00,'PENDING','ที่อยู่จัดส่ง (กรุณาไปแก้ไขในโปรไฟล์)','2025-10-12 10:22:51.607','2025-10-12 10:22:51.607',NULL,NULL),('cmgnk66m00001vpfk4qzzt5fe',3,11750.00,'PENDING','ที่อยู่จัดส่ง (กรุณาไปแก้ไขในโปรไฟล์)','2025-10-12 10:25:30.360','2025-10-12 10:25:30.360',NULL,NULL),('cmgnk91990001vpj0f9p27xhw',3,4700.00,'PENDING','ที่อยู่จัดส่ง (กรุณาไปแก้ไขในโปรไฟล์)','2025-10-12 10:27:43.390','2025-10-12 10:27:43.390',NULL,NULL),('cmgnkdmix0001vpdgvk5t366t',3,3500.00,'PENDING','ที่อยู่จัดส่ง (กรุณาไปแก้ไขในโปรไฟล์)','2025-10-12 10:31:17.577','2025-10-12 10:31:17.577',NULL,NULL),('cmgnkeq2p0003vpdgwdwnkj2f',3,37500.00,'PENDING','ที่อยู่จัดส่ง (กรุณาไปแก้ไขในโปรไฟล์)','2025-10-12 10:32:08.833','2025-10-12 10:32:08.833',NULL,NULL),('cmgnkeq2s0005vpdguybefium',3,37500.00,'PENDING','ที่อยู่จัดส่ง (กรุณาไปแก้ไขในโปรไฟล์)','2025-10-12 10:32:08.836','2025-10-12 10:32:08.836',NULL,NULL),('cmgqayszs0001vpmgharf3xg8',3,15000.00,'PENDING','ที่อยู่จัดส่ง (กรุณาไปแก้ไขในโปรไฟล์)','2025-10-14 08:31:08.104','2025-10-14 08:31:08.104',NULL,NULL),('cmgqrfct80001vp54k1say4tx',2,17500.00,'PENDING','ที่อยู่จัดส่ง','2025-10-14 16:11:54.137','2025-10-14 16:11:54.137',NULL,NULL),('cmgqrh9js0003vp54u96mdhu9',2,14000.00,'SHIPPED','ที่อยู่จัดส่ง','2025-10-14 16:13:23.224','2025-10-14 16:13:53.916',NULL,NULL),('cmgqsb14i0005vp54q80wyjk2',2,3500.00,'CONFIRMED','ที่อยู่จัดส่ง','2025-10-14 16:36:31.987','2025-10-24 15:48:32.865',NULL,NULL),('cmh524lqp0001vpowwh0pe25f',2,21000.00,'PENDING','ที่อยู่จัดส่ง','2025-10-24 16:20:14.731','2025-10-24 16:20:14.731',NULL,NULL),('cmh536klp0001vp4sv9bwbecs',2,13350.00,'PENDING','ที่อยู่จัดส่ง','2025-10-24 16:49:46.185','2025-10-24 16:49:46.185',NULL,NULL),('cmh53fcxi0001vp1ogislecpm',2,8900.00,'PENDING','ที่อยู่จัดส่ง','2025-10-24 16:56:36.150','2025-10-24 16:56:36.150',NULL,NULL),('cmh8u3tin0001vpyw8c5v8tne',2,14000.00,'PENDING','ที่อยู่จัดส่ง','2025-10-27 07:46:45.933','2025-10-27 07:46:45.933',NULL,NULL),('cmh8yo1f20001ve9sklhbaqeo',1,14000.00,'PENDING','ที่อยู่จัดส่ง','2025-10-27 09:54:27.758','2025-10-27 09:54:27.758',NULL,NULL),('cmh8ysl0m0003ve9sdedjxpoq',1,40500.00,'PENDING','ที่อยู่จัดส่ง','2025-10-27 09:57:59.782','2025-10-27 09:57:59.782',NULL,NULL),('cmh8yvk750005ve9sme6f1pof',1,8900.00,'PENDING','ที่อยู่จัดส่ง','2025-10-27 10:00:18.689','2025-10-27 10:00:18.689',NULL,NULL),('cmh8yxyls0001vekcr0sde4fe',1,4450.00,'PENDING','ที่อยู่จัดส่ง','2025-10-27 10:02:10.672','2025-10-27 10:02:10.672',NULL,NULL),('cmh8z08k00003vekcjap0d4du',1,3500.00,'PENDING','ที่อยู่จัดส่ง','2025-10-27 10:03:56.881','2025-10-27 10:03:56.881',NULL,NULL),('cmh8z3fh50001ve7o2mqvq33t',1,3500.00,'PENDING','ที่อยู่จัดส่ง','2025-10-27 10:06:25.818','2025-10-27 10:06:25.818',NULL,NULL),('cmh8z4nck0003ve7oenjl5qb0',1,4450.00,'PENDING','ที่อยู่จัดส่ง','2025-10-27 10:07:22.677','2025-10-27 10:07:22.677',NULL,NULL),('cmh8z87in0001ve24x7ulrb05',1,3500.00,'PENDING','cs_test_a1Gl8sxKoaUbilojzIp9fJX9ReamBOuJAsAYknuXeWtciJni95kSRP2gBB','2025-10-27 10:10:08.784','2025-10-27 10:10:08.784',NULL,NULL),('cmh8zg15o0001veu8n2yzsoh2',1,4450.00,'PENDING','cs_test_a1LbKX8LnDYUtmOL1yKydcg3wdcIsKy7IFWUpFkTkqmeciTk6fVTmDyrgC','2025-10-27 10:16:13.788','2025-10-27 10:16:13.788',NULL,NULL),('cmh8zhvhu0001vepoozk5enqb',1,4700.00,'PENDING','cs_test_a17PltZLbwRyUTL53h9VmJPsGDRxpm1vFUT08AhaK1WAkW6s2kvkshVMc1','2025-10-27 10:17:39.763','2025-10-27 10:17:39.763',NULL,NULL),('cmh8ztzr10001veto5tfie30i',1,9850.00,'PENDING','cs_test_a1nMjHnf0Kp5UT3gxMfzno7Ko2xwISVy8O163nR37LDzcCbZlKfVd92Mb9','2025-10-27 10:27:05.149','2025-10-27 10:27:05.149',NULL,NULL),('cmh9050uq0001vegsr4sj0bjk',1,2350.00,'PENDING','cs_test_a16wEdwQLVZJFCiujsVGT1ib6YKnhcnBKx48eOrtcoPFISCgWvfAHyzUkg','2025-10-27 10:35:39.794','2025-10-27 10:35:39.794',NULL,NULL),('cmh9082mn0003vegszzp847ei',1,3400.00,'PENDING','cs_test_a1RcEmEySJ70uUJDkmTu1ovWThK5B7LSstOA342GdehRT1PBp43ZhM0R3y','2025-10-27 10:38:02.063','2025-10-27 10:38:02.063',NULL,NULL),('cmhd663w40001veu0b1fio1eo',1,3600.00,'PENDING','ที่อยู่จัดส่ง','2025-10-30 08:35:32.788','2025-10-30 08:35:32.788',NULL,NULL),('cmhd9ck6y0001veb4xdtc0dtd',1,14100.00,'PENDING','ที่อยู่จัดส่ง','2025-10-30 10:04:32.698','2025-10-30 10:04:32.698',NULL,NULL),('cmhd9hyog0001vegwcw328py1',1,7500.00,'PENDING','ที่อยู่จัดส่ง','2025-10-30 10:08:44.753','2025-10-30 10:08:44.753',NULL,'pickup'),('cmhd9iqcd0003vegwyaot8gxt',1,7500.00,'PENDING','ที่อยู่จัดส่ง','2025-10-30 10:09:20.605','2025-10-30 10:09:20.605',NULL,'pickup'),('cmhd9k5a40005vegw6t0wl2d2',1,7500.00,'PENDING','ที่อยู่จัดส่ง','2025-10-30 10:10:26.621','2025-10-30 10:10:26.621',NULL,'pickup'),('cmhd9nnyx0001vedg6n99celw',1,7500.00,'PENDING','ที่อยู่จัดส่ง','2025-10-30 10:13:10.809','2025-10-30 10:13:10.809','{\"companyName\":\"nattapat kluabthong\",\"contactName\":\"nattapat kluabthong\",\"address\":\"99/5 moo 5\",\"phone\":\"0984435124\"}','delivery'),('cmhd9w0cg0001ve9k1pfesfyi',1,7500.00,'PENDING','ที่อยู่จัดส่ง','2025-10-30 10:19:40.096','2025-10-30 10:19:40.096','{\"companyName\":\"nattapat kluabthong\",\"contactName\":\"nattapat kluabthong\",\"address\":\"99/5 moo 5\",\"district\":\"ไทรน้อย\",\"amphoe\":\"ไทรน้อย\",\"province\":\"นนทบุรี\",\"postalCode\":\"11150\",\"phone\":\"0984435124\"}','delivery'),('cmhd9ym5s0001vee0bedj7hoq',1,15000.00,'PENDING','ที่อยู่จัดส่ง','2025-10-30 10:21:41.681','2025-10-30 10:21:41.681','{\"companyName\":\"nattapat kluabthong\",\"contactName\":\"nattapat kluabthong\",\"address\":\"99/5 moo 5\",\"district\":\"ไทรน้อย\",\"amphoe\":\"ไทรน้อย\",\"province\":\"นนทบุรี\",\"postalCode\":\"11150\",\"phone\":\"0984435124\"}','delivery'),('cmhda18cy0001ve7skcb8j1zp',1,7500.00,'PENDING','ที่อยู่จัดส่ง','2025-10-30 10:23:43.762','2025-10-30 10:23:43.762','{\"companyName\":\"nattapat kluabthong\",\"contactName\":\"nattapat kluabthong\",\"address\":\"99/5 moo 5\",\"district\":\"ไทรน้อย\",\"amphoe\":\"ไทรน้อย\",\"province\":\"นนทบุรี\",\"postalCode\":\"11150\",\"phone\":\"0984435124\"}','delivery'),('cmhda3jo00001ve9ckq3zbl1u',1,7500.00,'PENDING','ที่อยู่จัดส่ง','2025-10-30 10:25:31.728','2025-10-30 10:25:31.728','{\"companyName\":\"nattapat kluabthong\",\"contactName\":\"nattapat kluabthong\",\"address\":\"99/5 moo 5\",\"district\":\"ไทรน้อย\",\"amphoe\":\"ไทรน้อย\",\"province\":\"นนทบุรี\",\"postalCode\":\"11150\",\"phone\":\"0984435124\"}','delivery'),('cmhdaaq5h0001ve88j5delz3x',1,7500.00,'PENDING','ที่อยู่จัดส่ง','2025-10-30 10:31:06.725','2025-10-30 10:31:06.725','{\"companyName\":\"nattapat kluabthong\",\"contactName\":\"nattapat kluabthong\",\"address\":\"99/5 moo 5\",\"district\":\"ไทรน้อย\",\"amphoe\":\"ไทรน้อย\",\"province\":\"นนทบุรี\",\"postalCode\":\"11150\",\"phone\":\"0984435124\"}','delivery'),('cmhdaepph0001ve7ckky3ewuc',1,7500.00,'PENDING','99/5 moo 5 ตำบลไทรน้อย อำเภอไทรน้อย จังหวัดนนทบุรี 11150','2025-10-30 10:34:12.773','2025-10-30 10:34:12.773','{\"companyName\":\"nattapat kluabthong\",\"contactName\":\"nattapat kluabthong\",\"address\":\"99/5 moo 5\",\"district\":\"ไทรน้อย\",\"amphoe\":\"ไทรน้อย\",\"province\":\"นนทบุรี\",\"postalCode\":\"11150\",\"phone\":\"0984435124\"}','delivery'),('cmhdak9gw0003ve7c2u81zaig',1,7500.00,'PENDING','99/5 moo 5 ตำบลบางบัวทอง อำเภอบางบัวทอง จังหวัดนนทบุรี 11150','2025-10-30 10:38:31.664','2025-10-30 10:38:31.664','{\"companyName\":\"nattapat kluabthong\",\"contactName\":\"nattapat kluabthong\",\"address\":\"99/5 moo 5\",\"district\":\"บางบัวทอง\",\"amphoe\":\"บางบัวทอง\",\"province\":\"นนทบุรี\",\"postalCode\":\"11150\",\"phone\":\"0984435124\"}','delivery'),('cmhdaluj00005ve7c32h71vq9',1,7500.00,'PENDING','รับที่ร้าน - 99/5 หมู่ที่ 5 ตำบลไทรน้อย อำเภอไทรน้อย จังหวัดนนทบุรี 11150','2025-10-30 10:39:45.613','2025-10-30 10:39:45.613','{\"companyName\":\"อาร์ดีเอ็น (ประเทศไทย) จำกัด\",\"address\":\"99/5 หมู่ที่ 5 ตำบลไทรน้อย อำเภอไทรน้อย จังหวัดนนทบุรี 11150\",\"phone\":\"092-7605-230\",\"workingHours\":\"ทุกวัน 08:00-19:00 น.\"}','pickup'),('cmhdaqgj80001ve28vtyswld3',1,7500.00,'PENDING','99/5 moo 5 ตำบลบางบัวทอง อำเภอบางบัวทอง จังหวัดนนทบุรี 11150','2025-10-30 10:43:20.756','2025-10-30 10:43:20.756','{\"companyName\":\"nattapat kluabthong\",\"contactName\":\"nattapat kluabthong\",\"address\":\"99/5 moo 5\",\"district\":\"บางบัวทอง\",\"amphoe\":\"บางบัวทอง\",\"province\":\"นนทบุรี\",\"postalCode\":\"11150\",\"phone\":\"0984435124\"}','delivery');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `model` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `originalPrice` decimal(10,2) NOT NULL,
  `image` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `category` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `stock` int NOT NULL DEFAULT '0',
  `rating` decimal(3,2) NOT NULL DEFAULT '0.00',
  `reviews` int NOT NULL DEFAULT '0',
  `isBestSeller` tinyint(1) NOT NULL DEFAULT '0',
  `isOnSale` tinyint(1) NOT NULL DEFAULT '0',
  `discount` int NOT NULL DEFAULT '0',
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,'ตู้เอกสารเตี้ย','KEL-152',3500.00,3500.00,'/images/products/KEL-152.jpg','ตู้เอกสาร','ตู้เอกสารเตี้ย 2 ชั้น',0,0.00,0,0,0,0,'2025-10-24 17:31:32.233','2025-10-27 10:10:08.790'),(2,'ตู้เอกสารสูง','KEL-153',4450.00,4450.00,'/images/products/KEL-153.jpg','ตู้เอกสาร','ตู้เอกสารสูง 4 ชั้น',0,0.00,0,0,0,0,'2025-10-24 17:31:32.233','2025-10-27 10:16:13.796'),(3,'ตู้เอกสาร 2 บานเปิด','KIB-141',2350.00,2350.00,'/images/products/KIB-141.jpg','ตู้เอกสาร','ตู้เอกสาร 2 บานเปิด',0,0.00,0,0,0,0,'2025-10-24 17:31:32.233','2025-10-30 10:04:32.705'),(4,'ตู้ล็อกเกอร์ 18 ช่อง','KEL-077',7500.00,7500.00,'/images/products/KEL-077.jpg','ตู้ล็อกเกอร์','ตู้ล็อกเกอร์ 18 ช่อง',1,0.00,0,0,0,0,'2025-10-24 17:31:32.233','2025-10-30 10:43:20.764'),(5,'ตู้บานเลื่อนทึบ 3 ฟุต','KEL-109',4000.00,4000.00,'/images/products/KEL-109.jpg','ตู้เอกสาร','ตู้บานเลื่อนทึบ 3 ฟุต',0,0.00,0,0,0,0,'2025-10-24 17:31:32.233','2025-10-27 10:22:58.036'),(6,'ตู้บานเลื่อนทึบ 4 ฟุต','KEL-110',5600.00,5600.00,'/images/products/KEL-110.jpg','ตู้เอกสาร','ตู้บานเลื่อนทึบ 4 ฟุต',0,0.00,0,0,0,0,'2025-10-24 17:31:32.233','2025-10-27 10:22:58.041'),(7,'ตู้บานเลื่อนกระจกใส 3 ฟุต','KEL-111',4200.00,4200.00,'/images/products/KEL-111.jpg','ตู้เอกสาร','ตู้บานเลื่อนกระจกใส 3 ฟุต',0,0.00,0,0,0,0,'2025-10-24 17:31:32.233','2025-10-27 10:22:58.045'),(8,'ตู้บานเลื่อนกระจกใส 4 ฟุต','KEL-112',5500.00,5500.00,'/images/products/KEL-112.jpg','ตู้เอกสาร','ตู้บานเลื่อนกระจกใส 4 ฟุต',0,0.00,0,0,0,0,'2025-10-24 17:31:32.233','2025-10-27 10:22:58.049'),(9,'ตู้เอกสาร 2 บานเปิด','KEL-039',4000.00,4000.00,'/images/products/KEL-039.jpg','ตู้เอกสาร','ตู้เอกสาร 2 บานเปิด',0,0.00,0,0,0,0,'2025-10-24 22:12:51.280','2025-10-27 10:22:58.054'),(10,'ตู้เอกสาร 1 บาน 4 ลิ้นชัก','KEL-130',4500.00,4500.00,'/images/products/KEL-130.jpg','ตู้เอกสาร','ตู้เอกสาร 1 บาน 4 ลิ้นชัก',0,0.00,0,0,0,0,'2025-10-24 17:31:32.233','2025-10-27 10:22:58.058'),(11,'โต๊ะทำงานมาตรฐาน 150','KIB-119',3990.00,3990.00,'/images/products/KIB-119.jpg','โต๊ะทำงาน','โต๊ะทำงานมาตรฐาน 150 ซม.',0,0.00,0,0,0,0,'2025-10-24 17:31:32.233','2025-10-27 10:22:58.063'),(12,'โต๊ะทำงานมาตรฐาน 180','KIB-120',4200.00,4200.00,'/images/products/KIB-120.jpg','โต๊ะทำงาน','โต๊ะทำงานมาตรฐาน 180 ซม.',0,0.00,0,0,0,0,'2025-10-24 17:31:32.233','2025-10-27 10:22:58.068'),(13,'โต๊ะทำงานเตี้ย 80','KIB-011',2390.00,2390.00,'/images/products/KIB-011.jpg','โต๊ะทำงาน','โต๊ะทำงานเตี้ย 80 ซม.',0,0.00,0,0,0,0,'2025-10-24 17:31:32.233','2025-10-27 10:22:58.072'),(14,'โต๊ะทำงานเหล็ก 120','KIB-007',3190.00,3190.00,'/images/products/KIB-007.jpg','โต๊ะทำงาน','โต๊ะทำงานเหล็ก 120 ซม.',0,0.00,0,0,0,0,'2025-10-24 17:31:32.233','2025-10-27 10:22:58.076'),(15,'โต๊ะคอมพิวเตอร์ 120','KIB-004',1988.00,1988.00,'/images/products/KIB-004.jpg','โต๊ะทำงาน','โต๊ะคอมพิวเตอร์เหล็ก 120 ซม.',0,0.00,0,0,0,0,'2025-10-24 17:31:32.233','2025-10-27 10:22:58.081'),(16,'โต๊ะคอมพิวเตอร์ 160','KIB-005',1988.00,1988.00,'/images/products/KIB-005.jpg','โต๊ะทำงาน','โต๊ะคอมพิวเตอร์เหล็ก 160 ซม.',10,0.00,0,0,0,0,'2025-10-24 17:31:32.233','2025-10-27 10:22:58.085'),(17,'เก้าอี้ทำงาน KFT','KFT-001',2250.00,2250.00,'/images/products/KFT-001.jpg','เก้าอี้','เก้าอี้ทำงาน KFT',0,0.00,0,0,0,0,'2025-10-24 17:32:43.339','2025-10-27 10:22:58.089'),(18,'เก้าอี้ทำงาน KFT','KFT-002',2400.00,2400.00,'/images/products/KFT-002.jpg','เก้าอี้','เก้าอี้ทำงาน KFT',0,0.00,0,0,0,0,'2025-10-24 17:32:43.339','2025-10-27 10:22:58.093'),(19,'เก้าอี้ทำงาน KFT','KFT-003',3600.00,3600.00,'/images/products/KFT-003.jpg','เก้าอี้','เก้าอี้ทำงาน KFT',0,0.00,0,0,0,0,'2025-10-24 17:32:43.339','2025-10-30 08:35:32.797'),(20,'เก้าอี้ทำงาน KFT','KFT-004',3400.00,3400.00,'/images/products/KFT-004.jpg','เก้าอี้','เก้าอี้ทำงาน KFT',0,0.00,0,0,0,0,'2025-10-24 17:32:43.339','2025-10-27 10:38:02.069'),(21,'เก้าอี้ทำงาน KFT','KFT-005',3050.00,3050.00,'/images/products/KFT-005.jpg','เก้าอี้','เก้าอี้ทำงาน KFT',1,0.00,0,0,0,0,'2025-10-24 17:32:43.339','2025-10-27 10:37:33.561'),(22,'เก้าอี้ทำงาน KFT','KFT-006',4600.00,4600.00,'/images/products/KFT-006.jpg','เก้าอี้','เก้าอี้ทำงาน KFT',0,0.00,0,0,0,0,'2025-10-24 17:32:43.339','2025-10-27 10:22:58.109'),(23,'เก้าอี้ทำงาน KFT','KFT-007',2200.00,2200.00,'/images/products/KFT-007.jpg','เก้าอี้','เก้าอี้ทำงาน KFT',0,0.00,0,0,0,0,'2025-10-24 17:32:43.339','2025-10-27 10:22:58.114'),(24,'เก้าอี้ทำงาน KFT','KFT-008',2200.00,2200.00,'/images/products/KFT-008.jpg','เก้าอี้','เก้าอี้ทำงาน KFT',0,0.00,0,0,0,0,'2025-10-24 17:32:43.339','2025-10-27 10:22:58.118'),(25,'เก้าอี้ทำงาน KFT','KFT-009',2700.00,2700.00,'/images/products/KFT-009.jpg','เก้าอี้','เก้าอี้ทำงาน KFT',0,0.00,0,0,0,0,'2025-10-24 17:32:43.339','2025-10-27 10:22:58.123'),(26,'เก้าอี้ทำงาน KFT','KFT-010',3500.00,3500.00,'/images/products/KFT-010.jpg','เก้าอี้','เก้าอี้ทำงาน KFT',0,0.00,0,0,0,0,'2025-10-24 17:32:43.339','2025-10-27 10:22:58.128'),(27,'เก้าอี้ทำงาน KFT','KFT-011',3000.00,3000.00,'/images/products/KFT-011.jpg','เก้าอี้','เก้าอี้ทำงาน KFT',0,0.00,0,0,0,0,'2025-10-24 17:32:43.339','2025-10-27 10:22:58.133'),(28,'เก้าอี้ทำงาน KFT','KFT-012',3100.00,3100.00,'/images/products/KFT-012.jpg','เก้าอี้','เก้าอี้ทำงาน KFT',0,0.00,0,0,0,0,'2025-10-24 17:32:43.339','2025-10-27 10:22:58.138'),(29,'เก้าอี้ทำงาน KFT','KFT-013',2850.00,2850.00,'/images/products/KFT-013.jpg','เก้าอี้','เก้าอี้ทำงาน KFT',0,0.00,0,0,0,0,'2025-10-24 17:32:43.339','2025-10-27 10:22:58.143'),(30,'เก้าอี้ทำงาน KFT','KFT-014',1890.00,1890.00,'/images/products/KFT-014.jpg','เก้าอี้','เก้าอี้ทำงาน KFT',0,0.00,0,0,0,0,'2025-10-24 17:32:43.339','2025-10-27 10:22:58.147'),(31,'เก้าอี้ทำงาน KFT','RDP-316',1890.00,1890.00,'/images/products/RDP-316.jpg','เก้าอี้','เก้าอี้ทำงาน KFT',0,0.00,0,0,0,0,'2025-10-24 17:32:43.339','2025-10-27 10:22:58.152'),(32,'เก้าอี้ทำงาน KFT','RDP-350',990.00,990.00,'/images/products/RDP-350.jpg','เก้าอี้','เก้าอี้ทำงาน KFT',0,0.00,0,0,0,0,'2025-10-24 17:32:43.339','2025-10-27 10:22:58.156'),(33,'โต๊ะทำงานผู้บริหาร','KIB-047',8950.00,8950.00,'/images/products/KIB-047.jpg','โต๊ะทำงาน','โต๊ะทำงานผู้บริหาร',0,0.00,0,0,0,0,'2025-10-24 17:43:05.836','2025-10-27 10:22:58.161'),(34,'โต๊ะทำงานผู้บริหาร','KIB-048',8950.00,8950.00,'/images/products/KIB-048.jpg','โต๊ะทำงาน','โต๊ะทำงานผู้บริหาร',0,0.00,0,0,0,0,'2025-10-24 17:43:05.836','2025-10-27 10:22:58.166'),(35,'โต๊ะทำงานผู้บริหาร','KIB-046',9590.00,9590.00,'/images/products/KIB-046.jpg','โต๊ะทำงาน','โต๊ะทำงานผู้บริหาร',0,0.00,0,0,0,0,'2025-10-24 17:43:05.836','2025-10-27 10:22:58.170'),(36,'โต๊ะทำงาน 2 ชั้นซึ่งขนาด','KIB-067',2150.00,2150.00,'/images/products/KIB-067.jpg','โต๊ะทำงาน','โต๊ะทำงาน 2 ชั้น',0,0.00,0,0,0,0,'2025-10-24 17:43:05.836','2025-10-27 10:22:58.175'),(37,'โต๊ะทำงานไม้สามชั้น','KIB-065',2160.00,2160.00,'/images/products/KIB-065.jpg','โต๊ะทำงาน','โต๊ะทำงานไม้สามชั้น',0,0.00,0,0,0,0,'2025-10-24 17:43:05.836','2025-10-27 10:22:58.180'),(38,'โต๊ะทำงาน 3 ชั้น','KIB-035',4790.00,4790.00,'/images/products/KIB-035.jpg','โต๊ะทำงาน','โต๊ะทำงาน 3 ชั้น',0,0.00,0,0,0,0,'2025-10-24 17:43:05.836','2025-10-27 10:22:58.184'),(39,'โต๊ะทำงานสามตัวแบบการฟิต','KIB-038',4790.00,4790.00,'/images/products/KIB-038.jpg','โต๊ะทำงาน','โต๊ะทำงาน',0,0.00,0,0,0,0,'2025-10-24 17:43:05.836','2025-10-27 10:22:58.189'),(40,'โต๊ะทำงาน 1.20 ขนาด','KIB-039',1500.00,1500.00,'/images/products/KIB-039.jpg','โต๊ะทำงาน','โต๊ะทำงาน 1.20 ขนาด',0,0.00,0,0,0,0,'2025-10-24 17:43:05.836','2025-10-27 10:22:58.194'),(41,'โต๊ะทำงานที่มีห้องทำงาน','KIB-098',9900.00,9900.00,'/images/products/KIB-098.jpg','โต๊ะทำงาน','โต๊ะทำงานที่มีห้องทำงาน',0,0.00,0,0,0,0,'2025-10-24 17:43:05.836','2025-10-27 10:22:58.198'),(42,'โต๊ะทำงาน 1.50 มุมซึ่งเป็น','KIB-041',4950.00,4950.00,'/images/products/KIB-041.jpg','โต๊ะทำงาน','โต๊ะทำงาน 1.50 มุมซึ่งเป็น',0,0.00,0,0,0,0,'2025-10-24 17:43:05.836','2025-10-27 10:22:58.202'),(43,'โต๊ะคอมพิวเตอร์ 1.20','KIB-032',2005.00,2005.00,'/images/products/KIB-032.jpg','โต๊ะทำงาน','โต๊ะคอมพิวเตอร์ 1.20',0,0.00,0,0,0,0,'2025-10-24 17:43:05.836','2025-10-27 10:22:58.207'),(44,'โต๊ะทำงานเสริม','KIB-093',8500.00,8500.00,'/images/products/KIB-093.jpg','โต๊ะทำงาน','โต๊ะทำงานเสริม',0,0.00,0,0,0,0,'2025-10-24 17:43:05.836','2025-10-27 10:22:58.212'),(45,'โต๊ะคอมพิวเตอร์ 0.80','KIB-089',3200.00,3200.00,'/images/products/KIB-089.jpg','โต๊ะทำงาน','โต๊ะคอมพิวเตอร์ 0.80',0,0.00,0,0,0,0,'2025-10-24 17:43:05.836','2025-10-27 10:22:58.217'),(46,'โต๊ะทำงานไม้คอนโทรล','KIB-088',7500.00,7500.00,'/images/products/KIB-088.jpg','โต๊ะทำงาน','โต๊ะทำงานไม้คอนโทรล',0,0.00,0,0,0,0,'2025-10-24 17:43:05.836','2025-10-27 10:22:58.222'),(47,'โต๊ะทำงานมาตรฐาน 1.20','KIB-087',2990.00,2990.00,'/images/products/KIB-087.jpg','โต๊ะทำงาน','โต๊ะทำงานมาตรฐาน 1.20',0,0.00,0,0,0,0,'2025-10-24 17:43:05.836','2025-10-27 10:22:58.227'),(48,'โต๊ะทำงานมาตรฐาน 1.20','KIB-012',2990.00,2990.00,'/images/products/KIB-012.jpg','โต๊ะทำงาน','โต๊ะทำงานมาตรฐาน 1.20',0,0.00,0,0,0,0,'2025-10-24 17:43:05.836','2025-10-27 10:22:58.232');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `promotions`
--

DROP TABLE IF EXISTS `promotions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `promotions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `discount` int NOT NULL,
  `validUntil` datetime(3) NOT NULL,
  `image` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `category` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `promotions`
--

LOCK TABLES `promotions` WRITE;
/*!40000 ALTER TABLE `promotions` DISABLE KEYS */;
/*!40000 ALTER TABLE `promotions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `avatar` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `password` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `resetPasswordExpires` datetime(3) DEFAULT NULL,
  `resetPasswordToken` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `role` enum('USER','ADMIN') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'USER',
  `gender` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nickname` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `district` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `postalCode` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `province` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `amphoe` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_key` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'nattapat kluabthong','test1@gmail.com','0984435124','99/5 moo 5',NULL,'2025-10-09 13:32:44.624','2025-10-30 10:35:18.228','$2b$10$ZtJCO.MxMi6RA.G58599wOm9kcTslgGyCZ9n/nIWikOaSljNnASq2',NULL,NULL,'ADMIN','อื่นๆ','นาย','บางบัวทอง','11150','นนทบุรี','บางบัวทอง'),(2,'Admin User','admin@furniture.com','081-234-5678','สำนักงานใหญ่',NULL,'2025-10-09 13:44:27.843','2025-10-12 08:16:07.325','$2b$10$9dz.KEC19QhpI4qlvTFc/On.htMK6pDEEw/46IZ271sQZ.mvthy3q','2025-10-12 09:16:07.320','i25wevdi9eihnlmh9pjj95','ADMIN',NULL,NULL,NULL,NULL,NULL,NULL),(3,'User Test','user@furniture.com','089-876-5432','99/5, ไทรน้อย,  นนทบุรี, 11150',NULL,'2025-10-09 13:45:03.503','2025-10-14 09:45:30.896','$2b$10$7VLSWyrFbBLtkupAlUvyX.LZmYUlPKNpEZWyyEAjg1nQ3Ff9p/coa',NULL,NULL,'USER',NULL,NULL,NULL,NULL,NULL,NULL),(4,'Potae Kubpom','nattapatntp2@gmail.com','0984435124','82/2',NULL,'2025-10-12 07:51:31.033','2025-10-27 10:39:47.921','$2b$10$ksiBl8rSY.Hi.lXlkgbUzu9caZU.h5xpNcwVSMOZj1iCr3PX.lReS','2025-10-27 11:39:47.914','sc7b3ttzanr0kke6fhp2s','USER',NULL,NULL,NULL,NULL,NULL,NULL),(5,'jay jay','khongpop.s@gmail.com',NULL,NULL,NULL,'2025-10-12 08:47:29.755','2025-10-12 08:47:34.848','$2b$10$/qGhnoUoP/10LqIDFNWdK.fTYbsbp6gKyNld4TuYucThbOYa6eqfS','2025-10-12 09:47:34.847','pvsbc7fpulf4n0vh4vm6ff','USER',NULL,NULL,NULL,NULL,NULL,NULL),(6,'jay jay','khongpop.s@ku.th',NULL,NULL,NULL,'2025-10-12 08:48:17.930','2025-10-12 08:48:23.397','$2b$10$37ZicWCeR6X.SvshL8KWBOaScKbH4mKbMpq4yRi.WFWQNKsIk/l6i','2025-10-12 09:48:23.395','kmt1sfvn27ahno86hz5ep','USER',NULL,NULL,NULL,NULL,NULL,NULL),(7,'lukkade sudsuay','kamonporn.a@ku.th',NULL,NULL,NULL,'2025-10-14 16:15:04.038','2025-10-24 15:58:41.433','$2b$10$SY81HQ706VKtKWofzBpocel.Rk9vJgoE42BDNPvaMqiq9qSWPDPSe','2025-10-24 16:58:41.432','urdw4uuo3rolxqi8grm0vg','USER',NULL,NULL,NULL,NULL,NULL,NULL),(8,'nattapat kluabthong','kingofzeed@gmail.com','1',NULL,NULL,'2025-10-27 10:41:36.141','2025-10-27 10:41:36.141','$2b$10$eSHV8MohOR8hVsjBg6Koo.YMZua7ISJM4sBa/FjPJZkagGG5WL8oS',NULL,NULL,'USER',NULL,NULL,NULL,NULL,NULL,NULL),(9,'nattapat kluabthong','nattapat.klu@ku.th','1234568790',NULL,NULL,'2025-10-28 09:24:15.889','2025-10-28 09:24:15.889','$2b$10$kE5GrMo5TgRe2zdemnTrd.9aZzo.69zNk0JtN25DzETPr0AXAZLZu',NULL,NULL,'USER',NULL,NULL,NULL,NULL,NULL,NULL),(10,'nattapat kluabthoig','test4@gmail.com','0924854888','',NULL,'2025-10-30 10:44:54.506','2025-10-30 10:45:00.937','$2b$10$jR2Ni0J0o8rIIdLECDIJQeF/DA5.Ox0vd0RlIDZ8mUOi.RCfbWTOG',NULL,NULL,'USER','หญิง','s','','','',NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'furniture_office'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-10-31  3:21:29

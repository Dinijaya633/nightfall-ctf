/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-11.4.13-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: ctfd
-- ------------------------------------------------------
-- Server version	11.4.13-MariaDB-ubu2404

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Current Database: `ctfd`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `ctfd` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci */;

USE `ctfd`;

--
-- Table structure for table `alembic_version`
--

DROP TABLE IF EXISTS `alembic_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `alembic_version` (
  `version_num` varchar(32) NOT NULL,
  PRIMARY KEY (`version_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alembic_version`
--

LOCK TABLES `alembic_version` WRITE;
/*!40000 ALTER TABLE `alembic_version` DISABLE KEYS */;
INSERT INTO `alembic_version` VALUES
('24ad6790bc3c');
/*!40000 ALTER TABLE `alembic_version` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `awards`
--

DROP TABLE IF EXISTS `awards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `awards` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `team_id` int(11) DEFAULT NULL,
  `name` varchar(80) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `date` datetime(6) DEFAULT NULL,
  `value` int(11) DEFAULT NULL,
  `category` varchar(80) DEFAULT NULL,
  `icon` text DEFAULT NULL,
  `requirements` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`requirements`)),
  `type` varchar(80) DEFAULT 'standard',
  PRIMARY KEY (`id`),
  KEY `awards_ibfk_1` (`team_id`),
  KEY `awards_ibfk_2` (`user_id`),
  CONSTRAINT `awards_ibfk_1` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE,
  CONSTRAINT `awards_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `awards`
--

LOCK TABLES `awards` WRITE;
/*!40000 ALTER TABLE `awards` DISABLE KEYS */;
INSERT INTO `awards` VALUES
(4,7,NULL,'Hint 7','Hint for NF 04 - Packets Do Not Lie','2026-10-10 19:15:59.543251',-15,'hints',NULL,NULL,'standard'),
(5,7,NULL,'Hint 8','Hint for NF 04 - Packets Do Not Lie','2026-10-10 19:16:03.991607',-30,'hints',NULL,NULL,'standard');
/*!40000 ALTER TABLE `awards` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `brackets`
--

DROP TABLE IF EXISTS `brackets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `brackets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `type` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `brackets`
--

LOCK TABLES `brackets` WRITE;
/*!40000 ALTER TABLE `brackets` DISABLE KEYS */;
/*!40000 ALTER TABLE `brackets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `challenge_topics`
--

DROP TABLE IF EXISTS `challenge_topics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `challenge_topics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `challenge_id` int(11) DEFAULT NULL,
  `topic_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `challenge_id` (`challenge_id`),
  KEY `topic_id` (`topic_id`),
  CONSTRAINT `challenge_topics_ibfk_1` FOREIGN KEY (`challenge_id`) REFERENCES `challenges` (`id`) ON DELETE CASCADE,
  CONSTRAINT `challenge_topics_ibfk_2` FOREIGN KEY (`topic_id`) REFERENCES `topics` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `challenge_topics`
--

LOCK TABLES `challenge_topics` WRITE;
/*!40000 ALTER TABLE `challenge_topics` DISABLE KEYS */;
/*!40000 ALTER TABLE `challenge_topics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `challenges`
--

DROP TABLE IF EXISTS `challenges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `challenges` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `max_attempts` int(11) DEFAULT NULL,
  `value` int(11) DEFAULT NULL,
  `category` varchar(80) DEFAULT NULL,
  `type` varchar(80) DEFAULT NULL,
  `state` varchar(80) NOT NULL,
  `requirements` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`requirements`)),
  `connection_info` text DEFAULT NULL,
  `next_id` int(11) DEFAULT NULL,
  `attribution` text DEFAULT NULL,
  `logic` varchar(80) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `next_id` (`next_id`),
  CONSTRAINT `challenges_ibfk_1` FOREIGN KEY (`next_id`) REFERENCES `challenges` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `challenges`
--

LOCK TABLES `challenges` WRITE;
/*!40000 ALTER TABLE `challenges` DISABLE KEYS */;
INSERT INTO `challenges` VALUES
(1,'UNUSED - NF01 duplicate','Cygnus Labs suspects that SPECTER began by gathering publicly available information.\r\n\r\nInvestigate the fictional company website:\r\nhttp://localhost:8082\r\n\r\nExplore the pages and inspect their source to identify the developer handle, the Project NIGHTFALL codename, and the media filename leading to the next stage.\r\n\r\nFind and submit the NF01 flag in the format NIGHTFALL{...}.\r\nKeep the developer handle and media filename for NF02.',0,100,'OSINT','standard','hidden',NULL,NULL,NULL,NULL,'any'),
(2,'NF 01 - Footprints in the Open','Cygnus Labs suspects that SPECTER began by gathering publicly available information.\r\n\r\nInvestigate the fictional company website:\r\nhttp://localhost:8082\r\n\r\nExplore the pages and inspect their source to identify the developer handle, the Project NIGHTFALL codename, and the media filename leading to the next stage.\r\n\r\nConstruct your flag using the developer handle and project codename:\r\n\r\nNIGHTFALL{handle_codename}\r\n\r\nUse lowercase for both values inside the braces, separated by one underscore. Keep NIGHTFALL uppercase outside the braces.\r\n\r\nAlso locate the launch-review media file. Keep its filename and the developer handle for NF02.',0,100,'OSINT','standard','visible',NULL,'http://localhost:8082',NULL,'Thilomith Peiris ??? IT24100751','any'),
(3,'NF 02 - Picture Perfect Secret','The launch-review photograph located during NF01 appears ordinary, but it contains a hidden handover note.\r\n\r\nDownload the original image from the media path you discovered on the Cygnus Labs website:\r\nhttp://localhost:8082\r\n\r\nInspect the image and recover its embedded content. Information gathered during NF01 will help you unlock it.\r\n\r\nSubmit the NF02 verification flag found in the recovered note, exactly as written.\r\n\r\nKeep the portal route and account details from the note for NF03.\r\n\r\nImage SHA-256:\r\nb46f0752f268c73c9d67665fb05bcf92c096ed6397e2952b6bd1cd38f6451ae8\r\n\r\nUse the original downloaded file. Do not use a screenshot or re-save the image in an editor.',0,125,'Steganography','standard','visible','{\"prerequisites\": [2]}',NULL,NULL,NULL,'any'),
(4,'NF03 - Incident Review','The hidden note recovered in NF02 points to the Cygnus Incident Review Portal.\r\n\r\nUse the portal route and account credentials from that note to continue your investigation.\r\n\r\nService address:\r\nhttp://localhost:8081\r\n\r\nExplore the incident records and investigate whether your account can access information beyond its assigned case.\r\n\r\nFind and submit the NF03 verification flag exactly as written.\r\n\r\nKeep any evidence references and investigation details you discover for NF04.',0,175,'Web','standard','visible','{\"prerequisites\": [3]}','http://localhost:8081',NULL,'Thilomith Peiris ??? IT24100751','any'),
(5,'NF 04 - Packets Do Not Lie','The incident record from NF03 provides a prepared packet capture and access log from the suspected exfiltration window. Several benign streams act as realistic noise.\r\n\r\nAnalyze the network evidence and server log to reconstruct the exfiltration incident:\r\n1. Download `nightfall_capture.pcapng` and `access.log`.\r\n2. Apply HTTP filters and inspect client-to-server conversations matching the incident timeframe.\r\n3. Reconstruct the relevant TCP/HTTP stream and correlate the request ID with `access.log`.\r\n4. Recover the archive seed and event date required for the next stage.\r\n\r\nSubmit the combined Stage 4 proof flag.',0,200,'Forensics','standard','visible','{\"prerequisites\": [4]}',NULL,NULL,NULL,'any'),
(6,'NF 05 - Cipher in the Archive','SPECTER obtained an encrypted handover bundle (`nightfall.enc`). The developers derived its encryption key deterministically from the archive seed and event date recovered in NF04.\r\n\r\nYour task:\r\n1. Inspect `keygen.txt` to understand the key derivation algorithm.\r\n2. Write a Python script to generate date candidates (YYYY-MM-DD) based on the NF04 exfiltration window.\r\n3. Derive candidate keys using the SHA-256 hash truncation method shown in the pseudocode.\r\n4. Perform authenticated decryption on `nightfall.enc` to extract the plaintext JSON payload.\r\n\r\nSubmit the Stage 5 flag found inside the decrypted JSON file. Keep the recovered SSH credentials for NF06.',0,275,'Crypto','standard','visible','{\"prerequisites\": [5]}',NULL,NULL,NULL,'any'),
(7,'NF 06 - Root of the Breach','Using the SSH credentials recovered from NF05, log into the Cygnus Labs evidence server on port 2222.\r\n\r\nYour task:\r\n1. Connect to the target system via SSH (`ssh <user>@localhost -p 2222`).\r\n2. Enumerate user privileges using `sudo -l` and inspect permitted commands.\r\n3. Trace the execution path and file permissions of the root review utility and its helper scripts.\r\n4. Identify the user-writable dependency and exploit the configuration flaw to read `/root/final_flag.txt`.\r\n\r\nSubmit the final NIGHTFALL master flag.',0,350,'Linux','standard','visible','{\"prerequisites\": [6]}',NULL,NULL,NULL,'any');
/*!40000 ALTER TABLE `challenges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(80) DEFAULT NULL,
  `content` text DEFAULT NULL,
  `date` datetime(6) DEFAULT NULL,
  `author_id` int(11) DEFAULT NULL,
  `challenge_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `team_id` int(11) DEFAULT NULL,
  `page_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `author_id` (`author_id`),
  KEY `challenge_id` (`challenge_id`),
  KEY `page_id` (`page_id`),
  KEY `team_id` (`team_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `comments_ibfk_2` FOREIGN KEY (`challenge_id`) REFERENCES `challenges` (`id`) ON DELETE CASCADE,
  CONSTRAINT `comments_ibfk_3` FOREIGN KEY (`page_id`) REFERENCES `pages` (`id`) ON DELETE CASCADE,
  CONSTRAINT `comments_ibfk_4` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE,
  CONSTRAINT `comments_ibfk_5` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `config`
--

DROP TABLE IF EXISTS `config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `config` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` text DEFAULT NULL,
  `value` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `config`
--

LOCK TABLES `config` WRITE;
/*!40000 ALTER TABLE `config` DISABLE KEYS */;
INSERT INTO `config` VALUES
(1,'ctf_version','3.8.0'),
(2,'dynamic_challenges_alembic_version','eb68f277ab61'),
(3,'ctf_name','Operation NIGHTFALL'),
(4,'ctf_description','Operation NIGHTFALL: The Cygnus Labs Breach is a progressive cybersecurity Capture The Flag environment in which participants investigate a fictional security incident across OSINT, steganography, web security, digital forensics, cryptography, programming, and Linux system security challenges.\r\n\r\nParticipants act as junior penetration testers and incident investigators. Each stage produces evidence required by the next stage, forming a connected investigation from initial reconnaissance to the final system-security challenge.\r\n\r\nAll systems, identities, credentials, traffic, vulnerabilities, and evidence used in this environment are fictional or laboratory-generated. Testing is authorized only within the supplied NIGHTFALL CTF environment.'),
(5,'user_mode','users'),
(6,'ctf_theme','nightfall'),
(7,'start',''),
(8,'end',''),
(9,'freeze',NULL),
(10,'challenge_visibility','public'),
(11,'registration_visibility','public'),
(12,'score_visibility','public'),
(13,'account_visibility','public'),
(14,'verify_emails','false'),
(15,'social_shares','false'),
(16,'team_size',''),
(17,'mail_server',NULL),
(18,'mail_port',NULL),
(19,'mail_tls',NULL),
(20,'mail_ssl',NULL),
(21,'mail_username',NULL),
(22,'mail_password',NULL),
(23,'mail_useauth',NULL),
(24,'setup','1'),
(25,'version_latest','https://github.com/CTFd/CTFd/releases/tag/3.8.8'),
(26,'next_update_check','1791752510'),
(27,'theme_header','<link rel=\"stylesheet\" href=\"/themes/nightfall/static/css/animations.css?v=8\">\r\n<link rel=\"stylesheet\" href=\"/themes/nightfall/static/css/extras.css?v=8\">\r\n<link rel=\"stylesheet\" href=\"/themes/nightfall/static/css/alarm.css?v=8\">\r\n<link rel=\"stylesheet\" href=\"/themes/nightfall/static/css/effects.css?v=8\">\r\n<link rel=\"stylesheet\" href=\"/themes/nightfall/static/css/layout.css?v=8\">\r\n<script src=\"/themes/nightfall/static/js/nightfall.js?v=8\" defer></script>\r\n<script src=\"/themes/nightfall/static/js/extras.js?v=8\" defer></script>\r\n<script src=\"/themes/nightfall/static/js/alarm.js?v=8\" defer></script>\r\n<script src=\"/themes/nightfall/static/js/effects.js?v=8\" defer></script>\r\n<script src=\"/themes/nightfall/static/js/layout.js?v=8\" defer></script>'),
(28,'theme_footer','<div style=\"text-align:center; padding:24px 0; color:#64748b; font-family:\'JetBrains Mono\',Consolas,monospace; font-size:12px; letter-spacing:2px;\">\r\n  ?? 2026 CYGNUS LABS ??? SECURE OPERATIONS &nbsp;//&nbsp; OPERATION NIGHTFALL\r\n</div>'),
(29,'theme_settings',''),
(30,'ctf_logo','416f98ce3527ff322e07348f735c785d/cygnus-logo.svg');
/*!40000 ALTER TABLE `config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dynamic_challenge`
--

DROP TABLE IF EXISTS `dynamic_challenge`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `dynamic_challenge` (
  `id` int(11) NOT NULL,
  `initial` int(11) DEFAULT NULL,
  `minimum` int(11) DEFAULT NULL,
  `decay` int(11) DEFAULT NULL,
  `function` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `dynamic_challenge_ibfk_1` FOREIGN KEY (`id`) REFERENCES `challenges` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dynamic_challenge`
--

LOCK TABLES `dynamic_challenge` WRITE;
/*!40000 ALTER TABLE `dynamic_challenge` DISABLE KEYS */;
/*!40000 ALTER TABLE `dynamic_challenge` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `field_entries`
--

DROP TABLE IF EXISTS `field_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `field_entries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(80) DEFAULT NULL,
  `value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`value`)),
  `field_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `team_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `field_id` (`field_id`),
  KEY `team_id` (`team_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `field_entries_ibfk_1` FOREIGN KEY (`field_id`) REFERENCES `fields` (`id`) ON DELETE CASCADE,
  CONSTRAINT `field_entries_ibfk_2` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE,
  CONSTRAINT `field_entries_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `field_entries`
--

LOCK TABLES `field_entries` WRITE;
/*!40000 ALTER TABLE `field_entries` DISABLE KEYS */;
/*!40000 ALTER TABLE `field_entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fields`
--

DROP TABLE IF EXISTS `fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `fields` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` text DEFAULT NULL,
  `type` varchar(80) DEFAULT NULL,
  `field_type` varchar(80) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `required` tinyint(1) DEFAULT NULL,
  `public` tinyint(1) DEFAULT NULL,
  `editable` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fields`
--

LOCK TABLES `fields` WRITE;
/*!40000 ALTER TABLE `fields` DISABLE KEYS */;
/*!40000 ALTER TABLE `fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `files`
--

DROP TABLE IF EXISTS `files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `files` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(80) DEFAULT NULL,
  `location` text DEFAULT NULL,
  `challenge_id` int(11) DEFAULT NULL,
  `page_id` int(11) DEFAULT NULL,
  `sha1sum` varchar(40) DEFAULT NULL,
  `solution_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `page_id` (`page_id`),
  KEY `files_ibfk_1` (`challenge_id`),
  KEY `solution_id` (`solution_id`),
  CONSTRAINT `files_ibfk_1` FOREIGN KEY (`challenge_id`) REFERENCES `challenges` (`id`) ON DELETE CASCADE,
  CONSTRAINT `files_ibfk_2` FOREIGN KEY (`page_id`) REFERENCES `pages` (`id`),
  CONSTRAINT `files_ibfk_3` FOREIGN KEY (`solution_id`) REFERENCES `solutions` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `files`
--

LOCK TABLES `files` WRITE;
/*!40000 ALTER TABLE `files` DISABLE KEYS */;
INSERT INTO `files` VALUES
(1,'challenge','2d8a8f54c7393d76ce181a37ca5fbd95/access.log',5,NULL,'e3e45bc9e258931a3dc7e80c442a6f82ef0e56b5',NULL),
(2,'challenge','ab80e816c0a9d1cb8df9aa370145e23b/nightfall_capture.pcapng',5,NULL,'068fad8dcba634c35c200e0de9147d5982952844',NULL),
(3,'challenge','be72625d67be1ff653875c7c80e5de39/sha256sum.txt',5,NULL,'8ddafd5afb06e10abac509ebb66bfedde8337fd2',NULL),
(4,'challenge','d47a7b60d4c71324e4fb317793239c83/requirements.txt',6,NULL,'bb9cb54db37df27d5fe39008c2939452da5d1a2d',NULL),
(5,'challenge','1344b92709d533a571ef868aeeb9ca75/keygen.txt',6,NULL,'d9272c8131724cf6ffd97b4ae8ce150fe7766164',NULL),
(6,'challenge','6f06690f34ca6296d719bfea460af599/nightfall.enc',6,NULL,'ecadd61057a3f0bc7d77b162711e919caccd4c82',NULL),
(7,'standard','416f98ce3527ff322e07348f735c785d/cygnus-logo.svg',NULL,NULL,'1d2c181bc4262081b3f587be37615e66d65ac759',NULL);
/*!40000 ALTER TABLE `files` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flags`
--

DROP TABLE IF EXISTS `flags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `flags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `challenge_id` int(11) DEFAULT NULL,
  `type` varchar(80) DEFAULT NULL,
  `content` text DEFAULT NULL,
  `data` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `flags_ibfk_1` (`challenge_id`),
  CONSTRAINT `flags_ibfk_1` FOREIGN KEY (`challenge_id`) REFERENCES `challenges` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flags`
--

LOCK TABLES `flags` WRITE;
/*!40000 ALTER TABLE `flags` DISABLE KEYS */;
INSERT INTO `flags` VALUES
(1,2,'static','NIGHTFALL{nvale_nightfall}',''),
(2,3,'static','NIGHTFALL{pixels_keep_secrets}',''),
(3,4,'static','NIGHTFALL{object_ids_are_not_authorization}',''),
(5,5,'static','NIGHTFALL{S4_packets_do_not_lie}',''),
(6,6,'static','NIGHTFALL{S5_cipher_archive_unlocked}',''),
(7,7,'static','NIGHTFALL{S6_root_of_the_breach_master}','');
/*!40000 ALTER TABLE `flags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hints`
--

DROP TABLE IF EXISTS `hints`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hints` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(80) DEFAULT NULL,
  `challenge_id` int(11) DEFAULT NULL,
  `content` text DEFAULT NULL,
  `cost` int(11) DEFAULT NULL,
  `requirements` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`requirements`)),
  `title` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `hints_ibfk_1` (`challenge_id`),
  CONSTRAINT `hints_ibfk_1` FOREIGN KEY (`challenge_id`) REFERENCES `challenges` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hints`
--

LOCK TABLES `hints` WRITE;
/*!40000 ALTER TABLE `hints` DISABLE KEYS */;
INSERT INTO `hints` VALUES
(1,'standard',2,'Compare the People and Newsroom pages. Identify the developer associated with the prototype launch material, then find their developer handle and the internal project codename.',10,'{\"prerequisites\": []}','Connect the public clues'),
(2,'standard',2,'View the Newsroom page\'s HTML source and look for a legacy media migration comment. It identifies the launch image. The site\'s robots.txt also points to an archive where you can confirm the developer handle.',15,'{\"prerequisites\": []}','Look beneath the page'),
(3,'standard',3,'A JPEG can contain an embedded file without looking different. Inspect the original image with a JPEG steganography tool such as steghide.',10,'{\"prerequisites\": []}','More than a photograph'),
(4,'standard',3,'Use the developer handle recovered in NF01 as the extraction passphrase. Extract the hidden file with steghide and read the recovered note.',15,'{\"prerequisites\": []}','The developer holds the key'),
(5,'standard',4,'Open your assigned incident and inspect its URL. Which part identifies the individual record?',10,'{\"prerequisites\": []}','Follow the record reference'),
(6,'standard',4,'Being logged in does not mean you should have access to every incident. Try a nearby numeric record ID in the URL and check whether the portal verifies that the record belongs to your account.',15,'{\"prerequisites\": []}','Authentication is not authorization'),
(7,'standard',5,'Filter the packet capture by the incident time window and HTTP request traffic using display filters such as http.request.',15,'{\"prerequisites\": []}','Filter by time and protocol'),
(8,'standard',5,'Use \'Follow TCP Stream\' on the target HTTP exchange in Wireshark, then match its request ID with the timestamps in access.log.',30,'{\"prerequisites\": []}','Follow the stream'),
(9,'standard',6,'The encryption uses deterministic key derivation based on the seed and event date from NF04 rather than a random secret.',20,'{\"prerequisites\": []}','Deterministic Key Derivation'),
(10,'standard',6,'Generate date strings matching the format (YYYY-MM-DD), derive candidate keys using SHA-256 truncation as shown in keygen.txt, and perform authenticated decryption on nightfall.enc.',40,'{\"prerequisites\": []}','Date Candidate Search'),
(11,'standard',7,'Run \'sudo -l\' to check permitted commands, then inspect file permissions and ownership of the executable and its scripts using \'ls -la\'.',25,'{\"prerequisites\": []}','Enumerate Sudo & Permissions'),
(12,'standard',7,'Identify which helper script executed by the root utility resides in a user-writable directory, and modify it to extract /root/final_flag.txt.',50,'{\"prerequisites\": []}','Writable Helper Dependency');
/*!40000 ALTER TABLE `hints` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` text DEFAULT NULL,
  `content` text DEFAULT NULL,
  `date` datetime(6) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `team_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `team_id` (`team_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`),
  CONSTRAINT `notifications_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pages`
--

DROP TABLE IF EXISTS `pages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `pages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(80) DEFAULT NULL,
  `route` varchar(128) DEFAULT NULL,
  `content` text DEFAULT NULL,
  `draft` tinyint(1) DEFAULT NULL,
  `hidden` tinyint(1) DEFAULT NULL,
  `auth_required` tinyint(1) DEFAULT NULL,
  `format` varchar(80) DEFAULT NULL,
  `link_target` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `route` (`route`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pages`
--

LOCK TABLES `pages` WRITE;
/*!40000 ALTER TABLE `pages` DISABLE KEYS */;
INSERT INTO `pages` VALUES
(1,'Operation NIGHTFALL','index','<div style=\"text-align:center; margin-bottom:40px;\">\r\n  <img src=\"/themes/nightfall/static/img/hero-banner.svg\"\r\n       alt=\"Operation NIGHTFALL ??? The Cygnus Labs Breach\"\r\n       style=\"max-width:100%; height:auto; border-radius:8px; border:1px solid #1f2937;\">\r\n</div>\r\n<div class=\"nf-term\">\r\n  <div class=\"ln\"><b>root@cygnus-soc</b>:~# ./nightfall --status</div>\r\n  <div class=\"ln\"><span class=\"ok\">[ OK ]</span> Incident Review Portal online</div>\r\n  <div class=\"ln\"><span class=\"ok\">[ OK ]</span> Forensic evidence vault mounted</div>\r\n  <div class=\"ln\"><span class=\"ok\">[ OK ]</span> Analyst SSH gateway listening</div>\r\n  <div class=\"ln cur\"><b>root@cygnus-soc</b>:~# awaiting operator</div>\r\n</div>\r\n<div id=\"nf-board\" class=\"nf-board\"></div>\r\n<div id=\"nf-done\" class=\"nf-done\"></div>\r\n\r\n<div class=\"nf-cta\">\r\n  <a class=\"nf-btn\" href=\"/challenges\">&gt; Start Mission</a>\r\n</div>\r\n',0,0,0,'html',NULL);
/*!40000 ALTER TABLE `pages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ratings`
--

DROP TABLE IF EXISTS `ratings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ratings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `challenge_id` int(11) DEFAULT NULL,
  `value` int(11) DEFAULT NULL,
  `review` varchar(2000) DEFAULT NULL,
  `date` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`challenge_id`),
  KEY `challenge_id` (`challenge_id`),
  CONSTRAINT `ratings_ibfk_1` FOREIGN KEY (`challenge_id`) REFERENCES `challenges` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ratings_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ratings`
--

LOCK TABLES `ratings` WRITE;
/*!40000 ALTER TABLE `ratings` DISABLE KEYS */;
/*!40000 ALTER TABLE `ratings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `solutions`
--

DROP TABLE IF EXISTS `solutions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `solutions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `challenge_id` int(11) DEFAULT NULL,
  `content` text DEFAULT NULL,
  `state` varchar(80) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `challenge_id` (`challenge_id`),
  CONSTRAINT `solutions_ibfk_1` FOREIGN KEY (`challenge_id`) REFERENCES `challenges` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `solutions`
--

LOCK TABLES `solutions` WRITE;
/*!40000 ALTER TABLE `solutions` DISABLE KEYS */;
/*!40000 ALTER TABLE `solutions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `solves`
--

DROP TABLE IF EXISTS `solves`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `solves` (
  `id` int(11) NOT NULL,
  `challenge_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `team_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `challenge_id` (`challenge_id`,`team_id`),
  UNIQUE KEY `challenge_id_2` (`challenge_id`,`user_id`),
  KEY `team_id` (`team_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `solves_ibfk_1` FOREIGN KEY (`challenge_id`) REFERENCES `challenges` (`id`) ON DELETE CASCADE,
  CONSTRAINT `solves_ibfk_2` FOREIGN KEY (`id`) REFERENCES `submissions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `solves_ibfk_3` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE,
  CONSTRAINT `solves_ibfk_4` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `solves`
--

LOCK TABLES `solves` WRITE;
/*!40000 ALTER TABLE `solves` DISABLE KEYS */;
INSERT INTO `solves` VALUES
(27,2,7,NULL),
(28,3,7,NULL),
(29,4,7,NULL),
(31,5,7,NULL),
(32,6,7,NULL),
(33,7,7,NULL);
/*!40000 ALTER TABLE `solves` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `submissions`
--

DROP TABLE IF EXISTS `submissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `submissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `challenge_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `team_id` int(11) DEFAULT NULL,
  `ip` varchar(46) DEFAULT NULL,
  `provided` text DEFAULT NULL,
  `type` varchar(32) DEFAULT NULL,
  `date` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `challenge_id` (`challenge_id`),
  KEY `team_id` (`team_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `submissions_ibfk_1` FOREIGN KEY (`challenge_id`) REFERENCES `challenges` (`id`) ON DELETE CASCADE,
  CONSTRAINT `submissions_ibfk_2` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE,
  CONSTRAINT `submissions_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `submissions`
--

LOCK TABLES `submissions` WRITE;
/*!40000 ALTER TABLE `submissions` DISABLE KEYS */;
INSERT INTO `submissions` VALUES
(25,2,7,NULL,'172.20.0.1','CODEFEST{w4t3r3d_th3_f0xgl0v3}','incorrect','2026-10-10 19:12:06.212982'),
(26,2,7,NULL,'172.20.0.1','CODEFEST{w4t3r3d_th3_f0xgl0v3}','incorrect','2026-10-10 19:12:30.090722'),
(27,2,7,NULL,'172.20.0.1','NIGHTFALL{nvale_nightfall}','correct','2026-10-10 19:14:12.484998'),
(28,3,7,NULL,'172.20.0.1','NIGHTFALL{pixels_keep_secrets}','correct','2026-10-10 19:15:16.419553'),
(29,4,7,NULL,'172.20.0.1','NIGHTFALL{object_ids_are_not_authorization}','correct','2026-10-10 19:15:35.186746'),
(30,5,7,NULL,'172.20.0.1','NIGHTFALL{S4_packets_do_not_lie','incorrect','2026-10-10 19:16:27.210065'),
(31,5,7,NULL,'172.20.0.1','NIGHTFALL{S4_packets_do_not_lie}','correct','2026-10-10 19:16:46.938526'),
(32,6,7,NULL,'172.20.0.1','NIGHTFALL{S5_cipher_archive_unlocked}','correct','2026-10-10 19:17:07.319229'),
(33,7,7,NULL,'172.20.0.1','NIGHTFALL{S6_root_of_the_breach_master}','correct','2026-10-10 19:17:23.844573');
/*!40000 ALTER TABLE `submissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tags`
--

DROP TABLE IF EXISTS `tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `challenge_id` int(11) DEFAULT NULL,
  `value` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tags_ibfk_1` (`challenge_id`),
  CONSTRAINT `tags_ibfk_1` FOREIGN KEY (`challenge_id`) REFERENCES `challenges` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tags`
--

LOCK TABLES `tags` WRITE;
/*!40000 ALTER TABLE `tags` DISABLE KEYS */;
/*!40000 ALTER TABLE `tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `teams`
--

DROP TABLE IF EXISTS `teams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `teams` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `oauth_id` int(11) DEFAULT NULL,
  `name` varchar(128) DEFAULT NULL,
  `email` varchar(128) DEFAULT NULL,
  `password` varchar(128) DEFAULT NULL,
  `secret` varchar(128) DEFAULT NULL,
  `website` varchar(128) DEFAULT NULL,
  `affiliation` varchar(128) DEFAULT NULL,
  `country` varchar(32) DEFAULT NULL,
  `hidden` tinyint(1) DEFAULT NULL,
  `banned` tinyint(1) DEFAULT NULL,
  `created` datetime(6) DEFAULT NULL,
  `captain_id` int(11) DEFAULT NULL,
  `bracket_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `id` (`id`,`oauth_id`),
  UNIQUE KEY `oauth_id` (`oauth_id`),
  KEY `team_captain_id` (`captain_id`),
  KEY `bracket_id` (`bracket_id`),
  CONSTRAINT `team_captain_id` FOREIGN KEY (`captain_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `teams_ibfk_1` FOREIGN KEY (`bracket_id`) REFERENCES `brackets` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teams`
--

LOCK TABLES `teams` WRITE;
/*!40000 ALTER TABLE `teams` DISABLE KEYS */;
/*!40000 ALTER TABLE `teams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tokens`
--

DROP TABLE IF EXISTS `tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(32) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created` datetime(6) DEFAULT NULL,
  `expiration` datetime(6) DEFAULT NULL,
  `value` varchar(128) DEFAULT NULL,
  `description` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `value` (`value`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `tokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tokens`
--

LOCK TABLES `tokens` WRITE;
/*!40000 ALTER TABLE `tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `topics`
--

DROP TABLE IF EXISTS `topics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `topics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `value` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `value` (`value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `topics`
--

LOCK TABLES `topics` WRITE;
/*!40000 ALTER TABLE `topics` DISABLE KEYS */;
/*!40000 ALTER TABLE `topics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tracking`
--

DROP TABLE IF EXISTS `tracking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tracking` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(32) DEFAULT NULL,
  `ip` varchar(46) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `date` datetime(6) DEFAULT NULL,
  `target` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tracking_ibfk_1` (`user_id`),
  CONSTRAINT `tracking_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tracking`
--

LOCK TABLES `tracking` WRITE;
/*!40000 ALTER TABLE `tracking` DISABLE KEYS */;
/*!40000 ALTER TABLE `tracking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `unlocks`
--

DROP TABLE IF EXISTS `unlocks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `unlocks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `team_id` int(11) DEFAULT NULL,
  `target` int(11) DEFAULT NULL,
  `date` datetime(6) DEFAULT NULL,
  `type` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `unlocks_ibfk_1` (`team_id`),
  KEY `unlocks_ibfk_2` (`user_id`),
  CONSTRAINT `unlocks_ibfk_1` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE,
  CONSTRAINT `unlocks_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `unlocks`
--

LOCK TABLES `unlocks` WRITE;
/*!40000 ALTER TABLE `unlocks` DISABLE KEYS */;
INSERT INTO `unlocks` VALUES
(4,7,NULL,7,'2026-10-10 19:15:59.538512','hints'),
(5,7,NULL,8,'2026-10-10 19:16:03.989509','hints');
/*!40000 ALTER TABLE `unlocks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `oauth_id` int(11) DEFAULT NULL,
  `name` varchar(128) DEFAULT NULL,
  `password` varchar(128) DEFAULT NULL,
  `email` varchar(128) DEFAULT NULL,
  `type` varchar(80) DEFAULT NULL,
  `secret` varchar(128) DEFAULT NULL,
  `website` varchar(128) DEFAULT NULL,
  `affiliation` varchar(128) DEFAULT NULL,
  `country` varchar(32) DEFAULT NULL,
  `hidden` tinyint(1) DEFAULT NULL,
  `banned` tinyint(1) DEFAULT NULL,
  `verified` tinyint(1) DEFAULT NULL,
  `team_id` int(11) DEFAULT NULL,
  `created` datetime(6) DEFAULT NULL,
  `language` varchar(32) DEFAULT NULL,
  `bracket_id` int(11) DEFAULT NULL,
  `change_password` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `id` (`id`,`oauth_id`),
  UNIQUE KEY `oauth_id` (`oauth_id`),
  KEY `team_id` (`team_id`),
  KEY `bracket_id` (`bracket_id`),
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`),
  CONSTRAINT `users_ibfk_2` FOREIGN KEY (`bracket_id`) REFERENCES `brackets` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES
(7,NULL,'admin','$bcrypt-sha256$v=2,t=2b,r=12$N5jkzpBYl6cEW7bjhwTsKO$7A1H1KR1rl4U4okULNxDUGiylFHq4Ta','admin@example.com','admin',NULL,NULL,NULL,'LK',1,0,1,NULL,'2026-10-10 09:24:34.654949',NULL,NULL,0);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2026-10-11  9:04:19

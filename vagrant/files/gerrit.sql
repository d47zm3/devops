-- MySQL dump 10.14  Distrib 5.5.50-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: gerrit_reviewdb
-- ------------------------------------------------------
-- Server version	5.5.50-MariaDB

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
-- Table structure for table `account_diff_preferences`
--

DROP TABLE IF EXISTS `account_diff_preferences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `account_diff_preferences` (
  `ignore_whitespace` char(1) NOT NULL DEFAULT '',
  `tab_size` int(11) NOT NULL DEFAULT '0',
  `line_length` int(11) NOT NULL DEFAULT '0',
  `syntax_highlighting` char(1) NOT NULL DEFAULT 'N',
  `show_whitespace_errors` char(1) NOT NULL DEFAULT 'N',
  `intraline_difference` char(1) NOT NULL DEFAULT 'N',
  `show_tabs` char(1) NOT NULL DEFAULT 'N',
  `context` smallint(6) NOT NULL DEFAULT '0',
  `skip_deleted` char(1) NOT NULL DEFAULT 'N',
  `skip_uncommented` char(1) NOT NULL DEFAULT 'N',
  `expand_all_comments` char(1) NOT NULL DEFAULT 'N',
  `retain_header` char(1) NOT NULL DEFAULT 'N',
  `manual_review` char(1) NOT NULL DEFAULT 'N',
  `show_line_endings` char(1) NOT NULL DEFAULT 'N',
  `hide_top_menu` char(1) NOT NULL DEFAULT 'N',
  `hide_line_numbers` char(1) NOT NULL DEFAULT 'N',
  `render_entire_file` char(1) NOT NULL DEFAULT 'N',
  `theme` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `hide_empty_pane` char(1) NOT NULL DEFAULT 'N',
  `auto_hide_diff_table_header` char(1) NOT NULL DEFAULT 'N',
  `id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account_diff_preferences`
--

LOCK TABLES `account_diff_preferences` WRITE;
/*!40000 ALTER TABLE `account_diff_preferences` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_diff_preferences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `account_external_ids`
--

DROP TABLE IF EXISTS `account_external_ids`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `account_external_ids` (
  `account_id` int(11) NOT NULL DEFAULT '0',
  `email_address` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `password` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `external_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`external_id`),
  KEY `account_external_ids_byAccount` (`account_id`),
  KEY `account_external_ids_byEmail` (`email_address`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account_external_ids`
--

LOCK TABLES `account_external_ids` WRITE;
/*!40000 ALTER TABLE `account_external_ids` DISABLE KEYS */;
INSERT INTO `account_external_ids` VALUES (1,NULL,NULL,'gerrit:damian.tykalowski'),(1,'d47zm3@gmail.com',NULL,'mailto:d47zm3@gmail.com'),(1,NULL,NULL,'username:damian.tykalowski'),(2,NULL,NULL,'username:jenkins');
/*!40000 ALTER TABLE `account_external_ids` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `account_group_by_id`
--

DROP TABLE IF EXISTS `account_group_by_id`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `account_group_by_id` (
  `group_id` int(11) NOT NULL DEFAULT '0',
  `include_uuid` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`group_id`,`include_uuid`),
  KEY `account_group_id_byInclude` (`include_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account_group_by_id`
--

LOCK TABLES `account_group_by_id` WRITE;
/*!40000 ALTER TABLE `account_group_by_id` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_group_by_id` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `account_group_by_id_aud`
--

DROP TABLE IF EXISTS `account_group_by_id_aud`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `account_group_by_id_aud` (
  `added_by` int(11) NOT NULL DEFAULT '0',
  `removed_by` int(11) DEFAULT NULL,
  `removed_on` timestamp NULL DEFAULT NULL,
  `group_id` int(11) NOT NULL DEFAULT '0',
  `include_uuid` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  `added_on` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`group_id`,`include_uuid`,`added_on`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account_group_by_id_aud`
--

LOCK TABLES `account_group_by_id_aud` WRITE;
/*!40000 ALTER TABLE `account_group_by_id_aud` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_group_by_id_aud` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `account_group_id`
--

DROP TABLE IF EXISTS `account_group_id`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `account_group_id` (
  `s` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  UNIQUE KEY `s` (`s`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account_group_id`
--

LOCK TABLES `account_group_id` WRITE;
/*!40000 ALTER TABLE `account_group_id` DISABLE KEYS */;
INSERT INTO `account_group_id` VALUES (1),(2),(3);
/*!40000 ALTER TABLE `account_group_id` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `account_group_members`
--

DROP TABLE IF EXISTS `account_group_members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `account_group_members` (
  `account_id` int(11) NOT NULL DEFAULT '0',
  `group_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`account_id`,`group_id`),
  KEY `account_group_members_byGroup` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account_group_members`
--

LOCK TABLES `account_group_members` WRITE;
/*!40000 ALTER TABLE `account_group_members` DISABLE KEYS */;
INSERT INTO `account_group_members` VALUES (1,1),(1,3),(2,2),(2,3);
/*!40000 ALTER TABLE `account_group_members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `account_group_members_audit`
--

DROP TABLE IF EXISTS `account_group_members_audit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `account_group_members_audit` (
  `added_by` int(11) NOT NULL DEFAULT '0',
  `removed_by` int(11) DEFAULT NULL,
  `removed_on` timestamp NULL DEFAULT NULL,
  `account_id` int(11) NOT NULL DEFAULT '0',
  `group_id` int(11) NOT NULL DEFAULT '0',
  `added_on` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`account_id`,`group_id`,`added_on`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account_group_members_audit`
--

LOCK TABLES `account_group_members_audit` WRITE;
/*!40000 ALTER TABLE `account_group_members_audit` DISABLE KEYS */;
INSERT INTO `account_group_members_audit` VALUES (1,NULL,NULL,1,1,'2016-11-09 17:04:02'),(1,NULL,NULL,1,3,'2016-11-09 17:25:45'),(1,NULL,NULL,2,2,'2016-11-09 17:25:53'),(1,NULL,NULL,2,3,'2016-11-09 17:26:03');
/*!40000 ALTER TABLE `account_group_members_audit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `account_group_names`
--

DROP TABLE IF EXISTS `account_group_names`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `account_group_names` (
  `group_id` int(11) NOT NULL DEFAULT '0',
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account_group_names`
--

LOCK TABLES `account_group_names` WRITE;
/*!40000 ALTER TABLE `account_group_names` DISABLE KEYS */;
INSERT INTO `account_group_names` VALUES (1,'Administrators'),(3,'Event Streaming Users'),(2,'Non-Interactive Users');
/*!40000 ALTER TABLE `account_group_names` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `account_groups`
--

DROP TABLE IF EXISTS `account_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `account_groups` (
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  `description` text,
  `visible_to_all` char(1) NOT NULL DEFAULT 'N',
  `group_uuid` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  `owner_group_uuid` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  `group_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account_groups`
--

LOCK TABLES `account_groups` WRITE;
/*!40000 ALTER TABLE `account_groups` DISABLE KEYS */;
INSERT INTO `account_groups` VALUES ('Administrators','Gerrit Site Administrators','N','e6ceccc6a2eb7603dd519b44da579a05672450a5','e6ceccc6a2eb7603dd519b44da579a05672450a5',1),('Non-Interactive Users','Users who perform batch actions on Gerrit','N','b35824ba8e38f0431c7ce83aeceed7d24bbb5dbe','e6ceccc6a2eb7603dd519b44da579a05672450a5',2),('Event Streaming Users',NULL,'N','66e60b2f14797dbfbab2e34db586eeb1360bbf4f','66e60b2f14797dbfbab2e34db586eeb1360bbf4f',3);
/*!40000 ALTER TABLE `account_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `account_id`
--

DROP TABLE IF EXISTS `account_id`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `account_id` (
  `s` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  UNIQUE KEY `s` (`s`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account_id`
--

LOCK TABLES `account_id` WRITE;
/*!40000 ALTER TABLE `account_id` DISABLE KEYS */;
INSERT INTO `account_id` VALUES (1),(2);
/*!40000 ALTER TABLE `account_id` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `account_patch_reviews`
--

DROP TABLE IF EXISTS `account_patch_reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `account_patch_reviews` (
  `account_id` int(11) NOT NULL DEFAULT '0',
  `change_id` int(11) NOT NULL DEFAULT '0',
  `patch_set_id` int(11) NOT NULL DEFAULT '0',
  `file_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`account_id`,`change_id`,`patch_set_id`,`file_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account_patch_reviews`
--

LOCK TABLES `account_patch_reviews` WRITE;
/*!40000 ALTER TABLE `account_patch_reviews` DISABLE KEYS */;
INSERT INTO `account_patch_reviews` VALUES (1,12,1,'app/src/main/webapp/index.jsp'),(1,16,1,'app/src/main/webapp/index.jsp');
/*!40000 ALTER TABLE `account_patch_reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `account_project_watches`
--

DROP TABLE IF EXISTS `account_project_watches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `account_project_watches` (
  `notify_new_changes` char(1) NOT NULL DEFAULT 'N',
  `notify_all_comments` char(1) NOT NULL DEFAULT 'N',
  `notify_submitted_changes` char(1) NOT NULL DEFAULT 'N',
  `notify_new_patch_sets` char(1) NOT NULL DEFAULT 'N',
  `notify_abandoned_changes` char(1) NOT NULL DEFAULT 'N',
  `account_id` int(11) NOT NULL DEFAULT '0',
  `project_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  `filter` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`account_id`,`project_name`,`filter`),
  KEY `account_project_watches_byP` (`project_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account_project_watches`
--

LOCK TABLES `account_project_watches` WRITE;
/*!40000 ALTER TABLE `account_project_watches` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_project_watches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `account_ssh_keys`
--

DROP TABLE IF EXISTS `account_ssh_keys`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `account_ssh_keys` (
  `ssh_public_key` text NOT NULL,
  `valid` char(1) NOT NULL DEFAULT 'N',
  `account_id` int(11) NOT NULL DEFAULT '0',
  `seq` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`account_id`,`seq`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account_ssh_keys`
--

LOCK TABLES `account_ssh_keys` WRITE;
/*!40000 ALTER TABLE `account_ssh_keys` DISABLE KEYS */;
INSERT INTO `account_ssh_keys` VALUES ('ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC0djiCP59PSRZftJgtDKfwVRAisdOvijL3628cVAZOJOC85BcPAUwWZt+Ak6wgjW8Acro3q6YFlcq2qpBjLiqebk7+zVuneh8UnLMzLu0y4PwnM9ikDhpCqvhjCqxkeix+GmYDcP//G+2iIzJzedLxmNvyp+x/2zY9tN2EfbqTlTp3SDPyxMxC6Vp6UNgIKOuyMt6ZGQfrsUctacSITJYBJe5ybGA9R6rfCpaVT9wZ9o0nH1LbvFs8K7HGwsWZrjuYgT+RBwJ6KkisOcao4YKCD2G0dlrqi/mGBt+EPiagvvx5SYNbdDafJQ9NYco270gSmFyF38IEwxU0OO1zXzst damian.tykalowski@master01.devops.pl\n','Y',1,1),('ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDcYOgowVQFiwuWP4Aia2lvRzsHgfa6l5s7BkI5q8gU7w0K2TQS1w8zBq+wGI0wBagwWi/Ip34I4iSo/9ByYcrrkNyiRVqKAwwv/J+MZbX3z3PyiUNwEG0dEPiAwDxH5keYlWebfbeUzusAoQCUwIsq7L8/v6DRPGnKlMHowHVKETZquIPoUkiXeNxWdt1kop6nFYRBlAg+5X+Xq2GJzfbITatbcLhsOtdvOimVJDhAYGyFh4Eq+ATjBWY24vSu0Q7ZV9rcWOZXY8Bi3oWrXd387g+JZcuIXKiTITN808pvwCUOTWsZVB3A54URpVXOO89vfuF5WlS58KuvQA2ZdkJr jenkins@devops01.devops.pl\n','Y',2,1),('ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCjT4zsFFU3m6hWxeIbhlYREaFK/4FE0+gPQZ1RgADUuYNmfdURnhT6uxvgmLu8Sq9Z7KD9PRA/INHpujoiaYF6s4O/AHnj+GUzO2K/y8jHaUZrdXvQOkaO9msLpPooj05CKzJo6WUs/3EoZwVFj3T3XVbXtmxs7uDqAOwc7tnEMY1ZIZ2U4jeScXjpByoP30S6H43S9VFkXdG+s5jCAY4TO2idVr1ustNg/aZYcQTTfaRVYpDtTFZMFCh8nvRZH6dpQhcNmTId760uQRZjEXYQl7+sfwIasQYf9ehEwt/tmFBZHVUDGsJJsEyheYlpwt0jAnTw7OsG7FI9tqt4zyQx jenkins@devops01.devops.pl\n','Y',2,2),('ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCjT4zsFFU3m6hWxeIbhlYREaFK/4FE0+gPQZ1RgADUuYNmfdURnhT6uxvgmLu8Sq9Z7KD9PRA/INHpujoiaYF6s4O/AHnj+GUzO2K/y8jHaUZrdXvQOkaO9msLpPooj05CKzJo6WUs/3EoZwVFj3T3XVbXtmxs7uDqAOwc7tnEMY1ZIZ2U4jeScXjpByoP30S6H43S9VFkXdG+s5jCAY4TO2idVr1ustNg/aZYcQTTfaRVYpDtTFZMFCh8nvRZH6dpQhcNmTId760uQRZjEXYQl7+sfwIasQYf9ehEwt/tmFBZHVUDGsJJsEyheYlpwt0jAnTw7OsG7FI9tqt4zyQx jenkins@devops01.devops.pl\n','Y',2,3);
/*!40000 ALTER TABLE `account_ssh_keys` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `accounts`
--

DROP TABLE IF EXISTS `accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accounts` (
  `registered_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `full_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `preferred_email` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `contact_filed_on` timestamp NULL DEFAULT NULL,
  `maximum_page_size` smallint(6) NOT NULL DEFAULT '0',
  `show_site_header` char(1) NOT NULL DEFAULT 'N',
  `use_flash_clipboard` char(1) NOT NULL DEFAULT 'N',
  `download_url` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `download_command` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `copy_self_on_email` char(1) NOT NULL DEFAULT 'N',
  `date_format` varchar(10) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `time_format` varchar(10) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `relative_date_in_change_table` char(1) NOT NULL DEFAULT 'N',
  `diff_view` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `size_bar_in_change_table` char(1) NOT NULL DEFAULT 'N',
  `legacycid_in_change_table` char(1) NOT NULL DEFAULT 'N',
  `review_category_strategy` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `mute_common_path_prefixes` char(1) NOT NULL DEFAULT 'N',
  `inactive` char(1) NOT NULL DEFAULT 'N',
  `account_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`account_id`),
  KEY `accounts_byPreferredEmail` (`preferred_email`),
  KEY `accounts_byFullName` (`full_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts`
--

LOCK TABLES `accounts` WRITE;
/*!40000 ALTER TABLE `accounts` DISABLE KEYS */;
INSERT INTO `accounts` VALUES ('2016-11-09 17:04:02','Damian Tykalowski','d47zm3@gmail.com',NULL,25,'Y','Y','SSH','CHECKOUT','N',NULL,NULL,'N',NULL,'Y','N',NULL,'Y','N',1),('2016-11-09 17:15:19','Jenkins',NULL,NULL,25,'Y','Y',NULL,NULL,'N',NULL,NULL,'N',NULL,'Y','N',NULL,'Y','N',2);
/*!40000 ALTER TABLE `accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `change_id`
--

DROP TABLE IF EXISTS `change_id`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `change_id` (
  `s` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  UNIQUE KEY `s` (`s`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `change_id`
--

LOCK TABLES `change_id` WRITE;
/*!40000 ALTER TABLE `change_id` DISABLE KEYS */;
INSERT INTO `change_id` VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12),(13),(14),(15),(16),(17),(18),(19),(20),(21),(22),(23),(24),(25),(26),(27),(28),(29);
/*!40000 ALTER TABLE `change_id` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `change_message_id`
--

DROP TABLE IF EXISTS `change_message_id`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `change_message_id` (
  `s` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  UNIQUE KEY `s` (`s`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `change_message_id`
--

LOCK TABLES `change_message_id` WRITE;
/*!40000 ALTER TABLE `change_message_id` DISABLE KEYS */;
INSERT INTO `change_message_id` VALUES (1),(2),(3),(4);
/*!40000 ALTER TABLE `change_message_id` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `change_messages`
--

DROP TABLE IF EXISTS `change_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `change_messages` (
  `author_id` int(11) DEFAULT NULL,
  `written_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `message` text,
  `patchset_change_id` int(11) DEFAULT NULL,
  `patchset_patch_set_id` int(11) DEFAULT NULL,
  `change_id` int(11) NOT NULL DEFAULT '0',
  `uuid` varchar(40) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`change_id`,`uuid`),
  KEY `change_messages_byPatchset` (`patchset_change_id`,`patchset_patch_set_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `change_messages`
--

LOCK TABLES `change_messages` WRITE;
/*!40000 ALTER TABLE `change_messages` DISABLE KEYS */;
INSERT INTO `change_messages` VALUES (2,'2016-11-10 17:21:01','Patch Set 1: Verified-1\n\nBuild Failed \n\nhttp://jenkins.devops.pl:8080/job/MavenDemo/2/ : FAILURE',1,1,1,'daeb3561_01136a5d'),(2,'2016-11-10 17:21:00','Patch Set 1: -Verified\n\nBuild Started http://jenkins.devops.pl:8080/job/MavenDemo/2/',1,1,1,'daeb3561_210e6e35'),(2,'2016-11-10 17:19:47','Patch Set 1: Verified-1\n\nBuild Failed \n\nhttp://jenkins.devops.pl:8080/job/MavenDemo/1/ : FAILURE',1,1,1,'daeb3561_4109722b'),(2,'2016-11-10 17:35:43','Patch Set 1:\n\nBuild Successful \n\nhttp://jenkins.devops.pl:8080/job/MavenDemo/3/ : SUCCESS',1,1,1,'daeb3561_4120529b'),(2,'2016-11-10 17:19:46','Patch Set 1:\n\nBuild Started http://jenkins.devops.pl:8080/job/MavenDemo/1/',1,1,1,'daeb3561_61047615'),(2,'2016-11-10 17:35:20','Patch Set 1:\n\nBuild Started http://jenkins.devops.pl:8080/job/MavenDemo/3/',1,1,1,'daeb3561_612b5683'),(NULL,'2016-11-10 17:34:44','Change has been successfully merged into the git repository by Damian Tykalowski',1,1,1,'daeb3561_81265ab9'),(1,'2016-11-10 17:19:38','Uploaded patch set 1.',1,1,1,'daeb3561_81ff7a01'),(1,'2016-11-10 17:34:39','Removed the following votes:\n\n* Verified-1 by Jenkins (2)\n',1,1,1,'daeb3561_a1195e7b'),(1,'2016-11-10 17:33:24','Patch Set 1: Verified+1',1,1,1,'daeb3561_c11c626d'),(1,'2016-11-10 17:30:34','Patch Set 1: Code-Review+2',1,1,1,'daeb3561_e10f662d'),(1,'2016-11-10 18:29:48','Patch Set 1: Code-Review+2 Verified+1',2,1,2,'daeb3561_013a4acd'),(1,'2016-11-10 18:29:32','Uploaded patch set 1.',2,1,2,'daeb3561_21254eab'),(2,'2016-11-10 18:33:12','Patch Set 1:\n\nBuild Successful \n\nhttp://jenkins.devops.pl:8080/job/MavenDemo/6/ : SUCCESS',2,1,2,'daeb3561_215c2e25'),(2,'2016-11-10 18:33:00','Patch Set 1:\n\nBuild Started http://jenkins.devops.pl:8080/job/MavenDemo/6/',2,1,2,'daeb3561_41573203'),(2,'2016-11-10 18:31:28','Patch Set 1:\n\nBuild Failed \n\nhttp://jenkins.devops.pl:8080/job/MavenDemo/5/ : FAILURE',2,1,2,'daeb3561_61523615'),(2,'2016-11-10 18:31:05','Patch Set 1:\n\nBuild Started http://jenkins.devops.pl:8080/job/MavenDemo/5/',2,1,2,'daeb3561_814d3a75'),(2,'2016-11-10 18:30:15','Patch Set 1:\n\nBuild Failed \n\nhttp://jenkins.devops.pl:8080/job/MavenDemo/4/ : FAILURE',2,1,2,'daeb3561_a1303ee9'),(2,'2016-11-10 18:30:08','Patch Set 1:\n\nBuild Started http://jenkins.devops.pl:8080/job/MavenDemo/4/',2,1,2,'daeb3561_c13342f5'),(NULL,'2016-11-10 18:29:59','Change has been successfully merged into the git repository by Damian Tykalowski',2,1,2,'daeb3561_e13646e7'),(1,'2016-11-10 18:34:34','Uploaded patch set 1.',3,1,3,'daeb3561_01412a39'),(2,'2016-11-10 18:35:19','Patch Set 1:\n\nBuild Successful \n\nhttp://jenkins.devops.pl:8080/job/MavenDemo/7/ : SUCCESS',3,1,3,'daeb3561_81741a9d'),(2,'2016-11-10 18:35:08','Patch Set 1:\n\nBuild Started http://jenkins.devops.pl:8080/job/MavenDemo/7/',3,1,3,'daeb3561_a1471e4b'),(NULL,'2016-11-10 18:35:00','Change has been successfully merged into the git repository by Damian Tykalowski',3,1,3,'daeb3561_c14a2255'),(1,'2016-11-10 18:34:58','Patch Set 1: Code-Review+2 Verified+1',3,1,3,'daeb3561_e13d26bd'),(1,'2016-11-13 09:47:11','Change has been successfully pushed.',4,1,4,'baf0414d_200e6a35'),(2,'2016-11-13 09:32:27','Patch Set 1: Verified-1\n\nBuild Failed \n\nhttp://jenkins.devops.pl:8080/job/MavenDemo/8/ : FAILURE',4,1,4,'baf0414d_40096e2b'),(2,'2016-11-13 09:32:13','Patch Set 1:\n\nBuild Started http://jenkins.devops.pl:8080/job/MavenDemo/8/',4,1,4,'baf0414d_60047215'),(1,'2016-11-13 09:32:03','Uploaded patch set 1.',4,1,4,'baf0414d_80ff7601'),(1,'2016-11-13 09:49:25','Uploaded patch set 1.',5,1,5,'baf0414d_0013665d'),(2,'2016-11-13 10:05:15','Patch Set 1: Verified-1\n\nBuild Failed \n\nhttp://jenkins.devops.pl:8080/job/MavenDemo/14/ : FAILURE',5,1,5,'baf0414d_003a46cd'),(2,'2016-11-13 10:14:32','Patch Set 1: Verified-1\n\nBuild Failed \n\nhttp://jenkins.devops.pl:8080/job/MavenDemo/17/ : FAILURE',5,1,5,'baf0414d_00412639'),(2,'2016-11-13 10:05:15','Patch Set 1: -Verified\n\nBuild Started http://jenkins.devops.pl:8080/job/MavenDemo/14/',5,1,5,'baf0414d_20254aab'),(2,'2016-11-13 10:14:31','Patch Set 1: -Verified\n\nBuild Started http://jenkins.devops.pl:8080/job/MavenDemo/17/',5,1,5,'baf0414d_205c2a25'),(1,'2016-11-13 10:30:48','Abandoned',5,1,5,'baf0414d_20aaead4'),(2,'2016-11-13 10:03:11','Patch Set 1: Verified-1\n\nBuild Failed \n\nhttp://jenkins.devops.pl:8080/job/MavenDemo/12/ : FAILURE',5,1,5,'baf0414d_40204e9b'),(2,'2016-11-13 10:03:11','Patch Set 1: -Verified\n\nBuild Started http://jenkins.devops.pl:8080/job/MavenDemo/12/',5,1,5,'baf0414d_602b5283'),(2,'2016-11-13 10:02:13','Patch Set 1: Verified-1\n\nBuild Failed \n\nhttp://jenkins.devops.pl:8080/job/MavenDemo/11/ : FAILURE',5,1,5,'baf0414d_802656b9'),(2,'2016-11-13 10:07:25','Patch Set 1: Verified-1\n\nBuild Failed \n\nhttp://jenkins.devops.pl:8080/job/MavenDemo/16/ : FAILURE',5,1,5,'baf0414d_804d3675'),(2,'2016-11-13 10:02:12','Patch Set 1: -Verified\n\nBuild Started http://jenkins.devops.pl:8080/job/MavenDemo/11/',5,1,5,'baf0414d_a0195a7b'),(2,'2016-11-13 10:07:16','Patch Set 1: -Verified\n\nBuild Started http://jenkins.devops.pl:8080/job/MavenDemo/16/',5,1,5,'baf0414d_a0303ae9'),(2,'2016-11-13 09:49:42','Patch Set 1: Verified-1\n\nBuild Failed \n\nhttp://jenkins.devops.pl:8080/job/MavenDemo/10/ : FAILURE',5,1,5,'baf0414d_c01c5e6d'),(2,'2016-11-13 10:05:52','Patch Set 1: Verified-1\n\nBuild Failed \n\nhttp://jenkins.devops.pl:8080/job/MavenDemo/15/ : FAILURE',5,1,5,'baf0414d_c0333ef5'),(2,'2016-11-13 09:49:33','Patch Set 1:\n\nBuild Started http://jenkins.devops.pl:8080/job/MavenDemo/10/',5,1,5,'baf0414d_e00f622d'),(2,'2016-11-13 10:05:52','Patch Set 1: -Verified\n\nBuild Started http://jenkins.devops.pl:8080/job/MavenDemo/15/',5,1,5,'baf0414d_e03642e7'),(1,'2016-11-13 10:12:04','Uploaded patch set 1.',6,1,6,'baf0414d_60523215'),(1,'2016-11-13 10:30:17','Abandoned',6,1,6,'baf0414d_c061fed4'),(1,'2016-11-13 10:13:15','Uploaded patch set 1.',7,1,7,'baf0414d_40572e03'),(1,'2016-11-13 10:30:31','Abandoned',7,1,7,'baf0414d_a05efa10'),(1,'2016-11-13 10:30:34','Abandoned',8,1,8,'baf0414d_809bf6c8'),(1,'2016-11-13 10:15:59','Uploaded patch set 1.',8,1,8,'baf0414d_e03d22bd'),(1,'2016-11-13 10:30:38','Abandoned',9,1,9,'baf0414d_60a0f2f4'),(1,'2016-11-13 10:17:06','Uploaded patch set 1.',9,1,9,'baf0414d_c04a1e55'),(2,'2016-11-13 10:26:39','Patch Set 1: -Verified\n\nBuild Started http://jenkins.devops.pl:8080/job/MavenDemo/20/',10,1,10,'baf0414d_006806b9'),(2,'2016-11-13 10:44:56','Patch Set 1:\n\nBuild Started http://jenkins.devops.pl:8080/job/MavenDemo/25/',10,1,10,'baf0414d_0096c694'),(2,'2016-11-13 10:36:50','Patch Set 1:\n\nBuild Started http://jenkins.devops.pl:8080/job/MavenDemo/21/',10,1,10,'baf0414d_00afe6e4'),(2,'2016-11-13 10:22:07','Patch Set 1: Verified-1\n\nBuild Failed \n\nhttp://jenkins.devops.pl:8080/job/MavenDemo/19/ : FAILURE',10,1,10,'baf0414d_20730ab3'),(2,'2016-11-13 10:43:54','Patch Set 1:\n\nBuild Failed \n\nhttp://jenkins.devops.pl:8080/job/MavenDemo/24/ : FAILURE',10,1,10,'baf0414d_2081ca4a'),(2,'2016-11-13 10:21:59','Patch Set 1: -Verified\n\nBuild Started http://jenkins.devops.pl:8080/job/MavenDemo/19/',10,1,10,'baf0414d_406e0ecb'),(2,'2016-11-13 10:43:43','Patch Set 1:\n\nBuild Started http://jenkins.devops.pl:8080/job/MavenDemo/24/',10,1,10,'baf0414d_407cce72'),(1,'2016-11-13 10:30:42','Abandoned',10,1,10,'baf0414d_40a5ee02'),(2,'2016-11-13 10:17:59','Patch Set 1: Verified-1\n\nBuild Failed \n\nhttp://jenkins.devops.pl:8080/job/MavenDemo/18/ : FAILURE',10,1,10,'baf0414d_60791293'),(2,'2016-11-13 10:40:24','Patch Set 1:\n\nBuild Failed \n\nhttp://jenkins.devops.pl:8080/job/MavenDemo/23/ : FAILURE',10,1,10,'baf0414d_6087d262'),(2,'2016-11-13 10:17:49','Patch Set 1:\n\nBuild Started http://jenkins.devops.pl:8080/job/MavenDemo/18/',10,1,10,'baf0414d_8074169d'),(2,'2016-11-13 10:40:12','Patch Set 1:\n\nBuild Started http://jenkins.devops.pl:8080/job/MavenDemo/23/',10,1,10,'baf0414d_8082d650'),(1,'2016-11-13 10:17:44','Uploaded patch set 1.',10,1,10,'baf0414d_a0471a4b'),(2,'2016-11-13 10:39:20','Patch Set 1:\n\nBuild Failed \n\nhttp://jenkins.devops.pl:8080/job/MavenDemo/22/ : FAILURE',10,1,10,'baf0414d_a0b5da32'),(2,'2016-11-13 10:39:11','Patch Set 1:\n\nBuild Started http://jenkins.devops.pl:8080/job/MavenDemo/22/',10,1,10,'baf0414d_c0b8de2c'),(2,'2016-11-13 10:26:48','Patch Set 1: Verified-1\n\nBuild Failed \n\nhttp://jenkins.devops.pl:8080/job/MavenDemo/20/ : FAILURE',10,1,10,'baf0414d_e06402e7'),(2,'2016-11-13 10:45:07','Patch Set 1:\n\nBuild Successful \n\nhttp://jenkins.devops.pl:8080/job/MavenDemo/25/ : SUCCESS',10,1,10,'baf0414d_e092c29e'),(2,'2016-11-13 10:36:50','Patch Set 1:\n\nBuild Failed \n\nhttp://jenkins.devops.pl:8080/job/MavenDemo/21/ : FAILURE',10,1,10,'baf0414d_e0abe2d4'),(2,'2016-11-13 10:48:01','Patch Set 1: Verified+1\n\nBuild Successful \n\nhttp://jenkins.devops.pl:8080/job/MavenDemo/26/ : SUCCESS',11,1,11,'baf0414d_80e9b61c'),(2,'2016-11-13 10:47:50','Patch Set 1:\n\nBuild Started http://jenkins.devops.pl:8080/job/MavenDemo/26/',11,1,11,'baf0414d_a08cba80'),(1,'2016-11-13 10:47:45','Uploaded patch set 1.',11,1,11,'baf0414d_c08fbe74'),(2,'2016-11-13 11:42:41','Patch Set 1: -Verified\n\nBuild Started http://jenkins.devops.pl:8080/job/MavenDemo/28/',12,1,12,'baf0414d_00dda670'),(2,'2016-11-13 11:40:53','Patch Set 1: Verified+1\n\nBuild Successful \n\nhttp://jenkins.devops.pl:8080/job/MavenDemo/27/ : SUCCESS',12,1,12,'baf0414d_20f8aae4'),(2,'2016-11-13 11:40:42','Patch Set 1:\n\nBuild Started http://jenkins.devops.pl:8080/job/MavenDemo/27/',12,1,12,'baf0414d_40f3ae0a'),(1,'2016-11-13 11:40:34','Uploaded patch set 1.',12,1,12,'baf0414d_60eeb224'),(2,'2016-11-13 13:07:28','Patch Set 1: Verified+1\n\nBuild Successful \n\nhttp://jenkins.devops.pl:8080/job/MavenDemo/29/ : SUCCESS',12,1,12,'baf0414d_c06b3e84'),(2,'2016-11-13 13:07:17','Patch Set 1: -Verified\n\nBuild Started http://jenkins.devops.pl:8080/job/MavenDemo/29/',12,1,12,'baf0414d_e06e4296'),(2,'2016-11-13 11:42:52','Patch Set 1: Verified+1\n\nBuild Successful \n\nhttp://jenkins.devops.pl:8080/job/MavenDemo/28/ : SUCCESS',12,1,12,'baf0414d_e0d9a284'),(1,'2016-11-13 11:54:59','Uploaded patch set 1.',13,1,13,'baf0414d_c0e69e44'),(1,'2016-11-13 12:07:33','Patch Set 1: Code-Review+2 Verified+1',14,1,14,'baf0414d_80d09654'),(1,'2016-11-13 12:06:38','Uploaded patch set 1.',14,1,14,'baf0414d_a0e39a32'),(1,'2016-11-13 12:07:42','Uploaded patch set 1.',15,1,15,'baf0414d_60d59242'),(2,'2016-11-13 12:56:38','Patch Set 1: Verified+1\n\nBuild Successful \n\nhttp://jenkins.devops.pl:8080/job/NewTest/5/ : SUCCESS',16,1,16,'baf0414d_004b662c'),(2,'2016-11-13 12:08:43','Patch Set 1: Verified-1\n\nBuild Failed \n\nhttp://jenkins.devops.pl:8080/job/NewTest/1/ : FAILURE',16,1,16,'baf0414d_00c48690'),(2,'2016-11-13 12:56:32','Patch Set 1: -Verified\n\nBuild Started http://jenkins.devops.pl:8080/job/NewTest/5/',16,1,16,'baf0414d_20466a24'),(2,'2016-11-13 12:08:43','Patch Set 1:\n\nBuild Started http://jenkins.devops.pl:8080/job/NewTest/1/',16,1,16,'baf0414d_20cf8ab2'),(2,'2016-11-13 12:30:58','Patch Set 1: Verified+1\n\nBuild Successful \n\nhttp://jenkins.devops.pl:8080/job/NewTest/4/ : SUCCESS',16,1,16,'baf0414d_40416e0a'),(1,'2016-11-13 12:08:36','Uploaded patch set 1.',16,1,16,'baf0414d_40ca8ea2'),(2,'2016-11-13 12:30:52','Patch Set 1: -Verified\n\nBuild Started http://jenkins.devops.pl:8080/job/NewTest/4/',16,1,16,'baf0414d_603c7294'),(2,'2016-11-13 12:30:07','Patch Set 1: Verified+1\n\nBuild Successful \n\nhttp://jenkins.devops.pl:8080/job/NewTest/3/ : SUCCESS',16,1,16,'baf0414d_803776b0'),(2,'2016-11-13 12:30:01','Patch Set 1: -Verified\n\nBuild Started http://jenkins.devops.pl:8080/job/NewTest/3/',16,1,16,'baf0414d_a0ba7a08'),(2,'2016-11-13 12:57:54','Patch Set 1: Verified+1\n\nBuild Successful \n\nhttp://jenkins.devops.pl:8080/job/NewTest/6/ : SUCCESS',16,1,16,'baf0414d_c0545ecc'),(2,'2016-11-13 12:24:24','Patch Set 1: Verified+1\n\nBuild Successful \n\nhttp://jenkins.devops.pl:8080/job/NewTest/2/ : SUCCESS',16,1,16,'baf0414d_c0bd7e04'),(2,'2016-11-13 12:57:48','Patch Set 1: -Verified\n\nBuild Started http://jenkins.devops.pl:8080/job/NewTest/6/',16,1,16,'baf0414d_e047621c'),(2,'2016-11-13 12:24:18','Patch Set 1: -Verified\n\nBuild Started http://jenkins.devops.pl:8080/job/NewTest/2/',16,1,16,'baf0414d_e0c0827e'),(2,'2016-11-13 13:02:09','Patch Set 1: Verified+1\n\nBuild Successful \n\nhttp://jenkins.devops.pl:8080/job/NewTest/7/ : SUCCESS',17,1,17,'baf0414d_606352b2'),(2,'2016-11-13 13:02:04','Patch Set 1:\n\nBuild Started http://jenkins.devops.pl:8080/job/NewTest/7/',17,1,17,'baf0414d_805e56e8'),(1,'2016-11-13 13:01:56','Uploaded patch set 1.',17,1,17,'baf0414d_a0515ada'),(2,'2016-11-13 13:03:30','Patch Set 1: Verified+1\n\nBuild Successful \n\nhttp://jenkins.devops.pl:8080/job/NewTest/8/ : SUCCESS',18,1,18,'baf0414d_0072467c'),(2,'2016-11-13 13:03:24','Patch Set 1:\n\nBuild Started http://jenkins.devops.pl:8080/job/NewTest/8/',18,1,18,'baf0414d_205d4aea'),(1,'2016-11-13 13:03:16','Uploaded patch set 1.',18,1,18,'baf0414d_40584efa'),(NULL,'2016-11-13 13:44:18','Change has been successfully merged into the git repository by Damian Tykalowski',19,1,19,'baf0414d_20142af4'),(1,'2016-11-13 13:44:17','Patch Set 1: Code-Review+2',19,1,19,'baf0414d_400f2ee2'),(2,'2016-11-13 13:43:15','Patch Set 1: Verified+1\n\nBuild Successful \n\nhttp://jenkins.devops.pl:8080/job/MavenProject/1/ : SUCCESS',19,1,19,'baf0414d_600a32d4'),(2,'2016-11-13 13:43:10','Patch Set 1:\n\nBuild Started http://jenkins.devops.pl:8080/job/MavenProject/1/',19,1,19,'baf0414d_800536c4'),(1,'2016-11-13 13:43:04','Uploaded patch set 1.',19,1,19,'baf0414d_a0683a88'),(1,'2016-11-14 19:26:52','Patch Set 1: Code-Review+2',20,1,20,'9af53d3f_1f0e2335'),(2,'2016-11-14 19:26:07','Patch Set 1: Verified+1\n\nBuild Successful \n\nhttp://jenkins.devops.pl:8080/job/MavenProject/2/ : SUCCESS',20,1,20,'9af53d3f_3f09e72c'),(2,'2016-11-14 19:25:56','Patch Set 1:\n\nBuild Started http://jenkins.devops.pl:8080/job/MavenProject/2/',20,1,20,'9af53d3f_5f04ab14'),(1,'2016-11-14 19:25:50','Uploaded patch set 1.',20,1,20,'9af53d3f_7fff6f02'),(NULL,'2016-11-14 19:26:53','Change has been successfully merged into the git repository by Damian Tykalowski',20,1,20,'9af53d3f_ff125f57'),(2,'2016-11-14 19:30:27','Patch Set 1: Verified-1\n\nBuild Failed \n\nhttp://jenkins.devops.pl:8080/job/MavenProject/3/ : FAILURE',21,1,21,'9af53d3f_9f19137c'),(2,'2016-11-14 19:30:26','Patch Set 1:\n\nBuild Started http://jenkins.devops.pl:8080/job/MavenProject/3/',21,1,21,'9af53d3f_bf1cd76b'),(1,'2016-11-14 19:30:17','Uploaded patch set 1.',21,1,21,'9af53d3f_df0f9b2d'),(2,'2016-11-14 19:31:37','Patch Set 1: Verified-1\n\nBuild Failed \n\nhttp://jenkins.devops.pl:8080/job/MavenProject/4/ : FAILURE',22,1,22,'9af53d3f_3f20c79a'),(2,'2016-11-14 19:31:36','Patch Set 1:\n\nBuild Started http://jenkins.devops.pl:8080/job/MavenProject/4/',22,1,22,'9af53d3f_5f2b8b82'),(1,'2016-11-14 19:31:27','Uploaded patch set 1.',22,1,22,'9af53d3f_7f264fbc'),(1,'2016-11-14 19:35:14','Uploaded patch set 1.',23,1,23,'9af53d3f_1f2503ab'),(2,'2016-11-14 19:35:28','Patch Set 1: Verified+1\n\nBuild Successful \n\nhttp://jenkins.devops.pl:8080/job/MavenProject/5/ : SUCCESS',23,1,23,'9af53d3f_df367be7'),(2,'2016-11-14 19:35:22','Patch Set 1:\n\nBuild Started http://jenkins.devops.pl:8080/job/MavenProject/5/',23,1,23,'9af53d3f_ff393fd9'),(2,'2016-11-14 20:08:31','Patch Set 1: Verified+1\n\nBuild Successful \n\nhttp://jenkins.devops.pl:8080/job/MavenProject/6/ : SUCCESS',24,1,24,'9af53d3f_7f4d2f72'),(2,'2016-11-14 20:08:23','Patch Set 1:\n\nBuild Started http://jenkins.devops.pl:8080/job/MavenProject/6/',24,1,24,'9af53d3f_9f30f3e9'),(1,'2016-11-14 20:08:16','Uploaded patch set 1.',24,1,24,'9af53d3f_bf33b7f5'),(2,'2016-11-14 20:12:39','Patch Set 1: Verified+1\n\nBuild Successful \n\nhttp://jenkins.devops.pl:8080/job/MavenProject/7/ : SUCCESS',25,1,25,'9af53d3f_1f5ce324'),(2,'2016-11-14 20:12:32','Patch Set 1:\n\nBuild Started http://jenkins.devops.pl:8080/job/MavenProject/7/',25,1,25,'9af53d3f_3f57a704'),(1,'2016-11-14 20:12:24','Uploaded patch set 1.',25,1,25,'9af53d3f_5f526b14'),(2,'2016-11-14 20:18:23','Patch Set 1: Verified-1\n\nBuild Failed \n\nhttp://jenkins.devops.pl:8080/job/MavenProject/8/ : FAILURE',26,1,26,'9af53d3f_bf4a9753'),(2,'2016-11-14 20:18:23','Patch Set 1:\n\nBuild Started http://jenkins.devops.pl:8080/job/MavenProject/8/',26,1,26,'9af53d3f_df3d5bbd'),(1,'2016-11-14 20:18:16','Uploaded patch set 1.',26,1,26,'9af53d3f_ff401f37'),(2,'2016-11-14 20:22:48','Patch Set 1: Verified+1\n\nBuild Successful \n\nhttp://jenkins.devops.pl:8080/job/MavenProject/10/ : SUCCESS',27,1,27,'9af53d3f_1f73c3b2'),(2,'2016-11-14 20:22:36','Patch Set 1: -Verified\n\nBuild Started http://jenkins.devops.pl:8080/job/MavenProject/10/',27,1,27,'9af53d3f_3f6e87ca'),(2,'2016-11-14 20:21:45','Patch Set 1: Verified+1\n\nBuild Successful \n\nhttp://jenkins.devops.pl:8080/job/MavenProject/9/ : SUCCESS',27,1,27,'9af53d3f_5f794b92'),(2,'2016-11-14 20:21:38','Patch Set 1:\n\nBuild Started http://jenkins.devops.pl:8080/job/MavenProject/9/',27,1,27,'9af53d3f_7f740f9c'),(1,'2016-11-14 20:21:29','Uploaded patch set 1.',27,1,27,'9af53d3f_9f47d34b'),(2,'2016-12-10 09:52:15','Patch Set 1: Verified+1\n\nBuild Successful \n\nhttp://jenkins.devops.pl:8080/job/MavenProject/11/ : SUCCESS',28,1,28,'7afa4931_3e09e92c'),(2,'2016-12-10 09:52:00','Patch Set 1:\n\nBuild Started http://jenkins.devops.pl:8080/job/MavenProject/11/',28,1,28,'7afa4931_5e04b514'),(1,'2016-12-10 09:51:50','Uploaded patch set 1.',28,1,28,'7afa4931_7eff7102'),(1,'2016-12-10 10:26:57','Uploaded patch set 1.',29,1,29,'7afa4931_1e0e2d35'),(2,'2016-12-10 10:31:26','Patch Set 1: Verified+1\n\nBuild Successful \n\nhttp://jenkins.devops.pl:8080/job/MavenProject/13/ : SUCCESS',29,1,29,'7afa4931_9e191d7c'),(2,'2016-12-10 10:31:10','Patch Set 1: -Verified\n\nBuild Started http://jenkins.devops.pl:8080/job/MavenProject/13/',29,1,29,'7afa4931_be1cd96b'),(2,'2016-12-10 10:27:11','Patch Set 1: Verified-1\n\nBuild Failed \n\nhttp://jenkins.devops.pl:8080/job/MavenProject/12/ : FAILURE',29,1,29,'7afa4931_de0fa52d'),(2,'2016-12-10 10:27:05','Patch Set 1:\n\nBuild Started http://jenkins.devops.pl:8080/job/MavenProject/12/',29,1,29,'7afa4931_fe126157');
/*!40000 ALTER TABLE `change_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `changes`
--

DROP TABLE IF EXISTS `changes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `changes` (
  `change_key` varchar(60) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  `created_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_updated_on` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `owner_account_id` int(11) NOT NULL DEFAULT '0',
  `dest_project_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  `dest_branch_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  `status` char(1) NOT NULL DEFAULT '',
  `current_patch_set_id` int(11) NOT NULL DEFAULT '0',
  `subject` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  `topic` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `original_subject` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `row_version` int(11) NOT NULL DEFAULT '0',
  `change_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`change_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `changes`
--

LOCK TABLES `changes` WRITE;
/*!40000 ALTER TABLE `changes` DISABLE KEYS */;
INSERT INTO `changes` VALUES ('Id62d0fb646c644c6a06988798c243117430f40e2','2016-11-10 17:19:38','2016-11-10 17:35:43',1,'MavenDemo','refs/heads/master','M',1,'Hello World',NULL,'Hello World',12,1),('Iacdf97ffd5c99e7621adb065dc88ea8d13fec431','2016-11-10 18:29:32','2016-11-10 18:33:12',1,'MavenDemo','refs/heads/master','M',1,'pom update',NULL,'pom update',10,2),('Ica5b6a6996b4bbd104f0be66d2502ce529aac94f','2016-11-10 18:34:34','2016-11-10 18:35:19',1,'MavenDemo','refs/heads/master','M',1,'second change',NULL,'second change',6,3),('Ie0a9277472242288513f4160ea9f4bcfcf6eb6a9','2016-11-13 09:32:03','2016-11-13 09:47:11',1,'MavenDemo','refs/heads/master','M',1,'test',NULL,'test',4,4),('Ia57e73f1d72c31d8875a19fb27e3e82e2a80697e','2016-11-13 09:49:25','2016-11-13 10:30:48',1,'MavenDemo','refs/heads/master','A',1,'test3',NULL,'test3',16,5),('Ib402805aa699145baaba1a1cc5d0a7fc441bbda6','2016-11-13 10:12:04','2016-11-13 10:30:17',1,'MavenDemo','refs/heads/testing','A',1,' b test',NULL,' b test',2,6),('I356a2f61f4be90e6dbc1adf932b716fd95935b13','2016-11-13 10:13:15','2016-11-13 10:30:31',1,'MavenDemo','refs/heads/testing','A',1,' b test2',NULL,' b test2',2,7),('I9ab51eab40fb488e82a0d6836fca10633ab4b87e','2016-11-13 10:15:59','2016-11-13 10:30:34',1,'MavenDemo','refs/heads/testing','A',1,'test test4',NULL,'test test4',2,8),('I3ab32bb885bb2f7a7e4426ebe45b60be4f005088','2016-11-13 10:17:06','2016-11-13 10:30:38',1,'MavenDemo','refs/heads/testing','A',1,'test test5',NULL,'test test5',2,9),('I82642f29a9412887c61cb890b20117ea1b5dc497','2016-11-13 10:17:44','2016-11-13 10:45:07',1,'MavenDemo','refs/heads/testing','A',1,'test test6',NULL,'test test6',18,10),('I46d8104bf5ef2190253c7dd159aa8c3a7b296c6e','2016-11-13 10:47:45','2016-11-13 10:48:01',1,'MavenDemo','refs/heads/testing','n',1,'test',NULL,'test',3,11),('I605d61f6d974ecbd7dfbed30a70613d4d977ee8f','2016-11-13 11:40:34','2016-11-13 13:07:28',1,'MavenDemo','refs/heads/testing','n',1,'test',NULL,'test',7,12),('I42281bfa24cbb74b3af12267c847ce4894bb890d','2016-11-13 11:54:59','2016-11-13 11:54:59',1,'TestTwo','refs/meta/config','d',1,'Edit Project Config',NULL,'Edit Project Config',1,13),('I03012e75d2feb64f0e11be5b13e82ae58cd8188f','2016-11-13 12:06:38','2016-11-13 12:07:33',1,'NewTest','refs/heads/master','n',1,'test',NULL,'test',2,14),('Ib4a616f635e109debf7ab83079c519fd30bfcb07','2016-11-13 12:07:42','2016-11-13 12:07:42',1,'NewTest','refs/heads/master','n',1,'test',NULL,'test',1,15),('Id40e8ea0cb2b16ae940c94f3420f1b6701b0fb60','2016-11-13 12:08:36','2016-11-13 12:57:54',1,'NewTest','refs/heads/master','n',1,'test',NULL,'test',13,16),('Ibfa3f049bb2355bc903bbac7e8c31c67f7204bec','2016-11-13 13:01:56','2016-11-13 13:02:09',1,'NewTest','refs/heads/master','n',1,'test',NULL,'test',3,17),('I4b1116e4ce3dba0453c38641bb31460969174a6f','2016-11-13 13:03:16','2016-11-13 13:03:30',1,'NewTest','refs/heads/master','n',1,'test',NULL,'test',3,18),('I5fc02fcf778cbede689815ab401f7409af962951','2016-11-13 13:43:04','2016-11-13 13:44:18',1,'MavenProject','refs/heads/master','M',1,'initial POM',NULL,'initial POM',6,19),('I471e5cdd1a9272f44eaeae79ee8244d6be24fd25','2016-11-14 19:25:50','2016-11-14 19:26:53',1,'MavenProject','refs/heads/master','M',1,'added distribution to nexus',NULL,'added distribution to nexus',6,20),('I539b19eaaa608308032a6a886ab1d674400d5b90','2016-11-14 19:30:17','2016-11-14 19:30:27',1,'MavenProject','refs/heads/master','n',1,'added plugins nexus',NULL,'added plugins nexus',3,21),('Ie1482088eebffba6f75c2f46b3b0a7d9fcba52c1','2016-11-14 19:31:27','2016-11-14 19:31:37',1,'MavenProject','refs/heads/master','n',1,'added plugins nexus',NULL,'added plugins nexus',3,22),('I491a7da9cd2baef0b037bccc25965bf16bb656dd','2016-11-14 19:35:14','2016-11-14 19:35:28',1,'MavenProject','refs/heads/master','n',1,'added plugins nexus',NULL,'added plugins nexus',3,23),('Ib3b0a4e986d3578fcb1fe3e3c67d5a38f88239bf','2016-11-14 20:08:16','2016-11-14 20:08:31',1,'MavenProject','refs/heads/master','n',1,'added plugins nexus',NULL,'added plugins nexus',3,24),('I5843d8647f57995d0c029dae667b5c2983f96092','2016-11-14 20:12:24','2016-11-14 20:12:39',1,'MavenProject','refs/heads/master','n',1,'added plugins nexus',NULL,'added plugins nexus',3,25),('I62011f3656589d1c545d25fc75be9b53d468d397','2016-11-14 20:18:16','2016-11-14 20:18:23',1,'MavenProject','refs/heads/master','n',1,'added plugins nexus',NULL,'added plugins nexus',3,26),('I669e98df38bbbbb699742b0439e70c770708dc81','2016-11-14 20:21:29','2016-11-14 20:22:48',1,'MavenProject','refs/heads/master','n',1,'added plugins nexus',NULL,'added plugins nexus',5,27),('Ieb0bb9d608bad0d167c4ecb377da2920f9cab550','2016-12-10 09:51:50','2016-12-10 09:52:15',1,'MavenProject','refs/heads/master','n',1,'testing testing',NULL,'testing testing',3,28),('Ia3a885a4f91fe8a6af2aee161d45f90888310bc4','2016-12-10 10:26:57','2016-12-10 10:31:26',1,'MavenProject','refs/heads/master','n',1,'updated pom',NULL,'updated pom',5,29);
/*!40000 ALTER TABLE `changes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patch_comments`
--

DROP TABLE IF EXISTS `patch_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `patch_comments` (
  `line_nbr` int(11) NOT NULL DEFAULT '0',
  `author_id` int(11) NOT NULL DEFAULT '0',
  `written_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `status` char(1) NOT NULL DEFAULT '',
  `side` smallint(6) NOT NULL DEFAULT '0',
  `message` text,
  `parent_uuid` varchar(40) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `range_start_line` int(11) DEFAULT NULL,
  `range_start_character` int(11) DEFAULT NULL,
  `range_end_line` int(11) DEFAULT NULL,
  `range_end_character` int(11) DEFAULT NULL,
  `change_id` int(11) NOT NULL DEFAULT '0',
  `patch_set_id` int(11) NOT NULL DEFAULT '0',
  `file_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  `uuid` varchar(40) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`change_id`,`patch_set_id`,`file_name`,`uuid`),
  KEY `patch_comment_drafts` (`status`,`author_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patch_comments`
--

LOCK TABLES `patch_comments` WRITE;
/*!40000 ALTER TABLE `patch_comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `patch_comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patch_set_ancestors`
--

DROP TABLE IF EXISTS `patch_set_ancestors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `patch_set_ancestors` (
  `ancestor_revision` varchar(40) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  `change_id` int(11) NOT NULL DEFAULT '0',
  `patch_set_id` int(11) NOT NULL DEFAULT '0',
  `position` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`change_id`,`patch_set_id`,`position`),
  KEY `patch_set_ancestors_desc` (`ancestor_revision`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patch_set_ancestors`
--

LOCK TABLES `patch_set_ancestors` WRITE;
/*!40000 ALTER TABLE `patch_set_ancestors` DISABLE KEYS */;
INSERT INTO `patch_set_ancestors` VALUES ('054643acb8862e7a3bf3ad41b4cc23ab209ed15e',7,1,1),('075925001dc213ad37c696676fd5270063d4e7cd',1,1,1),('1ac17ba505e3508dd391ff936ed92124b5e3a73a',23,1,1),('1fd59bb0cfb5a5454ac4324e9e97b55f5fae09cf',8,1,1),('31da23a300b4218ce55c056955b5f754881b3276',13,1,1),('31f3265c54ca8359d755f1f635316d78a1f8758a',3,1,1),('334fc666045796310f2b4cabc443032a4259bd46',4,1,1),('349f8b462b2ec50f675239b062f1c9c2ca1d17e8',25,1,1),('360c36a91bb6ee2b7bd319a2bb0ead83f1911a83',17,1,1),('4ca54e21d476a644eeec0e3065adade89c960ae8',21,1,1),('5fa110e0da6204d5a9dab8573e074b34c376f743',29,1,1),('68cd506fbe5513d602e84c3af6b7adb46a7a2280',5,1,1),('732b5583155258ab32de2d6a3c201746a9e0b1e2',11,1,1),('7cf22fba0fc8bff6099747249865111e5afa71e4',16,1,1),('8a71f46cf7aceceef65e4f7844d5f2396d424e02',10,1,1),('a2406478d9edd13ed75b75eef10eb37d9d79d701',12,1,1),('b55fad9981943c8c36298e034619efc016e64f23',18,1,1),('b5c502eb47c9928d77beb2a33f56d07b2da3e5a1',9,1,1),('b641098fe5b6819256e87c2b8c6ed1c8c0d1ae21',14,1,1),('bf340adfbea53725e818db47e8202bbf94503a8e',27,1,1),('c0727521f9e97c0e839d2638a4823cd1081845d1',2,1,1),('c966811e3ef8239029ffa3b32facc2d38327b0f8',6,1,1),('cb64b7a41ad812b6e485d3afa0ba0ebdedbc8817',26,1,1),('cc4332d3c0a1ede397e29edc2034d670b2c6fc58',20,1,1),('df365e396bf946f10aae450ab36365a0073b221d',22,1,1),('e6112536ee127e0ce6d016d7935e84d2ad230621',24,1,1),('e91c271b229048e773b31da84a0e488cf706f516',28,1,1),('ff1d760ccda6a8b56b4f86fef45e2504286f96b8',15,1,1);
/*!40000 ALTER TABLE `patch_set_ancestors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patch_set_approvals`
--

DROP TABLE IF EXISTS `patch_set_approvals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `patch_set_approvals` (
  `value` smallint(6) NOT NULL DEFAULT '0',
  `granted` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `change_id` int(11) NOT NULL DEFAULT '0',
  `patch_set_id` int(11) NOT NULL DEFAULT '0',
  `account_id` int(11) NOT NULL DEFAULT '0',
  `category_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`change_id`,`patch_set_id`,`account_id`,`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patch_set_approvals`
--

LOCK TABLES `patch_set_approvals` WRITE;
/*!40000 ALTER TABLE `patch_set_approvals` DISABLE KEYS */;
INSERT INTO `patch_set_approvals` VALUES (2,'2016-11-10 17:30:34',1,1,1,'Code-Review'),(1,'2016-11-10 17:34:44',1,1,1,'SUBM'),(1,'2016-11-10 17:33:24',1,1,1,'Verified'),(0,'2016-11-10 17:35:20',1,1,2,'Code-Review'),(2,'2016-11-10 18:29:48',2,1,1,'Code-Review'),(1,'2016-11-10 18:29:59',2,1,1,'SUBM'),(1,'2016-11-10 18:29:48',2,1,1,'Verified'),(0,'2016-11-10 18:30:08',2,1,2,'Code-Review'),(2,'2016-11-10 18:34:58',3,1,1,'Code-Review'),(1,'2016-11-10 18:34:59',3,1,1,'SUBM'),(1,'2016-11-10 18:34:58',3,1,1,'Verified'),(0,'2016-11-10 18:35:08',3,1,2,'Code-Review'),(-1,'2016-11-13 09:32:27',4,1,2,'Verified'),(-1,'2016-11-13 10:14:32',5,1,2,'Verified'),(-1,'2016-11-13 10:26:48',10,1,2,'Verified'),(1,'2016-11-13 10:48:01',11,1,2,'Verified'),(1,'2016-11-13 13:07:28',12,1,2,'Verified'),(2,'2016-11-13 12:07:33',14,1,1,'Code-Review'),(1,'2016-11-13 12:07:33',14,1,1,'Verified'),(1,'2016-11-13 12:57:54',16,1,2,'Verified'),(1,'2016-11-13 13:02:09',17,1,2,'Verified'),(1,'2016-11-13 13:03:30',18,1,2,'Verified'),(2,'2016-11-13 13:44:17',19,1,1,'Code-Review'),(1,'2016-11-13 13:44:18',19,1,1,'SUBM'),(1,'2016-11-13 13:43:15',19,1,2,'Verified'),(2,'2016-11-14 19:26:52',20,1,1,'Code-Review'),(1,'2016-11-14 19:26:53',20,1,1,'SUBM'),(1,'2016-11-14 19:26:07',20,1,2,'Verified'),(-1,'2016-11-14 19:30:27',21,1,2,'Verified'),(-1,'2016-11-14 19:31:37',22,1,2,'Verified'),(1,'2016-11-14 19:35:28',23,1,2,'Verified'),(1,'2016-11-14 20:08:31',24,1,2,'Verified'),(1,'2016-11-14 20:12:39',25,1,2,'Verified'),(-1,'2016-11-14 20:18:23',26,1,2,'Verified'),(1,'2016-11-14 20:22:48',27,1,2,'Verified'),(1,'2016-12-10 09:52:15',28,1,2,'Verified'),(1,'2016-12-10 10:31:26',29,1,2,'Verified');
/*!40000 ALTER TABLE `patch_set_approvals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patch_sets`
--

DROP TABLE IF EXISTS `patch_sets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `patch_sets` (
  `revision` varchar(40) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `uploader_account_id` int(11) NOT NULL DEFAULT '0',
  `created_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `draft` char(1) NOT NULL DEFAULT 'N',
  `change_id` int(11) NOT NULL DEFAULT '0',
  `patch_set_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`change_id`,`patch_set_id`),
  KEY `patch_sets_byRevision` (`revision`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patch_sets`
--

LOCK TABLES `patch_sets` WRITE;
/*!40000 ALTER TABLE `patch_sets` DISABLE KEYS */;
INSERT INTO `patch_sets` VALUES ('c0727521f9e97c0e839d2638a4823cd1081845d1',1,'2016-11-10 17:19:38','N',1,1),('31f3265c54ca8359d755f1f635316d78a1f8758a',1,'2016-11-10 18:29:32','N',2,1),('334fc666045796310f2b4cabc443032a4259bd46',1,'2016-11-10 18:34:34','N',3,1),('da5f096acf4f9ad1d1eb79207564c32ee91464a0',1,'2016-11-13 09:32:03','N',4,1),('c966811e3ef8239029ffa3b32facc2d38327b0f8',1,'2016-11-13 09:49:25','N',5,1),('054643acb8862e7a3bf3ad41b4cc23ab209ed15e',1,'2016-11-13 10:12:04','N',6,1),('1fd59bb0cfb5a5454ac4324e9e97b55f5fae09cf',1,'2016-11-13 10:13:15','N',7,1),('b5c502eb47c9928d77beb2a33f56d07b2da3e5a1',1,'2016-11-13 10:15:59','N',8,1),('8a71f46cf7aceceef65e4f7844d5f2396d424e02',1,'2016-11-13 10:17:06','N',9,1),('732b5583155258ab32de2d6a3c201746a9e0b1e2',1,'2016-11-13 10:17:44','N',10,1),('a2406478d9edd13ed75b75eef10eb37d9d79d701',1,'2016-11-13 10:47:45','N',11,1),('463b541f23ef4b163b7ae9c71746d5c01f5a2432',1,'2016-11-13 11:40:34','N',12,1),('48165ce8cdc7b9e14773e1f92ee50afb517af31f',1,'2016-11-13 11:54:59','Y',13,1),('ff1d760ccda6a8b56b4f86fef45e2504286f96b8',1,'2016-11-13 12:06:38','N',14,1),('7cf22fba0fc8bff6099747249865111e5afa71e4',1,'2016-11-13 12:07:42','N',15,1),('360c36a91bb6ee2b7bd319a2bb0ead83f1911a83',1,'2016-11-13 12:08:36','N',16,1),('b55fad9981943c8c36298e034619efc016e64f23',1,'2016-11-13 13:01:56','N',17,1),('cc3b5d06ed0ce2d713290596b5add898219d2ead',1,'2016-11-13 13:03:16','N',18,1),('cc4332d3c0a1ede397e29edc2034d670b2c6fc58',1,'2016-11-13 13:43:04','N',19,1),('4ca54e21d476a644eeec0e3065adade89c960ae8',1,'2016-11-14 19:25:50','N',20,1),('df365e396bf946f10aae450ab36365a0073b221d',1,'2016-11-14 19:30:17','N',21,1),('1ac17ba505e3508dd391ff936ed92124b5e3a73a',1,'2016-11-14 19:31:27','N',22,1),('e6112536ee127e0ce6d016d7935e84d2ad230621',1,'2016-11-14 19:35:14','N',23,1),('349f8b462b2ec50f675239b062f1c9c2ca1d17e8',1,'2016-11-14 20:08:16','N',24,1),('cb64b7a41ad812b6e485d3afa0ba0ebdedbc8817',1,'2016-11-14 20:12:24','N',25,1),('bf340adfbea53725e818db47e8202bbf94503a8e',1,'2016-11-14 20:18:16','N',26,1),('e91c271b229048e773b31da84a0e488cf706f516',1,'2016-11-14 20:21:29','N',27,1),('5fa110e0da6204d5a9dab8573e074b34c376f743',1,'2016-12-10 09:51:50','N',28,1),('02adf049373549887e4ca969ef25317795ba8f66',1,'2016-12-10 10:26:57','N',29,1);
/*!40000 ALTER TABLE `patch_sets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_version`
--

DROP TABLE IF EXISTS `schema_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_version` (
  `version_nbr` int(11) NOT NULL DEFAULT '0',
  `singleton` varchar(1) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`singleton`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schema_version`
--

LOCK TABLES `schema_version` WRITE;
/*!40000 ALTER TABLE `schema_version` DISABLE KEYS */;
INSERT INTO `schema_version` VALUES (107,'X');
/*!40000 ALTER TABLE `schema_version` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `starred_changes`
--

DROP TABLE IF EXISTS `starred_changes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `starred_changes` (
  `account_id` int(11) NOT NULL DEFAULT '0',
  `change_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`account_id`,`change_id`),
  KEY `starred_changes_byChange` (`change_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `starred_changes`
--

LOCK TABLES `starred_changes` WRITE;
/*!40000 ALTER TABLE `starred_changes` DISABLE KEYS */;
/*!40000 ALTER TABLE `starred_changes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `submodule_subscriptions`
--

DROP TABLE IF EXISTS `submodule_subscriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `submodule_subscriptions` (
  `submodule_project_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  `submodule_branch_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  `super_project_project_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  `super_project_branch_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  `submodule_path` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`super_project_project_name`,`super_project_branch_name`,`submodule_path`),
  KEY `submodule_subscr_acc_byS` (`submodule_project_name`,`submodule_branch_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `submodule_subscriptions`
--

LOCK TABLES `submodule_subscriptions` WRITE;
/*!40000 ALTER TABLE `submodule_subscriptions` DISABLE KEYS */;
/*!40000 ALTER TABLE `submodule_subscriptions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `system_config`
--

DROP TABLE IF EXISTS `system_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `system_config` (
  `register_email_private_key` varchar(36) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `site_path` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `admin_group_id` int(11) DEFAULT NULL,
  `anonymous_group_id` int(11) DEFAULT NULL,
  `registered_group_id` int(11) DEFAULT NULL,
  `wild_project_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `batch_users_group_id` int(11) DEFAULT NULL,
  `owner_group_id` int(11) DEFAULT NULL,
  `admin_group_uuid` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `batch_users_group_uuid` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `singleton` varchar(1) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`singleton`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `system_config`
--

LOCK TABLES `system_config` WRITE;
/*!40000 ALTER TABLE `system_config` DISABLE KEYS */;
INSERT INTO `system_config` VALUES (NULL,'/var/gerrit',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'X');
/*!40000 ALTER TABLE `system_config` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-12-10 16:31:17

-- MySQL dump 10.17  Distrib 10.3.16-MariaDB, for Win64 (AMD64)
--
-- Host: 192.168.99.100    Database: apijson_todo_demo
-- ------------------------------------------------------
-- Server version	10.5.9-MariaDB-1:10.5.9+maria~focal

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Access`
--

DROP TABLE IF EXISTS `Access`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Access` (
  `id` bigint(15) NOT NULL AUTO_INCREMENT,
  `debug` tinyint(2) NOT NULL DEFAULT 0 COMMENT '是否为调试表，只允许在开发环境使用，测试和线上环境禁用',
  `name` varchar(50) NOT NULL COMMENT '实际表名，例如 apijson_user',
  `alias` varchar(20) DEFAULT NULL COMMENT '外部调用的表别名，例如 User',
  `get` varchar(100) NOT NULL DEFAULT '["UNKNOWN", "LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]' COMMENT '允许 get 的角色列表，例如 ["LOGIN", "CONTACT", "CIRCLE", "OWNER"]\n用 JSON 类型不能设置默认值，反正权限对应的需求是明确的，也不需要自动转 JSONArray。\nTODO: 直接 LOGIN,CONTACT,CIRCLE,OWNER 更简单，反正是开发内部用，不需要复杂查询。',
  `head` varchar(100) NOT NULL DEFAULT '["UNKNOWN", "LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]' COMMENT '允许 head 的角色列表，例如 ["LOGIN", "CONTACT", "CIRCLE", "OWNER"]',
  `gets` varchar(100) NOT NULL DEFAULT '["LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]' COMMENT '允许 gets 的角色列表，例如 ["LOGIN", "CONTACT", "CIRCLE", "OWNER"]',
  `heads` varchar(100) NOT NULL DEFAULT '["LOGIN", "CONTACT", "CIRCLE", "OWNER", "ADMIN"]' COMMENT '允许 heads 的角色列表，例如 ["LOGIN", "CONTACT", "CIRCLE", "OWNER"]',
  `post` varchar(100) NOT NULL DEFAULT '["OWNER", "ADMIN"]' COMMENT '允许 post 的角色列表，例如 ["LOGIN", "CONTACT", "CIRCLE", "OWNER"]',
  `put` varchar(100) NOT NULL DEFAULT '["OWNER", "ADMIN"]' COMMENT '允许 put 的角色列表，例如 ["LOGIN", "CONTACT", "CIRCLE", "OWNER"]',
  `delete` varchar(100) NOT NULL DEFAULT '["OWNER", "ADMIN"]' COMMENT '允许 delete 的角色列表，例如 ["LOGIN", "CONTACT", "CIRCLE", "OWNER"]',
  `date` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '创建时间',
  `detail` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`),
  UNIQUE KEY `alias_UNIQUE` (`alias`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COMMENT='权限配置(必须)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Access`
--

LOCK TABLES `Access` WRITE;
/*!40000 ALTER TABLE `Access` DISABLE KEYS */;
INSERT INTO `Access` VALUES (2,0,'User',NULL,'[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"UNKNOWN\",\"LOGIN\",\"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','2021-07-28 14:02:41','用户公开信息表'),(3,0,'Credential',NULL,'[]','[]','[\"UNKNOWN\",\"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','[\"UNKNOWN\",\"LOGIN\",\"OWNER\", \"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','[\"ADMIN\"]','2021-07-28 14:04:01','用户隐私表'),(4,0,'Todo',NULL,'[\"LOGIN\",\"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\",\"OWNER\", \"ADMIN\"]','[\"LOGIN\",\"CIRCLE\",\"OWNER\",\"ADMIN\"]','[\"OWNER\", \"ADMIN\"]','2021-07-28 14:02:41','（业务表）待办事项表'),(5,0,'Function',NULL,'[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"UNKNOWN\", \"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[\"LOGIN\", \"CONTACT\", \"CIRCLE\", \"OWNER\", \"ADMIN\"]','[]','[]','[]','2018-11-28 16:38:15','框架本身需要');
/*!40000 ALTER TABLE `Access` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Credential`
--

DROP TABLE IF EXISTS `Credential`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Credential` (
  `id` bigint(20) DEFAULT NULL,
  `pwdHash` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Credential`
--

LOCK TABLES `Credential` WRITE;
/*!40000 ALTER TABLE `Credential` DISABLE KEYS */;
INSERT INTO `Credential` VALUES (1627761019072,'123456'),(1627761038716,'233233'),(1627761152411,'654321'),(1627761504126,'666666');
/*!40000 ALTER TABLE `Credential` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Function`
--

DROP TABLE IF EXISTS `Function`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Function` (
  `id` bigint(15) NOT NULL AUTO_INCREMENT,
  `debug` tinyint(2) NOT NULL DEFAULT 0 COMMENT '是否为 DEBUG 调试数据，只允许在开发环境使用，测试和线上环境禁用：0-否，1-是。',
  `userId` bigint(15) NOT NULL COMMENT '管理员用户Id',
  `name` varchar(50) NOT NULL COMMENT '方法名',
  `arguments` varchar(100) DEFAULT NULL COMMENT '参数列表，每个参数的类型都是 String。\n用 , 分割的字符串 比 [JSONArray] 更好，例如 array,item ，更直观，还方便拼接函数。',
  `demo` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '可用的示例。\nTODO 改成 call，和返回值示例 back 对应。' CHECK (json_valid(`demo`)),
  `detail` varchar(1000) NOT NULL COMMENT '详细描述',
  `type` varchar(50) NOT NULL DEFAULT 'Object' COMMENT '返回值类型。TODO RemoteFunction 校验 type 和 back',
  `version` tinyint(4) NOT NULL DEFAULT 0 COMMENT '允许的最低版本号，只限于GET,HEAD外的操作方法。\nTODO 使用 requestIdList 替代 version,tag,methods',
  `tag` varchar(20) DEFAULT NULL COMMENT '允许的标签.\nnull - 允许全部\nTODO 使用 requestIdList 替代 version,tag,methods',
  `methods` varchar(50) DEFAULT NULL COMMENT '允许的操作方法。\nnull - 允许全部\nTODO 使用 requestIdList 替代 version,tag,methods',
  `date` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '创建时间',
  `back` varchar(45) DEFAULT NULL COMMENT '返回值示例',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 COMMENT='远程函数。强制在启动时校验所有demo是否能正常运行通过';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Function`
--

LOCK TABLES `Function` WRITE;
/*!40000 ALTER TABLE `Function` DISABLE KEYS */;
INSERT INTO `Function` VALUES (1,0,0,'sayHello','name','{\"name\": \"test\"}','最简单的远程函数','Object',0,NULL,NULL,'2021-07-28 12:04:27',NULL),(2,0,0,'isUserCanPutTodo','todoId','{\"todoId\": 123}','用来判定todo的写权限。','Object',0,NULL,NULL,'2021-07-28 12:04:27',NULL),(3,0,0,'getNoteCountAPI','','{}','计数当前登录用户的todo数，展示如何在远程函数内部操作db','Object',0,NULL,NULL,'2021-07-28 12:04:27',NULL),(4,0,0,'rawSQLAPI','id','{\"id\": \"_DOCUMENT_ONLY_\"}','展示如何用裸SQL操作','Object',0,NULL,NULL,'2021-07-28 12:04:27',NULL),(10,0,0,'countArray','array','{\"array\": [1, 2, 3]}','（框架启动自检需要）获取数组长度。没写调用键值对，会自动补全 \"result()\": \"countArray(array)\"','Object',0,NULL,NULL,'2018-10-13 08:23:23',NULL),(11,0,0,'isContain','array,value','{\"array\": [1, 2, 3], \"value\": 2}','（框架启动自检需要）判断是否数组包含值。','Object',0,NULL,NULL,'2018-10-13 08:23:23',NULL),(12,0,0,'getFromArray','array,position','{\"array\": [1, 2, 3], \"result()\": \"getFromArray(array,1)\"}','（框架启动自检需要）根据下标获取数组里的值。position 传数字时直接作为值，而不是从所在对象 request 中取值','Object',0,NULL,NULL,'2018-10-13 08:30:31',NULL),(13,0,0,'getFromObject','object,key','{\"key\": \"id\", \"object\": {\"id\": 1}}','（框架启动自检需要）根据键获取对象里的值。','Object',0,NULL,NULL,'2018-10-13 08:30:31',NULL);
/*!40000 ALTER TABLE `Function` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Request`
--

DROP TABLE IF EXISTS `Request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Request` (
  `id` bigint(15) NOT NULL COMMENT '唯一标识',
  `debug` tinyint(2) NOT NULL DEFAULT 0 COMMENT '是否为 DEBUG 调试数据，只允许在开发环境使用，测试和线上环境禁用：0-否，1-是。',
  `version` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'GET,HEAD可用任意结构访问任意开放内容，不需要这个字段。\n其它的操作因为写入了结构和内容，所以都需要，按照不同的version选择对应的structure。\n\n自动化版本管理：\nRequest JSON最外层可以传  “version”:Integer 。\n1.未传或 <= 0，用最新版。 “@order”:”version-“\n2.已传且 > 0，用version以上的可用版本的最低版本。 “@order”:”version+”, “version{}”:”>={version}”',
  `method` varchar(10) DEFAULT 'GETS' COMMENT '只限于GET,HEAD外的操作方法。',
  `tag` varchar(20) NOT NULL COMMENT '标签',
  `structure` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '结构。\nTODO 里面的 PUT 改为 UPDATE，避免和请求 PUT 搞混。' CHECK (json_valid(`structure`)),
  `detail` varchar(10000) DEFAULT NULL COMMENT '详细说明',
  `date` timestamp NULL DEFAULT current_timestamp() COMMENT '创建日期',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='请求参数校验配置(必须)。\n最好编辑完后删除主键，这样就是只读状态，不能随意更改。需要更改就重新加上主键。\n\n每次启动服务器时加载整个表到内存。\n这个表不可省略，model内注解的权限只是客户端能用的，其它可以保证即便服务端代码错误时也不会误删数据。';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Request`
--

LOCK TABLES `Request` WRITE;
/*!40000 ALTER TABLE `Request` DISABLE KEYS */;
INSERT INTO `Request` VALUES (2,0,1,'POST','api_register','{\"User\": {\"MUST\": \"username,realname\", \"REFUSE\": \"id\", \"UNIQUE\": \"username\"}, \"Credential\": {\"MUST\": \"pwdHash\", \"UPDATE\": {\"id@\": \"User/id\"}}}','注意tag名小写开头，则不会被默认映射到表','2021-07-28 18:15:40'),(3,0,1,'PUT','User','{\"REFUSE\": \"username\", \"UPDATE\": {\"@role\": \"OWNER\"}}','user 修改自身数据','2021-07-29 12:49:20'),(4,0,1,'POST','Todo','{\"MUST\": \"title\", \"UPDATE\": {\"@role\": \"OWNER\"}, \"REFUSE\": \"id\"}','增加todo','2021-07-29 13:18:50'),(5,0,1,'PUT','Todo','{\"Todo\":{ \"MUST\":\"id\",\"REFUSE\": \"userId\", \"UPDATE\": {\"checkCanPut-()\": \"isUserCanPutTodo(id)\"}} }','修改todo','2021-07-29 14:05:57'),(6,0,1,'DELETE','Todo','{\"MUST\": \"id\", \"REFUSE\": \"!\", \"INSERT\": {\"@role\": \"OWNER\"}}','删除todo','2021-07-29 14:10:32'),(8,0,1,'PUT','helper+','{\"Todo\": {\"MUST\": \"id,helper+\", \"INSERT\": {\"@role\": \"OWNER\"}}}','增加todo helper','2021-07-29 21:46:34'),(9,0,1,'PUT','helper-','{\"Todo\": {\"MUST\": \"id,helper-\", \"INSERT\": {\"@role\": \"OWNER\"}}}','删除todo helper','2021-07-29 21:46:34'),(10,0,1,'POST','Todo:[]','{\"Todo[]\": [{\"MUST\": \"title\", \"REFUSE\": \"id\"}], \"UPDATE\": {\"@role\": \"OWNER\"}}','批量增加todo','2021-08-01 04:51:31'),(11,0,1,'PUT','Todo:[]','{\"Todo[]\":[{ \"MUST\":\"id\",\"REFUSE\": \"userId\", \"UPDATE\": {\"checkCanPut-()\": \"isUserCanPutTodo(id)\"}}] }','每项单独设置（现在不生效）','2021-08-01 04:51:31'),(12,0,1,'PUT','Todo[]','{\"Todo\":{ \"MUST\":\"id{}\",\"REFUSE\": \"userId\", \"UPDATE\": {\"checkCanPut-()\": \"isUserCanPutTodo(id)\"}} }','指定全部改（现在不生效）','2021-08-01 04:51:31'),(13,0,1,'DELETE','Todo[]','{\"Todo\": {\"MUST\": \"id{}\", \"REFUSE\": \"!\", \"INSERT\": {\"@role\": \"OWNER\"}}}','删除todo','2021-08-01 10:35:15');
/*!40000 ALTER TABLE `Request` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Todo`
--

DROP TABLE IF EXISTS `Todo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Todo` (
  `id` bigint(20) DEFAULT NULL,
  `userId` bigint(20) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `date` timestamp NULL DEFAULT current_timestamp(),
  `helper` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Todo`
--

LOCK TABLES `Todo` WRITE;
/*!40000 ALTER TABLE `Todo` DISABLE KEYS */;
INSERT INTO `Todo` VALUES (1627761460691,1627761019072,'new todo','some content here...','2021-07-31 19:57:40',NULL),(1627761702477,1627761019072,'yet another todo','good helper','2021-07-31 20:01:42',NULL),(1627761711192,1627761019072,'yet another todo','good helper','2021-07-31 20:01:51','[1627761504126]'),(1627794007156,1627761019072,'edit put multi','good 1','2021-08-01 05:00:07',NULL),(1627794007173,1627761019072,'edit put multi','good 1','2021-08-01 05:00:07',NULL),(1627794043682,1627761019072,'multi post a1','','2021-08-01 05:00:44',NULL),(1627794043692,1627761019072,'multi post a2','','2021-08-01 05:00:44',NULL);
/*!40000 ALTER TABLE `Todo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `User`
--

DROP TABLE IF EXISTS `User`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `User` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '学校账号（教职工号）',
  `username` varchar(255) DEFAULT NULL,
  `realname` varchar(255) DEFAULT NULL,
  `bio` varchar(255) DEFAULT NULL,
  `friends` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `User_id_uindex` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1627761504127 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `User`
--

LOCK TABLES `User` WRITE;
/*!40000 ALTER TABLE `User` DISABLE KEYS */;
INSERT INTO `User` VALUES (1627761019072,'jerry','jerry','edit my bio while adding a friend','[1627761038716]'),(1627761038716,'neko','neko','registered via api',NULL),(1627761152411,'randomguy','randomguy','registered via api',NULL),(1627761504126,'doge','doge','registered via api',NULL);
/*!40000 ALTER TABLE `User` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-08-27 16:54:39

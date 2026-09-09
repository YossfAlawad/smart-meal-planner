CREATE DATABASE  IF NOT EXISTS `smart_meal_planner` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `smart_meal_planner`;
-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: smart_meal_planner
-- ------------------------------------------------------
-- Server version	8.0.31

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `ingredients`
--

DROP TABLE IF EXISTS `ingredients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ingredients` (
  `ingredient_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `unit` varchar(20) NOT NULL,
  PRIMARY KEY (`ingredient_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ingredients`
--

LOCK TABLES `ingredients` WRITE;
/*!40000 ALTER TABLE `ingredients` DISABLE KEYS */;
INSERT INTO `ingredients` VALUES (1,'Chicken Breast','g'),(2,'Rice','g'),(3,'Broccoli','g'),(4,'Oats','g'),(5,'Milk','ml'),(6,'Banana','g'),(7,'Egg','g'),(8,'Pasta','g'),(9,'Tomato','g'),(10,'Salmon','g'),(11,'Potato','g'),(12,'Spinach','g');
/*!40000 ALTER TABLE `ingredients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mealplanrecipes`
--

DROP TABLE IF EXISTS `mealplanrecipes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mealplanrecipes` (
  `plan_id` int NOT NULL,
  `recipe_id` int NOT NULL,
  `meal_time` varchar(20) NOT NULL,
  `servings` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`plan_id`,`recipe_id`),
  KEY `recipe_id` (`recipe_id`),
  CONSTRAINT `mealplanrecipes_ibfk_1` FOREIGN KEY (`plan_id`) REFERENCES `mealplans` (`plan_id`) ON DELETE CASCADE,
  CONSTRAINT `mealplanrecipes_ibfk_2` FOREIGN KEY (`recipe_id`) REFERENCES `recipes` (`recipe_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mealplanrecipes`
--

LOCK TABLES `mealplanrecipes` WRITE;
/*!40000 ALTER TABLE `mealplanrecipes` DISABLE KEYS */;
INSERT INTO `mealplanrecipes` VALUES (1,1,'Lunch',1),(1,2,'Breakfast',1),(1,4,'Dinner',1),(2,3,'Lunch',1),(2,5,'Breakfast',1),(3,2,'Breakfast',2),(3,6,'Lunch',1),(4,3,'Dinner',1),(4,5,'Breakfast',1),(5,2,'Breakfast',1),(5,4,'Dinner',1),(6,1,'Dinner',1),(6,5,'Breakfast',2);
/*!40000 ALTER TABLE `mealplanrecipes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mealplans`
--

DROP TABLE IF EXISTS `mealplans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mealplans` (
  `plan_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`plan_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `mealplans_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mealplans`
--

LOCK TABLES `mealplans` WRITE;
/*!40000 ALTER TABLE `mealplans` DISABLE KEYS */;
INSERT INTO `mealplans` VALUES (1,1,'2026-09-08'),(2,1,'2026-09-09'),(3,2,'2026-09-08'),(4,3,'2026-09-08'),(5,4,'2026-09-08'),(6,5,'2026-09-09');
/*!40000 ALTER TABLE `mealplans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nutrition`
--

DROP TABLE IF EXISTS `nutrition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nutrition` (
  `ingredient_id` int NOT NULL,
  `calories` decimal(8,2) NOT NULL,
  `protein` decimal(8,2) NOT NULL,
  `carbs` decimal(8,2) NOT NULL,
  `fat` decimal(8,2) NOT NULL,
  PRIMARY KEY (`ingredient_id`),
  CONSTRAINT `nutrition_ibfk_1` FOREIGN KEY (`ingredient_id`) REFERENCES `ingredients` (`ingredient_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nutrition`
--

LOCK TABLES `nutrition` WRITE;
/*!40000 ALTER TABLE `nutrition` DISABLE KEYS */;
INSERT INTO `nutrition` VALUES (1,165.00,31.00,0.00,3.60),(2,130.00,2.70,28.00,0.30),(3,34.00,2.80,7.00,0.40),(4,389.00,16.90,66.30,6.90),(5,42.00,3.40,5.00,1.00),(6,89.00,1.10,22.80,0.30),(7,143.00,12.60,0.70,9.50),(8,131.00,5.00,25.00,1.10),(9,18.00,0.90,3.90,0.20),(10,208.00,20.00,0.00,13.00),(11,77.00,2.00,17.00,0.10),(12,23.00,2.90,3.60,0.40);
/*!40000 ALTER TABLE `nutrition` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recipeingredients`
--

DROP TABLE IF EXISTS `recipeingredients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recipeingredients` (
  `recipe_id` int NOT NULL,
  `ingredient_id` int NOT NULL,
  `quantity` decimal(8,2) NOT NULL,
  PRIMARY KEY (`recipe_id`,`ingredient_id`),
  KEY `ingredient_id` (`ingredient_id`),
  CONSTRAINT `recipeingredients_ibfk_1` FOREIGN KEY (`recipe_id`) REFERENCES `recipes` (`recipe_id`) ON DELETE CASCADE,
  CONSTRAINT `recipeingredients_ibfk_2` FOREIGN KEY (`ingredient_id`) REFERENCES `ingredients` (`ingredient_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recipeingredients`
--

LOCK TABLES `recipeingredients` WRITE;
/*!40000 ALTER TABLE `recipeingredients` DISABLE KEYS */;
INSERT INTO `recipeingredients` VALUES (1,1,200.00),(1,2,150.00),(1,3,100.00),(2,4,80.00),(2,5,200.00),(2,6,100.00),(3,8,150.00),(3,9,100.00),(3,12,50.00),(4,3,100.00),(4,10,180.00),(4,11,200.00),(5,7,150.00),(5,12,50.00),(6,1,180.00),(6,8,150.00),(6,9,100.00);
/*!40000 ALTER TABLE `recipeingredients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recipes`
--

DROP TABLE IF EXISTS `recipes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recipes` (
  `recipe_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `category` varchar(50) NOT NULL,
  PRIMARY KEY (`recipe_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recipes`
--

LOCK TABLES `recipes` WRITE;
/*!40000 ALTER TABLE `recipes` DISABLE KEYS */;
INSERT INTO `recipes` VALUES (1,'Chicken and Rice','High-protein'),(2,'Oatmeal with Banana','Breakfast'),(3,'Vegetable Pasta','Vegetarian'),(4,'Salmon and Potatoes','High-protein'),(5,'Scrambled Eggs with Spinach','Breakfast'),(6,'Chicken Pasta','High-protein');
/*!40000 ALTER TABLE `recipes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `age` int DEFAULT NULL,
  `height` decimal(5,2) DEFAULT NULL,
  `weight` decimal(5,2) DEFAULT NULL,
  `goal` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Emma Johnson','emma@example.com',24,168.00,65.00,'Maintain weight'),(2,'Liam Smith','liam@example.com',28,182.00,82.00,'Gain muscle'),(3,'Sofia Andersson','sofia@example.com',21,165.00,70.00,'Lose weight'),(4,'Noah Williams','noah@example.com',30,178.00,76.00,'Maintain weight'),(5,'Olivia Brown','olivia@example.com',26,170.00,68.00,'Gain muscle');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'smart_meal_planner'
--
/*!50003 DROP FUNCTION IF EXISTS `GetRecipeCalories` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `GetRecipeCalories`(p_recipe_id INT) RETURNS decimal(10,2)
    READS SQL DATA
    DETERMINISTIC
BEGIN
    DECLARE total_calories DECIMAL(10,2);

    SELECT SUM(n.calories * ri.quantity / 100)
    INTO total_calories
    FROM RecipeIngredients ri
    JOIN Nutrition n
        ON ri.ingredient_id = n.ingredient_id
    WHERE ri.recipe_id = p_recipe_id;

    RETURN IFNULL(total_calories, 0);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetRecipesUnderCalories` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetRecipesUnderCalories`(
    IN p_max_calories DECIMAL(10,2)
)
BEGIN
    SELECT
        recipe_id,
        name,
        category,
        GetRecipeCalories(recipe_id) AS total_calories
    FROM Recipes
    WHERE GetRecipeCalories(recipe_id) <= p_max_calories
    ORDER BY total_calories ASC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-09 17:26:43

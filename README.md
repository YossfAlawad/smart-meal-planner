# Smart Meal Planner

Smart Meal Planner is a database project that helps users organize meal plans and track nutritional information.

The system stores users, recipes, ingredients, nutrition data, and meal plans in a MySQL database. A Python console application allows the user to interact with the database.

## Features

The application allows users to:

- View all recipes
- View the ingredients of a specific recipe
- View nutritional information for a recipe
- Find recipes under a specified calorie limit
- View a user's meal plans
- View the total nutritional values of a meal plan

## Database

The project uses MySQL and contains the following tables:

- Users
- MealPlans
- Recipes
- Ingredients
- Nutrition
- RecipeIngredients
- MealPlanRecipes

The database includes primary keys, foreign keys, one-to-many relationships, many-to-many relationships, and a one-to-one relationship.

The project also uses:

- SQL JOIN queries
- Aggregation and GROUP BY
- A stored function for calculating recipe calories
- A stored procedure for finding recipes under a calorie limit

## Technologies

- Python 3
- MySQL 8.0
- MySQL Connector for Python
- MySQL Workbench

## Installation

### 1. Import the database

Open MySQL Workbench and import:

`smart_meal_planner_dump.sql`

This creates the `smart_meal_planner` database and its tables, sample data, stored function, and stored procedure.

### 2. Install the Python dependency

Run:

```bash
pip install mysql-connector-python
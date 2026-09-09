import mysql.connector
import getpass


def connect_database():
    password = getpass.getpass("Enter MySQL password: ")

    return mysql.connector.connect(
        host="localhost",
        user="root",
        password=password,
        database="smart_meal_planner"
    )


# OPTION 1 - VIEW ALL RECIPES

def view_all_recipes(connection):
    cursor = connection.cursor()

    cursor.execute("""
        SELECT recipe_id, name, category
        FROM Recipes
        ORDER BY recipe_id;
    """)

    recipes = cursor.fetchall()

    print("\n====================================")
    print("          ALL RECIPES")
    print("====================================")

    for recipe in recipes:
        print(f"{recipe[0]}. {recipe[1]} - {recipe[2]}")

    cursor.close()



# OPTION 2 - VIEW RECIPE INGREDIENTS

def view_recipe_ingredients(connection):
    cursor = connection.cursor()

    recipe_id = input("\nEnter recipe ID: ")

    cursor.execute("""
        SELECT
            r.name,
            i.name,
            ri.quantity,
            i.unit
        FROM Recipes r
        JOIN RecipeIngredients ri
            ON r.recipe_id = ri.recipe_id
        JOIN Ingredients i
            ON ri.ingredient_id = i.ingredient_id
        WHERE r.recipe_id = %s;
    """, (recipe_id,))

    ingredients = cursor.fetchall()

    if ingredients:
        print("\n====================================")
        print("        RECIPE INGREDIENTS")
        print("====================================")
        print(f"Recipe: {ingredients[0][0]}\n")

        for ingredient in ingredients:
            print(f"{ingredient[1]}: {ingredient[2]} {ingredient[3]}")

    else:
        print("\nRecipe not found.")

    cursor.close()



# OPTION 3 - VIEW RECIPE NUTRITION

def view_recipe_nutrition(connection):
    cursor = connection.cursor()

    recipe_id = input("\nEnter recipe ID: ")

    cursor.execute("""
        SELECT
            r.name,
            SUM(n.calories * ri.quantity / 100) AS calories,
            SUM(n.protein * ri.quantity / 100) AS protein,
            SUM(n.carbs * ri.quantity / 100) AS carbs,
            SUM(n.fat * ri.quantity / 100) AS fat
        FROM Recipes r
        JOIN RecipeIngredients ri
            ON r.recipe_id = ri.recipe_id
        JOIN Nutrition n
            ON ri.ingredient_id = n.ingredient_id
        WHERE r.recipe_id = %s
        GROUP BY r.recipe_id, r.name;
    """, (recipe_id,))

    nutrition = cursor.fetchone()

    if nutrition:
        print("\n====================================")
        print("         RECIPE NUTRITION")
        print("====================================")
        print(f"Recipe: {nutrition[0]}\n")
        print(f"Calories: {nutrition[1]:.2f} kcal")
        print(f"Protein:  {nutrition[2]:.2f} g")
        print(f"Carbs:    {nutrition[3]:.2f} g")
        print(f"Fat:      {nutrition[4]:.2f} g")

    else:
        print("\nRecipe not found.")

    cursor.close()



# OPTION 4 - FIND RECIPES UNDER CALORIE LIMIT

def find_recipes_under_calories(connection):
    cursor = connection.cursor()

    try:
        max_calories = float(input("\nEnter maximum calories: "))

        cursor.callproc(
            "GetRecipesUnderCalories",
            [max_calories]
        )

        recipes = []

        for result in cursor.stored_results():
            recipes = result.fetchall()

        print("\n====================================")
        print("     RECIPES UNDER CALORIE LIMIT")
        print("====================================")
        print(f"Maximum calories: {max_calories:.2f} kcal\n")

        if recipes:
            for recipe in recipes:
                print(
                    f"{recipe[0]}. {recipe[1]} - "
                    f"{recipe[2]} - {recipe[3]:.2f} kcal"
                )
        else:
            print("No recipes found under this calorie limit.")

    except ValueError:
        print("\nPlease enter a valid number.")

    cursor.close()



# OPTION 5 - VIEW USER MEAL PLANS

def view_user_meal_plans(connection):
    cursor = connection.cursor()

    user_id = input("\nEnter user ID: ")

    # First check that the user exists
    cursor.execute("""
        SELECT name
        FROM Users
        WHERE user_id = %s;
    """, (user_id,))

    user = cursor.fetchone()

    if not user:
        print("\nUser not found.")
        cursor.close()
        return

    cursor.execute("""
        SELECT
            mp.plan_id,
            mp.date,
            mpr.meal_time,
            r.name,
            mpr.servings
        FROM MealPlans mp
        JOIN MealPlanRecipes mpr
            ON mp.plan_id = mpr.plan_id
        JOIN Recipes r
            ON mpr.recipe_id = r.recipe_id
        WHERE mp.user_id = %s
        ORDER BY
            mp.date,
            mp.plan_id,
            CASE mpr.meal_time
                WHEN 'Breakfast' THEN 1
                WHEN 'Lunch' THEN 2
                WHEN 'Dinner' THEN 3
                ELSE 4
            END;
    """, (user_id,))

    meal_plans = cursor.fetchall()

    print("\n====================================")
    print("          USER MEAL PLANS")
    print("====================================")
    print(f"User: {user[0]}\n")

    if meal_plans:
        current_date = None

        for meal in meal_plans:
            plan_id = meal[0]
            date = meal[1]
            meal_time = meal[2]
            recipe_name = meal[3]
            servings = meal[4]

            if date != current_date:
                print(f"\nDate: {date}")
                print(f"Meal Plan ID: {plan_id}")
                print("------------------------------------")
                current_date = date

            print(
                f"{meal_time}: {recipe_name} "
                f"(Servings: {servings})"
            )

    else:
        print("This user has no meal plans.")

    cursor.close()


# OPTION 6 - VIEW MEAL PLAN NUTRITION

def view_meal_plan_nutrition(connection):
    cursor = connection.cursor()

    plan_id = input("\nEnter meal plan ID: ")

    # Find meal plan and user
    cursor.execute("""
        SELECT
            mp.plan_id,
            mp.date,
            u.name
        FROM MealPlans mp
        JOIN Users u
            ON mp.user_id = u.user_id
        WHERE mp.plan_id = %s;
    """, (plan_id,))

    meal_plan = cursor.fetchone()

    if not meal_plan:
        print("\nMeal plan not found.")
        cursor.close()
        return

    # Calculate nutrition for all recipes in the meal plan
    cursor.execute("""
        SELECT
            SUM(
                n.calories * ri.quantity / 100 * mpr.servings
            ) AS calories,

            SUM(
                n.protein * ri.quantity / 100 * mpr.servings
            ) AS protein,

            SUM(
                n.carbs * ri.quantity / 100 * mpr.servings
            ) AS carbs,

            SUM(
                n.fat * ri.quantity / 100 * mpr.servings
            ) AS fat

        FROM MealPlanRecipes mpr
        JOIN RecipeIngredients ri
            ON mpr.recipe_id = ri.recipe_id
        JOIN Nutrition n
            ON ri.ingredient_id = n.ingredient_id
        WHERE mpr.plan_id = %s;
    """, (plan_id,))

    nutrition = cursor.fetchone()

    print("\n====================================")
    print("       MEAL PLAN NUTRITION")
    print("====================================")
    print(f"Meal Plan ID: {meal_plan[0]}")
    print(f"User: {meal_plan[2]}")
    print(f"Date: {meal_plan[1]}\n")

    if nutrition and nutrition[0] is not None:
        print(f"Calories: {nutrition[0]:.2f} kcal")
        print(f"Protein:  {nutrition[1]:.2f} g")
        print(f"Carbs:    {nutrition[2]:.2f} g")
        print(f"Fat:      {nutrition[3]:.2f} g")
    else:
        print("No recipes found in this meal plan.")

    cursor.close()



# MAIN MENU

def main():

    try:
        connection = connect_database()

        print("\nConnected to smart_meal_planner successfully!")

        while True:

            print("\n====================================")
            print("        SMART MEAL PLANNER")
            print("====================================")
            print("1. View all recipes")
            print("2. View recipe ingredients")
            print("3. View recipe nutrition")
            print("4. Find recipes under calorie limit")
            print("5. View user meal plans")
            print("6. View meal plan nutrition")
            print("7. Exit")

            choice = input("\nChoose an option (1-7): ")

            if choice == "1":
                view_all_recipes(connection)

            elif choice == "2":
                view_recipe_ingredients(connection)

            elif choice == "3":
                view_recipe_nutrition(connection)

            elif choice == "4":
                find_recipes_under_calories(connection)

            elif choice == "5":
                view_user_meal_plans(connection)

            elif choice == "6":
                view_meal_plan_nutrition(connection)

            elif choice == "7":
                print("\nGoodbye!")
                break

            else:
                print("\nInvalid option. Please choose 1-7.")

    except mysql.connector.Error as error:
        print("\nDatabase error:")
        print(error)

    finally:
        if 'connection' in locals() and connection.is_connected():
            connection.close()
            print("Connection closed.")



if __name__ == "__main__":
    main()
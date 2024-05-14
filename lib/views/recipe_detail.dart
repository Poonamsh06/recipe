import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe/controller/favouriterecipe_controller.dart';
import 'package:recipe/controller/recipe_controller.dart';

class RecipeDetail extends StatelessWidget {
  final RecipeController recipeController = Get.put(RecipeController());
  final FavoriteRecipesController favoriteRecipesController =
      Get.put(FavoriteRecipesController());
  final Map<String, dynamic> recipe;

  RecipeDetail({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          recipe['recipe']['label'],
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              recipe['recipe']['image'],
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width * 0.8,
              fit: BoxFit.fill,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Ingredients:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Column(
              children: List.generate(
                recipe['recipe']['ingredients'].length,
                (index) => ListTile(
                  title: Text(recipe['recipe']['ingredients'][index]['text']),
                ),
              ),
            ),
            Text(
              'Meal Type: ${recipe['recipe']['mealType']}',
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Label: ${recipe['recipe']['healthLabels']}',
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.normal,
              ),
            ),
            IconButton(
              icon: Icon(Icons.favorite),
              color: favoriteRecipesController.isFavorite(recipe)
                  ? Colors.red
                  : Colors.grey,
              onPressed: () {
                favoriteRecipesController.toggleFavorite(recipe);
              },
            ),
          ],
        ),
      ),
    );
  }
}

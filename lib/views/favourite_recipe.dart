import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe/controller/favouriterecipe_controller.dart';

class FavoriteRecipes extends StatelessWidget {
  final FavoriteRecipesController favoriteRecipesController =
      Get.put(FavoriteRecipesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorite Recipes',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (favoriteRecipesController.favoriteRecipes.isEmpty) {
          return Center(
            child: Text(
              'No favorite recipes yet.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        } else {
          return ListView.builder(
            itemCount: favoriteRecipesController.favoriteRecipes.length,
            itemBuilder: (context, index) {
              var recipe = favoriteRecipesController.favoriteRecipes[index];
              return ListTile(
                title: Text(recipe['recipe']['label']),
                leading: Image.network(
                  recipe['recipe']['image'],
                  width: 60.0,
                  height: 60.0,
                  fit: BoxFit.cover,
                ),
                subtitle: Text(
                  'Calories: ${recipe['recipe']['calories'].toStringAsFixed(2)}',
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    favoriteRecipesController.removeFavorite(recipe);
                  },
                ),
              );
            },
          );
        }
      }),
    );
  }
}

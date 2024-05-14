import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:recipe/controller/favouriterecipe_controller.dart';
import 'package:recipe/views/favourite_recipe.dart';
import 'package:recipe/views/recipe_detail.dart';

import '../controller/recipe_controller.dart';

class RecipeSearchScreen extends StatelessWidget {
  final RecipeController recipeController = Get.put(RecipeController());
  final FavoriteRecipesController favoriteRecipesController =
      Get.put(FavoriteRecipesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: <Widget>[
        const SizedBox(height: 10),
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text(
            'Home',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          onTap: () {
            Get.to(RecipeSearchScreen());
            // Navigate to home screen
          },
        ),
        ListTile(
          leading: const Icon(Icons.favorite),
          title: const Text(
            'Favourite Recipes',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          onTap: () {
            Get.to(FavoriteRecipes());
          },
        ),
      ])),
      appBar: AppBar(
        title: const Text(
          'Recipes',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.06,
                  width: MediaQuery.of(context).size.width * 0.55,
                  child: TextField(
                    // textAlign: TextAlign.center,
                    onSubmitted: (value) =>
                        recipeController.fetchRecipes(value),
                    decoration: InputDecoration(
                      hintText: 'Enter ingredients',
                      hintStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FavoriteRecipes(),
                        ),
                      );
                    },
                    child: const Icon(Icons.favorite)),
                ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Center(
                                  child: Text(
                                    'Filter ',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                                CheckboxListTile(
                                  title: const Text('Vegetarian'),
                                  value: recipeController.isVegetarian.value,
                                  onChanged: (value) {
                                    recipeController.isVegetarian.value =
                                        value!;
                                  },
                                ),
                                CheckboxListTile(
                                  title: const Text('Vegan'),
                                  value: recipeController.isVegan.value,
                                  onChanged: (value) {
                                    recipeController.isVegan.value = value!;
                                  },
                                ),
                                CheckboxListTile(
                                  title: Text('Gluten-Free'),
                                  value: recipeController.isGlutenFree.value,
                                  onChanged: (value) {
                                    recipeController.isGlutenFree.value =
                                        value!;
                                  },
                                ),
                                const SizedBox(height: 16.0),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Apply filters
                                      recipeController.applyFilters();
                                      Get.back();
                                    },
                                    child: const Text('Apply'),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: const Icon(Icons.filter_list))
              ],
            ),
            const SizedBox(height: 16.0),
            Obx(() {
              if (recipeController.recipes.isEmpty) {
                return const Center(
                    child: Text(
                  'No recipes found.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ));
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: recipeController.recipes.length,
                  itemBuilder: (context, index) {
                    var recipe = recipeController.recipes[index];
                    // Filter
                    if (recipe['recipe']['dietLabels'].contains('Vegetarian') &&
                        !recipeController.isVegetarian.value) {
                      return const SizedBox.shrink();
                    }
                    if (recipe['recipe']['dietLabels'].contains('Vegan') &&
                        !recipeController.isVegan.value) {
                      return const SizedBox.shrink();
                    }
                    if (recipe['recipe']['dietLabels']
                            .contains('Gluten-Free') &&
                        !recipeController.isGlutenFree.value) {
                      return const SizedBox.shrink();
                    }
                    return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecipeDetail(
                                recipe: recipe,
                              ),
                            ),
                          );
                        },
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.15,
                          child: Card(
                            elevation: 4,
                            child: Center(
                              child: ListTile(
                                title: Text(recipe['recipe']['label']),
                                leading: Image.network(
                                  recipe['recipe']['image'],
                                  height:
                                      MediaQuery.of(context).size.height * 0.13,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  fit: BoxFit.fill,
                                ),
                                subtitle: Text(
                                  'Meal Type: ${recipe['recipe']['mealType']}',
                                ),
                              ),
                            ),
                          ),
                        ));
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

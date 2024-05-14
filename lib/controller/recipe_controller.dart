import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RecipeController extends GetxController {
  final recipes = [].obs;

  var isVegetarian = false.obs;
  var isVegan = false.obs;
  var isGlutenFree = false.obs;

  void applyFilters() {
    final List filteredRecipes = [];
    for (var recipe in recipes) {
      bool includeRecipe = true;
      if (isVegetarian.value && !recipe['isVegetarian']) {
        includeRecipe = false;
      }
      if (isVegan.value && !recipe['isVegan']) {
        includeRecipe = false;
      }
      if (isGlutenFree.value && !recipe['isGlutenFree']) {
        includeRecipe = false;
      }
      if (includeRecipe) {
        filteredRecipes.add(recipe);
      }
    }
    recipes.assignAll(filteredRecipes);
  }

  Future<void> fetchRecipes(String query) async {
    // Fetch recipes
    final response = await http.get(Uri.parse(
        'https://api.edamam.com/search?q=$query&app_id=8805010c&app_key=91e99b2ad33aaa63c1ce279108a90ce5'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      recipes.assignAll(data['hits']);
    } else {
      throw Exception('Failed to load recipes');
    }
  }
}

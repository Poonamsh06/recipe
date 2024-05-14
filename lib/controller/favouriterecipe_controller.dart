import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class FavoriteRecipesController extends GetxController {
  RxList favoriteRecipes = [].obs;

  void addFavorite(Map<String, dynamic> recipe) {
    favoriteRecipes.add(recipe);
  }

  void removeFavorite(Map<String, dynamic> recipe) {
    favoriteRecipes.remove(recipe);
  }

  bool isFavorite(Map<String, dynamic> recipe) {
    return favoriteRecipes.contains(recipe);
  }

  void toggleFavorite(Map<String, dynamic> recipe) {
    if (isFavorite(recipe)) {
      removeFavorite(recipe);
    } else {
      addFavorite(recipe);
    }
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:meal_app/providers/meals_provider.dart';

enum Filters { glutenFree, lactoseFree, vegetarian, vegan }

class FilterNotifier extends StateNotifier<Map<Filters, bool>> {
  FilterNotifier()
    : super({
        Filters.glutenFree: false,
        Filters.lactoseFree: false,
        Filters.vegetarian: false,
        Filters.vegan: false,
      });
  void setFilter(Filters filter, bool isActive) {
    state = {...state, filter: isActive};
  }

  void setFilters(Map<Filters, bool> choosenFilters) {
    state = choosenFilters;
  }
}

final filtersProvider =
    StateNotifierProvider<FilterNotifier, Map<Filters, bool>>(
      (ref) => FilterNotifier(),
    );

final filteredMealsProvider = Provider((ref){
  return meals.where((meal) {
      final meals=ref.watch(mealsProvider);
      final activeFilters = ref.watch(filteredMealsProvider);
      if (activeFilters[Filters.glutenFree]! && !meal.isGlutenFree) {
        return false;
      }
      if (activeFilters[Filters.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }
      if (activeFilters[Filters.vegetarian]! && !meal.isVegetarian) {
        return false;
      }
      if (activeFilters[Filters.vegan]! && !meal.isVegan) {
        return false;
      }
      return true;
    }).toList();
})
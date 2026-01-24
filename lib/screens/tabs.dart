import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:meal_app/screens/categories.dart';
import 'package:meal_app/screens/filters.dart';
import 'package:meal_app/screens/meals.dart';
import 'package:meal_app/widgets/main_drawer.dart';
import 'package:meal_app/providers/meals_provider.dart';
import 'package:meal_app/providers/favourites_provider.dart';
import 'package:meal_app/providers/filters_provider.dart';

const kInitialFilters = {
  Filters.glutenFree: false,
  Filters.lactoseFree: false,
  Filters.vegetarian: false,
  Filters.vegan: false,
};

class TabScreen extends ConsumerStatefulWidget {
  TabScreen({super.key});

  @override
  ConsumerState<TabScreen> createState() {
    return _TabScreenState();
  }
}

class _TabScreenState extends ConsumerState<TabScreen> {
  int _selectedPageIndex = 0;

  //Map<Filters, bool> _selectedFilters = kInitialFilters;

  void _selectpage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'filter') {
      await Navigator.of(context).push<Map<Filters, bool>>(
        MaterialPageRoute(builder: (ctx) => FilterScreen()),
      );
      ;
    }
  }

  @override
  Widget build(BuildContext context) {
    final meals = ref.watch(mealsProvider);
    final availableMeals = meals.where((meal) {
      final activeFilters = ref.watch(filtersProvider);
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
    var activePageTitle = 'Categories';
    Widget activePage = categoriesScreen(availableMeals: availableMeals);
    if (_selectedPageIndex == 1) {
      final favoriteMeals = ref.watch(favouriteMealsProvider);
      activePage = MealsScreen(meals: favoriteMeals);
      activePageTitle = ' Your Favourites';
    }

    return Scaffold(
      appBar: AppBar(title: Text(activePageTitle)),
      drawer: MainDrawer(onSelectScreen: _setScreen),
      body: activePage,

      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectpage,
        currentIndex: _selectedPageIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favrites'),
        ],
      ),
    );
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

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

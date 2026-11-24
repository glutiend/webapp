// Copyright (c) 2026 Emanuele Ciotola. All Rights Reserved.
// PROJECT: GlutiEnd — See LICENSE file in root for terms.

import 'gluten_rules.dart';

class AdditivesChecker {
  static List<String> findDoubtfulAdditives(String lowerIngredients) {
    final List<String> found = [];
    for (final d in GlutenRules.doubtfulAdditives) {
      if (GlutenRules.containsKeyword(lowerIngredients, d)) {
        found.add(d);
      }
    }
    return found;
  }
}

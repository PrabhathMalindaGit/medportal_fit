class FoodItem {
  final String id;
  final String name;
  final String description;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final double fiber;
  final String imageUrl;
  final String category;
  final List<String> allergens;
  final String servingSize;
  final String unit;

  FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
    this.imageUrl = '',
    this.category = 'Other',
    this.allergens = const [],
    this.servingSize = '1',
    this.unit = 'serving',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'fiber': fiber,
      'imageUrl': imageUrl,
      'category': category,
      'allergens': allergens,
      'servingSize': servingSize,
      'unit': unit,
    };
  }

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      calories: json['calories'],
      protein: json['protein'],
      carbs: json['carbs'],
      fat: json['fat'],
      fiber: json['fiber'],
      imageUrl: json['imageUrl'] ?? '',
      category: json['category'] ?? 'Other',
      allergens: List<String>.from(json['allergens'] ?? []),
      servingSize: json['servingSize'] ?? '1',
      unit: json['unit'] ?? 'serving',
    );
  }
}

class Meal {
  final String id;
  final String name;
  final String description;
  final List<MealItem> items;
  final String imageUrl;
  final String category; // breakfast, lunch, dinner, snack
  final List<String> tags;
  final String instructions;
  final Duration prepTime;
  final Duration cookTime;
  final int servings;

  Meal({
    required this.id,
    required this.name,
    required this.description,
    required this.items,
    required this.category,
    this.imageUrl = '',
    this.tags = const [],
    this.instructions = '',
    this.prepTime = const Duration(minutes: 0),
    this.cookTime = const Duration(minutes: 0),
    this.servings = 1,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'items': items.map((e) => e.toJson()).toList(),
      'imageUrl': imageUrl,
      'category': category,
      'tags': tags,
      'instructions': instructions,
      'prepTime': prepTime.inMinutes,
      'cookTime': cookTime.inMinutes,
      'servings': servings,
    };
  }

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      items: (json['items'] as List).map((e) => MealItem.fromJson(e)).toList(),
      imageUrl: json['imageUrl'] ?? '',
      category: json['category'],
      tags: List<String>.from(json['tags'] ?? []),
      instructions: json['instructions'] ?? '',
      prepTime: Duration(minutes: json['prepTime'] ?? 0),
      cookTime: Duration(minutes: json['cookTime'] ?? 0),
      servings: json['servings'] ?? 1,
    );
  }

  double get totalCalories => items.fold(0, (sum, item) => sum + item.calories);
  double get totalProtein => items.fold(0, (sum, item) => sum + item.protein);
  double get totalCarbs => items.fold(0, (sum, item) => sum + item.carbs);
  double get totalFat => items.fold(0, (sum, item) => sum + item.fat);
  double get totalFiber => items.fold(0, (sum, item) => sum + item.fiber);
}

class MealItem {
  final String foodItemId;
  final double quantity;
  final String unit;
  final String notes;

  MealItem({
    required this.foodItemId,
    required this.quantity,
    this.unit = 'serving',
    this.notes = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'foodItemId': foodItemId,
      'quantity': quantity,
      'unit': unit,
      'notes': notes,
    };
  }

  factory MealItem.fromJson(Map<String, dynamic> json) {
    return MealItem(
      foodItemId: json['foodItemId'],
      quantity: json['quantity'],
      unit: json['unit'] ?? 'serving',
      notes: json['notes'] ?? '',
    );
  }

  double get calories => 0; // Will be calculated based on food item
  double get protein => 0; // Will be calculated based on food item
  double get carbs => 0; // Will be calculated based on food item
  double get fat => 0; // Will be calculated based on food item
  double get fiber => 0; // Will be calculated based on food item
}

class MealPlan {
  final String id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final List<DailyMealPlan> dailyPlans;
  final double targetCalories;
  final double targetProtein;
  final double targetCarbs;
  final double targetFat;
  final List<String> restrictions;
  final String imageUrl;

  MealPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.dailyPlans,
    required this.targetCalories,
    required this.targetProtein,
    required this.targetCarbs,
    required this.targetFat,
    this.restrictions = const [],
    this.imageUrl = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'dailyPlans': dailyPlans.map((e) => e.toJson()).toList(),
      'targetCalories': targetCalories,
      'targetProtein': targetProtein,
      'targetCarbs': targetCarbs,
      'targetFat': targetFat,
      'restrictions': restrictions,
      'imageUrl': imageUrl,
    };
  }

  factory MealPlan.fromJson(Map<String, dynamic> json) {
    return MealPlan(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      dailyPlans: (json['dailyPlans'] as List)
          .map((e) => DailyMealPlan.fromJson(e))
          .toList(),
      targetCalories: json['targetCalories'],
      targetProtein: json['targetProtein'],
      targetCarbs: json['targetCarbs'],
      targetFat: json['targetFat'],
      restrictions: List<String>.from(json['restrictions'] ?? []),
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}

class DailyMealPlan {
  final DateTime date;
  final List<PlannedMeal> meals;
  final String notes;

  DailyMealPlan({
    required this.date,
    required this.meals,
    this.notes = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'meals': meals.map((e) => e.toJson()).toList(),
      'notes': notes,
    };
  }

  factory DailyMealPlan.fromJson(Map<String, dynamic> json) {
    return DailyMealPlan(
      date: DateTime.parse(json['date']),
      meals: (json['meals'] as List).map((e) => PlannedMeal.fromJson(e)).toList(),
      notes: json['notes'] ?? '',
    );
  }
}

class PlannedMeal {
  final String mealId;
  final String category; // breakfast, lunch, dinner, snack
  final DateTime plannedTime;
  final bool isCompleted;
  final String notes;

  PlannedMeal({
    required this.mealId,
    required this.category,
    required this.plannedTime,
    this.isCompleted = false,
    this.notes = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'mealId': mealId,
      'category': category,
      'plannedTime': plannedTime.toIso8601String(),
      'isCompleted': isCompleted,
      'notes': notes,
    };
  }

  factory PlannedMeal.fromJson(Map<String, dynamic> json) {
    return PlannedMeal(
      mealId: json['mealId'],
      category: json['category'],
      plannedTime: DateTime.parse(json['plannedTime']),
      isCompleted: json['isCompleted'] ?? false,
      notes: json['notes'] ?? '',
    );
  }
} 
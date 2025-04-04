import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/meal.dart';

class MealService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _foodItemsCollection = 'food_items';
  final String _mealsCollection = 'meals';
  final String _mealPlansCollection = 'meal_plans';

  // Food Item CRUD operations
  Future<void> addFoodItem(FoodItem foodItem) async {
    await _firestore.collection(_foodItemsCollection).doc(foodItem.id).set(foodItem.toJson());
  }

  Future<void> updateFoodItem(FoodItem foodItem) async {
    await _firestore.collection(_foodItemsCollection).doc(foodItem.id).update(foodItem.toJson());
  }

  Future<void> deleteFoodItem(String id) async {
    await _firestore.collection(_foodItemsCollection).doc(id).delete();
  }

  Stream<List<FoodItem>> getFoodItems() {
    return _firestore
        .collection(_foodItemsCollection)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FoodItem.fromJson(doc.data()))
            .toList());
  }

  Future<List<FoodItem>> getFoodItemsByCategory(String category) async {
    final snapshot = await _firestore
        .collection(_foodItemsCollection)
        .where('category', isEqualTo: category)
        .get();

    return snapshot.docs.map((doc) => FoodItem.fromJson(doc.data())).toList();
  }

  // Meal CRUD operations
  Future<void> addMeal(Meal meal) async {
    await _firestore.collection(_mealsCollection).doc(meal.id).set(meal.toJson());
  }

  Future<void> updateMeal(Meal meal) async {
    await _firestore.collection(_mealsCollection).doc(meal.id).update(meal.toJson());
  }

  Future<void> deleteMeal(String id) async {
    await _firestore.collection(_mealsCollection).doc(id).delete();
  }

  Stream<List<Meal>> getMeals() {
    return _firestore
        .collection(_mealsCollection)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Meal.fromJson(doc.data()))
            .toList());
  }

  Future<List<Meal>> getMealsByCategory(String category) async {
    final snapshot = await _firestore
        .collection(_mealsCollection)
        .where('category', isEqualTo: category)
        .get();

    return snapshot.docs.map((doc) => Meal.fromJson(doc.data())).toList();
  }

  // Meal Plan operations
  Future<void> addMealPlan(MealPlan mealPlan) async {
    await _firestore.collection(_mealPlansCollection).doc(mealPlan.id).set(mealPlan.toJson());
  }

  Future<void> updateMealPlan(MealPlan mealPlan) async {
    await _firestore.collection(_mealPlansCollection).doc(mealPlan.id).update(mealPlan.toJson());
  }

  Future<void> deleteMealPlan(String id) async {
    await _firestore.collection(_mealPlansCollection).doc(id).delete();
  }

  Stream<List<MealPlan>> getMealPlans() {
    return _firestore
        .collection(_mealPlansCollection)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MealPlan.fromJson(doc.data()))
            .toList());
  }

  Future<MealPlan?> getActiveMealPlan() async {
    final now = DateTime.now();
    final snapshot = await _firestore
        .collection(_mealPlansCollection)
        .where('startDate', isLessThanOrEqualTo: now.toIso8601String())
        .where('endDate', isGreaterThanOrEqualTo: now.toIso8601String())
        .get();

    if (snapshot.docs.isEmpty) return null;
    return MealPlan.fromJson(snapshot.docs.first.data());
  }

  Future<DailyMealPlan?> getDailyMealPlan(DateTime date) async {
    final mealPlan = await getActiveMealPlan();
    if (mealPlan == null) return null;

    return mealPlan.dailyPlans.firstWhere(
      (plan) => plan.date.year == date.year && 
                plan.date.month == date.month && 
                plan.date.day == date.day,
      orElse: () => DailyMealPlan(date: date, meals: []),
    );
  }

  Future<void> markMealAsCompleted(String mealPlanId, String mealId) async {
    final mealPlan = await _firestore.collection(_mealPlansCollection).doc(mealPlanId).get();
    if (!mealPlan.exists) return;

    final data = mealPlan.data()!;
    final dailyPlans = (data['dailyPlans'] as List).map((e) => DailyMealPlan.fromJson(e)).toList();
    
    for (var i = 0; i < dailyPlans.length; i++) {
      final meals = dailyPlans[i].meals;
      for (var j = 0; j < meals.length; j++) {
        if (meals[j].mealId == mealId) {
          meals[j] = PlannedMeal(
            mealId: meals[j].mealId,
            category: meals[j].category,
            plannedTime: meals[j].plannedTime,
            isCompleted: true,
            notes: meals[j].notes,
          );
          break;
        }
      }
    }

    await _firestore.collection(_mealPlansCollection).doc(mealPlanId).update({
      'dailyPlans': dailyPlans.map((e) => e.toJson()).toList(),
    });
  }

  Future<Map<String, double>> getNutritionSummary(DateTime date) async {
    final dailyPlan = await getDailyMealPlan(date);
    if (dailyPlan == null) return {};

    double totalCalories = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFat = 0;
    double totalFiber = 0;

    for (final plannedMeal in dailyPlan.meals) {
      final mealDoc = await _firestore.collection(_mealsCollection).doc(plannedMeal.mealId).get();
      if (!mealDoc.exists) continue;

      final meal = Meal.fromJson(mealDoc.data()!);
      totalCalories += meal.totalCalories;
      totalProtein += meal.totalProtein;
      totalCarbs += meal.totalCarbs;
      totalFat += meal.totalFat;
      totalFiber += meal.totalFiber;
    }

    return {
      'calories': totalCalories,
      'protein': totalProtein,
      'carbs': totalCarbs,
      'fat': totalFat,
      'fiber': totalFiber,
    };
  }
} 
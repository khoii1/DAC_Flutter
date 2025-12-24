/// Script để fix category IDs trong meals
/// Chạy: flutter run scripts/fix_category_ids.dart
/// Hoặc: dart run scripts/fix_category_ids.dart (không cần Flutter)
/// 
/// LƯU Ý: Script này cần Firebase được init, nên tốt nhất chạy từ trong app

import 'dart:io';

void main() async {
  print('''
╔══════════════════════════════════════════════════════════════════╗
║                    FIX CATEGORY IDs SCRIPT                       ║
╠══════════════════════════════════════════════════════════════════╣
║ Script này KHÔNG thể chạy trực tiếp từ terminal vì cần:         ║
║ - Firebase SDK đã init                                           ║
║ - Flutter context                                                ║
║                                                                  ║
║ CÁCH SỬ DỤNG:                                                    ║
║ 1. Mở app trên thiết bị/simulator                               ║
║ 2. Vào màn hình Settings                                         ║
║ 3. Nhấn nút "🔧 Fix Category IDs"                                ║
║                                                                  ║
║ HOẶC: Thêm code sau vào bất kỳ nút nào trong app:              ║
╚══════════════════════════════════════════════════════════════════╝

import 'package:vipt/app/data/helpers/fake_data_helper.dart';

// Gọi function này:
await FakeDataHelper.fixAllMealCategoryIds();

''');

  print('Script sẽ fix các meals sau:');
  print('');
  
  final mealToCategoryNames = {
    // Breakfast meals
    'Apple Sauce Oatmeal': ['Breakfast'],
    'Oatmeal With Apples & Raisins': ['Breakfast'],
    'Protein Kiwi Pizza': ['Breakfast'],
    'Oat Cookies': ['Breakfast'],
    'Apple Cookies': ['Breakfast'],
    'Tortilla Mushroom Pie': ['Breakfast'],
    'Quinoa With Banana': ['Breakfast'],
    // Lunch/Dinner meals
    'Mushroom Steak A': ['Lunch/Dinner'],
    'Mushroom Steak': ['Lunch/Dinner'],
    'Protein Cauliflower Bites': ['Lunch/Dinner'],
    'Mushroom Walnut Burger': ['Lunch/Dinner'],
    'Quinoa & Sweet Potato': ['Lunch/Dinner'],
    'Air-Fried Tofu': ['Lunch/Dinner'],
    'Broccoli & Cauliflower Curry With Rice': ['Lunch/Dinner'],
    'Sweet Potato Curry With Rice': ['Lunch/Dinner'],
    // Snack meals
    'Roasted Chickpeas': ['Snack'],
    'Raw Gingerbread Bites': ['Snack'],
    'Pumpkin Oat Bites': ['Snack'],
    'Buckwheat Bread': ['Snack'],
    'Onion Rings': ['Snack'],
    'Carrot Cake Bites': ['Snack'],
    'Apple Nachos': ['Snack'],
  };

  print('BREAKFAST:');
  mealToCategoryNames.forEach((meal, cats) {
    if (cats.contains('Breakfast')) print('  • $meal');
  });
  
  print('');
  print('LUNCH/DINNER:');
  mealToCategoryNames.forEach((meal, cats) {
    if (cats.contains('Lunch/Dinner')) print('  • $meal');
  });
  
  print('');
  print('SNACK:');
  mealToCategoryNames.forEach((meal, cats) {
    if (cats.contains('Snack')) print('  • $meal');
  });
  
  print('');
  print('═══════════════════════════════════════════════════════════════════');
  print('Nhấn ENTER để thoát...');
  stdin.readLineSync();
}


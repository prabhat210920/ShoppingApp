import 'package:shopping/Model/groceryItem.dart';
import 'package:shopping/data/catogries.dart';
import 'package:shopping/Model/category.dart';
import 'package:shopping/data/Dummy_data.dart';


final groceryItems = [
  groceryItem(
      id: 'a',
      name: 'Milk',
      quantity: 1,
      category: categories[Categories.dairy]!),
  groceryItem(
      id: 'b',
      name: 'Bananas',
      quantity: 5,
      category: categories[Categories.fruit]!),
  groceryItem(
      id: 'c',
      name: 'Beef Steak',
      quantity: 1,
      category: categories[Categories.meat]!),
];
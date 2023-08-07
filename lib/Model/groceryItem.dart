
import 'package:shopping/Model/category.dart';

class groceryItem{
  const groceryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category
  });
  final String id;
  final String name;
  final int quantity;
  final Category category;
}
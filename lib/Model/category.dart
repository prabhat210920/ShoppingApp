import 'package:flutter/widgets.dart';


enum Categories{
  vegetables,
  fruit,
  meat,
  dairy,
  carbs,
  sweet,
  spices,
  convenience,
  hygiene,
  other
}

class Category{
  const Category(this.id, this.color);
 final String id;
 final Color color;

  get title => id;

  // get title => null;
}
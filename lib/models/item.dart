import 'package:front_insumos/models/enums.dart';

class Item {
  final int? id;
  final String name;
  final Unit unit;
  final Category category;
  final String? description;

  Item({
    this.id,
    required this.name,
    required this.unit,
    required this.category,
    this.description,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      unit: Unit.fromString(json['unit']),
      category: Category.fromString(json['category']),
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'unit': unit.toJson(),
      'category': category.toJson(),
      'description': description,
    };
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_insumos/components/custom_popup.dart';
import 'package:front_insumos/models/enums.dart';
import 'package:front_insumos/models/item.dart';
import 'package:front_insumos/screens/stock/item_bloc/item_bloc.dart';
import 'package:front_insumos/screens/stock/item_bloc/item_event.dart';
import 'package:front_insumos/utils/colors.dart';

Future<void> showRegisterIngredientDialog(BuildContext context) async {
  // Initialize the category and unit values as enum values
  Category categoriaValue = Category.carnes; // Default category
  Unit unidadeValue = Unit.unidade; // Default unit
  String ingredientName = ''; // Default value for the ingredient name

  await CustomPopup.show(
    context: context,
    title: 'Cadastrar Ingrediente',
    showFooter: true,
    primaryButtonLabel: 'Sim',
    primaryButtonOnPressed: () async {
      if (ingredientName.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Por favor, insira um nome para o ingrediente.')),
        );
        return;
      }

      final newItem = Item(
        name: ingredientName,
        unit: unidadeValue,
        category: categoriaValue,
        description: '',
      );

      try {
        context
            .read<ItemBloc>()
            .add(AddItemEvent(newItem)); 
        Navigator.of(context, rootNavigator: true).pop(); 
      } catch (e) {
        print('Failed to create item: $e');
      }
    },
    secondaryButtonLabel: 'Não',
    secondaryButtonOnPressed: () async {
      Navigator.of(context, rootNavigator: true)
          .pop(); 
    },
    content: StatefulBuilder(
      builder: (context, setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                // Ingredient Name input
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 13),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.blue),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        ingredientName = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),

                // Category Dropdown
                Expanded(
                  child: DropdownButtonFormField<Category>(
                    value: categoriaValue,
                    isExpanded: true,
                    items: Category.values.map((category) {
                      return DropdownMenuItem<Category>(
                        value: category,
                        child: Text(category.toJson(),
                            style: TextStyle(fontSize: 14)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        categoriaValue = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Categoria',
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.blue),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Unit Dropdown
                Expanded(
                  child: DropdownButtonFormField<Unit>(
                    value: unidadeValue,
                    isExpanded: true,
                    items: Unit.values.map((unit) {
                      return DropdownMenuItem<Unit>(
                        value: unit,
                        child:
                            Text(unit.toJson(), style: TextStyle(fontSize: 14)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        unidadeValue = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Unidade',
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.blue),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    ),
  );
}

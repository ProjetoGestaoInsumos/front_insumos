import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_insumos/components/custom_popup.dart';
import 'package:front_insumos/models/enums.dart';
import 'package:front_insumos/models/item.dart';
import 'package:front_insumos/models/stock.dart';
import 'package:front_insumos/screens/auth/auth_bloc/auth_bloc.dart';
import 'package:front_insumos/screens/auth/auth_bloc/auth_state.dart';
import 'package:front_insumos/screens/stock/stock_bloc/stock_bloc.dart';
import 'package:front_insumos/screens/stock/stock_bloc/stock_event.dart';
import 'package:front_insumos/utils/colors.dart'; // Importando o modelo de Item

Future<void> showAddStockDialog(
    BuildContext context, List<Item> allItems) async {
  String dropdownValue =
      allItems.isNotEmpty ? allItems[0].name : 'Carregando...';
  String unidadeValue = '';
  double quantity = 0;
  DateTime selectedDate = DateTime.now();
  Unit? itemUnit = allItems.isNotEmpty ? allItems[0].unit : null;

  final authState = context.read<AuthBloc>().state;

  if (authState is AuthUnauthenticated) {
    // Se o usuário não estiver autenticado, exiba uma mensagem
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Você precisa estar autenticado para adicionar estoque.')),
    );
    return;
  }

  await CustomPopup.show(
    context: context,
    title: 'Adicionar Lote',
    showFooter: true,
    primaryButtonLabel: 'Sim',
    primaryButtonOnPressed: () async {
      if (quantity <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Por favor, insira uma quantidade válida.')),
        );
        return;
      }

      final item = allItems.firstWhere((item) => item.name == dropdownValue);
      final stock = Stock(
        itemId: item.id!, // id do item selecionado
        quantity: quantity, // quantidade selecionada
        expirationDate: selectedDate, // data de validade
      );

      context.read<StockBloc>().add(AddStockEvent(stock));

      Navigator.of(context, rootNavigator: true).pop();
    },
    secondaryButtonLabel: 'Não',
    secondaryButtonOnPressed: () async {
      Navigator.of(context, rootNavigator: true).pop();
    },
    content: StatefulBuilder(
      builder: (context, setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Exibir os itens carregados no Dropdown
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: dropdownValue,
                    isExpanded: true,
                    items: allItems.map((Item item) {
                      return DropdownMenuItem<String>(
                        value: item.name,
                        child: Text(item.name, style: TextStyle(fontSize: 14)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        dropdownValue = value!;
                        final item = allItems
                            .firstWhere((item) => item.name == dropdownValue);
                        itemUnit = item.unit;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Nome do item',
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
                Expanded(
                  child: TextFormField(
                    initialValue: unidadeValue,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: itemUnit != null
                          ? 'Qtd. (${itemUnit!.toJson()})'
                          : 'Qtd.',
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 13),
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
                      if (value.isNotEmpty) {
                        String formattedValue = value.replaceAll(',', '.');

                        if (double.tryParse(formattedValue) != null) {
                          setState(() {
                            unidadeValue = value;
                            quantity = double.parse(formattedValue);
                          });
                        }
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        setState(() {
                          selectedDate = date;
                        });
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Validade',
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 14),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: CustomColors.blue),
                        ),
                      ),
                      child: Text(
                          '${selectedDate.day.toString().padLeft(2, '0')}/'
                          '${selectedDate.month.toString().padLeft(2, '0')}/'
                          '${selectedDate.year}'),
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

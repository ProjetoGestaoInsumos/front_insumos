 import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_insumos/components/custom_popup.dart';
import 'package:front_insumos/models/stock.dart';
import 'package:front_insumos/screens/stock/stock_bloc/stock_bloc.dart';
import 'package:front_insumos/screens/stock/stock_bloc/stock_event.dart';
import 'package:intl/intl.dart';

Future<void> showEditDialog(BuildContext context, Stock stock) async {
    final quantityController =
        TextEditingController(text: stock.quantity.toString());
    final expirationController = TextEditingController(
      text: stock.expirationDate != null
          ? DateFormat('dd/MM/yyyy').format(stock.expirationDate!)
          : '',
    );

    CustomPopup.show(
      context: context,
      title: 'Editar Lote de Estoque',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Campo de Quantidade
          TextField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Quantidade',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),

          // Campo de Data de Validade
          TextField(
            controller: expirationController,
            decoration: InputDecoration(
              labelText: 'Data de Validade',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      showFooter: true, // Exibe a área de footer com os botões
      primaryButtonLabel: 'Salvar',
      primaryButtonOnPressed: () async {
        final updatedQuantity = double.tryParse(quantityController.text);
        DateTime? updatedExpirationDate;

      // Se o campo de data de validade não estiver vazio, converte para DateTime
      if (expirationController.text.isNotEmpty) {
        updatedExpirationDate = DateFormat('dd/MM/yyyy').parse(expirationController.text);
      }

        if (updatedQuantity != null) {
          final updatedStock = Stock(
            id: stock.id,
            itemId: stock.itemId,
            quantity: updatedQuantity,
            expirationDate: updatedExpirationDate,
            createdAt: stock.createdAt,
          );

          context.read<StockBloc>().add(UpdateStockEvent(updatedStock));
          Navigator.of(context, rootNavigator: true).pop();
        }
      },
      secondaryButtonLabel: 'Cancelar',
      secondaryButtonOnPressed: () async {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
  }
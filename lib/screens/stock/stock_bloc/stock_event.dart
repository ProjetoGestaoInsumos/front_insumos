import 'package:front_insumos/models/stock.dart';

abstract class StockEvent {}

class LoadStockEvent extends StockEvent {}

class AddStockEvent extends StockEvent {
  final Stock stock;
  AddStockEvent(this.stock);
}

class UpdateStockEvent extends StockEvent {
  final Stock stock;
  UpdateStockEvent(this.stock);
}

class DeleteStockEvent extends StockEvent {
  final int stockId;
  DeleteStockEvent(this.stockId);
}

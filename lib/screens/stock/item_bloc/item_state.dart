import 'package:front_insumos/models/item.dart';

abstract class ItemState {}

class ItemInitial extends ItemState {}

class ItemLoading extends ItemState {}

class ItemLoaded extends ItemState {
  final List<Item> items;
  ItemLoaded(this.items);
}

class ItemError extends ItemState {
  final String message;
  ItemError(this.message);
}

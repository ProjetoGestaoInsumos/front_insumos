import 'package:front_insumos/models/item.dart';

abstract class ItemEvent {}

class LoadItemEvent extends ItemEvent {}

class AddItemEvent extends ItemEvent {
  final Item item;
  AddItemEvent(this.item);
}

class DeleteItemEvent extends ItemEvent {
  final int itemId;
  DeleteItemEvent(this.itemId);
}

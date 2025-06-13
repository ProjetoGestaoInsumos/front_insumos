import 'package:front_insumos/models/pop.dart';

abstract class POPEvent {}

class LoadPOPs extends POPEvent {}

class SearchPOPs extends POPEvent {
  final String query;

  SearchPOPs(this.query);
}

class ChangePage extends POPEvent {
  final int page;

  ChangePage(this.page);
}

class CreatePOP extends POPEvent {
  final POP pop;
  CreatePOP(this.pop);
}
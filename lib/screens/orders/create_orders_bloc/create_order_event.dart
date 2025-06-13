import 'package:equatable/equatable.dart';
import '/models/pop_create.dart';

abstract class CreateOrderEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateOrder extends CreateOrderEvent {
  final POPCreate popData;

  CreateOrder(this.popData);

  @override
  List<Object?> get props => [popData];
}

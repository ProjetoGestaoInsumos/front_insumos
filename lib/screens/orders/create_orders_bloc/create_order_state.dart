import 'package:equatable/equatable.dart';
import '/models/pop_response.dart';

abstract class CreateOrderState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateOrderInitial extends CreateOrderState {}

class CreateOrderLoading extends CreateOrderState {}

class CreateOrderSuccess extends CreateOrderState {
  final POPResponse response;

  CreateOrderSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class CreateOrderError extends CreateOrderState {
  final String message;

  CreateOrderError(this.message);

  @override
  List<Object?> get props => [message];
}

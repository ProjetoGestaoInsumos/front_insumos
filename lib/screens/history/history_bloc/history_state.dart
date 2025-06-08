abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<Map<String, dynamic>> movements;
  HistoryLoaded(this.movements);
}

class HistoryError extends HistoryState {
  final String message;
  HistoryError(this.message);
}

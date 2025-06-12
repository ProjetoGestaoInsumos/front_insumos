class Stock {
  final int? id;
  final int itemId;
  final double quantity;
  final DateTime? expirationDate;
  final DateTime? createdAt;

  Stock({
    this.id,
    required this.itemId,
    required this.quantity,
    this.expirationDate,
    this.createdAt,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      id: json['id'],
      itemId: json['item_id'],
      quantity: (json['quantity'] as num).toDouble(),
      expirationDate: json['expiration_date'] != null
          ? DateTime.parse(json['expiration_date'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'item_id': itemId,
      'quantity': quantity,
      'expiration_date': expirationDate?.toIso8601String(),
    };
  }
}

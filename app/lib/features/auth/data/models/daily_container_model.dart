class DailyContainerModel {
  final DateTime? actionDate;
  final String? actionDay;
  final double? recvdQty;
  final double? shippedQty;

  const DailyContainerModel({
    this.actionDate,
    this.actionDay,
    this.recvdQty,
    this.shippedQty,
  });

  factory DailyContainerModel.fromJson(Map<String, dynamic> json) {
    double? parseDouble(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString());
    }

    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      if (value is DateTime) return value;
      if (value is String) return DateTime.tryParse(value);
      return null;
    }

    return DailyContainerModel(
      actionDate: parseDate(json['actionDate'] ?? json['ActionDate']),
      actionDay: (json['actionDay'] ?? json['ActionDay'])?.toString(),
      recvdQty: parseDouble(json['recvdQty'] ?? json['RecvdQty']),
      shippedQty: parseDouble(json['shippedQty'] ?? json['ShippedQty']),
    );
  }
}

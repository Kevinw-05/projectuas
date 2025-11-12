import 'service.dart';

class CartItemModel {
  final String id;
  final Service service;
  final List<ServiceOption> selectedOptions;
  final int quantity;

  CartItemModel({
    required this.id,
    required this.service,
    this.selectedOptions = const [],
    this.quantity = 1,
  });

  double get totalPrice {
    final opts = selectedOptions.fold<double>(0.0, (p, e) => p + e.price);
    return (service.basePrice + opts) * quantity;
  }
}

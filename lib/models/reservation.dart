import 'cart_item.dart';

class Reservation {
  final String id;
  final CartItemModel cartItem;
  final DateTime date;
  final String timeslot;
  final String customerName;
  final String contact;

  Reservation({
    required this.id,
    required this.cartItem,
    required this.date,
    required this.timeslot,
    required this.customerName,
    required this.contact,
  });

  double get totalPrice => cartItem.totalPrice;

  String get formattedDate =>
      "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
}

class Service {
  final String id;
  final String title;
  final String description;
  final double basePrice;
  final List<ServiceOption> options;
  final String? imagePath;
  final int? durationMinutes;

  Service({
    required this.id,
    required this.title,
    required this.description,
    required this.basePrice,
    this.options = const [],
    this.imagePath,
    this.durationMinutes,
  });
}

class ServiceOption {
  final String id;
  final String name;
  final double price;

  ServiceOption({
    required this.id,
    required this.name,
    required this.price,
  });
}

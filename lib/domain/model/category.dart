import 'package:equatable/equatable.dart';
import 'package:sms/domain/model/service_provider.dart';

class Category extends Equatable {
  final String id;
  final String nameEn;
  final String nameAr;
  final String? icon;
  final String? color;
  final List<ServiceProvider> providers;

  const Category({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    this.icon,
    this.color,
    required this.providers,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      nameEn: json['name_en'] as String,
      nameAr: json['name_ar'] as String,
      icon: json['icon'] as String?,
      color: json['color'] as String?,
      providers:
          (json['providers'] as List)
              .map((p) => ServiceProvider.fromJson(p as Map<String, dynamic>))
              .toList(),
    );
  }

  @override
  List<Object?> get props => [id, nameEn, nameAr, icon, color, providers];
}

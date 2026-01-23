import 'package:equatable/equatable.dart';
import 'package:sms/domain/model/action_item.dart';

class ServiceProvider extends Equatable {
  final String id;
  final String nameEn;
  final String nameAr;
  final String? descriptionEn;
  final String? descriptionAr;
  final List<ActionItem> actions;

  const ServiceProvider({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    this.descriptionEn,
    this.descriptionAr,
    required this.actions,
  });

  factory ServiceProvider.fromJson(Map<String, dynamic> json) {
    return ServiceProvider(
      id: json['id'] as String,
      nameEn: json['name_en'] as String,
      nameAr: json['name_ar'] as String,
      descriptionEn: json['description_en'] as String?,
      descriptionAr: json['description_ar'] as String?,
      actions:
          (json['actions'] as List)
              .map((a) => ActionItem.fromJson(a as Map<String, dynamic>))
              .toList(),
    );
  }

  @override
  List<Object?> get props => [id, nameEn, nameAr, descriptionEn, descriptionAr, actions];
}

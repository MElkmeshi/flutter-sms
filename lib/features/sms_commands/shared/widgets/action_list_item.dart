import 'package:flutter/material.dart';
import 'package:sms/domain/model/action_item.dart';

class ActionListItem extends StatelessWidget {
  final ActionItem action;
  final VoidCallback onTap;

  const ActionListItem({super.key, required this.action, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final name = isArabic ? action.nameAr : action.nameEn;

    return ListTile(
      title: Text(name),
      subtitle: Text('SMS to: ${action.smsNumber}'),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}

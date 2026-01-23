import 'package:flutter/material.dart';

class IconMapper {
  static const Map<String, IconData> _iconMap = {
    'account_balance': Icons.account_balance,
    'business': Icons.business,
    'phone_android': Icons.phone_android,
    'phone': Icons.phone,
    'power': Icons.power,
    'water_drop': Icons.water_drop,
    'directions_car': Icons.directions_car,
    'local_hospital': Icons.local_hospital,
    'school': Icons.school,
    'shopping_cart': Icons.shopping_cart,
    'movie': Icons.movie,
    'category': Icons.category,
    'sms': Icons.sms,
    'arrow_forward_ios': Icons.arrow_forward_ios,
    'info_outline': Icons.info_outline,
    'edit': Icons.edit,
    'lock': Icons.lock,
    'attach_money': Icons.attach_money,
    'home': Icons.home,
    'work': Icons.work,
    'email': Icons.email,
    'settings': Icons.settings,
    'star': Icons.star,
    'favorite': Icons.favorite,
    'language': Icons.language,
    'wifi': Icons.wifi,
    'cell_tower': Icons.cell_tower,
    'sim_card': Icons.sim_card,
    'router': Icons.router,
    'credit_card': Icons.credit_card,
    'payment': Icons.payment,
    'receipt': Icons.receipt,
    'description': Icons.description,
    'folder': Icons.folder,
    'cloud': Icons.cloud,
    'security': Icons.security,
    'person': Icons.person,
    'group': Icons.group,
    'notifications': Icons.notifications,
    'help': Icons.help,
    'search': Icons.search,
    'refresh': Icons.refresh,
    'delete': Icons.delete,
    'add': Icons.add,
    'remove': Icons.remove,
    'check': Icons.check,
    'close': Icons.close,
    'warning': Icons.warning,
    'error': Icons.error,
    'local_atm': Icons.local_atm,
    'account_balance_wallet': Icons.account_balance_wallet,
    'savings': Icons.savings,
    'currency_exchange': Icons.currency_exchange,
    'public': Icons.public,
    'gavel': Icons.gavel,
    'policy': Icons.policy,
    'apartment': Icons.apartment,
  };

  static IconData fromString(String? iconName, {IconData fallback = Icons.category}) {
    if (iconName == null || iconName.isEmpty) return fallback;
    return _iconMap[iconName] ?? fallback;
  }

  static Color colorFromHex(String? hex, {Color fallback = Colors.grey}) {
    if (hex == null || hex.isEmpty) return fallback;
    final hexCode = hex.replaceFirst('#', '');
    if (hexCode.length == 6) {
      return Color(int.parse('FF$hexCode', radix: 16));
    } else if (hexCode.length == 8) {
      return Color(int.parse(hexCode, radix: 16));
    }
    return fallback;
  }
}

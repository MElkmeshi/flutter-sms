import 'package:flutter/material.dart';
import 'package:sms/l10n/app_localizations.dart';
import 'package:sms/domain/model/service_provider.dart';

class ProviderListItem extends StatefulWidget {
  final ServiceProvider provider;
  final VoidCallback onTap;

  const ProviderListItem({
    super.key,
    required this.provider,
    required this.onTap,
  });

  @override
  State<ProviderListItem> createState() => _ProviderListItemState();
}

class _ProviderListItemState extends State<ProviderListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  IconData _getProviderIcon(String providerId) {
    // Make icons more dynamic based on provider ID and name
    final id = providerId.toLowerCase();
    final name = providerId.toLowerCase();

    // Check for specific provider types
    if (id.contains('bank') || name.contains('bank')) {
      return Icons.account_balance;
    } else if (id.contains('telecom') ||
        id.contains('ltt') ||
        name.contains('phone') ||
        name.contains('mobile')) {
      return Icons.phone_android;
    } else if (id.contains('gov') ||
        id.contains('government') ||
        name.contains('public')) {
      return Icons.business;
    } else if (id.contains('electric') ||
        id.contains('power') ||
        name.contains('utility')) {
      return Icons.power;
    } else if (id.contains('water') || name.contains('water')) {
      return Icons.water_drop;
    } else if (id.contains('transport') ||
        id.contains('bus') ||
        name.contains('car')) {
      return Icons.directions_car;
    } else if (id.contains('health') ||
        id.contains('medical') ||
        name.contains('hospital')) {
      return Icons.local_hospital;
    } else if (id.contains('school') ||
        id.contains('education') ||
        name.contains('university')) {
      return Icons.school;
    } else if (id.contains('shop') ||
        id.contains('retail') ||
        name.contains('store')) {
      return Icons.shopping_cart;
    } else if (id.contains('movie') ||
        id.contains('entertainment') ||
        name.contains('media')) {
      return Icons.movie;
    } else {
      return Icons.business;
    }
  }

  Color _getProviderColor(String providerId) {
    // Make colors more dynamic based on provider ID and name
    final id = providerId.toLowerCase();
    final name = providerId.toLowerCase();

    if (id.contains('bank') || name.contains('bank')) {
      return Colors.green.shade600;
    } else if (id.contains('telecom') ||
        id.contains('ltt') ||
        name.contains('phone') ||
        name.contains('mobile')) {
      return Colors.orange.shade600;
    } else if (id.contains('gov') ||
        id.contains('government') ||
        name.contains('public')) {
      return Colors.blue.shade600;
    } else if (id.contains('electric') ||
        id.contains('power') ||
        name.contains('utility')) {
      return Colors.yellow.shade700;
    } else if (id.contains('water') || name.contains('water')) {
      return Colors.cyan.shade600;
    } else if (id.contains('transport') ||
        id.contains('bus') ||
        name.contains('car')) {
      return Colors.purple.shade600;
    } else if (id.contains('health') ||
        id.contains('medical') ||
        name.contains('hospital')) {
      return Colors.red.shade600;
    } else if (id.contains('school') ||
        id.contains('education') ||
        name.contains('university')) {
      return Colors.indigo.shade600;
    } else if (id.contains('shop') ||
        id.contains('retail') ||
        name.contains('store')) {
      return Colors.pink.shade600;
    } else if (id.contains('movie') ||
        id.contains('entertainment') ||
        name.contains('media')) {
      return Colors.deepPurple.shade600;
    } else {
      return Colors.grey.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final name = isArabic ? widget.provider.nameAr : widget.provider.nameEn;
    final description =
        isArabic
            ? widget.provider.descriptionAr
            : widget.provider.descriptionEn;
    final icon = _getProviderIcon(widget.provider.id);
    final color = _getProviderColor(widget.provider.id);

    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _animationController.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _animationController.reverse();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _animationController.reverse();
      },
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Card(
              elevation: _isPressed ? 8 : 4,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [color.withAlpha(26), color.withAlpha(13)],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: color.withAlpha(51),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icon, color: color, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: Theme.of(
                                context,
                              ).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            if (description != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: Colors.grey.shade600),
                              ),
                            ],
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: color.withAlpha(26),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${widget.provider.actions.length} ${l10n.actions}',
                                style: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.copyWith(
                                  color: color,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, color: color, size: 20),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sms/l10n/app_localizations.dart';
import 'package:sms/domain/model/category.dart';

class CategoryListItem extends StatefulWidget {
  final Category category;
  final VoidCallback onTap;

  const CategoryListItem({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  State<CategoryListItem> createState() => _CategoryListItemState();
}

class _CategoryListItemState extends State<CategoryListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _elevationAnimation = Tween<double>(begin: 4.0, end: 8.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  IconData _getCategoryIcon(String categoryId) {
    // Make icons more dynamic based on category ID
    switch (categoryId.toLowerCase()) {
      case 'banking':
      case 'banks':
      case 'bank':
        return Icons.account_balance;
      case 'government':
      case 'gov':
      case 'public':
        return Icons.business;
      case 'telecom':
      case 'telecommunications':
      case 'mobile':
      case 'phone':
        return Icons.phone_android;
      case 'utilities':
      case 'electricity':
      case 'water':
        return Icons.power;
      case 'transport':
      case 'transportation':
        return Icons.directions_car;
      case 'health':
      case 'medical':
        return Icons.local_hospital;
      case 'education':
      case 'school':
        return Icons.school;
      case 'shopping':
      case 'retail':
        return Icons.shopping_cart;
      case 'entertainment':
      case 'media':
        return Icons.movie;
      default:
        // Try to extract icon from category name
        final name = categoryId.toLowerCase();
        if (name.contains('bank')) {
          return Icons.account_balance;
        }
        if (name.contains('gov') || name.contains('public')) {
          return Icons.business;
        }
        if (name.contains('phone') ||
            name.contains('mobile') ||
            name.contains('telecom')) {
          return Icons.phone_android;
        }
        if (name.contains('power') || name.contains('electric')) {
          return Icons.power;
        }
        if (name.contains('car') || name.contains('transport')) {
          return Icons.directions_car;
        }
        if (name.contains('health') || name.contains('medical')) {
          return Icons.local_hospital;
        }
        if (name.contains('school') || name.contains('education')) {
          return Icons.school;
        }
        if (name.contains('shop') || name.contains('retail')) {
          return Icons.shopping_cart;
        }
        if (name.contains('movie') || name.contains('entertainment')) {
          return Icons.movie;
        }
        return Icons.category;
    }
  }

  Color _getCategoryColor(String categoryId) {
    // Make colors more dynamic based on category ID
    switch (categoryId.toLowerCase()) {
      case 'banking':
      case 'banks':
      case 'bank':
        return Colors.green.shade600;
      case 'government':
      case 'gov':
      case 'public':
        return Colors.blue.shade600;
      case 'telecom':
      case 'telecommunications':
      case 'mobile':
      case 'phone':
        return Colors.orange.shade600;
      case 'utilities':
      case 'electricity':
      case 'water':
        return Colors.yellow.shade700;
      case 'transport':
      case 'transportation':
        return Colors.purple.shade600;
      case 'health':
      case 'medical':
        return Colors.red.shade600;
      case 'education':
      case 'school':
        return Colors.indigo.shade600;
      case 'shopping':
      case 'retail':
        return Colors.pink.shade600;
      case 'entertainment':
      case 'media':
        return Colors.deepPurple.shade600;
      default:
        // Try to extract color from category name
        final name = categoryId.toLowerCase();
        if (name.contains('bank')) {
          return Colors.green.shade600;
        }
        if (name.contains('gov') || name.contains('public')) {
          return Colors.blue.shade600;
        }
        if (name.contains('phone') ||
            name.contains('mobile') ||
            name.contains('telecom')) {
          return Colors.orange.shade600;
        }
        if (name.contains('power') || name.contains('electric')) {
          return Colors.yellow.shade700;
        }
        if (name.contains('car') || name.contains('transport')) {
          return Colors.purple.shade600;
        }
        if (name.contains('health') || name.contains('medical')) {
          return Colors.red.shade600;
        }
        if (name.contains('school') || name.contains('education')) {
          return Colors.indigo.shade600;
        }
        if (name.contains('shop') || name.contains('retail')) {
          return Colors.pink.shade600;
        }
        if (name.contains('movie') || name.contains('entertainment')) {
          return Colors.deepPurple.shade600;
        }
        return Colors.grey.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final name = isArabic ? widget.category.nameAr : widget.category.nameEn;
    final icon = _getCategoryIcon(widget.category.id);
    final color = _getCategoryColor(widget.category.id);

    return GestureDetector(
      onTapDown: (_) {
        _animationController.forward();
      },
      onTapUp: (_) {
        _animationController.reverse();
      },
      onTapCancel: () {
        _animationController.reverse();
      },
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Card(
                elevation: _elevationAnimation.value,
                shadowColor: color.withAlpha(77),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
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
                        // Icon Container
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: color.withAlpha(51),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: color.withAlpha(51),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(icon, color: color, size: 28),
                        ),
                        const SizedBox(width: 16),

                        // Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Category Name
                              Text(
                                name,
                                style: GoogleFonts.ibmPlexSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),

                              // Provider Count Badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: color.withAlpha(26),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: color.withAlpha(77),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  '${widget.category.providers.length} ${l10n.providers}',
                                  style: GoogleFonts.ibmPlexSans(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: color,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Arrow Icon
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: color.withAlpha(26),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: color,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
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

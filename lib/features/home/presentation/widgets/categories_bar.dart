import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class CategoryItem {
  final String label;
  final IconData icon;
  final Color color;

  const CategoryItem({
    required this.label,
    required this.icon,
    required this.color,
  });
}

class CategoriesBar extends StatelessWidget {
  final Function(CategoryItem) onCategorySelected;
  final String selectedLabel;

  const CategoriesBar({
    super.key,
    required this.onCategorySelected,
    this.selectedLabel = 'All',
  });

  static const _categories = [
    CategoryItem(label: 'All', icon: Icons.apps, color: AppColors.primary),
    CategoryItem(label: 'Sports', icon: Icons.sports_basketball, color: Color(0xFFF0635A)),
    CategoryItem(label: 'Music', icon: Icons.music_note, color: Color(0xFFF19E38)),
    CategoryItem(label: 'Food', icon: Icons.fastfood, color: Color(0xFF29D697)),
    CategoryItem(label: 'Art', icon: Icons.palette, color: Color(0xFF46CDFB)),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final item = _categories[index];
          final isSelected = item.label == selectedLabel;

          return GestureDetector(
            onTap: () => onCategorySelected(item),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? item.color : item.color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(
                    item.icon,
                    size: 18,
                    color: isSelected ? Colors.white : item.color,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item.label,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

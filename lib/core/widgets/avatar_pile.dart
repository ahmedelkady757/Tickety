import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AvatarPile extends StatelessWidget {
  final int count;
  final double size;
  
  const AvatarPile({
    super.key,
    this.count = 3,
    this.size = 32.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (size * 0.6) * count + (size * 0.4),
      height: size,
      child: Stack(
        children: List.generate(count, (index) {
          return Positioned(
            left: index * (size * 0.6),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                color: AppColors.primaryLight,
              ),
              child: Icon(Icons.person, size: size * 0.5, color: Colors.white),
            ),
          );
        }),
      ),
    );
  }
}

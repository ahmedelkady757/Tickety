import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

enum AppButtonType { primary, outlined, text, social }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final bool isLoading;
  final bool isFullWidth;
  final String? iconPath; // For social icons (SVG)
  final bool hasArrow; // EventHub signature trailing arrow

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = AppButtonType.primary,
    this.isLoading = false,
    this.isFullWidth = true,
    this.iconPath,
    this.hasArrow = false,
  });

  factory AppButton.primary({
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
    bool isFullWidth = true,
    bool hasArrow = false,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      type: AppButtonType.primary,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      hasArrow: hasArrow,
    );
  }

  factory AppButton.outlined({
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
    bool isFullWidth = true,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      type: AppButtonType.outlined,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
    );
  }

  factory AppButton.text({
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      type: AppButtonType.text,
      isLoading: isLoading,
      isFullWidth: false,
    );
  }

  factory AppButton.social({
    required String text,
    required String iconPath,
    required VoidCallback? onPressed,
    bool isLoading = false,
    bool isFullWidth = true,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      type: AppButtonType.social,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      iconPath: iconPath,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget buttonChild = isLoading
        ? const SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (iconPath != null) ...[
                SvgPicture.asset(iconPath!, height: 24, width: 24),
                const SizedBox(width: 12),
              ],
              Flexible(
                child: Text(
                  text,
                  style: _getTextStyle(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              if (hasArrow && !isLoading) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_forward, size: 18, color: Colors.white),
                ),
              ],
            ],
          );

    Widget button;

    switch (type) {
      case AppButtonType.primary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
            elevation: 4,
            shadowColor: AppColors.primary.withValues(alpha: 0.3),
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          ),
          child: buttonChild,
        );
        break;
      case AppButtonType.outlined:
      case AppButtonType.social:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textPrimary,
            side: const BorderSide(color: AppColors.border, width: 1.5),
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: type == AppButtonType.social
                ? const EdgeInsets.symmetric(vertical: 16, horizontal: 12)
                : const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          ),
          child: buttonChild,
        );
        break;
      case AppButtonType.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          ),
          child: buttonChild,
        );
        break;
    }

    if (isFullWidth) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    return button;
  }

  TextStyle _getTextStyle() {
    switch (type) {
      case AppButtonType.primary:
        return AppTextStyles.button;
      case AppButtonType.outlined:
      case AppButtonType.social:
        return AppTextStyles.button.copyWith(color: AppColors.textPrimary);
      case AppButtonType.text:
        return AppTextStyles.button.copyWith(color: AppColors.primary);
    }
  }
}

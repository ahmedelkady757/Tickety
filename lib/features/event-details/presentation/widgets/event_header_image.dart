import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import 'going_bar.dart';

class EventHeaderImage extends StatelessWidget {
  final String? imagePath;
  final String? imageUrl;
  final int goingCount;
  final VoidCallback? onBackTap;
  final VoidCallback? onBookmarkTap;
  final VoidCallback? onInviteTap;
  final bool isFavorite;

  const EventHeaderImage({
    super.key,
    this.imagePath,
    this.imageUrl,
    this.goingCount = 20,
    this.onBackTap,
    this.onBookmarkTap,
    this.onInviteTap,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _buildHeroImage(context),

        // Back & bookmark buttons
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _CircularIconButton(
                  icon: Icons.arrow_back,
                  onTap: onBackTap ?? () {
                    if (context.canPop()) context.pop();
                  },
                ),
                _CircularIconButton(
                  icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                  onTap: onBookmarkTap ?? () {},
                ),
              ],
            ),
          ),
        ),

        // Going bar overlapping the bottom edge
        Positioned(
          bottom: -25,
          left: 32,
          right: 32,
          child: GoingBar(
            goingCount: goingCount,
            onInviteTap: onInviteTap,
          ),
        ),
      ],
    );
  }

  Widget _buildHeroImage(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        width: double.infinity,
        height: 240,
        fit: BoxFit.cover,
        placeholder: (_, __) => _placeholder(context, Object(), null),
        errorWidget: (_, __, ___) => _placeholder(context, Object(), null),
      );
    }
    if (imagePath != null) {
      return Image.asset(
        imagePath!,
        width: double.infinity,
        height: 240,
        fit: BoxFit.cover,
        errorBuilder: _placeholder,
      );
    }
    return _placeholder(context, Object(), StackTrace.current);
  }

  Widget _placeholder(BuildContext context, Object error, StackTrace? stackTrace) {
    return Container(
      width: double.infinity,
      height: 240,
      color: AppColors.primaryLight,
      child: const Icon(Icons.music_note, size: 80, color: Colors.white),
    );
  }
}

class _CircularIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircularIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}
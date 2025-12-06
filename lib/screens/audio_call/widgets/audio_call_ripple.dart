import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:the_friendz_zone/config/app_config.dart';
import 'package:the_friendz_zone/utils/app_dimen.dart';

class CallAvatarRipple extends StatefulWidget {
  final String imageUrl;
  final bool showRipple;

  const CallAvatarRipple({
    required this.imageUrl,
    required this.showRipple,
    Key? key,
  }) : super(key: key);

  @override
  State<CallAvatarRipple> createState() => _CallAvatarRippleState();
}

class _CallAvatarRippleState extends State<CallAvatarRipple>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _animation = Tween<double>(begin: 1.0, end: 1.6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildAvatar(double radius) {
    final isNetwork = widget.imageUrl.startsWith('http');
    if (isNetwork) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius / 2),
        child: CachedNetworkImage(
          imageUrl: widget.imageUrl,
          fit: BoxFit.cover,
          width: radius,
          height: radius,
          fadeInDuration: const Duration(milliseconds: 400),
          placeholder: (context, url) => Container(
            color: AppColors.greyShadeColor,
            width: radius,
            height: radius,
          ),
          errorWidget: (context, url, error) => Container(
            color: AppColors.greyShadeColor,
            width: radius,
            height: radius,
            child: Icon(
              Icons.person,
              color: AppColors.greyColor,
              size: radius * 0.5,
            ),
          ),
        ),
      );
    } else {
      return CircleAvatar(
        backgroundImage: AssetImage(widget.imageUrl),
        radius: radius / 2,
        backgroundColor: AppColors.greyShadeColor,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double radius = AppDimens.dimen200;
    return Center(
      child: widget.showRipple
          ? AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Outer ripple
              Container(
                width: radius * _animation.value,
                height: radius * _animation.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor.withOpacity(
                    0.15 * (2 - _animation.value),
                  ),
                ),
              ),
              // Middle circle
              Container(
                width: radius * 1.3,
                height: radius * 1.3,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor.withOpacity(0.10),
                ),
              ),
              // Avatar with shadow
              Container(
                width: radius,
                height: radius,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.2),
                      blurRadius: 16,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: _buildAvatar(radius),
              ),
            ],
          );
        },
      )
          : Container(
        width: radius,
        height: radius,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.2),
              blurRadius: 16,
              spreadRadius: 4,
            ),
          ],
        ),
        child: _buildAvatar(radius),
      ),
    );
  }
}
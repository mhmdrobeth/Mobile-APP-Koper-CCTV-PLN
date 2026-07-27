import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomHeader extends StatelessWidget {
  const CustomHeader({super.key});

  final String _danantaraLogoUrl = 'https://i.postimg.cc/3x7HCSMZ/Danantara-Indonesia.png';
  final String _plnLogoUrl = 'https://i.postimg.cc/yNdtv2L4/PLN-Logo.png';
  final Color primaryBlue = const Color(0xFF003D7A);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CachedNetworkImage(
          imageUrl: _danantaraLogoUrl,
          height: 32,
          width: 130,
          fit: BoxFit.contain,
          alignment: Alignment.centerLeft,
          placeholder: (context, url) => const SizedBox(height: 32, width: 100),
          errorWidget: (context, url, error) => const Icon(Icons.business, size: 32),
        ),
        const Spacer(),
        CachedNetworkImage(
          imageUrl: _plnLogoUrl,
          height: 28,
          width: 70,
          fit: BoxFit.contain,
          alignment: Alignment.centerRight,
          placeholder: (context, url) => const SizedBox(height: 28, width: 60),
          errorWidget: (context, url, error) => const Icon(Icons.bolt, size: 28, color: Colors.yellow),
        ),
        const SizedBox(width: 12),
        Icon(Icons.notifications_none_outlined, color: primaryBlue, size: 28),
      ],
    );
  }
}
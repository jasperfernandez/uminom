import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final String iconPath;
  final bool isLoading;

  const SocialLoginButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.iconPath,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFFFFFFFF), Color(0xFFF3F8FC)],
        ),
        border: Border.all(color: const Color(0xFFE1ECF4)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1C5D99).withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: isLoading ? null : onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF2F7FD4),
                      ),
                    ),
                  )
                else
                  Image.asset(iconPath, width: 22, height: 22),
                const SizedBox(width: 14),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1C4670),
                    letterSpacing: 0.2,
                    fontFamily: 'PT Sans',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

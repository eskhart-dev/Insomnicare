import 'package:flutter/material.dart';

/// Custom button widget with consistent styling
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? width;
  final double height;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.width,
    this.height = 48,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = isOutlined
        ? OutlinedButton.styleFrom(
            minimumSize: Size(width ?? double.infinity, height),
            foregroundColor: foregroundColor ?? Theme.of(context).colorScheme.primary,
            side: BorderSide(
              color: backgroundColor ?? Theme.of(context).colorScheme.primary,
            ),
          )
        : ElevatedButton.styleFrom(
            minimumSize: Size(width ?? double.infinity, height),
            backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.primary,
            foregroundColor: foregroundColor ?? Colors.white,
          );

    final buttonChild = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                foregroundColor ??
                    (isOutlined
                        ? Theme.of(context).colorScheme.primary
                        : Colors.white),
              ),
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: 8),
              ],
              Text(text),
            ],
          );

    return SizedBox(
      width: width,
      child: isOutlined
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: buttonStyle,
              child: buttonChild,
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: buttonStyle,
              child: buttonChild,
            ),
    );
  }
}

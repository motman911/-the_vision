import 'package:flutter/material.dart';

// دالة لتحديد حجم الشاشة
enum ScreenSize { small, medium, large }

ScreenSize getScreenSize(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width < 600) return ScreenSize.small;
  if (width < 1200) return ScreenSize.medium;
  return ScreenSize.large;
}

// ويدجت متجاوب للنصوص
class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextStyle? smallStyle;
  final TextStyle? mediumStyle;
  final TextStyle? largeStyle;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const ResponsiveText({
    super.key,
    required this.text,
    this.style,
    this.smallStyle,
    this.mediumStyle,
    this.largeStyle,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = getScreenSize(context);

    TextStyle? selectedStyle;

    switch (screenSize) {
      case ScreenSize.small:
        selectedStyle = smallStyle;
        break;
      case ScreenSize.medium:
        selectedStyle = mediumStyle;
        break;
      case ScreenSize.large:
        selectedStyle = largeStyle;
        break;
    }

    return Text(
      text,
      style: (selectedStyle ?? style)?.copyWith(
        fontSize: _getResponsiveFontSize(
            context, selectedStyle?.fontSize ?? style?.fontSize ?? 14),
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  double _getResponsiveFontSize(BuildContext context, double baseSize) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.small:
        return baseSize * 0.9;
      case ScreenSize.medium:
        return baseSize;
      case ScreenSize.large:
        return baseSize * 1.1;
    }
  }
}

// زر متجاوب - تم التعديل هنا: onPressed أصبح nullable
class ResponsiveButton extends StatelessWidget {
  final VoidCallback? onPressed; // ✅ أصبح nullable
  final String text;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final bool isLoading; // إضافة حالة التحميل

  const ResponsiveButton({
    super.key,
    this.onPressed, // ✅ ليس required لأنها nullable
    required this.text,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = getScreenSize(context);

    double buttonHeight;
    double buttonWidth;
    double fontSize;
    EdgeInsets padding;

    switch (screenSize) {
      case ScreenSize.small:
        buttonHeight = height ?? 45;
        buttonWidth = width ?? double.infinity;
        fontSize = 14;
        padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10);
        break;
      case ScreenSize.medium:
        buttonHeight = height ?? 50;
        buttonWidth = width ?? double.infinity;
        fontSize = 15;
        padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12);
        break;
      case ScreenSize.large:
        buttonHeight = height ?? 55;
        buttonWidth = width ?? double.infinity;
        fontSize = 16;
        padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 14);
        break;
    }

    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed, // ✅ يعمل مع null
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          padding: padding,
          textStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: fontSize * 1.5,
                height: fontSize * 1.5,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: textColor,
                ),
              )
            : (icon != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, size: fontSize * 1.2),
                      const SizedBox(width: 8),
                      Text(text),
                    ],
                  )
                : Text(text)),
      ),
    );
  }
}

// كارد متجاوب
class ResponsiveCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;
  final double? elevation;
  final BorderRadius? borderRadius;

  const ResponsiveCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.elevation,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = getScreenSize(context);

    EdgeInsets cardPadding;
    double cardElevation;

    switch (screenSize) {
      case ScreenSize.small:
        cardPadding = padding ?? const EdgeInsets.all(12);
        cardElevation = elevation ?? 2;
        break;
      case ScreenSize.medium:
        cardPadding = padding ?? const EdgeInsets.all(16);
        cardElevation = elevation ?? 4;
        break;
      case ScreenSize.large:
        cardPadding = padding ?? const EdgeInsets.all(20);
        cardElevation = elevation ?? 6;
        break;
    }

    return Container(
      margin: margin,
      child: Card(
        elevation: cardElevation,
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(16),
        ),
        child: Padding(
          padding: cardPadding,
          child: child,
        ),
      ),
    );
  }
}

// Grid متجاوب
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double childAspectRatio;
  final double crossAxisSpacing;
  final double mainAxisSpacing;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.childAspectRatio = 0.9,
    this.crossAxisSpacing = 10,
    this.mainAxisSpacing = 10,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = getScreenSize(context);

    int crossAxisCount;

    switch (screenSize) {
      case ScreenSize.small:
        crossAxisCount = 1;
        break;
      case ScreenSize.medium:
        crossAxisCount = 2;
        break;
      case ScreenSize.large:
        crossAxisCount = 3;
        break;
    }

    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: childAspectRatio,
      crossAxisSpacing: crossAxisSpacing,
      mainAxisSpacing: mainAxisSpacing,
      children: children,
    );
  }
}

// دالة مساعدة للـ opacity بدون deprecated method
Color colorWithOpacity(Color color, double opacity) {
  return Color.fromRGBO(
    color.red,
    color.green,
    color.blue,
    opacity.clamp(0.0, 1.0),
  );
}

// إضافة ويدجت AppBar متجاوب
class ResponsiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;

  const ResponsiveAppBar({
    super.key,
    required this.title,
    this.actions,
    this.centerTitle = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 4,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = getScreenSize(context);

    double titleFontSize;
    double toolbarHeight;

    switch (screenSize) {
      case ScreenSize.small:
        titleFontSize = 18;
        toolbarHeight = 56;
        break;
      case ScreenSize.medium:
        titleFontSize = 20;
        toolbarHeight = 64;
        break;
      case ScreenSize.large:
        titleFontSize = 22;
        toolbarHeight = 72;
        break;
    }

    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontSize: titleFontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: actions,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation,
      toolbarHeight: toolbarHeight,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// إضافة ويدجت للـ TextField متجاوب
class ResponsiveTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final TextInputType keyboardType;
  final int? maxLines;
  final int? maxLength;
  final bool enabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;

  const ResponsiveTextField({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.errorText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = getScreenSize(context);

    EdgeInsets padding;
    double borderRadius;

    switch (screenSize) {
      case ScreenSize.small:
        padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 10);
        borderRadius = 8;
        break;
      case ScreenSize.medium:
        padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
        borderRadius = 12;
        break;
      case ScreenSize.large:
        padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 14);
        borderRadius = 16;
        break;
    }

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        errorText: errorText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: padding,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLines: maxLines,
      maxLength: maxLength,
      enabled: enabled,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
    );
  }
}

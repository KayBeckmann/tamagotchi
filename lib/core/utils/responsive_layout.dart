import 'package:flutter/material.dart';

/// Breakpoints for responsive design.
class Breakpoints {
  /// Mobile: < 600px
  static const double mobile = 600;

  /// Tablet: 600px - 900px
  static const double tablet = 900;

  /// Desktop: 900px - 1200px
  static const double desktop = 1200;

  /// Large Desktop: > 1200px
  static const double largeDesktop = 1200;

  Breakpoints._();
}

/// Device type based on screen width.
enum DeviceType {
  mobile,
  tablet,
  desktop,
  largeDesktop,
}

/// Extension to get device type from screen width.
extension DeviceTypeExtension on double {
  DeviceType get deviceType {
    if (this < Breakpoints.mobile) return DeviceType.mobile;
    if (this < Breakpoints.tablet) return DeviceType.tablet;
    if (this < Breakpoints.desktop) return DeviceType.desktop;
    return DeviceType.largeDesktop;
  }
}

/// Responsive layout builder widget.
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? largeDesktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.largeDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final deviceType = width.deviceType;

    return switch (deviceType) {
      DeviceType.mobile => mobile,
      DeviceType.tablet => tablet ?? mobile,
      DeviceType.desktop => desktop ?? tablet ?? mobile,
      DeviceType.largeDesktop => largeDesktop ?? desktop ?? tablet ?? mobile,
    };
  }

  /// Build with a callback that receives device type.
  static Widget builder({
    required Widget Function(BuildContext context, DeviceType deviceType) builder,
  }) {
    return Builder(
      builder: (context) {
        final width = MediaQuery.sizeOf(context).width;
        return builder(context, width.deviceType);
      },
    );
  }
}

/// Responsive value helper.
class ResponsiveValue<T> {
  final T mobile;
  final T? tablet;
  final T? desktop;
  final T? largeDesktop;

  const ResponsiveValue({
    required this.mobile,
    this.tablet,
    this.desktop,
    this.largeDesktop,
  });

  T get(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final deviceType = width.deviceType;

    return switch (deviceType) {
      DeviceType.mobile => mobile,
      DeviceType.tablet => tablet ?? mobile,
      DeviceType.desktop => desktop ?? tablet ?? mobile,
      DeviceType.largeDesktop => largeDesktop ?? desktop ?? tablet ?? mobile,
    };
  }
}

/// Extension for responsive padding.
extension ResponsivePadding on BuildContext {
  /// Get responsive horizontal padding.
  double get horizontalPadding {
    final width = MediaQuery.sizeOf(this).width;
    final deviceType = width.deviceType;

    return switch (deviceType) {
      DeviceType.mobile => 16,
      DeviceType.tablet => 24,
      DeviceType.desktop => 32,
      DeviceType.largeDesktop => 48,
    };
  }

  /// Get responsive content max width.
  double get contentMaxWidth {
    final width = MediaQuery.sizeOf(this).width;
    final deviceType = width.deviceType;

    return switch (deviceType) {
      DeviceType.mobile => double.infinity,
      DeviceType.tablet => 700,
      DeviceType.desktop => 900,
      DeviceType.largeDesktop => 1100,
    };
  }

  /// Check if we should use mobile layout.
  bool get isMobile => MediaQuery.sizeOf(this).width < Breakpoints.mobile;

  /// Check if we should use tablet layout.
  bool get isTablet {
    final width = MediaQuery.sizeOf(this).width;
    return width >= Breakpoints.mobile && width < Breakpoints.tablet;
  }

  /// Check if we should use desktop layout.
  bool get isDesktop => MediaQuery.sizeOf(this).width >= Breakpoints.tablet;

  /// Check if device is wide (tablet or larger).
  bool get isWide => MediaQuery.sizeOf(this).width >= Breakpoints.mobile;

  /// Get current device type.
  DeviceType get deviceType => MediaQuery.sizeOf(this).width.deviceType;

  /// Get responsive grid columns.
  int get gridColumns {
    final deviceType = this.deviceType;
    return switch (deviceType) {
      DeviceType.mobile => 1,
      DeviceType.tablet => 2,
      DeviceType.desktop => 3,
      DeviceType.largeDesktop => 4,
    };
  }
}

/// Constrained content wrapper for centering content on large screens.
class ConstrainedContent extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;
  final bool center;

  const ConstrainedContent({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
    this.center = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = child;

    final effectiveMaxWidth = maxWidth ?? context.contentMaxWidth;

    if (effectiveMaxWidth < double.infinity) {
      content = ConstrainedBox(
        constraints: BoxConstraints(maxWidth: effectiveMaxWidth),
        child: content,
      );

      if (center) {
        content = Center(child: content);
      }
    }

    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }

    return content;
  }
}

/// Responsive grid view.
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final int? mobileColumns;
  final int? tabletColumns;
  final int? desktopColumns;
  final int? largeDesktopColumns;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.spacing = 16,
    this.runSpacing = 16,
    this.mobileColumns,
    this.tabletColumns,
    this.desktopColumns,
    this.largeDesktopColumns,
  });

  @override
  Widget build(BuildContext context) {
    final deviceType = context.deviceType;

    final columns = switch (deviceType) {
      DeviceType.mobile => mobileColumns ?? 1,
      DeviceType.tablet => tabletColumns ?? mobileColumns ?? 2,
      DeviceType.desktop => desktopColumns ?? tabletColumns ?? mobileColumns ?? 3,
      DeviceType.largeDesktop =>
        largeDesktopColumns ?? desktopColumns ?? tabletColumns ?? mobileColumns ?? 4,
    };

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - (columns - 1) * spacing) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: children.map((child) {
            return SizedBox(
              width: itemWidth,
              child: child,
            );
          }).toList(),
        );
      },
    );
  }
}

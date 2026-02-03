import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Custom app bar widget for enterprise banking application.
/// Implements clean, professional header design with security indicators.
///
/// Features:
/// - Adaptive height and styling for different screen contexts
/// - Optional secure session indicator
/// - Biometric authentication quick access
/// - Support for custom actions and leading widgets
/// - Material Design 3 styling with banking aesthetics
///
/// Variants:
/// - Standard: Default app bar with title and optional actions
/// - Secure: Includes session security indicator
/// - Minimal: Simplified version for authentication flows
///
/// Usage:
/// ```dart
/// CustomAppBar(
///   title: 'Service Selection',
///   variant: AppBarVariant.secure,
///   showBackButton: true,
///   actions: [
///     IconButton(
///       icon: Icon(Icons.notifications_outlined),
///       onPressed: () {},
///     ),
///   ],
/// )
/// ```
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// App bar title text
  final String title;

  /// App bar variant type
  final AppBarVariant variant;

  /// Whether to show back button
  final bool showBackButton;

  /// Custom leading widget (overrides back button)
  final Widget? leading;

  /// Action widgets displayed on the right
  final List<Widget>? actions;

  /// Whether to show secure session indicator
  final bool showSecureIndicator;

  /// Custom bottom widget (e.g., TabBar)
  final PreferredSizeWidget? bottom;

  /// Background color override
  final Color? backgroundColor;

  /// Elevation override
  final double? elevation;

  /// Center title alignment
  final bool centerTitle;

  const CustomAppBar({
    super.key,
    required this.title,
    this.variant = AppBarVariant.standard,
    this.showBackButton = false,
    this.leading,
    this.actions,
    this.showSecureIndicator = false,
    this.bottom,
    this.backgroundColor,
    this.elevation,
    this.centerTitle = false,
  });

  @override
  Size get preferredSize {
    final double height =
        kToolbarHeight + (bottom?.preferredSize.height ?? 0.0);
    return Size.fromHeight(height);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine system UI overlay style based on theme
    final SystemUiOverlayStyle overlayStyle =
        theme.brightness == Brightness.light
        ? SystemUiOverlayStyle.dark
        : SystemUiOverlayStyle.light;

    return AppBar(
      systemOverlayStyle: overlayStyle,
      backgroundColor: backgroundColor ?? colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: elevation ?? (variant == AppBarVariant.minimal ? 0 : 0),
      scrolledUnderElevation: 4.0,
      shadowColor: colorScheme.shadow.withValues(alpha: 0.08),
      centerTitle: centerTitle,

      // Leading widget
      leading:
          leading ??
          (showBackButton
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: 'Back',
                )
              : null),

      // Title with optional secure indicator
      title: _buildTitle(context),

      // Actions
      actions: _buildActions(context),

      // Bottom widget (e.g., TabBar)
      bottom: bottom,
    );
  }

  Widget _buildTitle(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (variant == AppBarVariant.minimal) {
      return Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      );
    }

    if (showSecureIndicator) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lock_outline,
            size: 16,
            color: const Color(0xFF059669), // Success green
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }

    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
    );
  }

  List<Widget>? _buildActions(BuildContext context) {
    if (variant == AppBarVariant.minimal) {
      return null;
    }

    final List<Widget> actionWidgets = [];

    // Add custom actions
    if (actions != null) {
      actionWidgets.addAll(actions!);
    }

    // Add biometric quick access for secure variant
    if (variant == AppBarVariant.secure) {
      actionWidgets.add(
        IconButton(
          icon: const Icon(Icons.fingerprint),
          onPressed: () {
            // Biometric authentication trigger
            // Implementation would call local_auth package
          },
          tooltip: 'Biometric Authentication',
        ),
      );
    }

    return actionWidgets.isEmpty ? null : actionWidgets;
  }
}

/// App bar variant types for different contexts
enum AppBarVariant {
  /// Standard app bar with full features
  standard,

  /// Secure app bar with session indicators
  secure,

  /// Minimal app bar for authentication flows
  minimal,
}

/// Custom app bar with search functionality
class CustomSearchAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String hintText;
  final ValueChanged<String>? onSearch;
  final VoidCallback? onClear;
  final TextEditingController? controller;
  final bool autofocus;

  const CustomSearchAppBar({
    super.key,
    this.hintText = 'Search...',
    this.onSearch,
    this.onClear,
    this.controller,
    this.autofocus = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: TextField(
        controller: controller,
        autofocus: autofocus,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          hintStyle: theme.textTheme.bodyLarge?.copyWith(
            color: theme.brightness == Brightness.light
                ? const Color(0xFF6B7280)
                : const Color(0xFF9CA3AF),
          ),
        ),
        style: theme.textTheme.bodyLarge,
        onChanged: onSearch,
      ),
      actions: [
        if (controller?.text.isNotEmpty ?? false)
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              controller?.clear();
              onClear?.call();
            },
          ),
      ],
    );
  }
}

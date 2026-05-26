import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Dismisses the soft keyboard when the user taps outside focused fields.
class DismissKeyboardOnTap extends StatelessWidget {
  final Widget child;

  const DismissKeyboardOnTap({super.key, required this.child});

  static void dismiss(BuildContext context) {
    final focus = FocusManager.instance.primaryFocus;
    if (focus != null && focus.hasFocus) {
      focus.unfocus();
      HapticFeedback.selectionClick();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => dismiss(context),
      behavior: HitTestBehavior.translucent,
      child: child,
    );
  }
}

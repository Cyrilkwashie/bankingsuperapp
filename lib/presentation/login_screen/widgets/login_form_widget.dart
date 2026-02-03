import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Login form widget with floating labels and validation
class LoginFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final bool isPasswordVisible;
  final bool isLoading;
  final VoidCallback onPasswordVisibilityToggle;
  final VoidCallback onLogin;
  final VoidCallback onForgotPassword;

  const LoginFormWidget({
    super.key,
    required this.formKey,
    required this.usernameController,
    required this.passwordController,
    required this.isPasswordVisible,
    required this.isLoading,
    required this.onPasswordVisibilityToggle,
    required this.onLogin,
    required this.onForgotPassword,
  });

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your username or phone number';
    }

    // Check if it's a phone number (10 digits)
    if (RegExp(r'^\d{10}$').hasMatch(value)) {
      return null;
    }

    // Check if it's a valid email
    if (RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return null;
    }

    // Check if it's a valid username (alphanumeric, 3-20 chars)
    if (RegExp(r'^[a-zA-Z0-9_]{3,20}$').hasMatch(value)) {
      return null;
    }

    return 'Enter valid email, phone, or username';
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  TextInputType _getKeyboardType() {
    final text = usernameController.text;
    if (RegExp(r'^\d+$').hasMatch(text)) {
      return TextInputType.phone;
    }
    return TextInputType.emailAddress;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Username/Phone Field
          TextFormField(
            controller: usernameController,
            keyboardType: _getKeyboardType(),
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'Email, Phone, or Username',
              hintText: 'Enter your credentials',
              prefixIcon: CustomIconWidget(
                iconName: 'person_outline',
                size: 24,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            validator: _validateUsername,
            onChanged: (value) {
              // Trigger rebuild to update keyboard type
              if (value.length == 1 || value.isEmpty) {
                (context as Element).markNeedsBuild();
              }
            },
          ),

          SizedBox(height: 2.h),

          // Password Field
          TextFormField(
            controller: passwordController,
            obscureText: !isPasswordVisible,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
              prefixIcon: CustomIconWidget(
                iconName: 'lock_outline',
                size: 24,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              suffixIcon: IconButton(
                icon: CustomIconWidget(
                  iconName: isPasswordVisible ? 'visibility_off' : 'visibility',
                  size: 24,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                onPressed: onPasswordVisibilityToggle,
              ),
            ),
            validator: _validatePassword,
            onFieldSubmitted: (_) => onLogin(),
          ),

          SizedBox(height: 1.h),

          // Forgot Password Link
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onForgotPassword,
              child: Text(
                'Forgot Password?',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Login Button
          SizedBox(
            height: 7.h,
            child: ElevatedButton(
              onPressed: isLoading ? null : onLogin,
              child: isLoading
                  ? SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : Text(
                      'Login',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

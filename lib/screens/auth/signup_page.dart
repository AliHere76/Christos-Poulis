import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/message_type.dart';
import '../../utils/responsive_extension.dart';
import '../../utils/responsive_helper.dart';
import '../../utils/responsive_widget.dart';
import '../../widgets/app_message_notifier.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authController = ref.watch(authControllerProvider);

    // Listen to auth controller state changes
    ref.listen<AuthControllerState>(authControllerProvider, (previous, next) {
      if (next.isError) {
        AppNotifier.show(
          context,
          next.error ?? 'Sign up failed',
          type: MessageType.error,
        );
      } else if (next.isSuccess) {
        AppNotifier.show(
          context,
          'Account created successfully!',
          type: MessageType.success,
        );
        _emailController.clear();
        _passwordController.clear();
        _confirmPasswordController.clear();
      }
    });

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Stack(
          children: [
            ResponsiveBuilder(
              builder: (context, constraints, deviceType) {
                return _buildResponsiveLayout(context, theme, deviceType);
              },
            ),
            Positioned(
              top: context.smallSpacing,
              left: context.smallSpacing,
              child: IconButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(theme.primaryColor),
                ),
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: ResponsiveHelper.getValue(
                    context,
                    mobile: 30.0,
                    tablet: 35.0,
                    desktop: 40.0,
                  ),
                ),
                onPressed:
                    authController.isLoading
                        ? null
                        : () {
                          Navigator.pushReplacementNamed(context, '/auth');
                        },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResponsiveLayout(
    BuildContext context,
    ThemeData theme,
    DeviceType deviceType,
  ) {
    switch (deviceType) {
      case DeviceType.desktop:
        return _buildDesktopLayout(context, theme);
      case DeviceType.tablet:
        return _buildTabletLayout(context, theme);
      case DeviceType.mobile:
        return _buildMobileLayout(context, theme);
    }
  }

  Widget _buildMobileLayout(BuildContext context, ThemeData theme) {
    return Center(
      child: SingleChildScrollView(
        padding: context.allPadding,
        child: Card(
          elevation: 4,
          color: Colors.white,
          shadowColor: theme.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.mediumSpacing),
          ),
          child: Padding(
            padding: context.allPadding,
            child: _buildFormContent(context, theme),
          ),
        ),
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context, ThemeData theme) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        padding: context.horizontalPadding,
        child: Card(
          elevation: 6,
          color: Colors.white,
          shadowColor: theme.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.mediumSpacing),
          ),
          child: Padding(
            padding: context.allPadding.copyWith(
              top: context.mediumSpacing,
              bottom: context.mediumSpacing,
            ),
            child: _buildFormContent(context, theme),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, ThemeData theme) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        padding: context.horizontalPadding,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Center(
                child: Image.asset(
                  'assets/icons/Splash_Logo.png',
                  width: ResponsiveHelper.getValue(
                    context,
                    mobile: 150.0,
                    tablet: 180.0,
                    desktop: 200.0,
                  ),
                  height: ResponsiveHelper.getValue(
                    context,
                    mobile: 40.0,
                    tablet: 48.0,
                    desktop: 56.0,
                  ),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(width: context.largeSpacing),
            Expanded(
              flex: 2,
              child: Card(
                elevation: 8,
                color: Colors.white,
                shadowColor: theme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.mediumSpacing),
                ),
                child: Padding(
                  padding: context.allPadding.copyWith(
                    top: context.largeSpacing,
                    bottom: context.largeSpacing,
                  ),
                  child: _buildFormContent(context, theme),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormContent(BuildContext context, ThemeData theme) {
    final authController = ref.watch(authControllerProvider);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🖼️ App Logo (not shown in desktop since it's outside the card)
          if (ResponsiveHelper.isMobile(context) ||
              ResponsiveHelper.isTablet(context))
            Center(
              child: Image.asset(
                'assets/icons/Splash_Logo.png',
                width: ResponsiveHelper.getValue(
                  context,
                  mobile: 150.0,
                  tablet: 180.0,
                  desktop: 200.0,
                ),
                height: ResponsiveHelper.getValue(
                  context,
                  mobile: 40.0,
                  tablet: 48.0,
                  desktop: 56.0,
                ),
                fit: BoxFit.contain,
              ),
            ),
          if (ResponsiveHelper.isMobile(context) ||
              ResponsiveHelper.isTablet(context))
            SizedBox(height: context.mediumSpacing),
          // 👋 Welcome Text and Subtitle
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Get On Board!",
                style: context.responsiveHeadlineLarge.copyWith(
                  color: theme.primaryColor,
                ),
              ),
              SizedBox(height: context.smallSpacing),
              Text(
                "Create your profile to start your Journey.",
                style: context.responsiveBodyLarge,
              ),
            ],
          ),
          SizedBox(height: context.largeSpacing),
          // 📧 Email Field
          TextFormField(
            controller: _emailController,
            enabled: !authController.isLoading,
            style: context.responsiveBodyLarge.copyWith(
              color: theme.primaryColor,
            ),
            decoration: InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(
                Icons.email,
                color: theme.primaryColor,
                size: ResponsiveHelper.getValue(
                  context,
                  mobile: 24.0,
                  tablet: 26.0,
                  desktop: 28.0,
                ),
              ),
              hintText: 'Enter your email',
              hintStyle: context.responsiveBodyMedium.copyWith(
                color: theme.primaryColor,
              ),
              labelStyle: context.responsiveBodyMedium.copyWith(
                color: theme.primaryColor,
              ),
              filled: true,
              fillColor: Colors.grey[100],
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(context.smallSpacing),
                borderSide: BorderSide(color: theme.primaryColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(context.smallSpacing),
                borderSide: BorderSide(color: theme.primaryColor, width: 2),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(context.smallSpacing),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter your email';
              }
              if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value!)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          SizedBox(height: context.mediumSpacing),
          // 🔒 Password Field
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            enabled: !authController.isLoading,
            style: context.responsiveBodyLarge.copyWith(
              color: theme.primaryColor,
            ),
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: Icon(
                Icons.lock,
                color: theme.primaryColor,
                size: ResponsiveHelper.getValue(
                  context,
                  mobile: 24.0,
                  tablet: 26.0,
                  desktop: 28.0,
                ),
              ),
              hintText: 'Enter your password',
              hintStyle: context.responsiveBodyMedium.copyWith(
                color: theme.primaryColor,
              ),
              labelStyle: context.responsiveBodyMedium.copyWith(
                color: theme.primaryColor,
              ),
              filled: true,
              fillColor: Colors.grey[100],
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(context.smallSpacing),
                borderSide: BorderSide(color: theme.primaryColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(context.smallSpacing),
                borderSide: BorderSide(color: theme.primaryColor, width: 2),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(context.smallSpacing),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: theme.primaryColor,
                  size: ResponsiveHelper.getValue(
                    context,
                    mobile: 24.0,
                    tablet: 26.0,
                    desktop: 28.0,
                  ),
                ),
                onPressed:
                    authController.isLoading
                        ? null
                        : () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
              ),
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter your password';
              }
              if (value!.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          SizedBox(height: context.mediumSpacing),
          // 🔒 Confirm Password Field
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            enabled: !authController.isLoading,
            style: context.responsiveBodyLarge.copyWith(
              color: theme.primaryColor,
            ),
            decoration: InputDecoration(
              labelText: 'Re-Enter Password',
              prefixIcon: Icon(
                Icons.lock,
                color: theme.primaryColor,
                size: ResponsiveHelper.getValue(
                  context,
                  mobile: 24.0,
                  tablet: 26.0,
                  desktop: 28.0,
                ),
              ),
              hintText: 'Re-Enter your Password',
              hintStyle: context.responsiveBodyMedium.copyWith(
                color: theme.primaryColor,
              ),
              labelStyle: context.responsiveBodyMedium.copyWith(
                color: theme.primaryColor,
              ),
              filled: true,
              fillColor: Colors.grey[100],
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(context.smallSpacing),
                borderSide: BorderSide(color: theme.primaryColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(context.smallSpacing),
                borderSide: BorderSide(color: theme.primaryColor, width: 2),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(context.smallSpacing),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: theme.primaryColor,
                  size: ResponsiveHelper.getValue(
                    context,
                    mobile: 24.0,
                    tablet: 26.0,
                    desktop: 28.0,
                  ),
                ),
                onPressed:
                    authController.isLoading
                        ? null
                        : () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
              ),
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please confirm your password';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          SizedBox(height: context.largeSpacing),
          // 📝 Sign Up Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              padding: EdgeInsets.symmetric(
                vertical: context.mediumSpacing,
                horizontal: context.largeSpacing,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.smallSpacing),
              ),
            ),
            onPressed:
                authController.isLoading
                    ? null
                    : () async {
                      if (_formKey.currentState!.validate()) {
                        final success = await ref
                            .read(authControllerProvider.notifier)
                            .signUp(
                              email: _emailController.text.trim(),
                              password: _passwordController.text,
                              role: 'user', // Default role, adjust as needed
                              context: context,
                            );
                        if (success) {
                          Navigator.pushReplacementNamed(
                            context,
                            '/profile_setup',
                          );
                        }
                      }
                    },
            child:
                authController.isLoading
                    ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                    : Text(
                      'SIGN UP',
                      style: context.responsiveBodyLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
          ),
          SizedBox(height: context.mediumSpacing),
          // 🔗 Already have an account? Sign In
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account? ',
                style: context.responsiveBodyMedium,
              ),
              TextButton(
                onPressed:
                    authController.isLoading
                        ? null
                        : () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                child: Text(
                  'Sign In',
                  style: context.responsiveBodyMedium.copyWith(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

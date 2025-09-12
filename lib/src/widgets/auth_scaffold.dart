import 'package:flutter/material.dart';

class AuthScaffold extends StatelessWidget {
  final Widget logo;
  final Widget form;
  final Widget actionButton;
  final Widget? changeFormButton;
  final Widget? routeButton;
  final Widget? footer;
  final Color backgroundColor;
  final Color appBarBackgroundColor;

  const AuthScaffold({
    super.key,
    required this.logo,
    required this.form,
    required this.actionButton,
    this.changeFormButton,
    this.routeButton,
    this.footer,
    this.backgroundColor = Colors.white,
    this.appBarBackgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: null,
      // AppBar(
      //   backgroundColor: backgroundColor.withAlpha(0),
      //   elevation: 0,
      // ),
      body: SafeArea(
        child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: height * 0.12),

                  /// Logo
                  Center(child: logo),

                  const SizedBox(height: 40),

                  /// Form content
                  form,

                  const SizedBox(height: 20),

                  /// Main Action (e.g., Sign In || Continue)
                  actionButton,

                  const SizedBox(height: 10),

                  if (changeFormButton != null) changeFormButton!,

                  const SizedBox(height: 30),

                  if (routeButton != null) routeButton!,

                  const SizedBox(height: 30),

                  /// Optional footer (version, links, etc.)
                  if (footer != null) footer!,
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}

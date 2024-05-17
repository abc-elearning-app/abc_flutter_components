import 'package:example/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../navigation/app_route.dart';
import '../../navigation/navigation_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Provider.of<AppThemeProvider>(context, listen: false)
            .changeAppTheme(),
        label: const Text("Change Theme"),
        icon: const Icon(Icons.grid_view_outlined),
      ),
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.all(16).add(const EdgeInsets.only(bottom: 60)),
          child: ListView(
            children: AppRoute.getAppRoute()
                .map(
                  (e) => ElevatedButton(
                    onPressed: () => NavigationService().pushNamed(e),
                    child: Text(e
                        .substring(1)
                        .split(RegExp(r'_(?=[a-zA-Z])'))
                        .map(
                            (part) => part[0].toUpperCase() + part.substring(1))
                        .join(" ")),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

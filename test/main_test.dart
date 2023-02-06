import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_it_flutter/ui/components/extras/rive_animations/animated_btn.dart';
import 'package:food_it_flutter/ui/screens/auth/login_screen.dart';
import 'package:food_it_flutter/ui/screens/search/search_screen.dart';

import 'duplicate_provider.dart';

void main() {
  group('Auth Screen widget tests', () {
    setUpAll(() => HttpOverrides.global = null);
    testWidgets(
      'When submit empty fields, should show error',
          (tester) async {
        await tester.pumpFrames(
          DuplicateProvider(child: const LoginScreen()),
          const Duration(seconds: 6),
        );
        // final Finder buttonToTap = find.byKey(const ValueKey("login-button"));
        // await tester.ensureVisible(buttonToTap);
        // await tester.dragUntilVisible(
        //   buttonToTap, // what you want to find
        //   find.byType(SingleChildScrollView), // widget you want to scroll
        //   const Offset(0, 100), // delta to move
        // );
        await tester.tap(find.byType(AnimatedBtn));
        await tester.pump(Duration(seconds: 4));
        expect(find.text("Username required!"), findsOneWidget);
        expect(find.text("Password required!"), findsOneWidget);
        await tester.pumpAndSettle();
      },
    );
  });

  group('Search Screen Test', () {
    setUpAll(() => HttpOverrides.global = null);

    testWidgets(
      'When search, should only show cards containing the text',
          (widgetTester) async {
        await HttpOverrides.runZoned(
              () async {
            await widgetTester.pumpFrames(
              DuplicateProvider(child: const SearchScreen()),
              const Duration(seconds: 1),
            );
            await widgetTester.enterText(
              find.byKey(const ValueKey('search-input')),
              "9",
            );
            await widgetTester.pump(const Duration(seconds: 1));
            expect(find.byKey(const ValueKey('search-card')), findsNWidgets(1));
          },
        );
        await widgetTester.pumpAndSettle();
      },
    );

    testWidgets(
      'When search with invalid query, should show no cards at all',
          (widgetTester) async {
        await HttpOverrides.runZoned(
              () async {
            await widgetTester.pumpFrames(
              DuplicateProvider(child: const SearchScreen()),
              const Duration(seconds: 1),
            );
            await widgetTester.enterText(
              find.byKey(const ValueKey('search-input')),
              "fasdfadfadf",
            );
            await widgetTester.pump(const Duration(seconds: 1));
            expect(find.byKey(const ValueKey('search-card')), findsNothing);
            expect(find.text("No restaurants found"), findsOneWidget);
          },
        );
        await widgetTester.pump();
      },
    );
  });
}
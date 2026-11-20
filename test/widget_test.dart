import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bisma_typing_tutor/app.dart';
import 'package:bisma_typing_tutor/services/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await StorageService.init();
  });

  testWidgets('Welcome screen renders title and start button', (WidgetTester tester) async {
    await tester.pumpWidget(const BismaTypingTutorApp());
    await tester.pump();

    // Verify Title
    expect(find.text('BISMA'), findsOneWidget);
    expect(find.text('AI Cartoon Typing Tutor'), findsOneWidget);
    expect(find.text('Start Typing Adventure!'), findsOneWidget);

    // Verify Companions are present
    expect(find.text('Bisma'), findsOneWidget);
    expect(find.text('Pip'), findsOneWidget);
    expect(find.text('Sparky'), findsOneWidget);
    expect(find.text('Buzzy'), findsOneWidget);
    expect(find.text('Ollie'), findsOneWidget);
  });
}

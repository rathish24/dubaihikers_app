import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dubaihikers_app/features/navigation/presentation/screens/main_navigation_screen.dart';
import 'package:dubaihikers_app/features/leads/domain/repositories/leads_repository.dart';
import 'package:dubaihikers_app/features/leads/presentation/providers/leads_provider.dart';

class MockLeadsRepository extends Mock implements LeadsRepository {}

void main() {
  late MockLeadsRepository mockRepository;

  setUp(() {
    mockRepository = MockLeadsRepository();
    when(() => mockRepository.getLeads()).thenAnswer((_) async => []);
    when(() => mockRepository.getEvents()).thenAnswer((_) async => []);
  });

  testWidgets('MainNavigationScreen displays 3 bottom tabs (Lead, Event, Profile)',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          leadsRepositoryProvider.overrideWithValue(mockRepository),
        ],
        child: const MaterialApp(
          home: MainNavigationScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify 3 bottom navigation tabs exist
    expect(find.text('Lead'), findsOneWidget);
    expect(find.text('Event'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    // Default tab is Lead
    expect(find.text('Event Leads'), findsOneWidget);

    // Tap Event tab
    await tester.tap(find.text('Event'));
    await tester.pumpAndSettle();

    expect(find.text('Published Events'), findsOneWidget);

    // Tap Profile tab
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    expect(find.text('Admin Profile'), findsOneWidget);
  });
}

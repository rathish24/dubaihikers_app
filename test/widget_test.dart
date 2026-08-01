import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dubaihikers_app/main.dart';
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

  testWidgets('DubaiHikersApp initializes and renders MainNavigationScreen',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          leadsRepositoryProvider.overrideWithValue(mockRepository),
        ],
        child: const DubaiHikersApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Event Leads'), findsOneWidget);
  });
}

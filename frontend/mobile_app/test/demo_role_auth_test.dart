import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:caregrid_mobile/features/auth/data/repositories/auth_repository.dart';
import 'package:caregrid_mobile/features/auth/domain/entities/portal_user.dart';

void main() {
  test('seeded accounts route to eight distinct roles', () {
    final repo = CareGridAuthRepository();
    final roles = CareGridAuthRepository.demoAccounts
        .where((entry) => !entry.user.email.startsWith('expired@'))
        .map((entry) => repo.signIn(entry.user.email, entry.password)?.role).toSet();
    expect(roles, CareGridPortalRole.values.toSet());
    expect(repo.signIn('admin@caregrid.org', 'incorrect'), isNull);
  });

  test('registration stores valid demo documents and countdown', () {
    final repo = CareGridAuthRepository();
    final valid = DemoNgoDocument('Certificate', 'demo.pdf', Uint8List.fromList([37, 80, 68, 70, 45, 49]));
    final invalid = DemoNgoDocument('Certificate', 'bad.pdf', Uint8List.fromList([1, 2]));
    expect(repo.registerNgo('Bad NGO', 'badfile@caregrid.example', 'Demo1234', documents: [invalid]), isFalse);
    expect(repo.registerNgo('File NGO', 'file@caregrid.example', 'Demo1234', documents: [valid]), isTrue);
    final membership = CareGridAuthRepository.memberships['file@caregrid.example']!;
    expect(membership.documents.single.name, 'demo.pdf');
    expect(membership.daysLeft, greaterThan(0));
    expect(membership.planLabel, 'One-month free trial');
    repo.renew(membership.email);
    expect(membership.planLabel, 'Yearly license');
    membership.suspend();
    expect(repo.signIn(membership.email, 'Demo1234'), isNull);
    membership.reactivate();
    expect(repo.signIn(membership.email, 'Demo1234'), isNotNull);
    membership.block();
    expect(repo.signIn(membership.email, 'Demo1234'), isNull);
    membership.reactivate();
  });

  test('trial registration, expiry and renewal', () {
    final repo = CareGridAuthRepository();
    final email = 'test-ngo@caregrid.example';
    expect(repo.registerNgo('Test NGO', email, 'DemoTest123'), isTrue);
    expect(repo.registerNgo('Duplicate', email, 'DemoTest123'), isFalse);
    expect(repo.signIn(email, 'DemoTest123')?.role, CareGridPortalRole.ngo);
    expect(CareGridAuthRepository.memberships[email]!.plan, 'Trial');
    expect(repo.signIn('expired@caregrid.example', 'Ngo@123'), isNull);
    repo.renew('expired@caregrid.example');
    expect(repo.signIn('expired@caregrid.example', 'Ngo@123')?.role, CareGridPortalRole.ngo);
    expect(CareGridAuthRepository.memberships['expired@caregrid.example']!.plan, 'Annual');
    expect(CareGridAuthRepository.addMonths(DateTime(2026, 1, 31), 1), DateTime(2026, 2, 28));
  });
}

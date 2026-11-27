import 'package:flutter_test/flutter_test.dart';
import 'package:caregrid_mobile/features/auth/data/repositories/auth_repository.dart';
import 'package:caregrid_mobile/features/auth/domain/entities/portal_user.dart';
void main() {
  test('only three mobile roles', () {
    final repo = CareGridAuthRepository();
    expect(CareGridPortalRole.values.length, 3);
    expect(CareGridAuthRepository.demoAccounts.length, 3);
    for (final account in CareGridAuthRepository.demoAccounts) {
      expect(repo.signIn(account.user.email, account.password)?.role, account.user.role);
    }
    for (final email in ['admin@caregrid.org','membership@caregrid.example',
      'kamran@alkhidmat-lhr.org','pharmacy@medpluscare.org','lab@chughtai-care.org',
      'expired@caregrid.example']) {
      expect(repo.emailExists(email), isFalse);
    }
  });
}

import '../../domain/entities/portal_user.dart';
class CareGridAuthRepository {
  static List<({String password, PortalUser user})> get demoAccounts =>
      _accounts.values.take(3).toList();
  static final Map<String, ({String password, PortalUser user})> _accounts = {
    'ayesha.bibi@caregrid.pk': (
      password: 'Ben@123',
      user: const PortalUser(
        id: 'CG-BEN-2026-009481',
        name: 'Ayesha Bibi',
        email: 'ayesha.bibi@caregrid.pk',
        role: CareGridPortalRole.beneficiary,
        subtitle: 'CNIC: 35202-8492014-6 • 80% Subsidy Active',
      ),
    ),
    'ops@lahorekitchen.pk': (
      password: 'Food@123',
      user: const PortalUser(
        id: 'RST-312',
        name: 'Lahore Kitchen Relief',
        email: 'ops@lahorekitchen.pk',
        role: CareGridPortalRole.restaurant,
        subtitle: 'Verified Surplus Food Partner • Lahore',
      ),
    ),
    'sponsor@caregrid.example': (
      password: 'Sponsor@123',
      user: const PortalUser(id: 'SP-001', name: 'Demo Sponsor', email: 'sponsor@caregrid.example', role: CareGridPortalRole.sponsor, subtitle: 'Donations and receipts'),
    ),
  };

  PortalUser? signIn(String email, String password) {
    final record = _accounts[email.trim().toLowerCase()];
    if (record != null && record.password == password) {
      return record.user;
    }
    return null;
  }

  bool emailExists(String email) => _accounts.containsKey(email.trim().toLowerCase());

  PortalUser registerBeneficiary({
    required String fullName,
    required String cnic,
    required String phone,
    required String email,
    required String password,
  }) {
    final cleanEmail = email.trim().toLowerCase();
    if (_accounts.containsKey(cleanEmail)) throw StateError('Account already exists');
    final newUser = PortalUser(
      id: 'CG-BEN-2026-${100000 + _accounts.length}',
      name: fullName.trim(),
      email: cleanEmail,
      role: CareGridPortalRole.beneficiary,
      subtitle: 'CNIC: ${cnic.trim()} • ${phone.trim()}',
    );
    _accounts[cleanEmail] = (password: password, user: newUser);
    return newUser;
  }
}

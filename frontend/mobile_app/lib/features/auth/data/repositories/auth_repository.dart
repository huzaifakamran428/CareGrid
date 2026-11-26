import '../../domain/entities/portal_user.dart';

class CareGridAuthRepository {
  static final Map<String, DemoMembership> memberships = {
    'kamran@alkhidmat-lhr.org': DemoMembership('Al-Khidmat Care (demo)', 'kamran@alkhidmat-lhr.org', 'Trial', addMonths(DateTime.now(), 1)),
    'expired@caregrid.example': DemoMembership('Expired NGO (demo)', 'expired@caregrid.example', 'Annual', DateTime.now().subtract(const Duration(days: 1))),
  };

  static DateTime addMonths(DateTime date, int months) {
    final first = DateTime(date.year, date.month + months, 1);
    final last = DateTime(first.year, first.month + 1, 0).day;
    return DateTime(first.year, first.month, date.day > last ? last : date.day, date.hour, date.minute, date.second);
  }

  static const _seedEmails = [
    'admin@caregrid.org', 'membership@caregrid.example', 'kamran@alkhidmat-lhr.org',
    'ayesha.bibi@caregrid.pk', 'pharmacy@medpluscare.org', 'lab@chughtai-care.org',
    'ops@lahorekitchen.pk', 'sponsor@caregrid.example', 'expired@caregrid.example',
  ];
  static List<({String password, PortalUser user})> get demoAccounts =>
      _seedEmails.map((email) => _accounts[email]!).toList(growable: false);

  static List<PortalUser> get users => _accounts.values.map((r) => r.user).toList(growable: false);

  bool registerNgo(String name, String email, String password) {
    email = email.trim().toLowerCase();
    if (name.trim().isEmpty || !email.contains('@') || password.length < 8 || _accounts.containsKey(email)) return false;
    _accounts[email] = (password: password, user: PortalUser(id: 'NGO-${_accounts.length + 100}', name: name.trim(), email: email, role: CareGridPortalRole.ngo, subtitle: 'NGO membership - demo'));
    memberships[email] = DemoMembership(name.trim(), email, 'Trial', addMonths(DateTime.now(), 1));
    return true;
  }

  void renew(String email) {
    final item = memberships[email];
    if (item == null) return;
    final now = DateTime.now();
    item.expires = addMonths(item.expires.isAfter(now) ? item.expires : now, 12);
    item.plan = 'Annual';
  }

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
    'pharmacy@medpluscare.org': (
      password: 'Pharm@123',
      user: const PortalUser(
        id: 'PHM-409',
        name: 'MedPlus Care Pharmacy',
        email: 'pharmacy@medpluscare.org',
        role: CareGridPortalRole.pharmacy,
        subtitle: 'Authorized Pharmacy & Prescription Partner',
      ),
    ),
    'lab@chughtai-care.org': (
      password: 'Lab@123',
      user: const PortalUser(
        id: 'LAB-204',
        name: 'Chughtai Diagnostic Lab',
        email: 'lab@chughtai-care.org',
        role: CareGridPortalRole.lab,
        subtitle: 'Diagnostic Pathology Partner',
      ),
    ),
    'kamran@alkhidmat-lhr.org': (
      password: 'Ngo@123',
      user: const PortalUser(
        id: 'NGO-104',
        name: 'Dr. Kamran Siddiqui',
        email: 'kamran@alkhidmat-lhr.org',
        role: CareGridPortalRole.ngo,
        subtitle: 'Al-Khidmat Foundation • NGO Admin',
      ),
    ),
    'membership@caregrid.example': (
      password: 'Member@123',
      user: const PortalUser(id: 'ADM-002', name: 'Membership Administrator', email: 'membership@caregrid.example', role: CareGridPortalRole.membershipAdmin, subtitle: 'NGO licenses and credential issuance'),
    ),
    'sponsor@caregrid.example': (
      password: 'Sponsor@123',
      user: const PortalUser(id: 'SP-001', name: 'Demo Sponsor', email: 'sponsor@caregrid.example', role: CareGridPortalRole.sponsor, subtitle: 'Donations and receipts'),
    ),
    'expired@caregrid.example': (
      password: 'Ngo@123',
      user: const PortalUser(id: 'NGO-105', name: 'Expired NGO (demo)', email: 'expired@caregrid.example', role: CareGridPortalRole.ngo, subtitle: 'Expired license sample'),
    ),
    'admin@caregrid.org': (
      password: 'Admin@123',
      user: const PortalUser(
        id: 'ADM-001',
        name: 'System Administrator',
        email: 'admin@caregrid.org',
        role: CareGridPortalRole.admin,
        subtitle: 'Root Governance & User Access Console',
      ),
    ),
  };

  PortalUser? signIn(String email, String password) {
    final record = _accounts[email.trim().toLowerCase()];
    if (record != null && record.password == password) {
      if (record.user.role == CareGridPortalRole.ngo && !(memberships[record.user.email]?.active ?? false)) return null;
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

class DemoMembership {
  final String name;
  final String email;
  String plan;
  DateTime expires;
  DemoMembership(this.name, this.email, this.plan, this.expires);
  bool get active => expires.isAfter(DateTime.now());
  String get status => active ? plan : 'Expired';
}

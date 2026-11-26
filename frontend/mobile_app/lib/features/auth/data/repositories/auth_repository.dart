import '../../domain/entities/portal_user.dart';

class CareGridAuthRepository {
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
    if (record != null && record.password == password.trim()) {
      return record.user;
    }
    return null;
  }

  PortalUser registerBeneficiary({
    required String fullName,
    required String cnic,
    required String phone,
    required String email,
    required String password,
  }) {
    final cleanEmail = email.trim().toLowerCase();
    final newUser = PortalUser(
      id: 'CG-BEN-2026-${100000 + _accounts.length}',
      name: fullName.trim(),
      email: cleanEmail,
      role: CareGridPortalRole.beneficiary,
      subtitle: 'CNIC: ${cnic.trim()} • ${phone.trim()}',
    );
    _accounts[cleanEmail] = (password: password.trim(), user: newUser);
    return newUser;
  }
}

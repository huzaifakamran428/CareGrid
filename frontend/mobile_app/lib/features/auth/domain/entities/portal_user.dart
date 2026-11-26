enum CareGridPortalRole {
  beneficiary,
  restaurant,
  pharmacy,
  lab,
  ngo,
  admin,
  membershipAdmin,
  sponsor,
}

class PortalUser {
  final String id;
  final String name;
  final String email;
  final CareGridPortalRole role;
  final String subtitle;

  const PortalUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.subtitle,
  });
}

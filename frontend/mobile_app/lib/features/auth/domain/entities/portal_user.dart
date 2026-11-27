/// Mobile-only role boundary. Staff and NGO workspaces belong to the web app.
enum CareGridPortalRole {
  beneficiary,
  restaurant,
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

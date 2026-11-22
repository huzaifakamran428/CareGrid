/// Fictional preview-only record. Not connected to NGO services or real identity data.
class BeneficiaryDigitalIdDemo {
  const BeneficiaryDigitalIdDemo({
    required this.name,
    required this.cnic,
    required this.address,
    required this.digitalId,
    required this.issuedAt,
    this.status = 'Active',
    this.photoAsset,
  });

  final String name;
  final String cnic;
  final String address;
  final String digitalId;
  final String issuedAt;
  final String status;
  final String? photoAsset;
}

const demoBeneficiaryId = BeneficiaryDigitalIdDemo(
  name: 'Ayesha Malik',
  cnic: '35201-0000000-0',
  address: 'Model Town, Lahore (fictional example)',
  digitalId: 'CG-BEN-1001',
  issuedAt: '14 Nov 2026',
);

import 'dart:typed_data';

/// Frontend-only mock records, shared between roles in one running app.
/// Never store actual patient documents in this demo.
class DemoPrescription {
  final String id, beneficiaryEmail, pharmacyEmail, filename;
  final Uint8List bytes;
  String status = 'Submitted';
  String reviewedText = '';
  double demoTotal = 0;
  DemoPrescription({required this.id, required this.beneficiaryEmail,
    required this.pharmacyEmail, required this.filename, required Uint8List bytes})
    : bytes = Uint8List.fromList(bytes);
}

abstract final class PrescriptionDemoStore {
  static final List<DemoPrescription> records = [];
  static DemoPrescription submit(String email, String filename, Uint8List bytes) {
    final record = DemoPrescription(
      id: 'RX-${DateTime.now().microsecondsSinceEpoch}',
      beneficiaryEmail: email, pharmacyEmail: 'pharmacy@medpluscare.org',
      filename: filename, bytes: bytes);
    records.add(record);
    return record;
  }
  static List<DemoPrescription> forBeneficiary(String email) =>
    records.where((r) => r.beneficiaryEmail == email).toList();
  static List<DemoPrescription> forPharmacy(String email) =>
    records.where((r) => r.pharmacyEmail == email).toList();
}

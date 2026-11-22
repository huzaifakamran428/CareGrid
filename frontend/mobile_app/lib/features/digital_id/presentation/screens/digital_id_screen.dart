import 'package:flutter/material.dart';
import '../state/beneficiary_digital_id_demo.dart';

/// The beneficiary's own digital card. This is UI only: secure access and
/// synchronization with NGO records require CareGrid's future backend.
class DigitalIdScreen extends StatelessWidget {
  const DigitalIdScreen({super.key, this.beneficiary = demoBeneficiaryId});
  final BeneficiaryDigitalIdDemo beneficiary;

  static const _green = Color(0xFF068A74);
  static const _dark = Color(0xFF123944);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          children: [
            Row(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset('assets/images/caregrid_logo.jpg', width: 54, height: 54, fit: BoxFit.cover),
              ),
              const SizedBox(width: 12),
              const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('CareGrid', style: TextStyle(color: _dark, fontSize: 23, fontWeight: FontWeight.w900)),
                Text('BENEFICIARY PORTAL', style: TextStyle(letterSpacing: 1.1, fontSize: 10, color: Color(0xFF748C94))),
              ]),
            ]),
            const SizedBox(height: 30),
            const Text('My Digital ID', style: TextStyle(fontSize: 29, fontWeight: FontWeight.w900, color: _dark)),
            const SizedBox(height: 9),
            const Text('Your NGO-issued beneficiary identity card appears here after registration.',
                style: TextStyle(fontSize: 13, height: 1.6, color: Color(0xFF748C94))),
            const SizedBox(height: 22),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFC9E5DC)),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [BoxShadow(color: Color(0x0F095D52), blurRadius: 20, offset: Offset(0, 10))],
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Container(
                  decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF075B53), Color(0xFF0B9882)])),
                  padding: const EdgeInsets.all(16),
                  child: Row(children: [
                    ClipRRect(borderRadius: BorderRadius.circular(10), child:
                      Image.asset('assets/images/caregrid_logo.jpg', width: 43, height: 43, fit: BoxFit.cover)),
                    const SizedBox(width: 10),
                    const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('CareGrid', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: Colors.white)),
                      Text('BENEFICIARY DIGITAL ID', style: TextStyle(fontSize: 9, letterSpacing: 1.0, color: Color(0xFFDCFFF7))),
                    ])),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                      decoration: BoxDecoration(border: Border.all(color: const Color(0x66FFFFFF)), borderRadius: BorderRadius.circular(30)),
                      child: Text(beneficiary.status.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white)),
                    ),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(17),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _portrait(),
                    const SizedBox(width: 15),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      _detail('FULL NAME', beneficiary.name),
                      _detail('DIGITAL ID', beneficiary.digitalId),
                      _detail('CNIC', beneficiary.cnic),
                      _detail('ADDRESS', beneficiary.address),
                    ])),
                  ]),
                ),
                Container(
                  color: const Color(0xFFE7F5EF),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                  child: Wrap(spacing: 10, runSpacing: 5, alignment: WrapAlignment.spaceBetween, children: [
                    Text('Issued: ${beneficiary.issuedAt}', style: const TextStyle(color: Color(0xFF4C776A), fontSize: 10)),
                    const Text('PREVIEW · NOT VERIFIABLE', style: TextStyle(color: Color(0xFF4C776A), fontSize: 9, fontWeight: FontWeight.w800)),
                  ]),
                ),
              ]),
            ),
            const SizedBox(height: 22),
            Container(
              decoration: BoxDecoration(color: const Color(0xFFE8F6EF), borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.all(15),
              child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(Icons.verified_user_outlined, size: 21, color: _green),
                SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('NGO assisted registration', style: TextStyle(fontWeight: FontWeight.w800, color: _dark)),
                  SizedBox(height: 5),
                  Text('The NGO registers the beneficiary after checking the original CNIC and three months of bills. No additional admin approval is required in this proposed workflow.',
                      style: TextStyle(fontSize: 12, height: 1.55, color: Color(0xFF55766E))),
                ])),
              ]),
            ),
            const SizedBox(height: 17),
            const Text('Preview only. The mobile app currently shows fictional details. Real beneficiary sign-in, photo/document access, and updates from NGO staff require a secure API.',
                style: TextStyle(color: Color(0xFF8B9299), fontSize: 11, height: 1.6)),
          ],
        ),
      ),
    );
  }

  Widget _portrait() {
    final file = beneficiary.photoAsset;
    return Container(
      width: 92,
      height: 116,
      decoration: BoxDecoration(color: const Color(0xFFE1EEE9), borderRadius: BorderRadius.circular(13)),
      clipBehavior: Clip.antiAlias,
      child: file == null
          ? const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.person_rounded, color: Color(0xFF589388), size: 46),
              SizedBox(height: 3),
              Text('Photo', style: TextStyle(color: Color(0xFF589388), fontSize: 10)),
            ])
          : Image.asset(file, fit: BoxFit.cover, errorBuilder: (_, __, ___) =>
              const Center(child: Icon(Icons.person_rounded, size: 44, color: Color(0xFF589388)))),
    );
  }

  Widget _detail(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 11),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: .7, color: Color(0xFF77928B))),
      const SizedBox(height: 4),
      Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: _dark)),
    ]),
  );
}

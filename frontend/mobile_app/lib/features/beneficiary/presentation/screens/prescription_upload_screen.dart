// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import '../../../../app/theme/brand_tokens.dart';
import '../../../../core/widgets/caregrid_brand.dart';

class PrescriptionUploadScreen extends StatefulWidget {
  const PrescriptionUploadScreen({super.key});

  @override
  State<PrescriptionUploadScreen> createState() =>
      _PrescriptionUploadScreenState();
}

class _PrescriptionUploadScreenState extends State<PrescriptionUploadScreen> {
  // ---------------------------------------------------------------------------
  // DESIGN SYSTEM COLORS (100% Consistent across CareGrid Screens)
  // ---------------------------------------------------------------------------
  static const Color _primaryGreen = CareGridPalette.primary;
  static const Color _headerBadgeBg = CareGridPalette.primaryDeep;
  static const Color _headerBadgeBorder = CareGridPalette.primaryBorder;
  static const Color _amberBadge = CareGridPalette.gold;

  static const Color _mintCardBg = CareGridPalette.paleMint;
  static const Color _mintCardBorder = CareGridPalette.mintBorder;
  static const Color _darkForestText = CareGridPalette.ink;
  static const Color _mutedText = CareGridPalette.secondaryText;

  static const Color _softRedBg = CareGridPalette.dangerTint;
  static const Color _softRedBorder = CareGridPalette.dangerBorder;
  static const Color _crimsonBadge = CareGridPalette.danger;

  static const Color _canvasBg = CareGridPalette.canvas;
  static const Color _neutralBtnBg = CareGridPalette.paleNeutral;
  static const Color _neutralBtnBorder = CareGridPalette.line;

  // ---------------------------------------------------------------------------
  // DUMMY DATA & OCR EXTRACTION STATE
  // ---------------------------------------------------------------------------
  bool _isScanning = false;
  bool _hasActiveScanPreview = true;

  final Map _latestOcrResult = {
    'rxId': 'RX-2026-118',
    'doctorName': 'Dr. Tariq Mahmood (MBBS, FCPS)',
    'clinicName': 'Al-Shifa Welfare Clinic, Lahore',
    'issueDate': '21 Nov 2026',
    'fileName': 'prescription_nov21_scan.jpg',
    'confidence': 'Example OCR preview (not scanned)',
  };

  final List _extractedMedicines = [
    {
      'name': 'Tab. Augmentin 625mg',
      'dosage': '1 Tablet • Twice Daily (Morning & Night)',
      'duration': '5 Days (10 Tablets)',
      'subsidyCovered': true,
    },
    {
      'name': 'Tab. Panadol 500mg',
      'dosage': '1 Tablet • Every 8 Hours (If Fever)',
      'duration': '3 Days (9 Tablets)',
      'subsidyCovered': true,
    },
    {
      'name': 'Cap. Risek 40mg',
      'dosage': '1 Capsule • Before Breakfast',
      'duration': '7 Days (7 Capsules)',
      'subsidyCovered': true,
    },
  ];

  final List _savedPrescriptions = [
    {
      'rxId': 'RX-2026-114',
      'doctor': 'Dr. Sadia Anwar (General Physician)',
      'date': '14 Nov 2026',
      'itemsCount': 2,
      'status': 'Demo record',
    },
    {
      'rxId': 'RX-2026-098',
      'doctor': 'Dr. Kamran Malik (Medical Specialist)',
      'date': '02 Nov 2026',
      'itemsCount': 4,
      'status': 'Demo record',
    },
  ];

  void _simulateUpload(String source) {
    setState(() {
      _isScanning = true;
    });
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() {
        _isScanning = false;
        _hasActiveScanPreview = true;
        _latestOcrResult['fileName'] = source == 'Camera'
            ? 'camera_rx_capture_2026.jpg'
            : 'gallery_rx_document_2026.pdf';
      });
      _showSnack('Demo scan shown: no file was uploaded or processed');
    });
  }

  void _deleteLatestPrescription() {
    setState(() {
      _hasActiveScanPreview = false;
    });
    _showSnack('Active prescription removed');
  }

  void _deleteSavedItem(int index) {
    final String rxId = _savedPrescriptions[index]['rxId'].toString();
    setState(() {
      _savedPrescriptions.removeAt(index);
    });
    _showSnack('Prescription $rxId deleted');
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _primaryGreen,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _primaryGreen,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // 1. TOP FOREST GREEN HEADER
            CareGridBrandedHeader(child: _buildTopHeader()),

            // 2. MAIN ROUNDED SHEET CONTAINER
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: _canvasBg,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Upload Action Box (Camera / Gallery)
                        _buildUploadSelectorCard(),
                        const SizedBox(height: 18),

                        // Prescription Scan Digitized Result Card
                        if (_isScanning)
                          _buildScanningLoaderCard()
                        else if (_hasActiveScanPreview) ...[
                          _buildOcrExtractedCard(),
                          const SizedBox(height: 18),
                        ],

                        // Previously Uploaded Prescriptions History
                        const Text(
                          'Saved Prescriptions History',
                          style: TextStyle(
                            color: _darkForestText,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildSavedPrescriptionsList(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TOP HEADER
  // ---------------------------------------------------------------------------
  Widget _buildTopHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: _amberBadge,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'AI PRESCRIPTION SCANNER',
                  style: TextStyle(
                    color: _darkForestText,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _headerBadgeBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _headerBadgeBorder, width: 1),
                ),
                child: const Text(
                  '70% MED SUBSIDY',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Upload & Manage Prescriptions',
            style: TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Scan your doctor’s prescription to extract medicines automatically for subsidized pharmacy dispensing.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.88),
              fontSize: 12.5,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // UPLOAD SOURCE SELECTOR CARD (Camera / Gallery)
  // ---------------------------------------------------------------------------
  Widget _buildUploadSelectorCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _neutralBtnBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upload New Prescription',
            style: TextStyle(
              color: _darkForestText,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Demo only: these buttons show sample data. File picking, upload and Prescription Scan will work after backend integration.',
            style: TextStyle(
              color: _mutedText,
              fontSize: 12,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _simulateUpload('Camera'),
                  icon: const Icon(Icons.camera_alt_outlined, size: 18),
                  label: const Text(
                    'Take Photo',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _simulateUpload('Gallery'),
                  icon: const Icon(Icons.upload_file_outlined, size: 18),
                  label: const Text(
                    'Choose File',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: _mintCardBg,
                    foregroundColor: _darkForestText,
                    side: const BorderSide(color: _mintCardBorder, width: 1.2),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // OCR SCANNING PROGRESS CARD
  // ---------------------------------------------------------------------------
  Widget _buildScanningLoaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: _mintCardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _mintCardBorder, width: 1.2),
      ),
      child: const Column(
        children: [
          CircularProgressIndicator(color: _primaryGreen, strokeWidth: 3),
          SizedBox(height: 12),
          Text(
            'Extracting Medicine Details via Prescription Scan...',
            style: TextStyle(
              color: _darkForestText,
              fontSize: 13.5,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Structuring drug names, dosages, and subsidy coverage.',
            style: TextStyle(
              color: _mutedText,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // DIGITIZED OCR RESULT CARD
  // ---------------------------------------------------------------------------
  Widget _buildOcrExtractedCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _mintCardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _mintCardBorder, width: 1.3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Badges
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _primaryGreen,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome, color: Colors.white, size: 13),
                    SizedBox(width: 4),
                    Text(
                      'OCR DIGITIZED',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                _latestOcrResult['confidence'].toString(),
                style: const TextStyle(
                  color: _darkForestText,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Doctor & File Metadata
          Text(
            '${_latestOcrResult['rxId']} • ${_latestOcrResult['doctorName']}',
            style: const TextStyle(
              color: _darkForestText,
              fontSize: 14.5,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            '${_latestOcrResult['clinicName']} (${_latestOcrResult['issueDate']})',
            style: const TextStyle(
              color: _mutedText,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          // White Extracted Medicines Container
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _mintCardBorder, width: 1.1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'EXTRACTED MEDICINES (READY FOR PHARMACY):',
                  style: TextStyle(
                    color: _primaryGreen,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 8),
                ...List.generate(_extractedMedicines.length, (index) {
                  final Map med = _extractedMedicines[index] as Map;
                  final bool isLast = index == _extractedMedicines.length - 1;
                  return Container(
                    padding: EdgeInsets.only(bottom: isLast ? 0 : 9),
                    margin: EdgeInsets.only(bottom: isLast ? 0 : 9),
                    decoration: BoxDecoration(
                      border: isLast
                          ? null
                          : const Border(
                              bottom: BorderSide(color: _neutralBtnBorder),
                            ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.medication_outlined,
                            color: _primaryGreen, size: 17),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                med['name'].toString(),
                                style: const TextStyle(
                                  color: _darkForestText,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                '${med['dosage']} • ${med['duration']}',
                                style: const TextStyle(
                                  color: _mutedText,
                                  fontSize: 11.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: _mintCardBg,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            '70% Off',
                            style: TextStyle(
                              color: _primaryGreen,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Replace / Delete Action Row
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _simulateUpload('Gallery'),
                  icon: const Icon(Icons.refresh_rounded, size: 16),
                  label: const Text(
                    'Replace Scan',
                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: _deleteLatestPrescription,
                icon: const Icon(Icons.delete_outline, size: 16),
                label: const Text(
                  'Delete',
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _crimsonBadge,
                  backgroundColor: _softRedBg,
                  side: const BorderSide(color: _softRedBorder),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SAVED PRESCRIPTIONS HISTORY LIST
  // ---------------------------------------------------------------------------
  Widget _buildSavedPrescriptionsList() {
    if (_savedPrescriptions.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _neutralBtnBorder),
        ),
        child: const Center(
          child: Text(
            'No previous prescriptions stored.',
            style: TextStyle(color: _mutedText, fontSize: 12.5),
          ),
        ),
      );
    }

    return Column(
      children: List.generate(_savedPrescriptions.length, (index) {
        final Map item = _savedPrescriptions[index] as Map;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _neutralBtnBorder, width: 1.2),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: _mintCardBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.description_outlined,
                  color: _primaryGreen,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${item['rxId']} • ${item['doctor']}',
                      style: const TextStyle(
                        color: _darkForestText,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${item['date']} • ${item['itemsCount']} Medicines • ${item['status']}',
                      style: const TextStyle(
                        color: _mutedText,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () =>
                    _showSnack('Viewing ${item['rxId']} digital scan'),
                icon: const Icon(Icons.visibility_outlined,
                    color: _primaryGreen, size: 19),
                tooltip: 'View',
              ),
              IconButton(
                onPressed: () => _deleteSavedItem(index),
                icon: const Icon(Icons.delete_outline,
                    color: _crimsonBadge, size: 19),
                tooltip: 'Delete',
              ),
            ],
          ),
        );
      }),
    );
  }
}
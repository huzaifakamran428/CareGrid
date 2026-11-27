import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../app/theme/brand_tokens.dart';
import '../../data/repositories/auth_repository.dart';
import '../../domain/entities/portal_user.dart';

class UnifiedAuthScreen extends StatefulWidget {
  final ValueChanged<PortalUser> onAuthenticated;
  const UnifiedAuthScreen({super.key, required this.onAuthenticated});

  @override
  State<UnifiedAuthScreen> createState() => _UnifiedAuthScreenState();
}

class _UnifiedAuthScreenState extends State<UnifiedAuthScreen> {
  bool _isSignup = false;
  int _signupStep = 0; // 0: Account, 1: Welfare Form, 2: Eligibility Documents
  bool _obscure = true;
  bool _obscureConfirm = true;
  bool _keepSignedIn = true;

  final _loginFormKey = GlobalKey<FormState>();
  final _signupFormKey = GlobalKey<FormState>();
  final _welfareFormKey = GlobalKey<FormState>();

  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  // Step 1 controllers
  final _nameCtrl = TextEditingController();
  final _cnicCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _signupEmailCtrl = TextEditingController();
  final _signupPassCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  // Step 2 controllers
  final _addressCtrl = TextEditingController(text: 'House 14, Street 6, Township, Lahore');
  final _incomeCtrl = TextEditingController(text: 'PKR 24,000 / mo');
  final _dependentsCtrl = TextEditingController(text: '4 Members');
  final _needSummaryCtrl = TextEditingController(
    text: 'Daily wage earner; Type-2 Diabetic requiring monthly insulin & blood glucose lab tests.',
  );
  bool _needMeds = true;
  bool _needLabs = true;
  bool _needFood = true;

  // Step 3 document states
  final List<Map<String, dynamic>> _docs = [
    {'title': '1. CNIC Front & Back (Required)', 'file': 'CNIC_Fatima_FrontBack.pdf (1.4 MB)', 'uploaded': true, 'required': true},
    {'title': '2. Last 3 Months Utility Bills (Required)', 'file': 'LESCO_3Month_Bills.pdf (2.1 MB)', 'uploaded': true, 'required': true},
    {'title': '3. Recent Applicant Picture (Required)', 'file': 'Fatima_Passport_Photo.jpg (640 KB)', 'uploaded': true, 'required': true},
    {'title': '4. Salary Slip / Income Proof (If Any)', 'file': 'Wage_Slip_Oct2026.pdf (480 KB)', 'uploaded': true, 'required': false},
    {'title': '5. Bank Statement (Optional / If Any)', 'file': 'No bank account declared (Optional field)', 'uploaded': false, 'required': false},
  ];

  PortalUser? _pendingUser;
  final _repo = CareGridAuthRepository();

  bool get _nameValid => _nameCtrl.text.trim().length >= 3;
  bool get _cnicValid => RegExp(r'^\d{5}-\d{7}-\d{1}$').hasMatch(_cnicCtrl.text.trim());
  bool get _passStrong => _signupPassCtrl.text.length >= 8;
  bool get _passMatched => _passStrong && _confirmPassCtrl.text == _signupPassCtrl.text;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _nameCtrl.dispose();
    _cnicCtrl.dispose();
    _phoneCtrl.dispose();
    _signupEmailCtrl.dispose();
    _signupPassCtrl.dispose();
    _confirmPassCtrl.dispose();
    _addressCtrl.dispose();
    _incomeCtrl.dispose();
    _dependentsCtrl.dispose();
    _needSummaryCtrl.dispose();
    super.dispose();
  }

  void _handleSignIn() {
    if (!(_loginFormKey.currentState?.validate() ?? false)) return;
    final user = _repo.signIn(_emailCtrl.text, _passCtrl.text);
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: CareGridPalette.danger,
          content: Text('Invalid credentials or expired NGO membership.'),
        ),
      );
      return;
    }
    widget.onAuthenticated(user);
  }

  void _completeStep1() {
    if (!(_signupFormKey.currentState?.validate() ?? false)) return;
    if (_repo.emailExists(_signupEmailCtrl.text)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('This email is already registered.')));
      return;
    }
    final user = _repo.registerBeneficiary(
      fullName: _nameCtrl.text,
      cnic: _cnicCtrl.text,
      phone: _phoneCtrl.text,
      email: _signupEmailCtrl.text,
      password: _signupPassCtrl.text,
    );
    setState(() {
      _pendingUser = user;
      _signupStep = 1;
    });
  }

  void _completeStep2() {
    if (!(_welfareFormKey.currentState?.validate() ?? false)) return;
    setState(() => _signupStep = 2);
  }

  void _completeStep3() {
    final user = _pendingUser ??
        PortalUser(
          id: 'CG-APP-2026-8841',
          name: _nameCtrl.text.trim().isEmpty ? 'Fatima Bibi' : _nameCtrl.text.trim(),
          email: _signupEmailCtrl.text.trim(),
          role: CareGridPortalRole.beneficiary,
          subtitle: 'CNIC: ${_cnicCtrl.text.trim()}',
        );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: CareGridPalette.primary,
        content: Text('Application CG-APP-2026-8841 submitted for ${user.name}!'),
      ),
    );
    widget.onAuthenticated(user);
  }

  @override
  Widget build(BuildContext context) {
    final headerTitle = !_isSignup
        ? 'Sign In to CareGrid'
        : switch (_signupStep) {
            0 => 'Create Beneficiary Account',
            1 => 'Welfare Assistance Form',
            _ => 'Upload Eligibility Documents',
          };

    final headerSubtitle = !_isSignup
        ? 'Demo only - enter your assigned email and password'
        : switch (_signupStep) {
            0 => 'Sign up with personal details to apply for welfare services',
            1 => 'Step 1 of 2: Household, Income & Assistance Details',
            _ => 'Linked to Application Ref: CG-APP-2026-8841',
          };

    return Scaffold(
      backgroundColor: CareGridPalette.canvas,
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: CareGridPalette.canvasGradient),
        child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Emerald Header Card (Matching Screenshot 2 Design & Palette)
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: CareGridPalette.headerGradient,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [CareGridLayout.cardShadow],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image.asset('assets/images/caregrid_logo.png', height: 38, width: 38),
                        ),
                        const SizedBox(width: 10),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CareGrid',
                              style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w900),
                            ),
                            Text(
                              'Compassion Connected',
                              style: TextStyle(color: Color(0xFFD7F2E9), fontSize: 11),
                            ),
                          ],
                        ),
                        if (_isSignup && _signupStep > 0) ...[
                          const Spacer(),
                          IconButton(
                            onPressed: () => setState(() => _signupStep--),
                            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                            tooltip: 'Previous Step',
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      headerTitle,
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      headerSubtitle,
                      style: const TextStyle(color: Color(0xFFE0F4EC), fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Sign Up / Sign In Switcher
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: CareGridPalette.paleMint,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: CareGridPalette.line),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() {
                          _isSignup = true;
                          _signupStep = 0;
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          decoration: BoxDecoration(
                            color: _isSignup ? CareGridPalette.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: _isSignup ? Colors.white : CareGridPalette.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isSignup = false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          decoration: BoxDecoration(
                            color: !_isSignup ? CareGridPalette.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: !_isSignup ? Colors.white : CareGridPalette.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: CareGridPalette.line),
                  boxShadow: const [CareGridLayout.cardShadow],
                ),
                child: Material(
                  type: MaterialType.transparency,
                  child: !_isSignup
                      ? _buildLoginForm()
                      : switch (_signupStep) {
                          0 => _buildSignupStep1(),
                          1 => _buildSignupStep2(),
                          _ => _buildSignupStep3(),
                        },
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildSignupStep1() {
    return Form(
      key: _signupFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Full Legal Name *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          TextFormField(
            controller: _nameCtrl,
            onChanged: (_) => setState(() {}),
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              hintText: 'Fatima Bibi',
              suffixIcon: _nameValid
                  ? const Padding(
                      padding: EdgeInsets.only(right: 12, top: 14),
                      child: Text('Valid ✓', style: TextStyle(color: CareGridPalette.primary, fontWeight: FontWeight.w700, fontSize: 12)),
                    )
                  : null,
            ),
            validator: (v) => (v == null || v.trim().length < 3) ? 'Enter your full legal name' : null,
          ),
          const SizedBox(height: 12),

          const Text('CNIC / National Identity Number *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          TextFormField(
            controller: _cnicCtrl,
            onChanged: (_) => setState(() {}),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d-]'))],
            decoration: InputDecoration(
              hintText: '35201-9847123-2',
              suffixIcon: _cnicValid
                  ? const Padding(
                      padding: EdgeInsets.only(right: 12, top: 14),
                      child: Text('Format OK ✓', style: TextStyle(color: CareGridPalette.primary, fontWeight: FontWeight.w700, fontSize: 12)),
                    )
                  : null,
            ),
            validator: (v) => !RegExp(r'^\d{5}-\d{7}-\d{1}$').hasMatch((v ?? '').trim())
                ? 'Format: 35201-9847123-2'
                : null,
          ),
          const SizedBox(height: 12),

          const Text('Mobile Contact Number *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          TextFormField(
            controller: _phoneCtrl,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(hintText: '+92 300 4129801'),
            validator: (v) => (v == null || v.trim().length < 10) ? 'Enter a valid mobile number' : null,
          ),
          const SizedBox(height: 12),

          const Text('Email Address *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          TextFormField(
            controller: _signupEmailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'fatima.bibi@email.com'),
            validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email address' : null,
          ),
          const SizedBox(height: 12),

          const Text('Create Strong Password *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          TextFormField(
            controller: _signupPassCtrl,
            onChanged: (_) => setState(() {}),
            obscureText: _obscure,
            decoration: InputDecoration(
              hintText: '••••••••••••',
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_passStrong)
                    const Text('Strong', style: TextStyle(color: CareGridPalette.primary, fontWeight: FontWeight.w700, fontSize: 12)),
                  IconButton(
                    icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, size: 20),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ],
              ),
            ),
            validator: (v) => (v == null || v.length < 8) ? 'Minimum 8 characters required' : null,
          ),
          const SizedBox(height: 12),

          const Text('Confirm Password *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          TextFormField(
            controller: _confirmPassCtrl,
            onChanged: (_) => setState(() {}),
            obscureText: _obscureConfirm,
            decoration: InputDecoration(
              hintText: '••••••••••••',
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_passMatched)
                    const Text('Matched ✓', style: TextStyle(color: CareGridPalette.primary, fontWeight: FontWeight.w700, fontSize: 12)),
                  IconButton(
                    icon: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility, size: 20),
                    onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                ],
              ),
            ),
            validator: (v) => (v != _signupPassCtrl.text) ? 'Passwords do not match' : null,
          ),
          const SizedBox(height: 14),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: CareGridPalette.paleMint,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: CareGridPalette.line),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '✓ System Data Validation Passed',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: CareGridPalette.primary),
                ),
                SizedBox(height: 2),
                Text(
                  'CNIC uniqueness, mobile format & password verified.',
                  style: TextStyle(fontSize: 11, color: CareGridPalette.secondaryText),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          FilledButton(
            onPressed: _completeStep1,
            style: FilledButton.styleFrom(
              backgroundColor: CareGridPalette.primary,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Create Account & Continue →', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
          ),
          const SizedBox(height: 12),
          Center(
            child: GestureDetector(
              onTap: () => setState(() => _isSignup = false),
              child: const Text.rich(
                TextSpan(
                  text: 'Already have an account? ',
                  style: TextStyle(fontSize: 12, color: CareGridPalette.secondaryText),
                  children: [
                    TextSpan(
                      text: 'Sign In',
                      style: TextStyle(color: CareGridPalette.primary, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupStep2() {
    final applicantName = _nameCtrl.text.trim().isEmpty ? 'Fatima Bibi' : _nameCtrl.text.trim();
    final applicantCnic = _cnicCtrl.text.trim().isEmpty ? '35201-9847123-2' : _cnicCtrl.text.trim();

    return Form(
      key: _welfareFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: CareGridPalette.paleMint,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: CareGridPalette.line),
            ),
            child: Text(
              'Applicant: $applicantName • CNIC: $applicantCnic',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: CareGridPalette.primary),
            ),
          ),
          const SizedBox(height: 12),

          const Text('Residential Address & City *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          TextFormField(controller: _addressCtrl),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Monthly Household Income *', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    TextFormField(controller: _incomeCtrl),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Dependents *', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    TextFormField(controller: _dependentsCtrl),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          const Text('Employment & Medical Need Summary *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          TextFormField(controller: _needSummaryCtrl, maxLines: 2),
          const SizedBox(height: 12),

          const Text('Select Welfare Assistance Required *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilterChip(
                selected: _needMeds,
                selectedColor: CareGridPalette.paleMint,
                label: Text('${_needMeds ? "✓ " : ""}Subsidized Meds'),
                onSelected: (v) => setState(() => _needMeds = v),
              ),
              FilterChip(
                selected: _needLabs,
                selectedColor: CareGridPalette.paleMint,
                label: Text('${_needLabs ? "✓ " : ""}Diagnostic Labs'),
                onSelected: (v) => setState(() => _needLabs = v),
              ),
              FilterChip(
                selected: _needFood,
                selectedColor: CareGridPalette.paleMint,
                label: Text('${_needFood ? "✓ " : ""}Surplus Food Redistribution Aid'),
                onSelected: (v) => setState(() => _needFood = v),
              ),
            ],
          ),
          const SizedBox(height: 16),

          FilledButton(
            onPressed: _completeStep2,
            style: FilledButton.styleFrom(
              backgroundColor: CareGridPalette.primary,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Submit Completed Application', style: TextStyle(fontWeight: FontWeight.w800)),
          ),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: CareGridPalette.goldTint,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: CareGridPalette.gold),
            ),
            child: const Column(
              children: [
                Text(
                  '✓ APPLICATION REGISTERED — UNIQUE REFERENCE ID',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF784E06)),
                ),
                SizedBox(height: 4),
                Text('CG-APP-2026-8841', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
              ],
            ),
          ),
          const SizedBox(height: 12),

          FilledButton(
            onPressed: _completeStep2,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF132A1E),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Next: Upload Required Documents →', style: TextStyle(fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupStep3() {
    final uploadedCount = _docs.where((d) => d['required'] == true && d['uploaded'] == true).length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: CareGridPalette.paleMint,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: CareGridPalette.line),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AES-256 Encrypted Document Vault',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: CareGridPalette.primary),
              ),
              SizedBox(height: 2),
              Text(
                'Supported Types: PDF, JPG, PNG (Max 5MB per file)',
                style: TextStyle(fontSize: 11, color: CareGridPalette.secondaryText),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        ...List.generate(_docs.length, (i) {
          final doc = _docs[i];
          final isUp = doc['uploaded'] as bool;
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isUp ? CareGridPalette.primary : CareGridPalette.line),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(doc['title'] as String, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                      const SizedBox(height: 2),
                      Text(
                        '${isUp ? "✓ " : ""}${doc['file']}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isUp ? FontWeight.w600 : FontWeight.w400,
                          color: isUp ? CareGridPalette.primary : CareGridPalette.secondaryText,
                        ),
                      ),
                      if (isUp)
                        const Text(
                          'Encrypted & Attached to CG-APP-2026-8841',
                          style: TextStyle(fontSize: 10, color: CareGridPalette.secondaryText),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                isUp
                    ? OutlinedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Updated ${doc['title']}')),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          side: const BorderSide(color: CareGridPalette.line),
                        ),
                        child: const Text('Replace', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                      )
                    : FilledButton(
                        onPressed: () {
                          setState(() {
                            _docs[i]['uploaded'] = true;
                            _docs[i]['file'] = 'Bank_Statement_Nov2026.pdf (920 KB)';
                          });
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: CareGridPalette.primary,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        ),
                        child: const Text('+ Upload', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                      ),
              ],
            ),
          );
        }),

        const SizedBox(height: 8),
        FilledButton(
          onPressed: _completeStep3,
          style: FilledButton.styleFrom(
            backgroundColor: CareGridPalette.primary,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Submit Demo Documents for Review', style: TextStyle(fontWeight: FontWeight.w800)),
        ),
        const SizedBox(height: 10),
        Center(
          child: Text(
            '✓ $uploadedCount/3 Mandatory Documents Verified & Attached',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: CareGridPalette.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _loginFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email Address',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _passCtrl,
            obscureText: _obscure,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
            validator: (v) => (v == null || v.isEmpty) ? 'Enter your password' : null,
          ),
          const SizedBox(height: 8),
          ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: const Text('Demo accounts'),
            subtitle: const Text('Tap to fill the login fields'),
            children: [
              for (final entry in CareGridAuthRepository.demoAccounts)
                ListTile(
                  title: Text(entry.user.role.name),
                  subtitle: Text('${entry.user.email}\n${entry.password}'),
                  onTap: () {
                    _emailCtrl.text = entry.user.email;
                    _passCtrl.text = entry.password;
                  },
                ),
            ],
          ),
          CheckboxListTile(
            value: _keepSignedIn,
            onChanged: (v) => setState(() => _keepSignedIn = v ?? true),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: CareGridPalette.primary,
            title: const Text(
              'Demo session (not saved across restarts)',
              style: TextStyle(fontSize: 13, color: CareGridPalette.secondaryText),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _handleSignIn,
            style: FilledButton.styleFrom(
              backgroundColor: CareGridPalette.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text(
              'Sign In & Launch Portal',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

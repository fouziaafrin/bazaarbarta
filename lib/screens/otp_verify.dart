import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../services/auth_service.dart';

class OtpVerify extends StatefulWidget {
  final String verificationId;
  final String phone;
  const OtpVerify({super.key, required this.verificationId, required this.phone});

  @override
  State<OtpVerify> createState() => _OtpVerifyState();
}

class _OtpVerifyState extends State<OtpVerify> {
  final TextEditingController _otpCtrl = TextEditingController();
  bool _verifying = false;

  void _verify() async {
    final code = _otpCtrl.text.trim();
    if (code.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('invalid_otp'.tr())));
      return;
    }
    setState(() => _verifying = true);
    try {
      await AuthService.verifyOtp(verificationId: widget.verificationId, smsCode: code);
      setState(() => _verifying = false);
      Navigator.of(context).pushReplacementNamed('/home');
    } on Exception catch (e) {
      setState(() => _verifying = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('invalid_otp'.tr())));
    }
  }

  @override
  void dispose() {
    _otpCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('verify_otp'.tr())),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('${'enter_otp'.tr()} (${widget.phone})'),
            const SizedBox(height: 12),
            TextField(
              controller: _otpCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'enter_otp'.tr()),
            ),
            const SizedBox(height: 16),
            _verifying
                ? const CircularProgressIndicator()
                : ElevatedButton(onPressed: _verify, child: Text('verify_otp'.tr())),
          ],
        ),
      ),
    );
  }
}

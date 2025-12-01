import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../services/auth_service.dart';
import 'otp_verify.dart';

class PhoneLogin extends StatefulWidget {
  const PhoneLogin({super.key});
  @override
  State<PhoneLogin> createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {
  final TextEditingController _phoneCtrl = TextEditingController();
  bool _sending = false;

  void _sendOtp() async {
  final raw = _phoneCtrl.text.trim();
  final digits = raw.replaceAll(RegExp(r'\D'), ''); // remove non-digits

  if (digits.length < 9) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('invalid_phone'.tr())),
    );
    return;
  }

  String phone;
  if (digits.startsWith('0')) {
    phone = '+88${digits.substring(1)}'; // 01234567890 -> +8801234567890
  } else if (digits.length == 10) {
    phone = '+88$digits'; // 1234567890 -> +881234567890
  } else if (digits.startsWith('88')) {
    phone = '+$digits'; // 8801234567890 -> +8801234567890
  } else if (digits.startsWith('1')) {
    phone = '+88$digits'; // 1712345678 -> +881712345678
  } else {
    phone = '+88$digits'; // fallback
  }

  setState(() => _sending = true);

  await AuthService.sendOtp(
    phone: phone,
    onCodeSent: (verificationId, _) {
      setState(() => _sending = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('otp_sent'.tr())),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpVerify(verificationId: verificationId, phone: phone),
        ),
      );
    },
    onVerificationFailed: (e) {
      setState(() => _sending = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('otp_failed'.tr(args: [e.message ?? e.code]))),
      );
    },
    onAutoVerified: () {
      Navigator.of(context).pushReplacementNamed('/home');
    },
  );
}

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('appTitle'.tr())),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'phone_hint'.tr(),
                //prefixText: '+88',
              ),
            ),
            const SizedBox(height: 16),
            _sending
                ? Column(children: [CircularProgressIndicator(), SizedBox(height: 8), Text('logging_in'.tr())])
                : ElevatedButton(
                    onPressed: _sendOtp,
                    child: Text('send_otp'.tr()),
                  ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:netraya/constants/app_settings.dart';
import 'package:netraya/providers/auth_screen_provider.dart';
import 'package:netraya/screens/otp_screen.dart';
import 'package:provider/provider.dart';

class FormOtp extends StatelessWidget {
  const FormOtp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String noHp = '';

    void sendOtp() {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        Navigator.of(context).pushNamed(OtpScreen.routeName, arguments: noHp);
      }
    }

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Masukkan nomor telepon anda untuk login ke aplikasi Netraya'),
          const SizedBox(
            height: AppSettings.appMainPadding,
          ),
          const Text('Nomor Hp'),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty || value.length < 8) {
                return 'Masukan no hp yang benar';
              }
            },
            onSaved: ((newValue) {
              noHp = newValue!;
            }),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(0),
              isDense: true,
              prefixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [Text('+62')],
              ),
              hintText: 'xxxx-xxxx-xxx',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(
            height: 16,
          ),
          Consumer<AuthScreenProvider>(
            builder: (context, value, child) => ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.red[900],
                minimumSize: const Size.fromHeight(44),
              ),
              onPressed: value.isLoading ? null : sendOtp,
              child: value.isLoading ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator()) : const Text('Kirimkan Kode OTP'),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:netraya/constants/app_colors.dart';
import 'package:netraya/providers/app_user_provider.dart';
import 'package:provider/provider.dart';

class EditPasswordScreen extends StatelessWidget {
  const EditPasswordScreen({Key? key}) : super(key: key);
  static const routeName = '/edit_password';

  @override
  Widget build(BuildContext context) {
    final appUserProvider = Provider.of<AppUserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Password',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Form(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Password Lama',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 6),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.black12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.black12),
                    ),
                    hintText: 'Masukan password',
                    hintStyle: const TextStyle(fontSize: 14)),
              ),
              const SizedBox(height: 12),
              const Text(
                'Password Baru',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 6),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.black12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.black12),
                    ),
                    hintText: 'Masukan password',
                    hintStyle: const TextStyle(fontSize: 14)),
              ),
              const SizedBox(height: 12),
              const Text(
                'Konfirmasi Password Baru',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 6),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.black12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.black12),
                    ),
                    hintText: 'Masukan password',
                    hintStyle: const TextStyle(fontSize: 14)),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.darkRed,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(side: const BorderSide(color: AppColors.darkRed), borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    'Simpan',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:netraya/constants/app_colors.dart';
import 'package:netraya/providers/app_user_provider.dart';
import 'package:netraya/services/user_service.dart';
import 'package:netraya/widgets/user_profile_picture.dart';
import 'package:netraya/widgets/widget_functions.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);
  static const routeName = '/edit_profile';

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late String name;
  final _formKey = GlobalKey<FormState>();
  final userService = UserService();
  final ImagePicker _picker = ImagePicker();
  late AppUserProvider appUserProvider;
  XFile? image;

  @override
  void didChangeDependencies() {
    appUserProvider = Provider.of<AppUserProvider>(context);
    name = appUserProvider.appUser.name;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appLocalizations.editProfile,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
        ),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: () async {
                    XFile? selectedImage =
                        await _picker.pickImage(source: ImageSource.gallery);
                    if (selectedImage != null) {
                      setState(() {
                        image = selectedImage;
                      });
                    }
                  },
                  child: image == null
                      ? const UserProfilePicture(width: 120, radius: 60)
                      : CircleAvatar(
                          radius: 60,
                          backgroundImage: FileImage(
                            File(image!.path),
                          ),
                        ),
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              Text(
                appLocalizations.name,
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 6),
              TextFormField(
                initialValue: name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '${appLocalizations.name} ${appLocalizations.mustBeFilled}';
                  }
                },
                onSaved: (newValue) => name = newValue!,
                decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.black12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.black12),
                    ),
                    hintText: appLocalizations.name,
                    hintStyle: const TextStyle(fontSize: 14)),
              ),
              const SizedBox(height: 12),
              Text(
                appLocalizations.position,
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 6),
              TextFormField(
                initialValue: appUserProvider.appUser.role,
                enabled: false,
                style: const TextStyle(color: Colors.black45),
                decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.black12),
                    ),
                    hintText: 'Jabatan',
                    hintStyle:
                        const TextStyle(fontSize: 14, color: Colors.black12)),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      loadingDialog(context);
                      userService
                          .updateProfile(name: name, xFile: image)
                          .then((value) => Navigator.of(context).pop());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.darkRed,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(color: AppColors.darkRed),
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(
                    appLocalizations.save,
                    style: const TextStyle(
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

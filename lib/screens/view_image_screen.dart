import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:netraya/widgets/absensi/camera_screen.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ViewImageScreen extends StatelessWidget {
  const ViewImageScreen({Key? key, this.localPath, this.urlPath}) : super(key: key);
  final String? localPath;
  final String? urlPath;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    if (localPath == null && urlPath == null) {
      Navigator.of(context).pop();
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              bottom: 0,
              child: localPath != null ? Image.file(File(localPath!)) : CachedNetworkImage(imageUrl: urlPath!),
            ),
            Positioned(
              top: MediaQuery.of(context).viewPadding.top + 16,
              left: 16,
              child: CustomBackButton(
                onTap: () => Navigator.of(context).pop(),
              ),
            ),
            const Positioned(
              bottom: 32,
              left: 10,
              right: 10,
              child: Text(
                'Pastikan wajah anda terfoto dengan jelas',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}

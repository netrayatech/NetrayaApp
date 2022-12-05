import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:netraya/constants/app_colors.dart';

Future loadingDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: const SizedBox(
        width: 50,
        height: 50,
        child: Center(child: CircularProgressIndicator()),
      ),
    ),
  );
}

Future infoDialog(BuildContext context, String text) async {
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Text(
        text,
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Tutup',
            ))
      ],
    ),
  );
}

Future simpleAlertDialogWithIcon(BuildContext context, String text, IconData iconData) async {
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            iconData,
            color: AppColors.darkRed,
            size: 40,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.darkRed),
          ),
          const SizedBox(
            height: 8,
          ),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Tutup',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Future customAlertDialog({required BuildContext context, required Widget child, String? buttonText, Function()? btnOnPressed}) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          child,
          const SizedBox(
            height: 16,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: btnOnPressed ?? () => Navigator.of(context).pop(),
              child: Text(
                buttonText ?? 'Tutup',
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Future customSuccessDialog({required BuildContext context, required String title, required String body, Function()? btnOnPresss, String? btnText}) async {
  await customAlertDialog(
    context: context,
    child: Column(
      children: [
        SvgPicture.asset('assets/svg/check_2.svg'),
        const SizedBox(
          height: 12,
        ),
        Text(
          title,
          style: const TextStyle(color: Colors.lightGreen, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          body,
          style: const TextStyle(color: Colors.black54),
          textAlign: TextAlign.center,
        )
      ],
    ),
    buttonText: btnText,
    btnOnPressed: btnOnPresss,
  );
}

Future showFormError(BuildContext context) async {
  await customAlertDialog(
    context: context,
    child: Column(
      children: [
        SvgPicture.asset('assets/svg/warning.svg'),
        const SizedBox(
          height: 12,
        ),
        const Text(
          'Mohon Lengkapi Data',
          style: TextStyle(color: AppColors.yellow, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
        ),
        const Text(
          'Terdapat data yang masih kosong, mohon lengkapi data untuk melanjutkan',
          style: TextStyle(color: Colors.black54),
          textAlign: TextAlign.center,
        )
      ],
    ),
  );
}

Future showValidationError(BuildContext context, String errorMessage) async {
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(
          Icons.error,
          color: Colors.red,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          errorMessage,
          style: const TextStyle(color: Colors.redAccent),
        ),
        SizedBox(
          width: double.infinity,
          child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Mengerti',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                textAlign: TextAlign.center,
              )),
        )
      ]),
    ),
  );
}

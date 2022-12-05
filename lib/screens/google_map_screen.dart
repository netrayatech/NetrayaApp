import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:netraya/constants/app_colors.dart';
import 'package:netraya/constants/app_settings.dart';
import 'package:netraya/models/absen.dart';
import 'package:netraya/models/app_user.dart';
import 'package:netraya/models/settings.dart';
import 'package:netraya/services/settings_service.dart';
import 'package:netraya/widgets/absensi/camera_screen.dart';
import 'package:netraya/widgets/user_profile_picture.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({Key? key}) : super(key: key);
  static const routeName = '/maps';

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  final List<Marker> _markers = <Marker>[];
  bool isInitState = true;
  late Absen absen;
  late AppUserTemp appUser;
  late AppLocalizations appLocalizations;

  final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 16,
  );

  @override
  void didChangeDependencies() {
    if (isInitState) {
      appLocalizations = AppLocalizations.of(context)!;
      final args = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
      absen = args[0];
      appUser = args[1];
      if (absen.clockInGeoPoint != null) {
        _markers.add(Marker(
          markerId: const MarkerId('clockIn'),
          position: LatLng(absen.clockInGeoPoint!.latitude,
              absen.clockInGeoPoint!.longitude),
          infoWindow: InfoWindow(title: appLocalizations.clockIn),
        ));
      }
      if (absen.clockOutGeoPoint != null) {
        _markers.add(Marker(
            markerId: const MarkerId('clockOut'),
            position: LatLng(absen.clockOutGeoPoint!.latitude,
                absen.clockOutGeoPoint!.longitude),
            infoWindow: InfoWindow(title: appLocalizations.clockOut)));
      }
      _controller.future.then((value) {
        value.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: _markers.last.position, zoom: 16)));
      });
      isInitState = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: _kGooglePlex,
              markers: Set<Marker>.of(_markers),
              zoomControlsEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
            Positioned(
              top: MediaQuery.of(context).viewPadding.top + 16,
              left: 16,
              child: CustomBackButton(
                onTap: () => Navigator.of(context).pop(),
              ),
            ),
            Positioned(
              bottom: AppSettings.appMainPadding,
              left: AppSettings.appMainPadding,
              right: AppSettings.appMainPadding,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OtherUserProfilePicture(
                        width: 20, radius: 20, url: appUser.photoUrl),
                    const SizedBox(
                      width: 6,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 60,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              appUser.name,
                              style: const TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                            FutureBuilder(
                              future: SettingsService().getGeneralData(),
                              builder:
                                  (context, AsyncSnapshot<General?> snapshot) {
                                String officeHours = '';
                                if (snapshot.connectionState !=
                                    ConnectionState.waiting) {
                                  if (snapshot.hasData) {
                                    switch (appUser.shift) {
                                      case 1:
                                        officeHours =
                                            '${snapshot.data!.shift1['start']} - ${snapshot.data!.shift1['end']}';
                                        break;
                                      case 2:
                                        officeHours =
                                            '${snapshot.data!.shift2['start']} - ${snapshot.data!.shift2['end']}';
                                        break;
                                      default:
                                        officeHours =
                                            '${snapshot.data!.normalShift['start']} - ${snapshot.data!.normalShift['end']}';
                                    }
                                  }
                                }
                                return Text(
                                  '${appLocalizations.officeHours} (${snapshot.connectionState == ConnectionState.waiting ? '' : officeHours})',
                                  style: const TextStyle(
                                      fontSize: 11, color: Colors.black45),
                                );
                              },
                            ),
                            Text(
                              '${appLocalizations.clockIn} ${absen.clockIn!.hour}:${absen.clockIn!.minute}',
                              style: const TextStyle(
                                  fontSize: 11, color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 130,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                color: AppColors.darkRed,
                                size: 16,
                              ),
                              Text(
                                absen.clockInLocation,
                                style: const TextStyle(
                                    fontSize: 11, color: AppColors.darkRed),
                              ),
                            ],
                          ),
                          absen.clockIn != null
                              ? Text(
                                  '${absen.clockIn!.hour}:${absen.clockIn!.minute}:${absen.clockIn!.second}',
                                  style: const TextStyle(
                                      fontSize: 11, color: Colors.black87),
                                )
                              : Container(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

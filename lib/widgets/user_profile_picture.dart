import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:netraya/providers/app_user_provider.dart';
import 'package:provider/provider.dart';

class UserProfilePicture extends StatelessWidget {
  const UserProfilePicture(
      {Key? key, required this.width, required this.radius})
      : super(key: key);
  final double width;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final appUserProvider = Provider.of<AppUserProvider>(context);
    return appUserProvider.appUser.photoUrl.isEmpty
        ? Container(
            width: width,
            height: width,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.white),
            child: const Icon(Icons.person),
          )
        : CachedNetworkImage(
            imageUrl: appUserProvider.appUser.photoUrl,
            imageBuilder: (context, imageProvider) => CircleAvatar(
              backgroundImage: imageProvider,
              minRadius: radius,
              maxRadius: radius,
            ),
            placeholder: (context, url) => Container(
              width: width,
              height: width,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white),
              child: const CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) {
              return Container(
                width: width,
                height: width,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.white),
                child: const Icon(Icons.person),
              );
            },
          );
  }
}

class OtherUserProfilePicture extends StatelessWidget {
  const OtherUserProfilePicture(
      {Key? key, required this.width, required this.radius, required this.url})
      : super(key: key);
  final double width;
  final double radius;
  final String url;

  @override
  Widget build(BuildContext context) {
    return url.isEmpty
        ? Container(
            width: width,
            height: width,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.white),
            child: const Icon(Icons.person),
          )
        : CachedNetworkImage(
            imageUrl: url,
            imageBuilder: (context, imageProvider) => CircleAvatar(
              backgroundImage: imageProvider,
              minRadius: radius,
              maxRadius: radius,
            ),
            placeholder: (context, url) => Container(
              width: width,
              height: width,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white),
              child: const CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) {
              return Container(
                width: width,
                height: width,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.white),
                child: const Icon(Icons.person),
              );
            },
          );
  }
}

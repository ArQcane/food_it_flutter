import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_it_flutter/providers_viewmodels/authentication_provider.dart';
import 'package:food_it_flutter/ui/theme/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../domain/user/user.dart';

class ProfileImagePicker extends StatefulWidget {
  final User user;
  const ProfileImagePicker({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<ProfileImagePicker> createState() => _ProfilePicturePickerState();
}

class _ProfilePicturePickerState extends State<ProfileImagePicker> {
  bool _isUpdatingImage = false;

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthenticationProvider>(context);
    var currentUser = authProvider.user;

    return Stack(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            border: Border.all(
              color:
              primary
              ,
              width: 2,
            ),
            shape: BoxShape.circle,
          ),
          child: _isUpdatingImage
              ? Center(
            child: CircularProgressIndicator(
              color: Theme
                  .of(context)
                  .brightness == Brightness.dark
                  ? primaryAccent
                  : Colors.white,
            ),
          )
              : widget.user.profile_pic == null
              ? const Icon(
            Icons.person,
            color: Colors.white,
            size: 100,
          )
              : ClipOval(
            child: authProvider.imageFromBase64String(widget.user.profile_pic!),
          ),
        ),
        if (currentUser != null && currentUser.user_id == widget.user.user_id)
          Positioned(
            bottom: 5,
            right: 5,
            child: Material(
              elevation: 4,
              color: Theme
                  .of(context)
                  .brightness == Brightness.dark
                  ? ElevationOverlay.colorWithOverlay(
                Theme
                    .of(context)
                    .colorScheme
                    .surface,
                Colors.white,
                50,
              )
                  : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                onTap: () async {
                  var picker = ImagePicker();
                  var image = await picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (image == null) return;
                  setState(() {
                    _isUpdatingImage = true;
                  });
                  var bytes = await image.readAsBytes();
                  var base64img = base64Encode(bytes);
                  await Provider.of<AuthenticationProvider>(
                    context,
                    listen: false,
                  ).updateAccountCredentials(
                    widget.user.user_id.toString(),
                    widget.user.first_name,
                    widget.user.last_name,
                    widget.user.mobile_number,
                    widget.user.address,
                    base64img,
                  );
                  await authProvider.getCurrentLoggedInUser();
                  setState(() {
                    _isUpdatingImage = false;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(3),
                  child: ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (rect) {
                      return const LinearGradient(
                        colors: [primaryAccent, primary],
                      ).createShader(
                        Rect.fromLTWH(0, 0, rect.width, rect.height),
                      );
                    },
                    child: const Icon(
                      Icons.camera_alt,
                    ),
                  ),
                ),
              ),
            ),
          )
      ],
    );
  }
}
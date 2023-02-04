import 'package:flutter/material.dart';
import 'package:food_it_flutter/providers_viewmodels/authentication_provider.dart';
import 'package:food_it_flutter/ui/components/extras/action_button.dart';
import 'package:food_it_flutter/ui/screens/profile/update/profile_image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../data/exceptions/default_exception.dart';
import '../../../../data/exceptions/field_exception.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  int userId = 0;
  String profilePic = "";
  String firstName = "";
  String? firstNameError;
  String lastName = "";
  String? lastNameError;
  int mobileNumber = 65;
  String? mobileNumberError;
  String address = "";
  String? addressError;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    var authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    userId = authProvider.user!.user_id;
    profilePic = authProvider.user!.profile_pic!;
    firstName = authProvider.user!.first_name;
    lastName = authProvider.user!.last_name;
    mobileNumber = authProvider.user!.mobile_number;
    address = authProvider.user!.address;
  }

  void submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<AuthenticationProvider>(context, listen: false).updateAccountCredentials(
        userId.toString(),
        firstName,
        lastName,
        mobileNumber,
        address,
        profilePic,
      );
    } on DefaultException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.error),
        ),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    } on FieldException catch (e) {
      var firstNameError = e.fieldErrors.where(
            (element) => element.field == "first_name",
      );
      var lastNameError = e.fieldErrors.where(
            (element) => element.field == "last_name",
      );
      var mobileNumberError = e.fieldErrors.where(
            (element) => element.field == "mobile_number",
      );
      var addressError = e.fieldErrors.where(
            (element) => element.field == "address",
      );
      setState(() {
        _isLoading = false;
        if (firstNameError.length == 1) {
          this.firstNameError = firstNameError.first.error;
        }
        if (lastNameError.length == 1) {
          this.lastNameError = lastNameError.first.error;
        }
        if (mobileNumberError.length == 1) {
          this.mobileNumberError = mobileNumberError.first.error;
        }
        if (addressError.length == 1) {
          this.addressError = addressError.first.error;
        }
      });
      return;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong'),
        ),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }
    setState(() {
      _isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthenticationProvider>(context);
    var currentUser = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                ProfileImagePicker(user: currentUser!),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: currentUser.first_name,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    border: const OutlineInputBorder(),
                    errorText: firstNameError,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'First name is required';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if (firstNameError == null) return;
                    setState(() {
                      firstNameError = null;
                    });
                  },
                  onSaved: (value) {
                    setState(() {
                      firstName = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: currentUser.last_name,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    border: const OutlineInputBorder(),
                    errorText: lastNameError,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Last name is required';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if (lastNameError == null) return;
                    setState(() {
                      lastNameError = null;
                    });
                  },
                  onSaved: (value) {
                    setState(() {
                      lastName = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: currentUser.mobile_number.toString(),
                  decoration: InputDecoration(
                    labelText: 'Mobile Number',
                    border: const OutlineInputBorder(),
                    errorText: mobileNumberError,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Mobile Number is required';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if (mobileNumberError == null) return;
                    setState(() {
                      mobileNumberError = null;
                    });
                  },
                  onSaved: (value) {
                    setState(() {
                      mobileNumber = int.parse(value!);
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: currentUser.address,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Address required';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if (addressError == null) return;
                    setState(() {
                      addressError = null;
                    });
                  },
                  onSaved: (value) {
                    setState(() {
                      address = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                ActionButton(
                  onClick: submit,
                  isLoading: _isLoading,
                  text: "Update Profile Credentials",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
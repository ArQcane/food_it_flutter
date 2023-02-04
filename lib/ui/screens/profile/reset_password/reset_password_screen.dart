import 'package:flutter/material.dart';
import 'package:food_it_flutter/providers_viewmodels/authentication_provider.dart';
import 'package:food_it_flutter/ui/components/extras/action_button.dart';
import 'package:food_it_flutter/ui/theme/colors.dart';
import 'package:provider/provider.dart';

import '../../../../data/exceptions/default_exception.dart';
import '../../../../data/exceptions/field_exception.dart';
import '../../../components/extras/rive_animations/rive_animated_check.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  String oldPassword = '';
  String? oldPasswordError;
  bool _isUpdatingPassword = false;
  bool _onSucceed = false;

  bool _obscureTextOld = true;

  void submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() {
      _isUpdatingPassword = true;
    });
    var authProvider = Provider.of<AuthenticationProvider>(
        context, listen: false);
    try {
      await authProvider.login(authProvider.user!.username, oldPassword);
    } on DefaultException catch (e) {
      setState(() {
        oldPasswordError = e.error;
        _isUpdatingPassword = false;
      });
      return;
    } on FieldException catch (e) {
      var passwordError = e.fieldErrors.where(
            (element) => element.field == 'password',
      );
      setState(() {
        if (passwordError.length == 1) {
          oldPasswordError = passwordError.first.error;
        }
        _isUpdatingPassword = false;
      });
      return;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong'),
        ),
      );
      setState(() {
        _isUpdatingPassword = false;
      });
      return;
    }

    try {
      await authProvider.updatePassword(authProvider.user!.email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'A email has been sent to the address this account was registered under'),
        ),
      );
      setState(() {
        _isUpdatingPassword = false;
        _onSucceed = true;
      });
      await Future.delayed(Duration(seconds: 1, milliseconds: 500));
      setState(() {
        _onSucceed = false;
      });
    } on DefaultException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.error),
        ),
      );
      setState(() {
        _isUpdatingPassword = false;
      });
    } on FieldException catch (e) {
      var passwordError = e.fieldErrors.where(
            (element) => element.field == 'password',
      );
      setState(() {
        _isUpdatingPassword = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong'),
        ),
      );
      setState(() {
        _isUpdatingPassword = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Password'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                ShaderMask(
                  shaderCallback: (bounds) =>
                      const LinearGradient(
                        colors: [primaryAccent, primary],
                      ).createShader(bounds),
                  child: const Icon(
                    Icons.lock,
                    size: 200,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Old Password',
                    border: const OutlineInputBorder(),
                    errorText: oldPasswordError,
                    suffixIcon: IconButton(
                      icon: _obscureTextOld
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _obscureTextOld = !_obscureTextOld;
                        });
                      },
                    ),
                  ),
                  textInputAction: TextInputAction.done,
                  obscureText: _obscureTextOld,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Old password is required';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      oldPasswordError = null;
                    });
                  },
                  onSaved: (value) {
                    oldPassword = value!;
                  },
                ),
                const SizedBox(height: 16),
                if(_onSucceed)
                  RiveAnimationCheck()
                else
                  ActionButton(
                    onClick: submit,
                    text: "Submit",
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
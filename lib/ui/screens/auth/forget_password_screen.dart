import 'package:flutter/material.dart';
import 'package:food_it_flutter/providers_viewmodels/authentication_provider.dart';
import 'package:food_it_flutter/ui/components/extras/action_button.dart';
import 'package:food_it_flutter/ui/components/extras/gradient_text.dart';
import 'package:food_it_flutter/ui/theme/colors.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart' as ra;

import '../../../data/exceptions/default_exception.dart';
import '../../../data/exceptions/field_exception.dart';
import '../../components/extras/gradient_text.dart';
import '../../utils/validation/regex_vals.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _form = GlobalKey<FormState>();
  var _email = "";
  String? _emailError;
  var _isLoading = false;

  void submit() async {
    print(_email);
    FocusScope.of(context).unfocus();
    if (_form.currentState?.validate() == false) return;
    _form.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    try {
      var provider =
          Provider.of<AuthenticationProvider>(context, listen: false);
      await provider.updatePassword(_email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Reset password link sent to your email")),
      );
      setState((){
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } on FieldException catch (e) {
      var emailError = e.fieldErrors.where((element) {
        return element.field == "email";
      }).toList();
      setState(() {
        _isLoading = false;
        if (emailError.length == 1) _emailError = emailError[0].error;
      });
    } on DefaultException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.error)),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong")),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password?"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _form,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          children: [
                            GradientText(
                              text: "Reset Password?",
                            ),
                            Text(
                                "Enter the email associated with\nyour account and we'll send an\nemail with instructions to\n reset your password.")
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [primaryAccent, primary],
                        ).createShader(bounds),
                        child: Image.asset(
                          "assets/foodit-website-favicon-color.png",
                          height: 175,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  height: 300,
                  color: background,
                  child: const ra.RiveAnimation.asset(
                    "assets/rive/1435-2808-scrolling-letter.riv",
                    fit: BoxFit.fill,
                  ),
                ),
                Text(
                  "Upon sendng the instructions to the email \n please check your email address.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 20,
                      ),
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "Email",
                              border: const OutlineInputBorder(),
                              errorText: _emailError,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Email is required";
                              }
                              var regex = RegExp(emailRegex);
                              if (!regex.hasMatch(value)) {
                                return "Email is invalid";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _email = value ?? "";
                            },
                            onChanged: (value) {
                              setState(() {
                                _emailError = null;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          ActionButton(
                            onClick: submit,
                            text: "Reset Password",
                            isLoading: _isLoading,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

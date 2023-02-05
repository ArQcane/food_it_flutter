import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:food_it_flutter/providers_viewmodels/authentication_provider.dart';
import 'package:food_it_flutter/ui/components/extras/action_button.dart';
import 'package:food_it_flutter/ui/screens/auth/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart' as ra;

import '../../../../data/exceptions/default_exception.dart';
import '../../../../data/exceptions/field_exception.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({Key? key}) : super(key: key);

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  var _password = '';
  String? _passwordError;
  var _passwordVisible = false;
  var _isLoading = false;

  void submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      var authProvider = Provider.of<AuthenticationProvider>(
          context, listen: false);
      await authProvider.login(authProvider.user!.username, _password);
    } on DefaultException catch (e) {
      setState(() {
        _passwordError = e.error;
        _isLoading = false;
      });
      return;
    } on FieldException catch (e) {
      var passwordError = e.fieldErrors.where(
            (element) => element.field == 'password',
      );
      setState(() {
        if (passwordError.length == 1) {
          _passwordError = passwordError.first.error;
        }
        _isLoading = false;
      });
      return;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong'),
        ),
      );
      return;
    }
    try {
      var authProvider = Provider.of<AuthenticationProvider>(
          context, listen: false);
      await authProvider.deleteAccount(authProvider.user!.user_id.toString());
      setState((){
        _isLoading = false;
      });
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(animate: false),
        ),
            (_) => false,
      );
    } on FieldException catch (e) {
      var passwordError = e.fieldErrors.where(
            (element) => element.field == 'password',
      );
      setState(() {
        if (passwordError.length == 1) {
          _passwordError = passwordError.first.error;
        }
        _isLoading = false;
      });
    } on DefaultException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.error),
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      log(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong'),
        ),
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
      title: const Text('Delete Account'),
    ),
    body: SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                height: 300,
                width: MediaQuery.of(context).size.width,
                child: const ra.RiveAnimation.asset(
                    "assets/rive/delete-logistics-man-boxes.riv",
                animations: ["Idle"],),
              ),
              const Text(
                'Are you sure you want to delete your account?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'This action cannot be undone.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  errorText: _passwordError,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    splashRadius: 20,
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Password required!';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value!;
                },
              ),
              const SizedBox(height: 16.0),
              ActionButton(
                onClick: submit,
                isLoading: _isLoading,
                gradient: const LinearGradient(
                  colors: [Color(0xFFE60000), Color(0xFFFF5E5E)],
                ),
                text: "Delete Account",
              ),
            ],
          ),
        ),
      ),
    ),
  );
}}
import 'package:flutter/material.dart';
import 'package:food_it_flutter/providers_viewmodels/authentication_provider.dart';
import 'package:food_it_flutter/ui/components/action_button.dart';
import 'package:food_it_flutter/ui/components/gradient_text.dart';
import 'package:food_it_flutter/ui/screens/home_screen.dart';
import 'package:provider/provider.dart';

import '../../data/exceptions/default_exception.dart';
import '../../data/exceptions/field_exception.dart';
import '../theme/colors.dart';
import '../utils/validation/regex_vals.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _firstStageFormKey = GlobalKey();
  final GlobalKey<FormState> _secondStageFormKey = GlobalKey();
  final GlobalKey<FormState> _thirdStageFormKey = GlobalKey();

  Offset _firstStageOffset = const Offset(0, 0);
  Offset _secondStageOffset = const Offset(1.1, 0);
  Offset _thirdStageOffset = const Offset(2.2, 0);

  String _firstName = "";
  String? _firstNameError;
  String _lastName = "";
  String? _lastNameError;
  String _username = "";
  String? _usernameError;
  String _password = "";
  String? _passwordError;
  String _email = "";
  String? _emailError;
  int _mobileNumber = 65;
  String? _mobileNumberError;
  String _gender = "";
  String? _genderError;
  String _address = "";
  String? _addressError;
  String _profilePic = "";
  String? _profilePicError;

  bool _isLoading = false;

  void animateStages(int index) {
    setState(() {
      if (index == 0) {
        _firstStageOffset = const Offset(0, 0);
        _secondStageOffset = const Offset(1.1, 0);
        _thirdStageOffset = const Offset(2.2, 0);
      }
      if (index == 1) {
        _firstStageOffset = const Offset(-1.1, 0);
        _secondStageOffset = const Offset(0.0, 0);
        _thirdStageOffset = const Offset(1.1, 0);
      }
      if (index == 2) {
        _firstStageOffset = const Offset(-2.2, 0);
        _secondStageOffset = const Offset(-1.1, 0);
        _thirdStageOffset = const Offset(0.0, 0);
      }
    });
  }

  void register() async {
    FocusScope.of(context).unfocus();
    var isFirstStageValid = _firstStageFormKey.currentState!.validate();
    var isSecondStageValid = _secondStageFormKey.currentState!.validate();
    var isThirdStageValid = _thirdStageFormKey.currentState!.validate();
    if (!isFirstStageValid || !isSecondStageValid || !isThirdStageValid) {
      if (!isFirstStageValid) animateStages(0);
      if (!isSecondStageValid) animateStages(1);
      return;
    }
    _firstStageFormKey.currentState?.save();
    _secondStageFormKey.currentState?.save();
    _thirdStageFormKey.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    var provider = Provider.of<AuthenticationProvider>(context, listen: false);
    try {
      await provider.register(_firstName, _lastName, _username, _password,
          _email, _mobileNumber, _gender, _address, _profilePic);
    } on DefaultException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.error)),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    } on FieldException catch (e) {
      var firstNameError = e.fieldErrors.where((element) {
        return element.field == "firstName";
      }).toList();
      var lastNameError = e.fieldErrors.where((element) {
        return element.field == "lastName";
      }).toList();
      var usernameError = e.fieldErrors.where((element) {
        return element.field == "username";
      }).toList();
      var passwordError = e.fieldErrors.where((element) {
        return element.field == "password";
      }).toList();
      var emailError = e.fieldErrors.where((element) {
        return element.field == "email";
      }).toList();
      var mobileNumberError = e.fieldErrors.where((element) {
        return element.field == "mobileNumber";
      }).toList();
      var genderError = e.fieldErrors.where((element) {
        return element.field == "gender";
      }).toList();
      var addressError = e.fieldErrors.where((element) {
        return element.field == "address";
      }).toList();
      var profilePicError = e.fieldErrors.where((element) {
        return element.field == "profilePic";
      }).toList();
      setState(() {
        _isLoading = false;
        if (firstNameError.length == 1)
          _firstNameError = firstNameError[0].error;
        if (lastNameError.length == 1) _lastNameError = lastNameError[0].error;
        if (usernameError.length == 1) _usernameError = usernameError[0].error;
        if (passwordError.length == 1) _passwordError = passwordError[0].error;
        if (emailError.length == 1) _emailError = emailError[0].error;
        if (mobileNumberError.length == 1)
          _mobileNumberError = mobileNumberError[0].error;
        if (genderError.length == 1) _genderError = genderError[0].error;
        if (addressError.length == 1) _addressError = addressError[0].error;
        if (profilePicError.length == 1)
          _profilePicError = profilePicError[0].error;
      });
      if (_firstNameError != null ||
          _lastNameError != null ||
          _genderError != null) {
        animateStages(0);
      }
      if (_usernameError != null ||
          _passwordError != null ||
          _emailError != null) {
        animateStages(1);
      }
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Hero(
                tag: "logo",
                child: Container(
                  height: MediaQuery.of(context).size.width + 40,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Image.asset(
                        "assets/foodit-website-favicon-color.png",
                        width: 200,
                        height: 200,
                        fit: BoxFit.fill,
                      ),
                      Expanded(
                        child: const DefaultTextStyle(
                          style: TextStyle(
                            color: primary,
                            fontSize: 54,
                            fontFamily: 'BungeeShade',
                          ),
                          child: Text('FOODIT!'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 450,
                  child: Stack(
                    children: [
                      AnimatedSlide(
                        offset: _firstStageOffset,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.fastOutSlowIn,
                        child: RegisterFirstStage(
                          formKey: _firstStageFormKey,
                          goToLoginPage: () {
                            Navigator.of(context).pop();
                          },
                          animateToNextStage: () => animateStages(1),
                          onFirstNameSaved: (value) => setState(() {
                            _firstName = value;
                          }),
                          onLastNameSaved: (value) => setState(() {
                            _lastName = value;
                          }),
                          onGenderSaved: (value) => setState(() {
                            _gender = value;
                          }),
                          firstNameError: _firstNameError,
                          lastNameError: _lastNameError,
                          genderError: _genderError,
                          setFirstNameError: (value) => setState(() {
                            _firstNameError = value;
                          }),
                          setLastNameError: (value) => setState(() {
                            _lastNameError = value;
                          }),
                          setGenderError: (value) => setState(() {
                            _genderError = value;
                          }),
                        ),
                      ),
                      AnimatedSlide(
                        offset: _secondStageOffset,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.fastOutSlowIn,
                        child: RegisterSecondStage(
                          formKey: _secondStageFormKey,
                          isLoading: _isLoading,
                          animateToPrevStage: () => animateStages(0),
                          animateToNextStage: () => animateStages(2),
                          onUsernameSaved: (value) => setState(() {
                            _username = value;
                          }),
                          onPasswordSaved: (value) => setState(() {
                            _password = value;
                          }),
                          onEmailSaved: (value) => setState(() {
                            _email = value;
                          }),
                          usernameError: _usernameError,
                          passwordError: _passwordError,
                          emailError: _emailError,
                          setUsernameError: (value) => setState(() {
                            _usernameError = value;
                          }),
                          setPasswordError: (value) => setState(() {
                            _passwordError = value;
                          }),
                          setEmailError: (value) => setState(() {
                            _emailError = value;
                          }),
                        ),
                      ),
                      AnimatedSlide(
                        offset: _thirdStageOffset,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.fastOutSlowIn,
                        child: RegisterThirdStage(
                          formKey: _thirdStageFormKey,
                          isLoading: _isLoading,
                          animateToPrevStage: () => animateStages(1),
                          onSubmit: () => register(),
                          onMobileNumberSaved: (value) => setState(() {
                            _mobileNumber = int.parse(value);
                          }),
                          onAddressSaved: (value) => setState(() {
                            _address = value;
                          }),
                          onProfilePicSaved: (value) => setState(() {
                            _profilePic = value;
                          }),
                          mobileNumberError: _mobileNumberError,
                          addressError: _addressError,
                          profilePicError: _profilePicError,
                          setMobileNumberError: (value) => setState(() {
                            _mobileNumberError = value;
                          }),
                          setAddressError: (value) => setState(() {
                            _addressError = value;
                          }),
                          setProfilePicError: (value) => setState(() {
                            _profilePicError = value;
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterFirstStage extends StatefulWidget {
  final void Function() goToLoginPage;
  final void Function() animateToNextStage;
  final void Function(String) onFirstNameSaved;
  final void Function(String) onLastNameSaved;
  final void Function(String) onGenderSaved;
  final GlobalKey<FormState> formKey;
  final String? firstNameError;
  final String? lastNameError;
  final String? genderError;
  final void Function(String?) setFirstNameError;
  final void Function(String?) setLastNameError;
  final void Function(String?) setGenderError;

  const RegisterFirstStage({
    Key? key,
    required this.goToLoginPage,
    required this.animateToNextStage,
    required this.onFirstNameSaved,
    required this.onLastNameSaved,
    required this.onGenderSaved,
    required this.formKey,
    required this.firstNameError,
    required this.lastNameError,
    required this.genderError,
    required this.setFirstNameError,
    required this.setLastNameError,
    required this.setGenderError,
  }) : super(key: key);

  @override
  State<RegisterFirstStage> createState() => _RegisterFirstStageState();
}

class _RegisterFirstStageState extends State<RegisterFirstStage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 20,
          ),
          child: Form(
            key: widget.formKey,
            child: Column(
              children: [
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Are you a new user?",
                      style: TextStyle(
                          color: primary,
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    )),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: GradientText(
                      text: "Make a new Account!",
                      textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900),
                    )),
                const SizedBox(height: 25),
                TextFormField(
                  decoration: InputDecoration(
                    label: const Text("First name"),
                    border: const OutlineInputBorder(),
                    errorText: widget.firstNameError,
                  ),
                  onChanged: (_) {
                    if (widget.firstNameError == null) return;
                    widget.setFirstNameError(null);
                  },
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "First Name required!";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    widget.onFirstNameSaved(value!);
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  decoration: InputDecoration(
                    label: const Text("Last Name"),
                    border: const OutlineInputBorder(),
                    errorText: widget.lastNameError,
                  ),
                  onChanged: (_) {
                    if (widget.lastNameError == null) return;
                    widget.setLastNameError(null);
                  },
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Last Name required!";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    widget.onLastNameSaved(value!);
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  //TODO: Make into radio button
                  decoration: InputDecoration(
                    label: const Text("Gender"),
                    border: const OutlineInputBorder(),
                    errorText: widget.genderError,
                  ),
                  onChanged: (_) {
                    if (widget.genderError == null) return;
                    widget.setGenderError(null);
                  },
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Gender required!";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    widget.onGenderSaved(value!);
                  },
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ActionButton(
                    onClick: () => widget.animateToNextStage(),
                    text: "Next",
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: widget.goToLoginPage,
                    child: const Text("Already own an account?"),
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

class RegisterSecondStage extends StatefulWidget {
  final void Function() animateToPrevStage;
  final void Function() animateToNextStage;
  final void Function(String) onUsernameSaved;
  final void Function(String) onPasswordSaved;
  final void Function(String) onEmailSaved;
  final GlobalKey<FormState> formKey;
  final String? usernameError;
  final String? passwordError;
  final String? emailError;
  final void Function(String?) setUsernameError;
  final void Function(String?) setPasswordError;
  final void Function(String?) setEmailError;
  final bool isLoading;

  const RegisterSecondStage({
    Key? key,
    required this.animateToPrevStage,
    required this.animateToNextStage,
    required this.onUsernameSaved,
    required this.onPasswordSaved,
    required this.onEmailSaved,
    required this.formKey,
    required this.usernameError,
    required this.passwordError,
    required this.emailError,
    required this.setUsernameError,
    required this.setPasswordError,
    required this.setEmailError,
    required this.isLoading,
  }) : super(key: key);

  @override
  State<RegisterSecondStage> createState() => _RegisterSecondStageState();
}

class _RegisterSecondStageState extends State<RegisterSecondStage> {
  String _username = "";
  String _password = "";
  String _email = "";
  bool _passwordObscureText = true;
  bool _confirmPasswordObscureText = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 20,
          ),
          child: Form(
            key: widget.formKey,
            child: Column(
              children: [
                const GradientText(text: "Almost done!"),
                const SizedBox(height: 25),
                TextFormField(
                  decoration: InputDecoration(
                    label: const Text("Username"),
                    border: const OutlineInputBorder(),
                    errorText: widget.usernameError,
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Username required!";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _username = value;
                    if (widget.usernameError == null) return;
                    widget.setUsernameError(null);
                  },
                  onSaved: (value) {
                    widget.onUsernameSaved(value!);
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  decoration: InputDecoration(
                    label: const Text("Password"),
                    border: const OutlineInputBorder(),
                    errorText: widget.passwordError,
                    suffixIcon: IconButton(
                      icon: _passwordObscureText
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off),
                      onPressed: () => setState(() {
                        _passwordObscureText = !_passwordObscureText;
                      }),
                      splashRadius: 20,
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _passwordObscureText,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password required!";
                    }
                    var regex = RegExp(createPasswordRegex);
                    if (!regex.hasMatch(value)) {
                      return "Password should be 8 letters long, contain one special character, number, lowercase and uppercase characters";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _password = value;
                    if (widget.passwordError == null) return;
                    widget.setPasswordError(null);
                  },
                  onSaved: (value) {
                    widget.onPasswordSaved(value!);
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  decoration: InputDecoration(
                    label: const Text("Confirm password"),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: _confirmPasswordObscureText
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off),
                      onPressed: () => setState(() {
                        _confirmPasswordObscureText =
                            !_confirmPasswordObscureText;
                      }),
                      splashRadius: 20,
                    ),
                  ),
                  obscureText: _confirmPasswordObscureText,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.visiblePassword,
                  validator: (value) {
                    if (_password != value) {
                      return "Passwords do not match!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  decoration: InputDecoration(
                    label: const Text("Email"),
                    border: const OutlineInputBorder(),
                    errorText: widget.emailError,
                  ),
                  onChanged: (_) {
                    if (widget.emailError == null) return;
                    widget.setEmailError(null);
                  },
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email required!";
                    }
                    var regex = RegExp(emailRegex);
                    if (!regex.hasMatch(value)) {
                      return "Invalid email!";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    widget.onEmailSaved(value!);
                  },
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: ActionButton(
                        text: "Prev",
                        onClick: () => widget.animateToPrevStage(),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF78BFA6),
                            Color(0xFFA7FEE0),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ActionButton(
                        onClick: () => widget.animateToNextStage(),
                        text: "Next",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterThirdStage extends StatefulWidget {
  final void Function() animateToPrevStage;
  final void Function() onSubmit;
  final void Function(String) onMobileNumberSaved;
  final void Function(String) onAddressSaved;
  final void Function(String) onProfilePicSaved;
  final GlobalKey<FormState> formKey;
  final String? mobileNumberError;
  final String? addressError;
  final String? profilePicError;
  final void Function(String?) setMobileNumberError;
  final void Function(String?) setAddressError;
  final void Function(String?) setProfilePicError;
  final bool isLoading;

  const RegisterThirdStage({
    Key? key,
    required this.animateToPrevStage,
    required this.onSubmit,
    required this.onMobileNumberSaved,
    required this.onAddressSaved,
    required this.onProfilePicSaved,
    required this.formKey,
    required this.mobileNumberError,
    required this.addressError,
    required this.profilePicError,
    required this.setMobileNumberError,
    required this.setAddressError,
    required this.setProfilePicError,
    required this.isLoading,
  }) : super(key: key);

  @override
  State<RegisterThirdStage> createState() => _RegisterThirdStageState();
}

class _RegisterThirdStageState extends State<RegisterThirdStage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 20,
          ),
          child: Form(
            key: widget.formKey,
            child: Column(
              children: [
                const GradientText(text: "Last Steps!"),
                const SizedBox(height: 25),
                TextFormField(
                  decoration: InputDecoration(
                    label: const Text("Mobile Number"),
                    border: const OutlineInputBorder(),
                    errorText: widget.mobileNumberError,
                  ),
                  onChanged: (_) {
                    if (widget.mobileNumberError == null) return;
                    widget.setMobileNumberError(null);
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Mobile Number required!";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    widget.onMobileNumberSaved(value!);
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  decoration: InputDecoration(
                    label: const Text("Address"),
                    border: const OutlineInputBorder(),
                    errorText: widget.addressError,
                  ),
                  onChanged: (_) {
                    if (widget.addressError == null) return;
                    widget.setAddressError(null);
                  },
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Address required!";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    widget.onAddressSaved(value!);
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  decoration: InputDecoration(
                    label: const Text("Profile Picture"),
                    border: const OutlineInputBorder(),
                    errorText: widget.profilePicError,
                  ),
                  onChanged: (_) {
                    if (widget.profilePicError == null) return;
                    widget.setProfilePicError(null);
                  },
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Profile Picture required!";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    widget.onProfilePicSaved(value!);
                  },
                ),
                const SizedBox(height: 50),
                Row(
                  children: [
                    Expanded(
                      child: ActionButton(
                        text: "Prev",
                        onClick: () => widget.animateToPrevStage(),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF78BFA6),
                            Color(0xFFA7FEE0),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ActionButton(
                        onClick: () => widget.onSubmit(),
                        isLoading: widget.isLoading,
                        text: "Register!",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

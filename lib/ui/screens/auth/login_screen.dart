import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_it_flutter/providers_viewmodels/authentication_provider.dart';
import 'package:food_it_flutter/ui/screens/auth/register_screen.dart';
import 'package:food_it_flutter/ui/screens/restaurant/home_screen.dart';
import 'package:food_it_flutter/ui/theme/colors.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

import '../../../data/exceptions/default_exception.dart';
import '../../../data/exceptions/field_exception.dart';
import '../../components/extras/action_button.dart';
import '../../components/extras/gradient_text.dart';
import '../../components/extras/rive_animations/animated_btn.dart';
import '../../main_screen.dart';
import 'forget_password_screen.dart';

class LoginScreen extends StatefulWidget {
  final bool animate;

  const LoginScreen({Key? key, this.animate = true}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  late RiveAnimationController _btnAnimationController;

  bool isShowSignInDialog = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isShowLoading = false;
  bool isShowConfetti = false;
  late SMITrigger error;
  late SMITrigger success;
  late SMITrigger reset;

  late SMITrigger confetti;

  void _onCheckRiveInit(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');

    artboard.addController(controller!);
    error = controller.findInput<bool>('Error') as SMITrigger;
    success = controller.findInput<bool>('Check') as SMITrigger;
    reset = controller.findInput<bool>('Reset') as SMITrigger;
  }

  void _onConfettiRiveInit(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, "State Machine 1");
    artboard.addController(controller!);

    confetti = controller.findInput<bool>("Trigger explosion") as SMITrigger;
  }

  final GlobalKey<FormState> _form = GlobalKey();
  bool _obscureText = true;

  String _username = "";
  String? _usernameError;
  String _password = "";
  String? _passwordError;
  bool _isLoading = false;

  void login() async {
    Future.delayed(const Duration(seconds: 1), () async {
      FocusScope.of(context).unfocus();
      if (_form.currentState?.validate() == false) return;
      _form.currentState?.save();
      setState(() {
        _isLoading = true;
        isShowLoading = true;
        isShowConfetti = true;
      });
      var provider =
          Provider.of<AuthenticationProvider>(context, listen: false);
      try {
        await provider.login(_username, _password);
      } on DefaultException catch (e) {
        error.fire();
        await Future.delayed(
          const Duration(seconds: 2),
              () {
            setState(() {
              isShowLoading = false;
            });
            reset.fire();
          },
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.error)),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      } on FieldException catch (e) {
        var usernameError = e.fieldErrors.where((element) {
          return element.field == "username";
        }).toList();
        var passwordError = e.fieldErrors.where((element) {
          return element.field == "password";
        }).toList();
        setState(() {
          _isLoading = false;
          if (usernameError.length == 1)
            _usernameError = usernameError[0].error;
          if (passwordError.length == 1)
            _passwordError = passwordError[0].error;
        });
        return;
      }
      success.fire();
      Future.delayed(
        const Duration(seconds: 2),
            () {
          confetti.fire();
          // Navigate & hide confetti
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              isShowConfetti = false;
              isShowLoading = false;
            });
            // Navigator.pop(context);
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 1500),
                pageBuilder: (_, __, ___) => const MainScreen(),
              ),
            );
          });
        },
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _btnAnimationController = OneShotAnimation(
      "active",
      autoplay: false,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 700),
      );
      Future.delayed(const Duration(milliseconds: 1000)).then((value) {
        _animation = Tween<double>(
          begin: 3.5,
          end: 1,
        ).animate(
          CurvedAnimation(
            parent: _controller!,
            curve: Curves.fastOutSlowIn,
          ),
        );
        _controller!.addListener(() {
          setState(() {});
        });
        _controller!.forward();
      });
    });
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
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
              isShowLoading
                  ? CustomPositioned(
                child: Container(
                  width: 200,
                  height: 200,
                  child: RiveAnimation.asset(
                    'assets/rive/check.riv',
                    fit: BoxFit.fill,
                    onInit: _onCheckRiveInit,
                  ),
                ),
              )
                  : const SizedBox(),
                isShowConfetti
                    ? CustomPositioned(
                  child: Container(
                    width: 250,
                    height: 250,
                    child: RiveAnimation.asset(
                      'assets/rive/4060-8417-confetti.riv',
                      fit: BoxFit.fill,
                      onInit: _onConfettiRiveInit,
                    ),
                  ),
                )
                    : const SizedBox(),
              Align(
                alignment: widget.animate
                    ? Alignment(0, _animation?.value ?? 3.5)
                    : Alignment.bottomCenter,
                child: Container(
                  height: 425,
                  child: Card(
                    color: secondaryAccent,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 20,
                      ),
                      child: SingleChildScrollView(
                        child: Form(
                          key: _form,
                          child: Column(
                            children: [
                              const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Welcome Back!",
                                    style: TextStyle(
                                        color: primary,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold),
                                  )),
                              const Align(
                                  alignment: Alignment.centerLeft,
                                  child: GradientText(
                                    text: "Log Back In!",
                                    textStyle: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900),
                                  )),
                              const SizedBox(height: 25),
                              TextFormField(
                                decoration: InputDecoration(
                                  label: const Text("Username"),
                                  border: const OutlineInputBorder(),
                                  errorText: _usernameError,
                                ),
                                onChanged: (_) {
                                  if (_usernameError == null) return;
                                  setState(() {
                                    _usernameError = null;
                                  });
                                },
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Username required!";
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _username = value!;
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                decoration: InputDecoration(
                                  label: const Text("Password"),
                                  border: const OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    icon: _obscureText
                                        ? const Icon(Icons.visibility)
                                        : const Icon(Icons.visibility_off),
                                    onPressed: () => setState(() {
                                      _obscureText = !_obscureText;
                                    }),
                                    splashRadius: 20,
                                  ),
                                  errorText: _passwordError,
                                ),
                                onChanged: (_) {
                                  if (_passwordError == null) return;
                                  setState(() {
                                    _passwordError = null;
                                  });
                                },
                                obscureText: _obscureText,
                                keyboardType: TextInputType.visiblePassword,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Password required!";
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _password = value!;
                                },
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const ForgetPasswordScreen(),
                                    ),
                                  ),
                                  child: const Text("Forgot password?"),
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: AnimatedBtn(
                                  text: "Login",
                                  btnAnimationController: _btnAnimationController,
                                  isLoading: _isLoading,
                                  press: () {
                                    _btnAnimationController.isActive = true;
                                    login();
                                  },
                                ),
                              ),
                              const SizedBox(height: 5),
                              Align(
                                alignment: Alignment.center,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                        transitionDuration:
                                        const Duration(milliseconds: 1500),
                                        pageBuilder: (_, __, ___) =>
                                        const RegisterScreen(),
                                      ),
                                    );
                                  },
                                  child: Text("Don't Have an account yet?"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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



class CustomPositioned extends StatelessWidget {
  const CustomPositioned({super.key, this.scale = 1, required this.child});

  final double scale;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Align(
          alignment: Alignment.topCenter,
          child: Padding(padding: EdgeInsets.fromLTRB(0,150,0,0),child: child)
      ),
    );
  }
}

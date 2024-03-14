import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_todo_app/auth/view/login.dart';
import 'package:flutter_riverpod_todo_app/auth/view/signup_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class WelcomePage extends ConsumerWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const WelcomePage(),
      );
  static WelcomePage builder(
    BuildContext context,
    GoRouterState state,
  ) =>
      const WelcomePage();
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          // we will give media query height
          // double.infinity make it big as my parent allows
          // while MediaQuery make it big as per the screen

          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            // even space distribution
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Column(
                children: <Widget>[
                  Text(
                    "Bienvenido a TaskMaker",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child: SvgPicture.asset('../assets/svgs/WelcomeSvg.svg'),
              ),
              Column(
                children: <Widget>[
                  Text(
                    "Organizate con TaskMaker",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 15,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 1),
              Column(
                children: <Widget>[
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpView()));
                    },
                    color: Color.fromARGB(255, 198, 12, 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    child: const Text(
                      "Registrate con Email",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 10),
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {},
                    // defining the shape
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            color: Color.fromARGB(255, 198, 12, 12)),
                        borderRadius: BorderRadius.circular(50)),
                    child: const Text(
                      "Registrate con Google",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                  ),
                ],
              ),
              RichText(
                text: TextSpan(
                  text: "Tienes una cuenta?",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                  children: [
                    TextSpan(
                      text: ' Iniciar sesion',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 198, 12, 12),
                        fontSize: 16,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            LoginView.route(),
                          );
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

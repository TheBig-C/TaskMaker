import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_todo_app/auth/controller/auth_controller.dart';
import 'package:flutter_riverpod_todo_app/common/loading_page.dart';
import 'package:flutter_riverpod_todo_app/widgets/auth_field.dart';
import 'package:flutter_svg/svg.dart';

class SignUpView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const SignUpView());
  const SignUpView({Key? key}) : super(key: key);

  @override
  ConsumerState<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends ConsumerState<SignUpView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  int currentStep = 1;

  bool isPasswordVisible = false;

  String fullPhoneNumber = '';

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return 'Contrasena es requerida';
    }

    if (value.length < 8) {
      return 'La contrasena debe tener almenos 8 caracteres';
    }

    // Al menos una letra mayúscula
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Contrasena debe tener almenos 1 letra mayuscula';
    }

    // Al menos una letra minúscula
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Contrasena debe tener almenos 1 letra minuscula';
    }

    // Al menos un dígito
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Contrasena debe tener almenos un numero';
    }

    // Al menos un carácter especial
    /*if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }*/

    return null; // La contraseña es válida
  }

  void nextStep() {
    if (currentStep == 1) {
      if (passwordController.text != confirmPasswordController.text) {
        // Las contraseñas no coinciden, muestra un mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Las contrasenas no son iguales"),
            backgroundColor: Colors.white,
          ),
        );
        return;
      }
    }

    setState(() {
      currentStep++;
    });
  }

  void previousStep() {
    setState(() {
      currentStep--;
    });
  }

  void onSignUp() {
    String username = '${firstNameController.text} ${lastNameController.text}';

    ref.read(authControllerProvider.notifier).signUp(
          email: emailController.text,
          password: passwordController.text,
          name: username,
          context: context,
        );
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneNumberController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          '../assets/svgs/taskMasterLogo.svg',
          height: 30,
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Loader()
          : Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // textfield 1
                      if (currentStep == 1)
                        const Text(
                          'Crea una cuenta con tu correo',
                          style: TextStyle(
                            fontSize: 50,
                          ),
                          textAlign: TextAlign.right,
                        ),

                      if (currentStep == 1) const SizedBox(height: 5),

                      if (currentStep == 1)
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Tu correo:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                      if (currentStep == 1) const SizedBox(height: 5),

                      if (currentStep == 1)
                        AuthField(
                          controller: emailController,
                          hintText: 'Correo',
                        ),

                      if (currentStep == 1) const SizedBox(height: 15),

                      if (currentStep == 1)
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Contrasena:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                      if (currentStep == 1) const SizedBox(height: 5),

                      if (currentStep == 1)
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: passwordController,
                                obscureText: !isPasswordVisible,
                                decoration: const InputDecoration(
                                  hintText: 'Contrasena',
                                ),
                              ),
                            ),
                          ],
                        ),

                      if (currentStep == 1) const SizedBox(height: 5),

                      // Confirm Password
                      if (currentStep == 1)
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Confirmar contrasena:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                      if (currentStep == 1) const SizedBox(height: 5),

                      if (currentStep == 1)
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: confirmPasswordController,
                                obscureText: !isPasswordVisible,
                                decoration: const InputDecoration(
                                  hintText: 'Confirmar contrasena',
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (currentStep == 1)
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      if (currentStep == 2)
                        Column(
                          children: [
                            // Nuevo título y subtítulo para el paso 2
                            const SizedBox(height: 15),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Informacion de contacto',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Por favor completa la informacion de tu perfil',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),

                            // Campos de entrada para el paso 2
                            const SizedBox(height: 15),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Nombre:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            AuthField(
                              controller: firstNameController,
                              hintText: 'Nombre',
                            ),
                            const SizedBox(height: 15),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Apellido:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            AuthField(
                              controller: lastNameController,
                              hintText: 'Apellido',
                            ),
                            const SizedBox(height: 15),
                          ],
                        ),

                      if (currentStep == 2)
                        Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween, // Alineación horizontal de los botones
                          children: [
                            ElevatedButton(
                              onPressed: previousStep,
                              child: const Text('Atras'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 198, 12, 12),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: currentStep < 2 ? nextStep : onSignUp,
                              child: Text(
                                currentStep < 2 ? 'Siguiente' : 'Registrar',
                                /*style: TextStyle(
                                  color: Color.fromARGB(255, 198, 12, 12),
                                ),*/
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 198, 12, 12),
                              ),
                            ),
                          ],
                        ),
                      if (currentStep == 1)
                        Row(
                          mainAxisAlignment: MainAxisAlignment
                              .end, // Alineación horizontal de los botones
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Validar la contraseña antes de pasar al siguiente paso
                                String? passwordError =
                                    validatePassword(passwordController.text);
                                if (passwordError != null) {
                                  // Muestra un mensaje de error si la contraseña no es válida
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(passwordError),
                                      backgroundColor: Colors.white,
                                    ),
                                  );
                                } else {
                                  // Si la contraseña es válida, avanza al siguiente paso
                                  nextStep();
                                }
                              },
                              child: const Text('Siguiete'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 198, 12, 12),
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

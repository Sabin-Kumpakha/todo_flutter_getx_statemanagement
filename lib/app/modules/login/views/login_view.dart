// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../utils/validator.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  LoginView({Key? key}) : super(key: key);

  //login form key
  final _loginFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blue[100],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 100),
            _buildTopSection(context),
            SizedBox(height: 40),
            _buildFormSection(context),
          ],
        ),
      ),
    );
  }

  _buildTopSection(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Welcome to your Account",
            style: TextStyle(
              fontSize: 30,
              color: Colors.red,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Login to continue",
            style: TextStyle(
              fontSize: 18,
              color: Colors.red[300],
            ),
          ),
        ],
      ),
    );
  }

  _buildFormSection(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: _buildLoginForm(context),
        ),
      ),
    );
  }

  _buildLoginForm(BuildContext context) {
    return Form(
      key: _loginFormKey,
      child: Column(
        children: [
          //Email TextField
          TextFormField(
            decoration: InputDecoration(
              hintText: "Email",
              labelText: "Email",
              fillColor: Colors.red.shade50,
              filled: true,
              prefixIcon: Icon(
                Icons.mail,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            validator: Validators.emailValidator,
            controller: controller.emailController,
          ),

          const SizedBox(height: 20),

          //Password TextField
          Obx(
            () => TextFormField(
              controller: controller.passwordController,
              validator: Validators.passwordValidator,
              obscureText: !controller.isPasswordVisible.value,
              decoration: InputDecoration(
                hintText: "Password",
                labelText: "Password",
                fillColor: Colors.red.shade50,
                filled: true,
                prefixIcon: Icon(
                  Icons.lock,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16.0,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    controller.isPasswordVisible.toggle();
                    //or //same as above
                    //controller.isPasswordVisible.value = !controller.isPasswordVisible.value;
                  },
                  icon: Icon(
                    controller.isPasswordVisible.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),

          //Login Button
          ElevatedButton(
            onPressed: () {
              if (_loginFormKey.currentState!.validate()) {
                controller.loginUser();
                Get.showOverlay(
                  asyncFunction: () async {
                    await controller.loginUser();
                  },
                  loadingWidget: Center(child: CircularProgressIndicator()),
                );
              }
            },
            style: TextButton.styleFrom(
              minimumSize: const Size(150, 40),
              backgroundColor: Colors.red,
            ),
            child: Text("Login"),
          ),

          //Register Text
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an account?",
                  style: TextStyle(color: Colors.grey)),
              TextButton(
                onPressed: () {
                  Get.toNamed(Routes.REGISTER);
                  // or //Get.to garda tapaile chai binding ni garna parcha and register view put garne
                  // Get.to( RegisterView(), binding: RegisterBinding());
                },
                child: const Text("Register"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

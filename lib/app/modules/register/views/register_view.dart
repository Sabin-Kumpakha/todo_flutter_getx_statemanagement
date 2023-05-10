// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/validator.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  RegisterView({Key? key}) : super(key: key);
  final _registerFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blue[100],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 80),
            _buildTopSection(context),
            SizedBox(height: 30),
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
            "Register your Account",
            style: TextStyle(
              fontSize: 30,
              color: Colors.red,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Register your new account",
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
      key: _registerFormKey,
      child: Column(
        children: [
          SizedBox(height: 5),
          //Username TextField
          TextFormField(
            decoration: InputDecoration(
              hintText: "Username",
              labelText: "Username",
              fillColor: Colors.red.shade50,
              filled: true,
              prefixIcon: const Icon(
                Icons.person,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            validator: Validators.usernameValidator,
            controller: controller.usernameController,
          ),
          const SizedBox(height: 20),

          //Full Name TextField
          TextFormField(
            decoration: InputDecoration(
              hintText: "Full Name",
              labelText: "Full Name",
              fillColor: Colors.red.shade50,
              filled: true,
              prefixIcon: const Icon(
                Icons.perm_identity_rounded,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            validator: Validators.nameValidator,
            controller: controller.nameController,
          ),
          const SizedBox(height: 20),

          //PhoneNumber TextField
          TextFormField(
            decoration: InputDecoration(
              hintText: "Phone Number",
              labelText: "Phone Number",
              fillColor: Colors.red.shade50,
              filled: true,
              prefixIcon: const Icon(
                Icons.phone,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            validator: Validators.phoneValidator,
            controller: controller.phoneController,
          ),
          const SizedBox(height: 20),

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
                controller: controller.passwordController,
                validator: Validators.passwordValidator),
          ),

          const SizedBox(height: 30),

          //Register Button
          ElevatedButton(
            onPressed: () async {
              if (_registerFormKey.currentState!.validate()) {
                // controller.registerUser();
                Get.showOverlay(
                  asyncFunction: () async {
                    await controller.registerUser();
                  },
                  loadingWidget: Center(child: CircularProgressIndicator()),
                );
              }
            },
            style: TextButton.styleFrom(
              minimumSize: const Size(150, 40),
              backgroundColor: Colors.red,
            ),
            child: Text("Register"),
          ),

          //Register Text
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Already have an account?",
                  style: TextStyle(color: Colors.grey)),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/login");
                },
                child: const Text("Login"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

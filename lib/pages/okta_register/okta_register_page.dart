import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/app/app_loading.dart';
import '../../services/rest_api/api_user.dart';
import '../../services/safety/base_stateful.dart';
import '../../widgets/p_appbar_transparency.dart';
import '../../widgets/w_dismiss_keyboard.dart';

class OktaRegisterPage extends StatefulWidget {
  @override
  _OktaRegisterPageState createState() => _OktaRegisterPageState();
}

class _OktaRegisterPageState extends BaseStateful<OktaRegisterPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String info;

  @override
  void initDependencies(BuildContext context) {}

  @override
  void afterFirstBuild(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PAppBarTransparency(
      child: WDismissKeyboard(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: <Widget>[
              TextField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(labelText: 'First name')),
              TextField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(labelText: 'Last name')),
              TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email')),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 5),
              RaisedButton(
                onPressed: () {
                  register();
                },
                child: const Text('Register'),
              ),
              const SizedBox(height: 5),
              Expanded(
                child: SingleChildScrollView(
                  child: SelectableText(info ?? ''),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Register
  Future<void> register() async {
    AppLoadingProvider.show(context);
    final Response<Map<String, dynamic>> result = await context
        .read<ApiUser>()
        .register(_firstNameController.text, _lastNameController.text,
            _emailController.text, _passwordController.text)
        .timeout(const Duration(seconds: 30));
    if (result.statusCode == 200) {
      final Map<String, dynamic> data = result.data;
      print('result $data');
      setState(() {
        info = data.toString();
      });
    } else {
      setState(() {
        info = 'Error';
      });
    }
    AppLoadingProvider.hide(context);
  }
}

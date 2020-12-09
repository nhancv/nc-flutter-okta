import 'package:flutter/material.dart';

import '../../services/safety/base_stateful.dart';
import '../../widgets/p_appbar_transparency.dart';
import '../../widgets/w_dismiss_keyboard.dart';

class OktaRestPage extends StatefulWidget {
  @override
  _OktaRestPageState createState() => _OktaRestPageState();
}

class _OktaRestPageState extends BaseStateful<OktaRestPage> {
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
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(),
          ),
        ),
      ),
    );
  }
}

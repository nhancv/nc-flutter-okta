import 'package:okta/my_app.dart';
import 'package:okta/utils/app_config.dart';

Future<void> main() async {
  /// Init dev config
  Config(environment: Env.dev());
  await myMain();
}

import 'package:flutter/cupertino.dart';
import 'package:jest_timecapsule/app/message_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return const MessageApp();
  }
}

import 'package:flutter/material.dart';
import 'package:reservadequadras/routers/routers.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() {
  usePathUrlStrategy();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      
      title: 'Reserva de Quadras',
      debugShowCheckedModeBanner: false,
      routerDelegate: routers.routerDelegate,
      routeInformationParser: routers.routeInformationParser,
      routeInformationProvider: routers.routeInformationProvider,
    );
  }
}

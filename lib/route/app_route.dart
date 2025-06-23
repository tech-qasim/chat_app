import 'package:auto_route/auto_route.dart';
import 'package:chat_app/route/app_route.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes {
    return [
      AutoRoute(page: LoginRoute.page, initial: true),
      AutoRoute(page: SignUpRoute.page),
    ];
  }
}

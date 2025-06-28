import 'package:auto_route/auto_route.dart';
import 'package:chat_app/route/app_route.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes {
    return [
      AutoRoute(page: LoginRoute.page),
      AutoRoute(page: SignUpRoute.page),
      AutoRoute(page: SplashRoute.page, initial: true),
      AutoRoute(page: ChatRoute.page),

      CustomRoute(
        page: NavigationRoute.page,
        // initial: true,
        transitionsBuilder: TransitionsBuilders.fadeIn,
        path: "/main",
        children: [
          CustomRoute(
            page: ContactsRoute.page,
            transitionsBuilder: TransitionsBuilders.fadeIn,
            path: "chat",
          ),
          CustomRoute(
            page: NewMessagesRoute.page,
            transitionsBuilder: TransitionsBuilders.fadeIn,
            path: "new_messages",
          ),
          CustomRoute(
            page: ProfileRoute.page,
            transitionsBuilder: TransitionsBuilders.fadeIn,
            path: "profile",
          ),
        ],
      ),
    ];
  }
}

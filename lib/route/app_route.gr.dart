// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i8;
import 'package:chat_app/screens/auth/login_screen.dart' as _i3;
import 'package:chat_app/screens/auth/sign_up_screen.dart' as _i6;
import 'package:chat_app/screens/chat/chat_screen.dart' as _i1;
import 'package:chat_app/screens/contacts/contacts_screen.dart' as _i2;
import 'package:chat_app/screens/navigation/navigation_screen.dart' as _i4;
import 'package:chat_app/screens/new_messages/new_messages_screen.dart' as _i5;
import 'package:chat_app/screens/splash/splash_screen.dart' as _i7;

/// generated route for
/// [_i1.ChatScreen]
class ChatRoute extends _i8.PageRouteInfo<void> {
  const ChatRoute({List<_i8.PageRouteInfo>? children})
    : super(ChatRoute.name, initialChildren: children);

  static const String name = 'ChatRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i1.ChatScreen();
    },
  );
}

/// generated route for
/// [_i2.ContactsScreen]
class ContactsRoute extends _i8.PageRouteInfo<void> {
  const ContactsRoute({List<_i8.PageRouteInfo>? children})
    : super(ContactsRoute.name, initialChildren: children);

  static const String name = 'ContactsRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i2.ContactsScreen();
    },
  );
}

/// generated route for
/// [_i3.LoginScreen]
class LoginRoute extends _i8.PageRouteInfo<void> {
  const LoginRoute({List<_i8.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i3.LoginScreen();
    },
  );
}

/// generated route for
/// [_i4.NavigationScreen]
class NavigationRoute extends _i8.PageRouteInfo<void> {
  const NavigationRoute({List<_i8.PageRouteInfo>? children})
    : super(NavigationRoute.name, initialChildren: children);

  static const String name = 'NavigationRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i4.NavigationScreen();
    },
  );
}

/// generated route for
/// [_i5.NewMessagesScreen]
class NewMessagesRoute extends _i8.PageRouteInfo<void> {
  const NewMessagesRoute({List<_i8.PageRouteInfo>? children})
    : super(NewMessagesRoute.name, initialChildren: children);

  static const String name = 'NewMessagesRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i5.NewMessagesScreen();
    },
  );
}

/// generated route for
/// [_i6.SignUpScreen]
class SignUpRoute extends _i8.PageRouteInfo<void> {
  const SignUpRoute({List<_i8.PageRouteInfo>? children})
    : super(SignUpRoute.name, initialChildren: children);

  static const String name = 'SignUpRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i6.SignUpScreen();
    },
  );
}

/// generated route for
/// [_i7.SplashScreen]
class SplashRoute extends _i8.PageRouteInfo<void> {
  const SplashRoute({List<_i8.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i7.SplashScreen();
    },
  );
}

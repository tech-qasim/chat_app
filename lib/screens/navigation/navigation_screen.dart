import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:chat_app/route/app_route.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class NavigationScreen extends ConsumerStatefulWidget {
  const NavigationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NavigationScreenState();
}

class _NavigationScreenState extends ConsumerState<NavigationScreen> {
  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      navigatorObservers: () => [HeroController()],
      routes: const [ContactsRoute(), NewMessagesRoute()],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        final selectedIndex = tabsRouter.activeIndex;

        // WidgetsBinding.instance.addPostFrameCallback((_) {
        //   ref
        //       .read(titleDashboardProvider.notifier)
        //       .touchedIndex(selectedIndex);
        // });

        return NavigationMobScreen(
          selectedIndex: selectedIndex,
          tabsRouter: tabsRouter,
          child: child,
        );
      },
    );
  }
}

class NavigationMobScreen extends ConsumerStatefulWidget {
  const NavigationMobScreen({
    super.key,
    required this.selectedIndex,
    required this.tabsRouter,
    required this.child,
  });

  final int selectedIndex;
  final TabsRouter tabsRouter;
  final Widget child;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NavigationMobScreenState();
}

class _NavigationMobScreenState extends ConsumerState<NavigationMobScreen> {
  @override
  Widget build(BuildContext context) {
    // final index = ref.watch(titleDashboardProvider).touchedIndex;

    return Scaffold(
      body: widget.child, // Use the child property in the body
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(blurRadius: 8, offset: Offset(0, 6)),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          child: BottomNavigationWidget(
            selectedIndex: widget.selectedIndex,
            onItemSelected: (index) {
              widget.tabsRouter.setActiveIndex(index);
            },
          ),
        ),
      ),
    );
  }
}

class BottomNavigationWidget extends StatelessWidget {
  const BottomNavigationWidget({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 100,
          child: BottomNavigationBar(
            elevation: 20,
            backgroundColor: Colors.white,
            currentIndex: selectedIndex,
            items: [
              BottomNavigationBarItem(
                activeIcon: Icon(Icons.contact_emergency),
                icon: Icon(Icons.contact_emergency_sharp),
                label: 'Contacts',
              ),
              BottomNavigationBarItem(
                activeIcon: Padding(
                  padding: EdgeInsets.only(right: 0),
                  child: Icon(Icons.chat),
                ),
                icon: Icon(Icons.chat_bubble_outline_outlined),
                label: 'New messages',
              ),
            ],
            onTap: onItemSelected,
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            // selectedItemColor: AppColors.primeryColor,
            // unselectedItemColor: AppColors.darkGrey,
          ),
        ),
      ],
    );
  }
}

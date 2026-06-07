import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../home/home_view.dart';
import '../pets/pets_view.dart';
import 'main_controller.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
            index: controller.currentIndex.value,
            children: const [
              HomeView(),
              PetsView(),
            ],
          )),
      bottomNavigationBar: Obx(() => NavigationBar(
            selectedIndex: controller.currentIndex.value,
            onDestinationSelected: controller.changePage,
            backgroundColor: Colors.white,
            indicatorColor: AppColors.primary.withValues(alpha: 0.15),
            labelBehavior:
                NavigationDestinationLabelBehavior.alwaysShow,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(
                  Icons.home_rounded,
                  color: AppColors.primary,
                ),
                label: 'Beranda',
              ),
              NavigationDestination(
                icon: Icon(Icons.pets_outlined),
                selectedIcon: Icon(
                  Icons.pets,
                  color: AppColors.primary,
                ),
                label: 'MyPet',
              ),
            ],
          )),
    );
  }
}

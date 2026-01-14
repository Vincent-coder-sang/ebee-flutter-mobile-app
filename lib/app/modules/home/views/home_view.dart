import 'package:ebee/app/modules/auth/controllers/auth_controller.dart';
import 'package:ebee/app/modules/cart/controllers/cart_controller.dart';
import 'package:ebee/app/modules/home/views/services_tab.dart';
import 'package:ebee/app/modules/products/views/products_view.dart';
import 'package:ebee/app/modules/profile/views/profile_view.dart';
import 'package:ebee/app/modules/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late final CartController cartController;
  late final ProfileController profileController;

  final List<String> _pageTitles = ['Products', 'Services', 'Profile'];

  @override
  void initState() {
    super.initState();
    cartController = Get.put(CartController(), permanent: true);
    profileController = Get.put(ProfileController(), permanent: true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      cartController.loadCart();
    });
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return ProductsView();
      case 1:
        return const ServicesTab();
      case 2:
        return const ProfileView();
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_pageTitles[_currentIndex]),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          Obx(
            () => badges.Badge(
              showBadge: cartController.totalItems > 0,
              badgeContent: Text(
                '${cartController.totalItems}',
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
              child: IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () => Get.toNamed('/cart'),
              ),
            ),
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: _getPage(_currentIndex),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // ---------------------------------------------------------------------------
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (i) => setState(() => _currentIndex = i),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.electric_bike),
          label: 'Products',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.build_circle),
          label: 'Services',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  Widget _buildDrawer() {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            _drawerHeader(),
            const Divider(),

            _drawerItem(
              icon: Icons.shopping_cart,
              title: 'My Cart',
              badge: cartController.totalItems,
              onTap: () => _navigate('/cart'),
            ),
            _drawerItem(
              icon: Icons.history,
              title: 'My Orders',
              onTap: () => _navigate('/orders'),
            ),
            _drawerItem(
              icon: Icons.location_on,
              title: 'My Addresses',
              onTap: () => _navigate('/addresses'),
            ),

            const Divider(),

            _drawerItem(
              icon: Icons.favorite_border,
              title: 'Wishlist',
              onTap: () => _navigate('/wishlist'),
            ),
            _drawerItem(
              icon: Icons.payment,
              title: 'Payments',
              onTap: () => _navigate('/payments'),
            ),
            _drawerItem(
              icon: Icons.help_outline,
              title: 'Help & Support',
              onTap: () => _navigate('/help'),
            ),

            const Spacer(),

            _drawerItem(
              icon: Icons.logout,
              title: 'Logout',
              onTap: _logout,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  Widget _drawerHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Obx(() {
        final user = profileController.user.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'eBee',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (user != null)
              Text(
                'Hello, ${user.name}',
                style: const TextStyle(color: Colors.grey),
              ),
          ],
        );
      }),
    );
  }

  // ---------------------------------------------------------------------------
  Widget _drawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    int badge = 0,
    Color? color,
  }) {
    return ListTile(
      leading: badge > 0
          ? badges.Badge(
              badgeContent: Text(
                '$badge',
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
              child: Icon(icon, color: color),
            )
          : Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      onTap: onTap,
    );
  }

  void _navigate(String route) {
    Get.back();
    Get.toNamed(route);
  }

  void _logout() {
    Get.back();
    Get.defaultDialog(
      title: 'Logout',
      middleText: 'Are you sure you want to logout?',
      confirm: ElevatedButton(
        onPressed: () {
          Get.back();
          Get.find<AuthController>().logout();
        },
        child: const Text('Logout'),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: const Text('Cancel'),
      ),
    );
  }
}

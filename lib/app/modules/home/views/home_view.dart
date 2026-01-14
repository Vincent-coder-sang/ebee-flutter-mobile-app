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
  late CartController cartController;
  late ProfileController profileController;

  // Page titles for AppBar
  final List<String> _pageTitles = ['Products', 'Services', 'Profile'];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    print('🔄 Initializing controllers in HomeView...');

    // Initialize CartController
    if (!Get.isRegistered<CartController>()) {
      cartController = Get.put(CartController());
      print('✅ CartController initialized in HomeView');
    } else {
      cartController = Get.find<CartController>();
      print('✅ CartController already exists, using existing instance');
    }

    // Initialize ProfileController
    if (!Get.isRegistered<ProfileController>()) {
      profileController = Get.put(ProfileController());
      print('✅ ProfileController initialized in HomeView');
    } else {
      profileController = Get.find<ProfileController>();
      print('✅ ProfileController already exists, using existing instance');
    }

    // Load initial data
    _loadInitialData();
  }

  void _loadInitialData() {
    // Load cart data
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
        return const Center(child: Text('Page not found'));
    }
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_pageTitles[_currentIndex]),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black87),
          onPressed: _openDrawer,
          tooltip: 'Menu',
        ),
        actions: [
          // Cart Icon with Badge
          Obx(
            () => badges.Badge(
              showBadge: cartController.totalItems > 0,
              badgeContent: Text(
                '${cartController.totalItems}',
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
              position: badges.BadgePosition.topEnd(top: -8, end: -8),
              child: IconButton(
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.black87,
                ),
                onPressed: () => Get.toNamed('/cart'),
                tooltip: 'Cart (${cartController.totalItems} items)',
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: _buildDrawer(),
      body: _getPage(_currentIndex),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey[600],
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.electric_bike),
          activeIcon: Icon(Icons.electric_bike),
          label: 'Products',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.build_circle_outlined),
          activeIcon: Icon(Icons.build_circle),
          label: 'Services',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          // Drawer Header
          _buildDrawerHeader(),

          // Navigation Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerSection('Main', [
                  _buildDrawerItem(
                    icon: Icons.home,
                    title: 'Home',
                    onTap: () => _navigateToTab(0),
                  ),
                  _buildDrawerItem(
                    icon: Icons.electric_bike,
                    title: 'Products',
                    onTap: () => _navigateToTab(0),
                  ),
                  _buildDrawerItem(
                    icon: Icons.build_circle_outlined,
                    title: 'Services',
                    onTap: () => _navigateToTab(1),
                  ),
                  _buildDrawerItem(
                    icon: Icons.person_outline,
                    title: 'Profile',
                    onTap: () => _navigateToTab(2),
                  ),
                ]),

                _buildDrawerSection('Shopping', [
                  _buildDrawerItem(
                    icon: Icons.shopping_cart,
                    title: 'My Cart',
                    badgeCount: cartController.totalItems,
                    onTap: () => _navigateTo('/cart'),
                  ),
                  _buildDrawerItem(
                    icon: Icons.favorite_border,
                    title: 'Wishlist',
                    onTap: () => _navigateTo('/wishlist'),
                  ),
                  _buildDrawerItem(
                    icon: Icons.history,
                    title: 'Order History',
                    onTap: () => _navigateTo('/orders'),
                  ),
                ]),

                _buildDrawerSection('Account', [
                  _buildDrawerItem(
                    icon: Icons.location_on,
                    title: 'My Addresses',
                    onTap: () => _navigateTo('/addresses'),
                  ),
                  _buildDrawerItem(
                    icon: Icons.payment,
                    title: 'Payment Methods',
                    onTap: () => _navigateTo('/payments'),
                  ),
                ]),

                _buildDrawerSection('Support', [
                  _buildDrawerItem(
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    onTap: () => _navigateTo('/help'),
                  ),
                  _buildDrawerItem(
                    icon: Icons.info_outline,
                    title: 'About Us',
                    onTap: () => _navigateTo('/about'),
                  ),
                  _buildDrawerItem(
                    icon: Icons.phone,
                    title: 'Contact Us',
                    onTap: () => _navigateTo('/contact'),
                  ),
                ]),

                _buildDrawerSection('Settings', [
                  _buildDrawerItem(
                    icon: Icons.settings,
                    title: 'Settings',
                    onTap: () => _navigateTo('/settings'),
                  ),
                  _buildDrawerItem(
                    icon: Icons.logout,
                    title: 'Logout',
                    onTap: _logout,
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return DrawerHeader(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text(
            'eBee',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ride the Electric Future',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          // User info if available
          Obx(() {
            final user = profileController.user.value;
            if (user != null && user.name.isNotEmpty) {
              return Text(
                'Hello, ${user.name}!',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              );
            }
            return const SizedBox();
          }),
        ],
      ),
    );
  }

  Widget _buildDrawerSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
              letterSpacing: 1.0,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    int badgeCount = 0,
  }) {
    return ListTile(
      leading: badgeCount > 0
          ? badges.Badge(
              showBadge: badgeCount > 0,
              badgeContent: Text(
                '$badgeCount',
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
              position: badges.BadgePosition.topEnd(top: -4, end: -4),
              child: Icon(icon),
            )
          : Icon(icon),
      title: Text(title),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      visualDensity: const VisualDensity(vertical: -2),
    );
  }

  void _navigateToTab(int index) {
    Get.back();
    setState(() {
      _currentIndex = index;
    });
  }

  void _navigateTo(String route) {
    Get.back();
    Get.toNamed(route);
  }

  void _logout() {
    Get.back();
    Get.defaultDialog(
      title: 'Logout',
      content: const Text('Are you sure you want to logout?'),
      confirm: ElevatedButton(
        onPressed: () {
          Get.back();
          Get.find<AuthController>().logout();
        },
        child: const Text('Yes, Logout'),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: const Text('Cancel'),
      ),
    );
  }
}

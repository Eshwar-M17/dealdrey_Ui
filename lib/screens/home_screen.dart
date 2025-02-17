import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // For the bottom navigation bar
  int _currentIndex = 0;

  final List<String> _bannerImages = [
    'assets/images/banner1.png',
    'assets/images/banner2.png',
    'assets/images/banner3.png',
  ];

  // Build the main content of the screen
  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Banner/Carousel
          SizedBox(
            height: 160,
            child: PageView.builder(
              controller: PageController(viewportFraction: 0.9),
              itemCount: _bannerImages.length,
              itemBuilder: (context, index) {
                return _buildBanner(_bannerImages[index]);
              },
            ),
          ),

          // KYC Card
          _buildKycCard(),

          // Categories
          _buildCategoryRow(),
          const SizedBox(height: 16),

          // Exclusive Section
          _buildExclusiveSection(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // Build the custom top bar with brand icon + search

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      elevation: 0,
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.red,
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w400,
      ),
      onTap: (index) {
        setState(() => _currentIndex = index);
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.category_outlined),
          label: 'Categories',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_offer_outlined),
          label: 'Deals',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildCustomAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavBar(),
      floatingActionButton: _buildChatButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

Widget _buildChatButton() {
  return FloatingActionButton.extended(
    onPressed: () {
      // Handle chat action
    },
    backgroundColor: Colors.red,
    icon: const Icon(
      Icons.chat_bubble_outline,
      color: Colors.white,
    ),
    label: const Text(
      'Chat',
      style: TextStyle(color: Colors.white),
    ),
  );
}

PreferredSizeWidget _buildCustomAppBar() {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    leading: IconButton(
      icon: const Icon(Icons.menu, color: Colors.black),
      onPressed: () {},
    ),
    title: Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/images/dealsdreyicon.png',
            fit: BoxFit.contain,
            height: 24,
            width: 24,
          ),
          const SizedBox(width: 8),
          // Search field
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search here",
                hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                border: InputBorder.none,
              ),
              onSubmitted: (value) {
                // Handle search input here
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.grey),
            onPressed: () {
            },
          ),
        ],
      ),
    ),
    actions: [
      IconButton(
        icon: const Icon(Icons.notifications_none, color: Colors.black),
        onPressed: () {
        },
      ),
    ],
  );
}

Widget _buildExclusiveSection() {
  // Sample product cards
  final products = [
    {
      'image': 'assets/images/product1.png',
      'name': 'Nokia 8.1 (iron,64 GB)',
      'discount': '32% Off',
      'price': '₹14,999',
    },
    {
      'image': 'assets/images/product3.png',
      'name': 'Samsung Galaxy S23(128 GB)',
      'discount': '10% Off',
      'price': '₹19,499',
    },
    {
      'image': 'assets/images/product4.png',
      'name': 'Redmi Note 7 (Sapphire, 64 GB)',
      'discount': '14% Off',
      'price': '₹9,999',
    },
  ];

  return Stack(
    children: [
      Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF5AC8FB),
              Color(0xFF84FFFF),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                'EXCLUSIVE FOR YOU',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            // Horizontal list of product cards
            SizedBox(
              height: 300,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Container(
                    width: 160,
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    // Stack for discount badge
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Image
                            Container(
                              height: 180,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(8),
                                ),
                                image: DecorationImage(
                                  image: AssetImage(product['image']!),
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            // Product Name
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                product['name']!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Product Price
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                product['price']!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Discount Badge
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              product['discount']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    ],
  );
}

Widget _buildCategoryRow() {
  final categories = [
    {
      'icon': Icons.phone_android,
      'label': 'Mobile',
      'gradient': const LinearGradient(
        colors: [Color(0xFF4e54c8), Color(0xFF8f94fb)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      'icon': Icons.laptop,
      'label': 'Laptop',
      'gradient': const LinearGradient(
        colors: [Color(0xFF00c6ff), Color(0xFF0072ff)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      'icon': Icons.camera_alt,
      'label': 'Camera',
      'gradient': const LinearGradient(
        colors: [Color(0xFFf953c6), Color(0xFFb91d73)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      'icon': Icons.lightbulb_outline,
      'label': 'LED',
      'gradient': const LinearGradient(
        colors: [Color(0xFFFFA726), Color(0xFFFF7043)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
  ];

  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: categories.map((cat) {
        return Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Column(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: cat['gradient'] as Gradient,
                ),
                child: Icon(
                  cat['icon'] as IconData,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                cat['label'].toString(),
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ],
          ),
        );
      }).toList(),
    ),
  );
}

Widget _buildBanner(String imagePath) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 8.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      image: DecorationImage(
        image: AssetImage(imagePath),
        fit: BoxFit.cover,
      ),
    ),
  );
}

// Build the KYC card
Widget _buildKycCard() {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    decoration: BoxDecoration(
      // Gradient background
      gradient: const LinearGradient(
        colors: [
          Color.fromARGB(255, 169, 150, 226),
          Color(0xFF6246EA),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'KYC Pending',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white, 
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'You need to provide the required documents '
          'for your account activation.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () {}, // Handle tap
          child: const Text(
            'Click Here',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}

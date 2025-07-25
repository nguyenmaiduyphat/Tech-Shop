import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tech_fun/components/productcard_hovereffect.dart';
import 'package:tech_fun/views/main/layout_page.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailPage extends StatefulWidget {
  final List<String> imageGallery;

  const ProductDetailPage({super.key, required this.imageGallery});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _bgColor1;
  late Animation<Color?> _bgColor2;

  late PageController _pageController;
  int _currentPage = 0;
  late Map<String, dynamic> productInfo;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    _bgColor1 = ColorTween(
      begin: const Color.fromARGB(255, 124, 126, 26),
      end: const Color.fromARGB(255, 93, 106, 112),
    ).animate(_animationController);

    _bgColor2 = ColorTween(
      begin: const Color.fromARGB(255, 11, 1, 146),
      end: const Color.fromARGB(255, 82, 156, 148),
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_bgColor1.value!, _bgColor2.value!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: ScrollConfiguration(
                behavior: const MaterialScrollBehavior().copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                  },
                ),
                child: Column(
                  children: [
                    _buildHeader(),
                    _buildImageGallery(),
                    _buildImageThumbnails(),
                    Expanded(
                      child:
                          _buildMainContent(), // Modular content below image section
                    ),
                    _buildFooterActions(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LayoutPage()),
              );
            },
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              height: 36,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(color: Colors.white),
                cursorColor: Color.fromARGB(255, 14, 167, 134),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white70,
                    size: 18,
                  ),
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                onSubmitted: (value) {
                  print('Search submitted: $value');
                },
              ),
            ),
          ),

          IconButton(
            icon: Icon(Icons.share, color: Colors.white),
            onPressed: () => _showShareOptions(productInfo),
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildImageGallery() {
    return SizedBox(
      height: 250,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.imageGallery.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    widget.imageGallery[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 10,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${_currentPage + 1} / ${widget.imageGallery.length}',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageThumbnails() {
    final totalImages = widget.imageGallery.length;
    final hasOverflow = totalImages > 5;
    final thumbnailsToShow = hasOverflow ? 5 : totalImages;
    final remainingCount = totalImages - 4;

    return Container(
      height: 70,
      margin: const EdgeInsets.only(top: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: thumbnailsToShow,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (context, index) {
          final isOverflowThumbnail = hasOverflow && index == 4;
          final imageIndex = isOverflowThumbnail ? 4 : index;

          return GestureDetector(
            onTap: () {
              if (isOverflowThumbnail) {
                _pageController.animateToPage(
                  4,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                border: Border.all(
                  color: _currentPage == index
                      ? Colors.white
                      : Colors.transparent,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      widget.imageGallery[imageIndex],
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (isOverflowThumbnail)
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '+$remainingCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  bool _isFavorited = false;

  Widget _buildMainContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Price & Sold
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '₫199,000',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Row(
                children: [
                  const Text('1.2k sold', style: TextStyle(color: Colors.grey)),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isFavorited = !_isFavorited;
                      });
                    },
                    child: Icon(
                      _isFavorited ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorited ? Colors.red : Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Row 2: Product Name
          const Text(
            'Awesome Bluetooth Speaker 2024',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 12),

          // Row 3: Ship From → To
          const Text(
            'Ships from: Hanoi → Ho Chi Minh City',
            style: TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 16),

          // Row 4: Rating + View All
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.star, color: Colors.amber, size: 18),
                  SizedBox(width: 4),
                  Text(
                    '4.8 | 1.2k reviews',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
            ],
          ),

          const SizedBox(height: 16),

          // Row 5: List of 4 reviews
          _buildReviewList(),

          const SizedBox(height: 16),

          // Row 6: Shop Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage('assets/shop_avatar.png'),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'ShopName Official',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Online',
                        style: TextStyle(color: Colors.green, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.storefront,
                  size: 18,
                  color: Colors.black,
                ),
                label: const Text(
                  'Visit Shop',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyanAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Row 7: Shop stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('⭐ 4.9', style: TextStyle(color: Colors.white)),
              Text('120 products', style: TextStyle(color: Colors.white)),
              Text('95% reply rate', style: TextStyle(color: Colors.white)),
            ],
          ),

          const SizedBox(height: 16),

          // Row 8: Detail product title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Product Details',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.info_outline, color: Colors.white),
                onPressed: () {
                  showGeneralDialog(
                    context: context,
                    barrierDismissible: true,
                    barrierLabel: "Product Details",
                    barrierColor: Colors.transparent, // Background fade
                    transitionDuration: const Duration(milliseconds: 300),
                    pageBuilder: (_, __, ___) {
                      return const SizedBox.shrink(); // Not used
                    },
                    transitionBuilder: (context, animation, _, __) {
                      return Transform.scale(
                        scale: animation.value,
                        child: AlertDialog(
                          backgroundColor:
                              Colors.blueGrey[900], // Modern dark background
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          titlePadding: const EdgeInsets.fromLTRB(
                            24,
                            20,
                            24,
                            0,
                          ),
                          contentPadding: const EdgeInsets.fromLTRB(
                            24,
                            12,
                            24,
                            20,
                          ),
                          title: const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Product Details',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          content: _buildProductDetailsTable(),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),

          const Divider(color: Colors.grey),

          // Row 9: Description with "View All"
          _buildProductDescription(),

          const SizedBox(height: 16),

          // Row 10: You may like
          const Text(
            'You may also like',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          _buildSuggestedProducts(),
        ],
      ),
    );
  }

  Widget _buildProductDetailsTable() {
    const styleLeft = TextStyle(color: Colors.grey, fontSize: 14);
    const styleRight = TextStyle(color: Colors.white, fontSize: 14);

    return Table(
      columnWidths: const {0: IntrinsicColumnWidth(), 1: FlexColumnWidth()},
      children: [
        _buildDetailRow('Waterproof', '100%'),
        _buildSpacerRow(),
        _buildDetailRow('Battery life', '12 hours'),
        _buildSpacerRow(),
        _buildDetailRow('Bluetooth', '5.0, 30m range'),
        _buildSpacerRow(),
        _buildDetailRow('Inputs', 'SD card, USB'),
        _buildSpacerRow(),
        _buildDetailRow('Compatible', 'iOS & Android'),
        _buildSpacerRow(),
        _buildDetailRow('Weight', '450g'),
        _buildSpacerRow(),
        _buildDetailRow('Dimensions', '18 × 7 × 6 cm'),
      ],
    );
  }

  TableRow _buildDetailRow(String left, String right) {
    const styleLeft = TextStyle(color: Colors.grey, fontSize: 14);
    const styleRight = TextStyle(color: Colors.white, fontSize: 14);

    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2, bottom: 2, left: 10),
          child: Text(left, style: styleLeft),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 2, bottom: 2, left: 10),
          child: Text(right, style: styleRight),
        ),
      ],
    );
  }

  TableRow _buildSpacerRow() {
    return const TableRow(children: [SizedBox(height: 4), SizedBox(height: 4)]);
  }

  Widget _buildReviewList() {
    final reviews = List.generate(
      4,
      (i) => {
        'name': 'User $i',
        'rating': 4 - (i % 3), // 4, 3, 2, 1
        'content': 'Great product! Really satisfied with quality.',
        'image': 'assets/product/product${(i % 3) + 1}.jpg',
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...reviews.map((review) {
          final rating = review['rating'] as int;
          final image = review['image'] as String;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 16,
                    child: Icon(Icons.person, size: 16),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        color: index < rating ? Colors.amber : Colors.grey,
                        size: 16,
                      );
                    }),
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    review['content'].toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      image,
                      height: 100,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              // Navigate to full review list
            },
            child: const Text(
              'View all',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  bool _isExpanded = false;
  Widget _buildProductDescription() {
    const fullDescription =
        '''It's summertime -- or as I like to call it, portable Bluetooth speaker season. I test everything from tiny speakers that strap onto the handle bars of your bike to big Bluetooth boom boxes that pump out surprisingly powerful sound that can fuel your outdoor pool and beach parties. With each passing year Bluetooth speakers continue to improve, featuring better sound quality, longer battery life and more durable designs that makes them suitable for indoor and outdoor use. Many are fully waterproof and some even float. I've included options in every size category and price range, with several budget-friendly choices for those who don't want to spend a lot.''';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fullDescription,
          maxLines: _isExpanded ? null : 10,
          overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Text(
              _isExpanded ? 'Show less' : 'View full description',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  final List<Map<String, dynamic>> products = List.generate(
    10,
    (index) => {
      'name': 'Product $index',
      'price': (index + 1) * 10.0,
      'image': [
        'assets/product/product${(index % 3) + 1}.jpg',
        'assets/product/product${(index % 3) + 1}.jpg',
        'assets/product/product${(index % 3) + 1}.jpg',
      ],
      'discount': 30,
      'rating': 4.5,
      'sold': 45,
      'delivery': 2,
      'location': 'TP.HCM',
    },
  );

  Widget _buildSuggestedProducts() {
    return SizedBox(
      height: 270, // Increase height to fit card content
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemBuilder: (context, index) {
          return SizedBox(
            width: 160, // Width of each product card
            child: ProductCardHoverEffect(product: products[index]),
          );
        },
      ),
    );
  }

  Widget _buildFooterActions() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white10,
        border: Border(top: BorderSide(color: Colors.white24)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 100, // Fixed width for icon button
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white30),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 100, // Same fixed width as above
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white30),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyanAccent,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Buy Now'),
            ),
          ),
        ],
      ),
    );
  }

  void _showShareOptions(Map<String, dynamic> product) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1F1F2E), // Dark techy background
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildShareTile(
              icon: FontAwesomeIcons.facebook,
              label: "Facebook",
              color: Colors.blueAccent,
              onTap: () {
                _shareToFacebook(product);
              },
            ),
            _buildShareTile(
              icon: FontAwesomeIcons.google,
              label: "Gmail",
              color: Colors.redAccent,
              onTap: () {
                _shareToGmail(product);
              },
            ),
            _buildShareTile(
              icon: FontAwesomeIcons.microsoft,
              label: "Outlook",
              color: Colors.teal,
              onTap: () {
                _shareToOutlook(product);
              },
            ),
            _buildShareTile(
              icon: Icons.chat_bubble,
              label: "Zalo",
              color: Colors.lightBlue,
              onTap: () {
                _shareToZalo(product);
              },
            ),
            _buildShareTile(
              icon: FontAwesomeIcons.teamspeak,
              label: "Microsoft Teams",
              color: Colors.deepPurpleAccent,
              onTap: () {
                _shareToZalo(product);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareTile({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: FaIcon(icon, color: color),
      title: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  void _shareToGmail(Map<String, dynamic> product) async {
    final subject = '${product['name']} - \$${product['price']}';
    final images = product['image'].join('\n');
    final body =
        '${product['name']} - \$${product['price']} - ${product['location']}';

    final uri = Uri(
      scheme: 'mailto',
      path: '',
      query:
          'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}',
    );

    if (await canLaunchUrl(uri)) launchUrl(uri);
  }

  void _shareToOutlook(Map<String, dynamic> product) =>
      _shareToGmail(product); // dùng mailto giống Gmail
  String _composeShareText(Map<String, dynamic> product) {
    final images = product['image'].join('\n');
    return '${product['name']}\n${product['price']}\n\n$images';
  }

  void _shareToFacebook(Map<String, dynamic> product) async {
    final content = _composeShareText(product);
    final fbUrl =
        'https://www.facebook.com/sharer/sharer.php?u=https://example.com&quote=${Uri.encodeComponent(content)}';
    if (await canLaunchUrl(Uri.parse(fbUrl))) launchUrl(Uri.parse(fbUrl));
  }

  void _shareToTeams(Map<String, dynamic> product) async {
    final content = _composeShareText(product);
    final teamsUrl =
        'https://teams.microsoft.com/share?msg=${Uri.encodeComponent(content)}';
    if (await canLaunchUrl(Uri.parse(teamsUrl))) launchUrl(Uri.parse(teamsUrl));
  }

  void _shareToZalo(Map<String, dynamic> product) async {
    final content = _composeShareText(product);
    final zaloUrl =
        'https://zalo.me/share?url=https://example.com&text=${Uri.encodeComponent(content)}';
    if (await canLaunchUrl(Uri.parse(zaloUrl))) launchUrl(Uri.parse(zaloUrl));
  }
}

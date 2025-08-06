// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:tech_fun/components/productcard_hovereffect.dart';
import 'package:tech_fun/models/product_detail.dart';
import 'package:tech_fun/utils/database_service.dart';
import 'package:tech_fun/utils/sort_methods.dart';
import 'package:tech_fun/views/main/layout_page.dart';

class ProductTechPage extends StatefulWidget {
  final List<ProductDetail> productList;
  const ProductTechPage({super.key, required this.productList});

  @override
  State<ProductTechPage> createState() => _ProductTechPageState();
}

class _ProductTechPageState extends State<ProductTechPage>
    with TickerProviderStateMixin {
  Map<String, dynamic> selectedFilter = {
    'selectedPrice': '',
    'selectedProductListType': '',
    'selectedUsage': '',
    'selectedShipping': '',
    'selectedBrands': [],
    'selectedStar': 0,
  };
  String selectedSort = 'None';

  void _openFilterDialog() {
    showModalBottomSheet(
      context: context,
      builder: (_) => _buildFilterOptions(),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _customRadioTile({
    required BuildContext context,
    required String title,
    required String value,
    required String? groupValue,
    required Function(String?) onChanged,
  }) {
    final isSelected = value == groupValue;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
        color: isSelected ? Colors.tealAccent : Colors.grey[400],
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () => onChanged(value),
    );
  }

  Widget _buildFilterOptions() {
    String selectedPrice = selectedFilter['selectedPrice'];
    String selectedProductListType = selectedFilter['selectedProductListType'];
    String selectedUsage = selectedFilter['selectedUsage'];
    String selectedShipping = selectedFilter['selectedShipping'];
    List<String> selectedBrands = List<String>.from(
      selectedFilter['selectedBrands'],
    );
    int selectedStar = selectedFilter['selectedStar'];

    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ScrollConfiguration(
              behavior: const MaterialScrollBehavior().copyWith(
                dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
              ),
              child: ListView(
                shrinkWrap: true,
                children: [
                  SizedBox(height: 5),
                  Center(
                    child: Container(
                      width: 120, // hoặc bất kỳ chiều rộng nào bạn muốn
                      height: 4,
                      color: Colors.grey.shade300, // hoặc Colors.black26
                    ),
                  ),
                  SizedBox(height: 4),
                  _sectionHeader("💰 Price"),
                  ...[
                    'Below 1M',
                    '1M - 3M',
                    '3M - 5M',
                    '5M - 10M',
                    'Above 10M',
                  ].map(
                    (price) => _customRadioTile(
                      context: context,
                      title: price,
                      value: price,
                      groupValue: selectedPrice,
                      onChanged: (val) => setState(() => selectedPrice = val!),
                    ),
                  ),
                  const Divider(color: Colors.white54),
                  _sectionHeader("🔥 Product"),
                  ...['Recommended', 'Season Sale'].map(
                    (sale) => _customRadioTile(
                      context: context,
                      title: sale,
                      value: sale,
                      groupValue: selectedProductListType,
                      onChanged: (val) =>
                          setState(() => selectedProductListType = val!),
                    ),
                  ),
                  const Divider(color: Colors.white54),
                  _sectionHeader("⭐ Rating"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(5, (index) {
                      final isSelected = index < selectedStar;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedStar = (selectedStar == index + 1)
                                ? 0
                                : index + 1;
                          });
                        },
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 300),
                          scale: isSelected ? 1.2 : 1.0,
                          curve: Curves.easeInOut,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: isSelected ? 1.0 : 0.5,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.all(6),
                              child: ShaderMask(
                                shaderCallback: (Rect bounds) {
                                  return LinearGradient(
                                    colors: isSelected
                                        ? [
                                            Colors.amberAccent,
                                            Colors.deepOrange,
                                          ]
                                        : [Colors.grey, Colors.grey.shade600],
                                  ).createShader(bounds);
                                },
                                blendMode: BlendMode.srcIn,
                                child: const Icon(
                                  Icons.star,
                                  size: 32,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),

                  const Divider(color: Colors.white54),
                  _sectionHeader("🏷️ Brand"),
                  Wrap(
                    spacing: 8,
                    children: ['Apple', 'Samsung', 'Xiaomi', 'Sony', 'Asus']
                        .map((brand) {
                          final isSelected = selectedBrands.contains(brand);
                          return FilterChip(
                            label: Text(brand),
                            selected: isSelected,
                            backgroundColor: Colors.white10,
                            selectedColor: const Color.fromARGB(
                              255,
                              180,
                              5,
                              87,
                            ),
                            checkmarkColor: Colors.white,
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? const Color.fromARGB(255, 43, 43, 43)
                                  : const Color.fromARGB(179, 139, 131, 131),
                            ),
                            onSelected: (val) {
                              setState(() {
                                if (val) {
                                  selectedBrands.add(brand);
                                } else {
                                  selectedBrands.remove(brand);
                                }
                              });
                            },
                          );
                        })
                        .toList(),
                  ),
                  const Divider(color: Colors.white54),
                  _sectionHeader("📦 Usage Status"),
                  ...['New', 'Old'].map(
                    (status) => _customRadioTile(
                      context: context,
                      title: status,
                      value: status,
                      groupValue: selectedUsage,
                      onChanged: (val) => setState(() => selectedUsage = val!),
                    ),
                  ),
                  const Divider(color: Colors.white54),
                  _sectionHeader("🚚 Shipping Unit"),
                  ...['Express delivery', 'Economical delivery'].map(
                    (type) => _customRadioTile(
                      context: context,
                      title: type,
                      value: type,
                      groupValue: selectedShipping,
                      onChanged: (val) =>
                          setState(() => selectedShipping = val!),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.done),
                      label: const Text("Apply"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.tealAccent[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedFilter = {
                            'selectedPrice': selectedPrice,
                            'selectedProductListType': selectedProductListType,
                            'selectedUsage': selectedUsage,
                            'selectedShipping': selectedShipping,
                            'selectedBrands': selectedBrands,
                            'selectedStar': selectedStar,
                          };
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  late AnimationController _bgController;
  late Animation<Color?> _color1;
  late Animation<Color?> _color2;
  late Animation<Color?> _color3;

  List<ProductDetail> productList = [];
  List<ProductDetail> productList_Origin = [];
  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    _color1 = ColorTween(
      begin: const Color(0xFF000000), // Pure Black
      end: const Color(0xFFB0BEC5), // Blue Grey 200 (cool grey tone)
    ).animate(_bgController);

    _color2 = ColorTween(
      begin: const Color(0xFF2196F3), // Material Blue 500
      end: const Color(0xFF90A4AE), // Blue Grey 300
    ).animate(_bgController);

    _color3 = ColorTween(
      begin: const Color(0xFFFFFFFF), // White
      end: const Color(0xFF37474F), // Blue Grey 800 (deep tech grey)
    ).animate(_bgController);
    _loadDataFuture = loadData();
  }

  late Future<void> _loadDataFuture;

  Future<void> loadData() async {
    productList = widget.productList.isEmpty
        ? await FirebaseCloundService.getAllProducts()
        : widget.productList;
    productList_Origin = await FirebaseCloundService.getAllProducts();
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _loadDataFuture,
        builder: (context, asyncSnapshot) {
          switch (asyncSnapshot.connectionState) {
            case ConnectionState.waiting:
              return Text('Loading....');
            default:
              if (asyncSnapshot.hasError)
                return Text('Error: ${asyncSnapshot.error}');
              else {
                return AnimatedBuilder(
                  animation: _bgController,
                  builder: (context, child) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment.center,
                          radius: 1.2,
                          colors: [
                            _color1.value ?? Colors.black,
                            _color2.value ?? Colors.blue,
                            _color3.value ?? Colors.white,
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                      child: SafeArea(
                        child: Column(
                          children: [
                            // AppBar-style header
                            // 🔵 HEADER: Back, Search, Filter
                            TechHeader(onFilterTap: _openFilterDialog),
                            // 🔽 SORT OPTIONS (Horizontal Row)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              color: Colors.transparent,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    _buildSortChip("Delivery Today"),
                                    _buildSortChip("Most Sold"),
                                    _buildSortChip("Most Rate"),
                                    _buildPriceToggleChip(),
                                  ],
                                ),
                              ),
                            ),

                            // Product List
                            Expanded(
                              child: ScrollConfiguration(
                                behavior: const MaterialScrollBehavior()
                                    .copyWith(
                                      dragDevices: {
                                        PointerDeviceKind.touch,
                                        PointerDeviceKind.mouse,
                                      },
                                    ),
                                child: GridView.builder(
                                  padding: const EdgeInsets.all(16),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10,
                                        childAspectRatio: 0.75,
                                      ),
                                  itemCount: productList.length,
                                  itemBuilder: (context, index) {
                                    final product = productList[index];
                                    return AnimationConfiguration.staggeredGrid(
                                      position: index,
                                      duration: const Duration(
                                        milliseconds: 375,
                                      ),
                                      columnCount: 2,
                                      child: ScaleAnimation(
                                        child: FadeInAnimation(
                                          child: ProductCardHoverEffect(
                                            product: product,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
          }
        },
      ),
    );
  }

  Widget _buildSortChip(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label, style: const TextStyle(color: Colors.white)),
        selected: selectedSort == label,
        selectedColor: Colors.deepOrange,
        onSelected: (_) {
          setState(() {
            selectedSort = label;
            productList = productList_Origin;
            switch (label) {
              case "Delivery Today":
                productList = productList
                    .where((element) => element.deliveryDays == 1)
                    .toList();
                break;
              case "Most Sold":
                quickSortDescending_sold(
                  productList,
                  0,
                  productList.length - 1,
                );

                break;
              case "Most Rate":
                quickSortDescending_rate(
                  productList,
                  0,
                  productList.length - 1,
                );

                break;
            }
          });
        },
        backgroundColor: Colors.blueGrey,
      ),
    );
  }

  Widget _buildPriceToggleChip() {
    final isIncrease = selectedSort == 'Prices gradually increase';
    final isDecrease = selectedSort == 'Prices gradually decrease';

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isIncrease ? Icons.arrow_upward : Icons.arrow_downward,
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: 4),
            const Text("Price", style: TextStyle(color: Colors.white)),
          ],
        ),
        selected: isIncrease || isDecrease,
        selectedColor: Colors.deepOrange,
        backgroundColor: Colors.blueGrey,
        onSelected: (_) {
          setState(() {
            productList = productList_Origin;
            if (!isIncrease && !isDecrease) {
              selectedSort = 'Prices gradually increase';
              quickSort(productList, 0, productList.length - 1);
            } else if (isIncrease) {
              selectedSort = 'Prices gradually decrease';
              quickSortDescending(productList, 0, productList.length - 1);
            } else {
              selectedSort = 'None';
              productList = productList_Origin;
            }
          });
        },
      ),
    );
  }

  void quickSort(List<ProductDetail> list, int low, int high) {
    if (low < high) {
      int pivotIndex = _partition(list, low, high);
      quickSort(list, low, pivotIndex - 1);
      quickSort(list, pivotIndex + 1, high);
    }
  }

  int _partition(List<ProductDetail> list, int low, int high) {
    double pivot = list[high].price;
    int i = low - 1;

    for (int j = low; j < high; j++) {
      if (list[j].price < pivot) {
        i++;
        double temp = list[i].price;
        list[i].price = list[j].price;
        list[j].price = temp;
      }
    }

    double temp = list[i + 1].price;
    list[i + 1].price = list[high].price;
    list[high].price = temp;

    return i + 1;
  }

  void quickSortDescending(List<ProductDetail> list, int low, int high) {
    if (low < high) {
      int pivotIndex = _partitionDescending(list, low, high);
      quickSortDescending(list, low, pivotIndex - 1);
      quickSortDescending(list, pivotIndex + 1, high);
    }
  }

  int _partitionDescending(List<ProductDetail> list, int low, int high) {
    double pivot = list[high].price;
    int i = low - 1;

    for (int j = low; j < high; j++) {
      if (list[j].price > pivot) {
        // Change '<' to '>'
        i++;
        double temp = list[i].price;
        list[i].price = list[j].price;
        list[j].price = temp;
      }
    }

    double temp = list[i + 1].price;
    list[i + 1].price = list[high].price;
    list[high].price = temp;

    return i + 1;
  }

  void quickSortDescending_rate(List<ProductDetail> list, int low, int high) {
    if (low < high) {
      int pivotIndex = _partitionDescending_rate(list, low, high);
      quickSortDescending_rate(list, low, pivotIndex - 1);
      quickSortDescending_rate(list, pivotIndex + 1, high);
    }
  }

  int _partitionDescending_rate(List<ProductDetail> list, int low, int high) {
    double pivot = list[high].rate;
    int i = low - 1;

    for (int j = low; j < high; j++) {
      if (list[j].rate > pivot) {
        // Change '<' to '>'
        i++;
        double temp = list[i].rate;
        list[i].rate = list[j].rate;
        list[j].rate = temp;
      }
    }

    double temp = list[i + 1].rate;
    list[i + 1].rate = list[high].rate;
    list[high].rate = temp;

    return i + 1;
  }

  void quickSortDescending_sold(List<ProductDetail> list, int low, int high) {
    if (low < high) {
      int pivotIndex = _partitionDescending_sold(list, low, high);
      quickSortDescending_sold(list, low, pivotIndex - 1);
      quickSortDescending_sold(list, pivotIndex + 1, high);
    }
  }

  int _partitionDescending_sold(List<ProductDetail> list, int low, int high) {
    int pivot = list[high].solds;
    int i = low - 1;

    for (int j = low; j < high; j++) {
      if (list[j].solds > pivot) {
        // Change '<' to '>'
        i++;
        int temp = list[i].solds;
        list[i].solds = list[j].solds;
        list[j].solds = temp;
      }
    }

    int temp = list[i + 1].solds;
    list[i + 1].solds = list[high].solds;
    list[high].solds = temp;

    return i + 1;
  }
}

class TechHeader extends StatelessWidget {
  final VoidCallback onFilterTap;

  const TechHeader({super.key, required this.onFilterTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo.shade900, Colors.blue.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LayoutPage()),
              );
            },
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Container(
              height: 42,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                onSubmitted: (value) async {
                  List<ProductDetail> list =
                      await FirebaseCloundService.getAllProducts();

                  list = list
                      .where(
                        (element) => element.name.toLowerCase().contains(
                          value.toLowerCase().trim(),
                        ),
                      )
                      .toList();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductTechPage(productList: list),
                    ),
                  );
                },
                cursorColor: const Color.fromARGB(255, 14, 167, 134),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  icon: Icon(Icons.search, color: Colors.white70),
                  hintText: 'Search tech products...',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.white),
            tooltip: 'Filter',
            onPressed: onFilterTap,
          ),
        ],
      ),
    );
  }
}

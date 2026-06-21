import 'package:flutter/material.dart';

void main() {
  runApp(const BeautyCatalogApp());
}

class BeautyCatalogApp extends StatelessWidget {
  const BeautyCatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Glow Beauty',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
      ),
      home: const HomePage(),
    );
  }
}

class Product {
  final String name, subtitle, description, price, imageUrl;
  final double rating;

  Product({
    required this.name,
    required this.subtitle,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      subtitle: json['subtitle'],
      description: json['description'],
      price: json['price'],
      imageUrl: json['imageUrl'],
      rating: (json['rating'] as num).toDouble(),
    );
  }
}

final List<Map<String, dynamic>> productJsonData = [
  {
    'name': 'Mat Ruj',
    'subtitle': 'Uzun süre kalıcı',
    'price': '₺349',
    'rating': 4.8,
    'imageUrl': 'assets/images/ruj.webp',
    'description': 'Mat bitişli, günlük kullanıma uygun ve yumuşak dokulu ruj.',
  },
  {
    'name': 'Fondöten',
    'subtitle': 'Doğal kapatıcılık',
    'price': '₺599',
    'rating': 4.7,
    'imageUrl': 'assets/images/fondoten.jfif',
    'description': 'Cilt tonunu eşitleyen, hafif yapılı ve doğal görünümlü fondöten.',
  },
  {
    'name': 'Maskara',
    'subtitle': 'Hacimli kirpikler',
    'price': '₺279',
    'rating': 4.6,
    'imageUrl': 'assets/images/maskara.jfif',
    'description': 'Kirpikleri belirginleştiren, hacim veren siyah maskara.',
  },
  {
    'name': 'Parfüm',
    'subtitle': 'Çiçeksi koku',
    'price': '₺1499',
    'rating': 4.9,
    'imageUrl': 'assets/images/parfum.jfif',
    'description': 'Zarif ve çiçeksi notalara sahip, gün boyu kalıcı parfüm.',
  },
  {
    'name': 'Allık',
    'subtitle': 'Canlı görünüm',
    'price': '₺399',
    'rating': 4.5,
    'imageUrl': 'assets/images/allik.jfif',
    'description': 'Yanaklara doğal ve canlı renk veren pudra allık.',
  },
  {
    'name': 'Nemlendirici',
    'subtitle': 'Cilt bakımı',
    'price': '₺549',
    'rating': 4.7,
    'imageUrl': 'assets/images/nemlendirici.jfif',
    'description': 'Cildi nemlendiren, hafif yapılı günlük bakım kremi.',
  },
];

final List<Product> products =
productJsonData.map((json) => Product.fromJson(json)).toList();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Product> cart = [];
  List<Product> displayedProducts = List.from(products);

  void filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        displayedProducts = List.from(products);
      } else {
        displayedProducts = products
            .where((product) =>
            product.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void addToCart(Product product) {
    setState(() => cart.add(product));
  }

  void removeFromCart(Product product) {
    setState(() => cart.remove(product));
  }

  int get totalPrice {
    int total = 0;
    for (var item in cart) {
      total += int.tryParse(
        item.price.replaceAll('₺', '').replaceAll('.', ''),
      ) ??
          0;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffff7fa),
      appBar: AppBar(
        title: const Text(
          'Glow Beauty',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.pink.shade100,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CartPage(
                        cart: cart,
                        onRemove: removeFromCart,
                      ),
                    ),
                  ).then((_) => setState(() {}));
                },
              ),
              if (cart.isNotEmpty)
                Positioned(
                  right: 6,
                  top: 6,
                  child: CircleAvatar(
                    radius: 9,
                    backgroundColor: Colors.pink,
                    child: Text(
                      cart.length.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              'Kozmetik ürünlerini keşfet',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: filterProducts,
              decoration: const InputDecoration(
                hintText: 'Ürün ara',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
            ),
          ),
          Expanded(
            child: displayedProducts.isEmpty
                ? const Center(child: Text('Aradığınız ürün bulunamadı.'))
                : GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: displayedProducts.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.70,
              ),
              itemBuilder: (context, index) {
                final product = displayedProducts[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailPage(
                          onAdd: () => addToCart(product),
                        ),
                        settings: RouteSettings(arguments: product),
                      ),
                    ).then((_) => setState(() {}));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pink.withValues(alpha:0.12),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(22),
                                ),
                                child: Image.asset(
                                  product.imageUrl,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    product.subtitle,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 15,
                                      ),
                                      Text(
                                        ' ${product.rating}',
                                        style:
                                        const TextStyle(fontSize: 12),
                                      ),
                                      const Spacer(),
                                      Text(
                                        product.price,
                                        style: const TextStyle(
                                          color: Colors.pink,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Positioned(
                          right: 8,
                          top: 8,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.favorite_border,
                              size: 18,
                              color: Colors.pink,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final VoidCallback onAdd;

  const DetailPage({
    super.key,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {

    final product =
    ModalRoute.of(context)!.settings.arguments as Product;

   
    return Scaffold(
      backgroundColor: const Color(0xfffff7fa),
      appBar: AppBar(
        title: const Text('Ürün Detayı'),
        backgroundColor: Colors.pink.shade100,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            product.imageUrl,
            height: 270,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  product.subtitle,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    Text(' ${product.rating}'),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  product.price,
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.pink,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Açıklama',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(product.description),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                icon: const Icon(Icons.shopping_bag_outlined),
                label: const Text('Sepete Ekle'),
                onPressed: () {
                  onAdd();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${product.name} sepete eklendi')),
                  );
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CartPage extends StatefulWidget {
  final List<Product> cart;
  final Function(Product) onRemove;

  const CartPage({
    super.key,
    required this.cart,
    required this.onRemove,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int get totalPrice {
    int total = 0;
    for (var item in widget.cart) {
      total += int.tryParse(
        item.price.replaceAll('₺', '').replaceAll('.', ''),
      ) ??
          0;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffff7fa),
      appBar: AppBar(
        title: const Text('Sepetim'),
        backgroundColor: Colors.pink.shade100,
      ),
      body: widget.cart.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 75,
              color: Colors.grey,
            ),
            SizedBox(height: 12),
            Text('Sepetin boş'),
          ],
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: widget.cart.length,
              itemBuilder: (context, index) {
                final product = widget.cart[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        product.imageUrl,
                        width: 55,
                        height: 55,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(product.name),
                    subtitle: Text(product.price),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.remove_circle_outline,
                        color: Colors.pink,
                      ),
                      onPressed: () {
                        widget.onRemove(product);
                        setState(() {});
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      'Toplam Tutar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '₺$totalPrice',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.pink,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text('Siparişi Tamamla'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
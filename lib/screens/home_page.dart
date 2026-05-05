import 'package:flutter/material.dart';
import '../widgets/menu_card.dart';
import '../widgets/section_header.dart';
import '../widgets/drawer_tile.dart';
import 'login_page.dart';

class HomePage extends StatelessWidget {
  final bool isLoggedIn;
  final String? userName;

  // Sugerencia: Mover esto a un modelo o servicio en el futuro
  static const List<Map<String, dynamic>> _menuData = [
    {
      'category': 'Entradas',
      'icon': Icons.emoji_food_beverage,
      'color': Colors.orangeAccent,
      'items': [
        {
          'title': 'Bruschetta',
          'subtitle': 'Pan tostado con tomate',
          'price': '6.000',
          'icon': Icons.lunch_dining,
          'color': Colors.orange,
        },
        {
          'title': 'Ensalada Caprese',
          'subtitle': 'Tomate y mozzarella',
          'price': '18.000',
          'icon': Icons.set_meal,
          'color': Colors.teal,
        },
      ],
    },
    {
      'category': 'Platos Fuertes',
      'icon': Icons.restaurant_menu,
      'color': Colors.redAccent,
      'items': [
        {
          'title': 'Pasta Alfredo',
          'subtitle': 'Pasta cremosa con pollo',
          'price': '22.000',
          'icon': Icons.ramen_dining,
          'color': Colors.red,
        },
        {
          'title': 'Pizza Margarita',
          'subtitle': 'Tomate y albahaca',
          'price': '25.000',
          'icon': Icons.local_pizza,
          'color': Colors.deepPurple,
        },
      ],
    },
  ];

  const HomePage({super.key, this.isLoggedIn = false, this.userName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      drawer: _buildDrawer(context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.shopping_cart),
        label: const Text('Mi pedido'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 200,
            backgroundColor: theme.colorScheme.primary,
            actions: [
              if (!isLoggedIn)
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.login, color: Colors.white),
                  label: const Text(
                    'Entrar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Oliva y Pimienta'),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, primaryColor.withValues(alpha: 0.6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(
                  Icons.restaurant_menu,
                  size: 96,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
            ),
          ),

          // Renderizado dinámico de secciones
          ..._buildMenuSections(),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  List<Widget> _buildMenuSections() {
    List<Widget> sections = [];
    for (var category in _menuData) {
      sections.add(
        _buildSectionTitle(
          category['category'],
          category['icon'],
          category['color'],
        ),
      );
      sections.add(
        _buildMenuGrid(
          (category['items'] as List)
              .map(
                (item) => MenuCard(
                  title: item['title'],
                  subtitle: item['subtitle'],
                  price: item['price'],
                  icon: item['icon'],
                  color: item['color'],
                ),
              )
              .toList(),
        ),
      );
    }
    return sections;
  }

  Widget _buildSectionTitle(String title, IconData icon, Color color) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
        child: SectionHeader(title: title, icon: icon, color: color),
      ),
    );
  }

  Widget _buildMenuGrid(List<Widget> children) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        delegate: SliverChildListDelegate(children),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primaryContainer,
                  theme.colorScheme.primary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: theme.colorScheme.onPrimary.withValues(
                    alpha: 0.2,
                  ),
                  child: const Icon(
                    Icons.restaurant_menu,
                    size: 36,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    userName != null
                        ? 'Bienvenido, $userName'
                        : 'Bienvenido a Oliva y Pimienta',
                    style: TextStyle(
                      fontSize: 18,
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const DrawerTile(icon: Icons.home, label: 'Inicio'),
                const DrawerTile(icon: Icons.fastfood, label: 'Entradas'),
                const DrawerTile(
                  icon: Icons.restaurant,
                  label: 'Platos Fuertes',
                ),
                const DrawerTile(icon: Icons.local_drink, label: 'Bebidas'),
                const DrawerTile(icon: Icons.settings, label: 'Configuración'),
                if (isLoggedIn) ...[
                  const Divider(),
                  DrawerTile(
                    icon: Icons.logout,
                    label: 'Cerrar Sesión',
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                        (route) => false, // Limpia el historial de navegación
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

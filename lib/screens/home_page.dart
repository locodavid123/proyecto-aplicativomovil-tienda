import 'package:flutter/material.dart';
import '../widgets/menu_card.dart';
import '../widgets/drawer_tile.dart';
import '../services/api_service.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  final bool isLoggedIn;
  final String? userName;

  const HomePage({super.key, this.isLoggedIn = false, this.userName});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _allMeals = [];
  List<dynamic> _filteredMeals = [];
  List<String> _categories = ['Todas'];
  String _selectedCategory = 'Todas';
  String _searchQuery = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final categories = await ApiService.fetchCategories();
      final meals = await ApiService.fetchMeals('');
      
      setState(() {
        _categories = ['Todas', ...categories];
        _allMeals = meals;
        _filteredMeals = meals;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _filterMeals(String query, String category) {
    setState(() {
      _searchQuery = query;
      _selectedCategory = category;
      
      _filteredMeals = _allMeals.where((meal) {
        final matchesQuery = meal['strMeal']
                ?.toString()
                .toLowerCase()
                .contains(query.toLowerCase()) ?? false;
        final matchesCategory = category == 'Todas' || meal['strCategory'] == category;
        return matchesQuery && matchesCategory;
      }).toList();
    });
  }

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
            backgroundColor: primaryColor,
            actions: [
              if (!widget.isLoggedIn)
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
          
          // Barra de búsqueda
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (value) => _filterMeals(value, _selectedCategory),
                decoration: InputDecoration(
                  hintText: 'Buscar platillo...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),
          ),

          // Filtro de categorías
          SliverToBoxAdapter(
            child: SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = category == _selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          _filterMeals(_searchQuery, category);
                        }
                      },
                      selectedColor: primaryColor.withValues(alpha: 0.2),
                      labelStyle: TextStyle(
                        color: isSelected ? primaryColor : Colors.black87,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Contenido principal
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_filteredMeals.isEmpty)
            const SliverFillRemaining(
              child: Center(child: Text('No se encontraron platillos.')),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.75, // Ajustado para la imagen
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final meal = _filteredMeals[index];
                    return MenuCard(
                      title: meal['strMeal'] ?? 'Sin nombre',
                      subtitle: meal['strCategory'] ?? 'Sin categoría',
                      price: (meal['idMeal'] != null 
                              ? (int.parse(meal['idMeal'].toString().substring(0, 2)) * 1000).toString() 
                              : '15.000'), // Precio simulado basado en el ID
                      imageUrl: meal['strMealThumb'],
                      color: primaryColor,
                    );
                  },
                  childCount: _filteredMeals.length,
                ),
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
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
                    widget.userName != null
                        ? 'Bienvenido, ${widget.userName}'
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
                DrawerTile(
                  icon: Icons.home,
                  label: 'Inicio',
                  onTap: () {
                    _filterMeals(_searchQuery, 'Todas');
                  },
                ),
                DrawerTile(
                  icon: Icons.cake,
                  label: 'Postres',
                  onTap: () {
                    _filterMeals(_searchQuery, 'Dessert');
                  },
                ),
                DrawerTile(
                  icon: Icons.restaurant,
                  label: 'Platos Fuertes',
                  onTap: () {
                    _filterMeals(_searchQuery, 'Beef');
                  },
                ),
                DrawerTile(
                  icon: Icons.soup_kitchen,
                  label: 'Sopas',
                  onTap: () {
                    _filterMeals(_searchQuery, 'Miscellaneous');
                  },
                ),
                DrawerTile(
                  icon: Icons.settings,
                  label: 'Configuración',
                  onTap: () {
                  },
                ),
                if (widget.isLoggedIn) ...[
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
                        (route) => false,
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

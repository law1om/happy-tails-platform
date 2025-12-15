import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/animal_model.dart';
import 'animal_detail_screen.dart';

class AnimalsCatalogScreen extends StatefulWidget {
  @override
  _AnimalsCatalogScreenState createState() => _AnimalsCatalogScreenState();
}

class _AnimalsCatalogScreenState extends State<AnimalsCatalogScreen> {
  List<AnimalModel> _animals = [];
  List<AnimalModel> _filteredAnimals = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String? _selectedSpecies;
  String? _selectedStatus;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAnimals();
  }

  Future<void> _loadAnimals() async {
    setState(() => _isLoading = true);
    try {
      final data = await ApiService.getAnimals();
      final animals = data.map((json) => AnimalModel.fromJson(json)).toList();
      setState(() {
        _animals = animals;
        _filteredAnimals = animals;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка загрузки: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredAnimals = _animals.where((animal) {
        final matchesSearch =
            animal.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                animal.breed.toLowerCase().contains(_searchQuery.toLowerCase());
        final matchesSpecies =
            _selectedSpecies == null || animal.species == _selectedSpecies;
        final matchesStatus =
            _selectedStatus == null || animal.status == _selectedStatus;
        return matchesSearch && matchesSpecies && matchesStatus;
      }).toList();
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Фильтры'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedSpecies,
              decoration: InputDecoration(labelText: 'Вид'),
              items: [
                DropdownMenuItem(value: null, child: Text('Все')),
                DropdownMenuItem(value: 'DOG', child: Text('Собаки')),
                DropdownMenuItem(value: 'CAT', child: Text('Кошки')),
              ],
              onChanged: (value) {
                setState(() => _selectedSpecies = value);
              },
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: InputDecoration(labelText: 'Статус'),
              items: [
                DropdownMenuItem(value: null, child: Text('Все')),
                DropdownMenuItem(value: 'AVAILABLE', child: Text('Доступен')),
                DropdownMenuItem(
                    value: 'RESERVED', child: Text('Забронирован')),
                DropdownMenuItem(value: 'ADOPTED', child: Text('Усыновлен')),
              ],
              onChanged: (value) {
                setState(() => _selectedStatus = value);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _selectedSpecies = null;
                _selectedStatus = null;
              });
              _applyFilters();
              Navigator.pop(context);
            },
            child: Text('Сбросить'),
          ),
          ElevatedButton(
            onPressed: () {
              _applyFilters();
              Navigator.pop(context);
            },
            child: Text('Применить'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Каталог животных'),
        backgroundColor: Color(0xFF4CAF50),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Поиск
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Поиск по имени или породе...',
                prefixIcon: Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                          _applyFilters();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
                _applyFilters();
              },
            ),
          ),

          // Активные фильтры
          if (_selectedSpecies != null || _selectedStatus != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                children: [
                  if (_selectedSpecies != null)
                    Chip(
                      label:
                          Text(_selectedSpecies == 'DOG' ? 'Собаки' : 'Кошки'),
                      onDeleted: () {
                        setState(() => _selectedSpecies = null);
                        _applyFilters();
                      },
                    ),
                  if (_selectedStatus != null)
                    Chip(
                      label: Text(_selectedStatus == 'AVAILABLE'
                          ? 'Доступен'
                          : _selectedStatus == 'RESERVED'
                              ? 'Забронирован'
                              : 'Усыновлен'),
                      onDeleted: () {
                        setState(() => _selectedStatus = null);
                        _applyFilters();
                      },
                    ),
                ],
              ),
            ),

          // Список животных
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _filteredAnimals.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.pets, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'Животные не найдены',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadAnimals,
                        child: GridView.builder(
                          padding: EdgeInsets.all(16),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: _filteredAnimals.length,
                          itemBuilder: (context, index) {
                            final animal = _filteredAnimals[index];
                            return _buildAnimalCard(animal);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimalCard(AnimalModel animal) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AnimalDetailScreen(animal: animal),
          ),
        );
        // После возврата обновляем список, чтобы отобразить изменившийся статус
        _loadAnimals();
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Фото
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                child: animal.photos.isNotEmpty
                    ? Image.network(
                        animal.photos[0],
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child:
                                Icon(Icons.pets, size: 48, color: Colors.grey),
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey[300],
                        child: Icon(Icons.pets, size: 48, color: Colors.grey),
                      ),
              ),
            ),
            // Информация
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    animal.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${animal.speciesRu} • ${animal.age} ${_getAgeText(animal.age)}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(animal.status),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      animal.statusRu,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getAgeText(int age) {
    if (age == 1) return 'год';
    if (age >= 2 && age <= 4) return 'года';
    return 'лет';
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'AVAILABLE':
        return Colors.green;
      case 'RESERVED':
        return Colors.orange;
      case 'ADOPTED':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import '../models/animal_model.dart';
import '../services/api_service.dart';

class AnimalDetailScreen extends StatefulWidget {
  final AnimalModel animal;

  AnimalDetailScreen({required this.animal});

  @override
  _AnimalDetailScreenState createState() => _AnimalDetailScreenState();
}

class _AnimalDetailScreenState extends State<AnimalDetailScreen> {
  bool _isSubmitting = false;
  Map<String, dynamic>? _currentUser;
  bool _isLoadingUser = true;
  late AnimalModel _animal;
  bool _isLoadingAnimal = true;

  @override
  void initState() {
    super.initState();
    _animal = widget.animal;
    _loadCurrentUser();
    _refreshAnimal();
  }

  Future<void> _loadCurrentUser() async {
    try {
      final user = await ApiService.getCurrentUser();
      setState(() {
        _currentUser = user;
        _isLoadingUser = false;
      });
    } catch (e) {
      setState(() => _isLoadingUser = false);
    }
  }

  Future<void> _refreshAnimal() async {
    try {
      final json = await ApiService.getAnimalById(widget.animal.id);
      setState(() {
        _animal = AnimalModel.fromJson(json);
        _isLoadingAnimal = false;
      });
    } catch (e) {
      setState(() => _isLoadingAnimal = false);
    }
  }

  bool get isAdmin => _currentUser?['role'] == 'ADMIN';

  Future<void> _submitApplication() async {
    if (_animal.status != 'AVAILABLE') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Это животное недоступно для усыновления'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await ApiService.createApplication(_animal.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Заявка успешно подана!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  void _showDonationDialog(int shelterId) {
    final TextEditingController amountController = TextEditingController();
    final TextEditingController messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Пожертвование приюту'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Сумма (₸)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: messageController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Сообщение (необязательно)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () async {
              final amount = double.tryParse(amountController.text);
              if (amount == null || amount <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Введите корректную сумму'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              try {
                await ApiService.donateShelter(
                  shelterId,
                  amount,
                  messageController.text.isEmpty
                      ? null
                      : messageController.text,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Спасибо за ваше пожертвование!'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Ошибка: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink,
              foregroundColor: Colors.white,
            ),
            child: Text('Пожертвовать'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_animal.name),
        backgroundColor: Color(0xFF4CAF50),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Фото животного
            _animal.photos.isNotEmpty
                ? Image.network(
                    _animal.photos[0],
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 300,
                        color: Colors.grey[300],
                        child: Icon(Icons.pets, size: 80, color: Colors.grey),
                      );
                    },
                  )
                : Container(
                    height: 300,
                    color: Colors.grey[300],
                    child: Icon(Icons.pets, size: 80, color: Colors.grey),
                  ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _animal.name,
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getStatusColor(_animal.status),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _animal.statusRu,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${_animal.speciesRu} • ${_animal.breed}',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                  ),
                  SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildInfoChip(Icons.cake, '${_animal.age} лет'),
                      _buildInfoChip(
                          Icons.monitor_weight, '${_animal.weight} кг'),
                      _buildInfoChip(Icons.male, _animal.genderRu),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Описание',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    _animal.description,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Здоровье',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    _animal.healthStatus,
                    style: TextStyle(fontSize: 16),
                  ),
                  if (_animal.shelterName != null) ...[
                    SizedBox(height: 16),
                    Text(
                      'Приют',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Card(
                      color: Colors.blue[50],
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Icon(Icons.home, color: Colors.blue),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _animal.shelterName!,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ),
                            if (!_isLoadingUser && !isAdmin)
                              ElevatedButton.icon(
                                onPressed: () =>
                                    _showDonationDialog(_animal.shelterId!),
                                icon: Icon(Icons.favorite, size: 18),
                                label: Text('Помочь'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.pink,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: 24),
                  if (!_isLoadingUser && !isAdmin)
                    _isSubmitting
                        ? Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: _animal.status == 'AVAILABLE'
                                ? _submitApplication
                                : null,
                            child: Text(
                              _animal.status == 'AVAILABLE'
                                  ? 'Подать заявку на усыновление'
                                  : 'Недоступно',
                              style: TextStyle(fontSize: 16),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF4CAF50),
                              foregroundColor: Colors.white,
                              minimumSize: Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
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

  Widget _buildInfoChip(IconData icon, String label) {
    return Chip(
      avatar: Icon(icon, size: 18, color: Color(0xFF4CAF50)),
      label: Text(label),
      backgroundColor: Colors.green[50],
    );
  }
}

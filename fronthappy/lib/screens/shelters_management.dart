import 'package:flutter/material.dart';
import '../services/api_service.dart';

// Управление приютами
class SheltersManagement extends StatefulWidget {
  @override
  _SheltersManagementState createState() => _SheltersManagementState();
}

class _SheltersManagementState extends State<SheltersManagement> {
  List<Map<String, dynamic>> shelters = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadShelters();
  }

  Future<void> _loadShelters() async {
    try {
      setState(() => _isLoading = true);
      final response = await ApiService.getShelters();
      setState(() {
        shelters = List<Map<String, dynamic>>.from(response);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Ошибка загрузки: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _deleteShelter(int id) async {
    try {
      await ApiService.deleteShelter(id);
      await _loadShelters();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Приют удален!'), backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _showShelterDialog({Map<String, dynamic>? shelter}) {
    final nameController = TextEditingController(text: shelter?['name'] ?? '');
    final descController =
        TextEditingController(text: shelter?['description'] ?? '');
    final addressController =
        TextEditingController(text: shelter?['address'] ?? '');
    final phoneController =
        TextEditingController(text: shelter?['phone'] ?? '');
    final emailController =
        TextEditingController(text: shelter?['email'] ?? '');
    final bankController =
        TextEditingController(text: shelter?['bankAccount'] ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(shelter == null ? 'Добавить приют' : 'Редактировать приют'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                    labelText: 'Название', border: OutlineInputBorder()),
              ),
              SizedBox(height: 12),
              TextField(
                controller: descController,
                maxLines: 3,
                decoration: InputDecoration(
                    labelText: 'Описание', border: OutlineInputBorder()),
              ),
              SizedBox(height: 12),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                    labelText: 'Адрес', border: OutlineInputBorder()),
              ),
              SizedBox(height: 12),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                    labelText: 'Телефон', border: OutlineInputBorder()),
              ),
              SizedBox(height: 12),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                    labelText: 'Email', border: OutlineInputBorder()),
              ),
              SizedBox(height: 12),
              TextField(
                controller: bankController,
                decoration: InputDecoration(
                    labelText: 'Банковский счет', border: OutlineInputBorder()),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () async {
              final data = {
                'name': nameController.text,
                'description': descController.text,
                'address': addressController.text,
                'phone': phoneController.text,
                'email': emailController.text,
                'bankAccount': bankController.text,
              };

              try {
                if (shelter == null) {
                  await ApiService.createShelter(data);
                } else {
                  await ApiService.updateShelter(shelter['id'], data);
                }
                Navigator.pop(context);
                await _loadShelters();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        shelter == null ? 'Приют создан!' : 'Приют обновлен!'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Ошибка: $e'), backgroundColor: Colors.red),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF4CAF50)),
            child: Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Приюты',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                onPressed: () => _showShelterDialog(),
                icon: Icon(Icons.add),
                label: Text('Добавить'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4CAF50)),
              ),
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : shelters.isEmpty
                    ? Center(child: Text('Нет приютов'))
                    : ListView.builder(
                        itemCount: shelters.length,
                        itemBuilder: (context, index) {
                          final shelter = shelters[index];
                          return Card(
                            margin: EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: Icon(Icons.home,
                                  color: Colors.blue, size: 40),
                              title: Text(shelter['name'] ?? '',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (shelter['address'] != null)
                                    Text('📍 ${shelter['address']}'),
                                  if (shelter['phone'] != null)
                                    Text('📞 ${shelter['phone']}'),
                                  Text(
                                      'Животных: ${shelter['animalCount'] ?? 0}'),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () =>
                                        _showShelterDialog(shelter: shelter),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () =>
                                        _deleteShelter(shelter['id']),
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

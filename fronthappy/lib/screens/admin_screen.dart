import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'shelters_management.dart';
import 'donations_management.dart';

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Color(0xFF4CAF50),
          child: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(icon: Icon(Icons.assignment), text: 'Заявки'),
              Tab(icon: Icon(Icons.pets), text: 'Животные'),
              Tab(icon: Icon(Icons.home), text: 'Приюты'),
              Tab(icon: Icon(Icons.favorite), text: 'Пожертвования'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              ApplicationsManagement(),
              AnimalsManagement(),
              SheltersManagement(),
              DonationsManagement(),
            ],
          ),
        ),
      ],
    );
  }
}

// Управление животными с функциями редактирования/удаления
class AnimalsManagement extends StatefulWidget {
  @override
  _AnimalsManagementState createState() => _AnimalsManagementState();
}

class _AnimalsManagementState extends State<AnimalsManagement> {
  List<Map<String, dynamic>> animals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAnimals();
  }

  Future<void> _loadAnimals() async {
    try {
      setState(() => _isLoading = true);
      final response = await ApiService.getAnimals();
      setState(() {
        animals = List<Map<String, dynamic>>.from(response);
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

  Future<void> _deleteAnimal(int id) async {
    try {
      await ApiService.deleteAnimal(id);
      await _loadAnimals();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Животное удалено!'), backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Ошибка удаления: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _editAnimal(Map<String, dynamic> animal) {
    _showAddAnimalDialog(context, animal: animal);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Управление животными (${animals.length})',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddAnimalDialog(context),
                icon: Icon(Icons.add),
                label: Text('Добавить'),
              ),
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: animals.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.pets, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('Нет животных',
                            style: TextStyle(fontSize: 18, color: Colors.grey)),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: animals.length,
                    itemBuilder: (context, index) {
                      final animal = animals[index];
                      // Get first photo URL from photos array
                      String? photoUrl;
                      if (animal['photos'] != null &&
                          animal['photos'] is List &&
                          (animal['photos'] as List).isNotEmpty) {
                        final firstPhoto = (animal['photos'] as List)[0];
                        if (firstPhoto is String) {
                          photoUrl = firstPhoto;
                        } else if (firstPhoto is Map &&
                            firstPhoto['url'] != null) {
                          photoUrl = firstPhoto['url'].toString();
                        }
                      }

                      return Card(
                        child: ListTile(
                          leading: photoUrl != null
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(photoUrl),
                                  onBackgroundImageError: (_, __) {},
                                )
                              : CircleAvatar(child: Icon(Icons.pets)),
                          title: Text(animal['name'] ?? 'Без имени'),
                          subtitle: Text(
                              '${animal['breed'] ?? ''} • ${animal['type'] ?? ''} • ${animal['status'] ?? ''}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _editAnimal(animal),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () =>
                                    _deleteAnimal(animal['id'] as int),
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

  void _showAddAnimalDialog(BuildContext context,
      {Map<String, dynamic>? animal}) {
    final nameController = TextEditingController(text: animal?['name'] ?? '');
    final breedController = TextEditingController(text: animal?['breed'] ?? '');
    final ageController =
        TextEditingController(text: animal?['age']?.toString() ?? '');
    final weightController =
        TextEditingController(text: animal?['weight']?.toString() ?? '');
    final descController =
        TextEditingController(text: animal?['description'] ?? '');

    // Extract existing photo URLs from animal data
    String existingPhotoUrl = '';
    if (animal != null &&
        animal['photos'] != null &&
        animal['photos'] is List &&
        (animal['photos'] as List).isNotEmpty) {
      final firstPhoto = (animal['photos'] as List)[0];
      if (firstPhoto is String) {
        existingPhotoUrl = firstPhoto;
      } else if (firstPhoto is Map && firstPhoto['url'] != null) {
        existingPhotoUrl = firstPhoto['url'].toString();
      }
    }

    final photoUrlController = TextEditingController(text: existingPhotoUrl);
    String selectedType = animal?['type'] ?? 'DOG';
    String selectedStatus = animal?['status'] ?? 'AVAILABLE';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
            animal == null ? 'Добавить животное' : 'Редактировать животное'),
        content: StatefulBuilder(
          builder: (context, setDialogState) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Имя*')),
                TextField(
                    controller: breedController,
                    decoration: InputDecoration(labelText: 'Порода*')),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: InputDecoration(labelText: 'Тип*'),
                  items: [
                    DropdownMenuItem(value: 'DOG', child: Text('Собака')),
                    DropdownMenuItem(value: 'CAT', child: Text('Кошка')),
                  ],
                  onChanged: (value) =>
                      setDialogState(() => selectedType = value!),
                ),
                TextField(
                    controller: ageController,
                    decoration: InputDecoration(labelText: 'Возраст*'),
                    keyboardType: TextInputType.number),
                TextField(
                    controller: weightController,
                    decoration: InputDecoration(labelText: 'Вес*'),
                    keyboardType: TextInputType.number),
                TextField(
                    controller: descController,
                    decoration: InputDecoration(labelText: 'Описание'),
                    maxLines: 3),
                TextField(
                    controller: photoUrlController,
                    decoration: InputDecoration(
                        labelText: 'URL фото',
                        hintText: 'https://example.com/photo.jpg'),
                    keyboardType: TextInputType.url),
                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  decoration: InputDecoration(labelText: 'Статус*'),
                  items: [
                    DropdownMenuItem(
                        value: 'AVAILABLE', child: Text('Доступен')),
                    DropdownMenuItem(
                        value: 'ADOPTED', child: Text('Усыновлен')),
                    DropdownMenuItem(
                        value: 'RESERVED', child: Text('Зарезервирован')),
                  ],
                  onChanged: (value) =>
                      setDialogState(() => selectedStatus = value!),
                ),
              ],
            ),
          ),
        ),
        actions: [
          if (animal != null)
            TextButton(
              onPressed: () => _deleteAnimal(animal['id'] as int),
              child: Text('Удалить', style: TextStyle(color: Colors.red)),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty &&
                  breedController.text.isNotEmpty) {
                try {
                  final data = {
                    'name': nameController.text,
                    'breed': breedController.text,
                    'type': selectedType,
                    'age': int.tryParse(ageController.text) ?? 0,
                    'weight': double.tryParse(weightController.text) ?? 0.0,
                    'description': descController.text,
                    'photoUrls': photoUrlController.text.isNotEmpty
                        ? [photoUrlController.text]
                        : [],
                    'status': selectedStatus,
                  };

                  if (animal == null) {
                    await ApiService.createAnimal(data);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Животное добавлено!'),
                          backgroundColor: Colors.green),
                    );
                  } else {
                    await ApiService.updateAnimal(animal['id'] as int, data);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Изменения сохранены!'),
                          backgroundColor: Colors.green),
                    );
                  }
                  await _loadAnimals();
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Ошибка: $e'),
                        backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: Text(animal == null ? 'Добавить' : 'Сохранить'),
          ),
        ],
      ),
    );
  }
}

// Управление заявками с функциями одобрения/отклонения/удаления
class ApplicationsManagement extends StatefulWidget {
  @override
  _ApplicationsManagementState createState() => _ApplicationsManagementState();
}

class _ApplicationsManagementState extends State<ApplicationsManagement> {
  List<Map<String, dynamic>> applications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadApplications();
  }

  Future<void> _loadApplications() async {
    try {
      setState(() => _isLoading = true);
      final response = await ApiService.getAllApplications();
      setState(() {
        applications = List<Map<String, dynamic>>.from(response);
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

  Future<void> _updateApplicationStatus(
      int id, String status, String? comment) async {
    try {
      await ApiService.updateApplicationStatus(id, status, comment);
      await _loadApplications();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Статус заявки обновлен!'),
            backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Ошибка обновления: $e'),
            backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Заявки на усыновление (${applications.length})',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Expanded(
            child: applications.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.assignment, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('Нет заявок',
                            style: TextStyle(fontSize: 18, color: Colors.grey)),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: applications.length,
                    itemBuilder: (context, index) {
                      final app = applications[index];
                      return Card(
                        child: ListTile(
                          leading: Icon(Icons.person),
                          title: Text(
                              '${app['userName'] ?? 'Неизвестно'} → ${app['animalName'] ?? 'Неизвестно'}'),
                          subtitle: Text(
                              'Подана: ${app['date'] ?? app['createdAt'] ?? 'Неизвестно'} • ${app['phone'] ?? 'Нет телефона'}'),
                          trailing: Chip(
                            label: Text(
                                _getStatusText(app['status'] ?? 'PENDING')),
                            backgroundColor:
                                _getStatusColor(app['status'] ?? 'PENDING'),
                            labelStyle:
                                TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          onTap: () => _showApplicationDetails(context, app),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'APPROVED':
        return 'Одобрена';
      case 'REJECTED':
        return 'Отклонена';
      case 'PENDING':
        return 'На рассмотрении';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'APPROVED':
        return Colors.green;
      case 'REJECTED':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  void _showApplicationDetails(BuildContext context, Map<String, dynamic> app) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Заявка на усыновление'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Пользователь: ${app['userName']}',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Телефон: ${app['phone']}'),
              Text('Животное: ${app['animalName']}'),
              Text('Дата: ${app['date']}'),
              Text('Статус: ${_getStatusText(app['status'] ?? '')}'),
              SizedBox(height: 10),
              Text('Комментарий:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(app['comment'] ?? 'Нет комментария'),
            ],
          ),
        ),
        actions: [
          if (app['status'] == 'PENDING') ...[
            TextButton(
              onPressed: () {
                _updateApplicationStatus(
                    app['id'], 'REJECTED', 'Заявка отклонена');
                Navigator.pop(context);
              },
              child: Text('Отклонить', style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () {
                _updateApplicationStatus(
                    app['id'], 'APPROVED', 'Заявка одобрена');
                Navigator.pop(context);
              },
              child: Text('Одобрить'),
            ),
          ] else
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Закрыть'),
            ),
        ],
      ),
    );
  }
}

// Управление событиями с функциями редактирования/удаления
class EventsManagement extends StatefulWidget {
  @override
  _EventsManagementState createState() => _EventsManagementState();
}

class _EventsManagementState extends State<EventsManagement> {
  List<Map<String, dynamic>> events = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      setState(() => _isLoading = true);
      final response = await ApiService.getEvents();
      setState(() {
        events = List<Map<String, dynamic>>.from(response);
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

  Future<void> _deleteEvent(int id) async {
    try {
      await ApiService.deleteEvent(id);
      await _loadEvents();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Событие удалено!'), backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Ошибка удаления: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _editEvent(Map<String, dynamic> event) {
    _showAddEventDialog(context, event: event);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'События приюта (${events.length})',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddEventDialog(context),
                icon: Icon(Icons.add),
                label: Text('Добавить'),
              ),
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: events.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('Нет событий',
                            style: TextStyle(fontSize: 18, color: Colors.grey)),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return Card(
                        child: ListTile(
                          leading: Icon(Icons.event, color: Colors.purple),
                          title: Text(event['title'] ?? 'Без названия'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(event['eventDate']?.toString() ?? ''),
                              if (event['description'] != null)
                                Text(
                                  event['description'],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _editEvent(event),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () =>
                                    _deleteEvent(event['id'] as int),
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

  void _showAddEventDialog(BuildContext context,
      {Map<String, dynamic>? event}) {
    final titleController = TextEditingController(text: event?['title'] ?? '');
    final locationController =
        TextEditingController(text: event?['location'] ?? '');
    final descController =
        TextEditingController(text: event?['description'] ?? '');
    final maxParticipantsController = TextEditingController(
        text: event?['maxParticipants']?.toString() ?? '50');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:
            Text(event == null ? 'Добавить событие' : 'Редактировать событие'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Название события*')),
              TextField(
                  controller: locationController,
                  decoration: InputDecoration(labelText: 'Место проведения*')),
              TextField(
                  controller: descController,
                  decoration: InputDecoration(labelText: 'Описание'),
                  maxLines: 3),
              TextField(
                  controller: maxParticipantsController,
                  decoration: InputDecoration(labelText: 'Макс. участников*'),
                  keyboardType: TextInputType.number),
              SizedBox(height: 8),
              Text('Дата через 7 дней от текущего времени',
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
        actions: [
          if (event != null)
            TextButton(
              onPressed: () {
                _deleteEvent(event['id'] as int);
                Navigator.pop(context);
              },
              child: Text('Удалить', style: TextStyle(color: Colors.red)),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty &&
                  locationController.text.isNotEmpty) {
                try {
                  final eventData = {
                    'title': titleController.text,
                    'description': descController.text,
                    'location': locationController.text,
                    'eventDate':
                        DateTime.now().add(Duration(days: 7)).toIso8601String(),
                    'maxParticipants':
                        int.tryParse(maxParticipantsController.text) ?? 50,
                    'status': 'UPCOMING',
                  };

                  if (event == null) {
                    await ApiService.createEvent(eventData);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Событие создано!'),
                          backgroundColor: Colors.green),
                    );
                  } else {
                    await ApiService.updateEvent(event['id'] as int, eventData);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Изменения сохранены!'),
                          backgroundColor: Colors.green),
                    );
                  }
                  await _loadEvents();
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Ошибка: $e'),
                        backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: Text(event == null ? 'Добавить' : 'Сохранить'),
          ),
        ],
      ),
    );
  }
}

// Управление пользователями с функциями блокировки/удаления
class UsersManagement extends StatefulWidget {
  @override
  _UsersManagementState createState() => _UsersManagementState();
}

class _UsersManagementState extends State<UsersManagement> {
  List<Map<String, dynamic>> users = [
    {
      'id': 1,
      'name': 'Дмитрий Тумаев',
      'email': 'dmitym@mail.ru',
      'role': 'Пользователь',
      'status': 'Активен'
    },
    {
      'id': 2,
      'name': 'Каролина Миллер',
      'email': 'miller@mail.ru',
      'role': 'Пользователь',
      'status': 'Активен'
    },
    {
      'id': 3,
      'name': 'Админ',
      'email': 'admin@happytails.ru',
      'role': 'Администратор',
      'status': 'Активен'
    },
  ];

  void _toggleUserStatus(int id) {
    setState(() {
      final index = users.indexWhere((user) => user['id'] == id);
      if (index != -1) {
        users[index]['status'] =
            users[index]['status'] == 'Активен' ? 'Заблокирован' : 'Активен';
      }
    });
  }

  void _deleteUser(int id) {
    setState(() {
      users.removeWhere((user) => user['id'] == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Пользователи',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title: Text(user['name']),
                    subtitle: Text(user['email']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Chip(
                          label: Text(user['role']),
                          backgroundColor: user['role'] == 'Администратор'
                              ? Colors.red
                              : Colors.blue,
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                        SizedBox(width: 8),
                        IconButton(
                          icon: Icon(
                            user['status'] == 'Активен'
                                ? Icons.block
                                : Icons.check_circle,
                            color: user['status'] == 'Активен'
                                ? Colors.green
                                : Colors.red,
                          ),
                          onPressed: () => _toggleUserStatus(user['id']),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteUser(user['id']),
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

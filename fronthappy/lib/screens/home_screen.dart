import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Happy Tails 🐾'),
        backgroundColor: const Color(0xFF4CAF50),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pets, size: 80, color: Colors.green),
            SizedBox(height: 20),
            Text(
              'Добро пожаловать в Happy Tails!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Помогаем найти дом для бездомных животных',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminPanel extends StatefulWidget {
  const AdminPanel({Key? key}) : super(key: key);

  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = const <Widget>[
    AnimalsManagement(),
    ApplicationsManagement(),
    EventsManagement(),
    UsersManagement(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Админ-панель'),
        backgroundColor: Colors.red[700],
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Животные',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Заявки',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'События',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Пользователи',
          ),
        ],
      ),
    );
  }
}

// Управление животными
class AnimalsManagement extends StatefulWidget {
  const AnimalsManagement({Key? key}) : super(key: key);

  @override
  _AnimalsManagementState createState() => _AnimalsManagementState();
}

class _AnimalsManagementState extends State<AnimalsManagement> {
  List<Map<String, dynamic>> animals = [
    {
      'id': 1,
      'name': 'Барсик',
      'breed': 'Дворняжка',
      'age': 2,
      'weight': 4.2,
      'description': 'Очень ласковый и игривый кот',
      'status': 'Доступен'
    },
    {
      'id': 2,
      'name': 'Шарик',
      'breed': 'Овчарка',
      'age': 3,
      'weight': 28.5,
      'description': 'Верный и умный пёс',
      'status': 'Забронирован'
    },
    {
      'id': 3,
      'name': 'Мурка',
      'breed': 'Сиамская',
      'age': 1,
      'weight': 3.1,
      'description': 'Элегантная и умная кошка',
      'status': 'Доступен'
    },
  ];

  void _deleteAnimal(int id) {
    setState(() {
      animals.removeWhere((animal) => animal['id'] == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Животное удалено!'), backgroundColor: Colors.green),
    );
  }

  void _editAnimal(Map<String, dynamic> animal) {
    _showAddAnimalDialog(context, animal: animal);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Управление животными',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddAnimalDialog(context),
                icon: const Icon(Icons.add),
                label: const Text('Добавить животное'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: animals.length,
              itemBuilder: (context, index) {
                final animal = animals[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.pets, size: 40),
                    title: Text(
                      animal['name'],
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Порода: ${animal['breed']}'),
                        Text('Возраст: ${animal['age']} года'),
                        Text('Вес: ${animal['weight']} кг'),
                        const SizedBox(height: 4),
                        Chip(
                          label: Text(
                            animal['status'],
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: animal['status'] == 'Доступен'
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editAnimal(animal),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteAnimal(animal['id']),
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

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
            animal == null ? 'Добавить животное' : 'Редактировать животное'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Имя*')),
              TextField(
                  controller: breedController,
                  decoration: const InputDecoration(labelText: 'Порода*')),
              TextField(
                  controller: ageController,
                  decoration: const InputDecoration(labelText: 'Возраст*'),
                  keyboardType: TextInputType.number),
              TextField(
                  controller: weightController,
                  decoration: const InputDecoration(labelText: 'Вес*'),
                  keyboardType: TextInputType.number),
              TextField(
                  controller: descController,
                  decoration: const InputDecoration(labelText: 'Описание'),
                  maxLines: 3),
            ],
          ),
        ),
        actions: [
          if (animal != null)
            TextButton(
              onPressed: () => _deleteAnimal(animal['id']),
              child: const Text('Удалить', style: TextStyle(color: Colors.red)),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  breedController.text.isNotEmpty) {
                if (animal == null) {
                  setState(() {
                    animals.add({
                      'id': DateTime.now().millisecondsSinceEpoch,
                      'name': nameController.text,
                      'breed': breedController.text,
                      'age': int.tryParse(ageController.text) ?? 0,
                      'weight': double.tryParse(weightController.text) ?? 0.0,
                      'description': descController.text,
                      'status': 'Доступен'
                    });
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Животное добавлено!'),
                        backgroundColor: Colors.green),
                  );
                } else {
                  setState(() {
                    final index =
                        animals.indexWhere((a) => a['id'] == animal['id']);
                    if (index != -1) {
                      animals[index] = {
                        ...animals[index],
                        'name': nameController.text,
                        'breed': breedController.text,
                        'age': int.tryParse(ageController.text) ?? 0,
                        'weight': double.tryParse(weightController.text) ?? 0.0,
                        'description': descController.text,
                      };
                    }
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Изменения сохранены!'),
                        backgroundColor: Colors.green),
                  );
                }
                Navigator.pop(context);
              }
            },
            child: Text(animal == null ? 'Добавить' : 'Сохранить'),
          ),
        ],
      ),
    );
  }
}

// Управление заявками
class ApplicationsManagement extends StatefulWidget {
  const ApplicationsManagement({Key? key}) : super(key: key);

  @override
  _ApplicationsManagementState createState() => _ApplicationsManagementState();
}

class _ApplicationsManagementState extends State<ApplicationsManagement> {
  List<Map<String, dynamic>> applications = [
    {
      'id': 1,
      'userName': 'Иван Петров',
      'animalName': 'Барсик',
      'status': 'На рассмотрении',
      'date': '15.12.2023',
      'phone': '+7 999 123-45-67',
      'comment': 'Хочу подарить заботу и любовь этому питомцу'
    },
    {
      'id': 2,
      'userName': 'Мария Сидорова',
      'animalName': 'Шарик',
      'status': 'Одобрена',
      'date': '14.12.2023',
      'phone': '+7 999 765-43-21',
      'comment': 'Есть частный дом, большой двор'
    },
    {
      'id': 3,
      'userName': 'Алексей Иванов',
      'animalName': 'Мурка',
      'status': 'Отклонена',
      'date': '13.12.2023',
      'phone': '+7 999 555-44-33',
      'comment': 'Живу в квартире, есть балкон'
    },
  ];

  void _updateApplicationStatus(int id, String status) {
    setState(() {
      final index = applications.indexWhere((app) => app['id'] == id);
      if (index != -1) {
        applications[index]['status'] = status;
      }
    });
  }

  void _deleteApplication(int id) {
    setState(() {
      applications.removeWhere((app) => app['id'] == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Заявка удалена!'), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Заявки на усыновление',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: applications.length,
              itemBuilder: (context, index) {
                final app = applications[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.person, size: 40),
                    title: Text(
                      app['userName'],
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Животное: ${app['animalName']}'),
                        Text('Телефон: ${app['phone']}'),
                        Text('Дата: ${app['date']}'),
                        const SizedBox(height: 4),
                        Chip(
                          label: Text(
                            app['status'],
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: _getStatusColor(app['status']),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (app['status'] == 'На рассмотрении') ...[
                          IconButton(
                            icon: const Icon(Icons.check, color: Colors.green),
                            onPressed: () {
                              _updateApplicationStatus(app['id'], 'Одобрена');
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Заявка одобрена!'),
                                    backgroundColor: Colors.green),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () {
                              _updateApplicationStatus(app['id'], 'Отклонена');
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Заявка отклонена'),
                                    backgroundColor: Colors.red),
                              );
                            },
                          ),
                        ],
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteApplication(app['id']),
                        ),
                      ],
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Одобрена':
        return Colors.green;
      case 'Отклонена':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  void _showApplicationDetails(BuildContext context, Map<String, dynamic> app) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Заявка на усыновление'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Пользователь: ${app['userName']}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('Телефон: ${app['phone']}'),
              Text('Животное: ${app['animalName']}'),
              Text('Дата: ${app['date']}'),
              Text('Статус: ${app['status']}'),
              const SizedBox(height: 10),
              const Text('Комментарий:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(app['comment']),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }
}

// Управление событиями
class EventsManagement extends StatefulWidget {
  const EventsManagement({Key? key}) : super(key: key);

  @override
  _EventsManagementState createState() => _EventsManagementState();
}

class _EventsManagementState extends State<EventsManagement> {
  List<Map<String, dynamic>> events = [
    {
      'id': 1,
      'title': 'День открытых дверей',
      'date': '15 декабря, 12:00',
      'description': 'Приходите познакомиться с нашими питомцами'
    },
    {
      'id': 2,
      'title': 'Волонтёрская суббота',
      'date': 'Каждую субботу',
      'description': 'Помощь в уходе за животными'
    },
  ];

  void _deleteEvent(int id) {
    setState(() {
      events.removeWhere((event) => event['id'] == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Событие удалено!'), backgroundColor: Colors.green),
    );
  }

  void _editEvent(Map<String, dynamic> event) {
    _showAddEventDialog(context, event: event);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'События приюта',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddEventDialog(context),
                icon: const Icon(Icons.add),
                label: const Text('Добавить событие'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading:
                        const Icon(Icons.event, size: 40, color: Colors.purple),
                    title: Text(
                      event['title'],
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(event['date']),
                        Text(event['description']),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editEvent(event),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteEvent(event['id']),
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
    final dateController = TextEditingController(text: event?['date'] ?? '');
    final descController =
        TextEditingController(text: event?['description'] ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:
            Text(event == null ? 'Добавить событие' : 'Редактировать событие'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: titleController,
                decoration:
                    const InputDecoration(labelText: 'Название события*')),
            TextField(
                controller: dateController,
                decoration: const InputDecoration(labelText: 'Дата и время*')),
            TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Описание'),
                maxLines: 3),
          ],
        ),
        actions: [
          if (event != null)
            TextButton(
              onPressed: () {
                _deleteEvent(event['id']);
                Navigator.pop(context);
              },
              child: const Text('Удалить', style: TextStyle(color: Colors.red)),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty &&
                  dateController.text.isNotEmpty) {
                if (event == null) {
                  setState(() {
                    events.add({
                      'id': DateTime.now().millisecondsSinceEpoch,
                      'title': titleController.text,
                      'date': dateController.text,
                      'description': descController.text,
                    });
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Событие добавлено!'),
                        backgroundColor: Colors.green),
                  );
                } else {
                  setState(() {
                    final index =
                        events.indexWhere((e) => e['id'] == event['id']);
                    if (index != -1) {
                      events[index] = {
                        ...events[index],
                        'title': titleController.text,
                        'date': dateController.text,
                        'description': descController.text,
                      };
                    }
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Изменения сохранены!'),
                        backgroundColor: Colors.green),
                  );
                }
                Navigator.pop(context);
              }
            },
            child: Text(event == null ? 'Добавить' : 'Сохранить'),
          ),
        ],
      ),
    );
  }
}

// Управление пользователями
class UsersManagement extends StatefulWidget {
  const UsersManagement({Key? key}) : super(key: key);

  @override
  _UsersManagementState createState() => _UsersManagementState();
}

class _UsersManagementState extends State<UsersManagement> {
  List<Map<String, dynamic>> users = [
    {
      'id': 1,
      'name': 'Дмитрий Тумаев',
      'email': 'tym@mail.ru',
      'role': 'Пользователь',
      'status': 'Активен',
      'registrationDate': '10.12.2023'
    },
    {
      'id': 2,
      'name': 'Каролина Миллер',
      'email': 'miller@mail.ru',
      'role': 'Пользователь',
      'status': 'Активен',
      'registrationDate': '11.12.2023'
    },
    {
      'id': 3,
      'name': 'Администратор',
      'email': 'admin@happytails.ru',
      'role': 'Администратор',
      'status': 'Активен',
      'registrationDate': '01.12.2023'
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Пользователь удален!'), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Управление пользователями',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.person, size: 40),
                    title: Text(
                      user['name'],
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user['email']),
                        Text('Регистрация: ${user['registrationDate']}'),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Chip(
                              label: Text(
                                user['role'],
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                              backgroundColor: user['role'] == 'Администратор'
                                  ? Colors.red
                                  : Colors.blue,
                            ),
                            const SizedBox(width: 8),
                            Chip(
                              label: Text(
                                user['status'],
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                              backgroundColor: user['status'] == 'Активен'
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            user['status'] == 'Активен'
                                ? Icons.block
                                : Icons.check_circle,
                            color: user['status'] == 'Активен'
                                ? Colors.orange
                                : Colors.green,
                          ),
                          onPressed: () => _toggleUserStatus(user['id']),
                        ),
                        if (user['role'] != 'Администратор')
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
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

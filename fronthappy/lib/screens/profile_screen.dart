import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _user;
  List<dynamic> _donations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await ApiService.getCurrentUser();
      final donations = await ApiService.getMyDonations();

      setState(() {
        _user = user;
        _donations = donations;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка загрузки профиля: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Мой профиль'),
        backgroundColor: Colors.blue[700],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _user == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Ошибка загрузки профиля'),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadUserData,
                        child: Text('Попробовать снова'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadUserData,
                  child: ListView(
                    padding: EdgeInsets.all(16),
                    children: [
                      // Информация о пользователе
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    child: Icon(Icons.person, size: 40),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _user!['fullName'] ?? 'Пользователь',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          _user!['email'] ?? '',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Divider(),
                              SizedBox(height: 8),
                              ListTile(
                                leading: Icon(Icons.phone),
                                title: Text('Телефон'),
                                subtitle: Text(_user!['phone'] ?? 'Не указан'),
                              ),
                              ListTile(
                                leading: Icon(Icons.info),
                                title: Text('Статус'),
                                subtitle: Text(_user!['status'] == 'ACTIVE'
                                    ? 'Активен'
                                    : 'Заблокирован'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24),

                      // История пожертвований
                      Text(
                        'Мои пожертвования',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      if (_donations.isEmpty)
                        Card(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              'У вас нет пожертвований',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      else
                        ..._donations.map((donation) {
                          return Card(
                            margin: EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: Icon(Icons.favorite, color: Colors.red),
                              title: Text(
                                'Пожертвование ${donation['amount']} ₸',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 4),
                                  if (donation['animalName'] != null)
                                    Text('Животное: ${donation['animalName']}'),
                                  if (donation['eventTitle'] != null)
                                    Text('Событие: ${donation['eventTitle']}'),
                                  if (donation['message'] != null &&
                                      donation['message'].isNotEmpty)
                                    Text('Сообщение: ${donation['message']}'),
                                  SizedBox(height: 4),
                                  Text(
                                    donation['createdAt'] ?? '',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                    ],
                  ),
                ),
    );
  }
}

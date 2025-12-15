import 'package:flutter/material.dart';
import '../services/api_service.dart';

class StatsScreen extends StatefulWidget {
  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  bool _isLoading = true;
  Map<String, dynamic> _stats = {};

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      // Загружаем данные
      final animals = await ApiService.getAnimals();
      final events = await ApiService.getEvents();
      final donations = await ApiService.getMyDonations();

      setState(() {
        _stats = {
          'animals': animals.length,
          'events': events.length,
          'donations': donations.length,
          'totalDonated':
              donations.fold(0.0, (sum, d) => sum + (d['amount'] ?? 0.0)),
        };
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка загрузки статистики: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Статистика'),
        backgroundColor: Colors.blue[700],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadStats,
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  // Статистика животных
                  _buildStatCard(
                    title: 'Животные',
                    count: _stats['animals'] ?? 0,
                    icon: Icons.pets,
                    color: Colors.orange,
                  ),
                  SizedBox(height: 12),

                  // Статистика событий
                  _buildStatCard(
                    title: 'События',
                    count: _stats['events'] ?? 0,
                    icon: Icons.event,
                    color: Colors.blue,
                  ),
                  SizedBox(height: 12),

                  // Статистика пожертвований
                  _buildStatCard(
                    title: 'Пожертвования',
                    count: _stats['donations'] ?? 0,
                    icon: Icons.favorite,
                    color: Colors.red,
                  ),
                  SizedBox(height: 12),

                  // Общая сумма пожертвований
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Icon(
                            Icons.attach_money,
                            size: 48,
                            color: Colors.green,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Всего собрано',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '${(_stats['totalDonated'] ?? 0.0).toStringAsFixed(2)} ₽',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  // Информация
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Информация',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 12),
                          ListTile(
                            leading: Icon(Icons.info),
                            title: Text('Версия приложения'),
                            subtitle: Text('1.0.0'),
                          ),
                          ListTile(
                            leading: Icon(Icons.language),
                            title: Text('Язык'),
                            subtitle: Text('Русский'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required int count,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 32,
                color: color,
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    count.toString(),
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: color,
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
}

import 'package:flutter/material.dart';
import '../services/api_service.dart';

// Управление пожертвованиями
class DonationsManagement extends StatefulWidget {
  @override
  _DonationsManagementState createState() => _DonationsManagementState();
}

class _DonationsManagementState extends State<DonationsManagement> {
  List<Map<String, dynamic>> donations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDonations();
  }

  Future<void> _loadDonations() async {
    try {
      setState(() => _isLoading = true);
      final response = await ApiService.getMyDonations();
      setState(() {
        donations = List<Map<String, dynamic>>.from(response);
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Пожертвования',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : donations.isEmpty
                    ? Center(child: Text('Нет пожертвований'))
                    : ListView.builder(
                        itemCount: donations.length,
                        itemBuilder: (context, index) {
                          final donation = donations[index];
                          return Card(
                            margin: EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: Icon(Icons.favorite,
                                  color: Colors.pink, size: 40),
                              title: Text('${donation['amount']} ₸',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'От: ${donation['userName'] ?? 'Аноним'}'),
                                  if (donation['animalName'] != null)
                                    Text('Животное: ${donation['animalName']}'),
                                  if (donation['eventTitle'] != null)
                                    Text('Событие: ${donation['eventTitle']}'),
                                  if (donation['shelterName'] != null)
                                    Text('Приют: ${donation['shelterName']}'),
                                  if (donation['message'] != null &&
                                      donation['message'].toString().isNotEmpty)
                                    Text('💬 ${donation['message']}',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic)),
                                ],
                              ),
                              trailing: Text(
                                donation['createdAt'] != null
                                    ? DateTime.parse(donation['createdAt'])
                                        .toString()
                                        .substring(0, 10)
                                    : '',
                                style: TextStyle(color: Colors.grey),
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

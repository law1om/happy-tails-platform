import 'package:flutter/material.dart';

class VirtualMeetingScreen extends StatefulWidget {
  final dynamic animal;

  VirtualMeetingScreen({required this.animal});

  @override
  _VirtualMeetingScreenState createState() => _VirtualMeetingScreenState();
}

class _VirtualMeetingScreenState extends State<VirtualMeetingScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isLoading = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 10, minute: 0),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _scheduleMeeting() async {
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select both date and time')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Встреча успешно запланирована
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Встреча запланирована на ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year} в ${_selectedTime!.hour}:${_selectedTime!.minute.toString().padLeft(2, '0')}'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Virtual Meeting'),
        backgroundColor: Color(0xFF4CAF50),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Информация о животном
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                        widget.animal[16] is List &&
                                (widget.animal[16] as List).isNotEmpty
                            ? (widget.animal[16] as List)[0]
                            : 'https://images.unsplash.com/photo-1513360371669-4adf3dd7dff8?w=400',
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.animal[1] ?? 'Animal',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(widget.animal[2] ?? 'Species',
                              style: TextStyle(color: Colors.grey.shade600)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),

            // Выбор даты и времени
            Text('Select Meeting Time',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    ListTile(
                      leading:
                          Icon(Icons.calendar_today, color: Color(0xFF4CAF50)),
                      title: Text('Date'),
                      subtitle: Text(_selectedDate != null
                          ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                          : 'Select date'),
                      trailing: Icon(Icons.arrow_drop_down),
                      onTap: () => _selectDate(context),
                    ),
                    Divider(),
                    ListTile(
                      leading:
                          Icon(Icons.access_time, color: Color(0xFF4CAF50)),
                      title: Text('Time'),
                      subtitle: Text(_selectedTime != null
                          ? '${_selectedTime!.hour}:${_selectedTime!.minute.toString().padLeft(2, '0')}'
                          : 'Select time'),
                      trailing: Icon(Icons.arrow_drop_down),
                      onTap: () => _selectTime(context),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),

            // Информация о встрече
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Meeting Details',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('• 30-minute virtual meeting'),
                    Text('• Get to know the animal'),
                    Text('• Ask questions to our staff'),
                    Text('• No obligation to adopt'),
                  ],
                ),
              ),
            ),
            Spacer(),

            // Кнопка записи
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(color: Color(0xFF4CAF50)))
                : ElevatedButton(
                    onPressed: _scheduleMeeting,
                    child: Text('Schedule Virtual Meeting',
                        style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

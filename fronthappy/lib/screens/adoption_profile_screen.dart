import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/adoption_profile_model.dart';

class AdoptionProfileScreen extends StatefulWidget {
  @override
  _AdoptionProfileScreenState createState() => _AdoptionProfileScreenState();
}

class _AdoptionProfileScreenState extends State<AdoptionProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  bool _isSaving = false;
  AdoptionProfileModel? _profile;

  // Контроллеры
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _workScheduleController = TextEditingController();
  final _otherPetsDescController = TextEditingController();
  final _additionalInfoController = TextEditingController();
  final _childrenCountController = TextEditingController();

  String _housingType = 'APARTMENT';
  bool _hasYard = false;
  bool _hasOtherPets = false;
  bool _hasChildren = false;
  String _experience = 'NONE';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    try {
      final profile = await ApiService.getMyAdoptionProfile();
      if (profile != null) {
        final profileModel = AdoptionProfileModel.fromJson(profile);
        setState(() {
          _profile = profileModel;
          _phoneController.text = profileModel.phone;
          _addressController.text = profileModel.address;
          _workScheduleController.text = profileModel.workSchedule;
          _otherPetsDescController.text =
              profileModel.otherPetsDescription ?? '';
          _additionalInfoController.text = profileModel.additionalInfo ?? '';
          _childrenCountController.text =
              profileModel.childrenCount?.toString() ?? '';
          _housingType = profileModel.housingType;
          _hasYard = profileModel.hasYard;
          _hasOtherPets = profileModel.hasOtherPets;
          _hasChildren = profileModel.hasChildren;
          _experience = profileModel.experience;
        });
      }
    } catch (e) {
      // Анкета не найдена - это нормально для нового пользователя
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      final profileData = {
        'housingType': _housingType,
        'hasYard': _hasYard,
        'hasOtherPets': _hasOtherPets,
        'otherPetsDescription':
            _hasOtherPets ? _otherPetsDescController.text : null,
        'hasChildren': _hasChildren,
        'childrenCount':
            _hasChildren ? int.tryParse(_childrenCountController.text) : null,
        'experience': _experience,
        'workSchedule': _workScheduleController.text,
        'address': _addressController.text,
        'phone': _phoneController.text,
        'additionalInfo': _additionalInfoController.text.isNotEmpty
            ? _additionalInfoController.text
            : null,
      };

      if (_profile == null) {
        await ApiService.createAdoptionProfile(profileData);
      } else {
        await ApiService.updateAdoptionProfile(_profile!.id, profileData);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Анкета успешно сохранена!'),
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
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Анкета усыновителя'),
        backgroundColor: Color(0xFF4CAF50),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_profile != null)
                      Card(
                        color: _profile!.status == 'APPROVED'
                            ? Colors.green[50]
                            : _profile!.status == 'REJECTED'
                                ? Colors.red[50]
                                : Colors.orange[50],
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Icon(
                                _profile!.status == 'APPROVED'
                                    ? Icons.check_circle
                                    : _profile!.status == 'REJECTED'
                                        ? Icons.cancel
                                        : Icons.pending,
                                color: _profile!.status == 'APPROVED'
                                    ? Colors.green
                                    : _profile!.status == 'REJECTED'
                                        ? Colors.red
                                        : Colors.orange,
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Статус: ${_profile!.statusRu}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    SizedBox(height: 16),
                    Text(
                      'Контактная информация',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Телефон *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (v) => v!.isEmpty ? 'Обязательное поле' : null,
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: 'Адрес проживания *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.home),
                      ),
                      maxLines: 2,
                      validator: (v) => v!.isEmpty ? 'Обязательное поле' : null,
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Условия проживания',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _housingType,
                      decoration: InputDecoration(
                        labelText: 'Тип жилья *',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(
                            value: 'APARTMENT', child: Text('Квартира')),
                        DropdownMenuItem(value: 'HOUSE', child: Text('Дом')),
                        DropdownMenuItem(value: 'OTHER', child: Text('Другое')),
                      ],
                      onChanged: (value) {
                        setState(() => _housingType = value!);
                      },
                    ),
                    SizedBox(height: 12),
                    SwitchListTile(
                      title: Text('Есть двор/сад'),
                      value: _hasYard,
                      onChanged: (value) {
                        setState(() => _hasYard = value);
                      },
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Семья и питомцы',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    SwitchListTile(
                      title: Text('Есть другие питомцы'),
                      value: _hasOtherPets,
                      onChanged: (value) {
                        setState(() => _hasOtherPets = value);
                      },
                    ),
                    if (_hasOtherPets) ...[
                      SizedBox(height: 12),
                      TextFormField(
                        controller: _otherPetsDescController,
                        decoration: InputDecoration(
                          labelText: 'Опишите других питомцев',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 2,
                      ),
                    ],
                    SizedBox(height: 12),
                    SwitchListTile(
                      title: Text('Есть дети'),
                      value: _hasChildren,
                      onChanged: (value) {
                        setState(() => _hasChildren = value);
                      },
                    ),
                    if (_hasChildren) ...[
                      SizedBox(height: 12),
                      TextFormField(
                        controller: _childrenCountController,
                        decoration: InputDecoration(
                          labelText: 'Количество детей',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                    SizedBox(height: 24),
                    Text(
                      'Опыт и график',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _experience,
                      decoration: InputDecoration(
                        labelText: 'Опыт содержания животных *',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(
                            value: 'NONE', child: Text('Нет опыта')),
                        DropdownMenuItem(
                            value: 'SOME', child: Text('Есть опыт')),
                        DropdownMenuItem(
                            value: 'EXTENSIVE', child: Text('Большой опыт')),
                      ],
                      onChanged: (value) {
                        setState(() => _experience = value!);
                      },
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: _workScheduleController,
                      decoration: InputDecoration(
                        labelText: 'График работы *',
                        border: OutlineInputBorder(),
                        hintText: 'Например: 9:00-18:00, пн-пт',
                      ),
                      validator: (v) => v!.isEmpty ? 'Обязательное поле' : null,
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Дополнительная информация',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: _additionalInfoController,
                      decoration: InputDecoration(
                        labelText: 'Расскажите о себе',
                        border: OutlineInputBorder(),
                        hintText:
                            'Почему вы хотите завести питомца? Что можете предложить?',
                      ),
                      maxLines: 4,
                    ),
                    SizedBox(height: 24),
                    _isSaving
                        ? Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: _saveProfile,
                            child: Text(
                              _profile == null
                                  ? 'Создать анкету'
                                  : 'Сохранить изменения',
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
            ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _addressController.dispose();
    _workScheduleController.dispose();
    _otherPetsDescController.dispose();
    _additionalInfoController.dispose();
    _childrenCountController.dispose();
    super.dispose();
  }
}

import 'dart:io';
import 'package:camify_travel_app/screens/client.list.dart';
import 'package:camify_travel_app/db_functions.dart/client_functions.dart';
import 'package:camify_travel_app/db_functions.dart/place_functions.dart';
import 'package:camify_travel_app/model/client/booking_model.dart';
import 'package:camify_travel_app/model/drop_add/place_model.dart';
import 'package:camify_travel_app/widgets/custom_textfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ClientScreen extends StatefulWidget {
  final PackageClient? clientToEdit;
  const ClientScreen({super.key, this.clientToEdit});

  @override
  State<ClientScreen> createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String? _selectedPlace;
  String? _selectedPackageType;
  double _price = 0.0;
  File? _imageFile;
  File? _idProofFile;
  DateTime? _selectedDate;
  final _formKey = GlobalKey<FormState>();

  final List<String> _packageTypes = ['Normal', 'Premium', 'Luxury'];
  final Map<String, double> _packagePrices = {
    'Normal': 500.0,
    'Premium': 1000.0,
    'Luxury': 2000.0,
  };

  @override
  void initState() {
    super.initState();
    if (widget.clientToEdit != null) {
      _nameController.text = widget.clientToEdit!.name;
      _phoneController.text = widget.clientToEdit!.phone;
      _dateController.text = widget.clientToEdit!.date;
      _selectedPlace = widget.clientToEdit!.placeName;
      _selectedPackageType = widget.clientToEdit!.packageType;
      _price = widget.clientToEdit!.price ?? 0.0;
      if (widget.clientToEdit!.imagePath != null) {
        _imageFile = File(widget.clientToEdit!.imagePath!);
      }
      if (widget.clientToEdit!.idProofPath != null) {
        _idProofFile = File(widget.clientToEdit!.idProofPath!);
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickIdProof() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _idProofFile = File(result.files.single.path!);
      });
    }
  }

  String _generateClientId() {
    return 'C${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Client',
          style: TextStyle(
            color: Theme.of(context).appBarTheme.foregroundColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ClientlistScreen(),
                ),
              );
            },
            icon: Icon(
              Icons.person,
              color: Theme.of(context).appBarTheme.foregroundColor,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[300],
                        backgroundImage:
                            _imageFile != null ? FileImage(_imageFile!) : null,
                        child:
                            _imageFile == null
                                ? const Icon(
                                  Icons.camera_alt,
                                  size: 40,
                                  color: Colors.black,
                                )
                                : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomTextfield(
                    hint: 'Name',
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Please enter a name';
                      if (value.length < 2)
                        return 'Name must be at least 2 characters long';
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomTextfield(
                    hint: 'Phone Number',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Please enter a phone number';
                      if (!RegExp(r'^[0-9]{10}$').hasMatch(value))
                        return 'Phone number must be 10 digits';
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: CustomTextfield(
                        hint: 'Date',
                        controller: _dateController,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () => _selectDate(context),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Please select a date';
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ValueListenableBuilder(
                    valueListenable: placeNotifier,
                    builder: (context, List<Place> places, _) {
                      return DropdownButtonFormField<String>(
                        value: _selectedPlace,
                        hint: const Text('Select Place'),
                        items:
                            places.map((place) {
                              return DropdownMenuItem<String>(
                                value: place.placeName,
                                child: Text(place.placeName),
                              );
                            }).toList(),
                        onChanged:
                            (value) => setState(() => _selectedPlace = value),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        validator:
                            (value) =>
                                value == null ? 'Please select a place' : null,
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _selectedPackageType,
                    hint: const Text('Select Package Type'),
                    items:
                        _packageTypes.map((type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text('$type - ₹${_packagePrices[type]}'),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedPackageType = value;
                        _price = _packagePrices[value]!;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    validator:
                        (value) =>
                            value == null
                                ? 'Please select a package type'
                                : null,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Price: ₹${_price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _idProofFile != null
                              ? _idProofFile!.path.split('/').last
                              : 'No ID proof selected',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _pickIdProof,
                        child: const Text('Pick ID Proof'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (_imageFile == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please upload an image'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          if (_idProofFile == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please upload an ID proof'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          final client = PackageClient(
                            clientId:
                                widget.clientToEdit?.clientId ??
                                _generateClientId(),
                            name: _nameController.text,
                            phone: _phoneController.text,
                            date: _dateController.text,
                            placeName: _selectedPlace!,
                            packageType: _selectedPackageType!,
                            price: _price,
                            imagePath: _imageFile?.path,
                            idProofPath: _idProofFile?.path,
                          );

                          if (widget.clientToEdit == null) {
                            PackageFunctions.addClient(client);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Client added successfully'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            PackageFunctions.updateClient(
                              widget.clientToEdit!.phone,
                              client,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Client updated successfully'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ClientlistScreen(),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          182,
                          182,
                          128,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                      ),
                      child: Text(
                        widget.clientToEdit == null ? 'Save' : 'Update',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _dateController.dispose();
    super.dispose();
  }
}

import 'dart:io';
import 'package:camify_travel_app/Screens/Listworker.dart';
import 'package:camify_travel_app/Screens/worker_detail.dart';
import 'package:camify_travel_app/db_functions.dart/role_funtion.dart';
import 'package:camify_travel_app/db_functions.dart/worker_delete_function.dart';
import 'package:camify_travel_app/db_functions.dart/worker_availabilty_functions.dart'; // Added
import 'package:camify_travel_app/model/workers/create_work_model.dart';
import 'package:camify_travel_app/model/workers/name_model.dart';
import 'package:camify_travel_app/model/workers/role_model.dart';
import 'package:camify_travel_app/model/awailability/worker_model.dart'; // Added
import 'package:camify_travel_app/widgets/custom_textfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';

class WorkerScreen extends StatefulWidget {
  const WorkerScreen({super.key});

  @override
  State<WorkerScreen> createState() => _WorkerScreenState();
}

class _WorkerScreenState extends State<WorkerScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _workNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _workDescriptionController =
      TextEditingController();
  String? _selectedRole;
  File? _imageFile;
  File? _idProofFile;
  List<Worker> _workers = [];
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadWorkers();
    getAllRoles();
  }

  String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  void _loadWorkers() {
    setState(() {
      _workers = WorkerFunctions.getAllWorkers();
      print('Worker loaded ${_workers.length}');
    });
  }

  void _showAddWorkerSheet(BuildContext ctx) {
    _nameController.clear();
    _phoneNumberController.clear();
    _ageController.clear();
    _selectedRole = null;

    setState(() {
      _imageFile = null;
      _idProofFile = null;
    });
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: const Color(0xFFE5E6E1),
      context: ctx,
      elevation: 5,
      builder: (_) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            Future<void> pickImage() async {
              final XFile? pickedFile = await _picker.pickImage(
                source: ImageSource.gallery,
              );
              if (pickedFile != null) {
                setState(() {
                  _imageFile = File(pickedFile.path);
                });
                setModalState(() {});
              }
            }

            Future<void> pickIdProof() async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['jpg', 'png', 'pdf'],
              );
              if (result != null && result.files.single.path != null) {
                setState(() {
                  _idProofFile = File(result.files.single.path!);
                });
                setModalState(() {});
              }
            }

            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
                top: 15,
                left: 15,
                right: 15,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Center(
                        child: GestureDetector(
                          onTap: pickImage,
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage:
                                _imageFile != null
                                    ? FileImage(_imageFile!)
                                    : null,
                            child:
                                _imageFile == null
                                    ? const Icon(
                                      Icons.photo,
                                      size: 40,
                                      color: Colors.black,
                                    )
                                    : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
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
                      ValueListenableBuilder(
                        valueListenable: roleNotifier,
                        builder: (context, List<Role> roles, _) {
                          return DropdownButtonFormField<String>(
                            value: _selectedRole,
                            hint: const Text('Select Role'),
                            items:
                                roles.map((role) {
                                  return DropdownMenuItem<String>(
                                    value: role.roleName,
                                    child: Text(role.roleName),
                                  );
                                }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedRole = value;
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomTextfield(
                        hint: 'Phone Number',
                        controller: _phoneNumberController,
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
                      CustomTextfield(
                        hint: 'Age',
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Please enter an age';
                          final age = int.tryParse(value);
                          if (age == null || age < 18 || age > 100)
                            return 'Age must be between 18 and 100';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: pickIdProof,
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            image:
                                _idProofFile != null &&
                                        !_idProofFile!.path.endsWith('.pdf')
                                    ? DecorationImage(
                                      image: FileImage(_idProofFile!),
                                      fit: BoxFit.cover,
                                    )
                                    : null,
                          ),
                          child:
                              _idProofFile == null
                                  ? const Icon(Icons.upload_file)
                                  : _idProofFile!.path.endsWith('.pdf')
                                  ? const Icon(
                                    Icons.picture_as_pdf,
                                    color: Colors.red,
                                  )
                                  : null,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate() &&
                              _imageFile != null &&
                              _idProofFile != null) {
                            final workerId = generateId();
                            final newWorker = Worker(
                              name: _nameController.text,
                              role: _selectedRole,
                              phoneNumber: _phoneNumberController.text,
                              age: int.parse(_ageController.text),
                              imagePath: _imageFile!.path,
                              idProofPath: _idProofFile!.path,
                            );
                            await WorkerFunctions.addWorker(newWorker);
                            // Sync with WorkerAvailable
                            await addWorker(
                              WorkerAvailable(
                                workerId: workerId,
                                name: _nameController.text,
                              ),
                            );
                            print(
                              'Worker added ${newWorker.name} and synced to availability',
                            );
                            _nameController.clear();
                            _phoneNumberController.clear();
                            _ageController.clear();
                            _imageFile = null;
                            _idProofFile = null;
                            _selectedRole = null;
                            Navigator.of(ctx).pop();
                            _loadWorkers();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Worker added successfully'),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please fill all required fields correctly',
                                ),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          'Add',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showAddWorkDialog(BuildContext ctx) {
    print('Opening Add Work dialog');
    showDialog(
      context: ctx,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add Work'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextfield(
                hint: 'Work Name',
                controller: _workNameController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty)
                    return 'Work Name cannot be empty';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              CustomTextfield(
                hint: 'Description',
                controller: _workDescriptionController,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_workNameController.text.isNotEmpty &&
                    _workDescriptionController.text.isNotEmpty) {
                  final newWork = Manage(
                    id: generateId(),
                    name: _workNameController.text,
                    description: _workDescriptionController.text,
                    status: 'Pending',
                    assignedWorkerIndices: const [],
                  );
                  print('Adding work: ${newWork.name}');
                  await WorkerFunctions.addmanagework(newWork);
                  print('Work added to MANAGEBOX');
                  _workNameController.clear();
                  _workDescriptionController.clear();
                  Navigator.of(dialogContext).pop();
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    const SnackBar(content: Text('Work added successfully')),
                  );
                } else {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields')),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Workers',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 182, 182, 128),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WorkListScreen()),
              );
            },
            icon: const Icon(Icons.work),
          ),
          IconButton(
            onPressed: () => _showAddWorkDialog(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body:
          _workers.isEmpty
              ? const Center(child: Text('No workers yet!'))
              : ListView.builder(
                itemCount: _workers.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: FileImage(
                        File(_workers[index].imagePath),
                      ),
                    ),
                    title: Text(_workers[index].name),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => WorkerDetailScreen(
                                worker: _workers[index],
                                index: index,
                              ),
                        ),
                      ).then((_) => _loadWorkers());
                    },
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF8D9851),
        onPressed: () => _showAddWorkerSheet(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _ageController.dispose();
    _workNameController.dispose();
    _workDescriptionController.dispose();
    super.dispose();
  }
}

import 'dart:io';
import 'package:camify_travel_app/screens/Listworker.dart';
import 'package:camify_travel_app/screens/worker_detail.dart';
import 'package:camify_travel_app/db_functions.dart/role_funtion.dart';
import 'package:camify_travel_app/db_functions.dart/worker_delete_function.dart';
import 'package:camify_travel_app/db_functions.dart/worker_availabilty_functions.dart';
import 'package:camify_travel_app/model/workers/create_work_model.dart';
import 'package:camify_travel_app/model/workers/name_model.dart';
import 'package:camify_travel_app/model/workers/role_model.dart';
import 'package:camify_travel_app/model/awailability/worker_model.dart';
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
      backgroundColor: Colors.transparent,
      context: ctx,
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
                top: 20,
                left: 20,
                right: 20,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor, // Dynamic background
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(25),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Add New Worker',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: pickImage,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          backgroundImage:
                              _imageFile != null
                                  ? FileImage(_imageFile!)
                                  : null,
                          child:
                              _imageFile == null
                                  ? Icon(
                                    Icons.camera_alt,
                                    size: 40,
                                    color: Theme.of(
                                      context,
                                    ).iconTheme.color?.withOpacity(0.7),
                                  )
                                  : null,
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
                      const SizedBox(height: 15),
                      ValueListenableBuilder(
                        valueListenable: roleNotifier,
                        builder: (context, List<Role> roles, _) {
                          return DropdownButtonFormField<String>(
                            value: _selectedRole,
                            hint: Text(
                              'Select Role',
                              style: TextStyle(
                                color: Theme.of(context).hintColor,
                              ),
                            ),
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
                                borderRadius: BorderRadius.circular(15),
                              ),
                              filled: true,
                              fillColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 15,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 15),
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
                      const SizedBox(height: 15),
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
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).dividerColor,
                            ),
                            borderRadius: BorderRadius.circular(15),
                            image:
                                _idProofFile != null &&
                                        !_idProofFile!.path.endsWith('.pdf')
                                    ? DecorationImage(
                                      image: FileImage(_idProofFile!),
                                      fit: BoxFit.cover,
                                    )
                                    : null,
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(
                                  context,
                                ).shadowColor.withOpacity(0.1),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child:
                              _idProofFile == null
                                  ? Icon(
                                    Icons.upload_file,
                                    size: 40,
                                    color: Theme.of(
                                      context,
                                    ).iconTheme.color?.withOpacity(0.7),
                                  )
                                  : _idProofFile!.path.endsWith('.pdf')
                                  ? Icon(
                                    Icons.picture_as_pdf,
                                    size: 40,
                                    color: Theme.of(context).primaryColor,
                                  )
                                  : null,
                        ),
                      ),
                      const SizedBox(height: 25),
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
                            await addWorker(
                              WorkerAvailable(
                                workerId: workerId,
                                name: _nameController.text,
                              ),
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
                              SnackBar(
                                content: const Text(
                                  'Worker added successfully',
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'Please fill all required fields',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                        ),
                        child: Text(
                          'Add Worker',
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context)
                                .elevatedButtonTheme
                                .style!
                                .foregroundColor
                                ?.resolve({}),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
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
    showDialog(
      context: ctx,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Theme.of(context).cardColor, // Dynamic background
          title: Text(
            'Add Work',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyMedium!.color,
            ),
          ),
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
              const SizedBox(height: 15),
              CustomTextfield(
                hint: 'Description',
                controller: _workDescriptionController,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.color?.withOpacity(0.7),
                ),
              ),
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
                  await WorkerFunctions.addmanagework(newWork);
                  _workNameController.clear();
                  _workDescriptionController.clear();
                  Navigator.of(dialogContext).pop();
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(
                      content: const Text('Work added successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(
                      content: const Text('Please fill all fields'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Add', style: TextStyle(color: Colors.white)),
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
        title: Text(
          'Workers',
          style: TextStyle(
            color: Theme.of(context).appBarTheme.foregroundColor,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor:
            Theme.of(
              context,
            ).appBarTheme.backgroundColor, // Dynamic AppBar color
        actions: [
          Tooltip(
            message: 'View Work List',
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WorkListScreen(),
                  ),
                );
              },
              icon: Icon(
                Icons.work,
                color: Theme.of(context).appBarTheme.foregroundColor,
              ),
            ),
          ),
          Tooltip(
            message: 'Add New Work',
            child: IconButton(
              onPressed: () => _showAddWorkDialog(context),
              icon: Icon(
                Icons.add,
                color: Theme.of(context).appBarTheme.foregroundColor,
              ),
            ),
          ),
        ],
      ),
      body:
          _workers.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 80,
                      color: Theme.of(
                        context,
                      ).iconTheme.color?.withOpacity(0.5),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'No Workers Yet!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Add a worker to get started.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(
                          context,
                        ).textTheme.bodyMedium!.color?.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _workers.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: Theme.of(context).cardColor, // Dynamic card color
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        backgroundImage: FileImage(
                          File(_workers[index].imagePath),
                        ),
                      ),
                      title: Text(
                        _workers[index].name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                      ),
                      subtitle: Text(
                        _workers[index].role ?? 'No Role',
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).textTheme.bodyMedium!.color?.withOpacity(0.7),
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Theme.of(
                          context,
                        ).iconTheme.color?.withOpacity(0.5),
                      ),
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
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddWorkerSheet(context),
        backgroundColor: Theme.of(context).primaryColor, // Dynamic FAB color
        elevation: 8,
        child: Icon(
          Icons.add,
          size: 30,
          color: Theme.of(
            context,
          ).elevatedButtonTheme.style!.foregroundColor?.resolve({}),
        ),
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

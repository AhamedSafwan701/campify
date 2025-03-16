import 'dart:io';
import 'package:camify_travel_app/db_functions.dart/worker_delete_function.dart';
import 'package:camify_travel_app/model/workers/name_model.dart';
import 'package:camify_travel_app/widgets/custom_alertbox.dart';
import 'package:camify_travel_app/widgets/custom_textfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class WorkerDetailScreen extends StatefulWidget {
  final Worker worker;
  final int index;
  const WorkerDetailScreen({
    super.key,
    required this.worker,
    required this.index,
  });
  @override
  State<WorkerDetailScreen> createState() => _WorkerDetailScreenState();
}

class _WorkerDetailScreenState extends State<WorkerDetailScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _ageController;
  File? _imageFile;
  File? _idProofFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.worker.name);
    _phoneNumberController = TextEditingController(
      text: widget.worker.phoneNumber,
    );
    _ageController = TextEditingController(text: widget.worker.age?.toString());
    _imageFile = File(widget.worker.imagePath);
    _idProofFile =
        widget.worker.idProofPath != null
            ? File(widget.worker.idProofPath!)
            : null;
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickIdProof() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _idProofFile = File(result.files.single.path!);
      });
    }
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Edit Worker'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundImage:
                        _imageFile != null ? FileImage(_imageFile!) : null,
                    child:
                        _imageFile == null
                            ? const Icon(
                              Icons.photo,
                              size: 50,
                              color: Colors.black,
                            )
                            : null,
                  ),
                ),
                const SizedBox(height: 10),
                CustomTextfield(hint: 'Name', controller: _nameController),
                const SizedBox(height: 10),
                CustomTextfield(
                  hint: 'Phone Number',
                  controller: _phoneNumberController,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 10),
                CustomTextfield(
                  hint: 'Age',
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  //   isAgeField: true,
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: _pickIdProof,
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      image:
                          _idProofFile != null
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
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_nameController.text.isNotEmpty && _imageFile != null) {
                  final updateWorker = Worker(
                    name: _nameController.text,
                    role: widget.worker.role,
                    phoneNumber:
                        _phoneNumberController.text.isNotEmpty
                            ? _phoneNumberController.text
                            : null,
                    imagePath: _imageFile!.path,
                    age:
                        _ageController.text.isNotEmpty
                            ? int.parse(_ageController.text)
                            : null,
                    idProofPath: _imageFile!.path,
                  );
                  await WorkerFunctions.updateWorker(
                    widget.index,
                    updateWorker,
                  );
                  debugPrint('Worker updated: ${updateWorker.name}');
                  Navigator.of(ctx).pop();
                  setState(() {});
                }
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _deleteWorker(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return CustomAlertbox(
          title: 'Delete Worker',
          content: Text(
            'Are you sure you want to delete ${widget.worker.name}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('No'),
            ),
            ElevatedButton(
              onPressed: () async {
                await WorkerFunctions.deleteWorker(widget.index);
                debugPrint('Worker deleted: ${widget.worker.name}');
                Navigator.of(ctx).pop();
                Navigator.of(context).pop(true);
              },
              child: Text('Yes'),
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
          'Details',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 182, 182, 128),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () => _showEditDialog(context),
            icon: Icon(Icons.edit, color: Colors.blue),
          ),
          IconButton(
            onPressed: () => _deleteWorker(context),
            icon: Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage:
                    _imageFile != null ? FileImage(_imageFile!) : null,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Name: ${_nameController.text}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Role: ${widget.worker.role ?? "Not assigned"}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Phone: ${_phoneNumberController.text.isNotEmpty ? _phoneNumberController.text : "Not provided"}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Age: ${_ageController.text.isNotEmpty ? _ageController.text : "Not provided"}',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            const Text('ID Proof:', style: TextStyle(fontSize: 18)),
            _idProofFile != null
                ? _idProofFile!.path.endsWith('.pdf')
                    ? const Icon(
                      Icons.picture_as_pdf,
                      size: 100,
                      color: Colors.red,
                    )
                    : Image.file(
                      _idProofFile!,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    )
                : const Text('Not provided'),
          ],
        ),
      ),
    );
  }

  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _ageController.dispose();
    super.dispose();
  }
}

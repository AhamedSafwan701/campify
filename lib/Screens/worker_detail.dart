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
    _nameController = TextEditingController(text: widget.worker.nameWorker);
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
    if (pickedFile != null) setState(() => _imageFile = File(pickedFile.path));
  }

  Future<void> _pickIdProof() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() => _idProofFile = File(result.files.single.path!));
    }
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Theme.of(context).cardColor,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setDialogState) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Edit Worker',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () async {
                          await _pickImage();
                          setDialogState(() {});
                        },
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
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).scaffoldBackgroundColor,
                        ),
                      ),
                      const SizedBox(height: 15),
                      CustomTextfield(
                        hint: 'Phone Number',
                        controller: _phoneNumberController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).scaffoldBackgroundColor,
                        ),
                      ),
                      const SizedBox(height: 15),
                      CustomTextfield(
                        hint: 'Age',
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).scaffoldBackgroundColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () async {
                          await _pickIdProof();
                          setDialogState(() {});
                        },
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyMedium!.color?.withOpacity(0.7),
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () async {
                              if (_nameController.text.isNotEmpty &&
                                  _imageFile != null) {
                                final updateWorker = Worker(
                                  nameWorker: _nameController.text,
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
                                  idProofPath: _idProofFile?.path,
                                );
                                await WorkerFunctions.updateWorker(
                                  widget.index,
                                  updateWorker,
                                );
                                debugPrint(
                                  'Worker updated: ${updateWorker.nameWorker}',
                                );
                                Navigator.of(ctx).pop();
                                setState(() {});
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      'Worker updated successfully',
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      'Please fill required fields',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 15,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 5,
                            ),
                            child: Text(
                              'Update',
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
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
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
            'Are you sure you want to delete ${widget.worker.nameWorker}?',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium!.color,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                'No',
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.color?.withOpacity(0.7),
                  fontSize: 16,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await WorkerFunctions.deleteWorker(widget.index);
                debugPrint('Worker deleted: ${widget.worker.nameWorker}');
                Navigator.of(ctx).pop();
                Navigator.of(context).pop(true);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Worker deleted successfully'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Yes', style: TextStyle(color: Colors.white)),
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
          'Worker Details',
          style: TextStyle(
            color: Theme.of(context).appBarTheme.foregroundColor,
            fontWeight: FontWeight.bold,
            fontSize: 22,
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
          Tooltip(
            message: 'Edit Worker',
            child: IconButton(
              onPressed: () => _showEditDialog(context),
              icon: Icon(Icons.edit, color: Colors.blue),
            ),
          ),
          Tooltip(
            message: 'Delete Worker',
            child: IconButton(
              onPressed: () => _deleteWorker(context),
              icon: Icon(Icons.delete, color: Colors.red),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Theme.of(context).cardColor,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      backgroundImage:
                          _imageFile != null ? FileImage(_imageFile!) : null,
                      child:
                          _imageFile == null
                              ? Icon(
                                Icons.person,
                                size: 70,
                                color: Theme.of(
                                  context,
                                ).iconTheme.color?.withOpacity(0.7),
                              )
                              : null,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _nameController.text,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Role: ${widget.worker.role ?? "Not Assigned"}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(
                          context,
                        ).textTheme.bodyMedium!.color?.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.phone,
                          color: Theme.of(context).primaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          _phoneNumberController.text.isNotEmpty
                              ? _phoneNumberController.text
                              : "Not Provided",
                          style: TextStyle(
                            fontSize: 18,
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cake,
                          color: Theme.of(context).primaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          _ageController.text.isNotEmpty
                              ? _ageController.text
                              : "Not Provided",
                          style: TextStyle(
                            fontSize: 18,
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Theme.of(context).cardColor,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ID Proof',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child:
                          _idProofFile != null
                              ? _idProofFile!.path.endsWith('.pdf')
                                  ? Container(
                                    height: 120,
                                    width: 120,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Theme.of(
                                            context,
                                          ).shadowColor.withOpacity(0.1),
                                          blurRadius: 5,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.picture_as_pdf,
                                      size: 80,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  )
                                  : Container(
                                    height: 150,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Theme.of(
                                            context,
                                          ).shadowColor.withOpacity(0.1),
                                          blurRadius: 5,
                                        ),
                                      ],
                                      image: DecorationImage(
                                        image: FileImage(_idProofFile!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                              : Text(
                                'Not Provided',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .color
                                      ?.withOpacity(0.7), // Dynamic text color
                                ),
                              ),
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

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _ageController.dispose();
    super.dispose();
  }
}

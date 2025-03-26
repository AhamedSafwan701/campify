// import 'dart:io';
// import 'package:camify_travel_app/Screens/client.list.dart';
// import 'package:camify_travel_app/db_functions.dart/client_functions.dart';
// import 'package:camify_travel_app/db_functions.dart/package_function.dart';
// import 'package:camify_travel_app/db_functions.dart/place_functions.dart';
// import 'package:camify_travel_app/model/client/booking_model.dart';
// import 'package:camify_travel_app/model/drop_add/package_model.dart';
// import 'package:camify_travel_app/model/drop_add/place_model.dart';
// import 'package:camify_travel_app/widgets/custom_textfield.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';

// class ClientScreen extends StatefulWidget {
//   final PackageClient? clientToEdit;
//   const ClientScreen({super.key, this.clientToEdit});

//   @override
//   State<ClientScreen> createState() => _ClientScreenState();
// }

// class _ClientScreenState extends State<ClientScreen> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _dateController = TextEditingController();
//   String? _selectedPackage;
//   DateTime? _selectedDate;
//   String? _selectedPlace;
//   File? _imageFile;
//   File? _idProofFile;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.clientToEdit != null) {
//       _nameController.text = widget.clientToEdit!.name;
//       _phoneController.text = widget.clientToEdit!.phone;
//       _dateController.text = widget.clientToEdit!.date;
//       _selectedPackage = widget.clientToEdit!.packageName;
//       _selectedPlace = widget.clientToEdit!.placeName;
//       if (widget.clientToEdit!.imagePath != null) {
//         _imageFile = File(widget.clientToEdit!.imagePath!);
//       }
//       if (widget.clientToEdit!.idProofPath != null) {
//         _idProofFile = File(widget.clientToEdit!.idProofPath);
//       }
//     }
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2030),
//     );
//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//         _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
//       });
//     }
//   }

//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//       });
//     }
//   }

//   Future<void> _pickIdProof() async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['jpg', 'png', 'pdf'],
//     );
//     if (result != null && result.files.single.path != null) {
//       setState(() {
//         _idProofFile = File(result.files.single.path!);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Add Client',
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         backgroundColor: const Color.fromARGB(255, 182, 182, 128),
//         leading: IconButton(
//           onPressed: () {
//             print('Back pressed');
//             Navigator.pop(context);
//           },
//           icon: const Icon(Icons.arrow_back),
//         ),
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => ClientlistScreen()),
//               );
//             },
//             icon: Icon(Icons.person),
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Center(
//                   child: Column(
//                     children: [
//                       GestureDetector(
//                         onTap: _pickImage,
//                         child: CircleAvatar(
//                           radius: 50,
//                           backgroundColor: Colors.grey[300],
//                           backgroundImage:
//                               _imageFile != null
//                                   ? FileImage(_imageFile!)
//                                   : null,
//                           child:
//                               _imageFile == null
//                                   ? const Icon(
//                                     Icons.camera_alt,
//                                     size: 40,
//                                     color: Colors.black,
//                                   )
//                                   : null,
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                     ],
//                   ),
//                 ),
//                 CustomTextfield(
//                   hint: 'Name',
//                   controller: _nameController,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter a name';
//                     }
//                     if (value.length < 2) {
//                       return 'Name must be at least 2 characters long';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 10),
//                 CustomTextfield(
//                   hint: 'Phone',
//                   controller: _phoneController,
//                   keyboardType: TextInputType.phone,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter a phone number';
//                     }
//                     if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
//                       return 'Phone number must be 10 digits';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 10),
//                 GestureDetector(
//                   onTap: () => _selectDate(context),
//                   child: AbsorbPointer(
//                     child: TextField(
//                       controller: _dateController,
//                       keyboardType: TextInputType.datetime,
//                       decoration: InputDecoration(
//                         hintText: 'Date',
//                         hintStyle: const TextStyle(color: Colors.black),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(25),
//                           borderSide: const BorderSide(color: Colors.black),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(25),
//                           borderSide: const BorderSide(color: Colors.black),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(25),
//                           borderSide: const BorderSide(
//                             color: Colors.blue,
//                             width: 2,
//                           ),
//                         ),
//                         contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 20,
//                           vertical: 15,
//                         ),
//                         suffixIcon: IconButton(
//                           icon: const Icon(
//                             Icons.calendar_today,
//                             color: Colors.black,
//                           ),
//                           onPressed: () => _selectDate(context),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 ValueListenableBuilder(
//                   valueListenable: placeNotifier,
//                   builder: (context, List<Place> Places, _) {
//                     return DropdownButtonFormField<String>(
//                       value: _selectedPlace,
//                       hint: const Text('Select Place'),
//                       items:
//                           Places.map((place) {
//                             return DropdownMenuItem<String>(
//                               value: place.placeName,
//                               child: Text(place.placeName),
//                             );
//                           }).toList(),
//                       onChanged: (value) {
//                         setState(() {
//                           _selectedPlace = value;
//                         });
//                       },
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(25),
//                         ),
//                         contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 20,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 ValueListenableBuilder(
//                   valueListenable: packageNotifier,
//                   builder: (context, List<Package> packages, _) {
//                     return DropdownButtonFormField<String>(
//                       value: _selectedPackage,
//                       hint: const Text('Select Package'),
//                       items:
//                           packages.map((package) {
//                             return DropdownMenuItem<String>(
//                               value: package.packageName,
//                               child: Text(package.packageName),
//                             );
//                           }).toList(),
//                       onChanged: (value) {
//                         setState(() {
//                           _selectedPackage = value;
//                         });
//                       },
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(25),
//                         ),
//                         contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 20,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: Text(
//                         _idProofFile != null
//                             ? _idProofFile!.path.split('/').last
//                             : 'No ID proof selected',
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                     ElevatedButton(
//                       onPressed: _pickIdProof,
//                       child: const Text('Pick ID Proof'),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 Center(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       if (_nameController.text.isEmpty ||
//                           _phoneController.text.isEmpty ||
//                           _dateController.text.isEmpty ||
//                           _selectedPackage == null ||
//                           _selectedPlace == null) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text('Please fill all fields'),
//                           ),
//                         );
//                         return;
//                       }
//                       final client = PackageClient(
//                         name: _nameController.text,
//                         phone: _phoneController.text,
//                         date: _dateController.text,
//                         packageName: _selectedPackage!,
//                         placeName: _selectedPlace!,
//                         imagePath: _imageFile!.path,
//                         idProofPath: _idProofFile!.path,
//                       );
//                       if (widget.clientToEdit == null) {
//                         PackageFunctions.addClient(client);
//                       } else {
//                         PackageFunctions.updateClient(
//                           widget.clientToEdit!.phone,
//                           client,
//                         );
//                       }

//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text('Client details saved')),
//                       );
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ClientlistScreen(),
//                         ),
//                       );
//                     },
//                     child: Text(
//                       widget.clientToEdit == null ? 'Save' : 'Update',
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:camify_travel_app/Screens/client.list.dart';
import 'package:camify_travel_app/db_functions.dart/client_functions.dart';
import 'package:camify_travel_app/db_functions.dart/package_function.dart';
import 'package:camify_travel_app/db_functions.dart/place_functions.dart';
import 'package:camify_travel_app/model/client/booking_model.dart';
import 'package:camify_travel_app/model/drop_add/package_model.dart';
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
  String? _selectedPackage;
  DateTime? _selectedDate;
  String? _selectedPlace;
  File? _imageFile;
  File? _idProofFile;

  @override
  void initState() {
    super.initState();
    if (widget.clientToEdit != null) {
      _nameController.text = widget.clientToEdit!.name;
      _phoneController.text = widget.clientToEdit!.phone;
      _dateController.text = widget.clientToEdit!.date;
      _selectedPackage = widget.clientToEdit!.packageName;
      _selectedPlace = widget.clientToEdit!.placeName;
      if (widget.clientToEdit!.imagePath != null) {
        _imageFile = File(widget.clientToEdit!.imagePath!);
      }
      // if (widget.clientToEdit!.idProofPath != null) {
      //   _idProofFile = File(widget.clientToEdit!.idProofPath);
      // }
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
        title: const Text(
          'Add Client',
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
                MaterialPageRoute(builder: (context) => ClientlistScreen()),
              );
            },
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                CustomTextfield(hint: 'Name', controller: _nameController),
                const SizedBox(height: 10),
                CustomTextfield(
                  hint: 'Phone',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: TextField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        hintText: 'Date',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () => _selectDate(context),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
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
                    );
                  },
                ),
                const SizedBox(height: 16),
                ValueListenableBuilder(
                  valueListenable: packageNotifier,
                  builder: (context, List<Package> packages, _) {
                    return DropdownButtonFormField<String>(
                      value: _selectedPackage,
                      hint: const Text('Select Package'),
                      items:
                          packages.map((package) {
                            return DropdownMenuItem<String>(
                              value: package.packageName,
                              child: Text(package.packageName),
                            );
                          }).toList(),
                      onChanged:
                          (value) => setState(() => _selectedPackage = value),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    );
                  },
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
                      if (_nameController.text.isEmpty ||
                          _phoneController.text.isEmpty ||
                          _dateController.text.isEmpty ||
                          _selectedPackage == null ||
                          _selectedPlace == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill all fields'),
                          ),
                        );
                        return;
                      }
                      final client = PackageClient(
                        clientId:
                            widget.clientToEdit?.clientId ??
                            _generateClientId(), // Generate or use existing
                        name: _nameController.text,
                        phone: _phoneController.text,
                        date: _dateController.text,
                        packageName: _selectedPackage!,
                        placeName: _selectedPlace!,
                        imagePath: _imageFile?.path,
                        idProofPath: _idProofFile?.path,
                      );
                      if (widget.clientToEdit == null) {
                        PackageFunctions.addClient(client);
                      } else {
                        PackageFunctions.updateClient(
                          widget.clientToEdit!.phone,
                          client,
                        );
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Client details saved')),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ClientlistScreen(),
                        ),
                      );
                    },
                    child: Text(
                      widget.clientToEdit == null ? 'Save' : 'Update',
                    ),
                  ),
                ),
              ],
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

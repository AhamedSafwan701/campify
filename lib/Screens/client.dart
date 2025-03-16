import 'package:camify_travel_app/db_functions.dart/package_function.dart';
import 'package:camify_travel_app/model/drop_add/package_model.dart';
import 'package:camify_travel_app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class ClientScreen extends StatefulWidget {
  const ClientScreen({super.key});

  @override
  State<ClientScreen> createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String? _selectedPackage;
  List<String> _activities = [];
  DateTime? _selectedDate;

  // final List<TaskItem> _tasks = [
  //   TaskItem(title: 'Pick Client'),
  //   TaskItem(title: 'Take Tour'),
  //   TaskItem(title: 'Organize Food Facility'),
  //   TaskItem(title: 'Package Setup'),
  //   TaskItem(title: 'Extra Activities'),
  // ];
  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: _selectedDate ?? DateTime.now(),
  //     firstDate: DateTime(2020),
  //     lastDate: DateTime(2030),
  //     builder: (context, child) {
  //       return Theme(
  //         data: Theme.of(context).copyWith(
  //           colorScheme: const ColorScheme.light(
  //             primary: Color(0xFFBEBD7F), // header background color
  //             onPrimary: Colors.black, // header text color
  //             onSurface: Colors.black, // body text color
  //           ),
  //           textButtonTheme: TextButtonThemeData(
  //             style: TextButton.styleFrom(
  //               foregroundColor: Colors.black, // button text color
  //             ),
  //           ),
  //         ),
  //         child: child!,
  //       );
  //     },
  //   );

  //   if (picked != null && picked != _selectedDate) {
  //     setState(() {
  //       _selectedDate = picked;
  //       _dateController.text = DateFormat('MMMM d, yyyy').format(picked);
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Client Details',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 182, 182, 128),
        leading: IconButton(
          onPressed: () {
            print('Back pressed');
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextfield(hint: 'Name', controller: _namecontroller),
                SizedBox(height: 10),
                CustomTextfield(
                  hint: 'Phone',
                  controller: _phoneController,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                CustomTextfield(hint: 'Place', controller: _placeController),
                SizedBox(height: 10),
                CustomTextfield(hint: 'Date', controller: _dateController),
                SizedBox(height: 16),
                ValueListenableBuilder(
                  valueListenable: packageNotifier,
                  builder: (context, List<Package> packages, _) {
                    return DropdownButtonFormField<String>(
                      value: _selectedPackage,
                      hint: const Text('Select Role'),
                      items:
                          packages.map((package) {
                            return DropdownMenuItem<String>(
                              value: package.packageName,
                              child: Text(package.packageName),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedPackage = value;
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
                SizedBox(height: 15),
                DropdownButtonFormField(
                  value: _selectedDate,
                  hint: Text('Extra Activity'),
                  items: null,
                  onChanged: null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

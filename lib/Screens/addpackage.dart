import 'package:camify_travel_app/db_functions.dart/package_function.dart';
import 'package:camify_travel_app/db_functions.dart/role_funtion.dart';
import 'package:camify_travel_app/model/drop_add/package_model.dart';
import 'package:camify_travel_app/model/workers/role_model.dart';
import 'package:camify_travel_app/widgets/custom_alertbox.dart';
import 'package:flutter/material.dart';

class AddPackageScreen extends StatefulWidget {
  const AddPackageScreen({super.key});

  @override
  State<AddPackageScreen> createState() => _AddPackageScreenState();
}

class _AddPackageScreenState extends State<AddPackageScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _packageNameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getAllRoles();
  }

  void _showAddPackageSheet(BuildContext ctx) {
    _idController.clear();
    _packageNameController.clear();
    showModalBottomSheet(
      backgroundColor: Color(0xFFE5E6E1),
      isScrollControlled: true,
      context: ctx,
      builder: (_) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            top: 15,
            left: 15,
            right: 15,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: _idController,
                decoration: InputDecoration(hintText: "Package ID"),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _packageNameController,
                decoration: InputDecoration(hintText: 'Package Name'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_idController.text.isNotEmpty &&
                      _packageNameController.text.isNotEmpty) {
                    final newPackage = Package(
                      id: _idController.text,
                      packageName: _packageNameController.text,
                    );
                    await addPackage(newPackage);
                    Navigator.of(ctx).pop();
                  }
                },
                child: Text(
                  'Add Package',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(height: 15),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Package',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 182, 182, 128),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: packageNotifier,
        builder: (context, List<Package> packages, _) {
          return packages.isEmpty
              ? Center(child: Text('No packages'))
              : ListView.builder(
                itemCount: packages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(packages[index].packageName),
                    subtitle: Text('ID: ${packages[index].id}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) {
                            return CustomAlertbox(
                              title: 'Delete package',
                              content: Text(
                                'Are you sure you want to delete ${packages[index].packageName}?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                  child: Text(
                                    'No',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    debugPrint(
                                      'package deleted: ${packages[index].packageName}',
                                    );
                                    Navigator.of(ctx).pop();
                                    try {
                                      await deletePackage(packages[index].id);
                                    } catch (e) {
                                      e;
                                    }
                                  },
                                  child: Text(
                                    'Yes',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },

                      //   onPressed: () {
                      //     //  await deleteRole(roles[index].id);
                      //     showDialog(
                      //       context: context,
                      //       builder: (ctx) {
                      //         return CustomAlertbox(
                      //           icon: Icon(Icons.delete, color: Colors.red),
                      //           onPressed: () {
                      //             showDialog(context: context, builder: (ctx) {
                      //               return
                      //             });
                      //           },
                      //         );
                      //       },
                      //     );
                      //   },
                      // ),
                    ),
                  );
                },
              );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF8D9851),
        onPressed: () {
          _showAddPackageSheet(context);
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  @override
  void dispose() {
    _idController.dispose();
    _packageNameController.dispose();
    super.dispose();
  }
}

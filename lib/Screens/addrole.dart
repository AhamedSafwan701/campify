import 'package:camify_travel_app/db_functions.dart/role_funtion.dart';
import 'package:camify_travel_app/model/workers/role_model.dart';
import 'package:camify_travel_app/widgets/custom_alertbox.dart';
import 'package:flutter/material.dart';

class AddRollScreen extends StatefulWidget {
  const AddRollScreen({super.key});

  @override
  State<AddRollScreen> createState() => _AddRollScreenState();
}

class _AddRollScreenState extends State<AddRollScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _roleNameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getAllRoles();
  }

  void _showAddRoleSheet(BuildContext ctx) {
    _idController.clear();
    _roleNameController.clear();
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
                decoration: InputDecoration(hintText: "Role ID"),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _roleNameController,
                decoration: InputDecoration(hintText: 'Role Name'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_idController.text.isNotEmpty &&
                      _roleNameController.text.isNotEmpty) {
                    final newRole = Role(
                      id: _idController.text,
                      roleName: _roleNameController.text,
                    );
                    await addRole(newRole);
                    Navigator.of(ctx).pop();
                  }
                },
                child: Text('Add Role', style: TextStyle(color: Colors.black)),
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
          'Add Role',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[100],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: roleNotifier,
        builder: (context, List<Role> roles, _) {
          return roles.isEmpty
              ? Center(child: Text('No roles'))
              : ListView.builder(
                itemCount: roles.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(roles[index].roleName),
                    subtitle: Text('ID: ${roles[index].id}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) {
                            return CustomAlertbox(
                              title: 'Delete Role',
                              content: Text(
                                'Are you sure you want to delete ${roles[index].roleName}?',
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
                                      'Role deleted: ${roles[index].roleName}',
                                    );
                                    Navigator.of(ctx).pop();
                                    try {
                                      await deleteRole(roles[index].id);
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
          _showAddRoleSheet(context);
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  @override
  void dispose() {
    _idController.dispose();
    _roleNameController.dispose();
    super.dispose();
  }
}

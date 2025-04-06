import 'dart:io';
import 'package:camify_travel_app/db_functions.dart/assignment_functions.dart';
import 'package:camify_travel_app/model/awailability/tent_model.dart';
import 'package:camify_travel_app/model/awailability/worker_model.dart';
import 'package:camify_travel_app/model/client/assignment_model.dart';
import 'package:camify_travel_app/model/client/booking_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class BookingHistoryScreen extends StatelessWidget {
  const BookingHistoryScreen({super.key});

  Future<bool> _requestStoragePermission(BuildContext context) async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        return true;
      } else {
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          status = await Permission.storage.request();
          if (!status.isGranted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  'Storage permission denied. Please allow it in settings.',
                ),
                action: SnackBarAction(
                  label: 'Settings',
                  onPressed: () => openAppSettings(),
                ),
              ),
            );
            return false;
          }
        }
        return true;
      }
    }
    return true; // iOS or other platforms
  }

  Future<void> _downloadBookingHistory(BuildContext context) async {
    final hasPermission = await _requestStoragePermission(context);
    if (!hasPermission) {
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (ctx) => AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  'Generating and Saving PDF...',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                  ),
                ),
              ],
            ),
          ),
    );

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      helpText: 'Select Month for Booking History',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              onSurface: Theme.of(context).textTheme.bodyMedium!.color!,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final selectedMonth = DateFormat('MM_yyyy').format(picked);
      final assignmentsBox = Hive.box<Assignment>(ASSIGNMENT_BOX);
      final monthlyAssignments =
          assignmentsBox.values
              .where(
                (assignment) =>
                    assignment.isCancelled &&
                    DateFormat('MM/yyyy').format(
                          DateFormat('dd/MM/yyyy').parse(assignment.date),
                        ) ==
                        DateFormat('MM/yyyy').format(picked),
              )
              .toList();

      if (monthlyAssignments.isEmpty) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No cancelled bookings found for this month'),
          ),
        );
        return;
      }

      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build:
              (pw.Context context) => pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Cancelled Booking History',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    'Month: ${DateFormat('MM/yyyy').format(picked)}',
                    style: const pw.TextStyle(fontSize: 18),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Table.fromTextArray(
                    headers: ['Date', 'Client ID', 'Tent ID', 'Worker ID'],
                    data:
                        monthlyAssignments
                            .map(
                              (assignment) => [
                                assignment.date,
                                assignment.clientId,
                                assignment.tentId,
                                assignment.workerId,
                              ],
                            )
                            .toList(),
                  ),
                ],
              ),
        ),
      );

      try {
        final directory = await getExternalStorageDirectory();
        if (directory != null) {
          await directory.create(recursive: true);
          final file = File(
            '${directory.path}/Cancelled_Booking_History_$selectedMonth.pdf',
          );
          await file.writeAsBytes(await pdf.save());

          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Booking history saved to ${file.path}')),
          );

          final result = await OpenFile.open(file.path);
          if (result.type != ResultType.done) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error opening file: ${result.message}')),
            );
          }
        } else {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to access storage directory')),
          );
        }
      } catch (e) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving file: $e')));
      }
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Booking History',
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
          Tooltip(
            message: 'Download History',
            child: IconButton(
              onPressed: () => _downloadBookingHistory(context),
              icon: Icon(Icons.download, color: Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Assignment>(ASSIGNMENT_BOX).listenable(),
        builder: (context, Box<Assignment> box, _) {
          final assignments = box.values.where((a) => a.isCancelled).toList();
          if (assignments.isEmpty) {
            return Center(
              child: Text(
                'No cancelled bookings found',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                  fontSize: 16,
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: assignments.length,
            itemBuilder: (context, index) {
              final assignment = assignments[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 4,
                color: Theme.of(context).cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ValueListenableBuilder(
                        valueListenable:
                            Hive.box<PackageClient>('CLIENT_BOX').listenable(),
                        builder: (context, Box<PackageClient> clientBox, _) {
                          final client = clientBox.values.firstWhere(
                            (c) => c.clientId == assignment.clientId,
                            orElse:
                                () => PackageClient(
                                  clientId: '',
                                  name: 'Unknown',
                                  phone: '',
                                  date: '',
                                  placeName: '',
                                  imagePath: null,
                                  idProofPath: null,
                                  packageType: 'Not Set',
                                  price: 0.0,
                                ),
                          );
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Client: ${client.name} (ID: ${client.clientId})',
                                style: TextStyle(
                                  color:
                                      Theme.of(
                                        context,
                                      ).textTheme.bodyMedium!.color,
                                ),
                              ),
                              Text(
                                'Package: ${client.packageType ?? "Not Set"}',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .color
                                      ?.withOpacity(0.7),
                                ),
                              ),
                              Text(
                                'Price: ₹${client.price?.toStringAsFixed(2) ?? "0.00"}',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      ValueListenableBuilder(
                        valueListenable:
                            Hive.box<Tent>('TENT_BOX').listenable(),
                        builder: (context, Box<Tent> tentBox, _) {
                          final tent = tentBox.get(assignment.tentId);
                          return Text(
                            'Tent: ${tent?.name ?? "Unknown"} (ID: ${assignment.tentId})',
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyMedium!.color,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      ValueListenableBuilder(
                        valueListenable:
                            Hive.box<WorkerAvailable>(
                              'WORKERAVAILABLE_BOX',
                            ).listenable(),
                        builder: (context, Box<WorkerAvailable> workerBox, _) {
                          final worker = workerBox.get(assignment.workerId);
                          return Text(
                            'Worker: ${worker?.name ?? "Unknown"} (ID: ${assignment.workerId})',
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyMedium!.color,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Date: ${assignment.date}',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Status: Cancelled',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            onPressed:
                                () => _showDeleteConfirmation(
                                  context,
                                  box,
                                  index,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    Box<Assignment> box,
    int index,
  ) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(
            'Delete Booking',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium!.color,
            ),
          ),
          content: Text(
            'Are you sure you want to permanently delete this cancelled booking?',
            style: TextStyle(
              color: Theme.of(
                context,
              ).textTheme.bodyMedium!.color?.withOpacity(0.7),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Theme.of(context).cardColor,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
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
                await box.deleteAt(index);
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Booking deleted successfully'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Delete',
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).elevatedButtonTheme.style!.foregroundColor?.resolve({}),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

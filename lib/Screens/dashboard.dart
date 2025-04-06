import 'package:camify_travel_app/model/client/assignment_model.dart';
import 'package:camify_travel_app/model/client/booking_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Booking Dashboard',
          style: TextStyle(
            color: Theme.of(context).appBarTheme.foregroundColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Assignment>('ASSIGNMENT_BOX').listenable(),
        builder: (context, Box<Assignment> assignmentBox, _) {
          return ValueListenableBuilder(
            valueListenable: Hive.box<PackageClient>('CLIENT_BOX').listenable(),
            builder: (context, Box<PackageClient> clientBox, _) {
              final assignments =
                  assignmentBox.values.where((a) => !a.isCancelled).toList();
              final currentDate = DateTime.now();

              final oneDayBookings =
                  assignments.where((a) {
                    final bookingDate = DateFormat('dd/MM/yyyy').parse(a.date);
                    return bookingDate.isAfter(
                          currentDate.subtract(const Duration(days: 1)),
                        ) &&
                        bookingDate.isBefore(
                          currentDate.add(const Duration(days: 1)),
                        );
                  }).toList();

              final oneWeekBookings =
                  assignments.where((a) {
                    final bookingDate = DateFormat('dd/MM/yyyy').parse(a.date);
                    return bookingDate.isAfter(
                      currentDate.subtract(const Duration(days: 7)),
                    );
                  }).toList();

              final oneMonthBookings =
                  assignments.where((a) {
                    final bookingDate = DateFormat('dd/MM/yyyy').parse(a.date);
                    return bookingDate.isAfter(
                      currentDate.subtract(const Duration(days: 30)),
                    );
                  }).toList();

              final oneDayTotalPrice = oneDayBookings.fold<double>(0.0, (
                sum,
                a,
              ) {
                final client = clientBox.values.firstWhere(
                  (c) => c.clientId == a.clientId,
                  orElse:
                      () => PackageClient(
                        clientId: '',
                        name: '',
                        phone: '',
                        date: '',
                        placeName: '',
                        packageType: '',
                        price: 0.0,
                      ),
                );
                return sum + (client.price ?? 0.0);
              });

              final oneWeekTotalPrice = oneWeekBookings.fold<double>(0.0, (
                sum,
                a,
              ) {
                final client = clientBox.values.firstWhere(
                  (c) => c.clientId == a.clientId,
                  orElse:
                      () => PackageClient(
                        clientId: '',
                        name: '',
                        phone: '',
                        date: '',
                        placeName: '',
                        packageType: '',
                        price: 0.0,
                      ),
                );
                return sum + (client.price ?? 0.0);
              });

              final oneMonthTotalPrice = oneMonthBookings.fold<double>(0.0, (
                sum,
                a,
              ) {
                final client = clientBox.values.firstWhere(
                  (c) => c.clientId == a.clientId,
                  orElse:
                      () => PackageClient(
                        clientId: '',
                        name: '',
                        phone: '',
                        date: '',
                        placeName: '',
                        packageType: '',
                        price: 0.0,
                      ),
                );
                return sum + (client.price ?? 0.0);
              });

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 4,
                      color: Theme.of(context).cardColor,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '1 Day Bookings',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(
                                          context,
                                        ).textTheme.bodyMedium!.color,
                                  ),
                                ),
                                Text(
                                  '${oneDayBookings.length}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Total Price: ₹${oneDayTotalPrice.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyMedium!.color?.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      elevation: 4,
                      color: Theme.of(context).cardColor,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '1 Week Bookings',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(
                                          context,
                                        ).textTheme.bodyMedium!.color,
                                  ),
                                ),
                                Text(
                                  '${oneWeekBookings.length}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Total Price: ₹${oneWeekTotalPrice.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyMedium!.color?.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      elevation: 4,
                      color: Theme.of(context).cardColor,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '1 Month Bookings',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(
                                          context,
                                        ).textTheme.bodyMedium!.color,
                                  ),
                                ),
                                Text(
                                  '${oneMonthBookings.length}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Total Price: ₹${oneMonthTotalPrice.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyMedium!.color?.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

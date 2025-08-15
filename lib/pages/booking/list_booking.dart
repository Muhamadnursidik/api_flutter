import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:api_flutter/models/booking_model.dart';
import 'package:api_flutter/services/booking_service.dart'; // service API nu nyokot data

class BookingListPage extends StatefulWidget {
  const BookingListPage({super.key});

  @override
  State<BookingListPage> createState() => _BookingListPageState();
}

class _BookingListPageState extends State<BookingListPage> {
  late Future<Booking> bookingFuture;

  @override
  void initState() {
    super.initState();
    bookingFuture = BookingService.getBookings(); // method ambil API
  }

  String formatCurrency(int price) {
    final format = NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);
    return format.format(price);
  }

  String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy HH:mm', 'id').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Booking Saya")),
      body: FutureBuilder<Booking>(
        future: bookingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final bookings = snapshot.data?.data ?? [];
          if (bookings.isEmpty) {
            return const Center(child: Text("Belum ada booking"));
          }

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return Card(
                child: ListTile(
                  leading: booking.field?.img != null
                      ? Image.network(booking.field!.img!, width: 60, fit: BoxFit.cover)
                      : const Icon(Icons.sports_soccer),
                  title: Text(booking.field?.name ?? "Tanpa Nama"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${formatCurrency(booking.field?.pricePerHour ?? 0)} / jam"),
                      Text("Mulai: ${formatDate(booking.startTime!)}"),
                      Text("Selesai: ${formatDate(booking.endTime!)}"),
                      Text("Status: ${booking.status}"),
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
}

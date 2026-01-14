// app/modules/orders/views/order_success_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:ebee/app/data/models/order_model.dart';
import 'package:ebee/app/data/models/address_model.dart';

class OrderSuccessView extends StatelessWidget {
  final Order? order;
  final String? orderId;
  final double? amount;
  final String? phoneNumber;

  OrderSuccessView({
    super.key,
    this.order,
    this.orderId,
    this.amount,
    this.phoneNumber,
  }) : assert(
         order != null ||
             (orderId != null && amount != null && phoneNumber != null),
         'Either provide order object or individual parameters',
       );

  // Getters to handle both constructor types
  String get _orderId => order?.id ?? orderId!;
  double get _amount => order?.totalPrice ?? amount!;
  String get _phoneNumber => order?.user?.phoneNumber ?? phoneNumber!;
  List<OrderItem>? get _orderItems => order?.orderItems;
  DateTime get _timestamp => order?.createdAt ?? DateTime.now();

  // Calculate subtotal from order items
  double get _subtotal {
    if (_orderItems == null) return _amount;
    return _orderItems!.fold(0, (sum, item) => sum + item.subtotal);
  }

  // Calculate total discount (if any)
  double get _totalDiscount => 0.0;

  // Generate PDF receipt
  Future<pw.Document> _generateReceipt() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Center(
                child: pw.Text(
                  'eBee - Payment Receipt',
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 20),

              // Order Details
              pw.Text(
                'ORDER CONFIRMED',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [pw.Text('Order ID:'), pw.Text('#$_orderId')],
              ),
              pw.SizedBox(height: 5),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Date:'),
                  pw.Text(
                    '${_timestamp.day}/${_timestamp.month}/${_timestamp.year} ${_timestamp.hour}:${_timestamp.minute.toString().padLeft(2, '0')}',
                  ),
                ],
              ),
              pw.SizedBox(height: 5),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [pw.Text('Phone:'), pw.Text(_phoneNumber)],
              ),
              pw.SizedBox(height: 20),

              // Order Items
              if (_orderItems != null && _orderItems!.isNotEmpty) ...[
                pw.Text(
                  'ORDER ITEMS',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),

                // Table Header
                pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300),
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  child: pw.Row(
                    children: [
                      pw.Expanded(
                        flex: 3,
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text(
                            'Item',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text(
                            'Qty',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text(
                            'Price',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            textAlign: pw.TextAlign.right,
                          ),
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text(
                            'Total',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            textAlign: pw.TextAlign.right,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Order Items List
                ..._orderItems!
                    .map(
                      (item) => pw.Container(
                        decoration: pw.BoxDecoration(
                          border: pw.Border(
                            bottom: pw.BorderSide(color: PdfColors.grey300),
                          ),
                        ),
                        child: pw.Row(
                          children: [
                            pw.Expanded(
                              flex: 3,
                              child: pw.Padding(
                                padding: const pw.EdgeInsets.all(8.0),
                                child: pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text(
                                      item.product?.name ?? 'Product Name',
                                    ),
                                    if (item.product?.description != null)
                                      pw.Text(
                                        item.product!.description!,
                                        style: pw.TextStyle(
                                          fontSize: 8,
                                          color: PdfColors.grey,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            pw.Expanded(
                              child: pw.Padding(
                                padding: const pw.EdgeInsets.all(8.0),
                                child: pw.Text(
                                  item.quantity.toString(),
                                  textAlign: pw.TextAlign.center,
                                ),
                              ),
                            ),
                            pw.Expanded(
                              child: pw.Padding(
                                padding: const pw.EdgeInsets.all(8.0),
                                child: pw.Text(
                                  'KES ${item.price.toStringAsFixed(2)}',
                                  textAlign: pw.TextAlign.right,
                                ),
                              ),
                            ),
                            pw.Expanded(
                              child: pw.Padding(
                                padding: const pw.EdgeInsets.all(8.0),
                                child: pw.Text(
                                  'KES ${item.subtotal.toStringAsFixed(2)}',
                                  textAlign: pw.TextAlign.right,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                pw.SizedBox(height: 20),
              ],

              // Order Summary
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey400),
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: pw.Column(
                  children: [
                    if (_orderItems != null && _orderItems!.isNotEmpty) ...[
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Subtotal:'),
                          pw.Text('KES ${_subtotal.toStringAsFixed(2)}'),
                        ],
                      ),
                      if (_totalDiscount > 0) pw.SizedBox(height: 5),
                      if (_totalDiscount > 0)
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('Discount:'),
                            pw.Text(
                              '- KES ${_totalDiscount.toStringAsFixed(2)}',
                              style: pw.TextStyle(color: PdfColors.green),
                            ),
                          ],
                        ),
                      pw.SizedBox(height: 5),
                      pw.Divider(),
                      pw.SizedBox(height: 5),
                    ],
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Total Amount:',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        pw.Text(
                          'KES ${_amount.toStringAsFixed(2)}',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 20),

              // Payment Details
              pw.Text(
                'PAYMENT DETAILS',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Amount Paid:'),
                  pw.Text('KES ${_amount.toStringAsFixed(2)}'),
                ],
              ),
              pw.SizedBox(height: 5),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [pw.Text('Payment Method:'), pw.Text('M-Pesa')],
              ),
              pw.SizedBox(height: 5),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Status:'),
                  pw.Text(
                    'Completed',
                    style: pw.TextStyle(color: PdfColors.green),
                  ),
                ],
              ),
              pw.SizedBox(height: 30),

              // Footer
              pw.Center(
                child: pw.Text(
                  'Thank you for your purchase!',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontStyle: pw.FontStyle.italic,
                  ),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Center(
                child: pw.Text(
                  'Support: support@ebee.com | 0700 000 000',
                  style: pw.TextStyle(fontSize: 10),
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  // Print receipt
  Future<void> _printReceipt() async {
    try {
      final pdf = await _generateReceipt();
      await Printing.layoutPdf(onLayout: (format) => pdf.save());
    } catch (e) {
      Get.snackbar(
        'Print Error',
        'Failed to print receipt: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Confirmed'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Success Icon
              const Icon(Icons.check_circle, color: Colors.green, size: 80),
              const SizedBox(height: 20),

              // Success Message
              const Text(
                'Payment Successful!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 10),

              Text(
                'Your order has been confirmed',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 30),

              // Order Details Card
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildDetailRow('Order ID', '#$_orderId'),
                      const Divider(),
                      _buildDetailRow(
                        'Amount',
                        'KES ${_amount.toStringAsFixed(2)}',
                      ),
                      const Divider(),
                      _buildDetailRow('Phone', _phoneNumber),
                      const Divider(),
                      _buildDetailRow(
                        'Date',
                        '${_timestamp.day}/${_timestamp.month}/${_timestamp.year}',
                      ),
                      const Divider(),
                      _buildDetailRow(
                        'Time',
                        '${_timestamp.hour}:${_timestamp.minute.toString().padLeft(2, '0')}',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.print),
                      label: const Text('Print Receipt'),
                      onPressed: _printReceipt,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // Continue Shopping Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to home and clear all previous routes
                    Get.offAllNamed('/home');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    'Continue Shopping',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

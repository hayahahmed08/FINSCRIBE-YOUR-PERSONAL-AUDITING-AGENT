import 'package:flutter/material.dart';
import '../Utils/components/colors.dart';
import '../model/invoice_model.dart';
import '../services/invoice_services.dart';

class InvoiceScreen extends StatefulWidget {
  @override
  _InvoiceScreenState createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  Future<List<Invoice>>? invoices;

  @override
  void initState() {
    super.initState();
    invoices = InvoiceService().fetchInvoices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.appbarColor,
        title: Text(
          "Invoices Details",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Invoice>>(
        future: invoices,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No invoices available'));
          } else {
            final invoiceList = snapshot.data!;

            return ListView.builder(
              itemCount: invoiceList.length,
              itemBuilder: (context, index) {
                final invoice = invoiceList[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Vendor and Invoice Details
                        Text(
                          'Vendor: ${invoice.vendorName}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Invoice Number: ${invoice.invoiceNumber}',
                          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                        Text(
                          'Invoice Date: ${invoice.invoiceDate}',
                          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                        SizedBox(height: 16),

                        // Product List
                        ...invoice.products.map(
                              (product) => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Product Name: ${product.productName}',
                                  style: TextStyle(fontSize: 14, color: Colors.black87),
                                ),
                                Text(
                                  'Product Type: ${product.productType}',
                                  style: TextStyle(fontSize: 14, color: Colors.black54),
                                ),
                                Text(
                                  'Category: ${product.productCategory}',
                                  style: TextStyle(fontSize: 14, color: Colors.black54),
                                ),
                                Text(
                                  'Quantity: ${product.quantity}',
                                  style: TextStyle(fontSize: 14, color: Colors.black54),
                                ),
                                Text(
                                  'Unit Price: ${product.unitPrice}',
                                  style: TextStyle(fontSize: 14, color: Colors.black54),
                                ),
                                Text(
                                  'Total Product Price: ${product.totalProductPrice}',
                                  style: TextStyle(fontSize: 14, color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 12),

                        // Divider
                        Divider(color: Colors.grey[300], height: 1),

                        // Invoice Summary
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Subtotal: ${invoice.invoiceSummary.subTotal}',
                                style: TextStyle(fontSize: 14, color: Colors.black87),
                              ),
                              Text(
                                'GST: ${invoice.invoiceSummary.gst}',
                                style: TextStyle(fontSize: 14, color: Colors.black87),
                              ),
                              Text(
                                'Other Taxes: ${invoice.invoiceSummary.otherTaxes}',
                                style: TextStyle(fontSize: 14, color: Colors.black87),
                              ),
                              Text(
                                'Total Quantity: ${invoice.invoiceSummary.totalQuantity}',
                                style: TextStyle(fontSize: 14, color: Colors.black87),
                              ),
                              Text(
                                'Total Price: ${invoice.invoiceSummary.totalPrice}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.text,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );

            // return ListView.builder(
            //   itemCount: invoiceList.length,
            //   itemBuilder: (context, index) {
            //     final invoice = invoiceList[index];
            //     return Card(
            //       margin: EdgeInsets.all(8),
            //       child: Padding(
            //         padding: EdgeInsets.all(16),
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Text('Vendor: ${invoice.vendorName}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: AppColors.text)),
            //             Text('Invoice Number: ${invoice.invoiceNumber}', style: TextStyle(fontSize: 14)),
            //             Text('Invoice Date: ${invoice.invoiceDate}', style: TextStyle(fontSize: 14)),
            //             SizedBox(height: 10),
            //             // Display product list
            //             for (var product in invoice.products)
            //               Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   Text('Product Name: ${product.productName}', style: TextStyle(fontSize: 14)),
            //                   Text('Product Type: ${product.productType}', style: TextStyle(fontSize: 14)),
            //                   Text('Category: ${product.productCategory}', style: TextStyle(fontSize: 14)),
            //                   Text('Quantity: ${product.quantity}', style: TextStyle(fontSize: 14)),
            //                   Text('Unit Price: ${product.unitPrice}', style: TextStyle(fontSize: 14)),
            //                   Text('Total Product Price: ${product.totalProductPrice}', style: TextStyle(fontSize: 14)),
            //                   SizedBox(height: 10),
            //                 ],
            //               ),
            //             SizedBox(height: 10),
            //             Divider(),
            //             // Display invoice summary
            //             Text('Subtotal: ${invoice.invoiceSummary.subTotal}', style: TextStyle(fontSize: 14)),
            //             Text('GST: ${invoice.invoiceSummary.gst}', style: TextStyle(fontSize: 14)),
            //             Text('Other Taxes: ${invoice.invoiceSummary.otherTaxes}', style: TextStyle(fontSize: 14)),
            //             Text('Total Quantity: ${invoice.invoiceSummary.totalQuantity}', style: TextStyle(fontSize: 14)),
            //             Text('Total Price: ${invoice.invoiceSummary.totalPrice}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            //           ],
            //         ),
            //       ),
            //     );
            //   },
            // );
          }
        },
      ),
    );
  }
}

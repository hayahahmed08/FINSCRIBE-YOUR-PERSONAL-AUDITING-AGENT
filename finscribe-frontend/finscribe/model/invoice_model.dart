class Invoice {
  final String vendorName;
  final String invoiceNumber;
  final String invoiceDate;
  final List<Product> products;
  final InvoiceSummary invoiceSummary;
  final String id;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Invoice({
    required this.vendorName,
    required this.invoiceNumber,
    required this.invoiceDate,
    required this.products,
    required this.invoiceSummary,
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      vendorName: json['vendor_name'],
      invoiceNumber: json['invoice_number'],
      invoiceDate: json['invoice_date'],
      products: List<Product>.from(json['products'].map((x) => Product.fromJson(x))),
      invoiceSummary: InvoiceSummary.fromJson(json['invoice_summary']),
      id: json['_id'],
      userId: json['user_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vendor_name': vendorName,
      'invoice_number': invoiceNumber,
      'invoice_date': invoiceDate,
      'products': List<dynamic>.from(products.map((x) => x.toJson())),
      'invoice_summary': invoiceSummary.toJson(),
      '_id': id,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class Product {
  final String productName;
  final String productType;
  final String productCategory;
  final double unitPrice;
  final int quantity;
  final double totalProductPrice;

  Product({
    required this.productName,
    required this.productType,
    required this.productCategory,
    required this.unitPrice,
    required this.quantity,
    required this.totalProductPrice,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productName: json['product_name'],
      productType: json['product_type'],
      productCategory: json['product_category'],
      unitPrice: (json['unit_price'] as num).toDouble(),
      quantity: json['quantity'],
      totalProductPrice: (json['total_product_price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_name': productName,
      'product_type': productType,
      'product_category': productCategory,
      'unit_price': unitPrice,
      'quantity': quantity,
      'total_product_price': totalProductPrice,
    };
  }
}

class InvoiceSummary {
  final double subTotal;
  final double gst;
  final double otherTaxes;
  final double tax;
  final int totalQuantity;
  final double totalPrice;
  final double discount;

  InvoiceSummary({
    required this.subTotal,
    required this.gst,
    required this.otherTaxes,
    required this.tax,
    required this.totalQuantity,
    required this.totalPrice,
    required this.discount,
  });

  factory InvoiceSummary.fromJson(Map<String, dynamic> json) {
    return InvoiceSummary(
      subTotal: (json['sub_total'] as num).toDouble(),
      gst: (json['gst'] as num).toDouble(),
      otherTaxes: (json['other_taxes'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      totalQuantity: json['total_quantity'],
      totalPrice: (json['total_price'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sub_total': subTotal,
      'gst': gst,
      'other_taxes': otherTaxes,
      'tax': tax,
      'total_quantity': totalQuantity,
      'total_price': totalPrice,
      'discount': discount,
    };
  }
}

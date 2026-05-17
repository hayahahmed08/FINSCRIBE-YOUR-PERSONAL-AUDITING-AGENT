class chatbot_data_model {
  Summary? summary;
  List<TopVendors>? topVendors;
  List<TopCategories>? topCategories;
  List<MonthlySpending>? monthlySpending;
  List<DailySpending>? dailySpending;
  List<DetailData>? detailData;

  chatbot_data_model(
      {this.summary,
        this.topVendors,
        this.topCategories,
        this.monthlySpending,
        this.dailySpending,
        this.detailData});

  chatbot_data_model.fromJson(Map<String, dynamic> json) {
    summary =
    json['summary'] != null ? new Summary.fromJson(json['summary']) : null;
    if (json['top_vendors'] != null) {
      topVendors = <TopVendors>[];
      json['top_vendors'].forEach((v) {
        topVendors!.add(new TopVendors.fromJson(v));
      });
    }
    if (json['top_categories'] != null) {
      topCategories = <TopCategories>[];
      json['top_categories'].forEach((v) {
        topCategories!.add(new TopCategories.fromJson(v));
      });
    }
    if (json['monthly_spending'] != null) {
      monthlySpending = <MonthlySpending>[];
      json['monthly_spending'].forEach((v) {
        monthlySpending!.add(new MonthlySpending.fromJson(v));
      });
    }
    if (json['daily_spending'] != null) {
      dailySpending = <DailySpending>[];
      json['daily_spending'].forEach((v) {
        dailySpending!.add(new DailySpending.fromJson(v));
      });
    }
    if (json['Detail_data'] != null) {
      detailData = <DetailData>[];
      json['Detail_data'].forEach((v) {
        detailData!.add(new DetailData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.summary != null) {
      data['summary'] = this.summary!.toJson();
    }
    if (this.topVendors != null) {
      data['top_vendors'] = this.topVendors!.map((v) => v.toJson()).toList();
    }
    if (this.topCategories != null) {
      data['top_categories'] =
          this.topCategories!.map((v) => v.toJson()).toList();
    }
    if (this.monthlySpending != null) {
      data['monthly_spending'] =
          this.monthlySpending!.map((v) => v.toJson()).toList();
    }
    if (this.dailySpending != null) {
      data['daily_spending'] =
          this.dailySpending!.map((v) => v.toJson()).toList();
    }
    if (this.detailData != null) {
      data['Detail_data'] = this.detailData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Summary {
  double? totalSpending;
  int? totalQuantity;
  double? totalTaxes;
  int? totalDiscounts;

  Summary(
      {this.totalSpending,
        this.totalQuantity,
        this.totalTaxes,
        this.totalDiscounts});

  Summary.fromJson(Map<String, dynamic> json) {
    totalSpending = json['total_spending'];
    totalQuantity = json['total_quantity'];
    totalTaxes = json['total_taxes'];
    totalDiscounts = json['total_discounts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_spending'] = this.totalSpending;
    data['total_quantity'] = this.totalQuantity;
    data['total_taxes'] = this.totalTaxes;
    data['total_discounts'] = this.totalDiscounts;
    return data;
  }
}

class TopVendors {
  String? name;
  double? amount;

  TopVendors({this.name, this.amount});

  TopVendors.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['amount'] = this.amount;
    return data;
  }
}

class TopCategories {
  String? name;
  int? amount;

  TopCategories({this.name, this.amount});

  TopCategories.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['amount'] = this.amount;
    return data;
  }
}

class MonthlySpending {
  String? month;
  double? amount;

  MonthlySpending({this.month, this.amount});

  MonthlySpending.fromJson(Map<String, dynamic> json) {
    month = json['month'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['month'] = this.month;
    data['amount'] = this.amount;
    return data;
  }
}

class DailySpending {
  String? day;
  double? amount;

  DailySpending({this.day, this.amount});

  DailySpending.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['amount'] = this.amount;
    return data;
  }
}

class DetailData {
  String? vendorName;
  String? invoiceNumber;
  String? invoiceDate;
  List<Products>? products;
  InvoiceSummary? invoiceSummary;
  String? sId;
  String? userId;
  String? createdAt;
  String? updatedAt;

  DetailData(
      {this.vendorName,
        this.invoiceNumber,
        this.invoiceDate,
        this.products,
        this.invoiceSummary,
        this.sId,
        this.userId,
        this.createdAt,
        this.updatedAt});

  DetailData.fromJson(Map<String, dynamic> json) {
    vendorName = json['vendor_name'];
    invoiceNumber = json['invoice_number'];
    invoiceDate = json['invoice_date'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
    invoiceSummary = json['invoice_summary'] != null
        ? new InvoiceSummary.fromJson(json['invoice_summary'])
        : null;
    sId = json['_id'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vendor_name'] = this.vendorName;
    data['invoice_number'] = this.invoiceNumber;
    data['invoice_date'] = this.invoiceDate;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    if (this.invoiceSummary != null) {
      data['invoice_summary'] = this.invoiceSummary!.toJson();
    }
    data['_id'] = this.sId;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Products {
  String? productName;
  String? productType;
  String? productCategory;
  int? unitPrice;
  int? quantity;
  int? totalProductPrice;

  Products(
      {this.productName,
        this.productType,
        this.productCategory,
        this.unitPrice,
        this.quantity,
        this.totalProductPrice});

  Products.fromJson(Map<String, dynamic> json) {
    productName = json['product_name'];
    productType = json['product_type'];
    productCategory = json['product_category'];
    unitPrice = json['unit_price'];
    quantity = json['quantity'];
    totalProductPrice = json['total_product_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_name'] = this.productName;
    data['product_type'] = this.productType;
    data['product_category'] = this.productCategory;
    data['unit_price'] = this.unitPrice;
    data['quantity'] = this.quantity;
    data['total_product_price'] = this.totalProductPrice;
    return data;
  }
}

class InvoiceSummary {
  int? subTotal;
  int? gst;
  double? otherTaxes;
  double? tax;
  int? totalQuantity;
  double? totalPrice;
  int? discount;

  InvoiceSummary(
      {this.subTotal,
        this.gst,
        this.otherTaxes,
        this.tax,
        this.totalQuantity,
        this.totalPrice,
        this.discount});

  InvoiceSummary.fromJson(Map<String, dynamic> json) {
    subTotal = json['sub_total'];
    gst = json['gst'];
    otherTaxes = json['other_taxes'];
    tax = json['tax'];
    totalQuantity = json['total_quantity'];
    totalPrice = json['total_price'];
    discount = json['discount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sub_total'] = this.subTotal;
    data['gst'] = this.gst;
    data['other_taxes'] = this.otherTaxes;
    data['tax'] = this.tax;
    data['total_quantity'] = this.totalQuantity;
    data['total_price'] = this.totalPrice;
    data['discount'] = this.discount;
    return data;
  }
}
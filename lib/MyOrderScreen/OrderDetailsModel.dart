class Posts {
  final String order_detail_id;
  final String order_master_id;
  final String product_id;
  final String Qty;
  final String Rate;
  final String OrderId;
  final String OrderDate;
  final String userId;
  final String Amount;
  final String order_status;
  final String customer;
  final String productName;
  final String amount;

  // final String TotalAmount;

  Posts({this.order_detail_id, this.order_master_id, this.product_id, this.Qty,this.Rate,this.OrderId,this.OrderDate,this.userId,this.Amount,this.order_status,this.customer,this.productName,this.amount});


  factory Posts.formJson(Map <String, dynamic> json){
    return new Posts(
      order_detail_id: json['order_detail_id'],
      order_master_id: json['order_master_id'],
      product_id: json['product_id'],
      Qty: json['Qty'],
      Rate: json['Rate'],
      OrderId: json['OrderId'],
      OrderDate: json['OrderDate'],
      userId: json['userId'],
      Amount: json['Amount'],
      order_status: json['order_status'],
      customer: json['customer'],
      productName: json['productName'],
      amount: json['amount'],
      );
  }
}
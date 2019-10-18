class Posts {
  final String OrderId;
  final String OrderDate;
  final String userId;
  final String Amount;
  final String order_status;


  // final String TotalAmount;

  Posts({this.OrderId, this.OrderDate, this.userId, this.Amount,this.order_status});


  factory Posts.formJson(Map <String, dynamic> json){
    return new Posts(
      OrderId: json['OrderId'],
      OrderDate: json['OrderDate'],
      userId: json['userId'],
      Amount: json['Amount'],
      order_status: json['order_status'],
      );
  }
}
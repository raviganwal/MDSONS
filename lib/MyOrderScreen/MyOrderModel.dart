class Posts {
  final String OrderId;
  final String OrderDate;
  final String userId;
  final String Amount;
  final String order_status;
  final String Payment_Image;

  // final String TotalAmount;

  Posts({this.OrderId, this.OrderDate, this.userId, this.Amount,this.order_status,this.Payment_Image});


  factory Posts.formJson(Map <String, dynamic> json){
    return new Posts(
      OrderId: json['OrderId'],
      OrderDate: json['OrderDate'],
      userId: json['userId'],
      Amount: json['Amount'],
      order_status: json['order_status'],
      Payment_Image: json['Payment_Image'],
      );
  }
}
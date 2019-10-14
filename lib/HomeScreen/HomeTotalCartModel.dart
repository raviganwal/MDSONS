class Posts {
  final String userId;
  final String id;
  final String productname;
  final String SellingPrice;
  final String image;
  final String MRP;
  final int QtyMRP;
  final String howtouse;
  final String mrp;
  final String Discount;
  final String productnumber;
  final String description;
  final String brand;
  final String count;

  Posts({this.userId, this.id, this.productname, this.SellingPrice,this.image,this.MRP,this.howtouse,this.mrp,this.Discount,this.productnumber,this.description,this.brand,this.count,this.QtyMRP});


  factory Posts.formJson(Map <String, dynamic> json){
    return new Posts(
      userId: json['product_id'],
      id: json['Id'],
      productname: json['product_name'],
      SellingPrice: json['SellingPrice'],
      image: json['image'],
      MRP: json['MRP'],
      QtyMRP: json['QtyMRP'],
      howtouse: json['how_to_use'],
      mrp: json['MRP'],
      Discount: json['Discount'],
      productnumber: json['product_number'],
      description: json['description'],
      brand: json['brand'],
      count: json['count(Cart.ProductId)'],
      //TotalAmount: json['total'],
      );
  }
}
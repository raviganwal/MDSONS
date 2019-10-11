class Posts {
  final String userId;
  final String id;
  final String title;
  final String body;
  final String image;
  final String categoryname;
  final String subcategoryname;
  final String howtouse;
  final String mrp;
  final String Discount;
  final String productnumber;
  final String description;

  Posts({this.userId, this.id, this.title, this.body,this.image,this.categoryname, this.subcategoryname,this.howtouse,this.mrp,this.Discount,this.productnumber,this.description});


  factory Posts.formJson(Map <String, dynamic> json){
    return new Posts(
      userId: json['product_id'],
      id: json['category_id'],
      title: json['product_name'],
      body: json['SellingPrice'],
      image: json['image'],
      categoryname: json['categoryname'],
      subcategoryname: json['subcategoryname'],
      howtouse: json['how_to_use'],
      mrp: json['MRP'],
      Discount: json['Discount'],
      productnumber: json['product_number'],
      description: json['description'],
    );
  }
}
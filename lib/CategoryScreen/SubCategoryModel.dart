class Posts {

  final String id;
  final String title;

  Posts({this.id, this.title});

  factory Posts.formJson(Map <String, dynamic> json){
    return new Posts(
      id: json['sub_cat_id'],
      title: json['sub_cat_name'],
    );
  }
}
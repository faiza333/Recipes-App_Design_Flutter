import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class RecipeModel {
  String label;
  String image;
  String source;
  String url;
  
  RecipeModel({this.label,this.image,this.source,this.url});
  factory RecipeModel.formMap(Map<String, dynamic>parsedjson){//هيحفظ كل كلب بالقيمة بتاعته مش زي ال بيظهر في الكنسول يعني لو كتبت موز يرجعلي مور بالبيلنات
    return RecipeModel(
      url: parsedjson["url"],
      label: parsedjson["label"],
      image: parsedjson["image"],
      source: parsedjson["source"]
    );
  }
}
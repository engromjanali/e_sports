import 'package:flutter/foundation.dart';

void printer(dynamic title){
  if(kDebugMode){
    print("📌===>: $title 📌");
  }
}
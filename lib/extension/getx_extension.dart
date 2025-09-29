import 'package:get/get.dart';

extension FindOrPut on GetInterface {
  S findOrPut<S>(S dependency,{String? tag}){
    if(GetInstance().isRegistered<S>(tag: tag)){
      return GetInstance().find<S>(tag: tag);
    }
    return GetInstance().put<S>(dependency,tag: tag);
  }
}
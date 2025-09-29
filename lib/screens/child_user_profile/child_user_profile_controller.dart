import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../config/app_config.dart';
import 'models/child_user_model.dart';

class ChildUserProfileController extends GetxController {
  final user = ChildUserModel(
    coverImageUrl:
        "https://images.unsplash.com/photo-1464983953574-0892a716854b?auto=format&fit=crop&w=800&q=80",
    avatarUrl: "https://randomuser.me/api/portraits/men/31.jpg",
    name: "Randy Dorwart",
    age: 25,
    username: "randydorwart",
    bio: "Food, Photography Enthusiast",
    posts: 21,
    connections: 815,
    interests: ["Food", "Photography"],
    coins: 5000,
    photos: [
      "https://images.unsplash.com/photo-1615216872226-3b0d6536617b?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTQzfHxhZXN0aGV0aWN8ZW58MHx8MHx8fDA%3D",
      "https://images.unsplash.com/photo-1510897345173-4d938815feb4?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTE5fHxhZXN0aGV0aWN8ZW58MHx8MHx8fDA%3D",
      "https://plus.unsplash.com/premium_photo-1667251759650-7af80fe4d079?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NTN8fGFlc3RoZXRpY3xlbnwwfHwwfHx8MA%3D%3D",
      "https://images.unsplash.com/photo-1506543277633-99deabfcd722?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MzQ4fHxhZXN0aGV0aWN8ZW58MHx8MHx8fDA%3D",
      "https://images.unsplash.com/photo-1623318046551-740404b7c7d1?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mzk0fHxhZXN0aGV0aWN8ZW58MHx8MHx8fDA%3D",
      "https://images.unsplash.com/photo-1600804340584-c7db2eacf0bf?ixlib=rb-4.0.3&auto=format&fit=crop&w=774&q=80",
      "https://plus.unsplash.com/premium_photo-1668472274328-cd239ae3586f?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTkzfHxhZXN0aGV0aWN8ZW58MHx8MHx8fDA%3D",
      "https://images.unsplash.com/photo-1558603668-6570496b66f8?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjIyfHxhZXN0aGV0aWN8ZW58MHx8MHx8fDA%3D",
      "https://plus.unsplash.com/premium_photo-1681414728888-c2360c8852f6?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8ODA5fHxhZXN0aGV0aWN8ZW58MHx8MHx8fDA%3D",
      "https://images.unsplash.com/photo-1482881497185-d4a9ddbe4151?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MzExfHxhZXN0aGV0aWN8ZW58MHx8MHx8fDA%3D",
      "https://images.unsplash.com/photo-1498050108023-c5249f4df085?ixlib=rb-4.0.3&auto=format&fit=crop&w=870&q=80",
      "https://images.unsplash.com/photo-1605187151664-9d89904d62d0?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTY0fHxhZXN0aGV0aWN8ZW58MHx8MHx8fDA%3D",
      "https://plus.unsplash.com/premium_photo-1691741857660-4a1d329e1b6e?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NTA5fHxhZXN0aGV0aWN8ZW58MHx8MHx8fDA%3D",
      "https://plus.unsplash.com/premium_photo-1680543345236-f2b4815fcd94?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NTczfHxhZXN0aGV0aWN8ZW58MHx8MHx8fDA%3D",
      "https://images.unsplash.com/photo-1604782206219-3b9576575203?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NjM0fHxhZXN0aGV0aWN8ZW58MHx8MHx8fDA%3D",
      "https://images.unsplash.com/photo-1638531540339-3846e93110c5?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NjQzfHxhZXN0aGV0aWN8ZW58MHx8MHx8fDA%3D",
      "https://plus.unsplash.com/premium_photo-1681414728724-20776252d54a?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NjQ5fHxhZXN0aGV0aWN8ZW58MHx8MHx8fDA%3D",
      "https://images.unsplash.com/photo-1648241154336-69f1dd4a7545?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NzU1fHxhZXN0aGV0aWN8ZW58MHx8MHx8fDA%3D",
    ],
    videos: [
      "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
      "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
    ],
    taggedUrls: [
      "https://plus.unsplash.com/premium_photo-1667251759650-7af80fe4d079?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NTN8fGFlc3RoZXRpY3xlbnwwfHwwfHx8MA%3D%3D",
    ],
  );

  final RxInt selectedTab = 0.obs; //0 = Photos, 1 = Videos, 2 = Tagged
  var videoControllers = <VideoPlayerController?>[].obs;
  var isVideoInitialized = <bool>[].obs;
  var isVideoError = <bool>[].obs;

  void initVideoControllers() {
    disposeVideoControllers();
    int videoCount = user.videos.length;
    videoControllers.value =
        List<VideoPlayerController?>.filled(videoCount, null);
    isVideoInitialized.value = List<bool>.filled(videoCount, false);
    isVideoError.value = List<bool>.filled(videoCount, false);

    for (int i = 0; i < videoCount; i++) {
      final videoUrl = user.videos[i];
      Uri? uri = Uri.tryParse(videoUrl);

      if (uri != null &&
          uri.isAbsolute &&
          (uri.scheme == 'http' || uri.scheme == 'https')) {
        final controller = VideoPlayerController.networkUrl(uri);
        videoControllers[i] = controller;
        controller.initialize().then((_) {
          isVideoInitialized[i] = true;
          isVideoError[i] = false;
          controller.setLooping(true);
          controller.pause();
          update();
        }).catchError((error, stackTrace) {
          isVideoInitialized[i] = false;
          isVideoError[i] = true;
          update();
        });
      } else {
        isVideoError[i] = true;
      }
    }
  }

  void disposeVideoControllers() {
    for (var c in videoControllers) {
      c?.dispose();
    }
    videoControllers.clear();
    isVideoInitialized.clear();
    isVideoError.clear();
  }
}

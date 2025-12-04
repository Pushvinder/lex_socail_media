import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_friendz_zone/models/comment_model.dart';

import '../../api_helpers/api_manager.dart';
import '../../api_helpers/api_utils.dart';
import '../../helpers/storage_helper.dart';
import '../../utils/app_colors.dart';

class CommunityPostDetailController extends GetxController {
  final Rx<CommentModel> comments = CommentModel().obs;
  final Rx<CommentModel?> replyingTo = Rx<CommentModel?>(null);
  final TextEditingController commentController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchComments(postId) async {
    try {
      var result = await ApiManager.callPostWithFormData(body: {
        'request': 'comment_list',
        'post_id': postId,
        'id': StorageHelper().getUserId.toString(),
      }, endPoint: ApiUtils.commentList);

      comments.value = CommentModel.fromJson((result));
    } catch (e) {
      print('Error fetching comments: $e');
      throw Exception('Failed to load comments');
    }
  }

  Future<bool> postComment(postId) async {
    if (commentController.text.trim().isEmpty) {
      return false;
    }

    try {
      final response = await ApiManager.callPostWithFormData(
        body: {
          'request': 'add_post_comment',
          'user_id': StorageHelper().getUserId.toString(),
          'post_id': postId,
          'comment': commentController.text.trim(),
        },
        endPoint: ApiUtils.addPostComment,
      );

      // Assuming the API returns a success status or similar upon successful post
      // You might want to parse the response to check for actual success
      print('Comment post response: $response');

      commentController.clear();
      fetchComments(postId);

      return true;


    } catch (e) {
      print('Error posting comment: $e');
      return false;
      Get.snackbar(
        'Error',
        'Failed to post comment. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.redColor,
        colorText: AppColors.whiteColor,
      );
    }
  }


  void setReplyingTo(CommentModel comment) {
    replyingTo.value = comment;
    commentController.clear();
  }

  // void addReply(String commentId, String replyText) {
  //   final idx = comments.indexWhere((c) => c.id == commentId);
  //   if (idx != -1) {
  //     comments[idx].replies.add(
  //           CommentModel(
  //             id: DateTime.now().millisecondsSinceEpoch.toString(),
  //             userName: 'You',
  //             userAvatar: 'https://randomuser.me/api/portraits/men/1.jpg',
  //             date: 'Now',
  //             text: replyText,
  //             replies: [],
  //           ),
  //         );
  //     comments.refresh();
  //     commentController.clear();
  //     replyingTo.value = null;
  //   }
  // }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_friendz_zone/config/app_config.dart';
import 'package:the_friendz_zone/models/comment_model.dart';
import 'package:the_friendz_zone/utils/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:the_friendz_zone/api_helpers/api_utils.dart';


class CommentBottomSheet extends StatefulWidget {
  final String postId;

  const CommentBottomSheet({Key? key, required this.postId}) : super(key: key);

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  late Future<CommentModel> _commentsFuture;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _commentsFuture = _fetchComments();
  }

  Future<CommentModel> _fetchComments() async {
    try {
      var result = await ApiManager.callPostWithFormData(body: {
        'request': 'comment_list',
        'post_id': widget.postId,
        'id': StorageHelper().getUserId.toString(),
      }, endPoint: ApiUtils.commentList);

      return CommentModel.fromJson((result));
    } catch (e) {
      print('Error fetching comments: $e');
      throw Exception('Failed to load comments');
    }
  }

  Future<void> _postComment() async {
    if (_commentController.text.trim().isEmpty) {
      return;
    }

    try {
      final response = await ApiManager.callPostWithFormData(
        body: {
          'request': 'add_post_comment',
          'user_id': StorageHelper().getUserId.toString(),
          'post_id': widget.postId,
          'comment': _commentController.text.trim(),
        },
        endPoint: ApiUtils.addPostComment,
      );

      // Assuming the API returns a success status or similar upon successful post
      // You might want to parse the response to check for actual success
      print('Comment post response: $response');

      _commentController.clear();
      final updatedComments = await _fetchComments();
      setState(() {
        _commentsFuture = Future.value(updatedComments);
      });

      // No longer explicitly popping here as we want to handle the pop in the build method's WillPopScope
      // Navigator.pop(context, updatedComments.totalCount?.toString());

    } catch (e) {
      print('Error posting comment: $e');
      Get.snackbar(
        'Error',
        'Failed to post comment. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.redColor,
        colorText: AppColors.whiteColor,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final currentComments = await _commentsFuture;
        Navigator.pop(context, currentComments.totalCount?.toString());
        return false; // Prevent default pop behavior
      },
      child: Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Comments',
            style: TextStyle(
              fontSize: FontDimen.dimen18,
              fontWeight: FontWeight.bold,
              color: AppColors.textColor3,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<CommentModel>(
              future: _commentsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData &&
                    snapshot.data!.data != null &&
                    snapshot.data!.data!.isNotEmpty) {
                  return ListView.builder(
                    itemCount: snapshot.data!.data!.length,
                    itemBuilder: (context, index) {
                      final comment = snapshot.data!.data![index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                image: (comment.image != null &&
                                        comment.image!.isNotEmpty)
                                    ? null
                                    : DecorationImage(
                                        image: AssetImage(AppImages.profile),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: CachedNetworkImage(
                                  imageUrl: comment.image ?? '',
                                  fit: BoxFit.cover,
                                  width: 35,
                                  height: 35,
                                  placeholder: (context, url) => Container(
                                      color: AppColors.greyShadeColor),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    color: AppColors.greyShadeColor,
                                    child: Icon(
                                      Icons.person,
                                      color: AppColors.greyColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    comment.name ?? 'Unknown',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textColor3,
                                      fontSize: FontDimen.dimen14,
                                    ),
                                  ),
                                  Text(
                                    comment.comment ?? '',
                                    style: TextStyle(
                                      color: AppColors.textColor3,
                                      fontSize: FontDimen.dimen12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: Text('No comments yet.'));
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Add a comment...',
                hintStyle: TextStyle(color: AppColors.textColor4),
                filled: true,
                fillColor: AppColors.cardBgColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.send, color: AppColors.primaryColor),
                  onPressed: _postComment,
                ),
              ),
              style: TextStyle(color: AppColors.textColor3),
            ),
          ),
        ],
      ),
    )
    );
  }
}

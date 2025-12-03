import 'package:cached_network_image/cached_network_image.dart';

import '../../../config/app_config.dart';
import '../../../models/comment_model.dart' as c;


class CommentItem extends StatelessWidget {
  final c.Data comment;
  final VoidCallback onReply;
  final bool replyingTo;
  final Function(String) onAddReply;

  const CommentItem({
    Key? key,
    required this.comment,
    required this.onReply,
    required this.replyingTo,
    required this.onAddReply,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main Comment Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.textColor4.withOpacity(1),
                  width: 3,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CachedNetworkImage(
                  imageUrl: comment.image??'',
                  fit: BoxFit.cover,
                  width: 28,
                  height: 28,
                  fadeInDuration: const Duration(milliseconds: 400),
                  placeholder: (context, url) =>
                      Container(color: AppColors.greyShadeColor),
                  errorWidget: (context, url, error) => Container(
                    color: AppColors.greyShadeColor,
                    child: Icon(
                      Icons.person,
                      color: AppColors.greyColor,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      Text(
                        comment.name??'' + ' •',
                        style: TextStyle(
                          color: AppColors.textColor3.withOpacity(1),
                          fontFamily: GoogleFonts.inter().fontFamily,
                          fontWeight: FontWeight.w600,
                          fontSize: FontDimen.dimen11,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${comment.created_at}',
                        // '20 Sep',
                        style: TextStyle(
                          color: AppColors.whiteColor.withOpacity(0.5),
                          fontFamily: GoogleFonts.inter().fontFamily,
                          fontWeight: FontWeight.w600,
                          fontSize: FontDimen.dimen10 - 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        Text(
          comment.comment??'',
          style: TextStyle(
            color: AppColors.textColor3.withOpacity(1),
            fontFamily: GoogleFonts.inter().fontFamily,
            fontWeight: FontWeight.w600,
            fontSize: FontDimen.dimen11,
          ),
        ),

        // GestureDetector(
        //   onTap: onReply,
        //   child: Text(
        //     AppStrings.reply,
        //     style: TextStyle(
        //       color: AppColors.textColor4.withOpacity(1),
        //       fontFamily: GoogleFonts.inter().fontFamily,
        //       fontWeight: FontWeight.w500,
        //       fontSize: FontDimen.dimen10,
        //     ),
        //   ),
        // ),
        const SizedBox(height: 10),
        // --- Divider ---
        Divider(
          color: AppColors.secondaryColor.withOpacity(0.5),
          thickness: 1,
          height: 5,
        ),
        // Replies
        // if (comment.replies.isNotEmpty)
        //   Padding(
        //     padding: const EdgeInsets.only(left: 44, top: 8),
        //     child: Column(
        //       children: comment.replies
        //           .map(
        //             (reply) => Row(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 CircleAvatar(
        //                   radius: 16,
        //                   backgroundImage: NetworkImage(reply.userAvatar),
        //                 ),
        //                 const SizedBox(width: 8),
        //                 Expanded(
        //                   child: Column(
        //                     crossAxisAlignment: CrossAxisAlignment.start,
        //                     children: [
        //                       Row(
        //                         children: [
        //                           Text(
        //                             reply.userName,
        //                             style: TextStyle(
        //                               color: AppColors.textColor3,
        //                               fontFamily: AppFonts.appFont,
        //                               fontWeight: FontWeight.w700,
        //                               fontSize: FontDimen.dimen13,
        //                             ),
        //                           ),
        //                           const SizedBox(width: 6),
        //                           Text(
        //                             '• ${reply.date}',
        //                             style: TextStyle(
        //                               color:
        //                                   AppColors.textColor3.withOpacity(0.6),
        //                               fontFamily: AppFonts.appFont,
        //                               fontWeight: FontWeight.w400,
        //                               fontSize: FontDimen.dimen11,
        //                             ),
        //                           ),
        //                         ],
        //                       ),
        //                       const SizedBox(height: 2),
        //                       Text(
        //                         reply.text,
        //                         style: TextStyle(
        //                           color: AppColors.textColor3,
        //                           fontFamily: AppFonts.appFont,
        //                           fontWeight: FontWeight.w400,
        //                           fontSize: FontDimen.dimen12,
        //                         ),
        //                       ),
        //                     ],
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           )
        //           .toList(),
        //     ),
        //   ),
      ],
    );
  }
}

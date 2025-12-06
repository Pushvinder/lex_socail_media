// // widgets/message_bubble.dart
//
// import 'package:flutter/material.dart';
// import 'package:visibility_detector/visibility_detector.dart';
//
// import '../lazy_image_widget.dart';
// import '../models/message_model.dart';
// import 'video_thumbnail_widget.dart';
// import 'audio_message_widget.dart';
// import 'document_message_widget.dart';
//
// /// Main message bubble widget that handles all message types
// class MessageBubble extends StatelessWidget {
//   final MessageModel message;
//   final bool isSentByMe;
//   final VoidCallback? onTap;
//   final VoidCallback? onLongPress;
//   final VoidCallback? onImageTap;
//   final VoidCallback? onVideoTap;
//   final VoidCallback? onReplyTap;
//   final Function(String messageId, MessageModel message)? onVisible;
//   final Function(String messageId)? onInvisible;
//   final bool showStatus;
//   final bool showTime;
//
//   const MessageBubble({
//     Key? key,
//     required this.message,
//     required this.isSentByMe,
//     this.onTap,
//     this.onLongPress,
//     this.onImageTap,
//     this.onVideoTap,
//     this.onReplyTap,
//     this.onVisible,
//     this.onInvisible,
//     this.showStatus = true,
//     this.showTime = true,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     if (message.isDeleted) {
//       return _buildDeletedMessage(context);
//     }
//
//     return VisibilityDetector(
//       key: Key('message_${message.messageId}'),
//       onVisibilityChanged: (info) {
//         if (info.visibleFraction > 0.5) {
//           onVisible?.call(message.messageId, message);
//         } else if (info.visibleFraction < 0.1) {
//           onInvisible?.call(message.messageId);
//         }
//       },
//       child: Padding(
//         padding: EdgeInsets.only(
//           left: isSentByMe ? 60 : 12,
//           right: isSentByMe ? 12 : 60,
//           top: 4,
//           bottom: 4,
//         ),
//         child: Row(
//           mainAxisAlignment: isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Flexible(
//               child: GestureDetector(
//                 onLongPress: onLongPress,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: isSentByMe ? Theme.of(context).primaryColor : Colors.grey[200],
//                     borderRadius: BorderRadius.only(
//                       topLeft: const Radius.circular(16),
//                       topRight: const Radius.circular(16),
//                       bottomLeft: Radius.circular(isSentByMe ? 16 : 4),
//                       bottomRight: Radius.circular(isSentByMe ? 4 : 16),
//                     ),
//                   ),
//                   clipBehavior: Clip.antiAlias,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       if (message.replyToMessage != null) _buildReplyPreview(context),
//                       _buildMessageContent(context),
//                       if (showTime) _buildTimeAndStatus(context),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDeletedMessage(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(
//         left: isSentByMe ? 60 : 12,
//         right: isSentByMe ? 12 : 60,
//         top: 4,
//         bottom: 4,
//       ),
//       child: Row(
//         mainAxisAlignment: isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             decoration: BoxDecoration(
//               color: Colors.grey[300],
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(Icons.block_rounded, size: 16, color: Colors.grey[600]),
//                 const SizedBox(width: 6),
//                 Text(
//                   'Message deleted',
//                   style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic, fontSize: 13),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildReplyPreview(BuildContext context) {
//     final reply = message.replyToMessage!;
//     final replyType = reply['type'] as String? ?? 'text';
//     final replyContent = reply['content'] as String? ?? '';
//     final replySender = reply['senderName'] as String? ?? '';
//
//     String previewText;
//     IconData? previewIcon;
//
//     switch (replyType) {
//       case 'image':
//         previewText = '📷 Photo';
//         previewIcon = Icons.image_rounded;
//         break;
//       case 'video':
//         previewText = '🎬 Video';
//         previewIcon = Icons.videocam_rounded;
//         break;
//       case 'audio':
//       case 'voiceNote':
//         previewText = '🎵 Audio';
//         previewIcon = Icons.mic_rounded;
//         break;
//       case 'document':
//         previewText = '📄 Document';
//         previewIcon = Icons.description_rounded;
//         break;
//       default:
//         previewText = replyContent;
//     }
//
//     return GestureDetector(
//       onTap: onReplyTap,
//       child: Container(
//         margin: const EdgeInsets.all(6),
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: isSentByMe ? Colors.white.withOpacity(0.15) : Colors.grey.withOpacity(0.2),
//           borderRadius: BorderRadius.circular(8),
//           border: Border(
//             left: BorderSide(
//               color: isSentByMe ? Colors.white70 : Theme.of(context).primaryColor,
//               width: 3,
//             ),
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               replySender,
//               style: TextStyle(
//                 color: isSentByMe ? Colors.white : Theme.of(context).primaryColor,
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 2),
//             Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 if (previewIcon != null) ...[
//                   Icon(previewIcon, size: 14, color: isSentByMe ? Colors.white70 : Colors.grey),
//                   const SizedBox(width: 4),
//                 ],
//                 Flexible(
//                   child: Text(
//                     previewText,
//                     style: TextStyle(color: isSentByMe ? Colors.white70 : Colors.grey[700], fontSize: 12),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMessageContent(BuildContext context) {
//     switch (message.type) {
//       case MessageType.text:
//         return _buildTextContent(context);
//       case MessageType.image:
//         return _buildImageContent(context);
//       case MessageType.video:
//         return _buildVideoContent(context);
//       case MessageType.audio:
//         return _buildAudioContent(context);
//       case MessageType.voiceNote:
//         return _buildVoiceNoteContent(context);
//       case MessageType.document:
//         return _buildDocumentContent(context);
//     }
//   }
//
//   Widget _buildTextContent(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 4),
//       child: Text(
//         message.content,
//         style: TextStyle(color: isSentByMe ? Colors.white : Colors.black87, fontSize: 15),
//       ),
//     );
//   }
//
//   Widget _buildImageContent(BuildContext context) {
//     return MessageImageWidget(
//       imageUrl: message.content,
//       localPath: message.localFilePath,
//       width: message.mediaWidth,
//       height: message.mediaHeight,
//       onTap: onImageTap,
//       onLongPress: onLongPress,
//     );
//   }
//
//   Widget _buildVideoContent(BuildContext context) {
//     return VideoThumbnailWidget(
//       videoUrl: message.content,
//       thumbnailUrl: message.thumbnailUrl,
//       localPath: message.localFilePath,
//       width: message.mediaWidth,
//       height: message.mediaHeight,
//       duration: message.mediaDuration,
//       onTap: onVideoTap,
//       onLongPress: onLongPress,
//     );
//   }
//
//   Widget _buildAudioContent(BuildContext context) {
//     return AudioMessageWidget(
//       audioUrl: message.content,
//       messageId: message.messageId,
//       duration: message.mediaDuration,
//       isSentByMe: isSentByMe,
//       onLongPress: onLongPress,
//     );
//   }
//
//   Widget _buildVoiceNoteContent(BuildContext context) {
//     return VoiceNoteWidget(
//       audioUrl: message.content,
//       messageId: message.messageId,
//       duration: message.mediaDuration,
//       isSentByMe: isSentByMe,
//       onLongPress: onLongPress,
//     );
//   }
//
//   Widget _buildDocumentContent(BuildContext context) {
//     return DocumentMessageWidget(
//       documentUrl: message.content,
//       fileName: message.fileName,
//       fileExtension: message.fileExtension,
//       fileSize: message.fileSize,
//       isSentByMe: isSentByMe,
//       onLongPress: onLongPress,
//     );
//   }
//
//   Widget _buildTimeAndStatus(BuildContext context) {
//     final timeText = _formatTime(message.timestamp);
//     final statusColor = isSentByMe ? Colors.white70 : Colors.grey;
//
//     return Padding(
//       padding: const EdgeInsets.only(left: 12, right: 8, bottom: 6, top: 2),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(timeText, style: TextStyle(color: statusColor, fontSize: 11)),
//           if (showStatus && isSentByMe) ...[
//             const SizedBox(width: 4),
//             _buildStatusIcon(statusColor),
//           ],
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatusIcon(Color color) {
//     switch (message.status) {
//       case MessageStatus.sending:
//         return SizedBox(
//           width: 12,
//           height: 12,
//           child: CircularProgressIndicator(strokeWidth: 1.5, valueColor: AlwaysStoppedAnimation(color)),
//         );
//       case MessageStatus.sent:
//         return Icon(Icons.check, size: 14, color: color);
//       case MessageStatus.delivered:
//         return Icon(Icons.done_all, size: 14, color: color);
//       case MessageStatus.seen:
//         return Icon(Icons.done_all, size: 14, color: Colors.blue[300]);
//       case MessageStatus.failed:
//         return Icon(Icons.error_outline, size: 14, color: Colors.red[300]);
//     }
//   }
//
//   String _formatTime(DateTime time) {
//     final hour = time.hour.toString().padLeft(2, '0');
//     final minute = time.minute.toString().padLeft(2, '0');
//     return '$hour:$minute';
//   }
// }
//
// class DateSeparator extends StatelessWidget {
//   final DateTime date;
//
//   const DateSeparator({Key? key, required this.date}) : super(key: key);
//
//   String _formatDate(DateTime date) {
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     final yesterday = today.subtract(const Duration(days: 1));
//     final messageDate = DateTime(date.year, date.month, date.day);
//
//     if (messageDate == today) {
//       return 'Today';
//     } else if (messageDate == yesterday) {
//       return 'Yesterday';
//     } else if (now.difference(date).inDays < 7) {
//       final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
//       return weekdays[date.weekday - 1];
//     } else {
//       return '${date.day}/${date.month}/${date.year}';
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 16),
//       child: Center(
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//           decoration: BoxDecoration(
//             color: Colors.grey[300],
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Text(
//             _formatDate(date),
//             style: TextStyle(color: Colors.grey[700], fontSize: 12, fontWeight: FontWeight.w500),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class TypingIndicator extends StatefulWidget {
//   final String userName;
//
//   const TypingIndicator({Key? key, required this.userName}) : super(key: key);
//
//   @override
//   State<TypingIndicator> createState() => _TypingIndicatorState();
// }
//
// class _TypingIndicatorState extends State<TypingIndicator> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 1500),
//       vsync: this,
//     )..repeat();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 12, bottom: 8),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//             decoration: BoxDecoration(
//               color: Colors.grey[200],
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: List.generate(3, (index) {
//                 return AnimatedBuilder(
//                   animation: _controller,
//                   builder: (context, child) {
//                     final delay = index * 0.2;
//                     final value = (_controller.value + delay) % 1.0;
//                     final offset = (value < 0.5 ? value : 1.0 - value) * 6;
//                     return Container(
//                       margin: const EdgeInsets.symmetric(horizontal: 2),
//                       child: Transform.translate(
//                         offset: Offset(0, -offset),
//                         child: Container(
//                           width: 8,
//                           height: 8,
//                           decoration: BoxDecoration(
//                             color: Colors.grey[500],
//                             shape: BoxShape.circle,
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               }),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
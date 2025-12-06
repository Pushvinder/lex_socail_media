// widgets/media_options_sheet.dart

import 'package:flutter/material.dart';
import 'file_download_service.dart';

/// Bottom sheet for media long-press options
class MediaOptionsSheet extends StatelessWidget {
  final String mediaUrl;
  final String mediaType;
  final String? fileName;
  final VoidCallback? onDownload;
  final VoidCallback? onShare;
  final VoidCallback? onReply;
  final VoidCallback? onForward;
  final VoidCallback? onDelete;
  final bool canDelete;

  const MediaOptionsSheet({
    Key? key,
    required this.mediaUrl,
    required this.mediaType,
    this.fileName,
    this.onDownload,
    this.onShare,
    this.onReply,
    this.onForward,
    this.onDelete,
    this.canDelete = false,
  }) : super(key: key);

  static Future<void> show(
      BuildContext context, {
        required String mediaUrl,
        required String mediaType,
        String? fileName,
        VoidCallback? onDownload,
        VoidCallback? onShare,
        VoidCallback? onReply,
        VoidCallback? onForward,
        VoidCallback? onDelete,
        bool canDelete = false,
      }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => MediaOptionsSheet(
        mediaUrl: mediaUrl,
        mediaType: mediaType,
        fileName: fileName,
        onDownload: onDownload,
        onShare: onShare,
        onReply: onReply,
        onForward: onForward,
        onDelete: onDelete,
        canDelete: canDelete,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: 20),

            _buildOption(
              context,
              icon: Icons.reply_rounded,
              title: 'Reply',
              onTap: () {
                Navigator.pop(context);
                onReply?.call();
              },
            ),

            _buildOption(
              context,
              icon: Icons.download_rounded,
              title: _getDownloadTitle(),
              onTap: () {
                Navigator.pop(context);
                _handleDownload(context);
              },
            ),

            _buildOption(
              context,
              icon: Icons.share_rounded,
              title: 'Share',
              onTap: () {
                Navigator.pop(context);
                onShare?.call();
              },
            ),

            _buildOption(
              context,
              icon: Icons.forward_rounded,
              title: 'Forward',
              onTap: () {
                Navigator.pop(context);
                onForward?.call();
              },
            ),

            if (canDelete) ...[
              const Divider(height: 1),
              _buildOption(
                context,
                icon: Icons.delete_rounded,
                title: 'Delete',
                color: Colors.red,
                onTap: () {
                  Navigator.pop(context);
                  onDelete?.call();
                },
              ),
            ],

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap,
        Color? color,
      }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 24, color: color ?? Colors.grey[700]),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(fontSize: 16, color: color ?? Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  String _getDownloadTitle() {
    switch (mediaType) {
      case 'image':
        return 'Save to Gallery';
      case 'video':
        return 'Save Video';
      case 'audio':
        return 'Save Audio';
      case 'document':
        return 'Download File';
      default:
        return 'Download';
    }
  }

  Future<void> _handleDownload(BuildContext context) async {
    if (onDownload != null) {
      onDownload!();
      return;
    }

    final downloadService = FileDownloadService();
    DownloadResult result;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      switch (mediaType) {
        case 'image':
          result = await downloadService.downloadImageToGallery(mediaUrl);
          break;
        case 'video':
          result = await downloadService.downloadVideoToGallery(mediaUrl);
          break;
        default:
          result = await downloadService.downloadDocument(mediaUrl, fileName: fileName);
      }

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message), behavior: SnackBarBehavior.floating),
      );
    } catch (e) {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Download failed: $e'), behavior: SnackBarBehavior.floating),
      );
    }
  }
}

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final Color? confirmColor;
  final VoidCallback? onConfirm;

  const ConfirmationDialog({
    Key? key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.confirmColor,
    this.onConfirm,
  }) : super(key: key);

  static Future<bool?> show(
      BuildContext context, {
        required String title,
        required String message,
        String confirmText = 'Confirm',
        String cancelText = 'Cancel',
        Color? confirmColor,
      }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        confirmColor: confirmColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(cancelText, style: TextStyle(color: Colors.grey[600])),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(confirmText, style: TextStyle(color: confirmColor ?? Theme.of(context).primaryColor)),
        ),
      ],
    );
  }
}
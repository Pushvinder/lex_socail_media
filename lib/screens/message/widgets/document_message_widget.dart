// widgets/document_message_widget.dart

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'file_download_service.dart';
import 'media_cache_service.dart';

/// Widget for displaying document messages
class DocumentMessageWidget extends StatefulWidget {
  final String documentUrl;
  final String? fileName;
  final String? fileExtension;
  final int? fileSize;
  final bool isSentByMe;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const DocumentMessageWidget({
    Key? key,
    required this.documentUrl,
    this.fileName,
    this.fileExtension,
    this.fileSize,
    this.isSentByMe = false,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  State<DocumentMessageWidget> createState() => _DocumentMessageWidgetState();
}

class _DocumentMessageWidgetState extends State<DocumentMessageWidget> {
  final MediaCacheService _cacheService = MediaCacheService();
  final FileDownloadService _downloadService = FileDownloadService();

  bool _isCached = false;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    _checkCache();
  }

  Future<void> _checkCache() async {
    _isCached = await _cacheService.isCached(
      widget.documentUrl,
      type: MediaCacheType.document,
    );
    if (mounted) setState(() {});
  }

  String get _displayFileName {
    if (widget.fileName != null) return widget.fileName!;
    try {
      return path.basename(Uri.parse(widget.documentUrl).path);
    } catch (e) {
      return 'Document';
    }
  }

  String get _displayExtension {
    if (widget.fileExtension != null) return widget.fileExtension!.toUpperCase();
    try {
      return path.extension(_displayFileName).replaceFirst('.', '').toUpperCase();
    } catch (e) {
      return '';
    }
  }

  String get _displayFileSize {
    if (widget.fileSize == null) return '';
    final bytes = widget.fileSize!;
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  IconData get _fileIcon {
    final ext = _displayExtension.toLowerCase();
    switch (ext) {
      case 'pdf':
        return Icons.picture_as_pdf_rounded;
      case 'doc':
      case 'docx':
        return Icons.description_rounded;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart_rounded;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow_rounded;
      case 'zip':
      case 'rar':
      case '7z':
        return Icons.folder_zip_rounded;
      case 'txt':
        return Icons.article_rounded;
      default:
        return Icons.insert_drive_file_rounded;
    }
  }

  Color get _fileIconColor {
    final ext = _displayExtension.toLowerCase();
    switch (ext) {
      case 'pdf':
        return Colors.red;
      case 'doc':
      case 'docx':
        return Colors.blue;
      case 'xls':
      case 'xlsx':
        return Colors.green;
      case 'ppt':
      case 'pptx':
        return Colors.orange;
      case 'zip':
      case 'rar':
      case '7z':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  Future<void> _openDocument() async {
    if (_isDownloading) return;

    setState(() {
      _isDownloading = true;
    });

    try {
      final success = await _downloadService.openFile(
        widget.documentUrl,
        type: MediaCacheType.document,
      );

      if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to open file')),
        );
      }

      _isCached = await _cacheService.isCached(
        widget.documentUrl,
        type: MediaCacheType.document,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.isSentByMe
        ? Colors.white.withOpacity(0.15)
        : Colors.grey.withOpacity(0.15);
    final textColor = widget.isSentByMe ? Colors.white : Colors.black87;
    final subtitleColor = widget.isSentByMe ? Colors.white70 : Colors.black54;

    return GestureDetector(
      onTap: widget.onTap ?? _openDocument,
      onLongPress: widget.onLongPress,
      child: Container(
        width: 220,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _fileIconColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _isDownloading
                  ? Padding(
                padding: const EdgeInsets.all(10),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(_fileIconColor),
                ),
              )
                  : Icon(
                _fileIcon,
                color: _fileIconColor,
                size: 24,
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _displayFileName,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      if (_displayExtension.isNotEmpty)
                        Text(
                          _displayExtension,
                          style: TextStyle(color: subtitleColor, fontSize: 11),
                        ),
                      if (_displayExtension.isNotEmpty && _displayFileSize.isNotEmpty)
                        Text(' • ', style: TextStyle(color: subtitleColor, fontSize: 11)),
                      if (_displayFileSize.isNotEmpty)
                        Text(_displayFileSize, style: TextStyle(color: subtitleColor, fontSize: 11)),
                      if (_isCached)
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Icon(Icons.download_done_rounded, color: subtitleColor, size: 12),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            Icon(
              _isCached ? Icons.open_in_new_rounded : Icons.download_rounded,
              color: subtitleColor,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
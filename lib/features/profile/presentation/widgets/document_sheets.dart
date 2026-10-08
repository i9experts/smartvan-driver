import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../l10n/l10n.dart';

enum DocumentAction { view, change, remove }

/// What to do with a document that is already uploaded.
Future<DocumentAction?> showDocumentActionsSheet(
    BuildContext context, String title) {
  final l10n = context.l10n;
  return showModalBottomSheet<DocumentAction>(
    context: context,
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SheetTitle(title),
          ListTile(
            leading: const Icon(Icons.visibility_outlined),
            title: Text(l10n.documentsView),
            onTap: () => Navigator.pop(ctx, DocumentAction.view),
          ),
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: Text(l10n.documentsChange),
            onTap: () => Navigator.pop(ctx, DocumentAction.change),
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: Color(0xFFE53935)),
            title: Text(l10n.documentsRemove,
                style: const TextStyle(color: Color(0xFFE53935))),
            onTap: () => Navigator.pop(ctx, DocumentAction.remove),
          ),
        ],
      ),
    ),
  );
}

/// Camera or gallery.
Future<ImageSource?> showImageSourceSheet(BuildContext context, String title) {
  final l10n = context.l10n;
  return showModalBottomSheet<ImageSource>(
    context: context,
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SheetTitle(title),
          ListTile(
            leading: const Icon(Icons.photo_camera_outlined),
            title: Text(l10n.documentsTakePhoto),
            onTap: () => Navigator.pop(ctx, ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library_outlined),
            title: Text(l10n.documentsChooseGallery),
            onTap: () => Navigator.pop(ctx, ImageSource.gallery),
          ),
        ],
      ),
    ),
  );
}

/// "Remove Driving License?" — true when confirmed.
Future<bool> confirmRemoveDocument(BuildContext context, String name) async {
  final l10n = context.l10n;
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.documentsRemoveTitle(name)),
      content: Text(l10n.documentsRemoveBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(l10n.commonCancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(l10n.documentsRemove,
              style: const TextStyle(color: Color(0xFFE53935))),
        ),
      ],
    ),
  );
  return ok == true;
}

class _SheetTitle extends StatelessWidget {
  const _SheetTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(title,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E),
                  fontFamily: 'Poppins')),
        ),
      );
}

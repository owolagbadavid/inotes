import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:inotes/services/crud/notes_service.dart';
import 'package:inotes/utils/dialogs/delete_dialog.dart';

typedef DeleteNoteCallback = void Function(DataBaseNote note);

class NotesListView extends StatefulWidget {
  final List<DataBaseNote> notes;
  final DeleteNoteCallback onDelete;
  final List<SlidableController> controllers;

  const NotesListView({
    super.key,
    required this.notes,
    required this.onDelete,
    required this.controllers,
  });

  @override
  State<NotesListView> createState() => _NotesListViewState();
}

class _NotesListViewState extends State<NotesListView> {
  SlidableController? _activeController;

  GlobalKey? _activeSlidableKey;

  bool _isPointInsideActiveSlidable(Offset position) {
    if (_activeSlidableKey == null) return false;

    final RenderBox? slidableBox =
        _activeSlidableKey!.currentContext?.findRenderObject() as RenderBox?;
    if (slidableBox == null) return false;

    final Offset slidablePosition = slidableBox.localToGlobal(Offset.zero);

    final Size slidableSize = slidableBox.size;

    // Check if the tapped position is within the bounds of the active Slidable
    return position.dx >= slidablePosition.dx &&
        position.dx <= slidablePosition.dx + slidableSize.width &&
        position.dy >= slidablePosition.dy &&
        position.dy <= slidablePosition.dy + slidableSize.height;
  }

  @override
  Widget build(BuildContext context) {
    List<GlobalKey> slidableKeys = List.generate(
      widget.controllers.length,
      (index) => GlobalKey(),
    );

    return GestureDetector(
      onVerticalDragDown: (details) {
        final Offset localPosition = details.globalPosition;

        // Close the active Slidable if the tap is outside its area
        if (_activeSlidableKey != null &&
            !_isPointInsideActiveSlidable(localPosition)) {
          _activeController!.close();
          _activeController = null; // Reset after closing
          _activeSlidableKey = null;
        }
      },
      child: ListView(children: [
        Card(
          margin: const EdgeInsets.all(8.0), // Space around the card
          color:
              const Color.fromARGB(255, 195, 193, 193), // Light grey background
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(
          //       12.0), // Rounded corners
          // ),
          child: ListView.separated(
            // padding: EdgeInsets.zero,
            shrinkWrap: true, // To prevent infinite height error
            // physics: const ClampingScrollPhysics(),
            itemCount: widget.notes.length,
            itemBuilder: (context, index) {
              int i;
              final note = widget.notes[index];
              final controller = widget.controllers[index];
              controller.actionPaneType.addListener(
                () {
                  if (controller.actionPaneType.value != ActionPaneType.none) {
                    _activeController = controller;
                    _activeSlidableKey = slidableKeys[index];
                  } else if (controller.actionPaneType.value ==
                          ActionPaneType.none &&
                      controller == _activeController) {
                    _activeController = null;
                    _activeSlidableKey = null;
                  }
                },
              );

              return Slidable(
                controller: controller,
                key: slidableKeys[index],
                endActionPane: ActionPane(
                  extentRatio: 0.5,
                  // A motion is a widget used to control how the pane animates.
                  motion: const StretchMotion(),

                  // A pane can dismiss the Slidable.
                  dismissible: DismissiblePane(
                      // closeOnCancel: true,
                      confirmDismiss: () async {
                        controller.openTo(-0.5);
                        return false;
                      },
                      onDismissed: () {}),

                  // All actions are defined in the children parameter.
                  children: [
                    // A SlidableAction can have an icon and/or a label.

                    SlidableAction(
                      autoClose: false,
                      onPressed: (_) async {
                        controller.openTo(-1);

                        final shouldDelete = await showDeleteDialog(context);

                        if (shouldDelete) {
                          await controller.dismiss(ResizeRequest(
                              const Duration(milliseconds: 150), () {
                            widget.onDelete(note);

                            // setState(() {
                            _activeController = null;
                            _activeSlidableKey = null;
                            // });
                          }));
                        } else {
                          await controller.close();
                        }
                      }, // Dismisses the Slidable.

                      backgroundColor: const Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                child: CupertinoListTile(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 10), // Adjust these values as needed
                  // contentPadding:
                  title: Text(note.text,
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                  subtitle: Text(
                      (i = note.text.indexOf('\n')) == -1
                          ? 'No additional text'
                          : note.text.substring(i + 1),
                      maxLines: 1),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const Divider(
                indent: 15,
                height: 1,
                color: Colors.grey, // Customize the color
                thickness: 1.0, // Customize the thickness
              );
            },
          ),
        ),
      ]),
    );
  }
}

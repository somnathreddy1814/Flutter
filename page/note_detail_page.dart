import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite_database_example/db/notes_database.dart';
import 'package:sqflite_database_example/model/note.dart';
import 'package:sqflite_database_example/page/edit_note_page.dart';
import 'dart:async';

class NoteDetailPage extends StatefulWidget {
  final int noteId;

  const NoteDetailPage({
    Key? key,
    required this.noteId,
  }) : super(key: key);

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late Note note;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNote();
  }

  Future<void> refreshNote() async {
    setState(() => isLoading = true);

    this.note = await NotesDatabase.instance.readNote(widget.noteId);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [editButton(), deleteButton()],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : buildNoteDetails(),
    );
  }

  Widget buildNoteDetails() {
    if (note != null) {
      return Padding(
        padding: EdgeInsets.all(12),
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 8),
          children: [
            Text(
              note.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 8),
            Text(
              DateFormat('EEEE, MMM d, yyyy, hh:mm a').format(note.createdTime),
              style: TextStyle(color: Colors.grey[300]),
            ),
            SizedBox(height: 8),
            Text(
              note.description,
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: Text(
          'No note available',
          style: TextStyle(color: Colors.white),
        ),
      );
    }
  }

  Widget editButton() {
    return IconButton(
      icon: Icon(Icons.edit_outlined),
      onPressed: () async {
        if (isLoading) return;

        await navigateToAddEditNotePage(context, note);

        refreshNote();
      },
    );
  }

  Widget deleteButton() {
    return GestureDetector(
      onLongPress: () {
        startDeleteTimer();
      },
      onLongPressEnd: (_) {
        stopDeleteTimer();
      },
      child: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async {
          bool? deleteConfirmed = await showConfirmationDialog();
          if (deleteConfirmed ?? false) {
            await NotesDatabase.instance.delete(widget.noteId);
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }

  bool isDeleting = false;
  Timer? deleteTimer;

  void startDeleteTimer() {
    isDeleting = true;
    deleteTimer = Timer(Duration(seconds: 3), () {
      if (isDeleting) {
        // Perform the delete action
        deleteItem();
      }
      stopDeleteTimer();
    });
  }

  void stopDeleteTimer() {
    isDeleting = false;
    deleteTimer?.cancel();
  }

  void deleteItem() async {
    await NotesDatabase.instance.delete(widget.noteId);
    Navigator.of(context).pop();
  }

  Future<bool?> showConfirmationDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Confirmation'),
        content: Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: Text('Delete'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      ),
    );
  }

  Future<void> navigateToAddEditNotePage(BuildContext context, Note note) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddEditNotePage(note: note),
      ),
    );
  }
}

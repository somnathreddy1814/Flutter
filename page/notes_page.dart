import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sqflite_database_example/db/notes_database.dart';
import 'package:sqflite_database_example/model/note.dart';
import 'package:sqflite_database_example/page/edit_note_page.dart';
import 'package:sqflite_database_example/page/note_detail_page.dart';
import 'package:sqflite_database_example/widget/note_card_widget.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late List<Note> notes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNotes();
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();

    super.dispose();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    this.notes = await NotesDatabase.instance.readAllNotes();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black87,
    appBar: AppBar(
      centerTitle: true,
      title: Text(
        'Diary Daze',
        style: TextStyle(fontSize: 24),
      ),

    ),
    body: Center(
      child: () {
        if (isLoading) {
          return CircularProgressIndicator();  // If isLoading is true, show a CircularProgressIndicator.
        } else if (notes.isEmpty) {
          return Text(
            'No Notes',  // If notes list is empty, show a "No Notes" message.
            style: TextStyle(color: Colors.white, fontSize: 24),
          );
        } else {
          return buildNotes();  // Otherwise, call the buildNotes() method to display the notes.
        }
      }(),
    ),

    floatingActionButton: FloatingActionButton(
      backgroundColor: Colors.blueGrey,
      child: Icon(Icons.add),
      onPressed: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => AddEditNotePage()),
        );
        refreshNotes();
      },
    ),
  );

  Widget buildNotes() {
    return StaggeredGridView.countBuilder(
      padding: EdgeInsets.all(12),
      itemCount: notes.length,
      crossAxisCount: 4,
      mainAxisSpacing: 2,
      crossAxisSpacing: 2,
      itemBuilder: (context, index) {
        final note = notes[index];

        return GestureDetector(
          onTap: () async {
            await navigateToNoteDetailPage(context, note.id!);
            refreshNotes();
          },
          child: NoteCardWidget(note: note, index: index),
        );
      },
      staggeredTileBuilder: (index) {
        return StaggeredTile.fit(4);
      },
    );
  }

  Future<void> navigateToNoteDetailPage(BuildContext context, int noteId) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NoteDetailPage(noteId: noteId),
      ),
    );
  }

}
import 'package:flutter/material.dart';
import 'package:rick_and_morty_app/models/character.dart';

class CharacterDetails extends StatelessWidget {
  const CharacterDetails({Key? key, required this.character}) : super(key: key);

  final Character character;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(character.name),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(character.image),
              onBackgroundImageError: (exception, strackrace) {
                debugPrint(exception.toString());
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: const Text('Género'),
                trailing: Text(character.gender),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Estado'),
                trailing: Text(character.status),
              ),
            ),
            if (character.type != null && character.type != '')
              Card(
                child: ListTile(
                  title: const Text('Tipo'),
                  trailing: Text(character.type!),
                ),
              ),
            Card(
              child: ListTile(
                title: const Text('Origen'),
                trailing: Text(character.origin.name),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Ubicación'),
                trailing: Text(character.location.name),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

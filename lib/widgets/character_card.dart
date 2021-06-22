import 'package:flutter/material.dart';
import 'package:rick_and_morty_app/models/character.dart';
import 'package:rick_and_morty_app/pages/character_details.dart';

class CharacterCard extends StatelessWidget {
  const CharacterCard({
    Key? key,
    required this.character,
  }) : super(key: key);
  final Character character;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(character.image),
          onBackgroundImageError: (exception, strackrace) {
            debugPrint(exception.toString());
          },
        ),
        title: Text(character.name),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CharacterDetails(
                character: character,
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination_view/pagination_view.dart';
import 'package:rick_and_morty_app/cubits/cubit/characters_cubit.dart';
import 'package:rick_and_morty_app/models/character.dart';
import 'package:rick_and_morty_app/pages/character_details.dart';

class ItemsList extends StatefulWidget {
  const ItemsList({Key? key}) : super(key: key);

  @override
  _ItemsListState createState() => _ItemsListState();
}

class _ItemsListState extends State<ItemsList> {
  @override
  Widget build(BuildContext context) {
    int page = 1;
    return BlocProvider<CharactersCubit>(
      create: (context) => CharactersCubit()..fetchInitialCharacters(),
      child: BlocBuilder<CharactersCubit, CharactersState>(
          builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Personajes'),
            centerTitle: true,
          ),
          body: (state is CharactersLoaded)
              ? PaginationView<Character>(
                  itemBuilder: (context, character, index) {
                    return ListTile(
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
                    );
                  },
                  preloadedItems: state.characters,
                  pageFetch: (offset) {
                    page++;
                    return BlocProvider.of<CharactersCubit>(context)
                        .fetchCharacters(page: page);
                  },
                  pullToRefresh: true,
                  onError: (e) {
                    if (e is SocketException) {
                      return const ErrorMessage(
                          message: 'No hay conexión a internet');
                    }
                    return ErrorMessage(message: e.toString());
                  },
                  onEmpty: const Center(
                    child: Text('La lista está vacía'),
                  ),
                  bottomLoader: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  initialLoader: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : (state is CharactersError)
                  ? ErrorMessage(message: state.message)
                  : const Center(
                      child: CircularProgressIndicator(strokeWidth: 2)),
        );
      }),
    );
  }
}

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({
    Key? key,
    required this.message,
  }) : super(key: key);
  final String message;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message),
            ElevatedButton(
              onPressed: () => BlocProvider.of<CharactersCubit>(context)
                  .fetchInitialCharacters(),
              child: const Text('Recargar'),
            ),
          ],
        ),
      ),
    );
  }
}

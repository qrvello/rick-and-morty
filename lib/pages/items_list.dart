import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination_view/pagination_view.dart';
import 'package:rick_and_morty_app/cubits/cubit/characters_cubit.dart';
import 'package:rick_and_morty_app/models/character.dart';
import 'package:rick_and_morty_app/widgets/character_card.dart';
import 'package:rick_and_morty_app/widgets/error_message.dart';
import 'package:search_page/search_page.dart';

class ItemsList extends StatefulWidget {
  const ItemsList({Key? key}) : super(key: key);

  @override
  _ItemsListState createState() => _ItemsListState();
}

class _ItemsListState extends State<ItemsList> {
  static List<Character> characters = [];

  @override
  Widget build(BuildContext context) {
    int page = 1;
    return BlocProvider<CharactersCubit>(
      create: (context) => CharactersCubit()..fetchInitialCharacters(),
      child: BlocBuilder<CharactersCubit, CharactersState>(
          builder: (context, state) {
        if (state is CharactersLoaded) {
          characters.addAll(state.characters);
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Personajes'),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  // Remueve duplicados
                  characters = characters.toSet().toList();

                  showSearch(
                    context: context,
                    delegate: SearchPage<Character>(
                      items: characters,
                      searchLabel: 'Buscá personajes',
                      suggestion: const Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Center(
                          child: Text(
                            'Filtrá personajes por nombre, estado, especie, tipo, género, planeta de origen o ubicación actual',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      failure: const Center(
                        child: Text('No se encontró ningún personaje'),
                      ),
                      filter: (character) => [
                        character.id.toString(),
                        character.name,
                        character.status,
                        character.species,
                        character.type,
                        character.gender,
                        character.origin.name,
                        character.location.name,
                      ],
                      builder: (character) =>
                          CharacterCard(character: character),
                    ),
                  );
                },
                icon: const Icon(Icons.search),
              ),
            ],
          ),
          body: (state is CharactersLoaded)
              ? PaginationView<Character>(
                  itemBuilder: (context, character, index) {
                    return CharacterCard(
                      character: character,
                    );
                  },
                  preloadedItems: state.characters,
                  pageFetch: (offset) async {
                    page++;

                    final List<Character> _characters =
                        await BlocProvider.of<CharactersCubit>(context)
                            .fetchCharacters(page: page);

                    characters.addAll(_characters);

                    return _characters;
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

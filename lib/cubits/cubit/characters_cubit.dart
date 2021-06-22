import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:rick_and_morty_app/models/character.dart';
import 'package:rick_and_morty_app/services/api.dart';

part 'characters_state.dart';

class CharactersCubit extends Cubit<CharactersState> {
  CharactersCubit() : super(CharactersInitial());

  final _apiService = ApiService(Client());

  Future<void> fetchInitialCharacters() async {
    final List<Character> characters = [];
    emit(CharactersLoading());

    try {
      final decodedData = await _apiService.getCharacters(1);

      if (decodedData['results'] != null &&
          decodedData['results'] is Map<String, dynamic>) {
        for (final result in decodedData['results']) {
          final Character character =
              Character.fromMap(result as Map<String, dynamic>);
          characters.add(character);
        }
      }
      emit(CharactersLoaded(characters));
    } on SocketException {
      emit(CharactersError('No hay conexión a internet'));
    } catch (e) {
      emit(CharactersError(e.toString()));
    }
  }

  Future<List<Character>> fetchCharacters({int page = 1}) async {
    final List<Character> characters = [];

    try {
      final decodedData = await _apiService.getCharacters(1);

      if (decodedData['results'] != null &&
          decodedData['results'] is Map<String, dynamic>) {
        for (final result in decodedData['results']) {
          final Character character =
              Character.fromMap(result as Map<String, dynamic>);
          characters.add(character);
        }
      } else {
        throw Exception('Ocurrió un error');
      }

      return characters;
    } catch (e) {
      rethrow;
    }
  }
}

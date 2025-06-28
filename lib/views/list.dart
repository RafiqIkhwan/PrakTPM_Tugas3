import 'package:flutter/material.dart';
import '../presenters/anime_presenter.dart';
import '../models/anime_model.dart';
import '../models/character_model.dart' as model;
import 'anime_detail.dart';

class AnimeListScreen extends StatefulWidget {
  const AnimeListScreen({super.key});

  @override
  State<AnimeListScreen> createState() => _AnimeListScreenState();
}

class _AnimeListScreenState extends State<AnimeListScreen>
    implements AnimeView {
  late AnimePresenter _presenter;
  bool _isLoading = false;
  List<Anime> _animeList = [];
  List<model.Characters> _charactersList = [];
  String? _errorMessage;
  String _currentEndpoint = 'akatsuki';

  @override
  void initState() {
    super.initState();
    _presenter = AnimePresenter(this);
    _presenter.loadAnimeData(_currentEndpoint);
  }

  void fetchData(String endpoint) {
    setState(() {
      _currentEndpoint = endpoint;
      _presenter.loadAnimeData(_currentEndpoint); //endpoint
    });
  }

  @override
  void hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void showAnimeList(List<Anime> animeList) {
    setState(() {
      _animeList = animeList;
    });
  }

  @override
  void showCharactersList(List<model.Characters> charactersList) {
    setState(() {
      _charactersList = charactersList;
    });
  }

  @override
  void showError(String message) {
    setState(() {
      _errorMessage = message;
    });
  }

  @override
  void showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Naruto Universe List")),
      body: Column(
        children: [
          Expanded(
            child:
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : _errorMessage != null
                    ? Center(child: Text(_errorMessage!))
                    : ListView.builder(
                      itemCount:
                          _currentEndpoint == 'characters'
                              ? _charactersList.length
                              : _animeList.length,
                      itemBuilder: (context, index) {
                        //untuk character
                        if (_currentEndpoint == 'characters') {
                          final character = _charactersList[index];
                          return ListTile(
                            leading:
                                character.imageUrl.isNotEmpty
                                    ? Image.network(character.imageUrl)
                                    : Image.network(
                                      'https://placehold.co/600x400',
                                    ),
                            title: Text(character.name),
                            subtitle: Text(
                              "Kekkei Genkai ${character.kekeiGenkai}",
                            ),
                            onTap: () {
                              print("${character.name} tapped");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => DetailScreen(
                                        id: character.id,
                                        endpoint: _currentEndpoint,
                                      ),
                                ),
                              );
                            },
                          );
                        } else {
                          //untuk anime
                          final anime = _animeList[index];
                          return ListTile(
                            leading:
                                anime.imageUrl.isNotEmpty
                                    ? Image.network(anime.imageUrl)
                                    : Image.network(
                                      'https://placehold.co/600x400',
                                    ),
                            title: Text(anime.name),
                            subtitle: Text("Family ${anime.familyCreator}"),
                            onTap: () {
                              print("${anime.name} tapped");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => DetailScreen(
                                        id: anime.id,
                                        endpoint: _currentEndpoint,
                                      ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
          ),
        ],
      ),
    );
  }
}

import '../models/anime_model.dart';
import '../models/character_model.dart' as model;
import '../network/base_network.dart';

abstract class AnimeView {
  void showLoading();
  void hideLoading();
  void showCharactersList(List<model.Characters> charactersList);
  void showAnimeList(List<Anime> animeList);
  void showError(String message);
}

class AnimePresenter {
  final AnimeView view;
  AnimePresenter(this.view);

  Future<void> loadAnimeData(String endpoint) async {
    try {
      final List<dynamic> data = await BaseNetwork.getData(endpoint);
      if (endpoint == 'characters') {
        final charactersList =
            data.map((json) => model.Characters.fromJson(json)).toList();
        view.showCharactersList(charactersList);
      } else {
        final animeList = data.map((json) => Anime.fromJson(json)).toList();
        view.showAnimeList(animeList);
      }
    } catch (e) {
      view.showError(e.toString());
    } finally {
      view.hideLoading();
    }
  }
}

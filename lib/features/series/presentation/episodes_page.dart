import 'package:flutter/material.dart';

import '../../../dat/catalog/catalogo.dart';
import '../../../dat/catalog/catalogo_controller.dart';
import '../../player/media_player.dart';

class EpisodesPage extends StatelessWidget {
  final Video serie;

  const EpisodesPage({super.key, required this.serie});

  @override
  Widget build(BuildContext context) {
    final episodios = [...serie.episodios]
      ..sort((a, b) => a.temporada != b.temporada
          ? a.temporada.compareTo(b.temporada)
          : a.numero.compareTo(b.numero));

    final porTemporada = <int, List<Episodio>>{};
    for (final episodio in episodios) {
      porTemporada.putIfAbsent(episodio.temporada, () => []).add(episodio);
    }

    return Scaffold(
      appBar: AppBar(title: Text(serie.titulo)),
      body: ListView(
        children: [
          for (final MapEntry(key: temporada, value: lista) in porTemporada.entries) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                "Temporada $temporada",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            for (final episodio in lista)
              ListTile(
                leading: Text(
                  "${episodio.numero}",
                  style: const TextStyle(fontSize: 18, color: Colors.white70),
                ),
                title: Text(episodio.titulo),
                trailing: const Icon(Icons.play_arrow),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PlayerPage(
                      videoUri: CatalogController.instance.library.resolve(episodio.videoPath),
                      title: "${serie.titulo} - T${episodio.temporada}E${episodio.numero} - ${episodio.titulo}",
                    ),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

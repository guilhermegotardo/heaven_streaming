import 'package:flutter/material.dart';

import '../../../dat/catalog/catalogo.dart';
import '../../../dat/catalog/catalogo_controller.dart';
import '../../player/media_player.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State <HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  int _currentPage = 0;
  late Future<Catalogo> _catalogoFuture;

  @override
  void initState(){
    super.initState();
    _pageController = PageController();
    _catalogoFuture = CatalogController.instance.loadCatalog();
  }

  @override
  void dispose(){
    _pageController.dispose();
    super.dispose();
  }

  void _retry() {
    setState(() {
      _catalogoFuture = CatalogController.instance.loadCatalog();
    });
  }

  void nextPage(int total) {
    if (_currentPage < total - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Heaven Stream"),
      ),
      body: FutureBuilder<Catalogo>(
        future: _catalogoFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Não foi possível carregar o catálogo."),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _retry,
                    child: const Text("Tentar novamente"),
                  ),
                ],
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return _buildCatalog(snapshot.data!.videos);
        },
      ),
    );
  }

  Widget _buildCatalog(List<Video> videos) {
    if (videos.isEmpty) {
      return const Center(child: Text("Nenhum vídeo no catálogo."));
    }

    return Column(
      children: [

        Expanded(
          child: PageView.builder(
            controller: _pageController,

            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },

            itemCount: videos.length,

            itemBuilder: (context, index) {
              final video = videos[index];
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: _buildPoster(video)),
                    const SizedBox(height: 16),
                    Text(
                      video.titulo,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Pagina ${index + 1}",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 20),

        Text(
          "Página atual: ${_currentPage + 1}",
          style: const TextStyle(fontSize: 20),
        ),

        const SizedBox(height: 20),

        ElevatedButton(
          onPressed: () => nextPage(videos.length),
          child: const Text("Next Page"),
        ),

        ElevatedButton(
          onPressed: () {
            final video = videos[_currentPage];
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PlayerPage(
                  videoUri: CatalogController.instance.library.resolve(video.videoPath),
                  title: video.titulo,
                ),
              ),
            );
          },
          child: const Text('Play'),
        ),

      ],
    );
  }

  Widget _buildPoster(Video video) {
    const placeholder = AspectRatio(
      aspectRatio: 2 / 3,
      child: ColoredBox(
        color: Colors.white10,
        child: Icon(Icons.movie, size: 64, color: Colors.white38),
      ),
    );

    final posterPath = video.posterPath;
    if (posterPath == null || posterPath.isEmpty) return placeholder;

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Image.network(
        CatalogController.instance.library.resolve(posterPath).toString(),
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => placeholder,
      ),
    );
  }

}

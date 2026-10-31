import 'package:flutter/material.dart';

import '../../../dat/catalog/catalog.dart';
import '../../../dat/catalog/catalog_controller.dart';
import '../../player/media_player.dart';
import '../../series/presentation/episodes_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State <HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  int _currentPage = 0;
  late Future<Catalog> _catalogFuture;

  @override
  void initState(){
    super.initState();
    _pageController = PageController();
    _catalogFuture = CatalogController.instance.loadCatalog();
  }

  @override
  void dispose(){
    _pageController.dispose();
    super.dispose();
  }

  void _retry() {
    setState(() {
      _catalogFuture = CatalogController.instance.loadCatalog();
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
      body: FutureBuilder<Catalog>(
        future: _catalogFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Unable to load the catalog."),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _retry,
                    child: const Text("Try again"),
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
      return const Center(child: Text("No videos in the catalog."));
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
                      video.title,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Page ${index + 1}",
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
          "Current page: ${_currentPage + 1}",
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
            final videoPath = video.videoPath;
            if (!video.isSeries && videoPath == null) return;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => video.isSeries
                    ? EpisodesPage(series: video)
                    : PlayerPage(
                        playlist: [
                          PlayerItem(
                            videoUri: CatalogController.instance.library.resolve(videoPath!),
                            title: video.title,
                          ),
                        ],
                      ),
              ),
            );
          },
          child: Text(videos[_currentPage].isSeries ? 'Episodes' : 'Play'),
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

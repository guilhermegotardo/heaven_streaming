import 'package:flutter/material.dart';

import '../../../dat/catalog/catalogo_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State <HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
late PageController _pageController;
int _currentPage = 0;
final catalogo = CatalogController.instance.catalogo;

  @override
  void initState(){
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose(){
    _pageController.dispose();
    super.dispose();
  }

  void nextPage() {
    if (_currentPage < catalogo.videos.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final videos = catalogo.videos;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Heaven Stream"),
      ),

      body: Column(
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
                return Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                    ),
                  );
              },
            ),
          ),

          const SizedBox(height: 20),

          Text(
            "Página atual: $_currentPage",
            style: const TextStyle(fontSize: 20),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: nextPage,
            child: const Text("Next Page"),
          ),

          const SizedBox(height: 30),

        ],
      ),
    );
  }

}

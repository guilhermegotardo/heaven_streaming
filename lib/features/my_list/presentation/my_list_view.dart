import 'package:flutter/material.dart';

import '../../../app/navigation.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/dropdown_select.dart';
import '../../../core/widgets/state_view.dart';
import '../../../dat/catalog/catalog.dart';
import '../../../dat/my_list/my_list_controller.dart';
import '../../browse/presentation/browse_view.dart';

enum _Sort {
  recent('Recently added'),
  title('Title A–Z'),
  year('Release year');

  const _Sort(this.label);

  final String label;
}

/// "08 My List" and its "11 Empty" state.
class MyListView extends StatefulWidget {
  const MyListView({super.key, required this.videos});

  final List<Video> videos;

  @override
  State<MyListView> createState() => _MyListViewState();
}

class _MyListViewState extends State<MyListView> {
  _Sort _sort = _Sort.recent;

  List<Video> _sorted() {
    final byId = {for (final video in widget.videos) video.id: video};
    // Stored oldest first; "Recently added" shows the newest first.
    final list = [
      for (final id in MyListController.instance.ids.reversed) ?byId[id],
    ];
    switch (_sort) {
      case _Sort.recent:
        break;
      case _Sort.title:
        list.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
      case _Sort.year:
        list.sort((a, b) => b.year.compareTo(a.year));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: MyListController.instance,
      builder: (context, _) => BrowseView(
        title: 'My List',
        videos: _sorted(),
        trailing: DropdownSelect<_Sort>(
          value: _sort,
          options: _Sort.values,
          labelOf: (sort) => sort.label,
          width: Responsive.isMobile(context) ? 180 : 220,
          onChanged: (sort) => setState(() => _sort = sort),
        ),
        empty: StateView(
          icon: Icons.format_list_bulleted,
          title: 'Your list is empty',
          message: 'Add movies and series to watch them later.',
          actionLabel: 'Browse catalog',
          actionIcon: Icons.movie_outlined,
          onAction: () => AppNavigation.goToTab(context, ShellTab.home),
        ),
      ),
    );
  }
}

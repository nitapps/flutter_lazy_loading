import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

/// widget that provides lazy loading functionality
///
/// [T] is the class type of items
class LazyLoadingWidget<T> extends StatefulWidget {
  const LazyLoadingWidget(
      {super.key,
      required this.provider,
      required this.itemWidget,
      this.gridView = false,
      this.gridViewCrossAxisCount = 2,
      this.noItemsFoundMessage,
      this.loadingIndicatorColor,
      this.loadingBackgroundColor,
      this.loadingWidget});

  /// The provider object which contains all the functionality for lazy loading items
  final LazyLoadingProvider<T> provider;

  /// the function which builds each item Ui component and returns item widget
  final Widget Function(T) itemWidget;

  /// the boolean that decides the list of items should be a [GridView] or a [ListView]
  ///
  /// if [gridView] is true then the ui will be a [GridView] of items otherwise a [ListView]
  ///
  /// by default it is false, which means the items appears in a [ListView]
  final bool gridView;

  /// how many items should be displayed in a row in the [GridView], if [gridview] is true
  final int gridViewCrossAxisCount;

  /// The message is shown when no items are found when load items, or [provider.items] is empty or null
  final String? noItemsFoundMessage;

  /// while fetching items a loading UI is shown, which is a [CircularProgressIndicator]
  ///
  /// this [loadingIndicatorColor] is the color of loading indicator
  ///
  /// by default it is [Colors.blue]
  final Color? loadingIndicatorColor;

  /// while fetching items a loading UI is shown, which is a [CircularProgressIndicator]
  ///
  /// this [loadingBackgroundColor] is the background color of loading indicator
  ///
  /// by default it is [Colors.white]
  final Color? loadingBackgroundColor;

  /// a loading widget to be shown while fetching items
  ///
  /// if [loadingWidget] is not provided, by default a [CircularProgressIndicator] is shown
  final Widget? loadingWidget;

  @override
  State<LazyLoadingWidget<T>> createState() => _LazyLoadingWidgetState<T>();
}

class _LazyLoadingWidgetState<T> extends State<LazyLoadingWidget<T>> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        widget.provider.loadMoreItems();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final gridItems = widget.gridView
        ? widget.provider.gridViewItems(widget.gridViewCrossAxisCount)
        : null;
    final isGridView = widget.gridView && (gridItems?.isNotEmpty ?? false);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        widget.provider.items?.isNotEmpty ?? false
            ? Expanded(
                child: ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: isGridView
                        ? gridItems!.length
                        : widget.provider.items!.length,
                    itemBuilder: (_, index) {
                      return isGridView
                          ? IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: gridItems![index]
                                    .map((e) =>
                                        Expanded(child: widget.itemWidget(e)))
                                    .toList(),
                              ),
                            )
                          : widget.itemWidget(widget.provider.items![index]);
                    }))
            : SizedBox(),
        SizedBox(
          height: 10,
        ),
        widget.provider.isLoading
            ? widget.loadingWidget ??
                Container(
                  color: widget.loadingBackgroundColor ?? Colors.white,
                  margin: const EdgeInsets.all(16),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: widget.loadingIndicatorColor ?? Colors.blue,
                    ),
                  ),
                )
            : (widget.provider.items?.isEmpty ?? false)
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        widget.noItemsFoundMessage ?? "No Items Found",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  )
                : const SizedBox()
      ],
    );
  }
}

/// a [ChangeNotifier] which handles the data and state changes for [LazyLoadingWidget]
class LazyLoadingProvider<T> extends ChangeNotifier {
  /// the response of the function [fetchItems]
  ItemsResponse<T>? _itemsResponse;

  /// then function that fetch items by [page] and [offset]
  final Future<ItemsResponse<T>?> Function(int page, int offset) fetchItems;

  /// the first page number for the fetching items
  ///
  /// some times first page can be 0, sometimes 1
  int firstPageNumber;

  /// a variable which holds the page number that is used when loading items
  int page = 0;

  /// specifies how many items should be loaded each time [fetchItems]
  int offset = 10;

  /// when items are loading [isLoading] will be true
  bool isLoading = true;

  /// tells whether the internet connection is available or not
  bool isInternet = true;

  /// whether while fetching items any error occurred
  bool isError = false;

  /// error message to display when some error occurred while fetching items
  String errorMessage = '';

  /// list of items
  ///
  /// items gets added as users scroll the page
  List<T>? items;

  LazyLoadingProvider(
      {required this.fetchItems, required this.firstPageNumber, int? offset}) {
    page = firstPageNumber;
    if (offset != null && offset > 0) {
      this.offset = offset;
    }
    loadItems(this.page, this.offset);
  }

  /// resets the all variable and loads the items from first page
  Future<void> reset() async {
    isLoading = true;
    page = firstPageNumber;
    items = null;
    notifyListeners();
    await loadItems(page, offset);
  }

  /// loads items for the [page] with the internet check
  Future<void> loadItems(int page, int offset) async {
    final connectivity = await Connectivity().checkConnectivity();
    isInternet = connectivity != ConnectivityResult.none;
    if (isInternet) {
      _itemsResponse = await fetchItems(page, offset);
      if (_itemsResponse != null) {
        if (items != null) {
          items!.addAll(_itemsResponse!.items);
        } else {
          items = _itemsResponse!.items;
        }
        this.page++;
      }
    }
    isLoading = false;
    notifyListeners();
  }

  /// function that loads more items as user scrolls if the
  /// current page is not the last page
  Future<void> loadMoreItems() async {
    if (!isLoading && _itemsResponse != null && isNextPageAvailable()) {
      isLoading = true;
      notifyListeners();
      await loadItems(page, offset);
    }
  }

  /// function that gives list chunks for gridview
  List<List<T>> gridViewItems(int gridCrossAxisCount) {
    List<List<T>> gridItems = [];
    if (items?.isNotEmpty ?? false) {
      for (int i = 0; i <= items!.length; i += gridCrossAxisCount) {
        gridItems.add(items!.sublist(
            i,
            i + gridCrossAxisCount < items!.length
                ? i + gridCrossAxisCount
                : (items!.length)));
      }
    }
    return gridItems;
  }

  /// function that checks whether current page is last page or not
  bool isNextPageAvailable() {
    final numberOfPages = _itemsResponse?.totalPages ?? 0;
    return (page <= (numberOfPages + (firstPageNumber - 1)));
  }
}

/// The Return type required for [LazyLoadingProvider.fetchItems]
///
/// When we load items for a page, the response contains list of items, that
/// with that items this [ItemResponse] object is created
class ItemsResponse<T> {
  /// list of items
  List<T> items;

  /// total number of pages available to fetch
  int totalPages;

  ItemsResponse({
    required this.items,
    required this.totalPages,
  });
}

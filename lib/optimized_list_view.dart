import 'package:flutter/material.dart';

class OptimizedListView extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final Widget Function(BuildContext, Map<String, dynamic>, int) itemBuilder;
  final int pageSize;
  final ScrollController? controller;
  final bool shrinkWrap;
  final EdgeInsets? padding;
  final bool showLoadingIndicator;
  final Widget? emptyWidget;

  const OptimizedListView({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.pageSize = 10,
    this.controller,
    this.shrinkWrap = false,
    this.padding,
    this.showLoadingIndicator = true,
    this.emptyWidget,
  });

  @override
  State<OptimizedListView> createState() => _OptimizedListViewState();
}

class _OptimizedListViewState extends State<OptimizedListView> {
  final List<Map<String, dynamic>> _visibleItems = [];
  late ScrollController _scrollController;
  int _currentPage = 0;
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.controller ?? ScrollController();
    _scrollController.addListener(_scrollListener);
    _loadMoreItems();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        _hasMore &&
        !_isLoading) {
      _loadMoreItems();
    }
  }

  Future<void> _loadMoreItems() async {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);

    // محاكاة تأخير للشبكة
    await Future.delayed(const Duration(milliseconds: 500));

    final start = _currentPage * widget.pageSize;
    if (start >= widget.items.length) {
      setState(() {
        _hasMore = false;
        _isLoading = false;
      });
      return;
    }

    final end = start + widget.pageSize;
    final newItems = widget.items.sublist(
      start,
      end < widget.items.length ? end : widget.items.length,
    );

    setState(() {
      _visibleItems.addAll(newItems);
      _currentPage++;
      _isLoading = false;
      _hasMore = end < widget.items.length;
    });
  }

  void refresh() {
    setState(() {
      _visibleItems.clear();
      _currentPage = 0;
      _hasMore = true;
      _isLoading = false;
    });
    _loadMoreItems();
  }

  @override
  Widget build(BuildContext context) {
    if (_visibleItems.isEmpty && !_hasMore) {
      return widget.emptyWidget ??
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'لا توجد عناصر لعرضها',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
    }

    return ListView.builder(
      controller: _scrollController,
      shrinkWrap: widget.shrinkWrap,
      padding: widget.padding,
      itemCount: _visibleItems.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _visibleItems.length) {
          return _hasMore && widget.showLoadingIndicator
              ? Container(
                  padding: const EdgeInsets.all(16),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Container(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      'تم عرض جميع العناصر',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
        }
        return widget.itemBuilder(context, _visibleItems[index], index);
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // تأكد من إضافة هذا الباكيج

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
    // تحميل استباقي عند الوصول لـ 90% من القائمة لتجربة أكثر سلاسة
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.9 &&
        _hasMore &&
        !_isLoading) {
      _loadMoreItems();
    }
  }

  Future<void> _loadMoreItems() async {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);

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

    if (mounted) {
      setState(() {
        _visibleItems.addAll(newItems);
        _currentPage++;
        _isLoading = false;
        _hasMore = end < widget.items.length;
      });
    }
  }

  // دالة مفيدة لإعادة تحميل القائمة
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
              padding: const EdgeInsets.all(40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.inbox_outlined,
                      size: 60,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'لا توجد عناصر لعرضها حالياً',
                    style: GoogleFonts.tajawal(
                      color: Colors.grey.shade600,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
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
      padding: widget.padding ?? const EdgeInsets.symmetric(vertical: 10),
      itemCount: _visibleItems.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _visibleItems.length) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: _hasMore && widget.showLoadingIndicator
                  ? const SizedBox(
                      width: 25,
                      height: 25,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    )
                  : Text(
                      'تم عرض جميع النتائج ✨',
                      style: GoogleFonts.tajawal(
                        color: Colors.grey.shade500,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
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

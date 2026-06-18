import 'package:bookmark_in_seoul/providers/bookmark_filter_provider.dart';
import 'package:bookmark_in_seoul/providers/bookmark_sort_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bookmark_in_seoul/data/district_data.dart';
import '../providers/district_filter_provider.dart';

// 북마크 목록
const List<Map<String, dynamic>> bookmarkItems = [
  {'value': 1, 'label': '별☆'},
  {'value': 2, 'label': '하트♡'},
  {'value': 3, 'label': '체크√'},
  {'value': 4, 'label': '엑스X'},
];

enum FilterMode {filter, sort}

class FilterBox extends ConsumerWidget {
  final FilterMode mode;
  const FilterBox({super.key, required this.mode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final selectMode = mode == FilterMode.filter
      ? ref.watch(bookmarkFilterProvider)
        : ref.watch(bookmarkSortProvider);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(width: 16,),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFDEFD9),
              borderRadius: BorderRadius.circular(25),
            ),
            padding: const EdgeInsets.fromLTRB(16, 26, 16, 0),
            child:
            Row(
              children: [
                SizedBox(width:8,),
                // 지역별 필터링
                Expanded(
                    child: Column(
                      children: [
                        // 탭하면 BottomSheet
                        GestureDetector(
                          onTap: () => _showDistrictBottomSheet(context ,ref),
                          child: _filterButton(
                              // 선택된 지역이 있으면 보여주고, 없으면 '지역' 출력
                              label: ref.watch(districtFilterProvider) ?? '지역',
                              isSelected: ref.watch(districtFilterProvider) != null,
                          ),
                        ),
                      ],
                    ),
                ),
                SizedBox(width:24,),
                // 북마크별 필터링or정렬
                Expanded(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => _showBookmarkBottomSheet(context, ref, mode),
                        child: _filterButton(
                          label: selectMode != null
                              ? bookmarkItems.firstWhere(
                                (item) => item['value'] == selectMode,
                          )['label'] as String
                              : '북마크',
                          isSelected: selectMode != null,
                        ),
                      ),
                    ],
                  )
                ),
                SizedBox(width:8,),
              ]
            ),
          ),
        ),
        SizedBox(width:16,),
      ],
    );
  }
}

Widget _filterButton({required String label, required bool isSelected}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black45),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.black
          ),
        ),
        const Icon(Icons.arrow_drop_down, color: Colors.black45),
      ],
    ),
  );
}


void _showDistrictBottomSheet(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SizedBox(
          height: 600,
          child: Column(
            children: [
              // 상단 타이틀 + 초기화 버튼
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '지역 선택',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        ref.read(districtFilterProvider.notifier).clear();
                        Navigator.pop(context);
                      },
                      child: const Text('전지역 보기'),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1,),
              // 지역 목록 리스트
              Expanded(
                  child: ListView.builder(
                    itemCount: districtNames.length,
                    itemBuilder: (context, index) {
                      final item = districtNames[index];
                      final value = item['value'] as String;
                      final label = item['label'] as String;
                      final isSelected = ref.watch(districtFilterProvider)==value;

                      return ListTile(
                        title: Center(child: Text(
                          label,
                          style: TextStyle(
                            color: isSelected ? Colors.blue : Colors.black,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),)),
                        onTap: () {
                          ref.read(districtFilterProvider.notifier).state = value;
                          Navigator.pop(context);
                        },
                      );
                    },
              ))
            ],
          ),
        );
      },
  );
}


void _showBookmarkBottomSheet(BuildContext context, WidgetRef ref, FilterMode mode) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return SizedBox(
        height: 360,
        child: Column(
          children: [
            // 상단 타이틀 + 초기화 버튼
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '북마크 선택',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  if(mode==FilterMode.filter)
                    TextButton(
                      onPressed: () {
                        ref.read(bookmarkFilterProvider.notifier).state = null;
                        Navigator.pop(context);
                      },
                      child: const Text('초기화'),
                    ),
                ],
              ),
            ),
            const Divider(height: 1),
            // 북마크 목록 리스트
            Expanded(
              child: ListView.builder(
                itemCount: bookmarkItems.length,
                itemBuilder: (context, index) {
                  final item = bookmarkItems[index];
                  final value = item['value'] as int;
                  final label = item['label'] as String;
                  final isSelected = mode == FilterMode.filter
                      ? ref.watch(bookmarkFilterProvider) == value
                      : ref.watch(bookmarkSortProvider) == value;

                  return ListTile(
                    title: Center(child: Text(
                      label,
                      style: TextStyle(
                        color: isSelected ? Colors.blue : Colors.black,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),)),
                    onTap: () {
                      if(mode == FilterMode.filter){
                        ref.read(bookmarkFilterProvider.notifier).state = value;
                      } else {
                        ref.read(bookmarkSortProvider.notifier).state = value;
                      }
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
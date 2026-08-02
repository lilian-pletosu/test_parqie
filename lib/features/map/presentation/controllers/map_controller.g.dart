// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MapNotifier)
final mapProvider = MapNotifierProvider._();

final class MapNotifierProvider
    extends $AsyncNotifierProvider<MapNotifier, MapState> {
  MapNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mapProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mapNotifierHash();

  @$internal
  @override
  MapNotifier create() => MapNotifier();
}

String _$mapNotifierHash() => r'ebf6c015d3d5723a1e24c43dfe77dbcc20765bb2';

abstract class _$MapNotifier extends $AsyncNotifier<MapState> {
  FutureOr<MapState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<MapState>, MapState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<MapState>, MapState>,
              AsyncValue<MapState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

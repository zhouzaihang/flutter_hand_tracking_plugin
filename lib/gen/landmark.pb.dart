///
//  Generated code. Do not modify.
//  source: landmark.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class Landmark extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Landmark', package: const $pb.PackageName('mediapipe'), createEmptyInstance: create)
    ..a<$core.double>(1, 'x', $pb.PbFieldType.OF)
    ..a<$core.double>(2, 'y', $pb.PbFieldType.OF)
    ..a<$core.double>(3, 'z', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  Landmark._() : super();
  factory Landmark() => create();
  factory Landmark.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Landmark.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  Landmark clone() => Landmark()..mergeFromMessage(this);
  Landmark copyWith(void Function(Landmark) updates) => super.copyWith((message) => updates(message as Landmark));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Landmark create() => Landmark._();
  Landmark createEmptyInstance() => create();
  static $pb.PbList<Landmark> createRepeated() => $pb.PbList<Landmark>();
  @$core.pragma('dart2js:noInline')
  static Landmark getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Landmark>(create);
  static Landmark _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get x => $_getN(0);
  @$pb.TagNumber(1)
  set x($core.double v) { $_setFloat(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasX() => $_has(0);
  @$pb.TagNumber(1)
  void clearX() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get y => $_getN(1);
  @$pb.TagNumber(2)
  set y($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasY() => $_has(1);
  @$pb.TagNumber(2)
  void clearY() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get z => $_getN(2);
  @$pb.TagNumber(3)
  set z($core.double v) { $_setFloat(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasZ() => $_has(2);
  @$pb.TagNumber(3)
  void clearZ() => clearField(3);
}

class LandmarkList extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('LandmarkList', package: const $pb.PackageName('mediapipe'), createEmptyInstance: create)
    ..pc<Landmark>(1, 'landmark', $pb.PbFieldType.PM, subBuilder: Landmark.create)
    ..hasRequiredFields = false
  ;

  LandmarkList._() : super();
  factory LandmarkList() => create();
  factory LandmarkList.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LandmarkList.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  LandmarkList clone() => LandmarkList()..mergeFromMessage(this);
  LandmarkList copyWith(void Function(LandmarkList) updates) => super.copyWith((message) => updates(message as LandmarkList));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LandmarkList create() => LandmarkList._();
  LandmarkList createEmptyInstance() => create();
  static $pb.PbList<LandmarkList> createRepeated() => $pb.PbList<LandmarkList>();
  @$core.pragma('dart2js:noInline')
  static LandmarkList getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LandmarkList>(create);
  static LandmarkList _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Landmark> get landmark => $_getList(0);
}

class NormalizedLandmark extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('NormalizedLandmark', package: const $pb.PackageName('mediapipe'), createEmptyInstance: create)
    ..a<$core.double>(1, 'x', $pb.PbFieldType.OF)
    ..a<$core.double>(2, 'y', $pb.PbFieldType.OF)
    ..a<$core.double>(3, 'z', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  NormalizedLandmark._() : super();
  factory NormalizedLandmark() => create();
  factory NormalizedLandmark.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory NormalizedLandmark.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  NormalizedLandmark clone() => NormalizedLandmark()..mergeFromMessage(this);
  NormalizedLandmark copyWith(void Function(NormalizedLandmark) updates) => super.copyWith((message) => updates(message as NormalizedLandmark));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NormalizedLandmark create() => NormalizedLandmark._();
  NormalizedLandmark createEmptyInstance() => create();
  static $pb.PbList<NormalizedLandmark> createRepeated() => $pb.PbList<NormalizedLandmark>();
  @$core.pragma('dart2js:noInline')
  static NormalizedLandmark getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NormalizedLandmark>(create);
  static NormalizedLandmark _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get x => $_getN(0);
  @$pb.TagNumber(1)
  set x($core.double v) { $_setFloat(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasX() => $_has(0);
  @$pb.TagNumber(1)
  void clearX() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get y => $_getN(1);
  @$pb.TagNumber(2)
  set y($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasY() => $_has(1);
  @$pb.TagNumber(2)
  void clearY() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get z => $_getN(2);
  @$pb.TagNumber(3)
  set z($core.double v) { $_setFloat(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasZ() => $_has(2);
  @$pb.TagNumber(3)
  void clearZ() => clearField(3);
}

class NormalizedLandmarkList extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('NormalizedLandmarkList', package: const $pb.PackageName('mediapipe'), createEmptyInstance: create)
    ..pc<NormalizedLandmark>(1, 'landmark', $pb.PbFieldType.PM, subBuilder: NormalizedLandmark.create)
    ..hasRequiredFields = false
  ;

  NormalizedLandmarkList._() : super();
  factory NormalizedLandmarkList() => create();
  factory NormalizedLandmarkList.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory NormalizedLandmarkList.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  NormalizedLandmarkList clone() => NormalizedLandmarkList()..mergeFromMessage(this);
  NormalizedLandmarkList copyWith(void Function(NormalizedLandmarkList) updates) => super.copyWith((message) => updates(message as NormalizedLandmarkList));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NormalizedLandmarkList create() => NormalizedLandmarkList._();
  NormalizedLandmarkList createEmptyInstance() => create();
  static $pb.PbList<NormalizedLandmarkList> createRepeated() => $pb.PbList<NormalizedLandmarkList>();
  @$core.pragma('dart2js:noInline')
  static NormalizedLandmarkList getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NormalizedLandmarkList>(create);
  static NormalizedLandmarkList _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<NormalizedLandmark> get landmark => $_getList(0);
}


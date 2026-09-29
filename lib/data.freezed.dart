// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FlapData {


/// Create a copy of FlapData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FlapDataCopyWith<FlapData> get copyWith => _$FlapDataCopyWithImpl<FlapData>(this as FlapData, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FlapData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FlapData&&(identical(other.setting, _this.setting) || other.setting == _this.setting)&&(identical(other.vfe, _this.vfe) || other.vfe == _this.vfe));
}


@override
int get hashCode {
  final _this = this as FlapData;
  return Object.hash(runtimeType,_this.setting,_this.vfe);
}

@override
String toString() {
  final _this = this as FlapData;
  return 'FlapData(setting: ${_this.setting}, vfe: ${_this.vfe})';
}


}

/// @nodoc
abstract mixin class $FlapDataCopyWith<$Res>  {
  factory $FlapDataCopyWith(FlapData value, $Res Function(FlapData) _then) = _$FlapDataCopyWithImpl;
@useResult
$Res call({
 FlapSetting setting, double vfe
});




}
/// @nodoc
class _$FlapDataCopyWithImpl<$Res>
    implements $FlapDataCopyWith<$Res> {
  _$FlapDataCopyWithImpl(this._self, this._then);

  final FlapData _self;
  final $Res Function(FlapData) _then;

/// Create a copy of FlapData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? setting = null,Object? vfe = null,}) {
  return _then(FlapData(
setting: null == setting ? _self.setting : setting // ignore: cast_nullable_to_non_nullable
as FlapSetting,vfe: null == vfe ? _self.vfe : vfe // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}



/// @nodoc
mixin _$AircraftData {


/// Create a copy of AircraftData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AircraftDataCopyWith<AircraftData> get copyWith => _$AircraftDataCopyWithImpl<AircraftData>(this as AircraftData, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AircraftData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AircraftData&&(identical(other.vne, _this.vne) || other.vne == _this.vne)&&(identical(other.mne, _this.mne) || other.mne == _this.mne)&&(identical(other.vle, _this.vle) || other.vle == _this.vle)&&const DeepCollectionEquality().equals(other.flapSettings, _this.flapSettings)&&(identical(other.hasAutoFlaps, _this.hasAutoFlaps) || other.hasAutoFlaps == _this.hasAutoFlaps)&&(identical(other.hasCobraButton, _this.hasCobraButton) || other.hasCobraButton == _this.hasCobraButton)&&(identical(other.hasReverseThrust, _this.hasReverseThrust) || other.hasReverseThrust == _this.hasReverseThrust)&&(identical(other.missingYawAndAileronTrim, _this.missingYawAndAileronTrim) || other.missingYawAndAileronTrim == _this.missingYawAndAileronTrim)&&(identical(other.hasAirbrake, _this.hasAirbrake) || other.hasAirbrake == _this.hasAirbrake)&&(identical(other.hasTailHook, _this.hasTailHook) || other.hasTailHook == _this.hasTailHook)&&(identical(other.hasDragChute, _this.hasDragChute) || other.hasDragChute == _this.hasDragChute));
}


@override
int get hashCode {
  final _this = this as AircraftData;
  return Object.hash(runtimeType,_this.vne,_this.mne,_this.vle,const DeepCollectionEquality().hash(_this.flapSettings),_this.hasAutoFlaps,_this.hasCobraButton,_this.hasReverseThrust,_this.missingYawAndAileronTrim,_this.hasAirbrake,_this.hasTailHook,_this.hasDragChute);
}

@override
String toString() {
  final _this = this as AircraftData;
  return 'AircraftData(vne: ${_this.vne}, mne: ${_this.mne}, vle: ${_this.vle}, flapSettings: ${_this.flapSettings}, hasAutoFlaps: ${_this.hasAutoFlaps}, hasCobraButton: ${_this.hasCobraButton}, hasReverseThrust: ${_this.hasReverseThrust}, missingYawAndAileronTrim: ${_this.missingYawAndAileronTrim}, hasAirbrake: ${_this.hasAirbrake}, hasTailHook: ${_this.hasTailHook}, hasDragChute: ${_this.hasDragChute})';
}


}

/// @nodoc
abstract mixin class $AircraftDataCopyWith<$Res>  {
  factory $AircraftDataCopyWith(AircraftData value, $Res Function(AircraftData) _then) = _$AircraftDataCopyWithImpl;
@useResult
$Res call({
 double vne, double mne, double vle, List<FlapData>? flapSettings, bool hasAutoFlaps, bool hasCobraButton, bool hasReverseThrust, bool missingYawAndAileronTrim, bool hasAirbrake, bool hasTailHook, bool hasDragChute
});




}
/// @nodoc
class _$AircraftDataCopyWithImpl<$Res>
    implements $AircraftDataCopyWith<$Res> {
  _$AircraftDataCopyWithImpl(this._self, this._then);

  final AircraftData _self;
  final $Res Function(AircraftData) _then;

/// Create a copy of AircraftData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? vne = null,Object? mne = null,Object? vle = null,Object? flapSettings = freezed,Object? hasAutoFlaps = null,Object? hasCobraButton = null,Object? hasReverseThrust = null,Object? missingYawAndAileronTrim = null,Object? hasAirbrake = null,Object? hasTailHook = null,Object? hasDragChute = null,}) {
  return _then(AircraftData(
vne: null == vne ? _self.vne : vne // ignore: cast_nullable_to_non_nullable
as double,mne: null == mne ? _self.mne : mne // ignore: cast_nullable_to_non_nullable
as double,vle: null == vle ? _self.vle : vle // ignore: cast_nullable_to_non_nullable
as double,flapSettings: freezed == flapSettings ? _self.flapSettings : flapSettings // ignore: cast_nullable_to_non_nullable
as List<FlapData>?,hasAutoFlaps: null == hasAutoFlaps ? _self.hasAutoFlaps : hasAutoFlaps // ignore: cast_nullable_to_non_nullable
as bool,hasCobraButton: null == hasCobraButton ? _self.hasCobraButton : hasCobraButton // ignore: cast_nullable_to_non_nullable
as bool,hasReverseThrust: null == hasReverseThrust ? _self.hasReverseThrust : hasReverseThrust // ignore: cast_nullable_to_non_nullable
as bool,missingYawAndAileronTrim: null == missingYawAndAileronTrim ? _self.missingYawAndAileronTrim : missingYawAndAileronTrim // ignore: cast_nullable_to_non_nullable
as bool,hasAirbrake: null == hasAirbrake ? _self.hasAirbrake : hasAirbrake // ignore: cast_nullable_to_non_nullable
as bool,hasTailHook: null == hasTailHook ? _self.hasTailHook : hasTailHook // ignore: cast_nullable_to_non_nullable
as bool,hasDragChute: null == hasDragChute ? _self.hasDragChute : hasDragChute // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}



// dart format on

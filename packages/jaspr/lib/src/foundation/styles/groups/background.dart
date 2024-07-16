part of '../styles.dart';

class _BackgroundStyles extends Styles {
  const _BackgroundStyles({
    this.color,
    this.attachment,
    this.clip,
    this.image,
    this.origin,
    this.position,
    this.repeat,
    this.size,
  }) : super._();

  final Color? color;
  final BackgroundAttachment? attachment;
  final BackgroundClip? clip;
  final ImageStyle? image;
  final BackgroundOrigin? origin;
  final BackgroundPosition? position;
  final BackgroundRepeat? repeat;
  final BackgroundSize? size;

  @override
  Map<String, String> get styles => {
        if (color != null) 'background-color': color!.value,
        if (attachment != null) 'background-attachment': attachment!.value,
        if (clip != null) 'background-clip': clip!.value,
        if (image != null) 'background-image': image!.value,
        if (origin != null) 'background-origin': origin!.value,
        if (position != null) 'background-position': position!.value,
        if (repeat != null) 'background-repeat': repeat!.value,
        if (size != null) 'background-size': size!.value,
      };
}

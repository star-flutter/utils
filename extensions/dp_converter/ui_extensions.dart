import 'design_to_screen_mapper.dart';

extension DpParcing on int {
  double fromDp() {
    return DesignToScreenMapper.dpToPixels(dp: this.toDouble());
  }
}

extension SpParsing on int {
  double fromSp() {
    return DesignToScreenMapper.spToPixels(sp: this.toDouble());
  }
}
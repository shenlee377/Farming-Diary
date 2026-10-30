/// 手機端模糊快篩：對亮度（Y）平面做 Laplacian 方差。
///
/// 數值越大越清晰。門檻與裝置、場景有關，[defaultBlurThreshold] 為起始值，
/// 需以實機在田間的樣本校正（docs/ROADMAP M4）。
library;

import 'dart:typed_data';

const double defaultBlurThreshold = 60;

/// [luma] 為逐列排列的 8-bit 亮度，[rowStride] 為每列位元組數（可大於 [width]）。
/// [step] 為取樣間隔，用來降低運算量（預覽影像 640x480 時取 2 即足夠）。
double laplacianVariance(
  Uint8List luma, {
  required int width,
  required int height,
  required int rowStride,
  int step = 2,
}) {
  if (width < 3 * step || height < 3 * step) return 0;
  var sum = 0.0;
  var sumSq = 0.0;
  var n = 0;
  for (var y = step; y < height - step; y += step) {
    final row = y * rowStride;
    final up = (y - step) * rowStride;
    final down = (y + step) * rowStride;
    for (var x = step; x < width - step; x += step) {
      final lap =
          luma[up + x] +
          luma[down + x] +
          luma[row + x - step] +
          luma[row + x + step] -
          4 * luma[row + x];
      sum += lap;
      sumSq += lap * lap;
      n++;
    }
  }
  if (n == 0) return 0;
  final mean = sum / n;
  return sumSq / n - mean * mean;
}

enum FrameQuality {
  sharp('畫面清晰'),
  blurry('畫面晃動，請放慢腳步'),
  tooDark('太暗了，請到光線較好的地方');

  final String hint;
  const FrameQuality(this.hint);
}

double meanLuma(
  Uint8List luma, {
  required int width,
  required int height,
  required int rowStride,
  int step = 8,
}) {
  var sum = 0;
  var n = 0;
  for (var y = 0; y < height; y += step) {
    final row = y * rowStride;
    for (var x = 0; x < width; x += step) {
      sum += luma[row + x];
      n++;
    }
  }
  return n == 0 ? 0 : sum / n;
}

FrameQuality classifyFrame({
  required double blurScore,
  required double brightness,
  double threshold = defaultBlurThreshold,
}) {
  if (brightness < 35) return FrameQuality.tooDark;
  if (blurScore < threshold) return FrameQuality.blurry;
  return FrameQuality.sharp;
}

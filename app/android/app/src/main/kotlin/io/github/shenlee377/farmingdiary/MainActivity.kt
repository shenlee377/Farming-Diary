package io.github.shenlee377.farmingdiary

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import kotlin.math.atan2
import kotlin.math.hypot

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, "farmingdiary/heading")
            .setStreamHandler(HeadingStreamHandler(applicationContext))
    }
}

/**
 * 以旋轉向量感測器（融合加速度計、陀螺儀、磁力計）提供磁北方位，單位度、順時針。
 *
 * 手機直立拿著拍照時回傳後鏡頭朝向；手機平放時改回傳手機頂端朝向。
 * 裝置沒有旋轉向量感測器時送出錯誤 `no_sensor`，App 端隱藏轉向箭頭。
 */
private class HeadingStreamHandler(context: Context) : EventChannel.StreamHandler, SensorEventListener {
    private val sensorManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager
    private val rotationSensor: Sensor? = sensorManager.getDefaultSensor(Sensor.TYPE_ROTATION_VECTOR)
    private var sink: EventChannel.EventSink? = null
    private val matrix = FloatArray(9)

    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        if (rotationSensor == null) {
            events.error("no_sensor", "此裝置沒有方位感測器", null)
            return
        }
        sink = events
        sensorManager.registerListener(this, rotationSensor, SensorManager.SENSOR_DELAY_UI)
    }

    override fun onCancel(arguments: Any?) {
        sensorManager.unregisterListener(this)
        sink = null
    }

    override fun onSensorChanged(event: SensorEvent) {
        SensorManager.getRotationMatrixFromVector(matrix, event.values)
        // matrix 把裝置座標轉成世界座標（東、北、上）；後鏡頭朝向是裝置 -z 軸
        val east = -matrix[2]
        val north = -matrix[5]
        val degrees = if (hypot(east, north) > 0.35f) {
            Math.toDegrees(atan2(east, north).toDouble())
        } else {
            Math.toDegrees(atan2(matrix[1], matrix[4]).toDouble())
        }
        sink?.success((degrees + 360.0) % 360.0)
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) = Unit
}

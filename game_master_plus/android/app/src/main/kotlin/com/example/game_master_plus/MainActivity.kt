package com.example.game_master_plus

import android.app.ActivityManager
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build
import android.os.Environment
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.RandomAccessFile
import com.example.game_master_plus.optimization.SystemOptimizationManager

class MainActivity : FlutterActivity() {
    private val metricsChannel = "game_master_plus/system_metrics"
    private val actionsChannel = "game_master_plus/device_actions"
    private val optimizationManager by lazy { SystemOptimizationManager(this) }

    private var lastCpuSample: CpuSample? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, metricsChannel)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getMetrics" -> result.success(collectMetrics())
                    else -> result.notImplemented()
                }
            }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, actionsChannel)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "applyPerformanceProfile" -> {
                        val performance = call.argument<String>("performanceProfile") ?: "Balanceado"
                        val network = call.argument<String>("networkProfile") ?: "Produtividade"
                        val brightness = call.argument<Double>("brightness") ?: 0.65
                        val limitBackground = call.argument<Boolean>("limitBackgroundApps") ?: true
                        val adaptiveBattery = call.argument<Boolean>("adaptiveBattery") ?: true
                        optimizationManager.applyPerformanceProfile(
                            performanceProfile = performance,
                            networkProfile = network,
                            brightnessLevel = brightness,
                            limitBackgroundApps = limitBackground,
                            adaptiveBattery = adaptiveBattery,
                        )
                        result.success(null)
                    }

                    "runQuickOptimize" -> {
                        optimizationManager.runQuickOptimize()
                        result.success(null)
                    }

                    "scheduleUnlockOptimization" -> {
                        val enable = call.argument<Boolean>("enable") ?: false
                        optimizationManager.setUnlockOptimizationEnabled(enable)
                        result.success(null)
                    }

                    "scheduleNightlyCleanup" -> {
                        val enable = call.argument<Boolean>("enable") ?: false
                        optimizationManager.setNightlyCleanupEnabled(enable)
                        result.success(null)
                    }

                    else -> result.notImplemented()
                }
            }
    }

    private fun collectMetrics(): Map<String, Any> {
        val cpuUsage = readCpuUsage()
        val ramUsage = readRamUsage()
        val storageFree = readStorageFree()
        val temperature = readBatteryTemperature()
        val batteryLevel = readBatteryLevel()

        return mapOf(
            "cpuUsage" to cpuUsage,
            "ramUsage" to ramUsage,
            "storageFree" to storageFree,
            "temperature" to temperature,
            "batteryLevel" to batteryLevel,
        )
    }

    private fun readCpuUsage(): Double {
        val current = readCpuSample() ?: return -1.0
        val previous = lastCpuSample
        lastCpuSample = current
        if (previous == null) {
            return -1.0
        }
        val idle = current.idle - previous.idle
        val total = current.total - previous.total
        if (total <= 0L) return -1.0
        val usage = 1.0 - idle.toDouble() / total.toDouble()
        return (usage * 100).coerceIn(0.0, 100.0)
    }

    private fun readCpuSample(): CpuSample? {
        return try {
            RandomAccessFile("/proc/stat", "r").use { reader ->
                val load = reader.readLine()
                val toks = load.split(" ").filter { it.isNotBlank() }
                if (toks.isEmpty()) return null
                val numbers = toks.drop(1).mapNotNull { it.toLongOrNull() }
                if (numbers.size < 4) return null
                val idle = numbers[3]
                val total = numbers.fold(0L) { acc, value -> acc + value }
                CpuSample(idle = idle, total = total)
            }
        } catch (_: Exception) {
            null
        }
    }

    private fun readRamUsage(): Double {
        val activityManager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val info = ActivityManager.MemoryInfo()
        activityManager.getMemoryInfo(info)
        if (info.totalMem <= 0L) return -1.0
        val used = info.totalMem - info.availMem
        return (used.toDouble() / info.totalMem.toDouble() * 100).coerceIn(0.0, 100.0)
    }

    private fun readStorageFree(): Double {
        return try {
            val stat = android.os.StatFs(Environment.getDataDirectory().absolutePath)
            val bytes = stat.availableBytes
            bytes.toDouble() / (1024.0 * 1024.0 * 1024.0)
        } catch (_: Exception) {
            -1.0
        }
    }

    private fun readBatteryTemperature(): Double {
        return try {
            val intent = registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
            val temp = intent?.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, Int.MIN_VALUE)
                ?: Int.MIN_VALUE
            if (temp != Int.MIN_VALUE) temp / 10.0 else -1.0
        } catch (_: Exception) {
            -1.0
        }
    }

    private fun readBatteryLevel(): Int {
        val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            val level = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
            if (level in 0..100) level else -1
        } else {
            -1
        }
    }

    data class CpuSample(val idle: Long, val total: Long)
}

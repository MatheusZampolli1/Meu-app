package com.example.game_master_plus

import android.app.ActivityManager
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build
import android.os.Environment
import android.os.StatFs
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.RandomAccessFile
import kotlin.math.max

class MainActivity : FlutterActivity() {
    private val METRICS_CHANNEL = "fluxon/metrics"
    private val ACTIONS_CHANNEL = "game_master_plus/device_actions"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Canal para métricas do sistema
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METRICS_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getSystemMetrics" -> {
                        try {
                            result.success(readMetrics())
                        } catch (e: Exception) {
                            result.error("READ_FAIL", e.message, null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }

        // Canal para automações do sistema
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, ACTIONS_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "startPerfService" -> {
                        val intent = Intent(this, PerfForegroundService::class.java)
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                            startForegroundService(intent)
                        } else {
                            startService(intent)
                        }
                        result.success(true)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun readMetrics(): Map<String, Any> {
        val out = HashMap<String, Any>()

        // RAM (%)
        val am = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val memInfo = ActivityManager.MemoryInfo()
        am.getMemoryInfo(memInfo)
        val total = memInfo.totalMem.toDouble()
        val used = (memInfo.totalMem - memInfo.availMem).toDouble()
        val ramPercent = if (total > 0) (used / total) * 100.0 else 0.0
        out["ramUsage"] = max(0.0, ramPercent)

        // Armazenamento livre (GB)
        val stat = StatFs(Environment.getDataDirectory().path)
        val available = stat.availableBlocksLong * stat.blockSizeLong
        val freeGb = available.toDouble() / (1024 * 1024 * 1024)
        out["storageFree"] = freeGb

        // Bateria (%)
        val bm = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        val batteryLevel = bm.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        out["batteryLevel"] = batteryLevel

        // Temperatura (°C)
        val ifilter = IntentFilter(Intent.ACTION_BATTERY_CHANGED)
        val batteryStatus: Intent? = registerReceiver(null, ifilter)
        val tempTenths = batteryStatus?.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, 0) ?: 0
        val tempC = tempTenths / 10.0
        out["temperature"] = tempC

        // CPU (%)
        out["cpuUsage"] = readCpuUsageQuick()

        return out
    }

    private fun readCpuUsageQuick(): Double {
        return try {
            val s1 = readProcStat()
            Thread.sleep(240)
            val s2 = readProcStat()
            val idle = (s2.idle - s1.idle).toDouble()
            val total = (s2.total - s1.total).toDouble()
            if (total > 0) (1.0 - (idle / total)) * 100.0 else 0.0
        } catch (e: Exception) {
            0.0
        }
    }

    private data class CpuSnapshot(val idle: Long, val total: Long)

    private fun readProcStat(): CpuSnapshot {
        RandomAccessFile("/proc/stat", "r").use { reader ->
            val load = reader.readLine()
            val toks = load.split("\\s+".toRegex()).drop(1).mapNotNull { it.toLongOrNull() }
            val idle = toks[3]
            val total = toks.sum()
            return CpuSnapshot(idle, total)
        }
    }
}

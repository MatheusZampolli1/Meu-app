package com.example.game_master_plus.optimization

import android.app.AlarmManager
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.PendingIntent.FLAG_IMMUTABLE
import android.app.PendingIntent.FLAG_UPDATE_CURRENT
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.os.Build
import android.provider.Settings
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import com.example.game_master_plus.R
import kotlin.math.max
import kotlin.math.min
import kotlin.math.roundToInt

data class PerformanceProfile(
    val performance: String,
    val network: String,
    val brightness: Double,
    val limitBackgroundApps: Boolean,
    val adaptiveBattery: Boolean,
)

class SystemOptimizationManager(private val context: Context) {
    private val prefs: SharedPreferences =
        context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
    private val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager

    init {
        ensureNotificationChannel()
    }

    fun applyPerformanceProfile(
        performanceProfile: String,
        networkProfile: String,
        brightnessLevel: Double,
        limitBackgroundApps: Boolean,
        adaptiveBattery: Boolean,
    ) {
        val profile = PerformanceProfile(
            performance = performanceProfile,
            network = networkProfile,
            brightness = brightnessLevel,
            limitBackgroundApps = limitBackgroundApps,
            adaptiveBattery = adaptiveBattery,
        )
        saveProfile(profile)
        maybeApplyBrightness(profile)
    }

    fun runQuickOptimize() {
        ProcessOptimizer.trimBackgroundProcesses(context)
    }

    fun setUnlockOptimizationEnabled(enable: Boolean) {
        prefs.edit().putBoolean(KEY_UNLOCK_OPTIMIZE, enable).apply()
        val component = ComponentName(context, UnlockReceiver::class.java)
        val newState = if (enable) {
            android.content.pm.PackageManager.COMPONENT_ENABLED_STATE_ENABLED
        } else {
            android.content.pm.PackageManager.COMPONENT_ENABLED_STATE_DISABLED
        }
        context.packageManager.setComponentEnabledSetting(
            component,
            newState,
            android.content.pm.PackageManager.DONT_KILL_APP,
        )
    }

    fun setNightlyCleanupEnabled(enable: Boolean) {
        prefs.edit().putBoolean(KEY_NIGHTLY_CLEANUP, enable).apply()
        val pendingIntent = nightlyCleanupPendingIntent(context)
        if (enable) {
            scheduleNightlyReminder(pendingIntent)
        } else {
            alarmManager.cancel(pendingIntent)
        }
    }

    fun handleUnlockEvent() {
        if (prefs.getBoolean(KEY_UNLOCK_OPTIMIZE, false)) {
            runQuickOptimize()
        }
    }

    fun handleNightlyReminder() {
        if (!prefs.getBoolean(KEY_NIGHTLY_CLEANUP, false)) return
        val builder = NotificationCompat.Builder(context, CHANNEL_ID)
            .setSmallIcon(R.drawable.ic_notification_optimize)
            .setContentTitle("Game Master Plus")
            .setContentText("Hora de revisar armazenamento e otimizar o dispositivo.")
            .setPriority(NotificationCompat.PRIORITY_DEFAULT)
            .setAutoCancel(true)
        NotificationManagerCompat.from(context).notify(NOTIFICATION_ID_NIGHTLY, builder.build())
    }

    private fun nightlyCleanupPendingIntent(context: Context): PendingIntent {
        val intent = Intent(context, NightlyCleanupReceiver::class.java)
        return PendingIntent.getBroadcast(
            context,
            REQUEST_CODE_NIGHTLY,
            intent,
            FLAG_UPDATE_CURRENT or FLAG_IMMUTABLE,
        )
    }

    private fun scheduleNightlyReminder(pendingIntent: PendingIntent) {
        val calendar = java.util.Calendar.getInstance().apply {
            set(java.util.Calendar.HOUR_OF_DAY, 22)
            set(java.util.Calendar.MINUTE, 0)
            set(java.util.Calendar.SECOND, 0)
            set(java.util.Calendar.MILLISECOND, 0)
            if (timeInMillis <= System.currentTimeMillis()) {
                add(java.util.Calendar.DATE, 1)
            }
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            alarmManager.setExactAndAllowWhileIdle(
                AlarmManager.RTC_WAKEUP,
                calendar.timeInMillis,
                pendingIntent,
            )
        } else {
            alarmManager.setExact(
                AlarmManager.RTC_WAKEUP,
                calendar.timeInMillis,
                pendingIntent,
            )
        }
    }

    private fun saveProfile(profile: PerformanceProfile) {
        prefs.edit()
            .putString(KEY_LAST_PERFORMANCE, profile.performance)
            .putString(KEY_LAST_NETWORK, profile.network)
            .putFloat(KEY_LAST_BRIGHTNESS, profile.brightness.toFloat())
            .putBoolean(KEY_LIMIT_BACKGROUND, profile.limitBackgroundApps)
            .putBoolean(KEY_ADAPTIVE_BATTERY, profile.adaptiveBattery)
            .apply()
    }

    private fun maybeApplyBrightness(profile: PerformanceProfile) {
        if (!Settings.System.canWrite(context)) {
            return
        }
        val normalized = min(1.0, max(0.05, profile.brightness))
        val value = (normalized * 255).roundToInt().coerceIn(10, 255)
        Settings.System.putInt(
            context.contentResolver,
            Settings.System.SCREEN_BRIGHTNESS,
            value,
        )
    }

    private fun ensureNotificationChannel() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val manager = context.getSystemService(NotificationManager::class.java)
        if (manager.getNotificationChannel(CHANNEL_ID) != null) return
        val channel = NotificationChannel(
            CHANNEL_ID,
            "Otimizacoes Game Master",
            NotificationManager.IMPORTANCE_DEFAULT,
        )
        manager.createNotificationChannel(channel)
    }

    companion object {
        private const val PREFS_NAME = "gm_plus_prefs"
        private const val KEY_UNLOCK_OPTIMIZE = "unlock_optimize"
        private const val KEY_NIGHTLY_CLEANUP = "nightly_cleanup"
        private const val KEY_LAST_PERFORMANCE = "last_performance"
        private const val KEY_LAST_NETWORK = "last_network"
        private const val KEY_LAST_BRIGHTNESS = "last_brightness"
        private const val KEY_LIMIT_BACKGROUND = "limit_background"
        private const val KEY_ADAPTIVE_BATTERY = "adaptive_battery"

        private const val CHANNEL_ID = "gmplus_optimization"
        private const val REQUEST_CODE_NIGHTLY = 2010
        private const val NOTIFICATION_ID_NIGHTLY = 4010
    }
}





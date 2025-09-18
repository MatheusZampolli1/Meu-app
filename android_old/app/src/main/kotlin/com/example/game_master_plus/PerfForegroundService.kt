package com.example.game_master_plus

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.os.PowerManager
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat
import com.example.game_master_plus.R

private const val CHANNEL_ID = "fluxon_perf"
private const val NOTIFICATION_ID = 2221
private const val LOCK_TAG = "Fluxon:PerfWakeLock"
private const val WAKE_LOCK_TIMEOUT_MS = 10 * 60 * 1000L
private const val RENEW_INTERVAL_MS = 9 * 60 * 1000L

class PerfForegroundService : Service() {
    private var wakeLock: PowerManager.WakeLock? = null
    private val handler = Handler(Looper.getMainLooper())
    private val renewRunnable = Runnable { renewWakeLock() }

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
        val notification: Notification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle(resolveAppName())
            .setContentText("Fluxon performance mode active")
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .build()
        startForeground(NOTIFICATION_ID, notification)
        acquireWakeLock()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        renewWakeLock()
        return START_STICKY
    }

    override fun onDestroy() {
        handler.removeCallbacks(renewRunnable)
        releaseWakeLock()
        stopForeground(STOP_FOREGROUND_REMOVE)
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null

    private fun acquireWakeLock() {
        if (wakeLock?.isHeld == true) {
            wakeLock?.acquire(WAKE_LOCK_TIMEOUT_MS)
            scheduleRenewal()
            return
        }
        val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager
        wakeLock = powerManager.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, LOCK_TAG).apply {
            setReferenceCounted(false)
            acquire(WAKE_LOCK_TIMEOUT_MS)
        }
        scheduleRenewal()
    }

    private fun renewWakeLock() {
        wakeLock?.let {
            if (!it.isHeld) {
                acquireWakeLock()
                return
            }
            it.acquire(WAKE_LOCK_TIMEOUT_MS)
        } ?: acquireWakeLock()
        scheduleRenewal()
    }

    private fun scheduleRenewal() {
        handler.removeCallbacks(renewRunnable)
        handler.postDelayed(renewRunnable, RENEW_INTERVAL_MS)
    }

    private fun releaseWakeLock() {
        wakeLock?.let {
            if (it.isHeld) {
                it.release()
            }
        }
        wakeLock = null
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            if (manager.getNotificationChannel(CHANNEL_ID) == null) {
                val channel = NotificationChannel(
                    CHANNEL_ID,
                    "Fluxon Performance",
                    NotificationManager.IMPORTANCE_LOW,
                ).apply {
                    description = "Keeps Fluxon performance mode active"
                    setShowBadge(false)
                }
                manager.createNotificationChannel(channel)
            }
        }
    }

    private fun resolveAppName(): String {
        return try {
            val label = packageManager?.getApplicationLabel(applicationInfo)
            label?.toString() ?: "Fluxon"
        } catch (error: Exception) {
            "Fluxon"
        }
    }

    companion object {
        fun start(context: Context) {
            val intent = Intent(context, PerfForegroundService::class.java)
            ContextCompat.startForegroundService(context, intent)
        }

        fun stop(context: Context) {
            val intent = Intent(context, PerfForegroundService::class.java)
            context.stopService(intent)
        }
    }
}

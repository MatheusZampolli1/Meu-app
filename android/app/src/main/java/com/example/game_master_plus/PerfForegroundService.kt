package com.example.game_master_plus

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Intent
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat

/**
 * Serviço em foreground responsável por executar otimizações rápidas
 * e manter o app estável durante o processo.
 */
class PerfForegroundService : Service() {

    companion object {
        private const val CHANNEL_ID = "perf_optimize_channel"
        private const val NOTIFICATION_ID = 2024
    }

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        // 🔔 Notificação que será exibida enquanto o serviço roda
        val notification: Notification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Fluxon")
            .setContentText("Otimizando seu dispositivo...")
            .setSmallIcon(R.mipmap.ic_launcher)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setOngoing(true)
            .build()

        // Inicia como serviço em foreground
        startForeground(NOTIFICATION_ID, notification)

        // Simula tarefa de otimização
        Thread {
            try {
                Thread.sleep(3000) // ⏳ 3 segundos de simulação
            } catch (e: InterruptedException) {
                e.printStackTrace()
            }
            stopSelf() // encerra o serviço
        }.start()

        return START_NOT_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? = null

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val serviceChannel = NotificationChannel(
                CHANNEL_ID,
                "Otimização do dispositivo",
                NotificationManager.IMPORTANCE_HIGH
            )
            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(serviceChannel)
        }
    }
}

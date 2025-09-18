package com.example.game_master_plus

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.WorkManager

class UnlockReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == Intent.ACTION_USER_PRESENT) {
            Log.d("UnlockReceiver", "Tela desbloqueada - agendando otimização")

            val work = OneTimeWorkRequestBuilder<NightlyCleanupWorker>().build()
            WorkManager.getInstance(context).enqueue(work)
        }
    }
}

package com.example.game_master_plus.optimization

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class NightlyCleanupReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent?) {
        val manager = SystemOptimizationManager(context.applicationContext)
        manager.handleNightlyReminder()
        // schedule the next reminder explicitly after firing
        manager.setNightlyCleanupEnabled(true)
    }
}

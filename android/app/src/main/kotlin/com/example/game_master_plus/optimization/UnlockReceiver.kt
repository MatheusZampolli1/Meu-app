package com.example.game_master_plus.optimization

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class UnlockReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent?) {
        val manager = SystemOptimizationManager(context.applicationContext)
        manager.handleUnlockEvent()
    }
}

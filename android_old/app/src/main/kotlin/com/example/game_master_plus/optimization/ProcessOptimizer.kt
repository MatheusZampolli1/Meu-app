package com.example.game_master_plus.optimization

import android.app.ActivityManager
import android.content.Context
import android.os.Build

object ProcessOptimizer {
    fun trimBackgroundProcesses(context: Context) {
        val activityManager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            activityManager.appTasks.forEach { task ->
                try {
                    task.finishAndRemoveTask()
                } catch (_: SecurityException) {
                    // ignore if we cannot close the task
                }
            }
        }
        val runningProcesses = activityManager.runningAppProcesses ?: return
        for (process in runningProcesses) {
            if (process.processName == context.packageName) continue
            if (process.importance > ActivityManager.RunningAppProcessInfo.IMPORTANCE_VISIBLE) {
                try {
                    activityManager.killBackgroundProcesses(process.processName)
                } catch (_: SecurityException) {
                    // ignore when we don't have permission
                }
            }
        }
    }
}

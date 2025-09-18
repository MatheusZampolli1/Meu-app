package com.example.game_master_plus;

import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Environment;
import android.os.StatFs;

import java.io.File;
import java.io.RandomAccessFile;
import java.io.IOException;

import java.util.HashMap;
import java.util.Map;

public class SystemMetrics {

    private final Context context;

    public SystemMetrics(Context context) {
        this.context = context;
    }

    // Metodo para obter todas as metricas do sistema
    public Map<String, Object> getSystemMetrics() {
        Map<String, Object> metrics = new HashMap<>();
        metrics.put("cpuUsage", getCpuUsage());
        metrics.put("ramUsage", getRamUsage());
        metrics.put("storageFree", getFreeStorage());
        metrics.put("temperature", getDeviceTemperature());
        metrics.put("batteryLevel", getBatteryLevel());
        return metrics;
    }

    // Metodo para obter o uso da CPU
    private double getCpuUsage() {
        try {
            RandomAccessFile reader = new RandomAccessFile("/proc/stat", "r");
            String load = reader.readLine();

            String[] toks = load.split(" ");

            long idle1 = Long.parseLong(toks[5]);
            long cpu1 = Long.parseLong(toks[2]) + Long.parseLong(toks[3]) + Long.parseLong(toks[4])
                    + Long.parseLong(toks[6]) + Long.parseLong(toks[7]) + Long.parseLong(toks[8]);

            try {
                Thread.sleep(360);
            } catch (Exception e) {
            }

            reader.seek(0);
            load = reader.readLine();
            reader.close();

            toks = load.split(" ");

            long idle2 = Long.parseLong(toks[5]);
            long cpu2 = Long.parseLong(toks[2]) + Long.parseLong(toks[3]) + Long.parseLong(toks[4])
                    + Long.parseLong(toks[6]) + Long.parseLong(toks[7]) + Long.parseLong(toks[8]);

            return (double)(cpu2 - cpu1) / ((cpu2 + idle2) - (cpu1 + idle1)) * 100.0;

        } catch (IOException ex) {
            ex.printStackTrace();
        }

        return 0; // Retorna 0 em caso de erro
    }

    // Metodo para obter o uso da RAM
    private double getRamUsage() {
        // Implementar codigo nativo para obter o uso real da RAM
        return 0; // Placeholder
    }

    // Metodo para obter o armazenamento livre
    private double getFreeStorage() {
        StatFs stat = new StatFs(Environment.getExternalStorageDirectory().getPath());
        long bytesAvailable = (long) stat.getBlockSizeLong() * (long) stat.getAvailableBlocksLong();
        return bytesAvailable / (1024.0 * 1024.0 * 1024.0);
    }

    // Metodo para obter a temperatura do dispositivo
    private double getDeviceTemperature() {
        // Implementar codigo nativo para obter a temperatura real
        return 0; // Placeholder
    }

    // Metodo para obter o nivel da bateria
private int getBatteryLevel() {
    IntentFilter ifilter = new IntentFilter(Intent.ACTION_BATTERY_CHANGED);
    Intent batteryStatus = context.registerReceiver(null, ifilter);
    int level = batteryStatus.getIntExtra(BatteryManager.EXTRA_LEVEL, -1);
    int scale = batteryStatus.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
    return (int) (level / (float) scale * 100);
}
    
}

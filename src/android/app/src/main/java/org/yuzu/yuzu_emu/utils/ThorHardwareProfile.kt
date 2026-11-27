// SPDX-FileCopyrightText: Copyright 2026 Eden SX2A
// SPDX-License-Identifier: GPL-3.0-or-later

package org.yuzu.yuzu_emu.utils

import android.app.ActivityManager
import android.content.Context
import android.os.Build
import androidx.preference.PreferenceManager
import org.yuzu.yuzu_emu.features.settings.model.BooleanSetting
import org.yuzu.yuzu_emu.features.settings.model.IntSetting

/**
 * Detects AYN Thor Base (≈8 GB) / Pro (≈12 GB) and applies SX2A defaults once.
 * Does not rewrite user-changed settings after the first apply.
 */
object ThorHardwareProfile {
    // v2: reclaim only after Free + single pacing authority (Alpha 0.2).
    private const val PREF_APPLIED = "sx2a_thor_profile_applied_v2"

    enum class DeviceClass {
        THOR_PRO,
        THOR_BASE,
        OTHER
    }

    data class Profile(
        val deviceClass: DeviceClass,
        val totalMemMb: Long,
        val recommendedFramePacing: Int, // FramePacingMode ordinal
        val recommendedPipelineWorkers: Int,
        val releaseHostBacking: Boolean
    )

    fun detect(context: Context): Profile {
        val am = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val mi = ActivityManager.MemoryInfo()
        am.getMemoryInfo(mi)
        val totalMb = mi.totalMem / (1024L * 1024L)
        val isThor = Build.MANUFACTURER.equals("AYN", ignoreCase = true) &&
            (Build.MODEL.contains("Thor", ignoreCase = true) ||
                Build.DEVICE.equals("kalama", ignoreCase = true))
        val deviceClass = when {
            !isThor -> DeviceClass.OTHER
            totalMb in 7000..9500 -> DeviceClass.THOR_BASE
            totalMb >= 9500 -> DeviceClass.THOR_PRO
            else -> DeviceClass.OTHER
        }
        return when (deviceClass) {
            DeviceClass.THOR_BASE -> Profile(
                deviceClass = deviceClass,
                totalMemMb = totalMb,
                recommendedFramePacing = 1, // Target_30
                recommendedPipelineWorkers = 1,
                releaseHostBacking = true
            )
            DeviceClass.THOR_PRO -> Profile(
                deviceClass = deviceClass,
                totalMemMb = totalMb,
                recommendedFramePacing = 1, // Target_30
                recommendedPipelineWorkers = 2,
                releaseHostBacking = true
            )
            DeviceClass.OTHER -> Profile(
                deviceClass = deviceClass,
                totalMemMb = totalMb,
                recommendedFramePacing = 1,
                recommendedPipelineWorkers = 2,
                releaseHostBacking = true
            )
        }
    }

    /** Apply Thor SX2A defaults only once per install/data. */
    fun applyDefaultsOnce(context: Context) {
        val prefs = PreferenceManager.getDefaultSharedPreferences(context)
        if (prefs.getBoolean(PREF_APPLIED, false)) {
            return
        }
        val profile = detect(context)
        if (profile.deviceClass == DeviceClass.OTHER) {
            // Still mark applied so we do not keep probing; Android default Target_30 already set in native.
            prefs.edit().putBoolean(PREF_APPLIED, true).apply()
            Log.info("[SX2A] Hardware profile OTHER (${profile.totalMemMb} MB); native Android defaults keep 30 FPS pacing")
            return
        }
        try {
            IntSetting.FRAME_PACING_MODE.setInt(profile.recommendedFramePacing)
            IntSetting.ANDROID_PIPELINE_WORKERS.setInt(profile.recommendedPipelineWorkers)
            BooleanSetting.RELEASE_HOST_BACKING.setBoolean(profile.releaseHostBacking)
            NativeConfig.saveGlobalConfig()
            Log.info(
                "[SX2A] Applied ${profile.deviceClass} profile: " +
                    "mem=${profile.totalMemMb}MB pacing=${profile.recommendedFramePacing} " +
                    "workers=${profile.recommendedPipelineWorkers}"
            )
        } catch (t: Throwable) {
            Log.warning("[SX2A] Failed to apply Thor profile: ${t.message}")
        }
        prefs.edit().putBoolean(PREF_APPLIED, true).apply()
    }
}

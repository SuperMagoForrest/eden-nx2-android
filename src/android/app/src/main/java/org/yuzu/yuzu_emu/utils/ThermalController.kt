// SPDX-FileCopyrightText: Copyright 2026 Eden SX2A
// SPDX-License-Identifier: GPL-3.0-or-later

package org.yuzu.yuzu_emu.utils

import android.content.Context
import android.os.Build
import android.os.PowerManager
import org.yuzu.yuzu_emu.features.settings.model.IntSetting

/**
 * Progressive thermal adaptation for Thor lab policy.
 * Adjusts reconstructible knobs only (pipeline workers). Does not change emulation speed %.
 *
 * Note: pipeline_worker_count is read when the Vulkan pipeline cache is created (game start).
 * Mid-session changes apply on the next emulation launch; frame pacing remains the live throttle.
 */
object ThermalController {
    enum class State {
        NORMAL,
        WARM,
        PRESSURE,
        THERMAL_CONSTRAINED,
        RECOVERY
    }

    @Volatile
    var state: State = State.NORMAL
        private set

    private var baselineWorkers: Int? = null
    private var lastLogState: State? = null

    fun poll(context: Context) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {
            return
        }
        val pm = context.getSystemService(Context.POWER_SERVICE) as? PowerManager ?: return
        val status = pm.currentThermalStatus
        val next = when {
            status >= PowerManager.THERMAL_STATUS_SEVERE -> State.THERMAL_CONSTRAINED
            status >= PowerManager.THERMAL_STATUS_MODERATE -> State.PRESSURE
            status >= PowerManager.THERMAL_STATUS_LIGHT -> State.WARM
            state == State.THERMAL_CONSTRAINED || state == State.PRESSURE -> State.RECOVERY
            else -> State.NORMAL
        }
        if (next != state) {
            apply(next)
            state = next
        } else if (state == State.RECOVERY && status <= PowerManager.THERMAL_STATUS_NONE) {
            apply(State.NORMAL)
            state = State.NORMAL
        }
    }

    private fun apply(next: State) {
        if (baselineWorkers == null) {
            baselineWorkers = IntSetting.ANDROID_PIPELINE_WORKERS.getInt()
        }
        val base = baselineWorkers ?: 2
        val workers = when (next) {
            State.NORMAL, State.RECOVERY -> base
            State.WARM -> maxOf(1, base)
            State.PRESSURE -> maxOf(1, base - 1)
            State.THERMAL_CONSTRAINED -> 1
        }
        try {
            IntSetting.ANDROID_PIPELINE_WORKERS.setInt(workers)
            if (next != lastLogState) {
                Log.info("[SX2A] Thermal state=$next pipeline_workers=$workers")
                lastLogState = next
            }
        } catch (t: Throwable) {
            Log.warning("[SX2A] ThermalController apply failed: ${t.message}")
        }
    }
}

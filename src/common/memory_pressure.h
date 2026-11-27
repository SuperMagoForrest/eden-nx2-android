// SPDX-FileCopyrightText: Copyright 2026 Eden SX2A
// SPDX-License-Identifier: GPL-3.0-or-later

#pragma once

#include <atomic>
#include "common/common_types.h"

namespace Common {

/// Host OS memory pressure hint (Android onTrimMemory / future sources).
/// 0 = none, 1 = moderate, 2 = low, 3 = critical. Does not kill threads or bypass LMKD.
enum class MemoryPressureLevel : u8 {
    None = 0,
    Moderate = 1,
    Low = 2,
    Critical = 3,
};

inline std::atomic<u8>& MemoryPressureState() {
    static std::atomic<u8> level{0};
    return level;
}

inline void SetMemoryPressureLevel(MemoryPressureLevel level) {
    MemoryPressureState().store(static_cast<u8>(level), std::memory_order_relaxed);
}

inline MemoryPressureLevel GetMemoryPressureLevel() {
    return static_cast<MemoryPressureLevel>(
        MemoryPressureState().load(std::memory_order_relaxed));
}

/// True for Moderate+. Callers should scale aggressiveness by GetMemoryPressureLevel().
inline bool MemoryPressureElevated() {
    return GetMemoryPressureLevel() >= MemoryPressureLevel::Moderate;
}

inline bool MemoryPressureCritical() {
    return GetMemoryPressureLevel() >= MemoryPressureLevel::Low;
}

} // namespace Common

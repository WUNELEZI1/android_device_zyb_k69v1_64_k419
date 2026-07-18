#
# Copyright (C) 2024 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Silence the Android 12 deprecation warning emitted by
# build/make/core/soong_config.mk and system/sepolicy/Android.mk:
#   "BOARD_PLAT_PUBLIC_SEPOLICY_DIR has been deprecated.
#    Use SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS instead."
#
# TWRP's vendor/twrp/config/common.mk (inherited by twrp_k69v1_64_k419.mk)
# still assigns the legacy BOARD_PLAT_*_SEPOLICY_DIR vars. We migrate them to
# the A12+ SYSTEM_EXT_*_SEPOLICY_DIRS equivalents so the original sepolicy
# paths are still included, just under the modern variable name.
#
# WHY THIS IS A SEPARATE FILE:
# $(call inherit-product, ...) DEFERS the inclusion of common.mk. If this
# logic were inlined in twrp_k69v1_64_k419.mk it would run *before* common.mk
# had set the vars (so the ifneq would be false and nothing would happen).
# By inheriting this file *after* common.mk, it executes once the deprecated
# vars are already populated, and clearing them here removes the warning.
#
# Guarded so it is a no-op if a future TWRP common.mk stops setting them.
ifneq ($(BOARD_PLAT_PUBLIC_SEPOLICY_DIR),)
SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS += $(BOARD_PLAT_PUBLIC_SEPOLICY_DIR)
BOARD_PLAT_PUBLIC_SEPOLICY_DIR :=
endif
ifneq ($(BOARD_PLAT_PRIVATE_SEPOLICY_DIR),)
SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += $(BOARD_PLAT_PRIVATE_SEPOLICY_DIR)
BOARD_PLAT_PRIVATE_SEPOLICY_DIR :=
endif

#
# Copyright (C) 2024 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Release name
PRODUCT_RELEASE_NAME := ZPD1203

# Inherit from the device makefile (TWRP product config is pulled in
# by vendor/twrp/config/common.mk below - do NOT add aosp_base.mk /
# core_64_bit.mk here, this is a recovery-only build).
$(call inherit-product, device/zyb/k69v1_64_k419/device.mk)

# Device identifier. This must come after all inclusions.
PRODUCT_DEVICE := k69v1_64_k419
PRODUCT_NAME := twrp_k69v1_64_k419
PRODUCT_BRAND := ZYB
PRODUCT_MODEL := ZPD1203
PRODUCT_MANUFACTURER := zyb

PRODUCT_GMS_CLIENTID_BASE := android-mediatek

# Inherit common TWRP config (provided by the TWRP minimal manifest).
$(call inherit-product, vendor/twrp/config/common.mk)

# Migrate common.mk's legacy BOARD_PLAT_*_SEPOLICY_DIR vars to the A12+
# SYSTEM_EXT_*_SEPOLICY_DIRS so the deprecation warning from
# build/make/core/soong_config.mk + system/sepolicy/Android.mk is silenced.
# Kept in a SEPARATE file inherited here (after common.mk) because
# $(call inherit-product,...) defers common.mk's inclusion - an inline
# block would run before common.mk sets the vars and do nothing.
$(call inherit-product, device/zyb/k69v1_64_k419/sepolicy_fix.mk)

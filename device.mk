#
# Copyright (C) 2024 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#
# device.mk for ZYB ZPD1203 (k69v1_64_k419) - MediaTek MT6768
#

# ============================================================
# Dynamic partitions + VNDK (Android 12 / VNDK 31)
# ============================================================
# NOTE: PRODUCT_USE_DYNAMIC_PARTITIONS and PRODUCT_SHIPPING_API_LEVEL
# are READONLY in Android 12+ and are auto-derived (from
# BOARD_SUPER_PARTITION_SIZE and PLATFORM_SDK_VERSION respectively).
# They must NOT be assigned here or in BoardConfig.mk.
PRODUCT_TARGET_VNDK_VERSION := 31
PRODUCT_VENDOR_MOVE_ENABLED := true

# ============================================================
# A/B OTA + fastbootd
# ============================================================
PRODUCT_PACKAGES += \
    android.hardware.fastboot@1.1-impl-mock \
    fastbootd

PRODUCT_PACKAGES += \
    android.hardware.boot@1.2-impl \
    android.hardware.boot@1.2-impl.recovery \
    android.hardware.boot@1.2-service

# ============================================================
# Virtual A/B with compression (device: ro.virtual_ab.compression.enabled=true)
# ============================================================
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/compression.mk)

PRODUCT_PACKAGES += \
    e2fsdroid \
    mke2fs \
    resize2fs \
    sload_f2fs \
    make_f2fs \
    fsck.f2fs

# ============================================================
# Keymaster 4.1 / Gatekeeper 1.0 (for FBE decryption in recovery)
# ============================================================
PRODUCT_PACKAGES += \
    android.hardware.gatekeeper@1.0-service \
    android.hardware.keymaster@4.1-service

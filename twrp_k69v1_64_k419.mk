#
# Copyright (C) 2025 The Android Open Source Project
# Copyright (C) 2025 SebaUbuntu's TWRP device tree generator
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := device/zyb/k69v1_64_k419

# ============================================================
# Inherit chain — order matters:
#   1. full_base_telephony provides the ramdisk skeleton, /init symlink,
#      and build infrastructure that produces /system/bin/recovery.
#      This is the critical fix: without it, the recovery binary is not
#      built and the boot.img boots to black screen → fastboot.
#   2. core_64_bit provides 64-bit ABI settings.
#   3. common.mk brings TWRP themes, tools, default apps.
#   4. device.mk provides device-specific packages and copy rules.
# ============================================================
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, vendor/twrp/config/common.mk)
$(call inherit-product, device/zyb/k69v1_64_k419/device.mk)

# ============================================================
# Product identifiers
# ============================================================
PRODUCT_DEVICE := k69v1_64_k419
PRODUCT_NAME := twrp_k69v1_64_k419
PRODUCT_BRAND := ZYB
PRODUCT_MODEL := ZPD1203
PRODUCT_MANUFACTURER := zyb

PRODUCT_GMS_CLIENTID_BASE := android-zyb

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="full_k69v1_64_k419-user 12 SP1A.210812.016 730_731_732-112 release-keys"

BUILD_FINGERPRINT := ZYB/full_k69v1_64_k419/k69v1_64_k419:12/SP1A.210812.016/730_731_732-112:user/release-keys

# ============================================================
# Force recovery binary into the build (belt-and-suspenders)
# ============================================================
PRODUCT_PACKAGES += \
    recovery

# ============================================================
# Recovery fstab (explicit, ensures it lands in ramdisk)
# ============================================================
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/recovery/root/system/etc/recovery.fstab:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/recovery.fstab

# ============================================================
# USB configuration for recovery
# ============================================================
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.adb.secure=0 \
    ro.secure=0 \
    persist.sys.usb.config=adb \
    persist.service.adb.enable=1
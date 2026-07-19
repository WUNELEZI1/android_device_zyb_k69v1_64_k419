#
# Copyright (C) 2024 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Release name
PRODUCT_RELEASE_NAME := ZPD1203

# ============================================================
# Base products -- REQUIRED for a bootable recovery ramdisk.
# ============================================================
# core_64_bit.mk + aosp_base.mk provide the core system binaries that the
# recovery-in-boot ramdisk must contain: /init (-> /system/bin/init),
# /system/bin/sh, the dynamic linker (linker64/linker), libc, and they bring
# the recovery module into the build graph so the TWRP binary gets built.
#
# ROOT CAUSE OF THE BOOTLOOP (CI build 7835d30): without these base products
# the recovery ramdisk was assembled from ONLY the device.mk packages
# (fastbootd/snapuserd/...). It had no real /init, no sh/linker/libc and no
# recovery binary, so the kernel could not exec init and panicked -> reboot
# loop. This mirrors the known-good omni_k69v1_64_k419.mk, which inherited
# exactly core_64_bit.mk + aosp_base.mk (plus device.mk).
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_base.mk)

# Inherit from the device makefile (TWRP-specific HALs / ramdisk staging).
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

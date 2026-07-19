#
# Copyright (C) 2024 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Release name
PRODUCT_RELEASE_NAME := ZPD1203

# ============================================================
# Base product -- REQUIRED for a bootable recovery ramdisk.
# ============================================================
# core_64_bit.mk provides the core 64-bit system binaries the recovery-in-boot
# ramdisk must contain: /init (-> /system/bin/init), /system/bin/sh, the
# dynamic linker (linker64), libc, and it brings the `recovery` module's
# dependencies into the build graph so the TWRP binary gets built.
#
# We deliberately do NOT inherit aosp_base.mk: it pulls in the full AOSP
# system daemon/app set, which blew the 32 MB boot-partition limit
# (CI build with aosp_base => boot.img 37412864 > 33554432 -> mkbootimg fail).
# core_64_bit.mk is the lean 64-bit core and is sufficient for recovery.
#
# ROOT CAUSE OF THE BOOTLOOP (CI build 7835d30): the product mk only inherited
# device.mk + vendor/twrp/config/common.mk and omitted the base product, so the
# recovery ramdisk had no real /init, no sh/linker/libc and no recovery binary;
# the kernel could not exec init and panicked -> reboot loop. This mirrors the
# known-good omni_k69v1_64_k419.mk, which inherited core_64_bit.mk (+aosp_base).
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)

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

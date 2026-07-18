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

# Force the generic ramdisk (out/target/product/<dev>/root) to be staged.
# The TWRP recovery-ramdisk recipe (INTERNAL_RECOVERY_RAMDISK_FILES_TIMESTAMP
# in build/make core/Makefile) rsyncs FROM $(PRODUCT_OUT)/root. That directory
# is only created when BUILDING_RAMDISK_IMAGE is true, which derives from
# PRODUCT_BUILD_RAMDISK_IMAGE. The inherited TWRP config leaves it false, so the
# build fails at ~99% with: rsync ... /root ... "No such file or directory".
# Force it true HERE (after the common.mk inherit) so it overrides any := set
# earlier in the inheritance chain.
PRODUCT_BUILD_RAMDISK_IMAGE := true

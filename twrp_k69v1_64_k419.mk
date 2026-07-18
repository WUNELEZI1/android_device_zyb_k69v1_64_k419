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

# Silence the A12 deprecation warning that TWRP's common.mk triggers by
# still assigning the legacy BOARD_PLAT_*_SEPOLICY_DIR vars. Migrate them
# to the A12+ equivalents recommended by build/make/core/soong_config.mk.
# (Guarded so it is a no-op if common.mk stops setting them; and it keeps
# the original sepolicy paths included, just under the modern variable.)
ifneq ($(BOARD_PLAT_PUBLIC_SEPOLICY_DIR),)
SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS += $(BOARD_PLAT_PUBLIC_SEPOLICY_DIR)
BOARD_PLAT_PUBLIC_SEPOLICY_DIR :=
endif
ifneq ($(BOARD_PLAT_PRIVATE_SEPOLICY_DIR),)
SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += $(BOARD_PLAT_PRIVATE_SEPOLICY_DIR)
BOARD_PLAT_PRIVATE_SEPOLICY_DIR :=
endif

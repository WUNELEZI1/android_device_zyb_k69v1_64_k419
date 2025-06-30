#
# Copyright (C) 2025 The Android Open Source Project
# Copyright (C) 2025 SebaUbuntu's TWRP device tree generator
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit some common Omni stuff.
$(call inherit-product, vendor/omni/config/common.mk)

# Inherit from k69v1_64_k419 device
$(call inherit-product, device/zyb/k69v1_64_k419/device.mk)

PRODUCT_DEVICE := k69v1_64_k419
PRODUCT_NAME := omni_k69v1_64_k419
PRODUCT_BRAND := ZYB
PRODUCT_MODEL := ZPD1203
PRODUCT_MANUFACTURER := zyb

PRODUCT_GMS_CLIENTID_BASE := android-zyb

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="full_k69v1_64_k419-user 12 SP1A.210812.016 730_731_732-61 release-keys"

BUILD_FINGERPRINT := ZYB/full_k69v1_64_k419/k69v1_64_k419:12/SP1A.210812.016/730_731_732-61:user/release-keys

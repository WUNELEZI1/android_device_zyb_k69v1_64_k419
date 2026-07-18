# Copyright (C) 2024 ZYB
# SPDX-License-Identifier: Apache-2.0

PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_TARGET_VNDK_VERSION := 33

PRODUCT_PACKAGES += \
    android.hardware.fastboot@1.0-impl-mock \
    fastbootd

$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)

PRODUCT_SHIPPING_API_LEVEL := 31
PRODUCT_VENDOR_MOVE_ENABLED := true

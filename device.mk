#
# Copyright (C) 2025 The Android Open Source Project
# Copyright (C) 2025 SebaUbuntu's TWRP device tree generator
#
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := device/zyb/k69v1_64_k419
# A/B
AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=ext4 \
    POSTINSTALL_OPTIONAL_system=true

# Boot control HAL
PRODUCT_PACKAGES += \
    android.hardware.boot@1.0-impl \
    android.hardware.boot@1.0-service \
    android.hardware.boot@1.0.recovery \
    bootctrl.mt6768 \
    bootctrl.mt6768.recovery 


PRODUCT_PACKAGES += \
    bootctrl
PRODUCT_PACKAGES += \
    vold \
    libvolddecrypt \
    libcryptfs_hw \
    qseecomd  
PRODUCT_PACKAGES += \
    mtk_tee_client \
    libtz_uree \
    liburee_meta_drmkeyinstall \
    mtk_sec \
    mtk_sec_hal
PRODUCT_PACKAGES += \
    libmtk_cryptfs \
    mtk_cryptfsd \
    mtk_keymaster_client \
    mtk_keymaster_service
PRODUCT_PACKAGES += \
    libvoldmtk \
    mtk_vold
PRODUCT_PACKAGES += \
    android.hardware.keymaster@4.0-service.mediatek \
    android.hardware.keymaster@4.0-impl.mediatek \
    libmtk_keymaster4_device \
    libmtk_keymaster4_helper
PRODUCT_PACKAGES += \
    otapreopt_script \
    cppreopts.sh \
    update_engine \
    update_verifier \
    update_engine_sideload

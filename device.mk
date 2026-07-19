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
    android.hardware.boot@1.2-service

# ============================================================
# Virtual A/B with compression (device: ro.virtual_ab.compression.enabled=true)
# ============================================================
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/compression.mk)

# ext4 tools (needed: /data and several partitions are ext4, used by TWRP
# backup/restore/format). The f2fs tools (sload_f2fs / make_f2fs / fsck.f2fs)
# are dropped: this device has no f2fs userdata/partition, they only bloat the
# recovery ramdisk. Every KB counts against the 32 MB boot-partition limit.
PRODUCT_PACKAGES += \
    e2fsdroid \
    mke2fs \
    resize2fs

# snapuserd: userspace daemon for Virtual A/B (VABC) snapshot management.
# Required so TWRP can flash/rollback the dynamic (super) partitions on this
# device (ro.virtual_ab.compression.enabled=true). Source is present in the
# minimal TWRP manifest (system/core/fs_mgr); the build log confirms
# libsnapshot_nobinder is already compiled.
PRODUCT_PACKAGES += \
    snapuserd

# ============================================================
# Keymaster 4.1 / Gatekeeper 1.0 (for FBE decryption in recovery)
# ============================================================
PRODUCT_PACKAGES += \
    android.hardware.gatekeeper@1.0-service \
    android.hardware.keymaster@4.1-service

# Health HAL, started by init.recovery.mt6768.rc ("start health-hal-2-1").
PRODUCT_PACKAGES += \
    android.hardware.health@2.1-service

# bootctrl for A/B slot switching from recovery (Switch Slot).
PRODUCT_PACKAGES += \
    bootctrl

# ============================================================
# Recovery ramdisk baseline -> /root
# ============================================================
# The TWRP recovery-ramdisk recipe (core/Makefile
# $(INTERNAL_RECOVERY_RAMDISK_FILES_TIMESTAMP)) does an unconditional
#   rsync -a $(TARGET_ROOT_OUT) $(TARGET_RECOVERY_OUT)
# i.e. it copies out/target/product/<dev>/root into the recovery root.
# In a recovery-only TWRP tree (recovery-in-boot, dynamic partitions)
# nothing else installs to $(TARGET_ROOT_OUT), so /root is never created
# and the rsync fails with: rsync ... /root ... "No such file or directory".
# Staging the recovery baseline here makes /root exist; the device
# recovery/root (copied by the recipe afterwards) overrides it, so the
# exact content below is irrelevant -- only /root's existence matters.
PRODUCT_COPY_FILES += \
    device/zyb/k69v1_64_k419/recovery/root/init.recovery.mt6768.rc:root/init.recovery.mt6768.rc \
    device/zyb/k69v1_64_k419/recovery/root/init.recovery.usb.rc:root/init.recovery.usb.rc \
    device/zyb/k69v1_64_k419/recovery/root/ueventd.mt6768.rc:root/ueventd.mt6768.rc \
    device/zyb/k69v1_64_k419/recovery/root/system/etc/recovery.fstab:root/system/etc/recovery.fstab

# ============================================================
# Critical missing binaries (fix bootloop + enable decryption)
# ============================================================
# linker64 (64-bit dynamic linker): the recovery ramdisk /init ->
# /system/bin/init is a dynamically-linked ELF whose PT_INTERP is
# /system/bin/linker64. Without linker64 the kernel cannot exec
# /init -> kernel panic -> black-screen bootloop. The minimal TWRP
# manifest does not build bionic's linker into the recovery ramdisk,
# so we stage the prebuilt (from a known-good TWRP for this SoC).
# keymaster@4.1 / gatekeeper@1.0: declared in PRODUCT_PACKAGES above
# but source is absent from the minimal manifest and silently skipped
# under ALLOW_MISSING_DEPENDENCIES=true. Both are dynamically linked
# (interpreter /system/bin/linker64) and required for FBE data
# decryption in recovery. Providing prebuilts here fixes both.
# These ELF binaries are installed as proper prebuilt modules (BUILD_PREBUILT,
# defined at the end of this file) into $(TARGET_ROOT_OUT). The recovery build
# REJECTS ELF files staged via PRODUCT_COPY_FILES into the ramdisk
# (check-non-elf-file-timestamps); prebuilt modules are the correct mechanism.
PRODUCT_PACKAGES += \
    twrp_linker64 \
    twrp_recovery_sh \
    twrp_keymaster41_service \
    twrp_gatekeeper10_service \
    twrp_gatekeeper10_impl \
    twrp_gatekeeper_default \
    twrp_libsoftgatekeeper

# ============================================================
# Boot HAL backend (passthrough impl) for A/B slot switching
# ============================================================
# android.hardware.boot@1.2-service dlopens android.hardware.boot@1.0-impl-1.2.so
# at runtime to provide IBootControl. The minimal TWRP manifest does NOT build
# this device-specific impl (skipped under ALLOW_MISSING_DEPENDENCIES), so we
# stage the prebuilt pulled from a known-good TWRP for this SoC. Without it the
# boot HAL service cannot provide IBootControl and TWRP cannot switch the active
# A/B slot (Reboot -> System fails -> always returns to recovery).
# Boot HAL passthrough impl is installed as a prebuilt module (twrp_boot_impl_12)
# below, also because ELF files cannot go through PRODUCT_COPY_FILES.
PRODUCT_PACKAGES += twrp_boot_impl_12

# ============================================================
# Recovery binary (TWRP/recovery executable)
# ============================================================
# Explicitly request the recovery module. It is installed at
# /system/bin/recovery (launched by init via init.recovery.*.rc) and is what
# actually presents the TWRP UI. The build system also auto-adds it when
# TARGET_NO_RECOVERY is unset, but listing it here keeps the dependency
# explicit and stops it being silently dropped under
# ALLOW_MISSING_DEPENDENCIES=true.
PRODUCT_PACKAGES += \
    recovery
# ============================================================
# Prebuilt ELF modules for the recovery ramdisk
# ============================================================
# Installed into $(TARGET_ROOT_OUT) (the ramdisk root) via BUILD_PREBUILT. The
# recovery-ramdisk recipe rsyncs $(TARGET_ROOT_OUT) into the recovery root, so
# these land in the final recovery/boot ramdisk. We must use proper prebuilt
# modules (not PRODUCT_COPY_FILES) because the build rejects ELF files placed
# into the ramdisk via PRODUCT_COPY_FILES (check-non-elf-file-timestamps).
# Source binaries live under prebuilt/ (moved out of recovery/root so the
# recovery-ramdisk recipe no longer trips the ELF check on them).

# --- linker64 (64-bit dynamic linker) ---
include $(CLEAR_VARS)
LOCAL_PATH := $(call my-dir)
LOCAL_MODULE := twrp_linker64
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT)/system/bin
LOCAL_SRC_FILES := prebuilt/system/bin/linker64
LOCAL_MODULE_STEM := linker64
LOCAL_CHECK_ELF_FILES := false
include $(BUILD_PREBUILT)

# --- sh (recovery shell) ---
include $(CLEAR_VARS)
LOCAL_PATH := $(call my-dir)
LOCAL_MODULE := twrp_recovery_sh
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT)/system/bin
LOCAL_SRC_FILES := prebuilt/system/bin/sh
LOCAL_MODULE_STEM := sh
LOCAL_CHECK_ELF_FILES := false
include $(BUILD_PREBUILT)

# --- keymaster@4.1 service binary ---
include $(CLEAR_VARS)
LOCAL_PATH := $(call my-dir)
LOCAL_MODULE := twrp_keymaster41_service
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT)/vendor/bin/hw
LOCAL_SRC_FILES := prebuilt/vendor/bin/hw/android.hardware.keymaster@4.1-service
LOCAL_MODULE_STEM := android.hardware.keymaster@4.1-service
LOCAL_CHECK_ELF_FILES := false
include $(BUILD_PREBUILT)

# --- gatekeeper@1.0 service binary ---
include $(CLEAR_VARS)
LOCAL_PATH := $(call my-dir)
LOCAL_MODULE := twrp_gatekeeper10_service
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT)/vendor/bin/hw
LOCAL_SRC_FILES := prebuilt/vendor/bin/hw/android.hardware.gatekeeper@1.0-service
LOCAL_MODULE_STEM := android.hardware.gatekeeper@1.0-service
LOCAL_CHECK_ELF_FILES := false
include $(BUILD_PREBUILT)

# --- gatekeeper@1.0 HAL impl (.so) ---
include $(CLEAR_VARS)
LOCAL_PATH := $(call my-dir)
LOCAL_MODULE := twrp_gatekeeper10_impl
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT)/vendor/lib64/hw
LOCAL_SRC_FILES := prebuilt/vendor/lib64/hw/android.hardware.gatekeeper@1.0-impl.so
LOCAL_MODULE_STEM := android.hardware.gatekeeper@1.0-impl.so
LOCAL_CHECK_ELF_FILES := false
include $(BUILD_PREBUILT)

# --- gatekeeper.default.so ---
include $(CLEAR_VARS)
LOCAL_PATH := $(call my-dir)
LOCAL_MODULE := twrp_gatekeeper_default
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT)/vendor/lib64/hw
LOCAL_SRC_FILES := prebuilt/vendor/lib64/hw/gatekeeper.default.so
LOCAL_MODULE_STEM := gatekeeper.default.so
LOCAL_CHECK_ELF_FILES := false
include $(BUILD_PREBUILT)

# --- libSoftGatekeeper.so ---
include $(CLEAR_VARS)
LOCAL_PATH := $(call my-dir)
LOCAL_MODULE := twrp_libsoftgatekeeper
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT)/vendor/lib64/hw
LOCAL_SRC_FILES := prebuilt/vendor/lib64/hw/libSoftGatekeeper.so
LOCAL_MODULE_STEM := libSoftGatekeeper.so
LOCAL_CHECK_ELF_FILES := false
include $(BUILD_PREBUILT)

# --- boot HAL passthrough impl (.so) for A/B slot switching ---
include $(CLEAR_VARS)
LOCAL_PATH := $(call my-dir)
LOCAL_MODULE := twrp_boot_impl_12
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT)/system/lib64/hw
LOCAL_SRC_FILES := prebuilt/system/lib64/hw/android.hardware.boot@1.0-impl-1.2.so
LOCAL_MODULE_STEM := android.hardware.boot@1.0-impl-1.2.so
LOCAL_CHECK_ELF_FILES := false
include $(BUILD_PREBUILT)

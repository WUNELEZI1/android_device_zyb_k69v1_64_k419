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
# A/B OTA (fastbootd removed to save space)
# ============================================================

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
# Keymaster 4.1 / Gatekeeper 1.0 — DROPPED to fit 32 MB boot limit
# FBE decryption disabled for now. Re-enable when ramdisk size allows.
# ============================================================

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
# Critical missing binaries (fix bootloop)
# ============================================================
# linker64 (64-bit dynamic linker): the recovery ramdisk /init ->
# /system/bin/init is a dynamically-linked ELF whose PT_INTERP is
# /system/bin/linker64. Without linker64 the kernel cannot exec
# /init -> kernel panic -> black-screen bootloop. The minimal TWRP
# manifest does not build bionic's linker into the recovery ramdisk,
# so we stage the prebuilt (from a known-good TWRP for this SoC).
# sh: required for shell execution in recovery (adbd shell, scripts).
# These ELF binaries are installed as proper prebuilt modules (BUILD_PREBUILT,
# defined in prebuilt/Android.mk) into $(TARGET_ROOT_OUT). The recovery build
# REJECTS ELF files staged via PRODUCT_COPY_FILES into the ramdisk
# (check-non-elf-file-timestamps); prebuilt modules are the correct mechanism.
PRODUCT_PACKAGES += \
    twrp_linker64 \
    twrp_recovery_sh

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
# Prebuilt ELF ramdisk binaries (twrp_linker64, twrp_recovery_sh,
# twrp_boot_impl_12) are defined in prebuilt/Android.mk as BUILD_PREBUILT
# modules (auto-discovered by the build). Their PRODUCT_PACKAGES entries
# above stay here; the module bodies moved there so the build reliably
# picks them up regardless of product-config parsing.

# ============================================================
# Keymaster 4.1 prebuilt modules for FBE decryption in recovery
# ============================================================
PRODUCT_PACKAGES += \
    twrp_keymaster41_service \
    twrp_keymaster41_rc \
    twrp_android.hardware.keymaster@3.0 \
    twrp_android.hardware.keymaster@4.0 \
    twrp_android.hardware.keymaster@4.1 \
    twrp_libcppbor_external \
    twrp_libcppcose_rkp \
    twrp_libkeymaster4 \
    twrp_libkeymaster41 \
    twrp_libkeymaster4_1support \
    twrp_libkeymaster4support \
    twrp_libkeymaster_messages \
    twrp_libkeymaster_portable \
    twrp_libsoft_attestation_cert \
    twrp_libpuresoftkeymasterdevice

#
# Copyright (C) 2024 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#
# BoardConfig.mk for ZYB ZPD1203 (k69v1_64_k419) - MediaTek MT6768
# Values derived from real device analysis (device_info/*).
#

DEVICE_PATH := device/zyb/k69v1_64_k419

# ============================================================
# Platform
# ============================================================
TARGET_BOARD_PLATFORM := mt6768
TARGET_BOOTLOADER_BOARD_NAME := k69v1_64_k419
TARGET_NO_BOOTLOADER := true
TARGET_USES_UEFI := false

# ============================================================
# Architecture (device is 64/32 zygote; recovery is 64-bit only)
# ============================================================
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := cortex-a75
TARGET_CPU_VARIANT_RUNTIME := cortex-a75

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a75
TARGET_2ND_CPU_VARIANT_RUNTIME := cortex-a55

# ============================================================
# Kernel (prebuilt) - boot header v2, dtb embedded in boot.img
# Confirmed: page_size=2048, cmdline & offsets from stock boot.img
# ============================================================
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/kernel
TARGET_PREBUILT_DTB := $(DEVICE_PATH)/prebuilt/dtb
BOARD_INCLUDE_DTB_IN_BOOTIMG := true

# Load addresses derived from the real stock boot.img header:
#   kernel_addr=0x40080000  ramdisk_addr=0x47c80000  tags_addr=0x4bc80000
#   dtb_addr=0x4bc80000  page_size=2048  =>  base=0x40078000
BOARD_BOOT_HEADER_VERSION := 2
BOARD_KERNEL_BASE := 0x40078000
BOARD_KERNEL_PAGESIZE := 2048
BOARD_KERNEL_OFFSET := 0x00008000
BOARD_RAMDISK_OFFSET := 0x07c08000
BOARD_KERNEL_TAGS_OFFSET := 0x0bc08000
BOARD_DTB_OFFSET := 0x0bc08000
BOARD_KERNEL_CMDLINE := bootopt=64S3,32N2,64N2 buildvariant=user

BOARD_MKBOOTIMG_ARGS += --base $(BOARD_KERNEL_BASE)
BOARD_MKBOOTIMG_ARGS += --kernel_offset $(BOARD_KERNEL_OFFSET)
BOARD_MKBOOTIMG_ARGS += --ramdisk_offset $(BOARD_RAMDISK_OFFSET)
BOARD_MKBOOTIMG_ARGS += --tags_offset $(BOARD_KERNEL_TAGS_OFFSET)
BOARD_MKBOOTIMG_ARGS += --dtb $(TARGET_PREBUILT_DTB)
BOARD_MKBOOTIMG_ARGS += --dtb_offset $(BOARD_DTB_OFFSET)
BOARD_MKBOOTIMG_ARGS += --pagesize $(BOARD_KERNEL_PAGESIZE)
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)

# ============================================================
# Partitions
# boot=32MB, dtbo=8MB (separate), vendor_boot=64MB, super=10240MB
# ============================================================
BOARD_BOOTIMAGE_PARTITION_SIZE := 33554432
BOARD_FLASH_BLOCK_SIZE := 131072

BOARD_USES_METADATA_PARTITION := true
BOARD_ROOT_EXTRA_FOLDERS += metadata

# ============================================================
# A/B (recovery lives inside boot; no dedicated recovery partition)
# ============================================================
AB_OTA_UPDATER := true
AB_OTA_PARTITIONS += \
    boot \
    vendor_boot \
    dtbo \
    system \
    system_ext \
    vendor \
    product

BOARD_USES_RECOVERY_AS_BOOT := true
TARGET_NO_RECOVERY := false

# ============================================================
# Dynamic partitions (Virtual A/B + VABC enabled on device)
# PRODUCT_USE_DYNAMIC_PARTITIONS is readonly in A12+ and is
# auto-derived from BOARD_SUPER_PARTITION_SIZE below.
# ============================================================
BOARD_SUPER_PARTITION_SIZE := 10737418240
BOARD_SUPER_PARTITION_GROUPS := main
BOARD_MAIN_SIZE := 10733223936
BOARD_MAIN_PARTITION_LIST := system system_ext vendor product

# ============================================================
# Filesystem
# ============================================================
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_SYSTEM_EXTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_SYSTEM_EXT := system_ext
TARGET_COPY_OUT_PRODUCT := product
TARGET_COPY_OUT_VENDOR := vendor
TARGET_USES_MKE2FS := true

# ============================================================
# FBE / Metadata decryption (real device: FBE v2, inline crypt)
#   contents  = aes-256-xts
#   filenames = aes-256-cts
#   policy    = v2
#   metadata  = dm-default-key (keymaster protected, NOT hw-wrapped)
# ============================================================
TW_INCLUDE_CRYPTO := true
TW_INCLUDE_CRYPTO_FBE := true
TW_INCLUDE_FBE_METADATA_DECRYPT := true
# fscrypt policy (v2) is now auto-detected by TWRP 3.7.1 ("without setting Board")
BOARD_USES_METADATA_PARTITION := true
PLATFORM_SECURITY_PATCH := 2024-01-05
PLATFORM_VERSION := 16.1.0
VENDOR_SECURITY_PATCH := 2024-01-05
TW_FORCE_KEYMASTER_VER := true
TW_PREPARE_DATA_MEDIA_EARLY := true
RECOVERY_SDCARD_ON_DATA := true

# ============================================================
# VNDK / Shipping API (Android 12 / API 31)
# ============================================================
BOARD_VNDK_VERSION := current
PRODUCT_SHIPPING_API_LEVEL := 31

# ============================================================
# Display / Theme (density confirmed = 280)
# ============================================================
TARGET_SCREEN_DENSITY := 280
TARGET_RECOVERY_PIXEL_FORMAT := "RGBX_8888"
TW_THEME := portrait_hdpi

# ============================================================
# Brightness (MTK leds-mt65xx backlight)
# ============================================================
TW_MAX_BRIGHTNESS := 255
TW_DEFAULT_BRIGHTNESS := 128
TW_BRIGHTNESS_PATH := "/sys/class/leds/lcd-backlight/brightness"

# ============================================================
# USB / MTP (controller = musb-hdrc, configfs gadget)
# ============================================================
TW_HAS_USB := true
TW_EXCLUDE_DEFAULT_USB_INIT := true
TARGET_USE_CUSTOM_LUN_FILE_PATH := /config/usb_gadget/g1/functions/mass_storage.0/lun.%d/file

# ============================================================
# Recovery fstab
# ============================================================
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/recovery/root/system/etc/recovery.fstab

# ============================================================
# Sepolicy (recovery) - relative path, picked up by the TWRP
# build system. Uses BOARD_SEPOLICY_DIRS (BOARD_PLAT_*_SEPOLICY_DIR
# is deprecated since Android 12 and must NOT be used).
# ============================================================
BOARD_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy

# ============================================================
# FastbootD / repack tools (A/B)
# ============================================================
TW_INCLUDE_FASTBOOTD := true
TW_INCLUDE_REPACKTOOLS := true

# ============================================================
# Languages
# ============================================================
TW_EXTRA_LANGUAGES := true
TW_DEFAULT_LANGUAGE := zh_CN

# ============================================================
# APEX
# ============================================================
TW_EXCLUDE_APEX := true

# ============================================================
# Misc TWRP tweaks
# ============================================================
TW_INCLUDE_NTFS_3G := true
TW_INCLUDE_RESETPROP := true
TW_INCLUDE_LIBRESETPROP := true
TW_INCLUDE_LPTOOLS := true
TW_INCLUDE_LPDUMP := true
TW_NO_SCREEN_BLANK := true
TWRP_INCLUDE_LOGCAT := true
TARGET_USES_LOGD := true
BOARD_SUPPRESS_SECURE_ERASE := true
TW_DEVICE_VERSION := ZYB-ZPD1203-1.0

# ============================================================
# Recovery decryption HAL modules (keymaster 4.1 + gatekeeper 1.0)
# ============================================================
TARGET_RECOVERY_DEVICE_MODULES += \
    android.hardware.boot@1.2-service \
    libcppbor_external \
    libkeymaster4 \
    libkeymaster41 \
    libkeymaster4_1support \
    libkeymaster4support \
    libkeymaster_messages \
    libkeymaster_portable \
    libpuresoftkeymasterdevice \
    libsoft_attestation_cert \
    libkeystore-engine-wifi-hidl \
    libkeystore-wifi-hidl \
    android.hardware.gatekeeper@1.0 \
    android.hardware.keymaster@3.0 \
    android.hardware.keymaster@4.0 \
    android.hardware.keymaster@4.1

RECOVERY_LIBRARY_SOURCE_FILES += \
    $(TARGET_OUT_SHARED_LIBRARIES)/libkeymaster4.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libkeymaster41.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libkeymaster4_1support.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libkeymaster4support.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libkeymaster_messages.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libkeymaster_portable.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libpuresoftkeymasterdevice.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hardware.gatekeeper@1.0.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hardware.keymaster@3.0.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hardware.keymaster@4.0.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hardware.keymaster@4.1.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libkeystore-engine-wifi-hidl.so

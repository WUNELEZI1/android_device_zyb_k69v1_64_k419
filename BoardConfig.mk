# Copyright (C) 2024 ZYB
# SPDX-License-Identifier: Apache-2.0

DEVICE_PATH := device/zyb/k69v1_64_k419

# === Platform ===
TARGET_BOARD_PLATFORM := mt6768
TARGET_BOOTLOADER_BOARD_NAME := k69v1_64_k419
TARGET_NO_BOOTLOADER := true

# === Architecture - 64bit ONLY ===
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := cortex-a55
TARGET_2ND_ARCH :=
TARGET_2ND_ARCH_VARIANT :=
TARGET_2ND_CPU_ABI :=
TARGET_2ND_CPU_ABI2 :=
TARGET_2ND_CPU_VARIANT :=

# === Kernel (boot header v2, confirmed from stock boot.img) ===
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/kernel
TARGET_PREBUILT_DTB := $(DEVICE_PATH)/prebuilt/dtb
BOARD_KERNEL_CMDLINE := bootopt=64S3,32N2,64N2 buildvariant=user
BOARD_KERNEL_BASE := 0x40080000
BOARD_KERNEL_PAGESIZE := 2048
BOARD_KERNEL_OFFSET := 0x00008000
BOARD_RAMDISK_OFFSET := 0x07c80000
BOARD_KERNEL_TAGS_OFFSET := 0x0bc80000
BOARD_DTB_OFFSET := 0x0bc80000
BOARD_MKBOOTIMG_ARGS += --ramdisk_offset $(BOARD_RAMDISK_OFFSET)
BOARD_MKBOOTIMG_ARGS += --tags_offset $(BOARD_KERNEL_TAGS_OFFSET)
BOARD_MKBOOTIMG_ARGS += --dtb $(TARGET_PREBUILT_DTB)
BOARD_MKBOOTIMG_ARGS += --dtb_offset $(BOARD_DTB_OFFSET)
BOARD_MKBOOTIMG_ARGS += --header_version 2
BOARD_INCLUDE_DTB_IN_BOOTIMG := true

# === Partition sizes ===
BOARD_BOOTIMAGE_PARTITION_SIZE := 33554432
BOARD_FLASH_BLOCK_SIZE := 131072
BOARD_SUPER_PARTITION_SIZE := 10737418240
BOARD_USES_METADATA_PARTITION := true
BOARD_ROOT_EXTRA_FOLDERS += metadata

# === A/B ===
AB_OTA_UPDATER := true
AB_OTA_PARTITIONS := boot system product vendor

# === Virtual A/B + Dynamic partitions ===
BOARD_BUILD_SYSTEM_ROOT_IMAGE := true
BOARD_USES_RECOVERY_AS_BOOT := true
PRODUCT_USE_DYNAMIC_PARTITIONS := true
BOARD_SUPER_PARTITION_GROUPS := main
BOARD_MAIN_SIZE := 10737418240
BOARD_MAIN_PARTITION_LIST := system system_ext vendor product

# === Filesystem ===
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_SYSTEM_EXTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_SYSTEM_EXT := system_ext
TARGET_COPY_OUT_PRODUCT := product
TARGET_COPY_OUT_VENDOR := vendor

# === FBE decryption ===
TW_INCLUDE_CRYPTO := true
TW_INCLUDE_CRYPTO_FBE := true
TW_INCLUDE_FBE_METADATA_DECRYPT := true
TW_USE_FSCRYPT_POLICY := 2
TW_FORCE_KEYMASTER_VER := true
TW_PREPARE_DATA_MEDIA_EARLY := true

# === VNDK / Shipping API ===
BOARD_VNDK_VERSION := current
PRODUCT_SHIPPING_API_LEVEL := 31

# === AVB ===
BOARD_AVB_VBMETA_SYSTEM := system product
BOARD_AVB_VBMETA_SYSTEM_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_VBMETA_SYSTEM_ALGORITHM := SHA256_RSA2048
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX_LOCATION := 2

# === Security patch anti-rollback ===
PLATFORM_SECURITY_PATCH := 2099-12-31
PLATFORM_VERSION := 99
VENDOR_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)

# === Screen (flipped) ===
BOARD_HAS_FLIPPED_SCREEN := true
TARGET_SCREEN_DENSITY := 280
TARGET_RECOVERY_PIXEL_FORMAT := "RGBX_8888"
TW_THEME := portrait_hdpi

# === Brightness ===
TW_MAX_BRIGHTNESS := 255
TW_DEFAULT_BRIGHTNESS := 128
TW_BRIGHTNESS_PATH := "/sys/devices/platform/leds-mt65xx/leds/lcd-backlight/brightness"

# === USB / MTP ===
TW_HAS_USB := true
TW_EXCLUDE_DEFAULT_USB_INIT := true
TARGET_USE_CUSTOM_LUN_FILE_PATH := /config/usb_gadget/g1/functions/mass_storage.0/lun.%d/file

# === Language ===
TW_EXTRA_LANGUAGES := true
TW_DEFAULT_LANGUAGE := zh_CN

# === FastbootD ===
TW_INCLUDE_FASTBOOTD := true

# === APEX ===
TW_EXCLUDE_APEX := true

# === Misc TWRP ===
TW_INCLUDE_NTFS_3G := true
TW_INCLUDE_RESETPROP := true
TW_INCLUDE_LIBRESETPROP := true
TW_NO_SCREEN_BLANK := true
TWRP_INCLUDE_LOGCAT := true
TARGET_USES_LOGD := true
BOARD_SUPPRESS_SECURE_ERASE := true
TW_DEVICE_VERSION := ZYB-ZPD1203

# === Decryption modules ===
TARGET_RECOVERY_DEVICE_MODULES += \
    android.hardware.boot@1.2-service \
    libhidltransport \
    libhwbinder \
    libutils \
    libcutils \
    liblog \
    libbinder \
    libbase \
    libkeymaster4 \
    libkeymaster41 \
    libkeymaster4_1support \
    libkeymaster4support \
    libkeymaster_portable \
    libkeymaster_messages \
    libpuresoftkeymasterdevice \
    android.hardware.gatekeeper@1.0 \
    android.hardware.keymaster@4.1 \
    android.hardware.keymaster@4.0 \
    android.hardware.keymaster@3.0 \
    libkeystore-engine-wifi-hidl

RECOVERY_LIBRARY_SOURCE_FILES += \
    $(TARGET_OUT_SHARED_LIBRARIES)/libkeymaster4.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libkeymaster41.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libkeymaster4_1support.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libkeymaster4support.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libkeymaster_portable.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libkeymaster_messages.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libpuresoftkeymasterdevice.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hardware.gatekeeper@1.0.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hardware.keymaster@4.1.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hardware.keymaster@4.0.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hardware.keymaster@3.0.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libkeystore-engine-wifi-hidl.so

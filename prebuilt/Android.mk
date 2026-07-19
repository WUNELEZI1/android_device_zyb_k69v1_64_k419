LOCAL_PATH := $(call my-dir)

# Prebuilt ELF binaries installed into the recovery/boot ramdisk root.
#
# Defined in this standalone Android.mk (auto-discovered by the build's module
# scanner) rather than in device.mk, so the build reliably picks them up
# regardless of product-config parsing flow.
#
# Each module installs into $(TARGET_ROOT_OUT)/<path>. For BOARD_USES_RECOVERY_AS_BOOT
# the recovery ramdisk IS $(TARGET_ROOT_OUT), so these land at the right runtime
# path inside the final boot.img.
#
# ELF files cannot be staged via PRODUCT_COPY_FILES (check-non-elf-file-timestamps
# rejects them), therefore BUILD_PREBUILT is the correct mechanism. The module
# names (twrp_*) are referenced from PRODUCT_PACKAGES in device.mk.

# --- linker64 (64-bit dynamic linker) ---
include $(CLEAR_VARS)
LOCAL_MODULE := twrp_linker64
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT)/system/bin
LOCAL_SRC_FILES := system/bin/linker64
LOCAL_MODULE_TAGS := optional
include $(BUILD_PREBUILT)

# --- /system/bin/sh ---
include $(CLEAR_VARS)
LOCAL_MODULE := twrp_recovery_sh
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT)/system/bin
LOCAL_SRC_FILES := system/bin/sh
LOCAL_MODULE_TAGS := optional
include $(BUILD_PREBUILT)

# --- android.hardware.keymaster@4.1-service ---
include $(CLEAR_VARS)
LOCAL_MODULE := twrp_keymaster41_service
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT)/vendor/bin/hw
LOCAL_SRC_FILES := vendor/bin/hw/android.hardware.keymaster@4.1-service
LOCAL_MODULE_TAGS := optional
include $(BUILD_PREBUILT)

# --- android.hardware.gatekeeper@1.0-service ---
include $(CLEAR_VARS)
LOCAL_MODULE := twrp_gatekeeper10_service
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT)/vendor/bin/hw
LOCAL_SRC_FILES := vendor/bin/hw/android.hardware.gatekeeper@1.0-service
LOCAL_MODULE_TAGS := optional
include $(BUILD_PREBUILT)

# --- android.hardware.gatekeeper@1.0-impl.so ---
include $(CLEAR_VARS)
LOCAL_MODULE := twrp_gatekeeper10_impl
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT)/vendor/lib64/hw
LOCAL_SRC_FILES := vendor/lib64/hw/android.hardware.gatekeeper@1.0-impl.so
LOCAL_MODULE_TAGS := optional
include $(BUILD_PREBUILT)

# --- gatekeeper.default.so ---
include $(CLEAR_VARS)
LOCAL_MODULE := twrp_gatekeeper_default
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT)/vendor/lib64/hw
LOCAL_SRC_FILES := vendor/lib64/hw/gatekeeper.default.so
LOCAL_MODULE_TAGS := optional
include $(BUILD_PREBUILT)

# --- libSoftGatekeeper.so ---
include $(CLEAR_VARS)
LOCAL_MODULE := twrp_libsoftgatekeeper
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT)/vendor/lib64/hw
LOCAL_SRC_FILES := vendor/lib64/hw/libSoftGatekeeper.so
LOCAL_MODULE_TAGS := optional
include $(BUILD_PREBUILT)

# --- android.hardware.boot@1.0-impl-1.2.so (Boot HAL passthrough backend) ---
# Required so android.hardware.boot@1.2-service can provide IBootControl for
# A/B active-slot switching (Reboot -> System). The minimal TWRP manifest does
# not build this device-specific impl, so we stage the known-good prebuilt.
include $(CLEAR_VARS)
LOCAL_MODULE := twrp_boot_impl_12
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT)/system/lib64/hw
LOCAL_SRC_FILES := system/lib64/hw/android.hardware.boot@1.0-impl-1.2.so
LOCAL_MODULE_TAGS := optional
include $(BUILD_PREBUILT)

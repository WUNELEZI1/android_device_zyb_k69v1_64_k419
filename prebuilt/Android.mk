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
# LOCAL_MODULE_STEM forces the installed filename to the REAL name the loader/HAL
# expects (e.g. /system/bin/linker64, /vendor/bin/hw/android.hardware.keymaster@4.1-service,
# the *-impl*.so the HAL dlopens). LOCAL_MODULE keeps a unique twrp_ name to avoid
# colliding with any system module of the same base name.
#
# LOCAL_CHECK_ELF_FILES := false bypasses the prebuilt ELF validation:
#  - SHARED_LIBRARIES would otherwise require DT_SONAME == installed filename.
#  - EXECUTABLES would otherwise require every DT_NEEDED lib (android.hardware.keymaster@4.0.so,
#    libkeymaster4.so, ...) to be declared/available, but the minimal TWRP manifest
#    does not build those. These are known-good binaries pulled from a working TWRP
#    for this SoC, so skipping the check is correct.
#
# The module names (twrp_*) are referenced from PRODUCT_PACKAGES in device.mk.

# --- twrp_linker64 (installs as linker64) ---
include $(CLEAR_VARS)
LOCAL_MODULE := twrp_linker64
LOCAL_MODULE_STEM := linker64
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT)/system/bin
LOCAL_SRC_FILES := system/bin/linker64
LOCAL_MODULE_TAGS := optional
LOCAL_CHECK_ELF_FILES := false
include $(BUILD_PREBUILT)

# --- twrp_recovery_sh (installs as sh) ---
include $(CLEAR_VARS)
LOCAL_MODULE := twrp_recovery_sh
LOCAL_MODULE_STEM := sh
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT)/system/bin
LOCAL_SRC_FILES := system/bin/sh
LOCAL_MODULE_TAGS := optional
LOCAL_CHECK_ELF_FILES := false
include $(BUILD_PREBUILT)

# --- twrp_keymaster41_service (installs as android.hardware.keymaster@4.1-service) ---
include $(CLEAR_VARS)
LOCAL_MODULE := twrp_keymaster41_service
LOCAL_MODULE_STEM := android.hardware.keymaster@4.1-service
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT)/vendor/bin/hw
LOCAL_SRC_FILES := vendor/bin/hw/android.hardware.keymaster@4.1-service
LOCAL_MODULE_TAGS := optional
LOCAL_CHECK_ELF_FILES := false
include $(BUILD_PREBUILT)

# --- twrp_gatekeeper10_service (installs as android.hardware.gatekeeper@1.0-service) ---
include $(CLEAR_VARS)
LOCAL_MODULE := twrp_gatekeeper10_service
LOCAL_MODULE_STEM := android.hardware.gatekeeper@1.0-service
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT)/vendor/bin/hw
LOCAL_SRC_FILES := vendor/bin/hw/android.hardware.gatekeeper@1.0-service
LOCAL_MODULE_TAGS := optional
LOCAL_CHECK_ELF_FILES := false
include $(BUILD_PREBUILT)

# --- twrp_gatekeeper10_impl (installs as android.hardware.gatekeeper@1.0-impl) ---
include $(CLEAR_VARS)
LOCAL_MODULE := twrp_gatekeeper10_impl
LOCAL_MODULE_STEM := android.hardware.gatekeeper@1.0-impl
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT)/vendor/lib64/hw
LOCAL_SRC_FILES := vendor/lib64/hw/android.hardware.gatekeeper@1.0-impl.so
LOCAL_MODULE_TAGS := optional
LOCAL_CHECK_ELF_FILES := false
include $(BUILD_PREBUILT)

# --- twrp_gatekeeper_default (installs as gatekeeper.default) ---
include $(CLEAR_VARS)
LOCAL_MODULE := twrp_gatekeeper_default
LOCAL_MODULE_STEM := gatekeeper.default
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT)/vendor/lib64/hw
LOCAL_SRC_FILES := vendor/lib64/hw/gatekeeper.default.so
LOCAL_MODULE_TAGS := optional
LOCAL_CHECK_ELF_FILES := false
include $(BUILD_PREBUILT)

# --- twrp_libsoftgatekeeper (installs as libSoftGatekeeper) ---
include $(CLEAR_VARS)
LOCAL_MODULE := twrp_libsoftgatekeeper
LOCAL_MODULE_STEM := libSoftGatekeeper
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT)/vendor/lib64/hw
LOCAL_SRC_FILES := vendor/lib64/hw/libSoftGatekeeper.so
LOCAL_MODULE_TAGS := optional
LOCAL_CHECK_ELF_FILES := false
include $(BUILD_PREBUILT)

# --- twrp_boot_impl_12 (installs as android.hardware.boot@1.0-impl-1.2) ---
include $(CLEAR_VARS)
LOCAL_MODULE := twrp_boot_impl_12
LOCAL_MODULE_STEM := android.hardware.boot@1.0-impl-1.2.so
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT)/system/lib64/hw
LOCAL_SRC_FILES := system/lib64/hw/android.hardware.boot@1.0-impl-1.2.so
LOCAL_MODULE_TAGS := optional
LOCAL_CHECK_ELF_FILES := false
include $(BUILD_PREBUILT)

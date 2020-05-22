#
# Copyright (C) 2020 Nate Ding
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-beardropper
PKG_VERSION:=1.1
PKG_RELEASE:=1

PKG_LICENSE:=GPLv3
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=natelol <natelol@github.com>

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=luci
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	TITLE:=LuCI support for bearDropper
	PKGARCH:=all
endef

define Package/$(PKG_NAME)/description
	LuCI Support for bearDropper.
endef


define Build/Prepare
	$(foreach po,$(wildcard ${CURDIR}/files/luasrc/i18n/*.po), \
		po2lmo $(po) $(PKG_BUILD_DIR)/$(patsubst %.po,%.lmo,$(notdir $(po)));)
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/conffiles
	/etc/config/bearDropper
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/root/etc/init.d/bearDropper $(1)/etc/init.d
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) ./files/root/usr/sbin/bearDropper $(1)/usr/sbin
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/root/etc/config/bearDropper $(1)/etc/config
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DATA) ./files/luasrc/controller/*.lua $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi/bearDropper
	$(INSTALL_DATA) ./files/luasrc/model/cbi/bearDropper/*.lua $(1)/usr/lib/lua/luci/model/cbi/bearDropper
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view/bearDropper
	$(INSTALL_DATA) ./files/luasrc/view/bearDropper/*.htm $(1)/usr/lib/lua/luci/view/bearDropper
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./files/root/etc/uci-defaults/luci-beardropper $(1)/etc/uci-defaults/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/bearDropper.*.lmo $(1)/usr/lib/lua/luci/i18n	
endef

$(eval $(call BuildPackage,$(PKG_NAME)))

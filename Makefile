# Number of Compilation Threads
OPT=-j$(shell nproc)

PYTHON = $(shell which python3)
ARKROOT ?= $(CURDIR)

export DEBUG ARKROOT

SUBDIRS = libs \
	contrib/PC/btcnf \
	contrib/PC/prxencrypter \
	core/systemctrl \
	core/inferno \
	core/stargate \
	core/popcorn \
	core/vshctrl \
	core/compat/psp/rebootex \
	core/compat/psp \
	core/compat/vita/rebootex \
	core/compat/vita \
	core/compat/vitapops/rebootex \
	core/compat/vitapops \
	core/compat/pentazemin/rebootex \
	core/compat/pentazemin \
	loader/live/user/linkless_payload \
	loader/live/user/signed_eboot \
	loader/live/user/psxloader \
	loader/live/kernel/kernel_loader \
	loader/live/kernel/psxloader \
	loader/live/kernel/chain_loader \
	loader/live/kernel/kram_dumper \
	loader/live/kernel/idstorage_dumper \
	loader/live/kernel/psp_flash_dumper \
	loader/live/kernel/vita_flash_dumper \
	extras/modules/ipl_update \
	extras/modules/kpspident \
	loader/perma/cipl/payloadex \
	loader/perma/cipl/mainbinex \
	loader/perma/cipl/combine \
	loader/perma/cipl/installer \
	loader/dc/dcman \
	loader/dc/msipl/payloadex \
	loader/dc/msipl/mainbinex \
	loader/dc/tmctrl/rebootex \
	loader/dc/tmctrl \
	loader/dc/vunbricker \
	loader/dc/installer \
	extras/installer \
	extras/menus/arkMenu \
	extras/menus/recovery \
	extras/menus/xMenu \
	extras/menus/advancedvsh \
	extras/menus/provsh \
	extras/modules/peops \
	extras/modules/xmbctrl \
	extras/modules/usbdevice \
	extras/modules/idsregeneration

.PHONY: subdirs $(SUBDIRS) cleanobj clean cleanobj copy-bin mkdir-dist encrypt-prx

all: subdirs newcipl kxploits mkdir-dist encrypt-prx copy-bin
	@echo "Build Done"

copy-bin:
#	Common installation
	$(Q)cp loader/live/user/signed_eboot/EBOOT.PBP dist/ARK_Loader/EBOOT.PBP # Signed EBOOT
	$(Q)cp loader/live/user/signed_eboot/ark_loader.iso dist/PSVita/Standalone/
	$(Q)cp loader/live/kernel/kxploit/psp660/K.BIN dist/ARK_Loader/K.BIN # Kernel exploit for PSP
	$(Q)cp loader/live/user/vitabubble/EBOOT.PBP dist/PSVita/Standalone/NPUZ01234/ # Vita fake ChovySign bubble
	$(Q)cp loader/live/user/vitabubble/PBOOT.PBP dist/PSVita/Standalone/NPUZ01234/ # Vita PBOOT.PBP bubble
	$(Q)cp loader/live/user/psxloader/ps1cfw_enabler.suprx dist/PSVita/PS1CFW/
	$(Q)cp loader/live/user/psxloader/EBOOT.PBP dist/PSVita/PS1CFW/SCPS10084/
	$(Q)cp loader/live/kernel/kxploit/vita360/K.BIN dist/PSVita/Standalone/K.BIN # Kernel exploit for Vita 3.60+
	$(Q)cp loader/live/kernel/kxploit/cfw/K.BIN dist/PSVita/Adrenaline/K.BIN # kxploit for CFW
	$(Q)cp loader/perma/infinity/EBOOT.PBP dist/PSP/Infinity/ # Infinity with ARK support
	$(Q)cp loader/perma/infinity/EBOOT_GO.PBP dist/PSP/Infinity/ # Infinity with ARK support (PSP Go)
	$(Q)cp -r contrib/PSP/SAVEDATA/ARK_01234/ dist/ # ARK Savedata installation
	$(Q)cp loader/live/kernel/chain_loader/ARK.BIN dist/ARK_01234/ARK.BIN # ARK-2 chainloader
	$(Q)cp loader/live/kernel/kernel_loader/ARK4.BIN dist/ARK_01234/ARK4.BIN # ARK-4 loader
	$(Q)cp loader/live/kernel/psxloader/ARKX.BIN dist/ARK_01234/ARKX.BIN # ARK-X loader
	$(Q)cp loader/live/kernel/kxploit/dummy/K.BIN dist/ARK_01234/K.BIN # Dummy Kernel exploit
	$(Q)cp loader/live/user/linkless_payload/H.BIN dist/ARK_01234/H.BIN # game exploit loader
	$(Q)cp -r contrib/PSP/GAME/ARK_DC/ dist/PSP/ # ARK DC installer
	$(Q)cp loader/dc/installer/EBOOT.PBP dist/PSP/ARK_DC/ # ARK DC installer
	$(Q)cp loader/perma/cipl/installer/EBOOT.PBP dist/PSP/ARK_cIPL/EBOOT.PBP
	$(Q)cp extras/modules/kpspident/kpspident.prx dist/PSP/ARK_cIPL/kpspident.prx
	$(Q)cp extras/modules/ipl_update/ipl_update.prx dist/PSP/ARK_cIPL/ipl_update.prx
	$(Q)cp loader/perma/newcipl/installer/EBOOT.PBP dist/PSP/ARK_newIPL/EBOOT.PBP
	$(Q)cp extras/modules/kpspident/kpspident.prx dist/PSP/ARK_newIPL/kpspident.prx
	$(Q)cp extras/modules/ipl_update/ipl_update.prx dist/PSP/ARK_newIPL/ipl_update.prx
	$(Q)cp extras/menus/recovery/EBOOT.PBP dist/ARK_01234/RECOVERY.PBP # Default recovery menu
	$(Q)cp extras/menus/arkMenu/EBOOT.PBP dist/ARK_01234/VBOOT.PBP # Default launcher
	$(Q)cp extras/menus/arkMenu/LANG.ARK dist/ARK_01234/LANG.ARK # Translations
	$(Q)cp extras/menus/xMenu/EBOOT.PBP dist/ARK_01234/XBOOT.PBP # PS1 launcher
	$(Q)cp extras/menus/arkMenu/themes/ARK_Revamped/THEME.ARK dist/ARK_01234/THEME.ARK # Launcher and Recovery resources
	$(Q)cp extras/menus/advancedvsh/satelite.prx dist/ARK_01234/VSHMENU.PRX # New Default & Advanced VSH Menu
	$(Q)cp extras/modules/xmbctrl/xmbctrl.prx dist/ARK_01234/XMBCTRL.PRX # XMB Control Module
	$(Q)cp extras/modules/idsregeneration/idsregeneration.prx dist/ARK_01234/IDSREG.PRX # idsregeneration
	$(Q)cp extras/modules/usbdevice/usbdevice.prx dist/ARK_01234/USBDEV.PRX # USB Device Driver
	$(Q)cp extras/installer/EBOOT.PBP dist/PSP/ARK_Full_Installer # Full installer
	$(Q)cp extras/modules/peops/peops.prx dist/ARK_01234/PS1SPU.PRX
	$(Q)cp contrib/UPDATER.TXT dist/ARK_01234/
	$(Q)cp contrib/PSP/mediasync.prx dist/ARK_01234/MEDIASYN.PRX
	$(Q)cp contrib/PSP/popsman.prx dist/ARK_01234/POPSMAN.PRX
	$(Q)cp contrib/PSP/pops_01g.prx dist/ARK_01234/POPS.PRX
	$(Q)cp -r extras/menus/arkMenu/themes dist/
	$(Q)rm -rf dist/themes/translations
	$(Q)cp contrib/README.TXT dist/
	$(Q)mv dist/FLASH0.ARK dist/ARK_01234/ # flash0 package
	$(Q)cp -r dist/ARK_01234 dist/PSP/ARK_DC/
	$(Q)find dist/themes/ -type d -name 'resources' -exec rm -rf {} \; 2>/dev/null || true
	$(Q)$(MAKE) -C extras/updater/
	$(Q)cp extras/updater/EBOOT_PSP.PBP dist/UPDATE/EBOOT.PBP

	
encrypt-prx: \
	dist/SYSCTRL.BIN \
	dist/VSHCTRL.BIN \
	dist/INFERNO.BIN \
	dist/STARGATE.BIN \
	dist/POPCORN.BIN \
	dist/PSPCOMP.BIN \
	dist/VITACOMP.BIN \
	dist/VITAPOPS.BIN \
	dist/VITAPLUS.BIN
	$(Q)cp contrib/PC/btcnf/psvbtinf.bin dist/PSVBTINF.BIN
	$(Q)cp contrib/PC/btcnf/psvbtcnf.bin dist/PSVBTCNF.BIN
	$(Q)cp contrib/PC/btcnf/psvbtxnf.bin dist/PSVBTXNF.BIN
	$(Q)cp contrib/PC/btcnf/psvbtjnf.bin dist/PSVBTJNF.BIN
	$(Q)cp contrib/PC/btcnf/psvbtknf.bin dist/PSVBTKNF.BIN
	$(Q)$(PYTHON) contrib/PC/pack/pack.py -p dist/FLASH0.ARK contrib/PC/pack/packlist.txt

newcipl:
	$(Q)$(MAKE) -C loader/perma/newcipl/payloadex
	$(Q)$(MAKE) PSP_MODEL=01G -C loader/perma/newcipl/
	$(Q)$(MAKE) PSP_MODEL=02G -C loader/perma/newcipl/
	$(Q)$(MAKE) PSP_MODEL=03G -C loader/perma/newcipl/
	$(Q)$(MAKE) PSP_MODEL=04G -C loader/perma/newcipl/
	$(Q)$(MAKE) PSP_MODEL=05G -C loader/perma/newcipl/
	$(Q)$(MAKE) PSP_MODEL=07G -C loader/perma/newcipl/
	$(Q)$(MAKE) PSP_MODEL=09G -C loader/perma/newcipl/
	$(Q)$(MAKE) PSP_MODEL=11G -C loader/perma/newcipl/
	$(Q)$(MAKE) -C loader/perma/newcipl/installer

kxploits:
	$(Q)$(MAKE) $@ K=dummy -C loader/live/kernel/kxploit
	$(Q)$(MAKE) $@ K=psp660 -C loader/live/kernel/kxploit
	$(Q)$(MAKE) $@ K=vita320 -C loader/live/kernel/kxploit
	$(Q)$(MAKE) $@ K=vita360 -C loader/live/kernel/kxploit
	$(Q)$(MAKE) $@ K=cfw -C loader/live/kernel/kxploit

# Only clean non-library code
cleanobj:
	$(Q)$(MAKE) clean CLEANOBJ=1

clean:
	$(Q)$(MAKE) $@ -C libs
	$(Q)$(MAKE) $@ -C loader/live/user/linkless_payload
	$(Q)$(MAKE) $@ -C loader/live/user/signed_eboot
	$(Q)$(MAKE) $@ -C loader/live/user/psxloader
	$(Q)$(MAKE) $@ -C loader/live/kernel/kernel_loader
	$(Q)$(MAKE) $@ -C loader/live/kernel/psxloader
	$(Q)$(MAKE) $@ -C loader/live/kernel/chain_loader
	$(Q)$(MAKE) $@ -C loader/live/kernel/kram_dumper
	$(Q)$(MAKE) $@ -C loader/live/kernel/idstorage_dumper
	$(Q)$(MAKE) $@ -C loader/live/kernel/psp_flash_dumper
	$(Q)$(MAKE) $@ -C loader/live/kernel/vita_flash_dumper
	$(Q)$(MAKE) $@ -C core/compat/psp/rebootex
	$(Q)$(MAKE) $@ -C core/compat/vita/rebootex
	$(Q)$(MAKE) $@ -C core/compat/vitapops/rebootex
	$(Q)$(MAKE) $@ -C core/compat/pentazemin/rebootex
	$(Q)$(MAKE) $@ -C core/systemctrl
	$(Q)$(MAKE) $@ -C core/vshctrl
	$(Q)$(MAKE) $@ -C core/stargate
	$(Q)$(MAKE) $@ -C core/popcorn
	$(Q)$(MAKE) $@ -C core/inferno
	$(Q)$(MAKE) $@ -C core/compat/psp
	$(Q)$(MAKE) $@ -C core/compat/vita
	$(Q)$(MAKE) $@ -C core/compat/vitapops
	$(Q)$(MAKE) $@ -C core/compat/pentazemin
	$(Q)$(MAKE) $@ -C extras/menus/recovery
	$(Q)$(MAKE) $@ -C extras/menus/arkMenu
	$(Q)$(MAKE) $@ -C extras/menus/advancedvsh
	$(Q)$(MAKE) $@ -C extras/menus/provsh
	$(Q)$(MAKE) $@ -C extras/menus/xMenu
	$(Q)$(MAKE) $@ -C extras/modules/peops
	$(Q)$(MAKE) $@ -C extras/modules/xmbctrl
	$(Q)$(MAKE) $@ -C extras/modules/usbdevice
	$(Q)$(MAKE) $@ -C extras/modules/ipl_update
	$(Q)$(MAKE) $@ -C extras/modules/kpspident
	$(Q)$(MAKE) $@ -C extras/modules/idsregeneration
	$(Q)$(MAKE) $@ K=dummy -C loader/live/kernel/kxploit
	$(Q)$(MAKE) $@ K=psp660 -C loader/live/kernel/kxploit
	$(Q)$(MAKE) $@ K=vita320 -C loader/live/kernel/kxploit
	$(Q)$(MAKE) $@ K=vita360 -C loader/live/kernel/kxploit
	$(Q)$(MAKE) $@ K=cfw -C loader/live/kernel/kxploit
	$(Q)$(MAKE) $@ -C contrib/PC/btcnf/
	$(Q)$(MAKE) $@ -C loader/perma/cipl/payloadex
	$(Q)$(MAKE) $@ -C loader/perma/cipl/mainbinex
	$(Q)$(MAKE) $@ -C loader/perma/cipl/combine
	$(Q)$(MAKE) $@ -C loader/perma/cipl/installer
	$(Q)$(MAKE) $@ -C loader/dc/dcman
	$(Q)$(MAKE) $@ -C loader/dc/installer
	$(Q)$(MAKE) $@ -C loader/dc/msipl/mainbinex
	$(Q)$(MAKE) $@ -C loader/dc/msipl/payloadex
	$(Q)$(MAKE) $@ -C loader/dc/tmctrl/rebootex
	$(Q)$(MAKE) $@ -C loader/dc/tmctrl
	$(Q)$(MAKE) $@ -C loader/dc/vunbricker
	$(Q)$(MAKE) $@ -C loader/perma/newcipl/
	$(Q)$(MAKE) $@ -C loader/perma/newcipl/payloadex
	$(Q)$(MAKE) $@ -C loader/perma/newcipl/installer
	$(Q)-rm -rf dist *~ | true
	$(Q)-rm -rf common/utils/*.o
	$(Q)$(MAKE) $@ -C extras/updater/
	$(Q)$(MAKE) $@ -C extras/installer/
	$(Q)rm -f extras/updater/ARK_01234.PKG | true
	$(Q)rm -f extras/updater/EBOOT_PSP.PBP | true
	$(Q)rm -f extras/updater/EBOOT_GO.PBP | true
	$(Q)$(PYTHON) contrib/PC/scripts/cleandeps.py
	$(Q)find -name 'THEME.ARK' -exec rm {} \;
	$(Q)rm -f extras/menus/arkMenu/LANG.ARK

subdirs: $(SUBDIRS)

$(filter-out libs, $(SUBDIRS)): libs
	$(Q)$(MAKE) $(OPT) -C $@

libs:
	$(Q)$(MAKE) $(OPT) -C $@

arkmenu: libs
	$(Q)$(MAKE) $@ -C extras/menus/arkMenu

vshmenu: libs
	$(Q)$(MAKE) $@ -C extras/menus/advancedvsh

xmenu: libs
	$(Q)$(MAKE) $@ -C extras/menus/xMenu

recovery: libs
	$(Q)$(MAKE) $@ -C extras/menus/recovery

mkdir-dist:
	$(Q)mkdir dist | true
	$(Q)mkdir dist/PSP | true
	$(Q)mkdir dist/PSVita | true
	$(Q)mkdir dist/UPDATE | true
	$(Q)mkdir dist/ARK_Loader | true
	$(Q)mkdir dist/PSP/Infinity | true
	$(Q)mkdir dist/PSP/ARK_DC | true
	$(Q)mkdir dist/PSP/ARK_cIPL | true
	$(Q)mkdir dist/PSP/ARK_newIPL | true
	$(Q)mkdir dist/PSP/ARK_Full_Installer | true
	$(Q)mkdir dist/PSVita/Adrenaline | true
	$(Q)mkdir dist/PSVita/Standalone | true
	$(Q)mkdir dist/PSVita/Standalone/NPUZ01234  | true
	$(Q)mkdir dist/PSVita/PS1CFW | true
	$(Q)mkdir dist/PSVita/PS1CFW/SCPS10084 | true

-include $(ARKROOT)/.config
include $(ARKROOT)/common/make/quiet.mak
include $(ARKROOT)/common/make/mod_enc.mak

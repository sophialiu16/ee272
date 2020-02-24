#=========================================================================
# Makefile
#=========================================================================
# Generator : /afs/ir.stanford.edu/class/ee272/mflowgen/mflowgen/MakeBackend.py

# $1 -- $dst
# $2 -- $src
# $3 -- $stamp

define cpdir
	rm -rf ./$1
	cp -aL $2 $1 || true
	chmod -R +w $1
	touch $3
endef

# $1 -- $dst
# $2 -- $src
# $3 -- $stamp

define cpdir-and-parameterize
	rm -rf ./$1
	cp -aL $2 $1 || true
	chmod -R +w $1
	cp .mflowgen/$1/configure.yml $1
	touch $3
endef

# $1 -- $dst
# $2 -- $src
# $3 -- $stamp

define mkdir-and-symlink
	rm -rf ./$1
	mkdir -p $1
	cd $1 && ln -sf ../$2/* . && cd ..
	rm $1/configure.yml && cp .mflowgen/$1/configure.yml $1
	touch $3
endef

# $1 -- $dst_dir
# $2 -- $dst
# $3 -- $src
# $4 -- $stamp

define symlink
	mkdir -p $1
	cd $1 && ln -sf $3 $2 && touch $4
endef

# $1 -- $stamp

define stamp
	touch $1
endef

# Default

default: info freepdk-45nm sram constraints rtl synopsys-dc-synthesis

# ------------------------------------------------------------------------
# info
# ------------------------------------------------------------------------

# build dir

0-info/.stamp:
	$(call cpdir-and-parameterize,0-info,../../../../../../../afs/ir/class/ee272/mflowgen/steps/info,0-info/.stamp)

# collect inputs

# execute

define 0_info_commands_rule
	mkdir -p 0-info/outputs && python /afs/ir/class/ee272/mflowgen/utils/letters.py -c -t info && cp -f .mflowgen/0-info/mflowgen-run.sh 0-info && cp -f .mflowgen/0-info/mflowgen-debug.sh 0-info 2> /dev/null || true && cd 0-info && sh mflowgen-run.sh 2>&1 | tee mflowgen-run.log && cd .. && touch -c 0-info/outputs/*
endef

0-info/.execstamp.execute-phony: 0-info/.stamp
	$(call 0_info_commands_rule)

# collect outputs

# alias

.PHONY: info

info: 0-info/.execstamp.execute-phony

.PHONY: 0

0: 0-info/.execstamp.execute-phony

# debug

# ------------------------------------------------------------------------
# freepdk-45nm
# ------------------------------------------------------------------------

# build dir

1-freepdk-45nm/.stamp:
	$(call cpdir-and-parameterize,1-freepdk-45nm,../../../../../../../afs/ir/class/ee272/mflowgen/adks/freepdk-45nm,1-freepdk-45nm/.stamp)

# collect inputs

# execute

define 1_freepdk_45nm_commands_rule
	mkdir -p 1-freepdk-45nm/outputs && python /afs/ir/class/ee272/mflowgen/utils/letters.py -c -t freepdk-45nm && cp -f .mflowgen/1-freepdk-45nm/mflowgen-run.sh 1-freepdk-45nm && cp -f .mflowgen/1-freepdk-45nm/mflowgen-debug.sh 1-freepdk-45nm 2> /dev/null || true && cd 1-freepdk-45nm && sh mflowgen-run.sh 2>&1 | tee mflowgen-run.log && cd .. && touch -c 1-freepdk-45nm/outputs/*
endef

1-freepdk-45nm/outputs/.execstamp.adk: 1-freepdk-45nm/.stamp
	$(call 1_freepdk_45nm_commands_rule)
	touch $@

# collect outputs

1-freepdk-45nm/outputs/.stamp.adk: 1-freepdk-45nm/outputs/.execstamp.adk
	$(call stamp,1-freepdk-45nm/outputs/.stamp.adk)

# alias

.PHONY: freepdk-45nm

freepdk-45nm: 1-freepdk-45nm/outputs/.stamp.adk 1-freepdk-45nm/outputs/.execstamp.adk

.PHONY: 1

1: 1-freepdk-45nm/outputs/.stamp.adk 1-freepdk-45nm/outputs/.execstamp.adk

# debug

# ------------------------------------------------------------------------
# sram
# ------------------------------------------------------------------------

# build dir

2-sram/.stamp:
	$(call cpdir-and-parameterize,2-sram,sram,2-sram/.stamp)

# collect inputs

# execute

define 2_sram_commands_rule
	mkdir -p 2-sram/outputs && python /afs/ir/class/ee272/mflowgen/utils/letters.py -c -t sram && cp -f .mflowgen/2-sram/mflowgen-run.sh 2-sram && cp -f .mflowgen/2-sram/mflowgen-debug.sh 2-sram 2> /dev/null || true && cd 2-sram && sh mflowgen-run.sh 2>&1 | tee mflowgen-run.log && cd .. && touch -c 2-sram/outputs/*
endef

2-sram/outputs/.execstamp.sram.sp: 2-sram/.stamp
	$(call 2_sram_commands_rule)
	touch $@

2-sram/outputs/.execstamp.sram.v: 2-sram/outputs/.execstamp.sram.sp
	touch $@
2-sram/outputs/.execstamp.sram.lib: 2-sram/outputs/.execstamp.sram.sp
	touch $@
2-sram/outputs/.execstamp.sram.lef: 2-sram/outputs/.execstamp.sram.sp
	touch $@
2-sram/outputs/.execstamp.sram_TT_3p3V_25C.lib: 2-sram/outputs/.execstamp.sram.sp
	touch $@
2-sram/outputs/.execstamp.sram_TT_3p3V_25C.db: 2-sram/outputs/.execstamp.sram.sp
	touch $@
2-sram/outputs/.execstamp.sram.gds: 2-sram/outputs/.execstamp.sram.sp
	touch $@

# collect outputs

2-sram/outputs/.stamp.sram.sp: 2-sram/outputs/.execstamp.sram.sp 2-sram/outputs/.execstamp.sram.v 2-sram/outputs/.execstamp.sram.lib 2-sram/outputs/.execstamp.sram.lef 2-sram/outputs/.execstamp.sram_TT_3p3V_25C.lib 2-sram/outputs/.execstamp.sram_TT_3p3V_25C.db 2-sram/outputs/.execstamp.sram.gds
	$(call stamp,2-sram/outputs/.stamp.sram.sp)

2-sram/outputs/.stamp.sram.v: 2-sram/outputs/.execstamp.sram.sp 2-sram/outputs/.execstamp.sram.v 2-sram/outputs/.execstamp.sram.lib 2-sram/outputs/.execstamp.sram.lef 2-sram/outputs/.execstamp.sram_TT_3p3V_25C.lib 2-sram/outputs/.execstamp.sram_TT_3p3V_25C.db 2-sram/outputs/.execstamp.sram.gds
	$(call stamp,2-sram/outputs/.stamp.sram.v)

2-sram/outputs/.stamp.sram.lib: 2-sram/outputs/.execstamp.sram.sp 2-sram/outputs/.execstamp.sram.v 2-sram/outputs/.execstamp.sram.lib 2-sram/outputs/.execstamp.sram.lef 2-sram/outputs/.execstamp.sram_TT_3p3V_25C.lib 2-sram/outputs/.execstamp.sram_TT_3p3V_25C.db 2-sram/outputs/.execstamp.sram.gds
	$(call stamp,2-sram/outputs/.stamp.sram.lib)

2-sram/outputs/.stamp.sram.lef: 2-sram/outputs/.execstamp.sram.sp 2-sram/outputs/.execstamp.sram.v 2-sram/outputs/.execstamp.sram.lib 2-sram/outputs/.execstamp.sram.lef 2-sram/outputs/.execstamp.sram_TT_3p3V_25C.lib 2-sram/outputs/.execstamp.sram_TT_3p3V_25C.db 2-sram/outputs/.execstamp.sram.gds
	$(call stamp,2-sram/outputs/.stamp.sram.lef)

2-sram/outputs/.stamp.sram_TT_3p3V_25C.lib: 2-sram/outputs/.execstamp.sram.sp 2-sram/outputs/.execstamp.sram.v 2-sram/outputs/.execstamp.sram.lib 2-sram/outputs/.execstamp.sram.lef 2-sram/outputs/.execstamp.sram_TT_3p3V_25C.lib 2-sram/outputs/.execstamp.sram_TT_3p3V_25C.db 2-sram/outputs/.execstamp.sram.gds
	$(call stamp,2-sram/outputs/.stamp.sram_TT_3p3V_25C.lib)

2-sram/outputs/.stamp.sram_TT_3p3V_25C.db: 2-sram/outputs/.execstamp.sram.sp 2-sram/outputs/.execstamp.sram.v 2-sram/outputs/.execstamp.sram.lib 2-sram/outputs/.execstamp.sram.lef 2-sram/outputs/.execstamp.sram_TT_3p3V_25C.lib 2-sram/outputs/.execstamp.sram_TT_3p3V_25C.db 2-sram/outputs/.execstamp.sram.gds
	$(call stamp,2-sram/outputs/.stamp.sram_TT_3p3V_25C.db)

2-sram/outputs/.stamp.sram.gds: 2-sram/outputs/.execstamp.sram.sp 2-sram/outputs/.execstamp.sram.v 2-sram/outputs/.execstamp.sram.lib 2-sram/outputs/.execstamp.sram.lef 2-sram/outputs/.execstamp.sram_TT_3p3V_25C.lib 2-sram/outputs/.execstamp.sram_TT_3p3V_25C.db 2-sram/outputs/.execstamp.sram.gds
	$(call stamp,2-sram/outputs/.stamp.sram.gds)

# alias

.PHONY: sram

sram: 2-sram/outputs/.stamp.sram.sp 2-sram/outputs/.stamp.sram_TT_3p3V_25C.lib 2-sram/outputs/.stamp.sram.lef 2-sram/outputs/.execstamp.sram_TT_3p3V_25C.lib 2-sram/outputs/.execstamp.sram.gds 2-sram/outputs/.stamp.sram.gds 2-sram/outputs/.execstamp.sram.lib 2-sram/outputs/.execstamp.sram.lef 2-sram/outputs/.stamp.sram.v 2-sram/outputs/.stamp.sram.lib 2-sram/outputs/.execstamp.sram.sp 2-sram/outputs/.execstamp.sram.v 2-sram/outputs/.stamp.sram_TT_3p3V_25C.db 2-sram/outputs/.execstamp.sram_TT_3p3V_25C.db

.PHONY: 2

2: 2-sram/outputs/.stamp.sram.sp 2-sram/outputs/.stamp.sram_TT_3p3V_25C.lib 2-sram/outputs/.stamp.sram.lef 2-sram/outputs/.execstamp.sram_TT_3p3V_25C.lib 2-sram/outputs/.execstamp.sram.gds 2-sram/outputs/.stamp.sram.gds 2-sram/outputs/.execstamp.sram.lib 2-sram/outputs/.execstamp.sram.lef 2-sram/outputs/.stamp.sram.v 2-sram/outputs/.stamp.sram.lib 2-sram/outputs/.execstamp.sram.sp 2-sram/outputs/.execstamp.sram.v 2-sram/outputs/.stamp.sram_TT_3p3V_25C.db 2-sram/outputs/.execstamp.sram_TT_3p3V_25C.db

# debug

# ------------------------------------------------------------------------
# constraints
# ------------------------------------------------------------------------

# build dir

3-constraints/.stamp:
	$(call cpdir-and-parameterize,3-constraints,constraints,3-constraints/.stamp)

# collect inputs

# execute

define 3_constraints_commands_rule
	mkdir -p 3-constraints/outputs && python /afs/ir/class/ee272/mflowgen/utils/letters.py -c -t constraints && cp -f .mflowgen/3-constraints/mflowgen-run.sh 3-constraints && cp -f .mflowgen/3-constraints/mflowgen-debug.sh 3-constraints 2> /dev/null || true && cd 3-constraints && sh mflowgen-run.sh 2>&1 | tee mflowgen-run.log && cd .. && touch -c 3-constraints/outputs/*
endef

3-constraints/outputs/.execstamp.constraints.tcl: 3-constraints/.stamp
	$(call 3_constraints_commands_rule)
	touch $@

# collect outputs

3-constraints/outputs/.stamp.constraints.tcl: 3-constraints/outputs/.execstamp.constraints.tcl
	$(call stamp,3-constraints/outputs/.stamp.constraints.tcl)

# alias

.PHONY: constraints

constraints: 3-constraints/outputs/.stamp.constraints.tcl 3-constraints/outputs/.execstamp.constraints.tcl

.PHONY: 3

3: 3-constraints/outputs/.stamp.constraints.tcl 3-constraints/outputs/.execstamp.constraints.tcl

# debug

# ------------------------------------------------------------------------
# rtl
# ------------------------------------------------------------------------

# build dir

4-rtl/.stamp:
	$(call cpdir-and-parameterize,4-rtl,rtl,4-rtl/.stamp)

# collect inputs

# execute

define 4_rtl_commands_rule
	mkdir -p 4-rtl/outputs && python /afs/ir/class/ee272/mflowgen/utils/letters.py -c -t rtl && cp -f .mflowgen/4-rtl/mflowgen-run.sh 4-rtl && cp -f .mflowgen/4-rtl/mflowgen-debug.sh 4-rtl 2> /dev/null || true && cd 4-rtl && sh mflowgen-run.sh 2>&1 | tee mflowgen-run.log && cd .. && touch -c 4-rtl/outputs/*
endef

4-rtl/outputs/.execstamp.design.v: 4-rtl/.stamp
	$(call 4_rtl_commands_rule)
	touch $@

# collect outputs

4-rtl/outputs/.stamp.design.v: 4-rtl/outputs/.execstamp.design.v
	$(call stamp,4-rtl/outputs/.stamp.design.v)

# alias

.PHONY: rtl

rtl: 4-rtl/outputs/.stamp.design.v 4-rtl/outputs/.execstamp.design.v

.PHONY: 4

4: 4-rtl/outputs/.stamp.design.v 4-rtl/outputs/.execstamp.design.v

# debug

# ------------------------------------------------------------------------
# synopsys-dc-synthesis
# ------------------------------------------------------------------------

# build dir

5-synopsys-dc-synthesis/.stamp: 3-constraints/outputs/.stamp.constraints.tcl 3-constraints/outputs/.execstamp.constraints.tcl
5-synopsys-dc-synthesis/.stamp: 1-freepdk-45nm/outputs/.stamp.adk 1-freepdk-45nm/outputs/.execstamp.adk
5-synopsys-dc-synthesis/.stamp: 4-rtl/outputs/.stamp.design.v 4-rtl/outputs/.execstamp.design.v
5-synopsys-dc-synthesis/.stamp: 2-sram/outputs/.stamp.sram.sp 2-sram/outputs/.stamp.sram_TT_3p3V_25C.lib 2-sram/outputs/.stamp.sram.lef 2-sram/outputs/.execstamp.sram_TT_3p3V_25C.lib 2-sram/outputs/.execstamp.sram.gds 2-sram/outputs/.stamp.sram.gds 2-sram/outputs/.execstamp.sram.lib 2-sram/outputs/.execstamp.sram.lef 2-sram/outputs/.stamp.sram.v 2-sram/outputs/.stamp.sram.lib 2-sram/outputs/.execstamp.sram.sp 2-sram/outputs/.execstamp.sram.v 2-sram/outputs/.stamp.sram_TT_3p3V_25C.db 2-sram/outputs/.execstamp.sram_TT_3p3V_25C.db
5-synopsys-dc-synthesis/.stamp:
	$(call cpdir-and-parameterize,5-synopsys-dc-synthesis,../../../../../../../afs/ir/class/ee272/mflowgen/steps/synopsys-dc-synthesis,5-synopsys-dc-synthesis/.stamp)

# collect inputs

5-synopsys-dc-synthesis/inputs/.stamp.design.v: 5-synopsys-dc-synthesis/.stamp 4-rtl/outputs/.stamp.design.v
	$(call symlink,5-synopsys-dc-synthesis/inputs,design.v,../../4-rtl/outputs/design.v,.stamp.design.v)

5-synopsys-dc-synthesis/inputs/.stamp.adk: 5-synopsys-dc-synthesis/.stamp 1-freepdk-45nm/outputs/.stamp.adk
	$(call symlink,5-synopsys-dc-synthesis/inputs,adk,../../1-freepdk-45nm/outputs/adk,.stamp.adk)

5-synopsys-dc-synthesis/inputs/.stamp.constraints.tcl: 5-synopsys-dc-synthesis/.stamp 3-constraints/outputs/.stamp.constraints.tcl
	$(call symlink,5-synopsys-dc-synthesis/inputs,constraints.tcl,../../3-constraints/outputs/constraints.tcl,.stamp.constraints.tcl)

5-synopsys-dc-synthesis/inputs/.stamp.sram.v: 5-synopsys-dc-synthesis/.stamp 2-sram/outputs/.stamp.sram.v
	$(call symlink,5-synopsys-dc-synthesis/inputs,sram.v,../../2-sram/outputs/sram.v,.stamp.sram.v)

5-synopsys-dc-synthesis/inputs/.stamp.sram_TT_3p3V_25C.lib: 5-synopsys-dc-synthesis/.stamp 2-sram/outputs/.stamp.sram_TT_3p3V_25C.lib
	$(call symlink,5-synopsys-dc-synthesis/inputs,sram_TT_3p3V_25C.lib,../../2-sram/outputs/sram_TT_3p3V_25C.lib,.stamp.sram_TT_3p3V_25C.lib)

5-synopsys-dc-synthesis/inputs/.stamp.sram.gds: 5-synopsys-dc-synthesis/.stamp 2-sram/outputs/.stamp.sram.gds
	$(call symlink,5-synopsys-dc-synthesis/inputs,sram.gds,../../2-sram/outputs/sram.gds,.stamp.sram.gds)

5-synopsys-dc-synthesis/inputs/.stamp.sram.lef: 5-synopsys-dc-synthesis/.stamp 2-sram/outputs/.stamp.sram.lef
	$(call symlink,5-synopsys-dc-synthesis/inputs,sram.lef,../../2-sram/outputs/sram.lef,.stamp.sram.lef)

5-synopsys-dc-synthesis/inputs/.stamp.sram.sp: 5-synopsys-dc-synthesis/.stamp 2-sram/outputs/.stamp.sram.sp
	$(call symlink,5-synopsys-dc-synthesis/inputs,sram.sp,../../2-sram/outputs/sram.sp,.stamp.sram.sp)

5-synopsys-dc-synthesis/inputs/.stamp.sram_TT_3p3V_25C.db: 5-synopsys-dc-synthesis/.stamp 2-sram/outputs/.stamp.sram_TT_3p3V_25C.db
	$(call symlink,5-synopsys-dc-synthesis/inputs,sram_TT_3p3V_25C.db,../../2-sram/outputs/sram_TT_3p3V_25C.db,.stamp.sram_TT_3p3V_25C.db)

5-synopsys-dc-synthesis/inputs/.stamp.sram.lib: 5-synopsys-dc-synthesis/.stamp 2-sram/outputs/.stamp.sram.lib
	$(call symlink,5-synopsys-dc-synthesis/inputs,sram.lib,../../2-sram/outputs/sram.lib,.stamp.sram.lib)

# execute

define 5_synopsys_dc_synthesis_commands_rule
	mkdir -p 5-synopsys-dc-synthesis/outputs && python /afs/ir/class/ee272/mflowgen/utils/letters.py -c -t synopsys-dc-synthesis && cp -f .mflowgen/5-synopsys-dc-synthesis/mflowgen-run.sh 5-synopsys-dc-synthesis && cp -f .mflowgen/5-synopsys-dc-synthesis/mflowgen-debug.sh 5-synopsys-dc-synthesis 2> /dev/null || true && cd 5-synopsys-dc-synthesis && sh mflowgen-run.sh 2>&1 | tee mflowgen-run.log && cd .. && touch -c 5-synopsys-dc-synthesis/outputs/*
endef

5-synopsys-dc-synthesis/outputs/.execstamp.design.v: 5-synopsys-dc-synthesis/inputs/.stamp.sram.sp 5-synopsys-dc-synthesis/inputs/.stamp.sram_TT_3p3V_25C.lib 5-synopsys-dc-synthesis/inputs/.stamp.sram.lef 5-synopsys-dc-synthesis/inputs/.stamp.adk 5-synopsys-dc-synthesis/inputs/.stamp.design.v 5-synopsys-dc-synthesis/inputs/.stamp.sram.lib 5-synopsys-dc-synthesis/inputs/.stamp.sram.gds 5-synopsys-dc-synthesis/inputs/.stamp.sram.v 5-synopsys-dc-synthesis/.stamp 5-synopsys-dc-synthesis/inputs/.stamp.sram_TT_3p3V_25C.db 5-synopsys-dc-synthesis/inputs/.stamp.constraints.tcl
	$(call 5_synopsys_dc_synthesis_commands_rule)
	touch $@

5-synopsys-dc-synthesis/outputs/.execstamp.design.sdc: 5-synopsys-dc-synthesis/outputs/.execstamp.design.v
	touch $@
5-synopsys-dc-synthesis/outputs/.execstamp.design.namemap: 5-synopsys-dc-synthesis/outputs/.execstamp.design.v
	touch $@

# collect outputs

5-synopsys-dc-synthesis/outputs/.stamp.design.v: 5-synopsys-dc-synthesis/outputs/.execstamp.design.v 5-synopsys-dc-synthesis/outputs/.execstamp.design.sdc 5-synopsys-dc-synthesis/outputs/.execstamp.design.namemap
	$(call stamp,5-synopsys-dc-synthesis/outputs/.stamp.design.v)

5-synopsys-dc-synthesis/outputs/.stamp.design.sdc: 5-synopsys-dc-synthesis/outputs/.execstamp.design.v 5-synopsys-dc-synthesis/outputs/.execstamp.design.sdc 5-synopsys-dc-synthesis/outputs/.execstamp.design.namemap
	$(call stamp,5-synopsys-dc-synthesis/outputs/.stamp.design.sdc)

5-synopsys-dc-synthesis/outputs/.stamp.design.namemap: 5-synopsys-dc-synthesis/outputs/.execstamp.design.v 5-synopsys-dc-synthesis/outputs/.execstamp.design.sdc 5-synopsys-dc-synthesis/outputs/.execstamp.design.namemap
	$(call stamp,5-synopsys-dc-synthesis/outputs/.stamp.design.namemap)

# alias

.PHONY: synopsys-dc-synthesis

synopsys-dc-synthesis: 5-synopsys-dc-synthesis/outputs/.stamp.design.v 5-synopsys-dc-synthesis/outputs/.execstamp.design.v 5-synopsys-dc-synthesis/outputs/.execstamp.design.sdc 5-synopsys-dc-synthesis/outputs/.execstamp.design.namemap 5-synopsys-dc-synthesis/outputs/.stamp.design.namemap 5-synopsys-dc-synthesis/outputs/.stamp.design.sdc

.PHONY: 5

5: 5-synopsys-dc-synthesis/outputs/.stamp.design.v 5-synopsys-dc-synthesis/outputs/.execstamp.design.v 5-synopsys-dc-synthesis/outputs/.execstamp.design.sdc 5-synopsys-dc-synthesis/outputs/.execstamp.design.namemap 5-synopsys-dc-synthesis/outputs/.stamp.design.namemap 5-synopsys-dc-synthesis/outputs/.stamp.design.sdc

# debug

define 5_debug_rule
	cd 5-synopsys-dc-synthesis && sh mflowgen-debug.sh 2>&1 | tee mflowgen-debug.log
endef

debug-synopsys-dc-synthesis: 
	$(call 5_debug_rule)

.PHONY: debug-5

debug-5: debug-synopsys-dc-synthesis

# ------------------------------------------------------------------------
# Misc
# ------------------------------------------------------------------------

# Clean

.PHONY: clean-all

clean-all:
	rm -rf ./0-info ./1-freepdk-45nm ./2-sram ./3-constraints ./4-rtl ./5-synopsys-dc-synthesis

.PHONY: clean-0

clean-0:
	rm -rf ./0-info

.PHONY: clean-1

clean-1:
	rm -rf ./1-freepdk-45nm

.PHONY: clean-2

clean-2:
	rm -rf ./2-sram

.PHONY: clean-3

clean-3:
	rm -rf ./3-constraints

.PHONY: clean-4

clean-4:
	rm -rf ./4-rtl

.PHONY: clean-5

clean-5:
	rm -rf ./5-synopsys-dc-synthesis

# Diff

.PHONY: diff-0

diff-0:
	@echo && diff -r -u --minimal --exclude={configure.yml,.time_end,.time_start,mflowgen-run.*,mflowgen-debug.*,.stamp,inputs,outputs} ../../../../../../../afs/ir/class/ee272/mflowgen/steps/info 0-info | grep --color=always -e '^-.*' -e '$$' -e 'Only in ../../../../../../../afs/ir/class/ee272/mflowgen/steps/info.*' | GREP_COLOR='01;32' grep --color=always -e '^+.*' -e '$$' -e 'Only in 0-info.*' && echo || true

.PHONY: diff-1

diff-1:
	@echo && diff -r -u --minimal --exclude={configure.yml,.time_end,.time_start,mflowgen-run.*,mflowgen-debug.*,.stamp,inputs,outputs} ../../../../../../../afs/ir/class/ee272/mflowgen/adks/freepdk-45nm 1-freepdk-45nm | grep --color=always -e '^-.*' -e '$$' -e 'Only in ../../../../../../../afs/ir/class/ee272/mflowgen/adks/freepdk-45nm.*' | GREP_COLOR='01;32' grep --color=always -e '^+.*' -e '$$' -e 'Only in 1-freepdk-45nm.*' && echo || true

.PHONY: diff-2

diff-2:
	@echo && diff -r -u --minimal --exclude={configure.yml,.time_end,.time_start,mflowgen-run.*,mflowgen-debug.*,.stamp,inputs,outputs} sram 2-sram | grep --color=always -e '^-.*' -e '$$' -e 'Only in sram.*' | GREP_COLOR='01;32' grep --color=always -e '^+.*' -e '$$' -e 'Only in 2-sram.*' && echo || true

.PHONY: diff-3

diff-3:
	@echo && diff -r -u --minimal --exclude={configure.yml,.time_end,.time_start,mflowgen-run.*,mflowgen-debug.*,.stamp,inputs,outputs} constraints 3-constraints | grep --color=always -e '^-.*' -e '$$' -e 'Only in constraints.*' | GREP_COLOR='01;32' grep --color=always -e '^+.*' -e '$$' -e 'Only in 3-constraints.*' && echo || true

.PHONY: diff-4

diff-4:
	@echo && diff -r -u --minimal --exclude={configure.yml,.time_end,.time_start,mflowgen-run.*,mflowgen-debug.*,.stamp,inputs,outputs} rtl 4-rtl | grep --color=always -e '^-.*' -e '$$' -e 'Only in rtl.*' | GREP_COLOR='01;32' grep --color=always -e '^+.*' -e '$$' -e 'Only in 4-rtl.*' && echo || true

.PHONY: diff-5

diff-5:
	@echo && diff -r -u --minimal --exclude={configure.yml,.time_end,.time_start,mflowgen-run.*,mflowgen-debug.*,.stamp,inputs,outputs} ../../../../../../../afs/ir/class/ee272/mflowgen/steps/synopsys-dc-synthesis 5-synopsys-dc-synthesis | grep --color=always -e '^-.*' -e '$$' -e 'Only in ../../../../../../../afs/ir/class/ee272/mflowgen/steps/synopsys-dc-synthesis.*' | GREP_COLOR='01;32' grep --color=always -e '^+.*' -e '$$' -e 'Only in 5-synopsys-dc-synthesis.*' && echo || true

# Runtimes

.PHONY: runtimes

runtimes:
	@python /afs/ir/class/ee272/mflowgen/utils/runtimes.py

# List

.PHONY: list

list:
	@echo && echo Generic Targets\: && echo && printf " - %s\n" "list      -- List all steps" "status    -- Print build status for each step" "runtimes  -- Print runtimes for each step" "graph     -- Generate a PDF of the step dependency graph" "clean-all -- Remove all build directories" "clean-N   -- Clean target N" "diff-N    -- Diff target N" && echo && echo Targets\: && echo && printf " - %s\n" " 0 : info" " 1 : freepdk-45nm" " 2 : sram" " 3 : constraints" " 4 : rtl" " 5 : synopsys-dc-synthesis" && echo && echo Debug Targets\: && echo && printf " - %s\n" "debug-5  : debug-synopsys-dc-synthesis" && echo

# Graph

.PHONY: graph

graph:
	dot -Tpdf .mflowgen/graph.dot > graph.pdf

# Status

.PHONY: status

status:
	@python /afs/ir/class/ee272/mflowgen/utils/status.py -s 0-info,5-synopsys-dc-synthesis,1-freepdk-45nm,4-rtl,2-sram,3-constraints


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

default: freepdk-45nm info constraints rtl synopsys-dc-synthesis

# ------------------------------------------------------------------------
# freepdk-45nm
# ------------------------------------------------------------------------

# build dir

0-freepdk-45nm/.stamp:
	$(call cpdir-and-parameterize,0-freepdk-45nm,../../../../../../../afs/ir/class/ee272/mflowgen/adks/freepdk-45nm,0-freepdk-45nm/.stamp)

# collect inputs

# execute

define 0_freepdk_45nm_commands_rule
	mkdir -p 0-freepdk-45nm/outputs && python /afs/ir/class/ee272/mflowgen/utils/letters.py -c -t freepdk-45nm && cp -f .mflowgen/0-freepdk-45nm/mflowgen-run.sh 0-freepdk-45nm && cp -f .mflowgen/0-freepdk-45nm/mflowgen-debug.sh 0-freepdk-45nm 2> /dev/null || true && cd 0-freepdk-45nm && sh mflowgen-run.sh 2>&1 | tee mflowgen-run.log && cd .. && touch -c 0-freepdk-45nm/outputs/*
endef

0-freepdk-45nm/outputs/.execstamp.adk: 0-freepdk-45nm/.stamp
	$(call 0_freepdk_45nm_commands_rule)
	touch $@

# collect outputs

0-freepdk-45nm/outputs/.stamp.adk: 0-freepdk-45nm/outputs/.execstamp.adk
	$(call stamp,0-freepdk-45nm/outputs/.stamp.adk)

# alias

.PHONY: freepdk-45nm

freepdk-45nm: 0-freepdk-45nm/outputs/.execstamp.adk 0-freepdk-45nm/outputs/.stamp.adk

.PHONY: 0

0: 0-freepdk-45nm/outputs/.execstamp.adk 0-freepdk-45nm/outputs/.stamp.adk

# debug

# ------------------------------------------------------------------------
# info
# ------------------------------------------------------------------------

# build dir

1-info/.stamp:
	$(call cpdir-and-parameterize,1-info,../../../../../../../afs/ir/class/ee272/mflowgen/steps/info,1-info/.stamp)

# collect inputs

# execute

define 1_info_commands_rule
	mkdir -p 1-info/outputs && python /afs/ir/class/ee272/mflowgen/utils/letters.py -c -t info && cp -f .mflowgen/1-info/mflowgen-run.sh 1-info && cp -f .mflowgen/1-info/mflowgen-debug.sh 1-info 2> /dev/null || true && cd 1-info && sh mflowgen-run.sh 2>&1 | tee mflowgen-run.log && cd .. && touch -c 1-info/outputs/*
endef

1-info/.execstamp.execute-phony: 1-info/.stamp
	$(call 1_info_commands_rule)

# collect outputs

# alias

.PHONY: info

info: 1-info/.execstamp.execute-phony

.PHONY: 1

1: 1-info/.execstamp.execute-phony

# debug

# ------------------------------------------------------------------------
# constraints
# ------------------------------------------------------------------------

# build dir

2-constraints/.stamp:
	$(call cpdir-and-parameterize,2-constraints,../design/constraints,2-constraints/.stamp)

# collect inputs

# execute

define 2_constraints_commands_rule
	mkdir -p 2-constraints/outputs && python /afs/ir/class/ee272/mflowgen/utils/letters.py -c -t constraints && cp -f .mflowgen/2-constraints/mflowgen-run.sh 2-constraints && cp -f .mflowgen/2-constraints/mflowgen-debug.sh 2-constraints 2> /dev/null || true && cd 2-constraints && sh mflowgen-run.sh 2>&1 | tee mflowgen-run.log && cd .. && touch -c 2-constraints/outputs/*
endef

2-constraints/outputs/.execstamp.constraints.tcl: 2-constraints/.stamp
	$(call 2_constraints_commands_rule)
	touch $@

# collect outputs

2-constraints/outputs/.stamp.constraints.tcl: 2-constraints/outputs/.execstamp.constraints.tcl
	$(call stamp,2-constraints/outputs/.stamp.constraints.tcl)

# alias

.PHONY: constraints

constraints: 2-constraints/outputs/.stamp.constraints.tcl 2-constraints/outputs/.execstamp.constraints.tcl

.PHONY: 2

2: 2-constraints/outputs/.stamp.constraints.tcl 2-constraints/outputs/.execstamp.constraints.tcl

# debug

# ------------------------------------------------------------------------
# rtl
# ------------------------------------------------------------------------

# build dir

3-rtl/.stamp:
	$(call cpdir-and-parameterize,3-rtl,../design/rtl,3-rtl/.stamp)

# collect inputs

# execute

define 3_rtl_commands_rule
	mkdir -p 3-rtl/outputs && python /afs/ir/class/ee272/mflowgen/utils/letters.py -c -t rtl && cp -f .mflowgen/3-rtl/mflowgen-run.sh 3-rtl && cp -f .mflowgen/3-rtl/mflowgen-debug.sh 3-rtl 2> /dev/null || true && cd 3-rtl && sh mflowgen-run.sh 2>&1 | tee mflowgen-run.log && cd .. && touch -c 3-rtl/outputs/*
endef

3-rtl/outputs/.execstamp.design.v: 3-rtl/.stamp
	$(call 3_rtl_commands_rule)
	touch $@

# collect outputs

3-rtl/outputs/.stamp.design.v: 3-rtl/outputs/.execstamp.design.v
	$(call stamp,3-rtl/outputs/.stamp.design.v)

# alias

.PHONY: rtl

rtl: 3-rtl/outputs/.execstamp.design.v 3-rtl/outputs/.stamp.design.v

.PHONY: 3

3: 3-rtl/outputs/.execstamp.design.v 3-rtl/outputs/.stamp.design.v

# debug

# ------------------------------------------------------------------------
# synopsys-dc-synthesis
# ------------------------------------------------------------------------

# build dir

4-synopsys-dc-synthesis/.stamp: 2-constraints/outputs/.stamp.constraints.tcl 2-constraints/outputs/.execstamp.constraints.tcl
4-synopsys-dc-synthesis/.stamp: 3-rtl/outputs/.execstamp.design.v 3-rtl/outputs/.stamp.design.v
4-synopsys-dc-synthesis/.stamp: 0-freepdk-45nm/outputs/.execstamp.adk 0-freepdk-45nm/outputs/.stamp.adk
4-synopsys-dc-synthesis/.stamp:
	$(call cpdir-and-parameterize,4-synopsys-dc-synthesis,../../../../../../../afs/ir/class/ee272/mflowgen/steps/synopsys-dc-synthesis,4-synopsys-dc-synthesis/.stamp)

# collect inputs

4-synopsys-dc-synthesis/inputs/.stamp.design.v: 4-synopsys-dc-synthesis/.stamp 3-rtl/outputs/.stamp.design.v
	$(call symlink,4-synopsys-dc-synthesis/inputs,design.v,../../3-rtl/outputs/design.v,.stamp.design.v)

4-synopsys-dc-synthesis/inputs/.stamp.adk: 4-synopsys-dc-synthesis/.stamp 0-freepdk-45nm/outputs/.stamp.adk
	$(call symlink,4-synopsys-dc-synthesis/inputs,adk,../../0-freepdk-45nm/outputs/adk,.stamp.adk)

4-synopsys-dc-synthesis/inputs/.stamp.constraints.tcl: 4-synopsys-dc-synthesis/.stamp 2-constraints/outputs/.stamp.constraints.tcl
	$(call symlink,4-synopsys-dc-synthesis/inputs,constraints.tcl,../../2-constraints/outputs/constraints.tcl,.stamp.constraints.tcl)

# execute

define 4_synopsys_dc_synthesis_commands_rule
	mkdir -p 4-synopsys-dc-synthesis/outputs && python /afs/ir/class/ee272/mflowgen/utils/letters.py -c -t synopsys-dc-synthesis && cp -f .mflowgen/4-synopsys-dc-synthesis/mflowgen-run.sh 4-synopsys-dc-synthesis && cp -f .mflowgen/4-synopsys-dc-synthesis/mflowgen-debug.sh 4-synopsys-dc-synthesis 2> /dev/null || true && cd 4-synopsys-dc-synthesis && sh mflowgen-run.sh 2>&1 | tee mflowgen-run.log && cd .. && touch -c 4-synopsys-dc-synthesis/outputs/*
endef

4-synopsys-dc-synthesis/outputs/.execstamp.design.v: 4-synopsys-dc-synthesis/inputs/.stamp.design.v 4-synopsys-dc-synthesis/.stamp 4-synopsys-dc-synthesis/inputs/.stamp.constraints.tcl 4-synopsys-dc-synthesis/inputs/.stamp.adk
	$(call 4_synopsys_dc_synthesis_commands_rule)
	touch $@

4-synopsys-dc-synthesis/outputs/.execstamp.design.sdc: 4-synopsys-dc-synthesis/outputs/.execstamp.design.v
	touch $@
4-synopsys-dc-synthesis/outputs/.execstamp.design.namemap: 4-synopsys-dc-synthesis/outputs/.execstamp.design.v
	touch $@

# collect outputs

4-synopsys-dc-synthesis/outputs/.stamp.design.v: 4-synopsys-dc-synthesis/outputs/.execstamp.design.v 4-synopsys-dc-synthesis/outputs/.execstamp.design.sdc 4-synopsys-dc-synthesis/outputs/.execstamp.design.namemap
	$(call stamp,4-synopsys-dc-synthesis/outputs/.stamp.design.v)

4-synopsys-dc-synthesis/outputs/.stamp.design.sdc: 4-synopsys-dc-synthesis/outputs/.execstamp.design.v 4-synopsys-dc-synthesis/outputs/.execstamp.design.sdc 4-synopsys-dc-synthesis/outputs/.execstamp.design.namemap
	$(call stamp,4-synopsys-dc-synthesis/outputs/.stamp.design.sdc)

4-synopsys-dc-synthesis/outputs/.stamp.design.namemap: 4-synopsys-dc-synthesis/outputs/.execstamp.design.v 4-synopsys-dc-synthesis/outputs/.execstamp.design.sdc 4-synopsys-dc-synthesis/outputs/.execstamp.design.namemap
	$(call stamp,4-synopsys-dc-synthesis/outputs/.stamp.design.namemap)

# alias

.PHONY: synopsys-dc-synthesis

synopsys-dc-synthesis: 4-synopsys-dc-synthesis/outputs/.execstamp.design.sdc 4-synopsys-dc-synthesis/outputs/.stamp.design.v 4-synopsys-dc-synthesis/outputs/.execstamp.design.v 4-synopsys-dc-synthesis/outputs/.stamp.design.sdc 4-synopsys-dc-synthesis/outputs/.execstamp.design.namemap 4-synopsys-dc-synthesis/outputs/.stamp.design.namemap

.PHONY: 4

4: 4-synopsys-dc-synthesis/outputs/.execstamp.design.sdc 4-synopsys-dc-synthesis/outputs/.stamp.design.v 4-synopsys-dc-synthesis/outputs/.execstamp.design.v 4-synopsys-dc-synthesis/outputs/.stamp.design.sdc 4-synopsys-dc-synthesis/outputs/.execstamp.design.namemap 4-synopsys-dc-synthesis/outputs/.stamp.design.namemap

# debug

define 4_debug_rule
	cd 4-synopsys-dc-synthesis && sh mflowgen-debug.sh 2>&1 | tee mflowgen-debug.log
endef

debug-synopsys-dc-synthesis: 
	$(call 4_debug_rule)

.PHONY: debug-4

debug-4: debug-synopsys-dc-synthesis

# ------------------------------------------------------------------------
# Misc
# ------------------------------------------------------------------------

# Clean

.PHONY: clean-all

clean-all:
	rm -rf ./0-freepdk-45nm ./1-info ./2-constraints ./3-rtl ./4-synopsys-dc-synthesis

.PHONY: clean-0

clean-0:
	rm -rf ./0-freepdk-45nm

.PHONY: clean-1

clean-1:
	rm -rf ./1-info

.PHONY: clean-2

clean-2:
	rm -rf ./2-constraints

.PHONY: clean-3

clean-3:
	rm -rf ./3-rtl

.PHONY: clean-4

clean-4:
	rm -rf ./4-synopsys-dc-synthesis

# Diff

.PHONY: diff-0

diff-0:
	@echo && diff -r -u --minimal --exclude={configure.yml,.time_end,.time_start,mflowgen-run.*,mflowgen-debug.*,.stamp,inputs,outputs} ../../../../../../../afs/ir/class/ee272/mflowgen/adks/freepdk-45nm 0-freepdk-45nm | grep --color=always -e '^-.*' -e '$$' -e 'Only in ../../../../../../../afs/ir/class/ee272/mflowgen/adks/freepdk-45nm.*' | GREP_COLOR='01;32' grep --color=always -e '^+.*' -e '$$' -e 'Only in 0-freepdk-45nm.*' && echo || true

.PHONY: diff-1

diff-1:
	@echo && diff -r -u --minimal --exclude={configure.yml,.time_end,.time_start,mflowgen-run.*,mflowgen-debug.*,.stamp,inputs,outputs} ../../../../../../../afs/ir/class/ee272/mflowgen/steps/info 1-info | grep --color=always -e '^-.*' -e '$$' -e 'Only in ../../../../../../../afs/ir/class/ee272/mflowgen/steps/info.*' | GREP_COLOR='01;32' grep --color=always -e '^+.*' -e '$$' -e 'Only in 1-info.*' && echo || true

.PHONY: diff-2

diff-2:
	@echo && diff -r -u --minimal --exclude={configure.yml,.time_end,.time_start,mflowgen-run.*,mflowgen-debug.*,.stamp,inputs,outputs} ../design/constraints 2-constraints | grep --color=always -e '^-.*' -e '$$' -e 'Only in ../design/constraints.*' | GREP_COLOR='01;32' grep --color=always -e '^+.*' -e '$$' -e 'Only in 2-constraints.*' && echo || true

.PHONY: diff-3

diff-3:
	@echo && diff -r -u --minimal --exclude={configure.yml,.time_end,.time_start,mflowgen-run.*,mflowgen-debug.*,.stamp,inputs,outputs} ../design/rtl 3-rtl | grep --color=always -e '^-.*' -e '$$' -e 'Only in ../design/rtl.*' | GREP_COLOR='01;32' grep --color=always -e '^+.*' -e '$$' -e 'Only in 3-rtl.*' && echo || true

.PHONY: diff-4

diff-4:
	@echo && diff -r -u --minimal --exclude={configure.yml,.time_end,.time_start,mflowgen-run.*,mflowgen-debug.*,.stamp,inputs,outputs} ../../../../../../../afs/ir/class/ee272/mflowgen/steps/synopsys-dc-synthesis 4-synopsys-dc-synthesis | grep --color=always -e '^-.*' -e '$$' -e 'Only in ../../../../../../../afs/ir/class/ee272/mflowgen/steps/synopsys-dc-synthesis.*' | GREP_COLOR='01;32' grep --color=always -e '^+.*' -e '$$' -e 'Only in 4-synopsys-dc-synthesis.*' && echo || true

# Runtimes

.PHONY: runtimes

runtimes:
	@python /afs/ir/class/ee272/mflowgen/utils/runtimes.py

# List

.PHONY: list

list:
	@echo && echo Generic Targets\: && echo && printf " - %s\n" "list      -- List all steps" "status    -- Print build status for each step" "runtimes  -- Print runtimes for each step" "graph     -- Generate a PDF of the step dependency graph" "clean-all -- Remove all build directories" "clean-N   -- Clean target N" "diff-N    -- Diff target N" && echo && echo Targets\: && echo && printf " - %s\n" " 0 : freepdk-45nm" " 1 : info" " 2 : constraints" " 3 : rtl" " 4 : synopsys-dc-synthesis" && echo && echo Debug Targets\: && echo && printf " - %s\n" "debug-4  : debug-synopsys-dc-synthesis" && echo

# Graph

.PHONY: graph

graph:
	dot -Tpdf .mflowgen/graph.dot > graph.pdf

# Status

.PHONY: status

status:
	@python /afs/ir/class/ee272/mflowgen/utils/status.py -s 0-freepdk-45nm,1-info,3-rtl,4-synopsys-dc-synthesis,2-constraints


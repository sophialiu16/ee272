CATAPULT = /cad/mentor/2019.11/Catapult_Synthesis_10.4b-841621/Mgc_home/bin/catapult

build/Conv.v1/rtl.v: build/InputDoubleBuffer*.v1/rtl.v build/WeightDoubleBuffer*.v1/rtl.v build/SystolicArrayCore*.v1/rtl.v src/SystolicArray.h
	$(CATAPULT) -shell -file scripts/Conv.tcl

build/SystolicArrayCore*.v1/rtl.v: build/ProcessingElement*.v1/rtl.v src/SystolicArrayCore.h
	$(CATAPULT) -shell -file scripts/SystolicArrayCore.tcl

SystolicArrayCore: build/SystolicArrayCore*.v1/rtl.v

build/ProcessingElement*.v1/rtl.v: src/ProcessingElement.h
	$(CATAPULT) -shell -file scripts/ProcessingElement.tcl

ProcessingElement: build/ProcessingElement*.v1/rtl.v

build/InputDoubleBuffer*.v1/rtl.v: src/InputDoubleBuffer.h
	$(CATAPULT) -shell -file scripts/InputDoubleBuffer.tcl

InputDoubleBuffer: build/InputDoubleBuffer*.v1/rtl.v

build/WeightDoubleBuffer*.v1/rtl.v: src/WeightDoubleBuffer.h
	$(CATAPULT) -shell -file scripts/WeightDoubleBuffer.tcl

WeightDoubleBuffer: build/WeightDoubleBuffer*.v1/rtl.v

gui:
	$(CATAPULT) build.ccs

test/Conv.v1: 
	$(CATAPULT) -shell -file scripts/run_c_test.tcl

c_test: test/Conv.v1
	cd test/Conv.v1 && make -f scverify/Verify_orig_cxx_osci.mk clean
	cd test/Conv.v1 && make -f scverify/Verify_orig_cxx_osci.mk sim

rtl_test: build/Conv.v1/rtl.v
	$(CATAPULT) -shell -file scripts/run_rtl_test.tcl

.PHONY: clean gui c_test InputDoubleBuffer WeightDoubleBuffer SystolicArrayCore ProcessingElement
clean:
	rm -rf build.ccs
	rm -rf build

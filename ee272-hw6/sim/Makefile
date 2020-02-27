.PHONY: ringosc filter pll view_ringosc view_filter view_pll

XRUN=xrun
XRUN_FLAGS=+access+rw

SIMVISION=simvision
SIMVISION_FLAGS=

ringosc:
	$(XRUN) other/meas_freq.sv ringosc/ringosc.sv ringosc/ringosc_tb.sv $(XRUN_FLAGS)

filter:
	$(XRUN) filter/filter.sv filter/filter_tb.sv $(XRUN_FLAGS)

pll:
	$(XRUN) other/meas_freq.sv other/pi_ctrl.sv other/freq_div.sv ringosc/ringosc.sv filter/filter.sv pll/pll.sv pll/pll_tb.sv $(XRUN_FLAGS)

view_ringosc:
	$(SIMVISION) ringosc.shm -input ringosc/ringosc.svcf $(SIMVISION_FLAGS) &

view_filter:
	$(SIMVISION) filter.shm -input filter/filter.svcf $(SIMVISION_FLAGS) &

view_pll:
	$(SIMVISION) pll.shm -input pll/pll.svcf $(SIMVISION_FLAGS) &

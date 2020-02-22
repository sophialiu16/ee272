#ifndef __INCLUDED_sram_32_128_freepdk45_trans_rsc_H__
#define __INCLUDED_sram_32_128_freepdk45_trans_rsc_H__
#include <mc_transactors.h>

class sram_32_128_freepdk45_trans_rsc : public mc_wire_trans_rsc_base<32,128>
{
public:
  sc_in< sc_lv<32> >   din0;
  sc_out< sc_lv<32> >   dout0;
  sc_in< sc_lv<7> >   addr0;
  sc_in< sc_logic >   csb0;
  sc_in< sc_logic >   web0;
  sc_in< bool >   clk0;

  typedef mc_wire_trans_rsc_base<32,128> base;
  MC_EXPOSE_NAMES_OF_BASE(base);

  SC_HAS_PROCESS( sram_32_128_freepdk45_trans_rsc );
  sram_32_128_freepdk45_trans_rsc(const sc_module_name& name, bool phase, double clk_skew_delay=0.0)
    : base(name, phase, clk_skew_delay)
    ,din0("din0")
    ,dout0("dout0")
    ,addr0("addr0")
    ,csb0("csb0")
    ,web0("web0")
    ,clk0("clk0")
    ,_is_connected_port_0(true)
    ,_is_connected_port_0_messaged(false)
  {
    SC_METHOD(at_active_clock_edge);
    sensitive << (phase ? clk0.pos() : clk0.neg());
    this->dont_initialize();

    MC_METHOD(clk_skew_delay);
    this->sensitive << this->_clk_skew_event;
    this->dont_initialize();
  }

  virtual void start_of_simulation() {
    if ((base::_holdtime == 0.0) && this->get_attribute("CLK_SKEW_DELAY")) {
      base::_holdtime = ((sc_attribute<double>*)(this->get_attribute("CLK_SKEW_DELAY")))->value;
    }
    if (base::_holdtime > 0) {
      std::ostringstream msg;
      msg << "sram_32_128_freepdk45_trans_rsc CLASS_STARTUP - CLK_SKEW_DELAY = "
        << base::_holdtime << " ps @ " << sc_time_stamp();
      SC_REPORT_INFO(this->name(), msg.str().c_str());
    }
    reset_memory();
  }

  virtual void inject_value(int addr, int idx_lhs, int mywidth, sc_lv_base& rhs, int idx_rhs) {
    this->set_value(addr, idx_lhs, mywidth, rhs, idx_rhs);
  }

  virtual void extract_value(int addr, int idx_rhs, int mywidth, sc_lv_base& lhs, int idx_lhs) {
    this->get_value(addr, idx_rhs, mywidth, lhs, idx_lhs);
  }

private:
  void at_active_clock_edge() {
    base::at_active_clk();
  }

  void clk_skew_delay() {
    this->exchange_value(0);
    if (din0.get_interface())
      _din0 = din0.read();
    else {
      _is_connected_port_0 = false;
    }
    if (addr0.get_interface())
      _addr0 = addr0.read();
    else {
      _is_connected_port_0 = false;
    }
    if (csb0.get_interface())
      _csb0 = csb0.read();
    if (web0.get_interface())
      _web0 = web0.read();

    //  Write
    int _w_addr_port_0 = -1;
    if ( _is_connected_port_0 && (_csb0==0) && (_web0==0)) {
      _w_addr_port_0 = get_addr(_addr0, "addr0");
      if (_w_addr_port_0 >= 0)
        inject_value(_w_addr_port_0, 0, 32, _din0, 0);
    }
    if( !_is_connected_port_0 && !_is_connected_port_0_messaged) {
      std::ostringstream msg;msg << "port_0 is not fully connected and writes on it will be ignored";
      SC_REPORT_WARNING(this->name(), msg.str().c_str());
      _is_connected_port_0_messaged = true;
    }

    //  Sync Read
    if ((_csb0==0)) {
      const int addr = get_addr(_addr0, "addr0");
      if (addr >= 0)
      {
        if (addr==_w_addr_port_0) {
          sc_lv<32> dc; // X
          _dout0 = dc;
        }
        else
          extract_value(addr, 0, 32, _dout0, 0);
      }
      else { 
        sc_lv<32> dc; // X
        _dout0 = dc;
      }
    }
    if (dout0.get_interface())
      dout0 = _dout0;
    this->_value_changed.notify(SC_ZERO_TIME);
  }

  int get_addr(const sc_lv<7>& addr, const char* pin_name) {
    if (addr.is_01()) {
      const int cur_addr = addr.to_uint();
      if (cur_addr < 0 || cur_addr >= 128) {
#ifdef CCS_SYSC_DEBUG
        std::ostringstream msg;
        msg << "Invalid address '" << cur_addr << "' out of range [0:" << 128-1 << "]";
        SC_REPORT_WARNING(pin_name, msg.str().c_str());
#endif
        return -1;
      } else {
        return cur_addr;
      }
    } else {
#ifdef CCS_SYSC_DEBUG
      std::ostringstream msg;
      msg << "Invalid Address '" << addr << "' contains 'X' or 'Z'";
      SC_REPORT_WARNING(pin_name, msg.str().c_str());
#endif
      return -1;
    }
  }

  void reset_memory() {
    this->zero_data();
    _din0 = sc_lv<32>();
    _addr0 = sc_lv<7>();
    _csb0 = SC_LOGIC_X;
    _web0 = SC_LOGIC_X;
    _is_connected_port_0 = true;
    _is_connected_port_0_messaged = false;
  }

  sc_lv<32>  _din0;
  sc_lv<32>  _dout0;
  sc_lv<7>  _addr0;
  sc_logic _csb0;
  sc_logic _web0;
  bool _is_connected_port_0;
  bool _is_connected_port_0_messaged;
};
#endif // ifndef __INCLUDED_sram_32_128_freepdk45_trans_rsc_H__



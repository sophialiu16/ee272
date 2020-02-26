#ifndef __INCLUDED_sram_256_128_trans_rsc_H__
#define __INCLUDED_sram_256_128_trans_rsc_H__
#include <mc_transactors.h>

template < 
  int WRAPPER_WIDTH
  ,int WRAPPER_ADDR_BITS
>
class sram_256_128_trans_rsc : public mc_wire_trans_rsc_base<128,32768>
{
public:
  sc_in< bool >   clk;
  sc_in< sc_logic >   csb;
  sc_in< sc_logic >   web;
  sc_in< sc_lv<WRAPPER_ADDR_BITS> >   addr;
  sc_in< sc_lv<WRAPPER_WIDTH> >   din;
  sc_out< sc_lv<WRAPPER_WIDTH> >   dout;

  typedef mc_wire_trans_rsc_base<128,32768> base;
  MC_EXPOSE_NAMES_OF_BASE(base);

  SC_HAS_PROCESS( sram_256_128_trans_rsc );
  sram_256_128_trans_rsc(const sc_module_name& name, bool phase, double clk_skew_delay=0.0)
    : base(name, phase, clk_skew_delay)
    ,clk("clk")
    ,csb("csb")
    ,web("web")
    ,addr("addr")
    ,din("din")
    ,dout("dout")
    ,_is_connected_port_0(true)
    ,_is_connected_port_0_messaged(false)
  {
    SC_METHOD(at_active_clock_edge);
    sensitive << (phase ? clk.pos() : clk.neg());
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
      msg << "sram_256_128_trans_rsc CLASS_STARTUP - CLK_SKEW_DELAY = "
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
    if (csb.get_interface())
      _csb = csb.read();
    if (web.get_interface())
      _web = web.read();
    if (addr.get_interface())
      _addr = addr.read();
    else {
      _is_connected_port_0 = false;
    }
    if (din.get_interface())
      _din = din.read();
    else {
      _is_connected_port_0 = false;
    }

    //  Write
    int _w_addr_port_0 = -1;
    if ( _is_connected_port_0 && (_csb==0) && (_web==0)) {
      _w_addr_port_0 = get_addr(_addr, "addr");
      if (_w_addr_port_0 >= 0)
        inject_value(_w_addr_port_0, 0, 128, _din, 0);
    }
    if( !_is_connected_port_0 && !_is_connected_port_0_messaged) {
      std::ostringstream msg;msg << "port_0 is not fully connected and writes on it will be ignored";
      SC_REPORT_WARNING(this->name(), msg.str().c_str());
      _is_connected_port_0_messaged = true;
    }

    //  Sync Read
    if ((_csb==0)) {
      const int addr = get_addr(_addr, "addr");
      if (addr >= 0)
      {
        if (addr==_w_addr_port_0) {
          sc_lv<128> dc; // X
          _dout = dc;
        }
        else
          extract_value(addr, 0, 128, _dout, 0);
      }
      else { 
        sc_lv<128> dc; // X
        _dout = dc;
      }
    }
    if (dout.get_interface())
      dout = _dout;
    this->_value_changed.notify(SC_ZERO_TIME);
  }

  int get_addr(const sc_lv<WRAPPER_ADDR_BITS>& addr, const char* pin_name) {
    if (addr.is_01()) {
      const int cur_addr = addr.to_uint();
      if (cur_addr < 0 || cur_addr >= 32768) {
#ifdef CCS_SYSC_DEBUG
        std::ostringstream msg;
        msg << "Invalid address '" << cur_addr << "' out of range [0:" << 32768-1 << "]";
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
    _csb = SC_LOGIC_X;
    _web = SC_LOGIC_X;
    _addr = sc_lv<WRAPPER_ADDR_BITS>();
    _din = sc_lv<WRAPPER_WIDTH>();
    _is_connected_port_0 = true;
    _is_connected_port_0_messaged = false;
  }

  sc_logic _csb;
  sc_logic _web;
  sc_lv<WRAPPER_ADDR_BITS>  _addr;
  sc_lv<WRAPPER_WIDTH>  _din;
  sc_lv<WRAPPER_WIDTH>  _dout;
  bool _is_connected_port_0;
  bool _is_connected_port_0_messaged;
};
#endif // ifndef __INCLUDED_sram_256_128_trans_rsc_H__



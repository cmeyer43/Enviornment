#! /usr/bin/env python3
from gnuradio import gr
import pmt
import numpy as np

class block1(gr.basic_block):
    def __init__(self):
        gr.basic_block.__init__(self,
                                name=self.__class__.__name__,
                                in_sig=None,
                                out_sig=None)

        self.MSG_PORT = pmt.intern("pdus")
        self.message_port_register_in(self.MSG_PORT)
        #self.message_port_register_out(self.MSG_PORT)
        self.set_msg_handler(self.MSG_PORT, self.handle_pdu)

    def handle_pdu(self, pdus):
        meta = pmt.car(pdus)
        meta_py = pmt.to_python(meta)
        print(meta_py)
        vect = pmt.cdr(pdus)
        vect = pmt.to_python(vect)
        print(vect)
        pdu_out = pmt.cons(meta, pmt.to_pmt(vect))
        #self.message_port_pub(self.MSG_PORT, pdu_out)
        return

class block2(gr.basic_block):
    def __init__(self):
        gr.basic_block.__init__(self,
                                name=self.__class__.__name__,
                                in_sig=None,
                                out_sig=None)

        self.MSG_PORT = pmt.intern("pdus")
        self.message_port_register_out(self.MSG_PORT)

    def write_out(self):
        meta = pmt.make_dict()
        vect = np.zeros(3)
        val = 3
        meta = pmt.dict_add(meta, pmt.intern("val"), pmt.to_pmt(val))
        pdu_out = pmt.cons(meta, pmt.to_pmt(vect))
        self.message_port_pub(self.MSG_PORT, pdu_out)
        return

if __name__ == '__main__':
    tb = gr.top_block()
    b1 = block1()
    b2 = block2()
    tb.msg_connect(b2, 'pdus', b1, 'pdus')
    tb.start()
    b2.write_out()
    tb.stop()
    tb.wait()

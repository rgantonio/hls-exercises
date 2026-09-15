set_directive_interface -mode m_axi -bundle gmem -offset slave -depth 64 "iface" x
set_directive_interface -mode m_axi -bundle gmem -offset slave -depth 64 "iface" y
set_directive_interface -mode s_axilite -bundle control "iface" x
set_directive_interface -mode s_axilite -bundle control "iface" y
set_directive_interface -mode s_axilite -bundle control "iface" a
set_directive_interface -mode s_axilite -bundle control "iface" sum
set_directive_interface -mode s_axilite -bundle control "iface" return
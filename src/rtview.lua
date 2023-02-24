local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "4.0")
local Gdk = lgi.require("Gdk")

function test_rtview()
  local sw = Gtk.ScrolledWindow()
  
  local ov = Gtk.Overlay({halign=Gtk.Align.CENTER, width_request=807, height_request=1169})
  
  textview = Gtk.TextView({wrap_mode=Gtk.WrapMode.WORD_CHAR, margin_top=20, margin_bottom=20})
  textview:set_overflow(Gtk.Overflow.VISIBLE)
  sw:set_child(ov)
  ov:set_child(textview)
  
  buffer = textview:get_buffer()
  buffer:set_text("", -1)
  
  local t = Gtk.TextTag({editable=false, name="page-break-elm", left_margin=0, right_margin=0})
  buffer:get_tag_table():add(t)
  
  tab = {}
  
  buffer.on_end_user_action = function()
	for i, o in pairs(tab) do
		local ite = buffer:get_iter_at_child_anchor(o)
		ite:forward_char()
		buffer:delete(buffer:get_iter_at_child_anchor(o), ite)
	end
	for k,v in pairs(tab) do tab[k]=nil end
	
	pos = 1169
	l1 = 0
	l2 = buffer:get_end_iter():get_line()
	while (l1<l2) do
		local it = textview:get_line_at_y(pos, nil)
		local kn2 = Gtk.Button({label="", width_request=737, sensitive=false, margin_top=30, margin_bottom=30})
		local anchor = buffer:create_child_anchor(it)
		local it1 = buffer:get_iter_at_child_anchor(anchor)
		it1:forward_char()
		buffer:apply_tag_by_name("page-break-elm", buffer:get_iter_at_child_anchor(anchor), it1);
		textview:add_child_at_anchor(kn2, anchor)
		table.insert(tab, anchor)
		ov:set_size_request(807, pos)
		
		pos = pos + 1169 + ((#tab-1) * 50)
		l1 = it:get_line()
	end
	
	if (tab[#tab] ~= nil) then
		local Ci1 = buffer:get_iter_at_child_anchor(tab[#tab])
		local Ci = buffer:get_iter_at_child_anchor(tab[#tab])
		Ci:forward_char()
		buffer:delete(Ci1, Ci)
		tab[#tab]=nil
	end
	
	local cp = textview:get_cursor_locations(nil)
	local vj = sw:get_vadjustment()
	if (cp.y < vj:get_value() or cp.y > vj:get_value() + vj:get_page_size()) then
		sw:get_vadjustment():set_value(cp.y)
	end
		
  end
  
  return(sw)
end

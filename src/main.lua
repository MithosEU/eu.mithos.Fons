#!/usr/bin/env lua
path = debug.getinfo(1).source:match("@?(.*/)"):sub(1, -5)
package.path = "./" .. path .. "lib/eu.mithos.Fons/?.lua;" .. package.path

local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "4.0")
local Gdk = lgi.require("Gdk")
require("rtview")

local App = Gtk.Application({
  application_id = "eu.mithos.Fons"
})

local Builder = Gtk.Builder.new_from_file(path .. "/share/eu.mithos.Fons/window.ui")
local menuBarModel = Builder:get_object("menuBarModel")

function App:on_startup()
  App:set_menubar(menuBarModel)
  win = Builder:get_object("mainWindow")
  win:set_application(App)
  
  local provider = Gtk.CssProvider()
  provider:load_from_path(path .. "/share/eu.mithos.Fons/texttest.css")
  Gtk.StyleContext.add_provider_for_display(Gdk.Display.get_default(), provider, 600)
  
  local rtv1 = test_rtview()
  local tabStack = Builder:get_object("tabStack")
  tabStack:add_child(rtv1)
  
  --action test
  local a1 = lgi.Gio.SimpleAction.new_stateful("charstyle", lgi.GLib.VariantType.STRING, lgi.GLib.Variant("s", "l"))
  App:add_action(a1)
end

function App:on_activate()
  self.active_window:present()
end

return App:run(arg)

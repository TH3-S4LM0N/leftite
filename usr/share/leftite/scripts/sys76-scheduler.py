#!/usr/bin/env python3
# https://unix.stackexchange.com/questions/214921/getting-notified-about-window-title-changes
import Xlib
import Xlib.display
import os

disp = Xlib.display.Display()
root = disp.screen().root
cmd = "dbus-send --system --dest=com.system76.Scheduler /org/system76/Scheduler com.system76.Scheduler.SetForegroundProcess uint32:{id}"

NET_WM_NAME = disp.intern_atom('_NET_WM_NAME')
NET_ACTIVE_WINDOW = disp.intern_atom('_NET_ACTIVE_WINDOW')

root.change_attributes(event_mask=Xlib.X.FocusChangeMask)
while True:
    try:
        window_id = root.get_full_property(NET_ACTIVE_WINDOW, Xlib.X.AnyPropertyType).value[0]
        window = disp.create_resource_object('window', window_id)
        window.change_attributes(event_mask=Xlib.X.PropertyChangeMask)
        window_name = window.get_full_property(NET_WM_NAME, 0).value
    except Xlib.error.XError:
        window_name = None
    os.system(cmd.format(id = window_id))
    event = disp.next_event()
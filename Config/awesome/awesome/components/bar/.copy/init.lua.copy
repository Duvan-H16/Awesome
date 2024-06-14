local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local apps = require("config.apps")
local helpers = require("components.helpers")
local watch = require('awful.widget.watch')
local modkey = "Mod4"

-- Importar Widgets
local text_taglist = require("components.bar.taglist")
local battery = require("components.bar.battery")
local music = require("components.bar.music")
local network = require("components.bar.network")
local volume = require("components.bar.volume")
local update = require("components.bar.update")
local brightness = require("components.bar.brightness")

-- Definir intervalos de actualización
local interval = 5

watch('sh -c', interval, function()
    sb_wifi()
    sb_ethernet()
    sb_bluetooth()
    sb_battery()
end)

local musicinterval = 15
watch('sh -c', musicinterval, function(_, stdout)
    sb_music()
end)

-- Ruta de la imagen
local image_path = os.getenv("HOME") .. "/.config/awesome/components/bar/.icon/david.png"
print("Loading image from: " .. image_path)

-- Comprobar si la imagen se carga correctamente
local function file_exists(path)
    local f = io.open(path, "rb")
    if f then f:close() return true else return false end
end

if file_exists(image_path) then
    print("Image file found")
else
    print("Image file not found")
end

-- Widget de búsqueda con imagen
local search = wibox.widget {
    {
        {
            image = image_path,
            resize = true,
            widget = wibox.widget.imagebox,
        },
        shape = gears.shape.circle,
        clip_shape = true,
        widget = wibox.container.background,
    },
    layout = wibox.layout.fixed.horizontal,
    buttons = gears.table.join(
        awful.button({}, 1, function ()
            awful.spawn(apps.run)
        end)
    )
}

local notification = wibox.widget {
    wibox.widget {
        markup = "<span foreground='".. beautiful.blue .."'>󰵚 </span>",
        font = beautiful.iconfont .. " 14",
        widget = wibox.widget.textbox,
    },
    layout = wibox.layout.fixed.horizontal,
    buttons = gears.table.join(
        awful.button({}, 1, function ()
            notifs_toggle()
        end)
    )
}

local power = wibox.widget {
    wibox.widget {
        markup = "<span foreground='".. beautiful.blue .."'>⏻ </span>",
        font = beautiful.iconfont .. " 13",
        widget = wibox.widget.textbox,
    },
    layout = wibox.layout.fixed.horizontal,
    buttons = awful.button({}, 1, function ()
        exit_screen_show()
    end)
}

local time = wibox.widget.textclock("<span font='" .. beautiful.uifont .. " 14'>  %A %d %B %Y |   %I:%M:%S |  dia %j del año</span>", 60)

-- Crear barra para cada pantalla
awful.screen.connect_for_each_screen(function(s)

    s.padding = {top = 0}

    awful.tag({ "󰈹", "", "󰉋", "󰓇", "󰟴", "󰒓" }, s, awful.layout.layouts[1])

    local taglistbuttons = gears.table.join(
        awful.button({}, 1, function(t) t:view_only() end),
        awful.button({ modkey }, 1, function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
        end),
        awful.button({}, 3, awful.tag.viewtoggle),
        awful.button({ modkey }, 3, function(t)
            if client.focus then
                client.focus:toggle_tag(t)
            end
        end),
        awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
        awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
    )

    s.mytaglist = awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = taglistbuttons,
        layout = {
            forced_num_cols = 1,
            layout = wibox.layout.grid.horizontal,
        },
        forced_width = 5,
        forced_height = 5,
    }

    s.mytasklist = awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = {
            gears.table.join(
                awful.button({}, 1, function(c)
                    if c == client.focus then
                        c.minimized = true
                    else
                        c:emit_signal(
                            "request::activate",
                            "tasklist",
                            {raise = true}
                        )
                    end
                end),
                awful.button({}, 2, function()
                    awful.client:kill()
                end),
                awful.button({}, 3, function()
                    awful.menu.client_list({ theme = { width = 250 } })
                end),
                awful.button({}, 4, function()
                    awful.client.focus.byidx(1)
                end),
                awful.button({}, 5, function()
                    awful.client.focus.byidx(-1)
                end)
            )
        },
        style = {
            icon_size = 22,
            shape = helpers.rrect(dpi(6)),
        },
        layout = {
            spacing = dpi(4),
            spacing_widget = {
                valign = "center",
                halign = "center",
                widget = wibox.container.place,
            },
            layout = wibox.layout.flex.horizontal
        },
        widget_template = {
            {
                {
                    {
                        {
                            id = "icon_role",
                            widget = wibox.widget.imagebox,
                        },
                        top = dpi(1),
                        bottom = dpi(1),
                        left = dpi(4),
                        right = dpi(4),
                        widget = wibox.container.margin,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                left = dpi(3),
                right = dpi(3),
                widget = wibox.container.margin,
            },
            id = "background_role",
            widget = wibox.container.background,
        },
    }

    s.mypromptbox = awful.widget.prompt()
    s.systray = wibox.widget.systray()

    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({}, 1, function() awful.layout.inc(1) end),
        awful.button({}, 3, function() awful.layout.inc(-1) end),
        awful.button({}, 4, function() awful.layout.inc(1) end),
        awful.button({}, 5, function() awful.layout.inc(-1) end)
    ))

    local function barcontainer(widget)
        local container = wibox.widget {
            widget,
            top = dpi(1),
            bottom = dpi(1),
            left = dpi(3),
            right = dpi(3),
            widget = wibox.container.margin,
        }
        local box = wibox.widget {
            {
                container,
                top = dpi(1),
                bottom = dpi(1),
                left = dpi(4),
                right = dpi(4),
                widget = wibox.container.margin,
            },
            bg = beautiful.bluealt,
            shape = helpers.rrect(dpi(6)),
            widget = wibox.container.background,
        }
        return wibox.widget {
            box,
            top = dpi(4),
            bottom = dpi(4),
            right = dpi(2),
            left = dpi(2),
            widget = wibox.container.margin,
        }
    end

    local sysbox = wibox.widget {
        brightness,
        volume,
        battery,
        s.mylayoutbox,
        spacing = dpi(10),
        layout = wibox.layout.fixed.horizontal,
    }

    s.mywibox = awful.wibar({ position = "top", width = '100%', height = 40, screen = s, stretch = false, margins = 0, bg = beautiful.black })
    s.mywibox.y = 0

    s.mywibox:setup {
        layout = wibox.layout.stack,
        {
            layout = wibox.layout.align.horizontal,
            {
                barcontainer(search),
                barcontainer(text_taglist(s)),
                s.mypromptbox,
                {
                    s.mytasklist,
                    top = dpi(3),
                    bottom = dpi(3),
                    widget = wibox.container.margin,
                },
                layout = wibox.layout.fixed.horizontal,
            },
            nil,
            {
                barcontainer(s.systray),
                barcontainer(music),
                barcontainer(update),
                barcontainer(notification),
                barcontainer(network),
                barcontainer(sysbox),
                barcontainer(power),
                layout = wibox.layout.fixed.horizontal,
            },
        },
        {
            barcontainer(time),
            valign = "center",
            halign = "center",
            layout = wibox.container.place,
        },
    }
end)


local awful = require("awful")
local wibox = require('wibox')
local watch = require('awful.widget.watch')
local beautiful = require('beautiful')
local gears = require("gears")
local apps = require("config.apps")
local dpi = require('beautiful').xresources.apply_dpi

-- Definición de los íconos
local wifiicon = wibox.widget.textbox()
wifiicon.font = beautiful.iconfont .. " 13"
wifiicon.text = "󰤭  " -- Icono por defecto

local ethicon = wibox.widget.textbox()
ethicon.font = beautiful.iconfont .. " 13"
ethicon.text = " " -- Icono por defecto

local bticon = wibox.widget.textbox()
bticon.font = beautiful.iconfont .. " 13"
bticon.text = " " -- Icono por defecto

--local ethip = wibox.widget.textbox()
--ethip.font = beautiful.uifont .. " 12"

-- Obtención del estado de Bluetooth
function sb_bluetooth()
    awful.spawn.easy_async_with_shell("bluetoothctl show | grep Powered | awk '{print $2}'", function(out)
        if string.match(out, "no") then
            bticon.text = ' '
        else
            awful.spawn.easy_async_with_shell("bluetoothctl info >> /dev/null && echo connected  || echo on ", function(out)
                if string.match(out, "connected") then
                    bticon.text = ' '
                else
                    bticon.text = ' '
                end
            end)
        end
    end)
end

-- Obtención del estado de Ethernet y la dirección IP
function sb_ethernet()
    awful.spawn.easy_async_with_shell("sh -c 'cat /sys/class/net/en*/operstate'", function(out)
        if string.match(out, "up") then
            ethicon.text = ' '
--            awful.spawn.easy_async_with_shell("ip -4 addr show en* | grep -oP '(?<=inet\s)\d+(\.\d+){3}'", function(ip)
--                ethip.text = ip:match("%S+") -- Limpia el espacio en blanco al final
--            end)
        else
            ethicon.text = ' '
--            ethip.text = "" -- No muestra IP si no hay conexión
        end
    end)
end

-- Obtención del estado de WiFi
function sb_wifi()
    awful.spawn.easy_async_with_shell("sh -c 'cat /sys/class/net/wl*/flags'", function(out)
        if string.match(out, "0x1003") then
            local getstrength = [[awk '/^\s*w/ { print int($3 * 100 / 70) }' /proc/net/wireless]]
            awful.spawn.easy_async_with_shell(getstrength, function(stdout)
                local strength = tonumber(stdout) or 0
                if strength > 80 then
                    wifiicon.text = '󰤨 '
                elseif strength > 60 then
                    wifiicon.text = '󰤥 '
                elseif strength > 40 then
                    wifiicon.text = '󰤢 '
                elseif strength > 20 then
                    wifiicon.text = '󰤟 '
                else
                    wifiicon.text = '󰤯 '
                end
            end)
        else
            wifiicon.text = '󰤭 '
        end
    end)
end

-- Widget de WiFi
local wifi = wibox.widget {
    wibox.widget {
        wifiicon,
        fg = beautiful.blue,
        widget = wibox.container.background
    },
    spacing = dpi(6),
    layout = wibox.layout.fixed.horizontal,
    buttons = gears.table.join(
        awful.button({}, 1, function()
            awful.spawn.with_shell("~/.config/rofi/wifi/wifi")
            sb_wifi()
        end)
    )
}

-- Widget de Ethernet
local ethernet = wibox.widget {
    {
        ethicon,
        fg = beautiful.blue,
        widget = wibox.container.background
    },
 --    {
 --       ethip,
 --       fg = beautiful.blue,
 --       widget = wibox.container.background
 --   },
    spacing = dpi(6),
    layout = wibox.layout.fixed.horizontal,
    buttons = gears.table.join(
        awful.button({}, 1, function()
            awful.spawn.with_shell("nm-connection-editor")
            sb_ethernet()
            sb_wifi()
        end)
    )
}

-- Widget de Bluetooth
local bluetooth = wibox.widget {
    wibox.widget {
        bticon,
        fg = beautiful.blue,
        widget = wibox.container.background
    },
    layout = wibox.layout.fixed.horizontal,
    buttons = gears.table.join(
        awful.button({}, 1, function()
            awful.spawn(apps.bluetooth)
            sb_bluetooth()
        end)
    )
}

-- Retorno de widgets
return wibox.widget {
    {
        ethernet,
        fg = beautiful.blue,
        widget = wibox.container.background
    },
    {
        wifi,
        fg = beautiful.blue,
        widget = wibox.container.background
    },
    {
        bluetooth,
        fg = beautiful.blue,
        widget = wibox.container.background
    },
    spacing = dpi(6),
    layout = wibox.layout.fixed.horizontal,
}


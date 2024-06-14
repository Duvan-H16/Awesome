pcall(require, "luarocks.loader")
local awful = require("awful")
local gears = require("gears")
require("awful.autofocus")
local beautiful = require("beautiful")
local getfs = require("gears.filesystem")

--[[RC.LUA une configuraciones completas juntas.

La estructura de archivos de las configuraciones completas es la siguiente:

1. La carpeta de activos tiene fondos de pantalla, iconos, configuraciones PICOM y ROFI.
2. La carpeta de configuración tiene todas las configuraciones necesarias. Es posible que desee cambiar. Como qué paquetes usa, atajos de teclado, fondos de pantalla, programas de inicio.
3. La carpeta de componentes tiene todos los componentes de las configuraciones, como notificaciones, barra, menú, administración de Windows, etc.
4. La carpeta de temas contiene todos los colores, temas, etc.
5. Si desea saber más, solo lea el archivo init.lua dentro de cualquiera de estas carpetas/subcarpetas.
]]--


-- Todos los comandos en la configuración de Awesome se ejecutarán en este shell
-- awful.util.shell = 'dash'
awful.util.shell = 'zsh'

-- Función para manejar cambios en la conexión HDMI
--local function check_hdmi()
--    awful.spawn.easy_async_with_shell("xrandr | grep 'HDMI1 connected'", function(stdout)
--        if stdout:match("HDMI1 connected") then
--            -- Ejecutar script de video HDMI
--            awful.spawn.easy_async("/usr/local/bin/hdmi-video-monitor.sh", function()
--                print("HDMI script ejecutado con éxito.")
--            end)
--        else
--            -- Si HDMI está desconectado, ejecutar el script para restablecer la pantalla a su estado predeterminado
--            awful.spawn.easy_async("/usr/local/bin/hdmi-video-monitor.sh", function()
--                print("Script para desconexión HDMI ejecutado con éxito.")
--            end)
--        end
--    end)
--end

-- Monitorear cambios en la conexión HDMI
--gears.timer.start_new(5, function()
--    check_hdmi()
--    return true  -- Reinicia el temporizador
--end)

-- Ejecutar al inicio
--check_hdmi()


-- Importar tema
beautiful.init(getfs.get_configuration_dir() .. "theme/theme.lua")

-- Establecer fondos de pantalla
-- Simplemente agregue su fondos de pantalla dentro de Wallpaper.lua, para usar sus propios fondos de pantalla.
require("config.wallpaper")

-- notificaciones
require("components.notify")

-- centro de notificaciones
require("components.notify.center")

-- Bloquear pantalla, la contraseña es increíble. Puede cambiar eso en el archivo Lockscreen.lua
require("components.lockscreen")

-- pantalla de salida
require("components.exitscreen")

-- Barra superior
require("components.bar")

-- menu
require("components.menu")

--[[ keyboard shortcuts.
Super+Enter 	Terminal
Super+q 	kill Client
Super+F1	All Hotkeys
Super+r		rofi
]]--
require('config.keys')

-- Windows/Reglas/gestión de clientes, barras de título .. etc.
require("components.windows")

-- Startup Profgrams. Agregue sus programas de inicio en el script de inicio.
--awful.spawn.with_shell(getfs.get_configuration_dir() .. "config/startup")
--awful.spawn.with_shell("xrdb -merge ~/.config/awesome/theme/.xresources")
awful.spawn.with_shell("picom --config /etc/xdg/picom.conf")
--awful.spawn.with_shell("~/.config/rofi/screen/monitor-hdmi.sh &")


-- Recolectar basura
collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)

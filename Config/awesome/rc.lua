pcall(require, "luarocks.loader")
local awful = require("awful")
require("awful.autofocus")
local beautiful = require("beautiful")
local getfs = require("gears.filesystem")

-[[RC.LUA une configuraciones completas juntas.

La estructura de archivos de las configuraciones completas es la siguiente:

1. La carpeta de activos tiene fondos de pantalla, iconos, configuraciones PICOM y ROFI.
2. La carpeta de configuración tiene todas las configuraciones necesarias. Es posible que desee cambiar. Como qué paquetes usa, atajos de teclado, fondos de pantalla, programas de inicio.
3. La carpeta de componentes tiene todos los componentes de las configuraciones, como notificaciones, barra, menú, administración de Windows, etc.
4. La carpeta de temas contiene todos los colores, temas, etc.
5. Si desea saber más, solo lea el archivo init.lua dentro de cualquiera de estas carpetas/subcarpetas.
]]-


- Todos los comandos en la configuración de Awesome se ejecutarán en este shell
-- awful.util.shell = 'dash'
awful.util.shell = 'zsh'

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
awful.spawn.with_shell("xrdb -merge ~/.xresources")

-- Recolectar basura
collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)

import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Util.EZConfig
import Data.Map as M (fromList,union, Map())

myConfig = defaultConfig
         { modMask = mod4Mask 
         , terminal = "urxvt"
         , focusedBorderColor = "cyan"
         }
         `additionalKeysP`
         [ ("M-p", spawn "dmenu_run -fn '-*-terminus-bold-*-*-*-14-*-*-*-*-*-*-*' -nb '#000000' -nf '#eeeeee' -sb '#4d4d4d' -sf '#eeeeee'")
         , ("M-S-l", spawn "slock")
         ]

main = xmonad myConfig

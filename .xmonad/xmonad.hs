{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TypeSynonymInstances #-}

import XMonad
import XMonad.StackSet (integrate)
import XMonad.Layout.OneBig
import XMonad.Layout.MosaicAlt
import qualified Data.Map as M
import XMonad.Hooks.FadeInactive (fadeInactiveLogHook, setOpacity)
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.Run

data OhMyStack a = OhMyStack deriving (Show, Read)

instance LayoutClass OhMyStack a where
    pureLayout OhMyStack r s = zip ws rs
      where ws = integrate s
            rs = repeat r

    description _ = "Oh-My-Stack"

myDynamicLogWithPP proc = 
    dynamicLogWithPP $ xmobarPP
        -- display current workspace as darkgrey on light grey (opposite of 
        -- default colors)
        { ppCurrent         = xmobarColor "#303030" "#909090" . pad 

        -- display other workspaces which contain windows as a brighter grey
        , ppHidden          = xmobarColor "#909090" "" . pad 

        -- display other workspaces with no windows as a normal grey
        , ppHiddenNoWindows = xmobarColor "#606060" "" . pad 

        -- display the current layout as a brighter grey
        , ppLayout          = xmobarColor "#909090" "" . pad 

        -- if a window on a hidden workspace needs my attention, color it so
        , ppUrgent          = xmobarColor "#ff0000" "" . pad . dzenStrip

        -- shorten if it goes over 100 characters
        , ppTitle           = shorten 300  

        -- no separator between workspaces
        , ppWsSep           = ""

        -- put a few spaces between each object
        , ppSep             = "  "

        -- output to the handle we were given as an argument
        , ppOutput          = hPutStrLn proc
        }

myLogHook proc = do
    myDynamicLogWithPP proc

myLayout = OneBig (3/4) (3/4) |||
           myTallLayout |||
           Mirror myTallLayout ||| 
           MosaicAlt M.empty |||
           OhMyStack
           where
                myTallLayout = Tall 1 (3/100) (60/100)

main = do
    d <- spawnPipe "xmobar"

    xmonad $ defaultConfig
        {   terminal    = "xfce4-terminal"
        ,   modMask     = modk
        ,   borderWidth = 0
        ,   logHook = myLogHook d
        ,   manageHook = manageDocks <+> manageHook defaultConfig
        ,   layoutHook = avoidStrutsOn [] $ myLayout
        } `additionalKeys`
        [ ((modk .|. shiftMask, xK_l),      sendMessage Expand) 
        , ((modk .|. shiftMask, xK_h),      sendMessage Shrink) 
        , ((modk,               xK_a),      withFocused $ flip setOpacity $ 1) 
        , ((modk,               xK_s),      withFocused $ flip setOpacity $ 0.9) 
        , ((modk .|. shiftMask, xK_a),      withFocused $ flip setOpacity $ 0.75) 
        , ((modk .|. shiftMask, xK_s),      withFocused $ flip setOpacity $ 0.4) 
        , ((modk,               xK_z),      spawn "xscreensaver-command -lock")
        , ((modk,               xK_d),      sendMessage $ ToggleStrut D)
        ] where modk = mod4Mask


import           Control.Monad
import qualified Data.Map                        as M
import           Data.Monoid
import           System.Exit
import           XMonad                          hiding ((|||))
import           XMonad.Actions.CycleWS
import           XMonad.Actions.GridSelect
import           XMonad.Actions.Warp
import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.EwmhDesktops
import           XMonad.Hooks.InsertPosition
import           XMonad.Hooks.ManageDocks
import           XMonad.Hooks.ManageHelpers
import           XMonad.Hooks.SetWMName
import           XMonad.Layout.DecorationMadness
import           XMonad.Layout.Drawer
import           XMonad.Layout.Grid
import           XMonad.Layout.LayoutCombinators
import           XMonad.Layout.Named
import           XMonad.Layout.NoBorders
import           XMonad.Layout.Spacing
import           XMonad.Layout.ThreeColumns
import           XMonad.Layout.TwoPanePersistent
import           XMonad.Prompt                   (amberXPConfig)
import           XMonad.Prompt.ConfirmPrompt     (confirmPrompt)
import qualified XMonad.StackSet                 as W
import           XMonad.Util.EZConfig            (mkKeymap)
import           XMonad.Util.Run
import           XMonad.Util.SpawnOnce

-- Main function
------------------------------------------------------------------------
main :: IO ()
main = do
  xmonad $
    ewmh $
      docks
        def
          { terminal = "alacritty",
            focusFollowsMouse = True,
            clickJustFocuses = False,
            borderWidth = 2,
            modMask = mod4Mask,
            normalBorderColor = "#111111",
            focusedBorderColor = "#aaaaaa",
            layoutHook = myLayout,
            manageHook = myManageHook,
            handleEventHook = fullscreenEventHook,
            startupHook = myStartupHook,
            keys = myKeys
          }

-- Key bindings
------------------------------------------------------------------------
myKeys conf = mkKeymap conf $
  [ ("M-S-r", spawn "xmonad --restart"), -- Recompile and restart xmonad
    ("M-S-e", confirmPrompt amberXPConfig "Quit XMonad" $ io exitSuccess), -- Quit xmonad
    -- Workspaces
    ("M-<Tab>", toggleWS),
    -- Windows
    ("M-q", kill), -- close focused window
    ("M-n", withFocused toggleFloat), -- toggle float
    ("M-j", windows W.focusDown >> warpToWindowCenter), -- Move focus to the next window
    ("M-k", windows W.focusUp >> warpToWindowCenter), -- Move focus to the previous window
    ("M-S-<Return>", windows W.swapMaster >> warpToWindowCenter), -- Swap the focused window and the master window
    ("M-S-j", windows W.swapDown >> warpToWindowCenter), -- Swap the focused window with the next window
    ("M-S-k", windows W.swapUp >> warpToWindowCenter), -- Swap the focused window with the previous window
    -- Layouts
    ("M-t",      sendMessage $ JumpToLayout "tiled"),
    ("M-M1-t",   sendMessage $ JumpToLayout "threecol"),
    ("M-M1-S-t", sendMessage $ JumpToLayout "threecolmid"),
    ("M-y",      sendMessage $ JumpToLayout "twopane"),
    ("M-S-y",    sendMessage $ JumpToLayout "twopanebottom"),
    ("M-b",      sendMessage $ JumpToLayout "bottom"),
    ("M-M1-g",      sendMessage $ JumpToLayout "grid"),
    ("M-f",      sendMessage $ JumpToLayout "full"),
    ("M-x", sendMessage NextLayout), -- Rotate through the available layout algorithms
    ("M-h", sendMessage Shrink), -- Shrink the master area
    ("M-l", sendMessage Expand), -- Expand the master area
    ("M-,", sendMessage (IncMasterN 1)), -- Increment the number of windows in the master area
    ("M-.", sendMessage (IncMasterN (-1))), -- Deincrement the number of windows in the master area
    ("M-ñ", toggleSpacing),
    ("M-g", goToSelected def),
    ("M-S-g", bringSelected def),
    ("M-+", incScreenWindowSpacing 2),
    ("M--", decScreenWindowSpacing 2),
    -- Status bar
    ("M-z", sendMessage ToggleStruts), -- Toggle the status bar gap
    ("M-S-z", spawn "polybar-msg cmd toggle") -- Toggle the status bar
  ]
   ++ [("M-"  ++ ws, windows $ W.view ws) | ws <- workspaces conf]
   ++ [("M-S-" ++ ws, windows $ W.shift ws) | ws <- workspaces conf]

-- Windows
------------------------------------------------------------------------
-- Borrowed from https://www.reddit.com/r/xmonad/comments/hm2tg0/how_to_toggle_floating_state_on_a_window/
toggleFloat w =
  windows
    ( \s ->
        if M.member w (W.floating s)
          then W.sink w s
          else W.float w centerRect s
    )

centerRect = W.RationalRect d d d' d'
  where d  = 0.04
        d' = 1-2*d

warpToWindowCenter = warpToWindow 0.5 0.5

-- Layouts
------------------------------------------------------------------------
myLayout =
  avoidStruts $
    spacing $
      named "tiled" tiled
        ||| named "bottom" (Mirror tiled)
        ||| named "threecol" threecol
        ||| named "threecolmid" threecolmid
        ||| named "grid" (smartBorders Grid)
        ||| named "full" (noBorders Full)
        ||| named "twopane" twopane
        ||| named "twopanebottom" (Mirror twopane)
  where
    tiled = smartBorders $ Tall 1 0.02 0.55
    threecol = smartBorders $ ThreeCol 1 0.02 0.55
    threecolmid = smartBorders $ ThreeColMid 1 0.02 0.55
    twopane = smartBorders $ TwoPanePersistent Nothing 0.02 0.55
    spacing = spacingRaw True (Border 10 10 10 10) False (Border 10 10 10 10) False

toggleSpacing :: X ()
toggleSpacing = toggleScreenSpacingEnabled >> toggleWindowSpacingEnabled

-- Hooks
------------------------------------------------------------------------
-- Window rules
myManageHook =
  composeAll
    [
      resource =? "desktop_window" --> doIgnore,
      resource =? "kdesktop" --> doIgnore,
      className =? "GParted" --> doRectFloat centerRect,
      className =? "Pavucontrol" --> doRectFloat centerRect,
      className =? "mpvWorkspace9" --> doCenterFloat
    ]
    <+> insertPosition End Newer

myStartupHook = do
  spawnOnce "hsetroot"
  spawnOnce "autorandr -c"
  spawnOnce "systemctl --user restart polybar"
  setWMName "LG3D"

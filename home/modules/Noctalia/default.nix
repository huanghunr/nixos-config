{
  ...
}:
{
  programs.noctalia-shell = {
    enable = true;
    settings = {
      settingsVersion = 23;
      setupCompleted = true;
      bar = {
        position = "top";
        backgroundOpacity = 0.25;
        monitors = [ ];
        density = "default";
        showCapsule = true;
        capsuleOpacity = 0.6;
        floating = true;
        useSeparateOpacity = true;
        marginVertical = 0.38;
        marginHorizontal = 0.38;
        outerCorners = true;
        exclusive = true;
        widgets = {
          left = [
            {
              id = "ControlCenter";
            }
            {
              id = "SystemMonitor";
            }
            {
              id = "ActiveWindow";
            }
            {
              id = "MediaMini";
            }
          ];
          center = [
            {
              id = "Workspace";
            }
          ];
          right = [
            {
              colorizeIcons = false;
              drawerEnabled = false;
              id = "Tray";
            }
            {
              id = "ScreenRecorder";
            }
            {
              id = "NotificationHistory";
            }
            {
              id = "Volume";
            }
            {
              id = "Brightness";
            }
            {
              id = "DarkMode";
            }
            {
              id = "WiFi";
            }
            {
              displayMode = "alwaysshow";
              id = "Battery";
            }
            {
              formatHorizontal = "HH:mm ddd, MMM dd";
              formatVertical = "HH mm - dd MM";
              id = "Clock";
            }
          ];
        };
      };
      general = {
        avatarImage = "";
        dimmerOpacity = 0.2;
        showScreenCorners = false;
        forceBlackScreenCorners = false;
        scaleRatio = 0.9;
        radiusRatio = 1;
        screenRadiusRatio = 1;
        animationSpeed = 1;
        animationDisabled = false;
        compactLockScreen = false;
        lockOnSuspend = true;
        enableShadows = true;
        shadowDirection = "bottom_right";
        shadowOffsetX = 2;
        shadowOffsetY = 3;
        language = "";
        allowPanelsOnScreenWithoutBar = true;
      };
      ui = {
        fontDefault = "Roboto";
        fontFixed = "DejaVu Sans Mono";
        fontDefaultScale = 1;
        fontFixedScale = 1;
        tooltipsEnabled = true;
        panelBackgroundOpacity = 0.7;
        panelsAttachedToBar = true;
        settingsPanelAttachToBar = false;
      };
      location = {
        name = "Zhejiang";
        weatherEnabled = true;
        weatherShowEffects = true;
        useFahrenheit = false;
        use12hourFormat = false;
        showWeekNumberInCalendar = false;
        showCalendarEvents = true;
        showCalendarWeather = true;
        analogClockInCalendar = false;
        firstDayOfWeek = -1;
      };
      screenRecorder = {
        directory = "";
        frameRate = 60;
        audioCodec = "opus";
        videoCodec = "h264";
        quality = "very_high";
        colorRange = "limited";
        showCursor = true;
        audioSource = "default_output";
        videoSource = "portal";
      };
      wallpaper = {
        enabled = true;
        overviewEnabled = false;
        directory = "~/Pictures/wallpaper";
        enableMultiMonitorDirectories = false;
        recursiveSearch = false;
        setWallpaperOnAllMonitors = false;
        defaultWallpaper = "/home/huanghunr/Pictures/wallpaper/landscape.jpg";
        fillMode = "crop";
        fillColor = "#000000";
        randomEnabled = false;
        randomIntervalSec = 300;
        transitionDuration = 1500;
        transitionType = "random";
        transitionEdgeSmoothness = 0.05;
        monitors = [ ];
        panelPosition = "follow_bar";
        hideWallpaperFilenames = false;
        useWallhaven = true;
        wallhavenQuery = "";
        wallhavenSorting = "relevance";
        wallhavenOrder = "desc";
        wallhavenCategories = "111";
        wallhavenPurity = "100";
        wallhavenResolutionMode = "atleast";
        wallhavenResolutionWidth = "";
        wallhavenResolutionHeight = "";
      };
      appLauncher = {
        enableClipboardHistory = true;
        enableClipPreview = true;
        position = "center";
        pinnedExecs = [ ];
        useApp2Unit = false;
        sortByMostUsed = true;
        terminalCommand = "kitty -e";
        customLaunchPrefixEnabled = false;
        customLaunchPrefix = "";
      };
      controlCenter = {
        position = "close_to_bar_button";
        shortcuts = {
          left = [
            {
              id = "WiFi";
            }
            {
              id = "Bluetooth";
            }
            {
              id = "ScreenRecorder";
            }
            {
              id = "WallpaperSelector";
            }
          ];
          right = [
            {
              id = "Notifications";
            }
            {
              id = "PowerProfile";
            }
            {
              id = "KeepAwake";
            }
            {
              id = "NightLight";
            }
          ];
        };
        cards = [
          {
            enabled = true;
            id = "profile-card";
          }
          {
            enabled = true;
            id = "shortcuts-card";
          }
          {
            enabled = true;
            id = "audio-card";
          }
          {
            enabled = true;
            id = "weather-card";
          }
          {
            enabled = true;
            id = "media-sysmon-card";
          }
        ];
      };
      systemMonitor = {
        cpuWarningThreshold = 80;
        cpuCriticalThreshold = 90;
        tempWarningThreshold = 80;
        tempCriticalThreshold = 90;
        memWarningThreshold = 80;
        memCriticalThreshold = 90;
        diskWarningThreshold = 80;
        diskCriticalThreshold = 90;
        useCustomColors = false;
        warningColor = "";
        criticalColor = "";
      };
      dock = {
        enabled = true;
        displayMode = "auto_hide";
        backgroundOpacity = 0.5;
        floatingRatio = 1;
        size = 0.8;
        onlySameOutput = true;
        monitors = [ ];
        pinnedApps = [ ];
        colorizeIcons = false;
        pinnedStatic = false;
        inactiveIndicators = false;
        deadOpacity = 0.6;
        animationSpeed = 1;
      };
      network = {
        wifiEnabled = true;
      };
      sessionMenu = {
        enableCountdown = true;
        countdownDuration = 5000;
        position = "center";
        showHeader = true;
        powerOptions = [
          {
            action = "lock";
            enabled = true;
          }
          {
            action = "suspend";
            enabled = true;
          }
          {
            action = "hibernate";
            enabled = true;
          }
          {
            action = "reboot";
            enabled = true;
          }
          {
            action = "logout";
            enabled = true;
          }
          {
            action = "shutdown";
            enabled = true;
          }
        ];
      };
      notifications = {
        enabled = true;
        monitors = [ "eDP-2" ];
        location = "top_right";
        overlayLayer = true;
        backgroundOpacity = 0.7;
        respectExpireTimeout = false;
        lowUrgencyDuration = 3;
        normalUrgencyDuration = 8;
        criticalUrgencyDuration = 15;
        enableKeyboardLayoutToast = true;
      };
      osd = {
        enabled = true;
        location = "top_right";
        monitors = [ ];
        autoHideMs = 2000;
        overlayLayer = true;
        backgroundOpacity = 0.5;
      };
      audio = {
        volumeStep = 5;
        volumeOverdrive = false;
        cavaFrameRate = 30;
        visualizerType = "linear";
        visualizerQuality = "high";
        mprisBlacklist = [ ];
        preferredPlayer = "";
        externalMixer = "pwvucontrol || pavucontrol";
      };
      brightness = {
        brightnessStep = 5;
        enforceMinimum = true;
        enableDdcSupport = true;
      };
      colorSchemes = {
        useWallpaperColors = false;
        predefinedScheme = "Rosepine";
        darkMode = false;
        schedulingMode = "off";
        manualSunrise = "06:30";
        manualSunset = "18:30";
        matugenSchemeType = "scheme-fruit-salad";
        generateTemplatesForPredefined = true;
      };
      templates = {
        gtk = true;
        qt = true;
        kcolorscheme = false;
        alacritty = false;
        kitty = false;
        ghostty = false;
        foot = false;
        wezterm = false;
        fuzzel = false;
        discord = false;
        pywalfox = false;
        vicinae = false;
        walker = false;
        code = true;
        spicetify = false;
        enableUserTemplates = false;
        hyprland = true;
        yazi = true;
      };
      nightLight = {
        enabled = false;
        forced = false;
        autoSchedule = true;
        nightTemp = "4000";
        dayTemp = "6500";
        manualSunrise = "06:30";
        manualSunset = "18:30";
      };
      changelog = {
        lastSeenVersion = "";
      };
      hooks = {
        enabled = false;
        wallpaperChange = "";
        darkModeChange = "";
      };
      desktopWidgets = {
        enabled = false;
        editMode = false;
        gridSnap = false;
        monitorWidgets = [ ];
      };
    };
  };
}

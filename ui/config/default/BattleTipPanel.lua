LuaQ                (   
@  J  Iΐ@Iΐ@IΑI Β	@      d   	@   d@  	@    d  	@   dΐ  	@    d  	@   d@ 	@ $ ΐ $ΐ   $  @ $@  $ Eΐ   Ε \@        BattleTipPanel    DefaultAnchor    s 
   TOPCENTER    r    x            y      ΐr@   OnFrameCreate    OnFrameDragEnd    UpdateAnchor    OnEvent    OnFrameBreathe    AdjustSize    IsBattleTipPanel    OpenBattleTipPanel    CloseBattleTipPanel     BattleTipPanel_SetAnchorDefault    RegisterEvent    CUSTOM_UI_MODE_SET_DEFAULT                 2      @@   @   @@ ΐ  @   @@   @   @@ @ @   @@  @   @@ ΐ @   @@   @   @@ @ @ ΐB E   @   E   @ CΒ  @    ΐC   Α   @D @         this    RegisterEvent 
   UI_SCALED    ON_ENTER_CUSTOM_UI_MODE    ON_LEAVE_CUSTOM_UI_MODE     ENTER_BATTLE_TIP_ANCHOR_CHANGED    OnBattleTipNotify    COINSHOP_ON_OPEN    COINSHOP_ON_CLOSE    SYNC_USER_PREFERENCES_END    BattleTipPanel    UpdateAnchor    UpdateCustomModeWindow    g_tStrings    STR_BATTLE_TIP_TITLE    Lookup        Hide                                    @@ @   ΐ@ A  @ Ε   ά  @          this    CorrectPos    StorageServer    SetData    OnlineFrameAnchor    BattleTipPanel    GetFrameAnchor                              
   E   F@ΐ \ Z@      E   Fΐ ΐ  Α  \Z@  @ E  F@Α A ΑΑ A  ΖAΒ Β FΒΒ @  C @         StorageServer    IsReady    GetData    OnlineFrameAnchor    BattleTipPanel    DefaultAnchor 	   SetPoint    s            r    x    y    CorrectPos                     "   @     \    @  E@  Fΐ ΐ  \@ ΐW A @ @A @E ΐ  Γ  \@ @ΐA  E@  Fΐ ΐ  \@  B  E@  Fΐ ΐ  \@ ΐ@B E Z   Eΐ F Γ  F Z    Eΐ  K@Γ Α  \ ΐ  CΕ ΐ Εΐ   E ZA    A ά Ε@  Ζ@ΔΑ  E FΑΔ E\ ά@  Λ@Γ AA άΛΕ@ ά@ΛΐΕ A ά@Λ@Ζ ά@ F ΐ Eΐ  KΐΖ \@   G  Eΐ  K@Η \@      
   UI_SCALED    BattleTipPanel    UpdateAnchor    this    ON_ENTER_CUSTOM_UI_MODE    ON_LEAVE_CUSTOM_UI_MODE    UpdateCustomModeWindow     ENTER_BATTLE_TIP_ANCHOR_CHANGED    SYNC_USER_PREFERENCES_END    OnBattleTipNotify    arg0    g_tStrings    tBattleTip    Lookup        FormatString    arg1    AdjustSize    math    ceil        @   Text_CampText    SetText 	   SetAlpha      ΰo@   Show    COINSHOP_ON_OPEN    ShowWhenUIHide    COINSHOP_ON_CLOSE    HideWhenUIHide                     B   L            @@   Α   Kΐ@ \ Z   K A \ M@Α Α  ΐA @   B   @  	      this    Lookup     
   IsVisible 	   GetAlpha       @           Hide 	   SetAlpha                     N   i     8      Ο@@@ Α  ΑΑ   K@Α \@B Λ@A ά@Β E FBΒΒ ΐ \Β ΛΒά B Γ ΓB  @C BΓ ΔBΐD ΔKB\Δ ΛΔB@  	άD ΛBάΔ KΕBΐ  
\E KC\E            ~@      4@   Lookup     	   Image_Bg 
   Image_BgM 
   Image_BgE    Text_CampText    math    max    GetSize    SetSize    FormatAllItemPos                     k   r            @@ A      @Kΐ@ \ Z   @ B  ^  B   ^          Station    Lookup    Normal/BattleTipPanel 
   IsVisible                     t        ,   E   \ Z       E@  Fΐ ΐ  \ Z     Α @  @ AΑΐ @ @  @Αΐ   @    Α@      ΐB    @  Γ @ @  @@ Ε ΖΐΓ AD@        IsBattleTipPanel    Station    Lookup    Normal/BattleTipPanel    Show    Wnd    OpenWindow    BattleTipPanel    IsModuleLoaded 	   CoinShop    CoinShop_Main 	   IsOpened    ShowWhenUIHide 
   PlaySound    SOUND 	   UI_SOUND    g_sound 
   OpenFrame                                E   \ Z@      E@  Fΐ ΐ  \ Z   @  Α @ @  @@ Ε ΖΐΑ AB@  
      IsBattleTipPanel    Station    Lookup    Normal/BattleTipPanel    Hide 
   PlaySound    SOUND 	   UI_SOUND    g_sound    CloseFrame                                    @@ A  ΐ  Εΐ  Ζ Α@ @ A @         StorageServer    SetData    OnlineFrameAnchor    BattleTipPanel    DefaultAnchor 
   FireEvent     ENTER_BATTLE_TIP_ANCHOR_CHANGED                        ¦                 F@@     Eΐ  \ Z@   E  \@ @ E@ \@         GetClientPlayer    dwID    arg0    IsInBattleField    CloseBattleTipPanel    OpenBattleTipPanel                             
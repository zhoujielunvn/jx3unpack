LuaQ                      J   G@  E@  ¤   I E@  ¤@  IE@  ¤  I E@  ¤À  IE@  ¤      I d@ GÀ d G  dÀ G@   
       OA   AutoExitPanel    OnFrameCreate    OnEvent    UpdateScaled    OnLButtonClick    OnFrameBreathe    OpenAutoExitPanel    IsAutoExitPanelOpened    CloseAutoExitPanel           
            @@   @À   A @ @ A E   @         this    RegisterEvent 
   UI_SCALED    AutoExitPanel    UpdateScaled    Station    SetFocusWindow                                 @  E@  FÀ \@      
   UI_SCALED    AutoExitPanel    UpdateScaled                              
      @@   ÁÀ  Á  A  Á  ÁÁ  @         this 	   SetPoint    CENTER                                            @@  @ @ EÀ  \@         this    GetName    Btn_Cancel    CloseAutoExitPanel                        /     @       E@  FÀ @  D   @   	AÀ    @AÄ   Í ÏÁ Å  Æ@ÁÁAÜ ÁÁE FAÂ Å ÆAÁÂÂÜ ÂÂE FBÁÂB\ ÂB\ @ EA  KÃÁÁ  B \ KÃÀ \A@EÀ   \ Z    E@ FÄ \ Z   À E@ FÀÄ   \@ E  @ E\@         GetTickCount    this    dwStartTime        math    floor      @@      N@   string    format 
   %d%d:%d%d       $@   Lookup    Text_CountDown    SetText    IsModuleLoaded 	   CoinShop    CoinShop_Main 	   IsOpened    Close 	   ReInitUI    LOAD_LOGIN_REASON 
   AUTO_EXIT                     1   8        E   F@À   \ ÀÀ  AA  AÁ B@  I@  @À Å  Æ@Ã ÁC@        Wnd    OpenWindow    AutoExitPanel    Lookup        Text_AutoExit    SetText    g_tStrings    MSG_AUTO_EXIT    dwStartTime    GetTickCount 
   PlaySound    SOUND 	   UI_SOUND    g_sound 
   OpenFrame                     :   =      
      @@ A   [   @ KÀ@ \ ^          Station    Lookup    Topmost2/AutoExitPanel 
   IsVisible                     ?   D        E   F@À   \@ @  @EÀ    @AÅ ÆÀÁ\@        Wnd    CloseWindow    AutoExitPanel 
   PlaySound    SOUND 	   UI_SOUND    g_sound 
   OpenFrame                             
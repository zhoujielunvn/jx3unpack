LuaQ                >   
@  J  IÀ@I@AIÀAI@B	@      J   ¤    ¤@  À ¤     äÀ     $      E  ¤A     IE  ¤       IE  ¤Á    IE  ¤    IE  ¤A      IE  ¤ IE  ¤Á IE  ¤ IE  ¤A Id GA E Á äÁ \A        PQTimePanel    Anchor    s    TOPLEFT    r    BOTTOMLEFT    x       YÀ   y       T@   OpenPQTimePanel    ClosePQTimePanel    OnFrameCreate    OnFrameBreathe    InitObject    Init    OnEvent    OnFrameDragEnd    UpdateAnchor    OnItemMouseEnter    OnItemMouseLeave    IsPQTimePanelOpened    RegisterEvent    PQTIME_PANEL_VISIBLE        
           E   F@À   \ @  @À  Å  Æ@Á ÁA@        Wnd    OpenWindow    PQTimePanel 
   PlaySound    SOUND 	   UI_SOUND    g_sound 
   OpenFrame                                E   \ Z   À E@  FÀ À  \@ @  @E  @ AÅÀ Æ Â\@  	      IsPQTimePanelOpened    Wnd    CloseWindow    PQTimePanel 
   PlaySound    SOUND 	   UI_SOUND    g_sound    CloseFrame                        #            @ @@  @ EÀ  F Á    Á@ \   D   F À KÁ À   \@@A ÀD   FÀÁ I@BD   F À KÂ ÁÀ \@     	   hTimeAdd 	   GetAlpha       @   math    max         	   SetAlpha    hFrame    nDeltaTime     SetText                         %   3    *   E      Ã  \    @@@  @ @   @@ AA @   @   @@ AÁ @    @@ A @@B À   @@@ EÁ FÃA@        GetTimeText    hTime    SetText       @   SetFontScheme       d@     Àr@      ;@     Àd@           0    g_tStrings    STR_BUFF_H_TIME_S                     5   >            @ @@    À  À@ E  \ @ AO  E  FÀÁ     @@@  Á  \  À  @  Â      @@Â  
      hFrame 	   nEndTime    math    ceil    GetLogicFrameCount    GLOBAL 	   GAME_FPS    max                              B   M     $      @@   @   @@ À  @   @@   @   @@ @ @   @@  @   @@ À @    B E   @    @B @  ÀB E   @         this    RegisterEvent 
   UI_SCALED    PQTIME_TIME_CHANGED    PQTIME_PROGRESS_UPDATE    PQQUEST_STATE_UPDATE    PQQUEST_END_TIME_UPDATE    PQQUEST_LEFT_TIME_UPDATE    InitObject    Init    PQTimePanel    UpdateAnchor                     O   `     "      @@    @    @    @ @  @    	À@   @  A @   @A A @   @    @  A @    	À@   E   FÀ LÁ 	@         this    nDeltaTime    nFrame               @   nState       ð?                    b   j       D   I  K@@ Á  Á  \    Ë@À AA ÜÀ    Ë@À AÁ ÜÀ @@   A  @     Ë@À A ÜÀ        hFrame    Lookup        Handle_Top    hTime 
   Text_Time 	   hTimeAdd    Text_Other    Handle_QuestProgress 
   hProgress    Text_ProgressMsg                     l   w     +      	À   À@ 	@   À@ 	Á   À@ 	Á    B @B  ÀB@    B  C @ @   C @B À @   C  C @ @    D @B @ @    D  C  @        PQTimePanel 
   nTipState            hFrame    nState 	   nEndTime     nDeltaTime    hTime    SetText    g_tStrings    STR_PQQUEST_UNSTART    SetFontScheme       ;@	   hTimeAdd     
   hProgress    --/--       @@                    y   °        @  E@  FÀ À  \@  # A  E@ Á  À @  !  @ @ @B ÀE@    B@  À   Ä   Æ@ÃËÃAÁ  UÜ@Ä   Æ@ÃË ÄAA Ü@ÀD E@ À Ä   Æ ÅËÃ@ A À UÁÜ@E E@    B@ Æ À @  @F@ Æ    ÀFC @   @CC @@@Ç À@  F   BÀÇ   ÀF H Å@ ÆÈÀ  Ä   Ü@ Ä   Æ@ÃËÃEA FÁÈÜ@Ä   Æ@ÃË ÄAA Ü@À	 É @	@  @G   BÀÇ   @CCA AI@   @C DA @  Á  @ @I ÀE@    BÅ 
   Ü ÀÀ@J @E 
 @ \   À  @   *   
   UI_SCALED    PQTimePanel    UpdateAnchor    this    PQTIME_PANEL_VISIBLE    arg0    OpenPQTimePanel    ClosePQTimePanel    PQTIME_TIME_CHANGED    hFrame    nDeltaTime    GetTimeText 	   hTimeAdd    SetText    + 	   SetAlpha      ào@   PQTIME_PROGRESS_UPDATE    arg1 
   hProgress    /    PQQUEST_STATE_UPDATE    nState            Init       ð?   hTime            @
   nTipState     GetText    g_tStrings    STR_PQQUEST_UNSTART    STR_PQQUEST_SUCCESS       @   STR_PQQUEST_FAIL    PQQUEST_END_TIME_UPDATE 	   nEndTime 	   tonumber    PQQUEST_LEFT_TIME_UPDATE                     ²   µ      	      @@ @   E     \ 	@        this    CorrectPos    PQTimePanel    Anchor    GetFrameAnchor                     ·   º     
   K @ Å@  ÆÀÆÀÀ A A ÅA  ÆÀÆÁB  @ÂAEB  FÀFÂ\@K@B \@   
   	   SetPoint    PQTimePanel    Anchor    s            Normal/Minimap    r    x    y    CorrectPos                     ¼   Ë      4      @@  @ @E   KÀÀ \À Å   Ë ÁÜÀ AA  ÁA B@A Å ÆÁÂ @  ÁA C@A Å ÆAÃ @   ÁAC A Å ÆÁÃ @  ÀB J  À  @ bB A         this    GetName    Handle_Top 
   GetAbsPos    GetSize        PQTimePanel 
   nTipState            GetFormatText    g_tStrings    STR_PQQUEST_TIP1       ð?   STR_PQQUEST_TIP2        @   STR_PQQUEST_TIP3 
   OutputTip       y@                    Í   Ò            @@  @ @ EÀ  \@         this    GetName    Handle_Top    HideTip                     Ô   Ù        E   F@À   \ Z   @ÀÀ     @             Station    Lookup    Normal/PQTimePanel 
   IsVisible                     Û   Û        E   F@À    \@         PQTimePanel    OnEvent                             
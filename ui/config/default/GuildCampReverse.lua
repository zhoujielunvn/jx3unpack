LuaQ                   
         d   	@   d@  	@    d  	@   dÀ  	@    d  	@$@  $ À $À     	      GuildCampReverse    OnFrameCreate    OnFrameBreathe    OnEvent 
   UpdatePos    OnLButtonClick    CloseGuildCampReverse    OpenGuildCampReverse    IsGuildCampReverseOpened                       @@   @À   A E   @    E \ 	@        this    RegisterEvent 
   UI_SCALED    GuildCampReverse 
   UpdatePos    dwStartTime    GetTickCount                     
         3      @@ @         E   F@À @  E   KÀÀ Á  A \    AÀA     AÏÀA À Ï BBABÍ BPBPAÂAKÂ ÅÁ  BC@ À UÂÜ\A    Â  @À @     Ä        this    dwStartTime    GetTickCount    Lookup     
   Text_Time    nCountDownTime      @@      N@      ð?   SetText    FormatString    g_tStrings    CAMP_REVERSE_COUNT_DOWN    :    CloseGuildCampReverse                          $         @ À E@  FÀ À  \@      
   UI_SCALED    GuildCampReverse 
   UpdatePos    this                     &   -        E   F@À \À Ë@ ÜÀ KÁ@ \Á ËA MB OBÁBAÜA ËA MB OBÁBAÜA         Station    GetClientSize 
   GetAbsPos    GetSize 
   SetRelPos        @
   SetAbsPos                     /   ?      %      @@  @ @E   KÀÀ \   Á@ Á @À @   B E@  ÀBÁ  \Z       E@ \ FÃ \@ EÀ \@ À ÀC @ EÀ \@         this    GetName 	   Btn_Sure    GetRoot    RemoteCallToServer    TongCampReverse    nCamp    CloseGuildCampReverse    Btn_LeaveGuild    CheckHaveLocked    SAFE_LOCK_EFFECT_TYPE    TONG_OPERATE    Tong    GetTongClient    Quit 
   Btn_Close                     A   K        E   \ Z@      E@  FÀ À  \@ @  @E  @ AÅÀ Æ Â\@  	      IsGuildCampReverseOpened    Wnd    CloseWindow    GuildCampReverse 
   PlaySound    SOUND 	   UI_SOUND    g_sound    CloseFrame                     M   [     	%   Å   Ü Ú@  À Å@  ÆÀÁ  Ü@ Å  Æ@Á Ü É É@ AÁA Á  EÁ  ACÅ ÆÃÆ\ÁC A@  @ ÅA ÆÄÂ EA        IsGuildCampReverseOpened    Wnd    OpenWindow    GuildCampReverse    Station    Lookup    Normal/GuildCampReverse    nCamp    nCountDownTime        Text_Message    FormatString    g_tStrings    CAMP_REVERSE_SHOW    STR_CAMP_TITLE    SetText 
   PlaySound    SOUND 	   UI_SOUND    g_sound 
   OpenFrame                     ]   d            @@ A      @ B  ^  B   ^          Station    Lookup    Normal/GuildCampReverse                             
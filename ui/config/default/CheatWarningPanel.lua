LuaQ                      J   G@  E@  �   I� �E@  �@      I���E@  ��  I� �E@  ��  I���E@  �  I� �d@ G� d� G  d� G@  � 
        ��@   CheatWarningPanel    OnFrameCreate    OnFrameBreathe    OnEvent 
   UpdatePos    OnLButtonClick    CloseCheatWarningPanel    OpenCheatWarningPanel    IsCheatWarningPanelOpened           
            @@ ��  @��   A E   @    E� \�� 	@�� �       this    RegisterEvent 
   UI_SCALED    CheatWarningPanel 
   UpdatePos    dwStartTime    GetTickCount                             	0      @@ @    � � �  �� E   F@� @  E   K�� �  \����� A A� �� �   �   ��� � �   AB܀ �� �  A��B� �AC��  ��A� � ˀ� B� �@���BE FA��@��   ��À �       this    dwStartTime    GetTickCount    Lookup 	   Btn_Sure     
   Text_Sure    math    floor      @�@   Enable    SetText    g_tStrings    STR_HOTKEY_SURE                               $         @ � �E@  F�� ��  \@  �    
   UI_SCALED    CheatWarningPanel 
   UpdatePos    this                     &   -        E   F@� \�� ˀ@ �� K�@ \� �A MB� OB����BA�A ˁA MB� OB����BA�A  �       Station    GetClientSize 
   GetAbsPos    GetSize 
   SetRelPos        @
   SetAbsPos                     /   4            @@ � �@ @ �E�  \@�  �       this    GetName 	   Btn_Sure    CloseCheatWarningPanel                     6   @        E   \�� Z@    � � E@  F�� ��  \@ @  @�E  �@ ��A�� � �\@� � 	      IsCheatWarningPanelOpened    Wnd    CloseWindow    CheatWarningPanel 
   PlaySound    SOUND 	   UI_SOUND    g_sound    CloseFrame                     B   L        E   \�� Z@  � �E@  F�� ��  \@ E  F@� �� \� @  @��� �  �@�� �B�@� �       IsCheatWarningPanelOpened    Wnd    OpenWindow    CheatWarningPanel    Station    Lookup    Topmost2/CheatWarningPanel 
   PlaySound    SOUND 	   UI_SOUND    g_sound 
   OpenFrame                     N   U            @@ A�  �    @ �B � ^  B   ^   �       Station    Lookup    Topmost2/CheatWarningPanel                             
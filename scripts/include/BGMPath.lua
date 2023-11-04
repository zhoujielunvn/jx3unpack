---------------------------------------------------------------------->
-- 脚本名称:	scripts/Include/BGMPath.lua
-- 更新时间:	2021/1/26 19:35:34
-- 更新用户:	WangJi2
-- 脚本说明:	小伙伴们，改这个地方的时候，一定记得，
--				提的时候复制了文字直接提，不要变成strings，不然国际服的繁体字版本找不到文件会报错
----------------------------------------------------------------------<
local tGlobalMusicPath = {
	[1]={MusicPath = "data\\sound\\同人娘\\乘梦万里.mp3", szName = GetEditorString(18, 5522), nPlayTime = 290},--1
	[2]={MusicPath = "data\\sound\\同人娘\\山海相逢.mp3", szName = GetEditorString(18, 5523), nPlayTime = 290},--2
	[3]={MusicPath = "data\\sound\\同人娘\\大美江湖.mp3", szName = GetEditorString(12, 6392), nPlayTime = 290,},--3
	[4]={MusicPath = "data\\sound\\同人娘\\如寄.mp3", szName = GetEditorString(16, 5499), nPlayTime = 295},--4
	[5]={MusicPath = "data\\sound\\同人娘\\剑侠风云录.mp3", szName = GetEditorString(16, 5501), nPlayTime = 245},--5
	[6]={MusicPath = "data\\sound\\同人娘\\江湖写照.mp3", szName = GetEditorString(16, 5503), nPlayTime = 259},--6
	[7]={MusicPath = "data\\sound\\同人娘\\侠.mp3", szName = GetEditorString(0, 1669), nPlayTime = 257},--7
	[8]={MusicPath = "data\\sound\\同人娘\\沧海一杯酒.mp3", szName = GetEditorString(16, 5506), nPlayTime = 238},--8
	[9]={MusicPath = "data\\sound\\同人娘\\说侠.mp3", szName = GetEditorString(16, 5508), nPlayTime = 332},--9
	[10]={MusicPath = "data\\sound\\同人娘\\当战.mp3", szName = GetEditorString(16, 5510), nPlayTime = 204},--10
	[11]={MusicPath = "data\\sound\\同人娘\\少年狂想录.mp3", szName = GetEditorString(16, 5512), nPlayTime = 227},--11
	[12]={MusicPath = "data\\sound\\同人娘\\天涯共此时.mp3", szName = GetEditorString(16, 5514), nPlayTime = 257},--12
	[13]={MusicPath = "data\\sound\\同人娘\\江湖小霸王.mp3", szName = GetEditorString(16, 5516), nPlayTime = 81},--13
	[14]={MusicPath = "data\\sound\\背景音乐\\黑龙沼\\aidefeixu2.mp3", szName = GetEditorString(8, 4404), nPlayTime = 268},--14
	[15]={MusicPath = "data\\sound\\同人娘\\天策·神枪入梦.ogg", szName = GetEditorString(16, 9502), nPlayTime = 290},--15
	[16]={MusicPath = "data\\sound\\同人娘\\七秀·轻云蔽月.ogg", szName = GetEditorString(16, 9504), nPlayTime = 290},--16
	[17]={MusicPath = "data\\sound\\同人娘\\少林·何处求佛.ogg", szName = GetEditorString(16, 9506), nPlayTime = 290},--17
	[18]={MusicPath = "data\\sound\\同人娘\\万花·千古风流.ogg", szName = GetEditorString(16, 9508), nPlayTime = 290},--18
	[19]={MusicPath = "data\\sound\\同人娘\\纯阳·希声无形.ogg", szName = GetEditorString(16, 9510), nPlayTime = 290},--19
	[20]={MusicPath = "data\\sound\\同人娘\\藏剑·君子不动.ogg", szName = GetEditorString(16, 9512), nPlayTime = 290},--20
	[21]={MusicPath = "data\\sound\\同人娘\\唐门·江湖在我.ogg", szName = GetEditorString(16, 9514), nPlayTime = 290},--21
	[22]={MusicPath = "data\\sound\\同人娘\\五毒·九黎苗歌.ogg", szName = GetEditorString(16, 9516), nPlayTime = 290},--22
	[23]={MusicPath = "data\\sound\\同人娘\\明教·圣火长存.ogg", szName = GetEditorString(16, 9518), nPlayTime = 290},--23
	[24]={MusicPath = "data\\sound\\同人娘\\丐帮·义侠天下.ogg", szName = GetEditorString(16, 9520), nPlayTime = 290},--24
	[25]={MusicPath = "data\\sound\\同人娘\\苍云·孤城万仞.ogg", szName = GetEditorString(16, 9522), nPlayTime = 290},--25
	[26]={MusicPath = "data\\sound\\同人娘\\长歌·在明明德.ogg", szName = GetEditorString(16, 9524), nPlayTime = 290},--26
	[27]={MusicPath = "data\\sound\\同人娘\\霸刀·北地黎明.ogg", szName = GetEditorString(16, 9526), nPlayTime = 290},--27
	[28]={MusicPath = "data\\sound\\同人娘\\剑侠·侠骨山河.ogg", szName = GetEditorString(16, 9528), nPlayTime = 290},--28
	[29]={MusicPath = "data\\sound\\同人娘\\情缘·一见千年.ogg", szName = GetEditorString(16, 9530), nPlayTime = 290},--29
	[30]={MusicPath = "data\\sound\\背景音乐\\凌雪阁\\凌雪阁_主题02.mp3", szName = GetEditorString(16, 9532), nPlayTime = 290},--30
	[31]={MusicPath = "data\\sound\\背景音乐\\蓬莱\\蓬莱主题.mp3", szName = GetEditorString(16, 9534), nPlayTime = 290},--31
	[32]={MusicPath = "data\\sound\\背景音乐\\南诏宫廷\\B05032 南诏宫廷 全长.mp3", szText = GetEditorString(3, 8489)},--太原--32
	[33]={MusicPath = "data\\sound\\背景音乐\\太原\\tianxianzi.mp3", szText = GetEditorString(7, 1250), RegionSoundID = 10,},--33
	[34]={MusicPath = "", szText = GetEditorString(8, 5646), RegionSoundID = 11, },--34
	[35]={MusicPath = "data\\sound\\背景音乐\\藏剑\\B02010a_雪霁春波.mp3", szText = GetEditorString(8, 4398), RegionSoundID = 12, },--35
	[36]={MusicPath = "data\\sound\\背景音乐\\藏剑\\B02010b_穆然世风.mp3", szText = GetEditorString(8, 4400), RegionSoundID = 13, },--36
	[37]={MusicPath = "data\\sound\\背景音乐\\丐帮\\B02012c.mp3", szText = GetEditorString(8, 4402), RegionSoundID = 14, },--37
	[38]={MusicPath = "data\\sound\\背景音乐\\黑龙沼\\aidefeixu2.mp3", szText = GetEditorString(8, 4404), RegionSoundID = 15, },--38
	[39]={MusicPath = "data\\sound\\背景音乐\\七秀\\B02009a.mp3", szText = GetEditorString(8, 4406), RegionSoundID = 16, },--39
	[40]={MusicPath = "data\\sound\\背景音乐\\情感音乐\\广陵散.mp3", szText = GetEditorString(0, 8513), RegionSoundID = 17, },--40
	[41]={MusicPath = "data\\sound\\背景音乐\\情感音乐\\B06004_无忧无虑_全长.mp3", szText = GetEditorString(8, 4409), RegionSoundID = 18, },--41
	[42]={MusicPath = "data\\sound\\背景音乐\\世界通用场景\\B04036 雪山.mp3", szText = GetEditorString(8, 4411), RegionSoundID = 19, },--42
	[43]={MusicPath = "data\\sound\\背景音乐\\世界通用场景/B04025_古城_全长.mp3", szText = GetEditorString(8, 4413), RegionSoundID = 20, },--43
	[44]={MusicPath = "data\\sound\\背景音乐\\倭寇\\B05022.mp3", szText = GetEditorString(8, 4415), RegionSoundID = 21, },--44
	--
	[45]={MusicPath = "data\\sound\\背景音乐\\扬州\\B01005b.mp3",},--扬州--45
	[46]={MusicPath = "data\\sound\\背景音乐\\唐门\\B02004b 唐门 全长.mp3",},--成都--46
	[47]={MusicPath ="data\\sound\\背景音乐\\侠客岛\\侠客岛 - B.mp3", },--侠客岛--47
	--
	[48]={MusicPath = "data\\sound\\同人娘\\《剑网3·乘梦江湖》专辑歌曲串烧.mp3", szName = GetEditorString(18, 5752), nPlayTime = 290},--48
	[49]={MusicPath = "data\\sound\\同人娘\\奉天证道（纯歌版）.mp3", szName = GetEditorString(18, 1551), nPlayTime = 250},--49
	[50]={MusicPath = "data\\sound\\同人娘\\山海相逢（器乐版）.mp3", szName = GetEditorString(17, 2291), nPlayTime = 249},--50
	--
	[51]={MusicPath = "data\\sound\\背景音乐\\副本场景\\B05027_副本BOSS战斗（中）_全长.mp3",},--51
	[52]={MusicPath = "data/sound/背景音乐/特殊场景/进入灵界.mp3",},--52
	[53]={MusicPath = "data/sound/背景音乐/衍天宗/衍天宗-大漠.mp3",},--53
	--艺人身份
	[54]={MusicPath = "data/sound/背景音乐/特殊场景/男性舞蹈01.mp3",},--54
	[55]={MusicPath = "data/sound/背景音乐/特殊场景/女性舞蹈01.mp3",},--55
	[56]={MusicPath = "data/sound/背景音乐/特殊场景/男性舞蹈01.mp3",},--56
	[57]={MusicPath = "data/sound/背景音乐/特殊场景/女性舞蹈01.mp3",},--57
	--
	[58]={MusicPath = "data\\sound\\背景音乐\\马嵬坡\\B05036b.mp3",},--58
	--帮主联赛三部曲
	[59]={MusicPath = "data\\sound\\背景音乐\\帮会联赛\\TongWarState1.mp3",},--59，备战期	
	[60]={MusicPath = "data\\sound\\背景音乐\\帮会联赛\\TongWarState2.mp3",},--60，开战期
	[61]={MusicPath = "data\\sound\\背景音乐\\帮会联赛\\TongWarState3.mp3",},--61，破城期
	--同人娘
	[62] = {MusicPath = "data\\sound\\同人娘\\万象长安（纯歌版）.mp3", szName = GetEditorString(21, 3304), nPlayTime = 249},
	[63] = {MusicPath = "data\\sound\\同人娘\\万象长安（民乐版）.mp3", szName = GetEditorString(21, 3305), nPlayTime = 123},
	--羊村
	[64] = {MusicPath = "data\\sound\\专有\\羊村\\羊村_追击中BGM.mp3", },
	--
	[65]={MusicPath = "data\\sound\\同人娘\\《九万里》.mp3", szText = GetEditorString(23, 7568), RegionSoundID = 47, },
	--
	[66] = {MusicPath = "data\\sound\\背景音乐\\衍天宗\\奉天证道（器乐版）WAV(1).wav", szText = GetEditorString(24, 4254), RegionSoundID = 47, },
	[67] = {MusicPath = "data\\sound\\背景音乐\\北天药宗\\通用场景.mp3", szText = GetEditorString(24, 4255), RegionSoundID = 47, },
	}
function GetGlobalMusicPath()
	return tGlobalMusicPath
end
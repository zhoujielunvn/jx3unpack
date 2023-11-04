---------------------------------------------------------------------->
-- �ű�����:	scripts/Include/BGMPath.lua
-- ����ʱ��:	2021/1/26 19:35:34
-- �����û�:	WangJi2
-- �ű�˵��:	С����ǣ�������ط���ʱ��һ���ǵã�
--				���ʱ����������ֱ���ᣬ��Ҫ���strings����Ȼ���ʷ��ķ����ְ汾�Ҳ����ļ��ᱨ��
----------------------------------------------------------------------<
local tGlobalMusicPath = {
	[1]={MusicPath = "data\\sound\\ͬ����\\��������.mp3", szName = GetEditorString(18, 5522), nPlayTime = 290},--1
	[2]={MusicPath = "data\\sound\\ͬ����\\ɽ�����.mp3", szName = GetEditorString(18, 5523), nPlayTime = 290},--2
	[3]={MusicPath = "data\\sound\\ͬ����\\��������.mp3", szName = GetEditorString(12, 6392), nPlayTime = 290,},--3
	[4]={MusicPath = "data\\sound\\ͬ����\\���.mp3", szName = GetEditorString(16, 5499), nPlayTime = 295},--4
	[5]={MusicPath = "data\\sound\\ͬ����\\��������¼.mp3", szName = GetEditorString(16, 5501), nPlayTime = 245},--5
	[6]={MusicPath = "data\\sound\\ͬ����\\����д��.mp3", szName = GetEditorString(16, 5503), nPlayTime = 259},--6
	[7]={MusicPath = "data\\sound\\ͬ����\\��.mp3", szName = GetEditorString(0, 1669), nPlayTime = 257},--7
	[8]={MusicPath = "data\\sound\\ͬ����\\�׺�һ����.mp3", szName = GetEditorString(16, 5506), nPlayTime = 238},--8
	[9]={MusicPath = "data\\sound\\ͬ����\\˵��.mp3", szName = GetEditorString(16, 5508), nPlayTime = 332},--9
	[10]={MusicPath = "data\\sound\\ͬ����\\��ս.mp3", szName = GetEditorString(16, 5510), nPlayTime = 204},--10
	[11]={MusicPath = "data\\sound\\ͬ����\\�������¼.mp3", szName = GetEditorString(16, 5512), nPlayTime = 227},--11
	[12]={MusicPath = "data\\sound\\ͬ����\\���Ĺ���ʱ.mp3", szName = GetEditorString(16, 5514), nPlayTime = 257},--12
	[13]={MusicPath = "data\\sound\\ͬ����\\����С����.mp3", szName = GetEditorString(16, 5516), nPlayTime = 81},--13
	[14]={MusicPath = "data\\sound\\��������\\������\\aidefeixu2.mp3", szName = GetEditorString(8, 4404), nPlayTime = 268},--14
	[15]={MusicPath = "data\\sound\\ͬ����\\��ߡ���ǹ����.ogg", szName = GetEditorString(16, 9502), nPlayTime = 290},--15
	[16]={MusicPath = "data\\sound\\ͬ����\\���㡤���Ʊ���.ogg", szName = GetEditorString(16, 9504), nPlayTime = 290},--16
	[17]={MusicPath = "data\\sound\\ͬ����\\���֡��δ����.ogg", szName = GetEditorString(16, 9506), nPlayTime = 290},--17
	[18]={MusicPath = "data\\sound\\ͬ����\\�򻨡�ǧ�ŷ���.ogg", szName = GetEditorString(16, 9508), nPlayTime = 290},--18
	[19]={MusicPath = "data\\sound\\ͬ����\\������ϣ������.ogg", szName = GetEditorString(16, 9510), nPlayTime = 290},--19
	[20]={MusicPath = "data\\sound\\ͬ����\\�ؽ������Ӳ���.ogg", szName = GetEditorString(16, 9512), nPlayTime = 290},--20
	[21]={MusicPath = "data\\sound\\ͬ����\\���š���������.ogg", szName = GetEditorString(16, 9514), nPlayTime = 290},--21
	[22]={MusicPath = "data\\sound\\ͬ����\\�嶾���������.ogg", szName = GetEditorString(16, 9516), nPlayTime = 290},--22
	[23]={MusicPath = "data\\sound\\ͬ����\\���̡�ʥ�𳤴�.ogg", szName = GetEditorString(16, 9518), nPlayTime = 290},--23
	[24]={MusicPath = "data\\sound\\ͬ����\\ؤ���������.ogg", szName = GetEditorString(16, 9520), nPlayTime = 290},--24
	[25]={MusicPath = "data\\sound\\ͬ����\\���ơ��³�����.ogg", szName = GetEditorString(16, 9522), nPlayTime = 290},--25
	[26]={MusicPath = "data\\sound\\ͬ����\\���衤��������.ogg", szName = GetEditorString(16, 9524), nPlayTime = 290},--26
	[27]={MusicPath = "data\\sound\\ͬ����\\�Ե�����������.ogg", szName = GetEditorString(16, 9526), nPlayTime = 290},--27
	[28]={MusicPath = "data\\sound\\ͬ����\\����������ɽ��.ogg", szName = GetEditorString(16, 9528), nPlayTime = 290},--28
	[29]={MusicPath = "data\\sound\\ͬ����\\��Ե��һ��ǧ��.ogg", szName = GetEditorString(16, 9530), nPlayTime = 290},--29
	[30]={MusicPath = "data\\sound\\��������\\��ѩ��\\��ѩ��_����02.mp3", szName = GetEditorString(16, 9532), nPlayTime = 290},--30
	[31]={MusicPath = "data\\sound\\��������\\����\\��������.mp3", szName = GetEditorString(16, 9534), nPlayTime = 290},--31
	[32]={MusicPath = "data\\sound\\��������\\��گ��͢\\B05032 ��گ��͢ ȫ��.mp3", szText = GetEditorString(3, 8489)},--̫ԭ--32
	[33]={MusicPath = "data\\sound\\��������\\̫ԭ\\tianxianzi.mp3", szText = GetEditorString(7, 1250), RegionSoundID = 10,},--33
	[34]={MusicPath = "", szText = GetEditorString(8, 5646), RegionSoundID = 11, },--34
	[35]={MusicPath = "data\\sound\\��������\\�ؽ�\\B02010a_ѩ������.mp3", szText = GetEditorString(8, 4398), RegionSoundID = 12, },--35
	[36]={MusicPath = "data\\sound\\��������\\�ؽ�\\B02010b_��Ȼ����.mp3", szText = GetEditorString(8, 4400), RegionSoundID = 13, },--36
	[37]={MusicPath = "data\\sound\\��������\\ؤ��\\B02012c.mp3", szText = GetEditorString(8, 4402), RegionSoundID = 14, },--37
	[38]={MusicPath = "data\\sound\\��������\\������\\aidefeixu2.mp3", szText = GetEditorString(8, 4404), RegionSoundID = 15, },--38
	[39]={MusicPath = "data\\sound\\��������\\����\\B02009a.mp3", szText = GetEditorString(8, 4406), RegionSoundID = 16, },--39
	[40]={MusicPath = "data\\sound\\��������\\�������\\����ɢ.mp3", szText = GetEditorString(0, 8513), RegionSoundID = 17, },--40
	[41]={MusicPath = "data\\sound\\��������\\�������\\B06004_��������_ȫ��.mp3", szText = GetEditorString(8, 4409), RegionSoundID = 18, },--41
	[42]={MusicPath = "data\\sound\\��������\\����ͨ�ó���\\B04036 ѩɽ.mp3", szText = GetEditorString(8, 4411), RegionSoundID = 19, },--42
	[43]={MusicPath = "data\\sound\\��������\\����ͨ�ó���/B04025_�ų�_ȫ��.mp3", szText = GetEditorString(8, 4413), RegionSoundID = 20, },--43
	[44]={MusicPath = "data\\sound\\��������\\����\\B05022.mp3", szText = GetEditorString(8, 4415), RegionSoundID = 21, },--44
	--
	[45]={MusicPath = "data\\sound\\��������\\����\\B01005b.mp3",},--����--45
	[46]={MusicPath = "data\\sound\\��������\\����\\B02004b ���� ȫ��.mp3",},--�ɶ�--46
	[47]={MusicPath ="data\\sound\\��������\\���͵�\\���͵� - B.mp3", },--���͵�--47
	--
	[48]={MusicPath = "data\\sound\\ͬ����\\������3�����ν�����ר����������.mp3", szName = GetEditorString(18, 5752), nPlayTime = 290},--48
	[49]={MusicPath = "data\\sound\\ͬ����\\����֤��������棩.mp3", szName = GetEditorString(18, 1551), nPlayTime = 250},--49
	[50]={MusicPath = "data\\sound\\ͬ����\\ɽ����꣨���ְ棩.mp3", szName = GetEditorString(17, 2291), nPlayTime = 249},--50
	--
	[51]={MusicPath = "data\\sound\\��������\\��������\\B05027_����BOSSս�����У�_ȫ��.mp3",},--51
	[52]={MusicPath = "data/sound/��������/���ⳡ��/�������.mp3",},--52
	[53]={MusicPath = "data/sound/��������/������/������-��Į.mp3",},--53
	--�������
	[54]={MusicPath = "data/sound/��������/���ⳡ��/�����赸01.mp3",},--54
	[55]={MusicPath = "data/sound/��������/���ⳡ��/Ů���赸01.mp3",},--55
	[56]={MusicPath = "data/sound/��������/���ⳡ��/�����赸01.mp3",},--56
	[57]={MusicPath = "data/sound/��������/���ⳡ��/Ů���赸01.mp3",},--57
	--
	[58]={MusicPath = "data\\sound\\��������\\������\\B05036b.mp3",},--58
	--��������������
	[59]={MusicPath = "data\\sound\\��������\\�������\\TongWarState1.mp3",},--59����ս��	
	[60]={MusicPath = "data\\sound\\��������\\�������\\TongWarState2.mp3",},--60����ս��
	[61]={MusicPath = "data\\sound\\��������\\�������\\TongWarState3.mp3",},--61���Ƴ���
	--ͬ����
	[62] = {MusicPath = "data\\sound\\ͬ����\\���󳤰�������棩.mp3", szName = GetEditorString(21, 3304), nPlayTime = 249},
	[63] = {MusicPath = "data\\sound\\ͬ����\\���󳤰������ְ棩.mp3", szName = GetEditorString(21, 3305), nPlayTime = 123},
	--���
	[64] = {MusicPath = "data\\sound\\ר��\\���\\���_׷����BGM.mp3", },
	--
	[65]={MusicPath = "data\\sound\\ͬ����\\�������.mp3", szText = GetEditorString(23, 7568), RegionSoundID = 47, },
	--
	[66] = {MusicPath = "data\\sound\\��������\\������\\����֤�������ְ棩WAV(1).wav", szText = GetEditorString(24, 4254), RegionSoundID = 47, },
	[67] = {MusicPath = "data\\sound\\��������\\����ҩ��\\ͨ�ó���.mp3", szText = GetEditorString(24, 4255), RegionSoundID = 47, },
	}
function GetGlobalMusicPath()
	return tGlobalMusicPath
end
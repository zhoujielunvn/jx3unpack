---------------------------------------------------------------------->
-- �ű�����:	scripts/Include/PushRoleCountMap.lua
-- ����ʱ��:	2017/7/15 10:32:53
-- �����û�:	zhengfeng6
-- �ű�˵��:   ע���ͼΪϵͳ�Զ�ͬ����ǰ��Ӫ����
-- GCCommand("RegisterPushRoleCountMap(" .. scene.dwMapID .. ")", false) --  dwMapID ��ͼID, bInRate �Ƿ��Ա�����ʽ��ʾ
-- GCCommand("UnregisterPushRoleCountMap(" .. scene.dwMapID .. ")")
----------------------------------------------------------------------<
local tPushRoleCountMap_List = {
	
	--[3] = {�Ƿ���Ҫ����Ӫ�������ޣ�"�ŶӻID"},  237��С���� 436������BOSS
	[9] =   {true, 237}, -- "���",
	[10] =  {true, 0}, -- "�ܵ�",
	[12] =  {true, 237}, -- "�㻪��",
	[13] =  {true, 237}, -- "��ˮ��",
	[21] =  {true, 237}, -- "������",
	[22] =  {true, 237}, -- "����ɽ",
	[23] =  {true, 237}, -- "���Ż�Į",
	[25] =  {true, 237}, -- "������",
	[27] =  {true, 237}, -- "���˹�",
	[30] =  {true, 237}, -- "����",
	[35] =  {true, 237}, -- "����Ͽ",	
	[100] = {true, 237}, -- "������",
	[101] = {true, 237}, -- "����ɽ",
	[103] = {true, 237}, -- "������",
	[104] = {true, 237}, -- "������",
	[105] = {true, 237}, -- "��ɽ����",
	[139] = {true, 237}, -- "�㻪�ȡ�ս��",
	[151] = {true, 436}, -- "������ս��",
	[152] = {true, 0}, -- "���Ƽ���",
	[153] = {true, 237}, -- "������",
	[156] = {true, 436}, -- "������ս��",
	[214] = {true, 436}, -- "��̨ɽ",
	[215] = {true, 436}, -- "ǧ����",
	[216] = {true, 0}, -- "��ɽ���ԭ",
	[217] = {false, 0}, -- "�ڸ��",
}
function PushRoleCountMap(scene)
	if GetServerType() == SERVER_TYPE.PVP then
		if tPushRoleCountMap_List[scene.dwMapID] then
			if not IsActivityOn(tPushRoleCountMap_List[scene.dwMapID][2]) and tPushRoleCountMap_List[scene.dwMapID][1] then
				GCCommand("SetMapMaxPlayerCountByCamp(" .. scene.dwMapID .. ", 1, 400)")
				GCCommand("SetMapMaxPlayerCountByCamp(" .. scene.dwMapID .. ", 2, 400)")
			end 
			GCCommand("RegisterPushRoleCountMap(" .. scene.dwMapID .. ", " .. scene.nCopyIndex .. ", true)") --  dwMapID ��ͼID, nCopyIndex(23.8.28��������), bInRate �Ƿ��Ա�����ʽ��ʾ
		end		

	end	
end
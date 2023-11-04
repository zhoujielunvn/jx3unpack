---------------------------------------------------------------------->
-- 脚本名称:	scripts/player/ClientPlayerActivate.lua
-- 更新时间:	2022/10/26 11:14:43
-- 更新用户:	SK-20220902MYYY
-- 脚本说明:	
----------------------------------------------------------------------<

--每次新增金发/粉发，需要在此处增加判断，因为要统计金发20个发名片，新增ID需同步维护并维护客户端脚本【scripts/player/Exterior.lua】下的同名表！！2022.4.25新增
local tYellowHair = {441, 498, 528, 557, 634, 679, 708, 709, 724, 769, 814, 867, 902, 918, 935, 965, 982, 985, 999, 1013, 1027, 1037, 1050, 1070, 1097, 1098, 1123, 1124, 1125, 1126, 1138,
	1165, 1166, 1167, 1168, 1169, 1170, 1183, 1184, 1185, 1186, 1187, 1188, 1191, 1201, 1202, 1209, 1214, 1229, 1244, 1245, 1246, 1247, 1263, 1264, 1265, 1266, 1267, 1270, 1283, 1301, 1322,
	1323, 1324, 1325, 1326, 1327, 1338, 1339, 1342, 1350, 1351, 1352, 1353, 1369, 1380, 1381, 1382, 1383, 1384, 1400, 1401, 1402, 1403, 1404, 1407, 1451, 1469, 1487, 1494, 1527,
	1541, 1542, 1543, 1544, 1545
}

--每次新增红发/紫发，需要在此处增加判断，因为要统计红发10个发名片，新增ID需同步维护并维护客户端脚本【scripts/player/Exterior.lua】下的同名表！！2022.4.25新增
local tRedHair = {224, 318, 375, 432, 513, 589, 663, 753, 844, 914, 942, 957, 994, 1026, 1046, 1061, 1129, 1196, 1219, 1294, 1362, 1446, 1518
}

--检查声望等级成就
local CheckPlayerAttributeAch = function(player, nAttribute, RangeList)
	for k, v in ipairs(RangeList) do
		if nAttribute >= v[1] then
			if not player.IsAchievementAcquired(v[2]) then
				RemoteCallToServer("OnClientAddAchievement", v[3])
			end
		else
			break
		end
	end
end

local CheckPlayerReputeLevelAch = function(player, RangeList, nStart, nEnd)
	if nStart > #RangeList then
		return
	end
	if nEnd > #RangeList then
		nEnd = #RangeList
	end
	for k = nStart, nEnd do
		if not player.IsReputationHide(RangeList[k][1]) and player.GetReputeLevel(RangeList[k][1]) >= RangeList[k][2] then
			if not player.IsAchievementAcquired(RangeList[k][3]) then
				RemoteCallToServer("OnClientAddAchievement", RangeList[k][4])
			end
		end
	end
end

-------------------等级提升-------------------
local LevelRange =
{
	{5, 706, "Level_5"},
	{10, 1, "Level_10"},
	{20, 2, "Level_20"},
	{30, 3, "Level_30"},
	{40, 4, "Level_40"},
	{50, 5, "Level_50"},
	{60, 6, "Level_60"},
	{70, 7, "Level_70"},
	{80, 1877, "Level_80"},
	{90, 3434, "Level_90"},
	{95, 4927, "Level_95"},
	{100, 6804, "Level_100"},
	{120, 10649, "Level_120"},
}

-------------------获得金钱-------------------
local MoneyRange =
{
	{1000, 371, "Get1000G"},
	{3000, 372, "Get3000G"},
	{5000, 373, "Get5000G"},
	{8000, 890, "Get8000G"},
	{10000, 891, "Get10000G"},
}

-------------------获得装备分数-------------------
local EquipScoreRange1 =
{
	{1000, 2902, "EQUIP_SCORE1000"},
	{2000, 2903, "EQUIP_SCORE2000"},
	{3000, 2904, "EQUIP_SCORE3000"},
	{3500, 2905, "EQUIP_SCORE3500"},
	{4000, 2906, "EQUIP_SCORE4000"},
	{5000, 2907, "EQUIP_SCORE5000"},
	{6000, 3448, "EQUIP_SCORE6000"},
	{7000, 3449, "EQUIP_SCORE7000"},
	{8000, 3450, "EQUIP_SCORE8000"},
	{9000, 3451, "EQUIP_SCORE9000"},
}

local EquipScoreRange2 =
{
	{10000, 4309, "EQUIP_SCORE10000"},
	{15000, 4967, "EQUIP_SCORE15000"},
	{20000, 4968, "EQUIP_SCORE20000"},
	{25000, 4969, "EQUIP_SCORE25000"},
	{30000, 4970, "EQUIP_SCORE30000"},
	{33000, 7110, "EQUIP_SCORE33000"},
	{35000, 7101, "EQUIP_SCORE35000"},
	{40000, 4971, "EQUIP_SCORE40000"},
	{45000, 7848, "EQUIP_SCORE45000"},
	{50000, 7474, "EQUIP_SCORE50000"},
}

local EquipScoreRange3 =
{
	{70000, 8833, "EQUIP_SCORE70000"},
	{80000, 9407, "EQUIP_SCORE80000"},
	{90000, 8834, "EQUIP_SCORE90000"},
	{100000, 9758, "EQUIP_SCORE100000"},
	{120000, 10156, "EQUIP_SCORE120000"},
	{160000, 10650, "EQUIP_SCORE160000"},
	{180000, 11014, "EQUIP_SCORE180000"},
	{200000, 10651, "EQUIP_SCORE200000"},
	{233000, 11015, "EQUIP_SCORE233000"},
	{260000, 11293, "EQUIP_SCORE260000"},
}

---------------获取称号----------------------
local DesignationRange =
{
	{1, 713, "Designation_1"},
	{10, 712, "Designation_10"},
	{20, 151, "Designation_20"},
	{50, 152, "Designation_50"},
}

---------------获取声望----------------------
local ReputeRange =
{
	{35, 7, 503, "Luoyang_Zunjin"}, 		-- 洛阳声望到尊敬
	{36, 7, 504, "Changan_Zunjin"}, 	   	-- 长安声望到尊敬
	{34, 7, 505, "Yangzhou_Zunjin"}, 	   	-- 扬州声望到尊敬
	{11, 7, 506, "Shaolin_Zunjin"}, 	   	-- 少林声望到尊敬
	{14, 7, 507, "Chunyang_Zunjin"}, 	   	-- 纯阳声望到尊敬
	{18, 7, 1346, "Cangjian_Zunjin"}, 	   	-- 藏剑声望到尊敬
	{12, 7, 508, "Wanhua_Zunjin"}, 	   	-- 万花声望到尊敬
	{15, 7, 509, "Qixiu_Zunjin"}, 	   	-- 七秀声望到尊敬
	{13, 7, 510, "Tiance_Zunjin"}, 	   	-- 天策声望到尊敬
	{50, 7, 511, "Haoqimeng_Zunjin"},		-- 浩气盟声望到尊敬
	{49, 7, 512, "Erengu_Zunjin"}, 	   	-- 恶人谷声望到尊敬
	--{38, 3, 513, "Hongyijiao_Zhongli"}, 	   	-- 红衣教声望到中立
	{38, 4, 514, "Hongyijiao_Youshan"}, 	   	-- 红衣教声望到友好
	{46, 4, 815, "Kunlun_Youshan"}, 	   	-- 昆仑声望到友好
	{47, 4, 816, "Daozong_Youshan"}, 	   	-- 刀宗声望到友好
	{46, 5, 817, "Kunlun_qinmi"}, 	   	-- 昆仑声望到亲密
	{47, 5, 818, "Daozong_qinmi"}, 	   	-- 刀宗声望到亲密
	{45, 7, 819, "Changgemen_Zunjin"}, 	   	-- 长歌门声望到尊敬
	{44, 7, 820, "Donglizhai_Zunjin"}, 	   	-- 东篱寨声望到达尊敬
	{48, 7, 821, "Yingyuanhui_Zunjin"}, 	   	-- 隐元会声望到达尊敬
	{43, 7, 822, "Shanghui_Zunjin"}, 	   	-- 商会声望到达尊敬
	{42, 7, 823, "Biaoju_Zunjin"}, 	   	-- 镖局声望到达尊敬
	{16, 7, 1881, "Wudu_Zunjin"}, 	   		-- 五毒声望到达尊敬
	{83, 7, 1879, "Cangjingge_Zunjin"}, 	   		-- 藏经阁声望到达尊敬
	{84, 7, 1880, "Badao_Zunjin"}, 	   		-- 霸刀声望到达尊敬
	{85, 7, 1882, "Daligong_Zunjin"}, 	   		-- 大理宫声望到达尊敬
	{86, 7, 1883, "Tana_Zunjin"}, 	   		-- 塔纳声望到达尊敬
	{87, 7, 1884, "Zhurongdian_Zunjin"}, 	   		-- 祝融殿声望到达尊敬
	{88, 7, 1885, "Tiannanwangjia_Zunjin"}, 	   		-- 天南王家声望到达尊敬
	{89, 7, 1886, "Baihuojiao_Zunjin"}, 	   		-- 拜火教声望到达尊敬
	{90, 7, 1887, "Jiulizu_Zunjin"}, 	   		-- 九黎族声望到达尊敬
	{91, 7, 1888, "Zhennanbiaoju_Zunjin"}, 	   		-- 镇南镖局声望到达尊敬
	{82, 7, 2396, "Xuanyuanshe_Zunjin"}, 	   		-- 轩辕社声望到达尊敬
	{17, 7, 2708, "Tangmen_Zunjin"}, 	   		-- 唐门声望到达尊敬
	{94, 7, 3120, "Wukuinanling_Zunjin"}, 	   		-- 无愧南灵声望到达尊敬
	{93, 7, 3185, "Lihenzhong_Zunjin"}, 	   		-- 塔纳离恨冢声望到达尊敬
	{20, 7, 3306, "Mingjiao_Zunjin"}, 	   		-- 明教声望到达尊敬
	{19, 7, 3541, "Gaibang_Zunjing"}, 	   		-- 丐帮声望到达尊敬
	{103, 7, 3542, "Shuofangjun_Zunjing"}, 	   		-- 朔方军声望到达尊敬
	{104, 7, 3543, "Yijun_Zunjing"}, 	   		-- 义军声望到达尊敬
	{105, 7, 3544, "Langyayanshi_Zunjing"}, 	   		-- 琅琊颜氏声望到达尊敬
	{107, 7, 3545, "Datangbingbu_Zunjing"}, 	   		-- 大唐兵部声望到达尊敬
	{108, 7, 3546, "Litanghuangshi_Zunjing"}, 	   		-- 李唐皇室声望到达尊敬
	{110, 7, 3547, "Tongguanshoubei_Zunjing"}, 	   		-- 潼关守备军声望到达尊敬
	{111, 7, 3548, "Tulanghui_Zunjing"}, 	   		-- 屠狼会声望到达尊敬
	{109, 7, 3549, "Lingyange_Zunjing"}, 	   		-- 凌烟阁声望到达尊敬
	{113, 7, 3894, "DaYanChangAnFu_Zunjing"}, 	   		-- 大燕长安府声望到尊敬
	{115, 7, 3895, "ChangAnShangHui_Zunjing"}, 	   		-- 长安商会声望到尊敬
	{114, 7, 3896, "JingShiJunZhong_Zunjing"}, 	   		-- 靖世军·忠声望到尊敬
	{116, 7, 3897, "JingShiJunYi_Zunjing"}, 	   		-- 靖世军·义声望到尊敬
	{118, 7, 3927, "JunXieJian_Zunjing"}, 	   		-- 军械监声望到尊敬
	{119, 7, 3928, "YingLingTing_Zunjing"}, 	   		-- 英灵厅声望到尊敬
	{121, 7, 4045, "ChaNaQianNian_Zunjing"}, 	   		-- 刹那千年声望到尊敬
	{123, 7, 4053, "MoShiMenTu_Zunjing"}, 	   		-- 墨氏门徒声望到尊敬
	{124, 7, 4054, "YinYuanTianBu_Zunjing"}, 	   		-- 隐元天部声望到尊敬
	{125, 7, 4055, "TaiChuLingShe_Zunjing"}, 	   		-- 太初陵社声望到尊敬
	{97, 7, 4198, "DuanShiShanCheng_Zunjing"}, 	   		-- 段氏山城声望到尊敬
	{126, 7, 4199, "ChangAnFuHao_Zunjing"}, 	   		-- 长安富豪声望到尊敬
	{127, 7, 4334, "CangYun_Zunjing"}, 			-- 苍云门派声望到尊敬
	{132, 7, 4335, "LingWuXianFengJun_Zunjing"}, 			-- 灵武先锋军声望到尊敬
	{133, 7, 4336, "TaiYuanYiShi_Zunjing"}, 			-- 太原义士声望到尊敬
	{134, 7, 4337, "WuLinMeng_Zunjing"}, 			-- 武林盟声望到尊敬
	{135, 7, 4338, "JianNingTieWei_Zunjing"}, 			-- 建宁铁卫声望到尊敬
	{137, 7, 4339, "HeDongShangHui_Zunjing"}, 			-- 河东商会声望到尊敬
	{138, 7, 4340, "TaiYuanLianJun_Zunjing"}, 			-- 太原联军声望到尊敬
	{139, 7, 4341, "LongChengFeiJiang_Zunjing"}, 			-- 太原守军·龙城飞将声望到尊敬
	{140, 7, 4342, "FengHuoBeiWang_Zunjing"}, 			-- 太原守军·烽火北望声望到尊敬
	{141, 7, 4646, "JiangNanYeShang_Zunjing"}, 			-- 江南叶商行声望到尊敬
	{128, 7, 5033, "changgemen_Zunjing"}, 			-- 长歌门	
	{142, 7, 5034, "huiheshangdui_Zunjing"}, 			-- 回纥商队
	{143, 7, 5035, "heishuicheng_Zunjing"}, 			-- 跋汗族·黑水城
	{144, 7, 5036, "huainanshanghang_Zunjing"}, 			-- 淮南商行
	{145, 7, 5037, "wuzhehui_Zunjing"}, 			-- 无遮会
	{146, 7, 5038, "yinshanheishi_Zunjing"}, 			-- 阴山黑市
	{147, 7, 5039, "mibaohuimoxibu_Zunjing"}, 			-- 觅宝会漠西部
	{148, 7, 5040, "kongshantang_Zunjing"}, 			-- 恶人谷空山堂
	{149, 7, 5041, "xinyutang_Zunjing"}, 			-- 浩气盟新雨堂
	{150, 7, 5042, "changgeyinxianju_Zunjing"}, 			-- 长歌门·隐贤居
	{151, 7, 5043, "baiyunhui_Zunjing"}, 			-- 白云会
	{152, 7, 5044, "mingsenghui_Zunjing"}, 			-- 名僧会
	{153, 7, 5110, "changgemiyinyuan_Zunjing"}, 			-- 长歌门·觅音明心园
	{154, 7, 5111, "yudailou_Zunjing"}, 			-- 商会·玉带楼
	{155, 7, 5112, "liehunzu_Zunjing"}, 			-- 源氏·狩魂组
	{160, 7, 5336, "yonganshanghang_Zunjing"}, 			-- 永安商行		
	{161, 7, 5444, "lingyunhui_Zunjing"}, 			-- 凌云会			
	{129, 7, 5489, "badao_Zunjing"}, 			-- 霸刀挚友	
	{163, 7, 5490, "guoziyijingwu_Zunjing"}, 			-- 郭子仪部·靖武	
	{164, 7, 5491, "jingjinge_Zunjing"}, 			-- 精金阁	
	{165, 7, 5492, "guangfudangkou_Zunjing"}, 			-- 洛阳光复联军·荡寇	
	{166, 7, 5493, "guangfujinbiao_Zunjing"}, 			-- 洛阳光复联军·旌表
	{167, 7, 5817, "yangminglei_Zunjing"}, 			-- 扬名擂	
	{168, 7, 5818, "beishanhuinutao_Zunjing"}, 			-- 北山会·怒涛堂	
	{169, 7, 5819, "beishanhuinongying_Zunjing"}, 			-- 北山会·弄影堂	
	{172, 7, 5996, "wudushengxiedian_Zunjing"}, 			-- 五毒圣蝎殿	
	{173, 7, 5993, "tianxuangefengbu_Zunjing"}, 			-- 隐元会·天玄阁·风部
	{174, 7, 5994, "badaoyuhaitang_Zunjing"}, 			-- 霸刀驭海堂
	{175, 7, 5995, "dugushijiajiujun_Zunjing"}, 			-- 独孤世家·九军
	{176, 7, 5992, "erjingfengyuan_Zunjing"}, 			-- 恶人惊风院
	{177, 7, 5991, "hqshuangleidian_Zunjing"}, 			-- 浩气霜雷殿
	{178, 7, 6197, "fb_huitianqian_Zunjing"}, 			-- 狼牙堡·辉天堑  丐帮·忠义堂
	{179, 7, 6198, "fb_langshendian_Zunjing"}, 			-- 狼牙堡·狼神殿  霸刀山庄·止戈堂
	{184, 7, 6559, "eryangweidian_Zunjing"},			 -- -- 恶人谷扬威殿
	{185, 7, 6561, "hqzhenyuantang_Zunjing"},			 -- -- 浩气盟镇远阁
	{130, 7, 6683, "penglai_Zunjing"},			 -- -- 蓬莱挚友
	{180, 7, 6771, "xiakedao_Zunjing"},			 -- -- 侠客岛
	{181, 7, 6773, "jsdyyinshi_Zunjing"},			 -- -- 经首道源尹氏
	{182, 7, 6775, "dtfdkangshi_Zunjing"},			 -- -- 洞天福地康氏
	{183, 7, 6777, "hanhaiguo_Zunjing"},			 -- -- 韩海国
	{186, 7, 6779, "binghuodao_Zunjing"},			 -- -- 冰火岛
	{195, 7, 7093, "jinghaimeng_Zunjing"},			-- --靖海盟
	{196, 7, 7095, "zhoutianshao_Zunjing"},			-- --周天哨
	{197, 7, 7070, "donghaibawanglei_Zunjing"},		-- --东海霸王擂
	{202, 7, 7477, "nanmingchuandui_Zunjing"},		-- --东海霸王擂
	{210, 7, 7875, "TZWSF_Zunjing"},		-- --太子卫率府
	--声望达到钦佩
	{35, 8, 6443, "Luoyang_QinPei"}, --洛阳声望到钦佩
	{36, 8, 6444, "Changan_QinPei"}, --长安声望到钦佩
	{34, 8, 6445, "Yangzhou_QinPei"}, --扬州声望到钦佩
	{11, 8, 6449, "Shaolin_QinPei"}, --少林声望到钦佩
	{14, 8, 6450, "Chunyang_QinPei"}, --纯阳声望到钦佩
	{12, 8, 6451, "Wanhua_QinPei"}, --万花声望到钦佩
	{15, 8, 6452, "Qixiu_QinPei"}, --七秀声望到钦佩
	{13, 8, 6453, "Tiance_QinPei"}, --天策声望到钦佩
	{18, 8, 6446, "Cangjian_QinPei"}, --藏剑声望到钦佩
	{50, 8, 6533, "Haoqimeng_QinPei"}, --浩气盟声望到钦佩
	{49, 8, 6534, "Erengu_QinPei"}, --恶人谷声望到钦佩
	{45, 8, 6475, "Changgemen_QinPei"}, --长歌门声望到钦佩
	{44, 8, 6476, "Donglizhai_QinPei"}, --东篱寨声望到达钦佩
	{48, 8, 6477, "Yingyuanhui_QinPei"}, --隐元会声望到达钦佩
	{43, 8, 6478, "Shanghui_QinPei"}, --商会声望到达钦佩
	{42, 8, 6479, "Biaoju_QinPei"}, --镖局声望到达钦佩
	{16, 8, 6448, "Wudu_QinPei"}, --五毒声望到达钦佩
	{83, 8, 6472, "Cangjingge_QinPei"}, --藏经阁声望到达钦佩
	{84, 8, 6474, "Badao_QinPei"}, --霸刀声望到达钦佩
	{85, 8, 6460, "Daligong_QinPei"}, --大理宫声望到达钦佩
	{86, 8, 6461, "Tana_QinPei"}, --塔纳声望到达钦佩
	{87, 8, 6464, "Zhurongdian_QinPei"}, --祝融殿声望到达钦佩
	{88, 8, 6465, "Tiannanwangjia_QinPei"}, --天南王家声望到达钦佩
	{89, 8, 6468, "Baihuojiao_QinPei"}, --拜火教声望到达钦佩
	{90, 8, 6469, "Jiulizu_QinPei"}, --九黎族声望到达钦佩
	{91, 8, 6563, "Zhennanbiaoju_QinPei"}, --镇南镖局声望到达钦佩
	{82, 8, 6480, "Xuanyuanshe_QinPei"}, --轩辕社声望到达钦佩
	{17, 8, 6454, "Tangmen_QinPei"}, --唐门声望到达钦佩
	{94, 8, 6481, "Wukuinanling_QinPei"}, --无愧南灵声望到达钦佩
	{93, 8, 6482, "Lihenzhong_QinPei"}, --塔纳离恨冢声望到达钦佩
	{20, 8, 6455, "Mingjiao_QinPei"}, --明教声望到达钦佩
	{19, 8, 6447, "Gaibang_QinPei"}, --丐帮声望到达钦佩
	{103, 8, 6459, "Shuofangjun_QinPei"}, --朔方军声望到达钦佩
	{104, 8, 6462, "Yijun_QinPei"}, --义军声望到达钦佩
	{105, 8, 6463, "Langyayanshi_QinPei"}, --琅琊颜氏声望到达钦佩
	{107, 8, 6466, "Datangbingbu_QinPei"}, --大唐兵部声望到达钦佩
	{108, 8, 6467, "Litanghuangshi_QinPei"}, --李唐皇室声望到达钦佩
	{110, 8, 6470, "Tongguanshoubei_QinPei"}, --潼关守备军声望到达钦佩
	{111, 8, 6471, "Tulanghui_QinPei"}, --屠狼会声望到达钦佩
	{109, 8, 6473, "Lingyange_QinPei"}, --凌烟阁声望到达钦佩
	{113, 8, 6483, "DaYanChangAnFu_QinPei"}, --大燕长安府声望到钦佩
	{115, 8, 6484, "ChangAnShangHui_QinPei"}, --长安商会声望到钦佩
	{114, 8, 6485, "JingShiJunZhong_QinPei"}, --靖世军·忠声望到钦佩
	{116, 8, 6486, "JingShiJunYi_QinPei"}, --靖世军·义声望到钦佩
	{118, 8, 6487, "JunXieJian_QinPei"}, --军械监声望到钦佩
	{119, 8, 6536, "YingLingTing_QinPei"}, --英灵厅声望到钦佩
	{123, 8, 6488, "MoShiMenTu_QinPei"}, --墨氏门徒声望到钦佩
	{124, 8, 6489, "YinYuanTianBu_QinPei"}, --隐元天部声望到钦佩
	{125, 8, 6490, "TaiChuLingShe_QinPei"}, --太初陵社声望到钦佩
	{97, 8, 6491, "DuanShiShanCheng_QinPei"}, --段氏山城声望到钦佩
	{126, 8, 6492, "ChangAnFuHao_QinPei"}, --长安富豪声望到钦佩
	{127, 8, 6456, "CangYun_QinPei"}, --苍云门派声望到钦佩
	{132, 8, 6493, "LingWuXianFengJun_QinPei"}, --灵武先锋军声望到钦佩
	{133, 8, 6494, "TaiYuanYiShi_QinPei"}, --太原义士声望到钦佩
	{134, 8, 6495, "WuLinMeng_QinPei"}, --武林盟声望到钦佩
	{135, 8, 6496, "JianNingTieWei_QinPei"}, --建宁铁卫声望到钦佩
	{137, 8, 6497, "HeDongShangHui_QinPei"}, --河东商会声望到钦佩
	{138, 8, 6498, "TaiYuanLianJun_QinPei"}, --太原联军声望到钦佩
	{139, 8, 6499, "LongChengFeiJiang_QinPei"}, --太原守军·龙城飞将声望到钦佩
	{140, 8, 6500, "FengHuoBeiWang_QinPei"}, --太原守军·烽火北望声望到钦佩
	{141, 8, 6501, "JiangNanYeShang_QinPei"}, --江南叶商行声望到钦佩。
	{128, 8, 64433, "changgemen_QinPei"}, --长歌门
	{142, 8, 6502, "huiheshangdui_QinPei"}, --回纥商队
	{143, 8, 6503, "heishuicheng_QinPei"}, --跋汗族·黑水城
	{144, 8, 6504, "huainanshanghang_QinPei"}, --淮南商行
	{145, 8, 6505, "wuzhehui_QinPei"}, --无遮会
	{146, 8, 6506, "yinshanheishi_QinPei"}, --阴山黑市
	{147, 8, 6507, "mibaohuimoxibu_QinPei"}, --觅宝会漠西部
	{148, 8, 6508, "kongshantang_QinPei"}, --恶人谷空山堂
	{149, 8, 6509, "xinyutang_QinPei"}, --浩气盟新雨堂
	{150, 8, 6510, "changgeyinxianju_QinPei"}, --长歌门·隐贤居
	{151, 8, 6511, "baiyunhui_QinPei"}, --白云会
	{152, 8, 6512, "mingsenghui_QinPei"}, --名僧会
	{153, 8, 6513, "changgemiyinyuan_QinPei"}, --长歌门·觅音明心园
	{154, 8, 6514, "yudailou_QinPei"}, --商会·玉带楼
	{155, 8, 6515, "liehunzu_QinPei"}, --源氏·狩魂组
	{160, 8, 6516, "yonganshanghang_QinPei"}, --永安商行
	{161, 8, 6517, "lingyunhui_QinPei"}, --凌云会
	{129, 8, 6458, "badao_QinPei"}, --霸刀至交
	{163, 8, 6518, "guoziyijingwu_QinPei"}, --郭子仪部·靖武
	{164, 8, 6519, "jingjinge_QinPei"}, --精金阁
	{165, 8, 6520, "guangfudangkou_QinPei"}, --洛阳光复联军·荡寇
	{166, 8, 6521, "guangfujinbiao_QinPei"}, --洛阳光复联军·旌表
	{167, 8, 6522, "yangminglei_QinPei"}, --扬名擂
	{168, 8, 6523, "beishanhuinutao_QinPei"}, --北山会·怒涛堂
	{169, 8, 6524, "beishanhuinongying_QinPei"}, --北山会·弄影堂
	{172, 8, 6530, "wudushengxiedian_QinPei"}, --五毒圣蝎殿
	{173, 8, 6527, "tianxuangefengbu_QinPei"}, --隐元会·天玄阁·风部
	{174, 8, 6528, "badaoyuhaitang_QinPei"}, --霸刀驭海堂
	{175, 8, 6529, "dugushijiajiujun_QinPei"}, --独孤世家·九军
	{176, 8, 6526, "erjingfengyuan_QinPei"}, --恶人惊风院
	{177, 8, 6525, "hqshuangleidian_QinPei"}, --浩气霜雷殿
	{178, 8, 6531, "fb_huitianqian_QinPei"}, --丐帮忠义堂
	{179, 8, 6532, "fb_langshendian_QinPei"}, --霸刀山庄·止戈堂
	{184, 8, 6559, "eryangweidian_QinPei"}, --恶人谷扬威殿
	{185, 8, 6561, "hqzhenyuantang_QinPei"}, --浩气盟镇远阁
	{130, 8, 6684, "penglai_QinPei"}, --蓬莱至交
	{180, 8, 6772, "xiakedao_QinPei"},			 -- -- 侠客岛
	{181, 8, 6774, "jsdyyinshi_QinPei"},			 -- -- 经首道源尹氏
	{182, 8, 6776, "dtfdkangshi_QinPei"},			 -- -- 洞天福地康氏
	{183, 8, 6778, "hanhaiguo_QinPei"},			 -- -- 韩海国
	{186, 8, 6780, "binghuodao_QinPei"},			 -- -- 冰火岛
	{195, 8, 7094, "jinghaimeng_QinPei"},			-- --靖海盟
	{196, 8, 7096, "zhoutianshao_QinPei"},			-- --周天哨
	{197, 8, 7071, "donghaibawanglei_QinPei"},		-- --东海霸王擂
	{202, 8, 7478, "nanmingchuandui_QinPei"},		-- --东海霸王擂
	{210, 8, 7876, "TZWSF_QinPei"},		-- --太子卫率府
}

-------------------侠行点相关------------------
local JusticeRange =
{
	{5000, 543, "Justice5000"},
	{13000, 544, "Justice13000"},
	{35000, 545, "Justice35000"},
}

---------------获得威望相关-----------------
local PrestigeRange =
{
	{9000, 840, "Prestige9000"},
	{12000, 841, "Prestige12000"},
	{15000, 549, "Prestige15000"},
	{20000, 550, "Prestige20000"},
	{50000, 551, "Prestige50000"},
}

--------------读书相关-----------------------
local aReadBook =
{
	-- {BookID, nAchievementID, "ReadBook_BookID"},
	{1152, 1063, "ReadBook_1152"},
	{1153, 1064, "ReadBook_1153"},
	{1154, 1065, "ReadBook_1154"},
	{1155, 1066, "ReadBook_1155"},
	{1156, 1067, "ReadBook_1156"},
	{1157, 1068, "ReadBook_1157"},
	{1158, 1069, "ReadBook_1158"},
	{1159, 1070, "ReadBook_1159"},
	{1160, 1172, "ReadBook_1160"},
	{1161, 1173, "ReadBook_1161"},
	{1162, 1174, "ReadBook_1162"},
	{1163, 1175, "ReadBook_1163"},
	{1164, 1176, "ReadBook_1164"},
	{1165, 1177, "ReadBook_1165"},
	{1166, 1178, "ReadBook_1166"},
	{1167, 1179, "ReadBook_1167"},
	{1192, 2072, "ReadBook_1192"}, -- 红尘恩怨套书
	{1193, 2073, "ReadBook_1193"},
	{1194, 2074, "ReadBook_1194"},
	{1195, 2075, "ReadBook_1195"},
	{1196, 2076, "ReadBook_1196"},
	{1197, 2077, "ReadBook_1197"},
	{1198, 2078, "ReadBook_1198"},
	{1199, 2079, "ReadBook_1199"},
	{1200, 2081, "ReadBook_1200"}, -- 血龙之谜套书
	{1201, 2082, "ReadBook_1201"},
	{1202, 2083, "ReadBook_1202"},
	{1203, 2084, "ReadBook_1203"},
	{1204, 2085, "ReadBook_1204"},
	{1205, 2086, "ReadBook_1205"},
	{1206, 2087, "ReadBook_1206"},
	{1207, 2088, "ReadBook_1207"},
	{1208, 2090, "ReadBook_1208"}, -- 血龙秘闻：达摩龙窟
	{1209, 2091, "ReadBook_1209"},
	{1210, 2092, "ReadBook_1210"},
	{1211, 2093, "ReadBook_1211"},
	{1212, 2094, "ReadBook_1212"},
	{1213, 2095, "ReadBook_1213"},
	{1214, 2096, "ReadBook_1214"},
	{1215, 2097, "ReadBook_1215"},
	{1216, 2099, "ReadBook_1216"}, -- 长安客书稿
	{1217, 2100, "ReadBook_1217"},
	{1218, 2101, "ReadBook_1218"},
	{1219, 2102, "ReadBook_1219"},
	{1220, 2103, "ReadBook_1220"},
	{1221, 2104, "ReadBook_1221"},
	{1222, 2105, "ReadBook_1222"},
	{1223, 2106, "ReadBook_1223"},
	{1224, 2108, "ReadBook_1224"}, -- 苗岭异事
	{1225, 2109, "ReadBook_1225"},
	{1226, 2110, "ReadBook_1226"},
	{1227, 2111, "ReadBook_1227"},
	{1228, 2112, "ReadBook_1228"},
	{1229, 2113, "ReadBook_1229"},
	{1230, 2114, "ReadBook_1230"},
	{1231, 2115, "ReadBook_1231"},
	{1232, 2117, "ReadBook_1232"}, -- 谢渊列传
	{1233, 2118, "ReadBook_1233"},
	{1234, 2119, "ReadBook_1234"},
	{1235, 2120, "ReadBook_1235"},
	{1236, 2121, "ReadBook_1236"},
	{1237, 2122, "ReadBook_1237"},
	{1238, 2123, "ReadBook_1238"},
	{1239, 2124, "ReadBook_1239"},
	{1240, 2126, "ReadBook_1240"}, -- 天之九野
	{1241, 2127, "ReadBook_1241"},
	{1242, 2128, "ReadBook_1242"},
	{1243, 2129, "ReadBook_1243"},
	{1244, 2130, "ReadBook_1244"},
	{1245, 2131, "ReadBook_1245"},
	{1246, 2132, "ReadBook_1246"},
	{1248, 2134, "ReadBook_1248"}, -- 星宿老仙
	{1249, 2135, "ReadBook_1249"},
	{1250, 2136, "ReadBook_1250"},
	{1251, 2137, "ReadBook_1251"},
	{1252, 2138, "ReadBook_1252"},
	{1253, 2139, "ReadBook_1253"},
	{1254, 2140, "ReadBook_1254"},
	{1256, 2142, "ReadBook_1256"}, -- 苗族制蛊秘术
	{1257, 2143, "ReadBook_1257"},
	{1258, 2144, "ReadBook_1258"},
	{1259, 2145, "ReadBook_1259"},
	{1260, 2146, "ReadBook_1260"},
	{1261, 2147, "ReadBook_1261"},
	{1264, 2149, "ReadBook_1264"}, -- 千金方
	{1265, 2150, "ReadBook_1265"},
	{1266, 2151, "ReadBook_1266"},
	{1267, 2152, "ReadBook_1267"},
	{1268, 2153, "ReadBook_1268"},
	{1272, 2155, "ReadBook_1272"}, --西南神话故事传说
	{1273, 2156, "ReadBook_1273"},
	{1274, 2157, "ReadBook_1274"},
	{1275, 2158, "ReadBook_1275"},
	{1276, 2159, "ReadBook_1276"},
	{1277, 2160, "ReadBook_1277"},
	{1280, 2162, "ReadBook_1280"}, -- 神异经·西荒经套书
	{1281, 2163, "ReadBook_1281"},
	{1282, 2164, "ReadBook_1282"},
	{1283, 2165, "ReadBook_1283"},
	{1288, 2167, "ReadBook_1288"}, -- 大唐军建秘录套书
	{1289, 2168, "ReadBook_1289"},
	{1290, 2169, "ReadBook_1290"},
	{1291, 2170, "ReadBook_1291"},
	{1292, 2171, "ReadBook_1292"},
	{1296, 2173, "ReadBook_1296"}, -- 段族旧事套书
	{1297, 2174, "ReadBook_1297"},
	{1298, 2175, "ReadBook_1298"},
	{1299, 2176, "ReadBook_1299"},
	{1300, 2177, "ReadBook_1300"},
	{1301, 2178, "ReadBook_1301"},
	{1302, 2179, "ReadBook_1302"},
	{1303, 2180, "ReadBook_1303"},
	{1304, 2182, "ReadBook_1304"}, --  红尘遗秘
	{1305, 2183, "ReadBook_1305"},
	{1306, 2184, "ReadBook_1306"},
	{1307, 2185, "ReadBook_1307"},
	{1308, 2186, "ReadBook_1308"},
	{1309, 2187, "ReadBook_1309"},
	{1310, 2188, "ReadBook_1310"},
	{1311, 2189, "ReadBook_1311"},
	{1312, 2191, "ReadBook_1312"}, -- 蛮人志异
	{1313, 2192, "ReadBook_1313"},
	{1314, 2193, "ReadBook_1314"},
	{1315, 2194, "ReadBook_1315"},
	{1316, 2195, "ReadBook_1316"},
	{1317, 2196, "ReadBook_1317"},
	{1318, 2197, "ReadBook_1318"},
	{1319, 2198, "ReadBook_1319"},
	{1320, 2200, "ReadBook_1320"}, -- 五仙圣地套书
	{1321, 2201, "ReadBook_1321"},
	{1322, 2202, "ReadBook_1322"},
	{1323, 2203, "ReadBook_1323"},
	{1324, 2204, "ReadBook_1324"},
	{1325, 2205, "ReadBook_1325"},
	{1328, 2207, "ReadBook_1328"}, -- 牡丹套书
	{1329, 2208, "ReadBook_1329"},
	{1330, 2209, "ReadBook_1330"},
	{1331, 2210, "ReadBook_1331"},
	{1336, 2212, "ReadBook_1336"}, -- 圣蛇·姬无双
	{1337, 2213, "ReadBook_1337"},
	{1338, 2214, "ReadBook_1338"},
	{1339, 2215, "ReadBook_1339"},
	{1344, 2217, "ReadBook_1344"}, -- 慕容追风套书
	{1345, 2218, "ReadBook_1345"},
	{1346, 2219, "ReadBook_1346"},
	{1347, 2220, "ReadBook_1347"},
	{1352, 2222, "ReadBook_1352"}, -- 卫栖梧套书
	{1353, 2223, "ReadBook_1353"},
	{1354, 2224, "ReadBook_1354"},
	{1355, 2225, "ReadBook_1355"},
	{1360, 2227, "ReadBook_1360"}, -- 阿萨辛套书
	{1361, 2228, "ReadBook_1361"},
	{1362, 2229, "ReadBook_1362"},
	{1363, 2230, "ReadBook_1363"},
	{1364, 2231, "ReadBook_1364"},
	{1368, 2233, "ReadBook_1368"}, -- 沙利亚套书
	{1369, 2234, "ReadBook_1369"},
	{1370, 2235, "ReadBook_1370"},
	{1371, 2236, "ReadBook_1371"},
	{1376, 2238, "ReadBook_1376"}, -- 慕容夫人套书
	{1377, 2239, "ReadBook_1377"},
	{1378, 2240, "ReadBook_1378"},
	{1379, 2241, "ReadBook_1379"},
	{1384, 2243, "ReadBook_1384"}, -- 乌蒙贵之标本作品集
	{1385, 2244, "ReadBook_1385"},
	{1386, 2245, "ReadBook_1386"},
	{1387, 2246, "ReadBook_1387"},
	{1392, 2248, "ReadBook_1392"},	-- 辽东第一擂
	{1393, 2249, "ReadBook_1393"},
	{1394, 2250, "ReadBook_1394"},
	{1395, 2251, "ReadBook_1395"},
	{1400, 2253, "ReadBook_1400"}, -- 龙渊第2擂·杂贺三忍
	{1401, 2254, "ReadBook_1401"},
	{1402, 2255, "ReadBook_1402"},
	{1403, 2256, "ReadBook_1403"},
	{1408, 2258, "ReadBook_1408"}, -- 龙渊第3擂·风魔兄弟
	{1409, 2259, "ReadBook_1409"},
	{1410, 2260, "ReadBook_1410"},
	{1411, 2261, "ReadBook_1411"},
	{1416, 2263, "ReadBook_1416"}, -- 龙渊第4擂·南诏双雄
	{1417, 2264, "ReadBook_1417"},
	{1418, 2265, "ReadBook_1418"},
	{1419, 2266, "ReadBook_1419"},
	{1424, 2268, "ReadBook_1424"}, -- 龙渊第5擂
	{1425, 2269, "ReadBook_1425"},
	{1426, 2270, "ReadBook_1426"},
	{1427, 2271, "ReadBook_1427"},
	{1432, 2606, "ReadBook_1432"}, -- 把酒问月
	{1433, 2607, "ReadBook_1433"}, -- 饮中八仙歌
	{1434, 2608, "ReadBook_1434"}, -- 貂蝉拜月
	{1435, 2609, "ReadBook_1435"}, -- 中秋燃灯
	{1488, 3809, "ReadBook_1488"}, -- 四书五经小札·卷一
	{1489, 3810, "ReadBook_1489"},
	{1490, 3811, "ReadBook_1490"},
	{1491, 3812, "ReadBook_1491"},
	{1492, 3813, "ReadBook_1492"},
	{1493, 3814, "ReadBook_1493"},
	{1494, 3815, "ReadBook_1494"},
	{1495, 3816, "ReadBook_1495"},
	{1496, 3817, "ReadBook_1496"}, -- 四书五经小札·卷二
	{1497, 3818, "ReadBook_1497"},
	{1498, 3819, "ReadBook_1498"},
	{1499, 3820, "ReadBook_1499"},
	{1500, 3821, "ReadBook_1500"},
	{1501, 3822, "ReadBook_1501"},
	{1502, 3823, "ReadBook_1502"},
	{1688, 4189, "ReadBook_1688"}, -- 有情世界
	{1689, 4190, "ReadBook_1689"}, -- 剑的心
	{1690, 4191, "ReadBook_1690"}, -- 阳宝哥小传
	{1691, 4192, "ReadBook_1691"}, -- 鸦碎碎念
	{1692, 4193, "ReadBook_1692"}, -- 珞山传
	{1693, 4194, "ReadBook_1693"}, -- 乐冬传
	{1694, 4195, "ReadBook_1694"}, -- 香菜菜传
	{1695, 4196, "ReadBook_1695"}, -- 星空随笔
	{2488, 7073, "ReadBook_2488"}, --鲲鹏岛碑铭
	{2489, 7074, "ReadBook_2489"}, --鲲鹏岛碑铭
	{2490, 7075, "ReadBook_2490"}, --鲲鹏岛碑铭
	{2491, 7076, "ReadBook_2491"}, --鲲鹏岛碑铭
	{2492, 7077, "ReadBook_2492"}, --鲲鹏岛碑铭
	{2493, 7078, "ReadBook_2493"}, --鲲鹏岛碑铭
	{2494, 7079, "ReadBook_2494"}, --鲲鹏岛碑铭
	{2496, 7080, "ReadBook_2496"}, --鲲鹏岛碑铭
	{2497, 7081, "ReadBook_2497"}, --鲲鹏岛碑铭
	{2498, 7082, "ReadBook_2498"}, --鲲鹏岛碑铭
	{2499, 7083, "ReadBook_2499"}, --鲲鹏岛碑铭
	{2500, 7084, "ReadBook_2500"}, --鲲鹏岛碑铭
	{2501, 7085, "ReadBook_2501"}, --鲲鹏岛碑铭
	{2514, 7257, "ReadBook_2514"}, --蔷薇列岛碑铭
	{1504, 8004, "ReadBook_1504"},
	{1505, 8005, "ReadBook_1505"},
	{1506, 8006, "ReadBook_1506"},
	{1507, 8007, "ReadBook_1507"},
	{1508, 8008, "ReadBook_1508"},
	{1509, 8009, "ReadBook_1509"},
	{1512, 8010, "ReadBook_1512"},
	{1513, 8011, "ReadBook_1513"},
	{1514, 8012, "ReadBook_1514"},
	{1515, 8013, "ReadBook_1515"},
	{1516, 8014, "ReadBook_1516"},
	{1517, 8015, "ReadBook_1517"},
	{1518, 8016, "ReadBook_1518"},
	{1519, 8017, "ReadBook_1519"},
	{1520, 8018, "ReadBook_1520"},
	{1521, 8019, "ReadBook_1521"},
	{1522, 8020, "ReadBook_1522"},
	{1523, 8021, "ReadBook_1523"},
	{1528, 8022, "ReadBook_1528"},
	{1529, 8023, "ReadBook_1529"},
	{1530, 8024, "ReadBook_1530"},
	{1531, 8025, "ReadBook_1531"},
	{1532, 8026, "ReadBook_1532"},
	{1533, 8027, "ReadBook_1533"},
	{1534, 8028, "ReadBook_1534"},
	{1535, 8029, "ReadBook_1535"},
	{1536, 8030, "ReadBook_1536"},
	{1537, 8031, "ReadBook_1537"},
	{1538, 8032, "ReadBook_1538"},
	{1539, 8033, "ReadBook_1539"},
	{1540, 8034, "ReadBook_1540"},
	{1541, 8035, "ReadBook_1541"},
	{1544, 8036, "ReadBook_1544"},
	{1545, 8037, "ReadBook_1545"},
	{1546, 8038, "ReadBook_1546"},
	{1547, 8039, "ReadBook_1547"},
	{1548, 8040, "ReadBook_1548"},
	{1549, 8041, "ReadBook_1549"},
	{1550, 8042, "ReadBook_1550"},
	{1551, 8043, "ReadBook_1551"},
	{1552, 8044, "ReadBook_1552"},
	{1553, 8045, "ReadBook_1553"},
	{1554,8046,"ReadBook_1554"},
	{1555,8047,"ReadBook_1555"},
	{1556,8048,"ReadBook_1556"},
	{1576,8049,"ReadBook_1576"},
	{1577,8050,"ReadBook_1577"},
	{1578,8051,"ReadBook_1578"},
	{1579,8052,"ReadBook_1579"},
	{1580,8053,"ReadBook_1580"},
	{1581,8054,"ReadBook_1581"},
	{1582,8055,"ReadBook_1582"},
	{1583,8056,"ReadBook_1583"},
	{1584,8057,"ReadBook_1584"},
	{1585,8058,"ReadBook_1585"},
	{1586,8059,"ReadBook_1586"},
	{1587,8060,"ReadBook_1587"},
	{1588,8061,"ReadBook_1588"},
	{1589,8062,"ReadBook_1589"},
	{1590,8063,"ReadBook_1590"},
	{1591,8064,"ReadBook_1591"},
	{1592,8065,"ReadBook_1592"},
	{1593,8066,"ReadBook_1593"},
	{1594,8067,"ReadBook_1594"},
	{1595,8068,"ReadBook_1595"},
	{1596,8069,"ReadBook_1596"},
	{1597,8070,"ReadBook_1597"},
	{1598,8071,"ReadBook_1598"},
	{1599,8072,"ReadBook_1599"},
	{1608,8073,"ReadBook_1608"},
	{1609,8074,"ReadBook_1609"},
	{1610,8075,"ReadBook_1610"},
	{1611,8076,"ReadBook_1611"},
	{1624,8077,"ReadBook_1624"},
	{1625,8078,"ReadBook_1625"},
	{1626,8079,"ReadBook_1626"},
	{1627,8080,"ReadBook_1627"},
	{1628,8081,"ReadBook_1628"},
	{1629,8082,"ReadBook_1629"},
	{1632,8083,"ReadBook_1632"},
	{1633,8084,"ReadBook_1633"},
	{1634,8085,"ReadBook_1634"},
	{1635,8086,"ReadBook_1635"},
	{1640,8087,"ReadBook_1640"},
	{1641,8088,"ReadBook_1641"},
	{1642,8089,"ReadBook_1642"},
	{1643,8090,"ReadBook_1643"},
	{1648,8091,"ReadBook_1648"},
	{1649,8092,"ReadBook_1649"},
	{1650,8093,"ReadBook_1650"},
	{1651,8094,"ReadBook_1651"},
	{1656,8095,"ReadBook_1656"},
	{1657,8096,"ReadBook_1657"},
	{1658,8097,"ReadBook_1658"},
	{1659,8098,"ReadBook_1659"},
	{1664,8099,"ReadBook_1664"},
	{1665,8100,"ReadBook_1665"},
	{1666,8101,"ReadBook_1666"},
	{1667,8102,"ReadBook_1667"},
	{1672,8103,"ReadBook_1672"},
	{1673,8104,"ReadBook_1673"},
	{1674,8105,"ReadBook_1674"},
	{1675,8106,"ReadBook_1675"},
	{1680,8107,"ReadBook_1680"},
	{1681,8108,"ReadBook_1681"},
	{1682,8109,"ReadBook_1682"},
	{1683,8110,"ReadBook_1683"},
	{1696,8119,"ReadBook_1696"},
	{1697,8120,"ReadBook_1697"},
	{1698,8121,"ReadBook_1698"},
	{1699,8122,"ReadBook_1699"},
	{1700,8123,"ReadBook_1700"},
	{1701,8124,"ReadBook_1701"},
	{1702,8125,"ReadBook_1702"},
	{1703,8126,"ReadBook_1703"},
	{1704,8127,"ReadBook_1704"},
	{1705,8128,"ReadBook_1705"},
	{1706,8129,"ReadBook_1706"},
	{1707,8130,"ReadBook_1707"},
	{1708,8131,"ReadBook_1708"},
	{1709,8132,"ReadBook_1709"},
	{1710,8133,"ReadBook_1710"},
	{1711,8134,"ReadBook_1711"},
	{1712,8135,"ReadBook_1712"},
	{1713,8136,"ReadBook_1713"},
	{1714,8137,"ReadBook_1714"},
	{1715,8138,"ReadBook_1715"},
	{1716,8139,"ReadBook_1716"},
	{1717,8140,"ReadBook_1717"},
	{1718,8141,"ReadBook_1718"},
	{1719,8142,"ReadBook_1719"},
	{1720,8143,"ReadBook_1720"},
	{1721,8144,"ReadBook_1721"},
	{1722,8145,"ReadBook_1722"},
	{1723,8146,"ReadBook_1723"},
	{1724,8147,"ReadBook_1724"},
	{1725,8148,"ReadBook_1725"},
	{1726,8149,"ReadBook_1726"},
	{1727,8150,"ReadBook_1727"},
	{1736,8151,"ReadBook_1736"},
	{1737,8152,"ReadBook_1737"},
	{1738,8153,"ReadBook_1738"},
	{1739,8154,"ReadBook_1739"},
	{1740,8155,"ReadBook_1740"},
	{1760,8156,"ReadBook_1760"},
	{1761,8157,"ReadBook_1761"},
	{1762,8158,"ReadBook_1762"},
	{1763,8159,"ReadBook_1763"},
	{1764,8160,"ReadBook_1764"},
	{1765,8161,"ReadBook_1765"},
	{1766,8162,"ReadBook_1766"},
	{1767,8163,"ReadBook_1767"},
	{1768,8164,"ReadBook_1768"},
	{1769,8165,"ReadBook_1769"},
	{1770,8166,"ReadBook_1770"},
	{1771,8167,"ReadBook_1771"},
	{1772,8168,"ReadBook_1772"},
	{1773,8169,"ReadBook_1773"},
	{1774,8170,"ReadBook_1774"},
	{1775,8171,"ReadBook_1775"},
	{1776,8172,"ReadBook_1776"},
	{1777,8173,"ReadBook_1777"},
	{1778,8174,"ReadBook_1778"},
	{1779,8175,"ReadBook_1779"},
	{1780,8176,"ReadBook_1780"},
	{1781,8177,"ReadBook_1781"},
	{1782,8178,"ReadBook_1782"},
	{1783,8179,"ReadBook_1783"},
	{1784,8180,"ReadBook_1784"},
	{1785,8181,"ReadBook_1785"},
	{1786,8182,"ReadBook_1786"},
	{1787,8183,"ReadBook_1787"},
	{1788,8184,"ReadBook_1788"},
	{1789,8185,"ReadBook_1789"},
	{1790,8186,"ReadBook_1790"},
	{1791,8187,"ReadBook_1791"},
	{1792,8188,"ReadBook_1792"},
	{1793,8189,"ReadBook_1793"},
	{1794,8190,"ReadBook_1794"},
	{1795,8191,"ReadBook_1795"},
	{1796,8192,"ReadBook_1796"},
	{1797,8193,"ReadBook_1797"},
	{1798,8194,"ReadBook_1798"},
	{1799,8195,"ReadBook_1799"},
	{1800,8196,"ReadBook_1800"},
	{1801,8197,"ReadBook_1801"},
	{1802,8198,"ReadBook_1802"},
	{1803,8199,"ReadBook_1803"},
	{1804,8200,"ReadBook_1804"},
	{1805,8201,"ReadBook_1805"},
	{1806,8202,"ReadBook_1806"},
	{1807,8203,"ReadBook_1807"},
	{1808,8204,"ReadBook_1808"},
	{1809,8205,"ReadBook_1809"},
	{1810,8206,"ReadBook_1810"},
	{1811,8207,"ReadBook_1811"},
	{1812,8208,"ReadBook_1812"},
	{1813,8209,"ReadBook_1813"},
	{1814,8210,"ReadBook_1814"},
	{1816,8211,"ReadBook_1816"},
	{1817,8212,"ReadBook_1817"},
	{1818,8213,"ReadBook_1818"},
	{1819,8214,"ReadBook_1819"},
	{1820,8215,"ReadBook_1820"},
	{1821,8216,"ReadBook_1821"},
	{1822,8217,"ReadBook_1822"},
	{1823,8218,"ReadBook_1823"},
	{1824,8219,"ReadBook_1824"},
	{1825,8220,"ReadBook_1825"},
	{1826,8221,"ReadBook_1826"},
	{1827,8222,"ReadBook_1827"},
	{1828,8223,"ReadBook_1828"},
	{1829,8224,"ReadBook_1829"},
	{1830,8225,"ReadBook_1830"},
	{1831,8226,"ReadBook_1831"},
	{1832,8227,"ReadBook_1832"},
	{1833,8228,"ReadBook_1833"},
	{1834,8229,"ReadBook_1834"},
	{1835,8230,"ReadBook_1835"},
	{1836,8231,"ReadBook_1836"},
	{1837,8232,"ReadBook_1837"},
	{1838,8233,"ReadBook_1838"},
	{1839,8234,"ReadBook_1839"},
	{1840,8235,"ReadBook_1840"},
	{1841,8236,"ReadBook_1841"},
	{1842,8237,"ReadBook_1842"},
	{1843,8238,"ReadBook_1843"},
	{1844,8239,"ReadBook_1844"},
	{1845,8240,"ReadBook_1845"},
	{1846,8241,"ReadBook_1846"},
	{1847,8242,"ReadBook_1847"},
	{1848,8243,"ReadBook_1848"},
	{1849,8244,"ReadBook_1849"},
	{1850,8245,"ReadBook_1850"},
	{1851,8246,"ReadBook_1851"},
	{1852,8247,"ReadBook_1852"},
	{1853,8248,"ReadBook_1853"},
	{1854,8249,"ReadBook_1854"},
	{1855,8250,"ReadBook_1855"},
	{1856,8251,"ReadBook_1856"},
	{1857,8252,"ReadBook_1857"},
	{1858,8253,"ReadBook_1858"},
	{1859,8254,"ReadBook_1859"},
	{1860,8255,"ReadBook_1860"},
	{1861,8256,"ReadBook_1861"},
	{1862,8257,"ReadBook_1862"},
	{1863,8258,"ReadBook_1863"},
	{1864,8259,"ReadBook_1864"},
	{1865,8260,"ReadBook_1865"},
	{1866,8261,"ReadBook_1866"},
	{1867,8262,"ReadBook_1867"},
	{1868,8263,"ReadBook_1868"},
	{1869,8264,"ReadBook_1869"},
	{1870,8265,"ReadBook_1870"},
	{1871,8266,"ReadBook_1871"},
	{1872,8267,"ReadBook_1872"},
	{1873,8268,"ReadBook_1873"},
	{1874,8269,"ReadBook_1874"},
	{1875,8270,"ReadBook_1875"},
	{1876,8271,"ReadBook_1876"},
	{1877,8272,"ReadBook_1877"},
	{1878,8273,"ReadBook_1878"},
	{1879,8274,"ReadBook_1879"},
	{1880,8275,"ReadBook_1880"},
	{1881,8276,"ReadBook_1881"},
	{1882,8277,"ReadBook_1882"},
	{1883,8278,"ReadBook_1883"},
	{1884,8279,"ReadBook_1884"},
	{1885,8280,"ReadBook_1885"},
	{1886,8281,"ReadBook_1886"},
	{1887,8282,"ReadBook_1887"},
	{1888,8283,"ReadBook_1888"},
	{1889,8284,"ReadBook_1889"},
	{1890,8285,"ReadBook_1890"},
	{1891,8286,"ReadBook_1891"},
	{1892,8287,"ReadBook_1892"},
	{1893,8288,"ReadBook_1893"},
	{1894,8289,"ReadBook_1894"},
	{1895,8290,"ReadBook_1895"},
	{1896,8291,"ReadBook_1896"},
	{1897,8292,"ReadBook_1897"},
	{1898,8293,"ReadBook_1898"},
	{1899,8294,"ReadBook_1899"},
	{1900,8295,"ReadBook_1900"},
	{1901,8296,"ReadBook_1901"},
	{1902,8297,"ReadBook_1902"},
	{1903,8298,"ReadBook_1903"},
	{1904,8299,"ReadBook_1904"},
	{1905,8300,"ReadBook_1905"},
	{1906,8301,"ReadBook_1906"},
	{1907,8302,"ReadBook_1907"},
	{1908,8303,"ReadBook_1908"},
	{1909,8304,"ReadBook_1909"},
	{1910,8305,"ReadBook_1910"},
	{1911,8306,"ReadBook_1911"},
	{1912,8307,"ReadBook_1912"},
	{1913,8308,"ReadBook_1913"},
	{1914,8309,"ReadBook_1914"},
	{1915,8310,"ReadBook_1915"},
	{1916,8311,"ReadBook_1916"},
	{1917,8312,"ReadBook_1917"},
	{1918,8313,"ReadBook_1918"},
	{1919,8314,"ReadBook_1919"},
	{1920,8315,"ReadBook_1920"},
	{1921,8316,"ReadBook_1921"},
	{1922,8317,"ReadBook_1922"},
	{1923,8318,"ReadBook_1923"},
	{1924,8319,"ReadBook_1924"},
	{1925,8320,"ReadBook_1925"},
	{1928,8321,"ReadBook_1928"},
	{1929,8322,"ReadBook_1929"},
	{1930,8323,"ReadBook_1930"},
	{1931,8324,"ReadBook_1931"},
	{1932,8325,"ReadBook_1932"},
	{1933,8326,"ReadBook_1933"},
	{1934,8327,"ReadBook_1934"},
	{1935,8328,"ReadBook_1935"},
	{1936,8329,"ReadBook_1936"},
	{1937,8330,"ReadBook_1937"},
	{1938,8331,"ReadBook_1938"},
	{1939,8332,"ReadBook_1939"},
	{1940,8333,"ReadBook_1940"},
	{1941,8334,"ReadBook_1941"},
	{1942,8335,"ReadBook_1942"},
	{1944,8336,"ReadBook_1944"},
	{1945,8337,"ReadBook_1945"},
	{1946,8338,"ReadBook_1946"},
	{1947,8339,"ReadBook_1947"},
	{1948,8340,"ReadBook_1948"},
	{1949,8341,"ReadBook_1949"},
	{1950,8342,"ReadBook_1950"},
	{1951,8343,"ReadBook_1951"},
	{1952,8344,"ReadBook_1952"},
	{1953,8345,"ReadBook_1953"},
	{1954,8346,"ReadBook_1954"},
	{1955,8347,"ReadBook_1955"},
	{1956,8348,"ReadBook_1956"},
	{1957,8349,"ReadBook_1957"},
	{1958,8350,"ReadBook_1958"},
	{1959,8351,"ReadBook_1959"},
	{1976,8352,"ReadBook_1976"},
	{1977,8353,"ReadBook_1977"},
	{1978,8354,"ReadBook_1978"},
	{1979,8355,"ReadBook_1979"},
	{1980,8356,"ReadBook_1980"},
	{1981,8357,"ReadBook_1981"},
	{1982,8358,"ReadBook_1982"},
	{1983,8359,"ReadBook_1983"},
	{1984,8360,"ReadBook_1984"},
	{1985,8361,"ReadBook_1985"},
	{1986,8362,"ReadBook_1986"},
	{1987,8363,"ReadBook_1987"},
	{1988,8364,"ReadBook_1988"},
	{1989,8365,"ReadBook_1989"},
	{1990,8366,"ReadBook_1990"},
	{1991,8367,"ReadBook_1991"},
	{1992,8368,"ReadBook_1992"},
	{1993,8369,"ReadBook_1993"},
	{1994,8370,"ReadBook_1994"},
	{1995,8371,"ReadBook_1995"},
	{1996,8372,"ReadBook_1996"},
	{1997,8373,"ReadBook_1997"},
	{1998,8374,"ReadBook_1998"},
	{1999,8375,"ReadBook_1999"},
	{2000,8376,"ReadBook_2000"},
	{2001,8377,"ReadBook_2001"},
	{2002,8378,"ReadBook_2002"},
	{2003,8379,"ReadBook_2003"},
	{2004,8380,"ReadBook_2004"},
	{2005,8381,"ReadBook_2005"},
	{2006,8382,"ReadBook_2006"},
	{2007,8383,"ReadBook_2007"},
	{2008,8384,"ReadBook_2008"},
	{2009,8385,"ReadBook_2009"},
	{2010,8386,"ReadBook_2010"},
	{2016,8387,"ReadBook_2016"},
	{2017,8388,"ReadBook_2017"},
	{2018,8389,"ReadBook_2018"},
	{2019,8390,"ReadBook_2019"},
	{2020,8391,"ReadBook_2020"},
	{2021,8392,"ReadBook_2021"},
	{2022,8393,"ReadBook_2022"},
	{2023,8394,"ReadBook_2023"},
	{2024,8395,"ReadBook_2024"},
	{2025,8396,"ReadBook_2025"},
	{2026,8397,"ReadBook_2026"},
	{2027,8398,"ReadBook_2027"},
	{2028,8399,"ReadBook_2028"},
	{2029,8400,"ReadBook_2029"},
	{2030,8401,"ReadBook_2030"},
	{2031,8402,"ReadBook_2031"},
	{2056,8421,"ReadBook_2056"},
	{2057,8422,"ReadBook_2057"},
	{2058,8423,"ReadBook_2058"},
	{2059,8424,"ReadBook_2059"},
	{2060,8425,"ReadBook_2060"},
	{2061,8426,"ReadBook_2061"},
	{2062,8427,"ReadBook_2062"},
	{2063,8428,"ReadBook_2063"},
	{2064,8429,"ReadBook_2064"},
	{2065,8430,"ReadBook_2065"},
	{2066,8431,"ReadBook_2066"},
	{2067,8432,"ReadBook_2067"},
	{2068,8433,"ReadBook_2068"},
	{2080,8434,"ReadBook_2080"},
	{2081,8435,"ReadBook_2081"},
	{2082,8436,"ReadBook_2082"},
	{2083,8437,"ReadBook_2083"},
	{2088,8438,"ReadBook_2088"},
	{2089,8439,"ReadBook_2089"},
	{2090,8440,"ReadBook_2090"},
	{2091,8441,"ReadBook_2091"},
	{2092,8442,"ReadBook_2092"},
	{2093,8443,"ReadBook_2093"},
	{2096,8444,"ReadBook_2096"},
	{2097,8445,"ReadBook_2097"},
	{2098,8446,"ReadBook_2098"},
	{2099,8447,"ReadBook_2099"},
	{2104,8448,"ReadBook_2104"},
	{2105,8449,"ReadBook_2105"},
	{2106,8450,"ReadBook_2106"},
	{2107,8451,"ReadBook_2107"},
	{2108,8452,"ReadBook_2108"},
	{2112,8453,"ReadBook_2112"},
	{2113,8454,"ReadBook_2113"},
	{2114,8455,"ReadBook_2114"},
	{2115,8456,"ReadBook_2115"},
	{2120,8457,"ReadBook_2120"},
	{2121,8458,"ReadBook_2121"},
	{2122,8459,"ReadBook_2122"},
	{1960,8243,"ReadBook_1960"},
	{1961,8244,"ReadBook_1961"},
	{1962,8245,"ReadBook_1962"},
	{1963,8246,"ReadBook_1963"},
	{1964,8247,"ReadBook_1964"},
	{1965,8248,"ReadBook_1965"},
	{1966,8249,"ReadBook_1966"},
	{1967,8250,"ReadBook_1967"},
	{1968,8251,"ReadBook_1968"},
	{1969,8252,"ReadBook_1969"},
	{1970,8253,"ReadBook_1970"},
	{1971,8254,"ReadBook_1971"},
	{1972,8255,"ReadBook_1972"},
	{1973,8256,"ReadBook_1973"},
	{1974,8257,"ReadBook_1974"},
	{1975,8258,"ReadBook_1975"},
	{2304,8861,"ReadBook_2304"},
	{2305,8862,"ReadBook_2305"},
	{2306,8863,"ReadBook_2306"},
	{2307,8864,"ReadBook_2307"},
	{2308,8865,"ReadBook_2308"},
	{2309,8866,"ReadBook_2309"},
	{2310,8867,"ReadBook_2310"},
	{2311,8868,"ReadBook_2311"},
	{2312,8869,"ReadBook_2312"},
	{2313,8870,"ReadBook_2313"},
	{2314,8871,"ReadBook_2314"},
	{2315,8872,"ReadBook_2315"},
	{2316,8873,"ReadBook_2316"},
	{2317,8874,"ReadBook_2317"},
	{2318,8875,"ReadBook_2318"},
	{2319,8876,"ReadBook_2319"},
	{2320,8877,"ReadBook_2320"},
	{2321,8878,"ReadBook_2321"},
	{2322,8879,"ReadBook_2322"},
	{2323,8880,"ReadBook_2323"},
	{2324,8881,"ReadBook_2324"},
	{2325,8882,"ReadBook_2325"},
	{2326,8883,"ReadBook_2326"},
	{2327,8884,"ReadBook_2327"},
	{2328,8885,"ReadBook_2328"},
	{2329,8886,"ReadBook_2329"},
	{2330,8887,"ReadBook_2330"},
	{2331,8888,"ReadBook_2331"},
	{2332,8889,"ReadBook_2332"},
	{2333,8890,"ReadBook_2333"},
	{2334,8891,"ReadBook_2334"},
	{2335,8892,"ReadBook_2335"},
	{2336,8893,"ReadBook_2336"},
	{2337,8894,"ReadBook_2337"},
	{2338,8895,"ReadBook_2338"},
	{2339,8896,"ReadBook_2339"},
	{2340,8897,"ReadBook_2340"},
	{2341,8898,"ReadBook_2341"},
	{2342,8899,"ReadBook_2342"},
	{2343,8900,"ReadBook_2343"},
	{2400,8901,"ReadBook_2400"},
	{2401,8902,"ReadBook_2401"},
	{2402,8903,"ReadBook_2402"},
	{2403,8904,"ReadBook_2403"},
	{2404,8905,"ReadBook_2404"},
	{2408,8906,"ReadBook_2408"},
	{2409,8907,"ReadBook_2409"},
	{2410,8908,"ReadBook_2410"},
	{2411,8909,"ReadBook_2411"},
	{2412,8910,"ReadBook_2412"},
	{2440,8911,"ReadBook_2440"},
	{2441,8912,"ReadBook_2441"},
	{2442,8913,"ReadBook_2442"},
	{2443,8914,"ReadBook_2443"},
	{2444,8915,"ReadBook_2444"},
	{2445,8916,"ReadBook_2445"},
	{2446,8917,"ReadBook_2446"},
	{2447,8918,"ReadBook_2447"},
	{2456,8919,"ReadBook_2456"},
	{2457,8920,"ReadBook_2457"},
	{2458,8921,"ReadBook_2458"},
	{2459,8922,"ReadBook_2459"},
	{2460,8923,"ReadBook_2460"},
	{2416,8924,"ReadBook_2416"},
	{2417,8925,"ReadBook_2417"},
	{2418,8926,"ReadBook_2418"},
	{2419,8927,"ReadBook_2419"},
	{2420,8928,"ReadBook_2420"},
	{2421,8929,"ReadBook_2421"},
	{2424,8930,"ReadBook_2424"},
	{2425,8931,"ReadBook_2425"},
	{2426,8932,"ReadBook_2426"},
	{2427,8933,"ReadBook_2427"},
	{2428,8934,"ReadBook_2428"},
	{2429,8935,"ReadBook_2429"},
	{2512,8936,"ReadBook_2512"},
	{2513,8937,"ReadBook_2513"},
--{2514,8938,"ReadBook_2514"},
	{2515,8939,"ReadBook_2515"},
	{2516,8940,"ReadBook_2516"},
	{2517,8941,"ReadBook_2517"},
	{2736,8943,"ReadBook_2736"},
	{2737,8944,"ReadBook_2737"},
	{2738,8945,"ReadBook_2738"},
	{2739,8946,"ReadBook_2739"},
	{2740,8947,"ReadBook_2740"},
	{2608,8948,"ReadBook_2608"},
	{2609,8949,"ReadBook_2609"},
	{2610,8950,"ReadBook_2610"},
	{2611,8951,"ReadBook_2611"},
	{2612,8952,"ReadBook_2612"},
	{2664,8953,"ReadBook_2664"},
	{2665,8954,"ReadBook_2665"},
	{2666,8955,"ReadBook_2666"},
	{2667,8956,"ReadBook_2667"},
	{2668,8957,"ReadBook_2668"},
	{2669,8958,"ReadBook_2669"},
	{2670,8959,"ReadBook_2670"},
	{2671,8960,"ReadBook_2671"},
	{2624,8961,"ReadBook_2624"},
	{2625,8962,"ReadBook_2625"},
	{2626,8963,"ReadBook_2626"},
	{2627,8964,"ReadBook_2627"},
	{2628,8965,"ReadBook_2628"},
	{2629,8966,"ReadBook_2629"},
	{2632,8967,"ReadBook_2632"},
	{2633,8968,"ReadBook_2633"},
	{2634,8969,"ReadBook_2634"},
	{2635,8970,"ReadBook_2635"},
	{2636,8971,"ReadBook_2636"},
	{2637,8972,"ReadBook_2637"},
	{2638,8973,"ReadBook_2638"},
	{2639,8974,"ReadBook_2639"},
	{2640,8975,"ReadBook_2640"},
	{2641,8976,"ReadBook_2641"},
	{2642,8977,"ReadBook_2642"},
	{2643,8978,"ReadBook_2643"},
	{2644,8979,"ReadBook_2644"},
	{2645,8980,"ReadBook_2645"},
	{2646,8981,"ReadBook_2646"},
	{2647,8982,"ReadBook_2647"},
	{2648,8983,"ReadBook_2648"},
	{2649,8984,"ReadBook_2649"},
	{2650,8985,"ReadBook_2650"},
	{2651,8986,"ReadBook_2651"},
	{2652,8987,"ReadBook_2652"},
	{2675,9042,"ReadBook_2675"},
	{2673,9043,"ReadBook_2673"},
	{2674,9044,"ReadBook_2674"},
	{2672, 9045, "ReadBook_2672"},
	-- 横刀断浪版本补奉天证道阅读成就 start
	--{2688, 10511, "ReadBook_2688"},
	--{2689, 10512, "ReadBook_2689"},
	--{2690, 10513, "ReadBook_2690"},
	--{2691, 10514, "ReadBook_2691"},
	--{2744, 10538, "ReadBook_2744"},
	--{2745, 10539, "ReadBook_2745"},
	--{2746, 10540, "ReadBook_2746"},
	--{2720, 10542, "ReadBook_2720"},
	--{2721, 10543, "ReadBook_2721"},
	--{2722, 10544, "ReadBook_2722"},
	--{2723, 10545, "ReadBook_2723"},
	--{2724, 10546, "ReadBook_2724"},
	--{2704, 10559, "ReadBook_2704"},
	--{2705, 10560, "ReadBook_2705"},
	--{2706, 10561, "ReadBook_2706"},
	--{2707, 10562, "ReadBook_2707"},
	--{2708, 10563, "ReadBook_2708"},
	--{2725, 10682, "ReadBook_2725"},
	--{2726, 10683, "ReadBook_2726"},
	--{2727, 10684, "ReadBook_2727"},
	--{2747, 10685, "ReadBook_2747"},
	--{2748, 10686, "ReadBook_2748"},
	--{2776, 10687, "ReadBook_2776"},
	--{2777, 10688, "ReadBook_2777"},
	--{2778, 10689, "ReadBook_2778"},
	--{2779, 10690, "ReadBook_2779"},
	--{2780, 10691, "ReadBook_2780"},
	--{2800, 10693, "ReadBook_2800"},
	--{2801, 10694, "ReadBook_2801"},
	--{2802, 10695, "ReadBook_2802"},
	--{2803, 10696, "ReadBook_2803"},
	--{2804, 10697, "ReadBook_2804"},
	--{2805, 10698, "ReadBook_2805"},
	--{2808, 10700, "ReadBook_2808"},
	--{2809, 10701, "ReadBook_2809"},
	--{2810, 10702, "ReadBook_2810"},
	--{2811, 10703, "ReadBook_2811"},
	--{2812, 10704, "ReadBook_2812"},
	--{2813, 10705, "ReadBook_2813"},
	--{2814, 10706, "ReadBook_2814"},
	--{2816, 10708, "ReadBook_2816"},
	--{2817, 10709, "ReadBook_2817"},
	--{2818, 10710, "ReadBook_2818"},
	--{2819, 10711, "ReadBook_2819"},
	--{2820, 10712, "ReadBook_2820"},
	--{2821, 10713, "ReadBook_2821"},
	--{2824, 10715, "ReadBook_2824"},
	--{2825, 10716, "ReadBook_2825"},
	--{2826, 10717, "ReadBook_2826"},
	--{2827, 10718, "ReadBook_2827"},
	--{2828, 10719, "ReadBook_2828"},
	--{2829, 10720, "ReadBook_2829"},
	-- 横刀断浪版本补奉天证道阅读成就 end
}

--------------挂件相关-----------------------
local ExtendRange = --小玩意，挂件、腰挂、面挂、眼镜
{
	{1, 730, "Extend_1"}, 
	{5, 731, "Extend_5"}, 
	{10, 732, "Extend_10"}, 
	{20, 733, "Extend_20"}, 
	{30, 1903, "Extend_30"}, 
	{50, 1904, "Extend_50"}, 
	{70, 1905, "Extend_70"}, 
	{80, 1906, "Extend_80"}, 
	{100, 1907, "Extend_100"},
	{150, 1908, "Extend_150"},
}

--------------修为相关-----------------------
local VenationTrain = 
{
	-- {nTrain, dwAchievementID, "KeyName"}, 		-- 修为值，成就ID，Key字符串名
	{5000, 99, "Venation_5000"}, -- 小周天
	{10000, 100, "Venation_10000"}, -- 大周天
	{20000, 101, "Venation_20000"}, -- 神功初成
	{50000, 102, "Venation_50000"}, -- 气聚丹田
	{98000, 103, "Venation_98000"}, -- 内息澎湃
}

--------------特效称号相关---------------
local tDesignation = {--请同步维护scripts/achievement/AchievementForClient.lua下的同名表，好恶心但是没程序接口判断！
	[1] = {--前缀和世界称号
		[81] = true, --名震天下
		[120] = true, --济世菩萨
		[122] = true, --天下无敌
		[168] = true, --老江湖
		[191]=true,--财大气粗
		[192]=true,--高富帅
		[193]=true,--白富美
		[266]=true,--红尘
		[300]=true,--侠客行
		[323]=true,--金影绝风
		[361]=true,--丹心
		[363]=true,--纵江湖
		[377]=true,--凌霄客
		[378]=true,--尽锋芒
		[379]=true,--血衣染
		[380]=true,--意风流
		[381]=true,--风华盈
		[382]=true,--幽梦引
		[383]=true,--日月行
		[384]=true,--夺命翎
		[385]=true,--烽火夜
		[386]=true,--渡众生
		[387]=true,--长相思
		[388]=true,--天涯客
		[389]=true,--战狂歌
		[422]=true,--一笑中
		[426]=true,--解千愁
		[451]=true,--焰莲隐客
		[452]=true,--夜昙帝华
		[459]=true,--光明无象
		[460]=true,--索魂雀翎
		[461]=true,--神弈国手
		[462]=true,--曼华隐锋
		[463]=true,--步引霜雷
		[464]=true,--妙音琼枝
		[465]=true,--乾坤无极
		[466]=true,--百战烽城
		[467]=true,--醉饮八方
		[468]=true,--妙法昙华
		[469]=true,--倾舞动霄
		[470]=true,--凌虚碎刃
		[471]=true,--迷仙蝶梦
		[472]=true,--业火战殇
		[473]=true,--天海仙风
		[488]=true,--一个人的江湖
		[490]=true,--喵呜
		[493]=true,--参星
		[505]=true,--紫宫绛河
		[506]=true,--北斗星曜
		[519]=true,--飞熊
		[520]=true,--凶虎
		[521]=true,--萌猫
		[522]=true,--汝有梦想乎
		[523]=true,--魅影
		[524]=true,--无惧
		[525]=true,--小飞熊
		[526]=true,--小凶虎
		[527]=true,--小萌猫
		[531]=true,--阔豪
		[535]=true,--无上正等正觉
		[539]=true,--无上正等正觉
		[540]=true,--无上正等正觉
		[541]=true,--鹤衣
		[542]=true,--鹿鸣
		[543]=true,--山涧
		[544]=true,--蜀天
		[545]=true,--刀灵
		[546]=true,--流照
		[547]=true,--焜煌
		[548]=true,--游龙
		[549]=true,--万象
		[550]=true,--鸿鲤
		[551]=true,--妙莲
		[552]=true,--海月
		[553]=true,--梦蝶
		[554]=true,--寒血
		[555]=true,--戎马
		[556]=true,--炎狱
		[583]=true,--灵蕊
		[587]=true,--知凝
		[588]=true,--游茵
		[610]=true,--彩凤吟
		[613]=true,--化羽
		[614]=true,--梵钟
		[615]=true,--顾兔
		[616]=true,--洒墨
		[617]=true,--啸傲
		[618]=true,--盈锋
		[619]=true,--惑梦
		[620]=true,--玄翎
		[621]=true,--翻江
		[622]=true,--圣烨
		[623]=true,--威灵
		[624]=true,--泽音
		[625]=true,--霆锐
		[626]=true,--渊洄
		[627]=true,--辞刃
		[628]=true,--移星
		[629]=true,--卷藏
		[637]=true,--月凝
		[645]=true,--画江湖
		[658] = true, --幽兰引芳
		[678] = true, --携游
		[682] = true, --踏云行
		[683] = true, --万法寂
		[684] = true, --凝光莹
		[685] = true, --不尽言
		[686] = true, --烨重霄
		[687] = true, --切玉刃
		[688] = true, --几魂梦
		[689] = true, --堕千劫
		[690] = true, --笑东风
		[691] = true, --经天月
		[692] = true, --渡征鸿
		[693] = true, --绝来音
		[694] = true, --曜无涯
		[695] = true, --玉华寒
		[696] = true, --行路难
		[697] = true, --步天歌
		[698] = true, --寄蘅芜
		[699] = true, --亘天渊
		[707] = true, --狂
		[710] = true, --引锐流虹
	},
	[2] = {--后缀
		[194]=true,--追梦人
		[251]=true,--傲岸
		[269]=true,--侠万里
		[280]=true,--踏浪
		[385]=true,--渐苏
		[417]=true,--商安
	}
}

--检查是否要更新20个金发的成就
function CheckYellowHairNum(player)
	if player.IsAchievementAcquired(10160) then
		return 0
	end
	local nTotalNum = 0
	for k, v in pairs(tYellowHair) do
		if player.IsHaveHair(HAIR_STYLE.HAIR, v) then
			nTotalNum = nTotalNum + 1
		end
	end
	if nTotalNum >= 20 then	--客户端先遍历一次，需要更新才去服务端验证
		RemoteCallToServer("OnClientAddAchievement", "NameCard_10160")
	end
	return nTotalNum
end

--检查是否要更新10个红发的成就
function CheckRedHairNum(player)
	if player.IsAchievementAcquired(10161) then
		return 0
	end
	local nTotalNum = 0
	for k, v in pairs(tRedHair) do
		if player.IsHaveHair(HAIR_STYLE.HAIR, v) then
			nTotalNum = nTotalNum + 1
		end
	end
	if nTotalNum >= 10 then	--客户端先遍历一次，满足条件才去服务端验证
		RemoteCallToServer("OnClientAddAchievement", "NameCard_10161")
	end
	return nTotalNum
end

local nNameCardConditionIndex = 0	--挂号排队检查吧，不然一下子全检查可能客户端卡
local CheckPlayerNameCardCondition = function(player)
	--0.披风数量20个
	if nNameCardConditionIndex == 0 then
		nNameCardConditionIndex = nNameCardConditionIndex + 1
		if not player.IsAchievementAcquired(9773) and player.GetPendentCount(KPENDENT_TYPE.BACKCLOAK) >= 20 then
			RemoteCallToServer("OnClientAddAchievement", "NameCard_9773")
		end
		----Log("nNameCardConditionIndex="..nNameCardConditionIndex..";BACKCLOAK="..player.GetPendentCount(KPENDENT_TYPE.BACKCLOAK))		
		--1.特效称号50个
	elseif nNameCardConditionIndex == 1 then
		nNameCardConditionIndex = nNameCardConditionIndex + 1
		local nSfxNum = 0
		if not player.IsAchievementAcquired(9774) then
			for kPre, _ in pairs(tDesignation[1]) do
				if player.IsDesignationPrefixAcquired(kPre) then
					nSfxNum = nSfxNum + 1
				end
			end
			for kPos, _ in pairs(tDesignation[2]) do
				if player.IsDesignationPostfixAcquired(kPos) then
					nSfxNum = nSfxNum + 1
				end
			end
			if nSfxNum >= 50 then
				RemoteCallToServer("OnClientAddAchievement", "NameCard_9774")
			end
		end
		--Log("nNameCardConditionIndex="..nNameCardConditionIndex..";Designation="..nSfxNum)
		--2.跟宠数量100个
	elseif nNameCardConditionIndex == 2 then
		nNameCardConditionIndex = nNameCardConditionIndex + 1
		if not player.IsAchievementAcquired(9775) and player.GetFellowPetCount() >= 100 then
			RemoteCallToServer("OnClientAddAchievement", "NameCard_9775")
		end
		--Log("nNameCardConditionIndex="..nNameCardConditionIndex..";FellowPetCount="..player.GetFellowPetCount())
		--3.奇趣坐骑数量60个
	elseif nNameCardConditionIndex == 3 then
		nNameCardConditionIndex = nNameCardConditionIndex + 1
		local nRareHorseNum = 0
		if not player.IsAchievementAcquired(9776) then
			local tRareHorseList = GetRareHorseInfoList()
			for i = 1, #tRareHorseList do
				if player.GetItem(tRareHorseList[i].dwBox, tRareHorseList[i].dwX) then
					nRareHorseNum = nRareHorseNum + 1
				end
			end
			if nRareHorseNum >= 60 then
				RemoteCallToServer("OnClientAddAchievement", "NameCard_9776")
			end			
		end
		--Log("nNameCardConditionIndex="..nNameCardConditionIndex..";RareHorse="..nRareHorseNum)
		--4.挂件800个
	elseif nNameCardConditionIndex == 4 then
		nNameCardConditionIndex = nNameCardConditionIndex + 1
		if not player.IsAchievementAcquired(9777) and (#player.GetAllWaistPendent(true) + #player.GetAllBackPendent(true)) >= 800 then
			RemoteCallToServer("OnClientAddAchievement", "NameCard_9777")
		end
		--Log("nNameCardConditionIndex="..nNameCardConditionIndex..";Pendent="..(#player.GetAllWaistPendent(true) + #player.GetAllBackPendent(true)))
		--5.冰雪逐梦三件套
	elseif nNameCardConditionIndex == 5 then
		nNameCardConditionIndex = nNameCardConditionIndex + 1
		local nCount = 0
		if not player.IsAchievementAcquired(10039) then
			if player.IsHaveExterior(9046) then
				nCount = nCount + 1
			end
			if player.IsHaveHair(HAIR_STYLE.HAIR, 1299) then
				nCount = nCount + 1
			end
			if player.IsPendentExist(25883) then
				nCount = nCount + 1
			end
			if nCount >= 3 then
				RemoteCallToServer("OnClientAddAchievement", "NameCard_10039")
				return
			end			
		end
		--Log("nNameCardConditionIndex="..nNameCardConditionIndex..";NameCard_10039="..nCount)
		--6.金发20个
	elseif nNameCardConditionIndex == 6 then
		nNameCardConditionIndex = nNameCardConditionIndex + 1
		CheckYellowHairNum(player)
		--Log("nNameCardConditionIndex="..nNameCardConditionIndex..";YellowHair="..CheckYellowHairNum(player))
		--7.红发10个
	elseif nNameCardConditionIndex == 7 then
		nNameCardConditionIndex = nNameCardConditionIndex + 1
		CheckRedHairNum(player)
		--Log("nNameCardConditionIndex="..nNameCardConditionIndex..";RedHair="..CheckRedHairNum(player))
		--8.声望钦佩100个转移到scripts/player/include/声望家将列表.lua处理
		--elseif nNameCardConditionIndex == 8 then
		--nNameCardConditionIndex = nNameCardConditionIndex + 1
	else
		nNameCardConditionIndex = 0	--轮询结束，从头开始
	end
end

local CheckReadBook = function(player, nStart, nEnd)
	if nStart > #aReadBook then
		return
	end
	if nEnd > #aReadBook then
		nEnd = #aReadBook
	end
	for k = nStart, nEnd do
		if not player.IsAchievementAcquired(aReadBook[k][2]) and player.IsBookMemorized(GlobelRecipeID2BookID(aReadBook[k][1])) then
			RemoteCallToServer("OnClientAddAchievement", aReadBook[k][3])
		end
	end
end

local nCheckBookNum = 1
local CheckReadBookStep = function(player)
	nCheckBookNum = nCheckBookNum or 1
	if nCheckBookNum > #aReadBook / 10 + 1 then
		nCheckBookNum = 1
	end
	CheckReadBook(player, nCheckBookNum * 10 - 9, nCheckBookNum * 10)
	nCheckBookNum = nCheckBookNum + 1
end

local nCheckReputationNum = 1
local CheckReputationLevel = function(player)
	nCheckReputationNum = nCheckReputationNum or 1
	if nCheckReputationNum > #ReputeRange / 15 + 1 then
		nCheckReputationNum = 1
	end
	CheckPlayerReputeLevelAch(player, ReputeRange, nCheckReputationNum * 15 - 14, nCheckReputationNum * 15)
	nCheckReputationNum = nCheckReputationNum + 1
end

----------------------检查玩家的装备品质------------------------------
tEquipQualityList =
{
	[EQUIPMENT_INVENTORY.MELEE_WEAPON] = true,
	[EQUIPMENT_INVENTORY.CHEST] = true,
	[EQUIPMENT_INVENTORY.HELM] = true,
	[EQUIPMENT_INVENTORY.PANTS] = true,
	[EQUIPMENT_INVENTORY.BOOTS] = true,
	[EQUIPMENT_INVENTORY.BANGLE] = true,
	[EQUIPMENT_INVENTORY.WAIST] = true,
}

function IsAllEquipQuality(player, nQuality)	--检查玩家的装备品质是否达到蓝绿紫品
	for k, v in pairs(tEquipQualityList) do
		local item = player.GetItem(INVENTORY_INDEX.EQUIP, k)
		if not item or item.nQuality ~= nQuality then
			return false
		end
	end
	return true
end
function IsAllEquipLevel(player, nLevel)	--检查玩家的装备品级是否都超过XX品
	for k, v in pairs(tEquipQualityList) do
		local item = player.GetItem(INVENTORY_INDEX.EQUIP, k)
		if not item or item.nQuality < 4 or item.nLevel < nLevel then
			return false
		end
	end
	return true
end
local CheckPlayerEquipQulityAchi = function(player)	--开始检查玩家的装备品级和品质
	if player.GetEquipIDArray(0) > 3 then --不是玩家的1~4套装不生效		
		return
	end
	if not player.IsAchievementAcquired(131) and IsAllEquipQuality(player, 3) then
		RemoteCallToServer("OnClientAddAchievement", "ItemQuality_3")
	end

	if not player.IsAchievementAcquired(132) and IsAllEquipQuality(player, 4) then
		RemoteCallToServer("OnClientAddAchievement", "ItemQuality_4")
	end

	if not player.IsAchievementAcquired(35) and IsAllEquipLevel(player, 120) then
		RemoteCallToServer("OnClientAddAchievement", "ItemQuality_120")
	end

	if not player.IsAchievementAcquired(90) and IsAllEquipLevel(player, 140) then
		RemoteCallToServer("OnClientAddAchievement", "ItemQuality_140")
	end

	if not player.IsAchievementAcquired(374) and IsAllEquipLevel(player, 160) then
		RemoteCallToServer("OnClientAddAchievement", "ItemQuality_160")
	end
end

local CheckPlayerEquipScoreAchi = function(player, nAttribute, RangeList)	--开始检查玩家的装备分数和成就
	if player.GetEquipIDArray(0) > 3 then --不是玩家的1~4套装不生效		
		return
	end
	for k, v in ipairs(RangeList) do
		if nAttribute >= v[1] then
			if not player.IsAchievementAcquired(v[2]) then
				RemoteCallToServer("OnClientAddAchievement", v[3])
			end
		else
			break
		end
	end
end

--------------做成函数表，分散负载-----------
local ActiveFunctionList =
{
	function(player) CheckPlayerAttributeAch(player, player.nLevel, LevelRange) end,
	function(player) CheckPlayerAttributeAch(player, player.GetMoney().nGold, MoneyRange) end,
	function(player) CheckPlayerAttributeAch(player, player.GetAcquiredDesignationCount(), DesignationRange) end,
	--CheckReputationLevel,
	function(player) CheckPlayerAttributeAch(player, player.nJustice, JusticeRange) end,
	function(player) CheckPlayerAttributeAch(player, player.nCurrentPrestige, PrestigeRange) end,
	function(player) CheckPlayerAttributeAch(player, #player.GetAllWaistPendent(true) + #player.GetAllBackPendent(true) + #player.GetAllFacePendent(true) + #player.GetAllPendent(KPENDENT_TYPE.GLASSES), ExtendRange) end,
	function(player) CheckPlayerNameCardCondition(player) end,
	function(player) CheckPlayerEquipScoreAchi(player, player.GetTotalEquipScore(), EquipScoreRange1) end, --装备三个成就组分隔开时段调用，太容易完成的系列成就不要放一起挨着
	CheckReadBookStep,
	function(player) CheckPlayerEquipScoreAchi(player, player.GetTotalEquipScore(), EquipScoreRange2) end,
	function(player) CheckPlayerAttributeAch(player, player.nCurrentTrainValue, VenationTrain) end,
	function(player) CheckPlayerEquipScoreAchi(player, player.GetTotalEquipScore(), EquipScoreRange3) end,
	function(player) CheckPlayerEquipQulityAchi(player) end,
}

--检查是否在我的地皮上
local nHomeCheckInterVal = 2	--每多少秒检查一次是否在自己的地皮上
local nOldLandIndex = -1--记录玩家在哪块地皮上，如果变化就像服务端通知。
local CheckPlayerHomeLand = function(player)	--检查是否在我家地皮上
	if player.GetMapID() == 565 then	--个人家园暂时屏蔽
		return
	end

	local _, nMapType = GetMapParams(player.GetMapID())
	if nMapType ~= MAP_TYPE.COMMUNITY then
		return
	end

	local nNowLandIndex = GetHomelandMgr().GetNowLandIndex()
	if nNowLandIndex ~= nOldLandIndex then
		RemoteCallToServer("On_Home_ChangeLand", nOldLandIndex, nNowLandIndex)
		nOldLandIndex = nNowLandIndex
	end
	--把一些代码 移到cd前面了，可能会有点耗
	--local nCurrenTime=GetCurrentTime()
	--if nCurrenTime % nHomeCheckInterVal ~= 0 then
	--return
	--end
	--local scene = player.GetScene()
	--Log(nNowLandIndex)	
	--if nNowLandIndex>0 then
	--local bOnMayLand = GetHomelandMgr().IsMyLand(scene.dwMapID, scene.nCopyIndex, nNowLandIndex)
	--Log(tostring(bOnMayLand))		
	--if bOnMayLand and not player.IsHaveBuff(16972,2) then	--首次打开界面
	--RemoteCallToServer("On_Home_HouseFastPanel", true)
	--return
	--end
	--if not bOnMayLand and player.IsHaveBuff(16972,2) then	--首次关闭界面
	--RemoteCallToServer("On_Home_HouseFastPanel", false)
	--return
	--end
	--elseif player.IsHaveBuff(16972,2) then	--首次关闭界面
	--RemoteCallToServer("On_Home_HouseFastPanel", false)
	--return
	--end
end

local nActiveIndex = 1
-- 客户端玩家周期性调用,注意,只有客户端主角玩家才会调用,调用周期为1秒
function Activate(player)
	nActiveIndex = nActiveIndex or 1
	if nActiveIndex > #ActiveFunctionList then
		nActiveIndex = 1
	end
	ActiveFunctionList[nActiveIndex](player)
	nActiveIndex = nActiveIndex + 1

	--检查玩家是否站在自己的地皮上
	CheckPlayerHomeLand(player)
end
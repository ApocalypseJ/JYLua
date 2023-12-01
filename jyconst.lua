
--设置全局变量CC，保存游戏中使用的常数
function SetGlobalConst()

	--无酒不欢：基本完整的SDL2键码，便于设置快捷键
	VK_ESCAPE=27
	VK_SPACE=32				--注意这里的空格实际上不需要定义，因为底层会自动把空格转换成回车
	VK_RETURN=13
	VK_F1=1073741882
	VK_F2=1073741883
	VK_F3=1073741884
	VK_F4=1073741885
	VK_A = 97
	VK_B = 98 
	VK_C = 99 
	VK_D = 100 
	VK_E = 101
	VK_F = 102 
	VK_G = 103
	VK_H = 104 
	VK_I = 105
	VK_J = 106 
	VK_K = 107
	VK_L = 108 
	VK_M = 109
	VK_N = 110 
	VK_O = 111
	VK_P = 112 
	VK_Q = 113
	VK_R = 114 
	VK_S = 115
	VK_T = 116 
	VK_U = 117
	VK_V = 118 
	VK_W = 119
	VK_X = 120 
	VK_Y = 121
	VK_Z = 122 
	
	VK_BACKSPACE = 8

	VK_UP=1073741906
	VK_DOWN=1073741905
	VK_LEFT=1073741904
	VK_RIGHT=1073741903
	VK_PGUP=1073741899
	VK_PGDN=1073741902
		
	-- 游戏中颜色定义
	C_STARTMENU = RGB(132, 0, 4)
	C_RED = RGB(216, 20, 24)
	C_WHITE = RGB(236, 236, 236)
	C_ORANGE = RGB(252, 148, 16)
	C_GOLD = RGB(236, 200, 40)
	C_BLACK = RGB(0, 0, 0)
	M_Black = RGB(0, 0, 0)
	M_Sienna = RGB(160, 82, 45)
	M_DarkOliveGreen = RGB(85, 107, 47)
	M_DarkGreen = RGB(0, 100, 0)
	M_DarkSlateBlue = RGB(72, 61, 139)
	M_Navy = RGB(0, 0, 128)
	M_Indigo = RGB(75, 0, 130)
	M_DarkSlateGray = RGB(47, 79, 79)
	M_DarkRed = RGB(139, 0, 0)
	M_DarkOrange = RGB(255, 140, 0)
	M_Olive = RGB(128, 128, 0)
	M_Green = RGB(0, 128, 0)
	M_Teal = RGB(0, 128, 128)
	M_Blue = RGB(0, 0, 255)
	M_SlateGray = RGB(112, 128, 144)
	M_DimGray = RGB(105, 105, 105)
	M_Red = RGB(255, 0, 0)
	M_SandyBrown = RGB(244, 164, 96)
	M_YellowGreen = RGB(154, 205, 50)
	M_SeaGreen = RGB(46, 139, 87)
	M_MediumTurquoise = RGB(72, 209, 204)
	M_RoyalBlue = RGB(65, 105, 225)
	M_Purple = RGB(128, 0, 128)
	M_Gray = RGB(128, 128, 128)
	M_Magenta = RGB(255, 0, 255)
	M_Orange = RGB(255, 165, 0)
	M_Yellow = RGB(255, 255, 0)
	M_Lime = RGB(0, 255, 0)
	M_Cyan = RGB(0, 255, 255)
	M_DeepSkyBlue = RGB(0, 191, 255)
	M_DarkOrchid = RGB(153, 50, 204)
	M_Silver = RGB(192, 192, 192)
	M_Pink = RGB(255, 192, 203)
	M_Wheat = RGB(245, 222, 179)
	M_Wheat2 = RGB(205, 182, 139)
	M_LemonChiffon = RGB(255, 250, 205)
	M_PaleGreen = RGB(152, 251, 152)
	M_PaleTurquoise = RGB(175, 238, 238)
	M_LightBlue = RGB(173, 216, 230)
	M_Plum = RGB(221, 160, 221)
	M_White = RGB(255, 255, 255)
	MilkWhite =RGB(255, 255, 204)
	LimeGreen = RGB(100,200, 90)
	Lime = RGB(0,255,0)
	LightGreen = RGB(144,238,144)
	LightSkyBlue = RGB(135,206,250)
	green1 = RGB(145, 235, 45)
	OliveDrab = RGB(107, 142, 35)
	Snow3 = RGB(205, 201, 201)
	grey21 = RGB(54, 54, 54)
	LightSlateBlue = RGB(132, 112, 255)
	Violet = RGB(208, 152, 208)
	PinkRed = RGB(255, 102, 102)
	LightPurple = RGB(165, 28, 218)
	Color_Hurt1 = RGB(255, 215, 0)
	TG_Red = RGB(216, 20, 24)
	TG_Red_Bright = RGB(248, 40, 44)
	Dark_Gold = RGB(216, 180, 20)
	S_Yellow = RGB(245, 215, 15)
	LightYellow = RGB(255, 242, 204)
	LightYellow2 = RGB(255, 229, 153)
	LightYellow3 = RGB(255, 217, 102)

	-- 游戏状态定义
    GAME_START =0       --开始画面
    GAME_FIRSTMMAP = 1  --第一次显示主地图
    GAME_MMAP =2;       --主地图
    GAME_FIRSTSMAP = 3  --第一次显示主地图
    GAME_SMAP =4;       --场景地图
    GAME_WMAP =5;       --战斗地图
	GAME_DEAD =6;       --死亡画面
    GAME_END  =7;       --结束
    GAME_NEWNAME = 8;		--开启新游戏
	
	
	--游戏数据全局变量
	CC={};				--定义游戏中使用的常量，这些可以在修改游戏时修改之

	--实际的屏幕宽度与高度
	CC.ScreenW=lib.GetScreenW();		--显示窗口宽高
    CC.ScreenH=lib.GetScreenH();

	CC.SrcCharSet=0;					--源代码的字符集 0 gb  1 big5，用于转换R×。 如果源码被转换为big5，则应设为1
	CC.OSCharSet=CONFIG.CharSet;		--OS 字符集，-1 系统判断，0 GB, 1 Big5
	CC.FontName=CONFIG.FontName;		--显示字体

	--定义记录文件名。S和D由于是固定大小，因此不再定义idx了。
	CC.R_IDXFilename = {[0] = CONFIG.DataPath .. "ranger.idx"}
	CC.R_GRPFilename = {[0] = CONFIG.DataPath .. "ranger.grp"}
	CC.S_Filename = {[0] = CONFIG.DataPath .. "allsin.grp"}
	CC.D_Filename = {[0] = CONFIG.DataPath .. "alldef.grp"}
	
	CC.SavePath = CONFIG.DataPath .. "save/";
	CC.R_GRP = CC.SavePath.."r%d.grp"
	CC.S_GRP = CC.SavePath.."s%d.grp"
	CC.D_GRP = CC.SavePath.."d%d.grp"
	CC.SaveNum = 10;			--存档数量为10

	CC.TempS_Filename=CONFIG.DataPath .. "allsinbk.grp";

	CC.PaletteFile=CONFIG.DataPath .. "mmap.col";

	CC.FirstFile=CONFIG.PicturePath .. "title.png";
	CC.DeadFile=CONFIG.PicturePath .. "dead.png";

	CC.MMapFile={CONFIG.DataPath .. "earth.002",
				CONFIG.DataPath .. "surface.002",
				CONFIG.DataPath .. "building.002",
		        CONFIG.DataPath .. "buildx.002",
				CONFIG.DataPath .. "buildy.002"};

	--各种贴图文件名。这里只给出文件名，扩展名必须为idx/grp
	CC.MMAPPicFile = {CONFIG.DataPath .. "mmap.idx", CONFIG.DataPath .. "mmap.grp"}
	CC.SMAPPicFile = {CONFIG.DataPath .. "smap.idx", CONFIG.DataPath .. "smap.grp"}
	CC.WMAPPicFile = {CONFIG.DataPath .. "wmap.idx", CONFIG.DataPath .. "wmap.grp"}
	CC.EFTFile = {CONFIG.DataPath .. "Eft.idx", CONFIG.DataPath .. "Eft.grp"}
	CC.FightPicFile = {CONFIG.DataPath .. "fight/fight%03d.idx", CONFIG.DataPath .. "fight/fight%03d.grp"}

	CC.HeadPath = CONFIG.DataPath .. "head/";
	CC.HeadNum = 1010;
	CC.ThingPicFile = {CONFIG.DataPath .. "thing.idx", CONFIG.DataPath .. "thing.grp"}
	
	CC.IconPath = CONFIG.DataPath .. "icons/";
	CC.IconNum = 1010;

	CC.UIPath = CONFIG.DataPath .. "UI/";
	CC.UINum = 1010;
	
	CC.PTPath = CONFIG.DataPath .. "Portrait/";
	CC.PTNum = 1010;
	
	if CONFIG.MP3 == 1 then
		CC.MIDIFile=CONFIG.SoundPath .. "game%02d.mp3";
	else
		CC.MIDIFile=CONFIG.SoundPath .. "game%02d.mid";
	end
	CC.OGGFile=CONFIG.SoundPath .. "game%02d.ogg";
	CC.ATKFile=CONFIG.SoundPath .. "atk%02d.wav";
	CC.EFile=CONFIG.SoundPath .. "e%02d.wav";

	CC.WarFile=CONFIG.DataPath .. "war.sta";
	CC.WarMapFile={CONFIG.DataPath .. "warfld.idx",
                  CONFIG.DataPath .. "warfld.grp"};

	CC.TRP = CONFIG.DataPath.."talk.grp"
	CC.TDX = CONFIG.DataPath.."talk.idx"
	
	CC.Acvmts = CONFIG.DataPath .. "Achievements"

	--定义记录文件R×结构。  lua不支持结构，无法直接从二进制文件中读取，因此需要这些定义，用table中不同的名字来仿真结构。
	CC.TeamNum=15;          --队伍人数
	CC.MyThingNum=400      --主角物品数量
	
	CC.ItemInfoPath = CONFIG.ScriptPath .. "ItemInfo/"
	
	--版本号
	CC.Version="版本 1.98 Z"
   
	--动态显示提示
	CC.Timer={
						stime=0,
						status=0,
						str='',
						len=0,
						fun=demostr,
					};
	--动态显示的内容
	CC.RUNSTR={
							'快捷键 F1-马车 F3-队列 F4-整理物品 H-回家',
							'多培养一些队友，可以让你后面的战斗更轻松',
							'全球最大金庸MOD交流群是可以自由黑山的地方 QQ群号：624432140',
							'建议在小村把队友和主角练至最高的30级再出门历险',
							'小村的厨灶和炼丹炉可以制作提升生命和内力上限的药品'
						};
   

	CC.Base_S={};         --保存基本数据的结构，以便以后存取
	CC.Base_S["乘船"]={0,0,2}   -- 起始位置(从0开始)，数据类型(0有符号 1无符号，2字符串)，长度
	CC.Base_S["无用"]={2,0,2};
	CC.Base_S["人X"]={4,0,2};
	CC.Base_S["人Y"]={6,0,2};
	CC.Base_S["人X1"]={8,0,2};
	CC.Base_S["人Y1"]={10,0,2};
	CC.Base_S["人方向"]={12,0,2};
	CC.Base_S["船X"]={14,0,2};
	CC.Base_S["船Y"]={16,0,2};
	CC.Base_S["船X1"]={18,0,2};
	CC.Base_S["船Y1"]={20,0,2};
	CC.Base_S["船方向"]={22,0,2};
	CC.Base_S["难度"]={24,0,2};
	CC.Base_S["标准"]={26,0,2};
	CC.Base_S["畅想"]={28,0,2};
	CC.Base_S["特殊"]={30,0,2};
	CC.Base_S["单通"]={32,0,2};
	CC.Base_S["周目"]={34,0,2};
	CC.Base_S["天书数量"]={36,0,2};
	for i=1,CC.TeamNum do
		CC.Base_S["队伍" .. i]={38+2*(i-1),0,2};
	end

	for i=1,CC.MyThingNum do
		CC.Base_S["物品" .. i]={68+4*(i-1),0,2};
		CC.Base_S["物品数量" .. i]={68+4*(i-1)+2,0,2};
	end

    CC.PersonSize=404;   --每个人物数据占用字节
    CC.Person_S={};      --保存人物数据的结构，以便以后存取
    CC.Person_S["代号"]={0,0,2}
    CC.Person_S["头像代号"]={2,0,2}
    CC.Person_S["生命增长"]={4,0,2}
    CC.Person_S["无用"]={6,0,2}
    CC.Person_S["姓名"]={8,2,10}
    CC.Person_S["外号"]={18,2,10}
    CC.Person_S["性别"]={28,0,2}
    CC.Person_S["等级"]={30,0,2}
    CC.Person_S["经验"]={32,1,2}
    CC.Person_S["生命"]={34,0,2}
    CC.Person_S["生命最大值"]={36,0,2}
    CC.Person_S["受伤程度"]={38,0,2}
    CC.Person_S["中毒程度"]={40,0,2}
    CC.Person_S["体力"]={42,0,2}
    CC.Person_S["物品修炼点数"]={44,0,2}
    CC.Person_S["武器"]={46,0,2}
    CC.Person_S["防具"]={48,0,2}

	for i=1,5 do
		CC.Person_S["出招动画帧数" .. i]={50+2*(i-1),0,2};
        CC.Person_S["出招动画延迟" .. i]={60+2*(i-1),0,2};
        CC.Person_S["武功音效延迟" .. i]={70+2*(i-1),0,2};
	end

    CC.Person_S["内力性质"]={80,0,2}
    CC.Person_S["内力"]={82,0,2}
    CC.Person_S["内力最大值"]={84,0,2}
    CC.Person_S["攻击力"]={86,0,2}
    CC.Person_S["轻功"]={88,0,2}
    CC.Person_S["防御力"]={90,0,2}
    CC.Person_S["医疗能力"]={92,0,2}
    CC.Person_S["用毒能力"]={94,0,2}
    CC.Person_S["解毒能力"]={96,0,2}
    CC.Person_S["抗毒能力"]={98,0,2}
    CC.Person_S["拳掌功夫"]={100,0,2}
	CC.Person_S["指法技巧"]={102,0,2}
    CC.Person_S["御剑能力"]={104,0,2}
    CC.Person_S["耍刀技巧"]={106,0,2}
    CC.Person_S["特殊兵器"]={108,0,2}
    CC.Person_S["暗器技巧"]={110,0,2}
    CC.Person_S["武学常识"]={112,0,2}
    CC.Person_S["品德"]={114,0,2}
    CC.Person_S["攻击带毒"]={116,0,2}
    CC.Person_S["左右互搏"]={118,0,2}
    CC.Person_S["声望"]={120,0,2}
    CC.Person_S["资质"]={122,0,2}
    CC.Person_S["修炼物品"]={124,0,2}
    CC.Person_S["修炼点数"]={126,0,2}

    for i=1,15 do
        CC.Person_S["武功" .. i]={128+2*(i-1),0,2};
        CC.Person_S["武功等级" .. i]={158+2*(i-1),0,2};
    end

    for i=1,4 do
        CC.Person_S["携带物品" .. i]={188+2*(i-1),0,2};
        CC.Person_S["携带物品数量" .. i]={196+2*(i-1),0,2};
    end
	
	for i=1,4 do
		CC.Person_S["天赋外功"..i]={204+2*(i-1),0,2};
	end
	
	CC.Person_S["天赋内功"]={212,0,2}
	CC.Person_S["天赋轻功"]={214,0,2}
	CC.Person_S["实战"]={216,0,2}
	CC.Person_S["出战"]={218,0,2}
	CC.Person_S["休战"]={220,0,2}
	CC.Person_S["主运内功"]={222,0,2}
	CC.Person_S["主运轻功"]={224,0,2}
	CC.Person_S["六如觉醒"]={226,0,2}
	CC.Person_S["个人觉醒"]={228,0,2}
	CC.Person_S["畅想分阶"]={230,0,2}
	CC.Person_S["外号2"]={232,2,10}
	CC.Person_S["冰封程度"]={242,0,2}
	CC.Person_S["血量翻倍"]={244,0,2}
	CC.Person_S["论剑奖励"]={246,0,2}
	CC.Person_S["灼烧程度"]={248,0,2}
	CC.Person_S["行为模式"]={250,0,2}
	CC.Person_S["优先使用"]={252,0,2}
	CC.Person_S["是否吃药"]={254,0,2}
	CC.Person_S["生命阈值"]={256,0,2}
	CC.Person_S["内力阈值"]={258,0,2}
	CC.Person_S["体力阈值"]={260,0,2}
	CC.Person_S["禁用自动"]={262,0,2}
	CC.Person_S["特色指令"]={264,0,2}
	CC.Person_S["暗器1"]={266,0,2}
	CC.Person_S["暗器2"]={268,0,2}
	CC.Person_S["暗器3"]={270,0,2}
	CC.Person_S["动物"]={272,0,2}
	for i=1,4 do
		CC.Person_S["天"..i]={272+2*i,0,2};
	end
	CC.Person_S["暗器4"]={282,0,2}
	CC.Person_S["洗髓"]={284,0,2}
	CC.Person_S["积分"]={286,0,2}
	for i=1,10 do
        CC.Person_S["地" .. i]={286+2*i,0,2};  
    end
	CC.Person_S["专1"]={308,0,2}
	CC.Person_S["专2"]={310,0,2}
	CC.Person_S["武功16"]={312,0,2}
	CC.Person_S["武功等级16"]={314,0,2}
	
	for i=1,40 do
	CC.Person_S["人"..i]={314+2*i,0,2}
	end
	CC.Person_S["感悟点"]={396,0,2}
	CC.Person_S["感悟"]={398,0,2}
	CC.Person_S["路线"]={400,0,2}
	CC.Person_S["阶"]={402,0,2}
	
    CC.ThingSize=202;   --每个人物数据占用字节
    CC.Thing_S={};
    CC.Thing_S["代号"]={0,0,2}
    CC.Thing_S["名称"]={2,2,20}
    CC.Thing_S["名称2"]={22,2,20}
    CC.Thing_S["物品说明"]={42,2,30}
    CC.Thing_S["练出武功"]={72,0,2}
    CC.Thing_S["暗器动画编号"]={74,0,2}
    CC.Thing_S["使用人"]={76,0,2}
    CC.Thing_S["装备类型"]={78,0,2}
    CC.Thing_S["显示物品说明"]={80,0,2}
    CC.Thing_S["类型"]={82,0,2}
    CC.Thing_S["未知5"]={84,0,2}
    CC.Thing_S["未知6"]={86,0,2}
    CC.Thing_S["未知7"]={88,0,2}
    CC.Thing_S["加生命"]={90,0,2}
    CC.Thing_S["加生命最大值"]={92,0,2}
    CC.Thing_S["加中毒解毒"]={94,0,2}
    CC.Thing_S["加体力"]={96,0,2}
    CC.Thing_S["改变内力性质"]={98,0,2}
    CC.Thing_S["加内力"]={100,0,2}

    CC.Thing_S["加内力最大值"]={102,0,2}
    CC.Thing_S["加攻击力"]={104,0,2}
    CC.Thing_S["加轻功"]={106,0,2}
    CC.Thing_S["加防御力"]={108,0,2}
    CC.Thing_S["加医疗能力"]={110,0,2}
    CC.Thing_S["加用毒能力"]={112,0,2}
    CC.Thing_S["加解毒能力"]={114,0,2}
    CC.Thing_S["加抗毒能力"]={116,0,2}
    CC.Thing_S["加拳掌功夫"]={118,0,2}
	CC.Thing_S["加指法技巧"]={120,0,2}	
    CC.Thing_S["加御剑能力"]={122,0,2}
    CC.Thing_S["加耍刀技巧"]={124,0,2}
    CC.Thing_S["加特殊兵器"]={126,0,2}
    CC.Thing_S["加暗器技巧"]={128,0,2}
    CC.Thing_S["加武学常识"]={130,0,2}
    CC.Thing_S["加品德"]={132,0,2}

    CC.Thing_S["加攻击次数"]={134,0,2}
    CC.Thing_S["加攻击带毒"]={136,0,2}
    CC.Thing_S["仅修炼人物"]={138,0,2}
    CC.Thing_S["需内力性质"]={140,0,2}
    CC.Thing_S["需内力"]={142,0,2}
    CC.Thing_S["需攻击力"]={144,0,2}
    CC.Thing_S["需轻功"]={146,0,2}
    CC.Thing_S["需用毒能力"]={148,0,2}
    CC.Thing_S["需医疗能力"]={150,0,2}
    CC.Thing_S["需解毒能力"]={152,0,2}
    CC.Thing_S["需拳掌功夫"]={154,0,2}	
	CC.Thing_S["需指法技巧"]={156,0,2}	
    CC.Thing_S["需御剑能力"]={158,0,2}
    CC.Thing_S["需耍刀技巧"]={160,0,2}
    CC.Thing_S["需特殊兵器"]={162,0,2}
    CC.Thing_S["需暗器技巧"]={164,0,2}

    CC.Thing_S["需资质"]={166,0,2}
    CC.Thing_S["需经验"]={168,0,2}
    CC.Thing_S["练出物品需经验"]={170,0,2}
    CC.Thing_S["需材料"]={172,0,2}

    for i=1,5 do
		CC.Thing_S["练出物品" .. i]={174+2*(i-1),0,2};
		CC.Thing_S["需要物品数量" .. i]={184+2*(i-1),0,2};
	end
	 
	CC.Thing_S["是否特效"]={194,0,2}
	CC.Thing_S["装备经验"]={196,0,2}
	CC.Thing_S["装备等级"]={198,0,2}
	CC.Thing_S["需阴"]={200,0,2}

    CC.SceneSize=54;   --每个场景数据占用字节
    CC.Scene_S={};
    CC.Scene_S["代号"]={0,0,2}
    CC.Scene_S["名称"]={2,2,10}
    CC.Scene_S["出门音乐"]={12,0,2}
    CC.Scene_S["进门音乐"]={14,0,2}
    CC.Scene_S["跳转场景"]={16,0,2}
    CC.Scene_S["进入条件"]={18,0,2}
    CC.Scene_S["外景入口X1"]={20,0,2}
    CC.Scene_S["外景入口Y1"]={22,0,2}
    CC.Scene_S["外景入口X2"]={24,0,2}
    CC.Scene_S["外景入口Y2"]={26,0,2}
    CC.Scene_S["入口X"]={28,0,2}
    CC.Scene_S["入口Y"]={30,0,2}
    CC.Scene_S["出口X1"]={32,0,2}
    CC.Scene_S["出口X2"]={34,0,2}
    CC.Scene_S["出口X3"]={36,0,2}
    CC.Scene_S["出口Y1"]={38,0,2}
    CC.Scene_S["出口Y2"]={40,0,2}
    CC.Scene_S["出口Y3"]={42,0,2}
    CC.Scene_S["跳转口X1"]={44,0,2}
    CC.Scene_S["跳转口Y1"]={46,0,2}
    CC.Scene_S["跳转口X2"]={48,0,2}
    CC.Scene_S["跳转口Y2"]={50,0,2}
	CC.Scene_S["场景类型"]={52,0,2}

    CC.WugongSize=146;   --每个武功数据占用字节
    CC.Wugong_S={};
    CC.Wugong_S["代号"]={0,0,2}
    CC.Wugong_S["名称"]={2,2,10}
    CC.Wugong_S["未知1"]={12,0,2}
    CC.Wugong_S["未知2"]={14,0,2}
    CC.Wugong_S["未知3"]={16,0,2}
    CC.Wugong_S["未知4"]={18,0,2}
    CC.Wugong_S["未知5"]={20,0,2}
    CC.Wugong_S["出招音效"]={22,0,2}
    CC.Wugong_S["武功类型"]={24,0,2}
    CC.Wugong_S["武功动画&音效"]={26,0,2}
    CC.Wugong_S["伤害类型"]={28,0,2}
    CC.Wugong_S["攻击范围"]={30,0,2}
    CC.Wugong_S["消耗内力点数"]={32,0,2}
    CC.Wugong_S["敌人中毒点数"]={34,0,2}

    for i=1,10 do
		CC.Wugong_S["攻击力" .. i]={36+2*(i-1),0,2};
		CC.Wugong_S["移动范围" .. i]={56+2*(i-1),0,2};
		CC.Wugong_S["杀伤范围" .. i]={76+2*(i-1),0,2};
		CC.Wugong_S["加内力" .. i]={96+2*(i-1),0,2};
		CC.Wugong_S["杀内力" .. i]={116+2*(i-1),0,2};
    end
	 
	CC.Wugong_S["冰封系数"]={136,0,2}
	CC.Wugong_S["灼烧系数"]={138,0,2}
	CC.Wugong_S["啊"]={140,0,2}
	CC.Wugong_S["积分"]={142,0,2}
	CC.Wugong_S["冷却"]={144,0,2}

	CC.ShopSize=36;   --每个小宝商店数据占用字节
	CC.Shop_S={};
	for i=1,6 do
		CC.Shop_S["物品" .. i]={0+2*(i-1),0,2};
		CC.Shop_S["物品数量" .. i]={12+2*(i-1),0,2};
		CC.Shop_S["物品价格" .. i]={24+2*(i-1),0,2};
	end

	CC.ShopScene={};       --小宝商店场景数据，sceneid 场景id，d_shop 小宝位置D*, d_leave 小宝离开D*，一般在场景出口，路过触发
	CC.ShopScene[0]={sceneid=1,d_shop=16,d_leave={17,18}, };
	CC.ShopScene[1]={sceneid=3,d_shop=14,d_leave={15,16}, };
	CC.ShopScene[2]={sceneid=40,d_shop=20,d_leave={21,22}, };
	CC.ShopScene[3]={sceneid=60,d_shop=16,d_leave={17,18}, };
	CC.ShopScene[4]={sceneid=61,d_shop=9,d_leave={10,11,12}, };

	--其他常量
	CC.MWidth=480;       --主地图宽
	CC.MHeight=480;      --主地图高

	CC.SWidth=64;     --子场景地图大小
	CC.SHeight=64;

	CC.DNum=200;       --D*每个场景的事件数

	CC.XScale=CONFIG.XScale;    --贴图一半的宽高
	CC.YScale=CONFIG.YScale;


	CC.Frame=CONFIG.FrameRate;     --每帧毫秒数
	CC.BattleDelay=CONFIG.BattleDelay;     --战斗点数显示的延迟（毫秒）

	CC.SceneMoveFrame=100;           --场景移动帧速，用于场景移动事件
	CC.PersonMoveFrame=100;          --主角移动速度，用于主角移动事件
	CC.AnimationFrame=150;           --动画显示帧速，用于显示动画事件

	CC.WarAutoDelay=300;                   --自动战斗时显示头像的延时

	CC.DirectX={0,1,-1,0};  --不同方向x，y的加减值，用于走路改变坐标值
	CC.DirectY={-1,0,0,1};

	CC.MyStartPicM=2501;      --男主角走路起始贴图
	CC.MyStartPicF=5001;      --女主角走路起始贴图
	CC.BoatStartPic=3715;    --船起始贴图

	CC.Level=30;                  ---人物等级和每等级经验
	CC.Exp={   50,    150,     300 ,500   , 750 ,
               1050,  1400,   1800 ,2250  , 2750 ,
               3850,  5050,   6350 ,7750  , 9250 ,
               10850, 12550, 14350 ,16750 , 18250 ,
               21400, 24700, 28150 ,31750 , 35500 ,
	           39400, 43450, 47650 ,52000 , 60000 , [0] = 0 };

    CC.MMapBoat={};    --主地图船可以进入的贴图
	local tmpBoat={ {0x166,0x16a},{0x176,0x17c},{0x1ca,0x1d0},{0x1fa,0x262},{0x3f8,0x3fe},};
    for i,v in ipairs(tmpBoat) do      --把这些数据变换成数组，其中有值就是可以进入
        for j=v[1],v[2],2 do
            CC.MMapBoat[j]=1;
        end
    end
	--Alungky 解决船开到深海区时，显示为人的问题
	local tmpForbid={{0x264,0x29E}}
    for i,v in ipairs(tmpForbid) do    
        for j=v[1],v[2],2 do
			CC.MMapBoat[j]=1;
        end
    end

    CC.SceneWater={};    --场景人不能进入的贴图
    local tmpWater={ {0x166,0x16a},{0x176,0x17c},{0x1ca,0x1d0},{0x1fa,0x262},{0x332,0x338},
                     {0x346,0x346},{0x3a6,0x3a8},{0x3f8,0x3fe},{0x52c,0x544},};
    for i,v in ipairs(tmpWater) do      --把这些数据变换成数组，其中空项就是可以进入的贴图
        for j=v[1],v[2],2 do
            CC.SceneWater[j]=1;
        end
    end

    CC.WarWater={};    --战斗地图人不能进入的贴图
    local tmpWater={ {0x166,0x16a},{0x176,0x17c},{0x1ca,0x1d0},{0x1fa,0x262},{0x332,0x338},
                     {0x346,0x346},{0x3a6,0x3a8},{0x3f8,0x3fe},{0x52c,0x544},};
    for i,v in ipairs(tmpWater) do      --把这些数据变换成数组，其中空项就是可以进入的贴图
        for j=v[1],v[2],2 do
            CC.WarWater[j]=1;
        end
    end

--武功招式
CC.KFMove={}
--逍遥游3招
CC.KFMove[2]={
{'饭来张口',600},
{'沿门托钵',600},
{'见人伸手',600}
}
--五毒神掌1招
CC.KFMove[3]={
{'五毒摧心',700}
}
--鹰爪功2招
CC.KFMove[4]={
{'锁喉',700},
{'探目',700}
}
--寒冰绵掌1招
CC.KFMove[5]={
{'寒冰封体',700}
}
--美女拳法3招
CC.KFMove[6]={
{'红玉击鼓',700},
{'文姬归汉',700},
{'木兰弯弓',700}
}
--绵掌1招
CC.KFMove[7]={
{'绵绵不绝',700}
}
--天山六阳掌3招
CC.KFMove[8]={
{'阳歌天钧',900},
{'阳春白雪',900},
{'阳关三叠',900}
}
--白驼雪山掌1招
CC.KFMove[9]={
{'雪山白驼',800}
}
--百花错拳2招
CC.KFMove[10]={
{'红花天梦',800},
{'天池缭乱',800}
}
--九阴白骨爪1招
CC.KFMove[11]={
{'冥华幻灭',1100}
}
--落英神剑掌3招
CC.KFMove[12]={
{'珞樱缤纷',900},
{'雨急风狂',900},
{'江城飞花',900}
}
--铁掌1招
CC.KFMove[13]={
{'壁立千仞',900}
}
--天山折梅手2招
CC.KFMove[14]={
{'踏雪折梅',1200},
{'天山灵鹫',1200}
}
--空明拳3招
CC.KFMove[15]={
{'深藏若虚',1200},
{'天马行空',1200},
{'空空如也',1200}
}
--太极拳3招
CC.KFMove[16]={
{'上步野马分鬃',1000},
{'提步高探马',1000},
{'白鹤晾翅',1000}
}
--一阳指3招
CC.KFMove[17]={
{'梵指南天',1200},
{'指矢天日',1200},
{'紫微伏龙',1200}
}
--弹指神通2招
CC.KFMove[18]={
{'弹指一瞬',1200},
{'踏月香华',1200}
}
--幻阴指1招
CC.KFMove[19]={
{'魔幻天阴',1000}
}
--龙爪手1招
CC.KFMove[20]={
{'沛然有雨',1000}
}
--玄冥神掌2招
CC.KFMove[21]={
{'玄冥侵体',1100},
{'冰毒缭绕',1100}
}
--大金刚掌3招
CC.KFMove[22]={
{'大梵炼狱',1000},
{'九仪崩乱',1000},
{'地火燃穹',1000}
}
--七伤拳2招
CC.KFMove[23]={
{'魂魄飞扬',1000},
{'三焦齐逆',1000}
}
--须弥山神掌3招
CC.KFMove[24]={
{'色空四显',1200},
{'无色无相',1200},
{'慑伏外道',1200}
}
--黯然销魂掌6招
CC.KFMove[25]={
{'拖泥带水',1300},
{'倒行逆施',1300},
{'行尸走肉',1300},
{'魂不守舍',1300},
{'心惊肉跳',1300},
{'六神不安',1300}
}
--降龙十八掌6招
CC.KFMove[26]={
{'亢龙有悔',1500},
{'见龙在田',1500},
{'飞龙在天',1500},
{'双龙出水',1500},
{'神龙摆尾',1500},
{'潜龙勿用',1500}
}
--松风剑法3招
CC.KFMove[27]={
{'平沙落雁',300},
{'鸿飞冥冥',300},
{'碧渊腾蛟',300}
}
--雷震剑术2招
CC.KFMove[28]={
{'轰雷掣电',300},
{'雷霆万钧',300}
}
--三分剑术4招
CC.KFMove[29]={
{'云无常',600},
{'风无相',600},
{'霜无痕',600},
{'摩诃无量',1800}
}
--恒山剑法3招
CC.KFMove[30]={
{'万花齐放',500},
{'万卉争艳',500},
{'清澈梅花',500}
}
--泰山剑法3招
CC.KFMove[31]={
{'五大夫剑',500},
{'岱宗如何',500},
{'七星落长空',500}
}
--衡山剑法3招
CC.KFMove[32]={
{'如梦如幻',600},
{'千变万化',600},
{'炫人耳目',600}
}
--嵩山剑法3招
CC.KFMove[33]={
{'叠翠浮青',600},
{'玉进天池',600},
{'天外玉龙',600}
}
--华山剑法3招
CC.KFMove[34]={
{'苍松迎客',600},
{'金雁横空',600},
{'天坤倒悬',600}
}
--雪山剑法3招
CC.KFMove[35]={
{'雪泥鸿爪',600},
{'梅雪争春',600},
{'雪山六出',600}
}
--柔云剑法3招
CC.KFMove[36]={
{'杏花春雨',700},
{'满天花雨',700},
{'玉带围腰',700}
}
--两仪剑法2招
CC.KFMove[37]={
{'金针渡劫',800},
{'峭壁断云',800}
}
--玉萧剑法5招
CC.KFMove[38]={
{'山外清音',800},
{'金声玉振',800},
{'凤曲长鸣',800},
{'响隔楼台',800},
{'棹歌中流',800}
}
--全真剑法5招
CC.KFMove[39]={
{'大江似练',800},
{'春意阑珊',800}, 
{'斜风细雨',800}, 
{'星河欲转',800}, 
{'桃花流水',800}
}
--金蛇剑法5招
CC.KFMove[40]={
{'金光蛇影',900},
{'蛇影万馈',900},
{'金蛇化龙',900},
{'灵蛇电闪',900},
{'蛇困愁城',900}
}
--倚天剑法3招
CC.KFMove[41]={
{'玉碎昙香',1000},
{'天劫俱灭',1000}, 
{'倚天照海',1000}
}
--玉女剑法6招
CC.KFMove[42]={
{'清饮小酌',800},
{'浪迹天涯',800},
{'举案齐眉',800},
{'皓腕玉镯',800},
{'冷月窥人',800},
{'竹帘临池',800}
}
--斗转星移2招
CC.KFMove[43]={
{'星落云散',1200},
{'星光日月',1200}
}
--苗家剑法6招
CC.KFMove[44]={
{'冲天掌苏秦背剑',1000},
{'黄龙转身吐须势',1000},
{'迎门腿反劈华山',1000},
{'洗剑怀中抱月',1000},
{'上步云边摘月',1000},
{'提撩剑白鹤舒翅',1000}
}
--玄铁剑法4招
CC.KFMove[45]={
{'逆击',1500},
{'倒劈',1500},
{'顺刺',1500},
{'横削',1500}
}
--太极剑法3招
CC.KFMove[46]={
{'仙人指路',1300},
{'青龙出水',1300},
{'三环套月',1300}
}
--独孤九剑9招
CC.KFMove[47]={
{'总决式',1200},
{'破剑式',1200},
{'破枪式',1200},
{'破刀式',1200},
{'破鞭式',1200},
{'破索式',1200},
{'破掌式',1200},
{'破箭式',1200},
{'破气式',1200}
}
--辟邪剑法6招
CC.KFMove[48]={
{'指打奸邪',600},
{'飞燕穿柳',1200},
{'花开见佛',1000}, 
{'锺馗抉目',1100}, 
{'扫荡群魔',1500},
{'紫气东来',1400}
}

--傲寒六诀
CC.KFMove[217]={
{'惊寒一瞥',0},
{'冰封三尺',0},
{'红杏出墙',0}, 
{'桃枝夭夭',0}, 
{'踏雪寻梅',0},
{'冷刃冰心',0}
}
CC.KFMove[219]={
{'冷刃冰心',0}
}
--柴刀十八路2招
CC.KFMove[50]={
{'砍',500},
{'劈',500}
}
--鬼头刀法1招
CC.KFMove[52]={
{'鬼见愁',600}
}
--南山刀法2招
CC.KFMove[53]={
{'铁锁横江',600},
{'燕子入巢',600}
}
--鸳鸯刀法2招
CC.KFMove[54]={
{'云蕾花开',1200},
{'玲珑偃月',1200}
}
--狂风刀法2招
CC.KFMove[55]={
{'狂风大作',700},
{'飞沙走石',700}
}
--奇门三才刀2招
CC.KFMove[56]={
{'带醉脱靴',700},
{'奇刀单鞭式',700}
}
--慈悲刀法2招
CC.KFMove[57]={
{'放下屠刀',600},
{'立地成佛',600}
}
--修罗刀1招
CC.KFMove[58]={
{'恨意绵绵',600}
}
--五虎断门刀2招
CC.KFMove[59]={
{'白虎跳涧',600},
{'剪扑自如',600}
}
--反两仪刀法2招
CC.KFMove[60]={
{'重节守义',700},
{'万劫不复',700}
}
--金乌刀法2招
CC.KFMove[61]={
{'梅雪逢夏',700},
{'赤日炎炎',700}
}
--夫妻刀法4招
CC.KFMove[62]={
{'女貌郎才珠万斛',1200},
{'天教丽质为眷属',1200}, 
{'清风引佩下瑶台',1200}, 
{'明月照妆成金屋',1200}
}
--血刀大法3招
CC.KFMove[63]={
{'呕心沥血',800},
{'批纸削腐',800},
{'流星经天',800}
}
--玄虚刀法2招
CC.KFMove[64]={
{'玄之又玄',900}
}
--燃木刀法2招
CC.KFMove[65]={
{'钻木取火',900},
{'无名孽火',900}
}
--火焰刀法2招
CC.KFMove[66]={
{'炽炎破军',1200},
{'昊火焚天',1200}
}
--胡家刀法2招
CC.KFMove[67]={
{'穿手藏刀式',1000},
{'八方藏刀式',1000}
}
--杨家枪法3招
CC.KFMove[68]={
{'回马枪',500},
{'春雷震怒',500},
{'凤点头',500}
}
--中平枪法2招
CC.KFMove[70]={
{'中正锁喉',600},
{'枪平九洲',600}
}
--裴将军帖2招
CC.KFMove[71]={
{'大君制六合',700},
{'猛将清九垓',700}
}
--棋盘招式8招
CC.KFMove[72]={
{'紧气',800},
{'提子',800},
{'大飞',800},
{'小飞',800},
{'天元',800},
{'跳',800},
{'立',800},
{'长',800}
}
--鹤蛇八打2招
CC.KFMove[74]={
{'冲天一鹤',700},
{'仙鹤穿云',700}
}
--大剪刀2招
CC.KFMove[75]={
{'咔嚓',800},
{'我剪',800}
}
--阴阳倒乱刃2招
CC.KFMove[77]={
{"假刀非刀",1000},
{"假剑非剑",1000}
}
--黄沙万里鞭2招
CC.KFMove[78]={
{"血染黄沙",800},
{"飞沙万里",800}
}
--银索金铃2招
CC.KFMove[79]={
{"银索缠身",1100},
{"锁穴金铃",1100}
}
--打狗棒法4招
CC.KFMove[80]={
{'棒打狗头',1400},
{'反截狗臀',1400},
{'獒口夺杖',1400},
{'棒打双犬',1400}
}
--灵蛇杖法2招
CC.KFMove[81]={
{'怪蟒翻身',1400},
{'毒蛇吐信',1400}
}
--金刚伏魔圈4招
CC.KFMove[82]={
{'祗园精舍',1100},
{'诸行无常',1100},
{'娑罗双树',1100}, 
{'幻梦一场',1100}
}
--无上大力杵3招
CC.KFMove[83]={
{'力战千钧',1200},
{'拔山填海',1200},
{'千钧压顶',1200}
}
--倚天屠龙功6招
CC.KFMove[84]={
{'武林至尊',1000},
{'宝刀屠龙',1000},
{'号令天下',1000},
{'莫敢不从',1000},
{'倚天不出',1000},
{'谁与争锋',1000}
}
--伏魔杖法2招
CC.KFMove[86]={
{'天魔降伏',1100},
{'降龙伏虎',1100}
}
--太玄神功5招
CC.KFMove[102]={
{'赵客缦胡缨 吴钩霜雪明',1200},
{'银鞍照白马 飒沓如流星',1200},
{'三杯吐然诺 五岳倒为轻',1200},
{'纵死侠骨香 不惭世上英',1200},
{'谁能书阁下 白首太玄经',1200}
}	
--野球拳3招
CC.KFMove[109]={
{'石头',1200},
{'剪子',1200},
{'布',1200}
}
--神山剑法3招
CC.KFMove[110]={
{'神洲移山剑',1200},
{'神洲镇山剑',1200},
{'神洲擎山剑',1200}
}
--西瓜刀法3招
CC.KFMove[111]={
{'切瓜',1200},
{'剁瓜',1200},
{'砍瓜',1200}
}
--犽月流空2招
CC.KFMove[112]={
{'月犽流',1200},
{'月骁流',1200}
}
--连城剑法4招
CC.KFMove[114]={
{'故人西辞黄鹤楼',900},
{'烟花三月下扬州',900},
{'孤帆远影碧空尽',900},
{'唯见长江天际流',900}
}
--三花聚顶掌1招
CC.KFMove[115]={
{'天虹倒划',700}
}
--化骨绵掌1招
CC.KFMove[118]={
{'百鬼恸哭',1000}
}
--冰蚕毒掌1招
CC.KFMove[120]={
{'冰毒缭绕',1100}
}
--一指禅1招
CC.KFMove[128]={
{'丹凤朝阳',1000},
{'海底捞月',1000}
}
--凝血神爪2招
CC.KFMove[134]={
{'风驰电掣',1000},
{'逆挽天华',1000}
}
--大力金刚指2招
CC.KFMove[135]={
{'金刚揭谛',700},
{'金刚震脉',700}
}
--无相劫指2招
CC.KFMove[136]={
{'天地玄黄',1300},
{'天火焚城',1300}
}
--参合指6招
CC.KFMove[138]={
{'国破山河在，城春草木深',1500},
{'感时花溅泪，恨别鸟惊心',1500},
{'锋火连三月，兵败参合陂',1500},
{'白头搔更短，浑欲不胜簪',1500},
{'夜来参星斗，天命何所归',1500},
{'顾盼子孙贤，铭记复国志',1500}
}
--玉女素心剑6招
CC.KFMove[139]={
{'清饮小酌',1100},
{'浪迹天涯',1100},
{'举案齐眉',1100},
{'皓腕玉镯',1100},
{'冷月窥人',1100},
{'竹帘临池',1100}
}
--达摩剑法1招
CC.KFMove[140]={
{'天罗地煞',1000}
}
--百胜刀法2招
CC.KFMove[141]={
{'却月天戈',1000},
{'孤月寒江',1000}
}
--妙笔丹青1招
CC.KFMove[142]={
{'神封太渊',1200}
}
--沧溟刀法2招
CC.KFMove[153]={
{'素月分辉',1200},
{'银河共影',1200}
}
--越女剑法4招
CC.KFMove[156]={
{'电照长空',1500},
{'仙猿剑舞',1500},
{'诛天凌神',1500},
{'天仙剑影',1500}
}
--枣核钉1招
CC.KFMove[157]={
{'瞬狱一杀',1000}
}
--五轮大转2招
CC.KFMove[158]={
{'天罡震烈',1300},
{'天舞宝轮',1300}
}
--苍狼战戟2招
CC.KFMove[159]={
{'魔澜惊炽',2000},
{'罗摩沌灭',2000}
}
--玄女剑法1招
CC.KFMove[161]={
{'碧落穹苍',1200}
}
--狂风快剑2招
CC.KFMove[162]={
{'一叶扁舟',1200},
{'天外飞龙',1200}
}
--白蟒鞭法1招
CC.KFMove[164]={
{'残烛引月',1200}
}
--青莲剑法10招
CC.KFMove[167]={
{'长风万里送秋雁',1200},
{'对此可以酣高楼',1200},
{'蓬莱文章建安骨',1200},
{'中间小谢又清发',1200},
{'俱怀逸兴壮思飞',1200},
{'欲上青天览明月',1200},
{'抽刀断水水更流',1200},
{'举杯消愁愁更愁',1200},
{'人生在世不称意',1200},
{'明朝散发弄扁舟',1200}
}
--逍遥神剑2招
CC.KFMove[168]={
{'蓬莱仙梦',1600},
{'百剑无终',1600}
}

--达摩神掌4招
CC.KFMove[173]={
{'亿万小时',3000},
{'精心打磨',3000},
{'国产绿色',3000},
{'休闲单机',3000}
}

--阴风刀2招
CC.KFMove[174]={
{'阴风阵阵',1200},
{'利刃寒锋',1200}
}

--烈火剑法1招
CC.KFMove[176]={
{'天灰地烬',2000}
}

--千蛛万毒手1招
CC.KFMove[183]={
{'千蛛万毒',1000}
}

--白虹掌力1招
CC.KFMove[184]={
{'曲直如意',1200}
}

--夺命三仙剑3招
CC.KFMove[185]={
{'肃杀',1200},
{'夺命',1200},
{'同归',1200},
}

--神刀斩2招
CC.KFMove[189]={
{'天涯明月刀如雪',2000},
{'小楼一夜听春雨',2000},
}

--满洲摔跤4招
CC.KFMove[119]={
{'过肩摔',1200},
{'过胸摔',1200},
{'别腿摔',1200},
{'拦腰摔',1200},
}

--莫名剑法
CC.KFMove[199]={
{'一剑成名',0},
{'莫名其妙',0},
{'名动一时',0},
{'悲痛莫名',0},
{'隐姓埋名',0},
{'剑火无名',0},
{'名不经传',0},
{'名不虚传',0},
{'名动江湖',0},
{'怨忿莫名',0},
}

--摧心掌
CC.KFMove[201]={
{'椎心泣血',1300},
{'摧心剖肝',1300},
}
--碧针清掌4招
CC.KFMove[206]={
{"松针旋舞",1500},
{"碧波清流",1300},
{"化气为实",1600},
{"气动乾坤",1800},
}

--龙啸穿云枪
CC.KFMove[208]={
{"敢当百万雄",1600},
{"凛凛一心忠",1500},
{"直入虎狼丛",1800},
{"谁敢与争锋",1900},
}

--龙啸穿云枪
CC.KFMove[253]={
{"敢当百万雄",1600},
{"凛凛一心忠",1500},
{"直入虎狼丛",1800},
{"谁敢与争锋",1900},
}

--白家剑法
CC.KFMove[211]={
{"白翁撒网",800},
{"白鱼入舟",800},
{"白燕分飞",800},
{"白鹤渡江",800},
{"白马奔腾",800},
{"白蛇吐信",800},
{"白驹空谷",800},
{"白虹贯日",800},
{"白云孤飞",800},
{"白雪阳春",800},
{"白凤振翅",800},
{"白龙戏水",800},
}
--无量神掌
CC.KFMove[212]={
{"海量汪涵",600},
{"无量直捣",800},
{"四方无量",1000},
{"大海无量",1800},
{"佛法无边",1200},
{"地动天旋",1400},
{"气海无涯",1600},
{"日月无华",1800},
{"气吞天下",2000},
{"无悔三震",2200},
}
--霹雳刀法
CC.KFMove[215]={
{"列缺霹雳",1300},
{"丘峦崩摧",1300},
}

CC.KFMove[221]={
{"雷霆无尽",1700},
{"风火无边",1000},
{"五情无敌",1200},
}
CC.KFMove[222]={
{"剑留痕",1400},
{"剑流云",1000},
{"剑流星",2000},
{"无极云十剑",2200},
}
CC.KFMove[239]={
{"五行错乱",1100},
}
--lotus whip,dragon's touch,surging fist,dragon tail,crescent heel,twin snake,rising fang*,wall of kun-lun*,iron rage**,volcanic roar**,dragon's prey***
CC.KFMove[241]={
{"如意金箍棒",13500},
}
CC.KFMove[242]={
{"莲花鞭",700},
}
CC.KFMove[243]={
{"龙之触",1400},
}
CC.KFMove[244]={
{"狂涌之拳",300},
}
CC.KFMove[245]={
{"神龙摆尾",1200},
}
CC.KFMove[246]={
{"圆月踏",1100},
}
CC.KFMove[247]={
{"双生蛇",1200},
}
CC.KFMove[248]={
{"冲天牙",2000},
}
CC.KFMove[249]={
{"昆仑壁",2000},
}
CC.KFMove[250]={
{"铁拳之怒",2000},
}
CC.KFMove[251]={
{"火山咆哮",3000},
}
CC.KFMove[252]={
{"龙之掠夺",5000},
}
--离队人员列表: {人员id，离队调用函数}      ----如果有新的离队人员加入，直接在这里增加
CC.PersonExit = {
{1, 100}, 
{2, 102}, 
{4, 104}, 
{9, 106}, 
{16, 108}, 
{17, 110}, 
{25, 112}, 
{28, 114}, 
{29, 116}, 
{30, 118}, 
{35, 120}, 
{36, 122}, 
{37, 124}, 
{38, 126}, 
{44, 128}, 
{45, 130}, 
{47, 132}, 
{48, 134}, 
{49, 136}, 
{51, 138}, 
{52, 140}, 
{53, 142}, 
{54, 144}, 
{55, 146}, 
{56, 148}, 
{58, 150}, 
{59, 152}, 
{63, 154}, 
{66, 156}, 
{72, 158}, 
{73, 160}, 
{74, 162}, 
{75, 164}, 
{76, 166}, 
{77, 168}, 
{78, 170}, 
{79, 172}, 
{80, 174}, 
{81, 176}, 
{82, 178}, 
{83, 180}, 
{84, 182}, 
{85, 184}, 
{86, 186}, 
{87, 188}, 
{88, 190}, 
{89, 192}, 
{90, 194}, 
{91, 196}, 
{655, 7100},--李逍遥
{656, 7102},--赵灵儿
{657, 7104},--林月如
{658, 7106},--阿奴
{589, 8005},--水笙离队事件
{590, 8650},--李文秀离队事件
{601, 4138},--韦小宝离队事件
{161, 4183},--李莫愁离队事件
{626, 4184},--郭襄离队事件
{628, 4191},--神雕离队事件
{629, 4200},--阿九离队事件
{607, 4202},--焦宛儿离队事件
{631, 4209},--周芷若离队事件
{646, 4249},--殷离离队事件
{609, 4250} --赵敏离队事件
}

    --所有可加入人员离队需要清除的D*事件，清除后这些人就找不到了。得到神杖时使用
    CC.AllPersonExit={
			{1, 5}, 
			{2, 6}, 
			{4, 21}, 
			{9, 17}, 
			{16, 31}, 
			{17, 32}, 
			{25, 28}, 
			{28, 29}, 
			{29, 26}, 
			{30, 13}, 
			{35, 15}, 
			{36, 25}, 
			{37, {7,8}}, 
			{38, {16,58}}, 
			{44, 33}, 
			{45, 12}, 
			{47, 23}, 
			{48, 24}, 
			{49, {10,11}}, 
			{51, 22}, 
			{52, 41}, 
			{53, 9}, 
			{54, 18}, 
			{55, 13}, 
			{56, 14}, 
			{58, 19}, 
			{59, 20}, 
			{63, 30}, 
			{66, 38}, 
			{72, 40}, 
			{73, 35}, 
			{74, 36}, 
			{75, 37}, 
			{76, 27}, 
			{77, 39}, 
			{78, 59}, 
			{79, 42}, 
			{80, 52}, 
			{81, 46}, 
			{82, 54}, 
			{83, 55}, 
			{84, 34}, 
			{85, 47}, 
			{86, 49}, 
			{87, 50}, 
			{88, 43}, 
			{89, 44}, 
			{90, 53}, 
			{91, 51}, 
			{92, 1},
			{655, 1},
			{656, 1},
			{657, 1},
			{658, 1},
			{589, 80},
			{590, 86},
			{601, 48}	--韦小宝
			};

    CC.BookNum=14;               --天书个数
    CC.BookStart=144;            --14天书起始物品id

    CC.MoneyID=174;              --金钱物品id
    CC.Shemale = {[93] = 1,[311] = 1,[78] = 1}

	--特效帧数
	CC.Effect = {
	14, 	--特效1 Blue puff
	17, 	--特效2 Water drop
	9, 		--特效3 Thin yellow line with tiny pink circle at bottom
	13, 	--特效4 Tiny yellow splashing
	17, 	--特效5 Water drop with thunder like effect
	17, 	--特效6 Water drop with thunder like effect + yellow flames rising
	17, 	--特效7 Vertical red flame fading
	18, 	--特效8	Ice falling then breaking
	19, 	--特效9 Bright yellow explotion smoke
	19, 	--特效10 yellow flames rising
	15, 	--特效11 Small blood spilling
	13, 	--特效12 Small blood spilling (fewer frames)
	10, 	--特效13 Black half circle splashing
	10, 	--特效14 Red half circle splashing
	15, 	--特效15 Tiny tornado exploding
	21, 	--特效16 blood spilling with tiny yellow explotion
	16, 	--特效17
	9, 		--特效18
	11, 	--特效19
	8, 		--特效20
	9, 		--特效21
	8, 		--特效22
	8, 		--特效23
	7, 		--特效24
	8, 		--特效25
	8, 		--特效26
	9, 		--特效27
	12, 	--特效28
	19, 	--特效29
	11, 	--特效30
	14, 	--特效31 Yellow puff
	12, 	--特效32
	17, 	--特效33
	8, 		--特效34
	11, 	--特效35
	10, 	--特效36
	13, 	--特效37
	10, 	--特效38 
	19, 	--特效39 Bright yellow mushroom cloud
	14, 	--特效40
	17, 	--特效41
	19, 	--特效42
	14, 	--特效43
	21, 	--特效44
	16, 	--特效45
	13, 	--特效46
	18, 	--特效47
	14, 	--特效48
	17, 	--特效49
	17, 	--特效50
	16, 	--特效51
	7, 		--特效52 Tiny mushroom cloud
	12, 	--特效53 Yellow dragon rising(badly drawn)
	40, 	--特效54 Beige ghost like smoke
	16, 	--特效55
	9, 		--特效56
	15, 	--特效57
	15, 	--特效58 Classic explotion flame
	31, 	--特效59
	38, 	--特效60 Swords falling
	24, 	--特效61
	26, 	--特效62 Swords falling(fewer and faded)
	24, 	--特效63 北冥
	20, 	--特效64 化功
	12, 	--特效65
	17, 	--特效66
	14, 	--特效67
	14, 	--特效68
	10, 	--特效69
	10, 	--特效70
	18, 	--特效71 吸星
	31, 	--特效72
	12, 	--特效73
	7, 		--特效74
	6, 		--特效75
	7, 		--特效76
	28, 	--特效77
	16, 	--特效78
	7, 		--特效79
	16, 	--特效80
	20, 	--特效81
	15, 	--特效82
	13, 	--特效83
	15, 	--特效84
	11, 	--特效85
	11, 	--特效86
	11, 	--特效87
	20, 	--特效88
	20, 	--特效89
	20, 	--特效90
	17, 	--特效91
	17, 	--特效92
	17, 	--特效93
	9, 		--特效94
	8, 		--特效95
	8, 		--特效96
	17, 	--特效97
	10, 	--特效98
	11, 	--特效99
	8, 		--特效100
	29, 	--特效101
	6, 		--特效102
	13, 	--特效103
	31, 	--特效104
	14, 	--特效105
	4, 		--特效106
	13, 	--特效107 two blades
	13, 	--特效108
	15,		--特效109
	24; 	--特效110 打狗
	20; 	--特效111 降龙
	12; 	--特效112 
	16; 	--特效113 blue serpent
	18; 	--特效114 yellow tornado
	17; 	--特效115 red lights flailing
	14; 	--特效116 ice breaking
	12; 	--特效117 dark serpent
	19; 	--特效118 Old school explotion
	16; 	--特效119 Yellow cross explotion
	12; 	--特效120 Red light rising
	14; 	--特效121 Light green explotion
	14; 	--特效122 Fire arrow
	6; 		--特效123 Devil face
	8; 		--特效124 Fire explosion
	24; 	--特效125 Light slashing
	19; 	--特效126 Yellow cosmic explosion
	16; 	--特效127 Small burning explotion
	14; 	--特效128 Heart shaped explotion
	20; 	--特效129 Violet halo
	18;		--特效130 五轮
	16;		--特效131 lightning
	13;		--特效132 bright light swords surrounding
	25;		--特效133 Flame ring
	20;		--特效134 连珠腐尸毒
	13;		--特效135 blizzard shield
	22;		--特效136 blue spiral
	35;		--特效137 Pink saber
	11;		--特效138 进阶太岳
	17;		--特效139 进阶云雾
	25;		--特效140 进阶万岳
	23;		--特效141 进阶万花
	16;		--特效142 进阶泰山
	11;		--特效143 thin orange flame
	13;		--特效144 thin blue flame
	7;		--特效145 口才
	14;		--特效146 破军
	27;		--特效147 yellow halo
	16;		--特效148 poison
	14;		--特效149 倾国
	44;		--特效150 nuclear explosion
	12;		--特效151 集中
	16;		--特效152 ice entangle
	14;		--特效153 梯云纵
	18;		--特效154 fire bird
	21;		--特效155 剑步谜影
	9;		--特效156 玄铁重击
	12;     --157灭杀豪升龙
	10;     --158
	19;     --159断塔
	18;     --160赤鸦空裂破
	20;     --161yiyin
	22;     --redhexwind
	17;     --darkflame
	19;     --Greenwhatever
	19;     --Greenwhatever
	12;      --bolt
	12;      --meteor
	7;
	[0] = 9	--特效0	Tiny heart(when heal)
	}
	
	--装备对威力的加成
    CC.ExtraOffense = {
			{52, 75, 100},		--鳄嘴剪+大剪刀
			{45, 67, 100},		--冷月宝刀+胡刀
			{202, 67, 100},		--闯王军刀+胡刀
			{37, 41, 100},		--倚天剑+灭剑
			{49, 80, 200},		--打狗棒+打狗棒法
			{44, 63, 200},		--血刀+血刀
			{40, 40, 200},		--金蛇剑+金蛇
			{36, 45, 200},		--玄铁剑+玄铁
			{276, 155, 3000},	--火枪+火枪
			{51, 78, 200},		--金龙鞭+黄沙万里鞭法
			{50, 86, 100},		--伏魔杵+伏魔杖法
			{241, 39, 100},		--君子剑+全真剑法
			{242, 42, 100},		--淑女剑+玉女剑法
			{244, 81, 200},		--西毒蛇杖+灵蛇杖法
			{55, 110, 100},		--神山剑+神山剑法
			{56, 111, 100},		--玄铁菜刀+西瓜刀法
			{57, 112, 100},		--犽月+犽月流空
			{243, 77, 200},		--金刀黑剑+阴阳倒乱刃
			{39, 44, 100},		--白龙剑+苗家剑法
			{236, 46, 100},		--真武剑+太极剑法
			{239, 6, 200},		--金丝手套+美女拳法
			{200, 14, 200},		--七宝指环+天山折梅手
			{54, 68, 100},		--亮银枪+杨家枪
			{319, 189, 200},	--圆月弯刀+神刀斩
			{41, 36, 100},		--凝碧剑+柔云剑法
			{338, 158, 300},	--五轮大法
			{344, 68, 300},
			{344, 70, 300},
			{344, 165, 300},
			{344, 208, 300},
			}

    CC.NewPersonName=CONFIG.PlayName;                --新游戏的数据
	
    CC.NewGameSceneID = 70
	CC.NewGameSceneX = 16
	CC.NewGameSceneY = 31
	CC.NewGameEvent = 691
	CC.NewPersonPicM = 2515
	CC.NewPersonPicF = 5015

	CC.PersonAttribMax = {}
	CC.PersonAttribMax["经验"] = 60000
	CC.PersonAttribMax["物品修炼点数"] = 30000
	CC.PersonAttribMax["修炼点数"] = 30000
	CC.PersonAttribMax["生命最大值"] = 1000
	CC.PersonAttribMax["受伤程度"] = 100
	CC.PersonAttribMax["中毒程度"] = 100
	CC.PersonAttribMax["内力最大值"] = 9999
	CC.PersonAttribMax["体力"] = 100
	CC.PersonAttribMax["攻击力"] = 520
	CC.PersonAttribMax["防御力"] = 520
	CC.PersonAttribMax["轻功"] = 520
	CC.PersonAttribMax["医疗能力"] = 200
	CC.PersonAttribMax["用毒能力"] = 200
	CC.PersonAttribMax["解毒能力"] = 200
	CC.PersonAttribMax["抗毒能力"] = 200
	CC.PersonAttribMax["拳掌功夫"] = 320
	CC.PersonAttribMax["指法技巧"] = 320
	CC.PersonAttribMax["御剑能力"] = 320
	CC.PersonAttribMax["耍刀技巧"] = 320
	CC.PersonAttribMax["特殊兵器"] = 320
	CC.PersonAttribMax["暗器技巧"] = 320
	CC.PersonAttribMax["武学常识"] = 200
	CC.PersonAttribMax["品德"] = 120
	CC.PersonAttribMax["资质"] = 100
	CC.PersonAttribMax["攻击带毒"] = 340

    CC.WarDataSize=186;         --战斗数据大小  war.sta数据结构
    CC.WarData_S={};        --战斗数据结构
    CC.WarData_S["代号"]={0,0,2};
    CC.WarData_S["名称"]={2,2,10};
    CC.WarData_S["地图"]={12,0,2};
    CC.WarData_S["经验"]={14,0,2};
    CC.WarData_S["音乐"]={16,0,2};
    for i=1,6 do
        CC.WarData_S["手动选择参战人"  .. i]={18+(i-1)*2,0,2};
        CC.WarData_S["自动选择参战人"  .. i]={30+(i-1)*2,0,2};
        CC.WarData_S["我方X"  .. i]={42+(i-1)*2,0,2};
        CC.WarData_S["我方Y"  .. i]={54+(i-1)*2,0,2};
    end
    for i=1,20 do
        CC.WarData_S["敌人"  .. i]={66+(i-1)*2,0,2};
        CC.WarData_S["敌方X"  .. i]={106+(i-1)*2,0,2};
        CC.WarData_S["敌方Y"  .. i]={146+(i-1)*2,0,2};
    end

    CC.WarWidth=64;        --战斗地图大小
    CC.WarHeight=64;

	--显示主地图和场景地图坐标
	--如果显示坐标，则会增加cpu占用。机器速度慢的话可能会卡。这个在调试时有用。
	CC.ShowXY=1      --0 不显示 1 显示


	--以下为控制显示方式的参数
	CC.MenuBorderPixel=5  -- 菜单四周边框留的像素数，也用于绘制字符串的box四周留得像素

	CC.DefaultFont=math.modf(math.min(CC.ScreenW,CC.ScreenH) / 320 * 14);
	CC.SmallFont = CC.DefaultFont*3/4;
	CC.FontBIG = math.modf(CC.DefaultFont*1.45)
	CC.FontBig = math.modf(CC.DefaultFont*1.3)
	CC.Fontbig = math.modf(CC.DefaultFont*1.15)
	CC.Fontsmall = math.modf(CC.DefaultFont*0.85)
	CC.FontSmall = math.modf(CC.DefaultFont*0.7)
	CC.FontSmall2 = math.modf(CC.DefaultFont*0.65)
	CC.FontSmall3 = math.modf(CC.DefaultFont*0.635)
	CC.FontSmall4 = math.modf(CC.DefaultFont*0.9)
	CC.FontSmall5 = math.modf(CC.DefaultFont*0.92)
	CC.FontSMALL = math.modf(CC.DefaultFont*0.55)
	CC.RowPixel = math.modf(math.min(CC.ScreenW, CC.ScreenH) / 100)

	--CC.StartMenuY= 160       --开始菜单Y坐标
	CC.StartMenuFontSize=CC.DefaultFont  --开始菜单字号

	--CC.NewGameY= 160         --新游戏属性显示Y坐标
	CC.NewGameFontSize =CC.DefaultFont   --新游戏属性选择字号


	CC.MainMenuX=10;         --主菜单开始坐标
	CC.MainMenuY=10;

	CC.GameOverX=90;
	CC.GameOverY=65;

    CC.PersonStateRowPixel= 5;    --显示人物状态行间距像素
    
    --物品显示定义
    CC.ThingFontSize = CC.Fontsmall;
		
	--CC.ThingPicWidth=math.modf(100*CONFIG.Zoom/100);    --物品图片宽高
	CC.ThingPicWidth=100	--物品图片固定尺寸
	CC.ThingPicHeight=CC.ThingPicWidth;

	local n = math.modf(CC.ScreenW/CC.ThingPicWidth-2);			--一行显示几个物品
	if n < 10 then	
		CC.MenuThingXnum = 9;				
	else
		CC.MenuThingXnum = 9
	end
		
	local m = math.modf(CC.ScreenH/CC.ThingPicHeight-2);		--物品显示几列
	if m < 5 then	
		CC.MenuThingYnum = 5;
	else
		CC.MenuThingYnum = 5;
	end

	CC.ThingGapOut=4;		--物品图像显示四周留白
	CC.ThingGapIn=4;		--物品图像显示中间间隔	

    CC.StartMenuY=CC.ScreenH-3*(CC.StartMenuFontSize+CC.RowPixel)-20;
	CC.NewGameY=CC.ScreenH-4*(CC.NewGameFontSize+CC.RowPixel)-10;

	--子菜单的开始坐标
	CC.MainSubMenuX=CC.MainMenuX+2*CC.MenuBorderPixel+2*CC.DefaultFont+5;       --主菜单为两个汉字
	CC.MainSubMenuY=CC.MainMenuY;

	--二级子菜单开始坐标
	CC.MainSubMenuX2=CC.MainSubMenuX+2*CC.MenuBorderPixel+4*CC.DefaultFont+5;   --子菜单为四个字符

	CC.SingleLineHeight=CC.DefaultFont+2*CC.MenuBorderPixel+5;  --带框的单行字符高

	CC.StartThingPic = 0
	
	CC.AutoMoveEvent = {[0]=0};		--鼠标操作时是否触发事件， 第一个位置0未触发， 1触发， 2触发并且能够走到面前， 第二和第三个位置为XY坐标
	CC.MMapAdress = {};				--大地图地址

	LMSJ = {"少冲剑","商阳剑", "中冲剑", "少泽剑", "关冲剑", "少商剑"}
	XL18JY = {"极意--亢龙·鸿渐於陆", "极意--飞龙·或跃在渊", "极意--潜龙·密雨不云", "极意--神龙·震惊百里", "极意--见龙·利涉大川", "极意--双龙·突如其来", "极意--六龙·履霜冰至", "极意--龙战·损则有孚"}
	TFSSJ = {"·『天道惊雷憾』", "·『点墨山河』", "·『一剑镇神洲』", "·『羽葬煌炎斩』", "·『千机龙绝闪』", "·『斗焰罡霸劲』", "·『仁者无敌』", "·『八门聚万象』", "·『天人五衰』"}
	ZJTF = {"盖世神拳", "灵犀一指", "剑神一笑", "傲世狂刀", "奇门无双", "绝世天罡", "仁者无敌", "回天圣手", "欲天摩罗"}
	TFE = {"拳", "指", "剑", "刀", "特", "罡", "仁", "医", "毒"}
	TSTF = {nil, "影帝"}
	Kael = {"急速冷却","幽灵漫步","强袭飓风","电磁脉冲","灵动迅捷","混沌陨石","阳炎冲击","熔炉精灵","寒冰之墙","超震声波"}
	tf = {
			             {{"药物精通：吃药效果加倍 ",nil,1},{"无路可逃：攻击范围+1 ",nil,1},{"乘胜追击：对生命值低于50%敌人造成的伤害提高35% ",nil,1},{"好斗勇者：每一个存活的敌人会使你的伤害提高3% ",nil,1},{"百步穿杨：暗器提高100",nil,1},{"冰冻之息：攻击必定冰封，并使敌人集气速度减少20%",nil,1},{"朴实无华：普通攻击范围+2，威力+300",nil,1},{"Bloodsplosion",nil,1}},
			             {{"拳法精通：拳掌威力提高20% ",nil,1},{"指法精通：指法威力提高20%",nil,1},{"剑法精通：剑法威力提高20%",nil,1},{"刀法精通：刀法威力提高20%",nil,1},{"奇门精通：奇门威力提高20%",nil,1},{"一代宗师：所有武功威力提高15%",nil,1},{"博览群书：第一格武功行动前随机更换",nil,1},{"Critical Ascensi0n",nil,1}},
						 {{"根骨不凡：五系兵器值提高30，上限提高30 ",nil,1},{"杀即使生：攻击后恢复已损失生命值的5%",nil,1},{"孤胆英雄：单独出战，攻击伤害提高15%，受到伤害减少15%",nil,1},{"铜墙铁壁：受到的伤害减少15%",nil,1},{"稳如泰山：气防+1500",nil,1},{"众志成城：每存在一个队友，受到的伤害减少5%",nil,1},{"荆棘之肤：受到攻击，10%的伤害反弹给攻击者",nil,1},{"Body of Diamond",nil,1}},
						 {{"不畏奸邪：受到四大山的伤害减少20% ",nil,1},{"风驰电掣：集气速度+15",nil,1},{"齐心协力：每存在一个队友，最终伤害提高7%",nil,1},{"百不一失：攻击必中，暴击几率提高10%",nil,1},{"狂风骤雨：连击伤害随连击数提高 ",nil,1},{"来去自如：攻击后可以移动 ",nil,1},{"气血充盈：内力和生命时序回复效果加倍",nil,1},{"Yieks！",nil,1}},
						 {{"八部神威：天龙八部武功威力增加50% ",nil,1},{"唯快不破：集气速度越快，伤害越高 ",nil,1},{"圣霸道强：内力上限增加3000 ",nil,1},{"舍命一击：攻击会消耗10%当前失生命值，造成30%已损失生命值额外伤害 ",nil,1},{"抱薪救火：攻击必灼烧，自己时序增加灼烧，灼烧状态下增减伤15% ",nil,1},{"腥香血膻：生命值越低，伤害越高，集气越快  ",nil,1},{"突飞猛进：集气速度时序+1",nil,1},{"Spirit Walk",nil,1}},
						 {{"斗转星移：学会斗转星移",nil,1},{"左右互搏：学会左右互搏",nil,1},{"翻云破浪：攻击必定三连击",nil,1},{"万夫莫开：受到的伤害减少20%，受到的连击伤害减少60%",nil,1},{"滴水穿石：造成的伤害减少30%，攻击附带300真实伤害",nil,1},{"以暴制暴：攻击必连必暴 ",nil,1},{"三生万物：第三击会全屏攻击 ",nil,1},{"Buzz Axe Rampage",nil,1}},
						 {{"灵罡不灭：时序回复80点内力",nil,1},{"拳之极者：拳掌指法威力+500，攻击无视100%防御",nil,1},{"武器大师：刀剑奇威力+500，装备武器时，攻击无视100%防御",nil,1},{"洞若观火：无视条件必定击中破绽，击中破绽伤害提高15%",nil,1},{"生生不息：时序回复20点生命",nil,1},{"含沙射影：暗器根据暗器值，几率伤害加倍 ",nil,1},{"煞星飞殃：所有其他角色17%几率不命中，被攻击时对攻击者上满灼烧冰封中毒内伤 ",nil,1},{"Siphon Life ",nil,1}},
						 {{"邪涌魔彰：道德低于30时，集气速度+15，生命上限+2000，造成的伤害提高20% ",nil,1},{"不动明王：免疫第二三击的连击伤害 ",nil,1},{"知一万毕：所有武功组合需求减少2（至少需要一个）",nil,1},{"龙形舞天：道德高于90时，集气速度+25，内力上限+1000，20%几率闪避 ",nil,1},{"剑盾合璧：同时装备武器和防具时，造成的伤害+180，受到的伤害-180 ",nil,1},{"神秘韵律：攻击不消耗体力，受到的伤害减少，威力越高，减少量越高",nil,1},{"摩睺罗伽：战斗开始时，所有其他角色时停20时序",nil,1},{"Doom Bolt",nil,1}},  
						 {{"狂怒不灭：时序增加8点怒气",nil,1},{"森罗万象：所有属性值提高到上限",nil,1},{"正义使者：对四大山的伤害提高50%",nil,1},{"太阴：阴内等级+10",nil,1},{"太阳：阳内等级+10",nil,1},{"太极，内属变为调和15 ",nil,1},{"气血转换：被攻击时，用三倍内力抵消80%的伤害 ",nil,1},{"Tw0 Fang",nil,1}},
						 {{"玄之又玄：40%几率免疫攻击",nil,1},{"至尊江湖：特效几率必定四次判定，并有特殊减伤效果 ",nil,1},{"恶法轮回：第一次被击退会复活，恢复全状态，复活后伤害提高35% ",nil,1},{"只手遮天：攻击范围+5，伤害不随距离递减 ",nil,1},{"恐怖如斯：伤害提高100%",nil,1},{"无极：阴阳内等级各+5，内属变为天罡",nil,1},{"大事化小：进入战斗所有敌方生命内力减半",nil,1},{"Star Terminator",nil,1}},
						}
	NAN1 = {3,6,7,8,10,11,12,13,14,15,18,19,20,21,22,23,24,31,32,33,34,41,42,43,46,67,70,71,74,94,95,96,97,98,
    99,100,101,106,107,108,109,110,111,115,119,120,121,122,123,124,125,126,127,128,130,131,132,133,134,135,136,39,40,
    137,138,139,140,141,142,143,144,145,146,147,148,150,151,152,153,154,155,156,157,158,159,160,161,167,168,169,
    170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,594,597,598,599,602,603,609,
    633,635,639,640,643,644,645,646,647,648,649}
    NAN2 = {5,26,27,50,60,62,64,65,69,102,103,112,113,114,116,117,118,604,605,606,608,610,612,613,614,615,627,628,
    634,654,636,637,638,652,659,660,661,662,663,664}
    NAN3 = {592,665,666,667,668,670,671,672,673,674,675,676,677,678,681,682,683,686,687,688,691,692,689}
	Number ={"一","二","三","四","五","六","七","八","九","十","十一","十二","十三","十四","十五"}
	JYJS1 = {1,2,3}--飞雪
	JYJS2 = {3,4,72,633}
	JYJS3 = {37,52,94,95,96,97,589,594,595,672}--连
	JYJS4 = {44,45,46,47,48,49,50,51,53,70,76,90,98,99,100,101,102,103,112,113,114,115,116,117,118,600,634}--天
	JYJS5 = {30,55,56,57,60,61,65,67,68,69,78,129,130,131,132,133,134,135,136,637}--射
	JYJS6 = {137,138,590}--白
	JYJS7 = {71,150,601,602,603}--鹿鼎记
	JYJS8 = {19,20,21,22,23,24,25,26,27,29,31,32,33,34,35,36,73,79,88,140,142,149,610,611}--笑
	JYJS9 = {74,75,80,151,152,153,154,155,156,606}--书
	JYJS10 = {58,59,62,63,64,84,157,158,160,159,161,592,605,614,615,616,617,626,627,628}--神
	JYJS11 = {38,39,40,41,42,43,85,162,163,164}--侠
	JYJS12 = {5,6,7,8,9,10,11,12,13,14,15,18,66,81,82,171,172,173,174,175,459,597,598,599,608,609,631,638,646,647,648}--倚天
	JYJS13 = {54,83,91,184,185,186,187,188,629,639}--碧血剑
	JYJS14 = {77,189}
	--李白
	LIBAI = {"君不见黄河之水天上来，奔流到海不复回","床前明月光，疑是地上霜","飞湍瀑流争喧豗，砯崖转石万壑雷","剑阁峥嵘而崔嵬，一夫当关，万夫莫开",
	"上有六龙回日之高标，下有冲波逆折之回川","相思相见知何日？此时此夜难为情","列缺霹雳，丘峦崩摧","飞流直下三千尺，疑是银河落九天",
	"众鸟高飞尽，孤云独去闲","且乐生前一杯酒，何须身后千载名","两岸猿声啼不住，轻舟已过万重山","银鞍照白马，飒沓如流星",
	"长相思兮长相忆，短相思兮无穷极","入我相思门，知我相思苦","十步杀一人，千里不留行","停杯投箸不能食，拔剑四顾心茫然",
	"长风几万里，吹度玉门关","抽刀断水水更流，举杯销愁愁更愁","弹剑作歌奏苦声，曳裾王门不称情","危楼高百尺，手可摘星辰",
	"我本楚狂人，凤歌笑孔丘","君不见黄河之水天上来，奔流到海不复回"}
	--阶
	Tier = {}

	Tier[1] = {"胡家刀法威力增加1000，必定触发极意","飞天神行自动运功，轻功+100","所有人每次行动后，有30%几率无视地形移动3格"}
	Tier[2] = {"攻击带毒+100，时序解毒+5","攻击强制上毒+50，时序解毒+5","攻击强制上毒+50，时序解毒+5"}
	Tier[3] = {"苗家剑法威力增加500，极意概率+50%","苗家剑法威力增加500，极意概率+50%","苗家剑法威力增加500，苗家剑法无视气防"}--苗人凤
	--Tier[4] = {"受到伤害减少20%，装备任何武器，攻击强制上毒+100","击退敌方获得大量银两"}--阎基
	Tier[5] = {"阴阳内属等级各加2","太极拳、太极剑法、太极神功威力提高20%","【太极之形】上限提高至30，每次被攻击获得2~5个【太极之形】"}--张三丰
	Tier[6] = {"剑法威力提高800","装备倚天剑剑法攻击无视气防","生命首次低于25%，下一次攻击会持续连击，直到内力或体力过低或者击退敌方"}--灭绝
	Tier[7] = {"两仪剑法威力提高50%，自带【两仪守护】效果","两仪剑法威力提高50%","两仪剑法威力提高50%，【两仪守护·极】100%触发"}--何太冲
	Tier[8] = {"七伤拳范围+2，威力+1000","七伤拳距离+3，100%【七伤】","七伤拳伤害加倍"}--唐文亮
	Tier[9] = {"太极拳、太极剑法、七伤拳威力+500","乾坤大挪移自动运功","九阳神功自动运功"}--张无忌
	Tier[10] = {"武学常识+100，五系兵器值+50","兵器值上限+100，修炼武功时，五系兵器值+1","每练一个武功到极，最终伤害增加20，受到伤害减少20"}--范遥
	Tier[11] = {"弹指神通范围+5","天赋内功自动运功","集气速度、伤害提高25%"}--杨逍
	Tier[12] = {"鹰爪功威力加倍","鹰爪功威力加倍","鹰爪功威力加倍"}--殷天正
	Tier[13] = {"可用狮子吼攻击，狮子吼范围+3","内力上限提高3000","七伤拳必定触发狮子吼，杀气效果提高100，35%几率全屏攻击"}--谢逊
	Tier[14] = {"集气速度提高30","每20点集气速度提高10%伤害和3%攻击吸血","如果生命值低于30%，则伤害加倍，必定暴击且100%吸血"}--韦一笑
	Tier[15] = {"灵蛇杖法威力+800","攻击不造成怒气","灵蛇杖法威力+800"}--黛绮丝
	
	Tier[16] = {"医疗无消耗，医疗能力提高100，上限提高100","行动结束后，医疗自己一次","所有人每次行动后，概率医疗自己一次，概率随实战提升"}--胡青牛

	Tier[18] = {"幻阴指强制上毒100，威力提高800","幻阴指范围+4","攻击50%概率无视集气条击中破绽，击中破绽伤害杀气提高80%"}--成昆
	Tier[19] = {"太岳三青峰威力翻倍，范围+3","紫霞神功自动运功，内力上限提高2000","辟邪剑法招式无冷却"}--岳不群
	Tier[20] = {"云雾十三式威力加倍，范围+2","集气速度提高30","云雾十三式必定暴击三连"}--莫大
	Tier[21] = {"万花剑法直接有【花开花落】效果，范围+1","万花剑法自带专精效果且威力加倍","受到的最终伤害减少35%"}--定闲
	Tier[22] = {"寒冰真气自动运功，万岳朝宗威力提高700","寒冰真气自带专精效果，威力加倍，范围+5，可以攻击冻结敌人","受到的伤害减少20%，被攻击反冰100点"}--左冷禅
	Tier[23] = {"泰山十八盘变为面攻，威力+500","【峻岭横空】效果持续","泰山十八盘威力加倍，不可闪避"}--天门
	--Tier[24] = {"可用狮子吼攻击，狮子吼范围+3","内力上限提高3000","七伤拳必定触发狮子吼，35%几率全屏攻击"}--余沧海
	Tier[25] = {"黄沙万里鞭法自带专精效果","攻击50%几率附带随机【蛊毒】效果","攻击100%几率附带随机【蛊毒】效果"}--蓝凤凰
	Tier[26] = {"吸星大法自动运功，且可以吸血","内力上限提高2000","攻击可吸集气速度"}--任我行
	Tier[27] = {"攻击几率三连","葵花神功自动运功","攻击伤害不会低于200"}--东方不败
	Tier[28] = {"攻击伤害和治疗效果提高30%","两次受到致命伤会治疗自己一次，恢复70%生命值","治疗后，下次攻击最终伤害会附带未攻击前治疗量的伤害"}--平一指
	Tier[29] = {"狂风刀法有刺目效果，狂风刀法攻击不消耗体力","每使用一次狂风刀法，集气速度提高10","每10点集气速度提高狂风刀法15%威力、1距离"}--田伯光
	
	Tier[35] = {"自带独孤九剑专精效果，独孤九剑威力提高500","剑法攻击80%几率无视集气条击中破绽","独孤九剑范围可以移动，不消耗体力"}--令狐冲
	
	Tier[36] = {"辟邪剑法自带专精效果","集气速度提高30","最终集气速度提高20%，暴怒集气速度提高50%"}--林平之
	Tier[37] = {"内力上限提高2000","连城剑法威力提高800，必定暴击","每3000内力最大值神照功可以复活一次"}--狄云
	Tier[38] = {"五系兵器值+150","被攻击反弹10~40%的伤害","【太玄之重】【太玄之轻】100%触发"}--石破天
	Tier[39] = {"最终伤害提高120","杀气提高2000","必定三连击"}--龙岛主
	Tier[40] = {"受到的伤害减少120","气防提高2000","不受连击伤害"}--木岛主
	
	--Tier[41] = {"张三伤害增加20%，李四受到的伤害减少20%"}--张三
	
	Tier[43] = {"雪山剑法范围+2，可以移动，威力提高1000","所有敌方时序增加5冰封，集气速度减少25%","若敌方集气速度小于40或者内力小于2000，则不能攻击移动"}--白万剑
	--Tier[44] = {"受到的伤害降低20%","集气比自身快的敌方攻击伤害降低30%","若敌方集气速度小于40或者内力小于2000，则不能攻击移动"}--岳老三
	Tier[46] = {"化功大法自动运功","连环腐尸毒必连击必暴击","道德为0时，免疫杀气，最终伤害提高40%"}--丁春秋
	Tier[47] = {"化功大法自动运功","每损失2%生命值，闪避几率提高1%","攻击必定击中破绽，击中破绽伤害提高50%"}--阿紫
	Tier[48] = {"受到的最终伤害减少20%","受到的最终伤害减少200","受到的伤害后，免疫下次攻击"}--游坦之
	Tier[49] = {"中了生死符的角色集气紊乱，生命值时序减少","内力上限提高3000","内力上限提高5000"}--虚竹
	Tier[50] = {"降龙十八掌不消耗体力内力","受到的最终伤害减少25%","每时序最终伤害提高10"}--乔峰
	Tier[51] = {"五系兵器值+100，武学常识+50","攻击时，提高五系兵器值之和10%伤害，被攻击时减少等量伤害","斗转星移反击伤害加倍"}--慕容复
	Tier[52] = {"攻击无法闪避,中平枪法变为面攻","50%概率受到的最终伤害减少99.9%","第二格武功行动前有50%概率变为如意金箍棒"}--花铁干
	Tier[53] = {"北冥神功自动运功","六脉神剑不消耗体力，范围+5","内力上限提高5000"}--段誉
	Tier[54] = {"金蛇奥义触发几率提高30%，最终伤害+100","神行百变自动运功，金蛇奥义最终伤害+200","战斗结束获得金蛇锥，暗器伤害提高200"}--袁承志
	Tier[55] = {"左右互搏几率100%，左右互搏第一下伤害气功提高35%","降龙十八掌威力提高1000","九阴神功自动运功"}--郭靖
	Tier[56] = {"打狗棍法不消耗体力，威力提高1000","闪避几率提高20%","软猬甲反弹40%伤害"}--黄蓉
	Tier[57] = {"桃花三绝威力提高1000","【奇门五转】闪避几率提高15%","攻击必定击中破绽，免疫破绽"}--黄药师
	Tier[58] = {"黯然销魂掌没有使用限制，玄铁剑法威力提高600","【西狂之怒啸】杀气效果增加100","生命值越低，伤害越高，集气越快，最多提高200%"}--杨过
	Tier[59] = {"左右互搏几率100%","额外增加一次连击","额外增加一次连击"}--小龙女
	Tier[60] = {"内力上限提高2000","灵蛇杖法额外造成敌方10%最大生命值伤害","暴击伤害提高50%"}--欧阳锋
	Tier[61] = {"【灵蛇拳】100%触发，暴怒时白驼雪山掌全屏攻击","【灵蛇拳】会使敌人时序损失3%当前生命值","【灵蛇拳】会使敌人时序损失8%当前内力值"}--欧阳克
	Tier[62] = {"五轮大转自带专精效果","内力生命上限提高1000","十层龙象"}--金轮法王
	Tier[63] = {"玉箫剑法范围变为面，威力提高1000","生命50%以下，受到的最终伤害减少50%","玉箫剑法自带专精效果，杀内提高"}--程英
	Tier[64] = {"修炼秘籍时，攻防轻+1","空明拳威力提高800，必定命中","九阴神功自动运功"}--周伯通
	Tier[65] = {"一阳指攻击后恢复10%已损失生命值","一阳指、六脉神剑不消耗内力","先天功自动运功"}--一灯
	Tier[66] = {"圣火神功自动主运，圣火神功攻击必定击中破绽","回合后集气从300开始","圣火神功必连击必暴击"}--小昭
	Tier[67] = {"铁掌威力加倍","轻功提高100，铁掌变为面攻","铁掌最终伤害提高240"}--裘千仞
	--Tier[68] = {"全真剑法","轻功提高100，铁掌变为面攻","铁掌伤害提高300"}--丘处机
	Tier[69] = {"打狗棍法，降龙十八掌范围+3","阴阳内属等级各加3","内力上限提高2000"}--洪七公
	Tier[70] = {"般若掌威力加倍","内力上限提高3000","受到的最终伤害减少300"}--玄慈
	
	--Tier[71] = {"受到伤害减少15%","伤害提高15%",""}--洪安通
	--Tier[70] = {"般若掌威力加倍","内力上限提高4000","受到的伤害减少200"}--玄慈
	Tier[73] = {"【七弦无形剑气】伤害提高100","【七弦无形剑气】伤害提高150","【七弦无形剑气】伤害提高200"}--任盈盈
	--Tier[75] = {"百花错拳","内力上限提高4000","受到的伤害减少200"}--陈家洛
	Tier[76] = {"所有武功威力提高30%","每修炼一个武功，伤害提高5%","武学组合需求-2"}--王语嫣
	Tier[77] = {"鸳鸯刀法、夫妻刀法威力加倍，范围+3","最终伤害提高200","受到的最终伤害减少200"}--萧中慧
	Tier[78] = {"九阴白骨爪最终伤害提高200","受到的伤害减少25%","九阴白骨爪攻击生命值低于25%的敌人最终伤害提高2000"}--梅超风
	Tier[79] = {"剑法威力提高30%","剑法威力提高30%","第一格武功威力提升所有习得的其它剑法基础威力之和"}--岳灵珊
	Tier[80] = {"柔云剑法威力加倍","太极拳、太极剑法威力提高1000","太极推手攻击后效果不清除"}--张召重
	
	Tier[81] = {"暴击伤害提高30%，暴击几率提高10%","暴击伤害提高40%，暴击几率提高10%","暴击伤害提高40%，暴击几率提高10%"}--朱九真
	Tier[82] = {"绵掌不消耗内力，威力提高300","绵掌不消体力，威力提高300","变为面攻，威力提高300，连击率提高30%"}--宋青书
	Tier[83] = {"五毒神掌威力加倍","被攻击使攻击者中毒损失最大生命值5%","行动后可以使用暗器毒蟾砂"}--何铁手
	Tier[85] = {"五行六合掌自带专精效果","易筋经自动运功","受到攻击恢复200点生命"}--贝海石
	Tier[88] = {"闪避几率提高15%","闪避几率提高15%","闪避几率提高15%"}--祖千秋
	Tier[89] = {"奇门三才到威力三倍","时序回复体力值一半的内力","时序回复体力值一半的生命"}--人厨子
	Tier[90] = {"装备闪电貂，攻击会使敌方持续损失生命值，且中毒不会恢复","最终伤害提高100，【灵貂】指令使敌方中剧毒持续损失生命值","受到的最终伤害减少20%，闪避几率提高20%，集气速度提高20%"}--钟灵
	
	Tier[91] = {"暴击会造成最大生命值5~20%的伤害","雷震剑法专精效果提高","连击暴击率提高50%"}--温青青
	Tier[97] = {"自身免疫流血伤害，时序流血伤害+5","所有人流血的伤害同时转化为自身生命回复","流血伤害加倍"}--血刀老祖
	Tier[103] = {"火焰刀范围+2，威力提高300","50%几率免疫非连击伤害，五系兵器值+100，内力上限提高2000","小无相功自带运功，小无相功反击伤害提高200"}--鸠摩智
	Tier[106] = {"五虎断门刀威力加倍","五虎断门刀自带专精效果","五虎断门刀无视气防"}--王元霸
	Tier[112] = {"受到的最终伤害减少10%","所有武功威力提高1000，五系兵器值+100","不再走火入魔，行动前50%概率进入杀破狼状态"}--萧远山
	Tier[113] = {"斗转星移自带专精效果","星云剑气威力提高1000，范围+3","武学常识增加200，受到的最终伤害减少20%"}--慕容博
	Tier[114] = {"受到的最终伤害减少100","少林武功威力提高1000","攻击自身一格范围内的敌人，造成三倍最终伤害"}--扫地
	Tier[115] = {"琴棋书画必连击，范围+2","琴棋书画必暴击","琴棋书画威力加倍"}--苏星河
	Tier[116] = {"凌波微步自动运功","北冥神功自动运功，且自带专精","天山六阳掌威力提高800，全屏攻击"}--无崖子
	Tier[117] = {"时序回复8点内力，6点生命，1点体力","八荒六合功自动运功","受到的单次伤害不会超过最大生命值15%"}--童姥
	Tier[118] = {"白虹掌力范围+5","小无相功自动运功","攻击伤害不会低于最大生命值10%"}--李秋水
	
	Tier[129] = {"全真剑法威力提高1000，一阳指威力提高600","先天功自动运功且自带专精效果","【北斗七闪】状态伤害提高100%"}--王重阳
	Tier[130] = {"1点集气速度提高10武功威力","攻击带毒100点","1点集气速度提高10武功威力"}--柯镇恶
	Tier[147] = {"自带【齐心协力】效果","分筋错骨手变为面攻，分筋错骨手攻击敌方持续集气紊乱","桃谷六仙都有觉醒一二阶效果"}--桃花仙
	Tier[149] = {"须弥山神掌自带专精效果","易筋神功自动运功","生命上提高1000，内力上限提高3000"}--方证
	Tier[151] = {"拳掌威力提高500","连击率提高50%","奔雷手文泰来"}--文泰来
	Tier[153] = {"暗器+80，上限+80","暗器+80，暗器上限+80","暗器+80，暗器上限+80，【回龙璧】几率变成【飞燕银梭】，造成双倍伤害"}--赵半山
	Tier[160] = {"最终伤害提高30%","受到的最终伤害减少30%","受到的最终伤害减少40%，免疫杀气"}--达尔巴
	Tier[161] = {"五毒神掌威力加倍","天罗地网自动运功","玉女心经自动运功"}--李莫愁
	Tier[164] = {"弹指神通、碧针清掌威力提高800","移动、攻击范围+1，敌方攻击、移动范围-1","攻击附带5%当前内力值最终伤害"}--谢烟客
	
	Tier[171] = {"防御效果提高100%，太极拳，太极剑法威力提高1000","防御状态时，每次受到攻击使攻击最终伤害减少10%","太极拳，太极剑法自带专精效果"}--宋远桥
	
	--Tier[184] = {"铁血十二式威力+300","铁血十二式变为面攻","闪避后，集气提高300"}--玉真子
	--Tier[185] = {"狂风快剑威力加倍","狂风快剑自带专精效果","必定三连击，混元功自动运功自带专精效果"}--穆人清
	Tier[186] = {"拳掌威力提高50%","进入战斗，拳掌系数加倍","拳掌附带的额外伤害加倍"}--归辛树
	Tier[420] = {"生命上限提高10%","生命上限提高10%，受到的最终伤害减少15%","生命上限提高10%，攻击额外造成自身生命值5%的最终伤害"}--大雪怪
	
	Tier[601] = {"特效几率+20%，且有二次判定","所有敌方15%概率不会行动","火枪范围+10，威力提高3000"}--韦小宝
	
	Tier[626] = {"桃花三绝威力提高1000","瑜伽秘乘自动运功","【诸天化身步】几率和伤害提高"}--郭襄
	Tier[631] = {"倚天剑法威力提高1000","九阴白骨爪威力提高2000","九阴神功自动运功"}--周芷若
	Tier[646] = {"自身时序增加5点中毒，中毒值越高，千蛛万毒手威力越高","自身中毒越高，集气越快","中毒的敌人最终伤害减半，时序损失生命值"}--殷离
	
	Tier[670] = {"五系兵器值+50","五系兵器值+50","五系兵器值+50"}--雷震
	Tier[671] = {"每习得一个剑法，剑法上限提高20，修炼剑法剑系数+1","剑法攻击，最终伤害提高剑系数的20%","天剑"}--无名
	Tier[673] = {"专属武功威力提高1000","进入战斗怒气值100","拳掌系数+300"}--豪鬼
	Tier[672] = {"触发神照免死几率提高","无影神拳伤害几率增加","免疫杀气，被攻击集气速度提高"}--丁典
	
	Tier[677] = {"自带【主角光环】","所有武功最终威力提高50%","真野球拳伤害提高"}--小虾米	
	
	Tier[688] = {"龙啸穿云枪威力提高800，双向攻击","集气速度提高20，闪避几率提高12%","前七次行动后用龙啸穿云枪攻击所有敌人"}--赵云
	
	Tier[685] = {"无","炼化的角色觉醒阶级和左慈觉醒阶级保持一致","被攻击几率召唤一个分身战斗"}--左慈
	Tier[689] = {"元素等级各+1，防御力的3%和内力最大值的0.2%转化为护甲","元素等级各+1，受到的最终伤害用DOTA2计算公式再减少一次","元素等级各+1，选择一个元素等级额外+1"}--卡尔
	Tier[693] = {"攻击可以获得一定怒气，进入战斗有时会播放专属BGM","行动前被攻击增加集气速度","反弹20%攻击伤害给所有敌方，沉默攻击者"}--铁拳
	Tier[694] = {"每闪避、雷击或者【祝由】一次，集气速度提高3","行动后有几率和一个角色交换集气位置","进入战斗，雷击所有敌方，【祝由】自己"}--张角
	
	Tier[1000] = {"拳掌最终伤害提高100","拳掌大招最终伤害提高50%","拳法根据敌方已损失生命值最多提高200%最终伤害"}--拳
	Tier[1001] = {"指法范围+2","指法大招概率提高","指法攻击概率击中死穴，造成五倍最终伤害"}--指法
	Tier[1002] = {"剑法威力提高500","剑法大招杀气提高2500","剑法攻击后回气500"}--剑法
	Tier[1003] = {"耍刀技巧提高100，上限提高100","受到的最终伤害减少20%，被攻击获得的怒气+10","刀法暴击伤害提高100%"}--刀法
	Tier[1004] = {"集气速度+10，移动范围+1，攻击范围+1","闪避后，集气提高200","必出大招"}--奇门
	Tier[1005] = {"气防+1000","内力上限提高3000","阴阳内属等级各加4"}--天罡
	Tier[1006] = {"受到的单次伤害不会超过（200+当前生命值20%）","所有敌方15%概率攻击落空","所有敌方连击率减半"}--仁
	Tier[1007] = {"时序回复2点体力，最终伤害提高医疗技巧/2","医疗不消耗体力，医疗效果提高100%","行动结束后概率医疗自己同时集气值提高300"}--医
	Tier[1008] = {"用毒会使敌方损失当前生命值15%","所有敌方时序增加3中毒","大招引爆所有敌方的毒素，造成中毒值五倍的伤害和300点杀集气"}--毒
	
	
	SkillT = {
	{155,105,"根骨上佳 ：攻防轻上限+20，造成的伤害提高6%",9,6,32,31,{nil},0,60},--1
	{71,206,"猛虎之拳 ：攻击杀气提高200，造成的最终伤害提高30",1,4,24,3,{1},1,90},--2
	{240,206,"剑道 ：攻击20%概率无视闪避，攻击必流血，装备武器时，武功威力提高200",31,5,2,14,{1},1,180},--3
	{71,308,"宁静致远 ：连击率+5%，攻击范围增加1，阴阳内属等级各加1",2,8,38,6,{2},1,160},--4
	{240,308,"新发于硎 ：暴击率+5%，攻击无视35%的防御，敌人的防御无效且承受25%额外伤害",3,34,6,16,{3},2,220},--5
	{155,308,"狂影：攻击强制杀气，数值为威力的十分之一，受到攻击获得的怒气+15",1,33,4,5,{nil},4,260},--6
	{298,491,"冥昭瞢暗 ：暴击连击率+10%，所有角色攻击范围+1，所有误伤造成全额伤害",34,10,8,17,{34},0,270},--7
	{114,491,"龙魂 ：攻击杀气提高500，66%概率杀气再提高500并附带额外范围",4,9,26,7,{4,6},5,250},--8
	{114,593,"无情猛袭 ：攻击20%概率无视闪避，攻击附带目标5%已损失生命值伤害，连击伤害随连击数提高",8,1,28,10,{8},6,350},--9
	{240,593,"妄念 ：攻击最终伤害提高25%，击退敌方会将其复活为友方，血内为30%",33,31,9,20,{9},9,400},--10
	
	{355,105,"生机勃勃 ：生命最大值提高12%，吃药效果提高40%",20,16,31,12,{nil},0,150},--11
	{522,105,"内力浑厚 ：内力最大值提高500，气防提高500",40,13,11,21,{nil},0,120},--12
	{522,206,"内劲不息：气防提高1000，时序回复已损失内力的1%",12,15,14,22,{12},2,260},--13
	{441,206,"金钟罩 ：受到的最终伤害减少12%",19,35,3,13,{nil},2,200},--14
	{522,308,"睡梦罗汉 ：12%概率闪避攻击",13,40,16,25,{nil},2,180},--15
	{355,308,"固若金汤 ：进入战斗获得200护盾，免疫破绽",11,17,5,15,{11},3,220},--16
	{388,491,"以攻为守 ：暴击连击率+10%，根据造成的伤害形成护盾免疫伤害",16,19,7,40,{7},7,440},--17
	{585,491,"灵动跃进 ：初始集气位置提前，最终集气速度提高20，闪避后集气上升300",36,30,40,26,{26},8,460},--18
	{441,593,"先天罡气 ：每25时序免疫一次攻击伤害，受到的最终伤害减少50",35,14,20,30,{35},8,390},--19
	{355,593,"菱镜 ：受到的攻击伤害反弹15%给所有敌方，30%反弹给攻击者",17,11,10,19,{19},10,430},--20
	
	{732,105,"吉人天相 ：特效几率提高4%",29,23,12,32,{nil},0,50},--21
	{647,206,"诡秘莫测 ：攻击20%几率不造成怒气，攻击20%概率冰封，灼烧，中毒或内伤",26,25,13,23,{21},1,170},--22
	{732,206,"毒术 ：攻击25%几率无视闪避，攻击带毒加100，用毒解毒上限加100，时序解毒加3",21,37,22,24,{21},1,180},--23
	{815,206,"透骨打穴 ：攻击20%几率无视闪避，攻击25%概率封穴，攻击被封穴的敌人伤害提高8%",32,38,23,2,{21},1,170},--24
	{647,308,"蜻蜓点水 ：6%概率闪避攻击，移动范围+2",22,26,15,37,{22},2,180},--25
	{647,491,"神出鬼没 ：行动后可以移动，6%概率闪避攻击，最终集气速度提高10",25,29,18,8,{25},5,280},--26
	{815,412,"勇往直前 ：集气不会暂停，最低为30，行动前集气速度会越来越快",38,28,39,33,{38},6,330},--27
	{815,593,"落井下石 ：被封穴的敌人集气会慢速倒退，攻击被封穴的敌人伤害提高35%",27,32,29,9,{27},9,420},--28
	{732,593,"大难临头 ：攻击被冰封/灼烧/中毒/内伤的敌人，必定击中破绽且伤害杀气提高30%",39,21,30,28,{39},6,340},--29
	{585,593,"祸乱 ：攻击和被攻击对全体敌方造成冰封，灼烧，中毒和内伤，根据攻击者状态，削弱敌方",18,36,19,29,{29},9,470},--30
	
	{240,105,"劲力狂增 ：每时序伤害增加1",10,3,1,11,{nil},0,250},--31
	{815,105,"步履轻盈 ：最终集气速度增加5，5%概率闪避攻击，移动范围+1",28,24,21,1,{nil},0,160},--32
	{199,412,"无坚不摧 ：暴击伤害+20%，伤害增加100",6,8,27,34,{nil},5,320},--33
	{298,412,"嗜血成性 ：暴击连击率+9%，造成的伤害6%转化为生命回复",5,7,33,35,{5,16},4,300},--34
	{441,412,"以静制动 ：被攻击概率使敌方停止攻击，转为防守，受到的连击伤害减少20%",14,19,34,36,{14,15,16},5,320},--35
	{585,412,"惊岚步 ：闪避攻击后打断连击，使攻击者下回合集气减少200",15,18,35,39,{15,25},6,330},--36
	{732,308,"先发制人 ：进入战斗，所有敌方受到冰封，灼烧，中毒和内伤，生命减少10%",23,39,25,38,{23},4,290},--37
	{815,308,"后发制人 ：受到攻击使攻击者受到5-10点封穴",24,27,37,4,{24},3,290},--38
	{732,412,"心神不宁 ：敌方第一次行动不能攻击",37,29,36,27,{37},6,400},--39
	{522,491,"止息 ：敌方不能连击",15,12,17,18,{nil},8,680},--40
	}
	STType = {
	{1,2,4,6,8,9,10,3,5,31},--2170
    {1,2,4,6,8,9,10,11,16},--1920
    {1,2,4,6,8,9,10,12,13},--1960
    {1,2,4,6,8,9,10,21,22},--1830
    {1,3,5,11,16,34,7,17,31},--1980
    {1,3,5,11,16,34,7,17,1,3},--1970
    {1,3,5,11,16,34,7,17,21,24},--1990
    {1,3,5,11,16,34,7,17,14,15},--2140
    {8,39,15,19,9,7,37},--2260
    {11,16,14,15,35,19,20,1,2,6},--2250
    {11,16,14,15,35,19,20,31,1},--2120
    {21,22,25,26,18,15,22,36},--1870
    {21,22,25,26,18,31,33},--1690
    {21,22,25,26,18,11,16,1,2,3},--1800
	{11,12,13,14,15,16,1,2,3},
	{11,12,13,14,15,21,22,23},
    {21,23,37,39,29,30,22},--2170
    {21,23,39,29,30,14,11,16},--2120
    {21,23,37,39,29,30,24,38},--1980
	{31,1,12,13,21,23,3,5,13,22},
	{11,1,12,13,21,23,3,5,13,22},
    {21,24,7,27,28,1,2,3,4,5},--1840
    {21,24,9,27,28,31,14,1,2,4},--1890
    {21,24,8,27,28,12,13,1,11,16},--1930
    {1,2,3,33,14,33,21,24},--1780
    {1,31,14,15,33,15,40,16},--1780
	
	}
	ZJINS = {
		"被攻击几率会使用睡梦罗汉拳反击，并闪避",
		"攻击范围+2，攻击后可以移动6格",
		"强制上毒50，攻击带毒+50",
		"攻击使敌人盲目",
		"必冰封，并使敌人集气速度减少30%，10时序",
		"范围+5",
		"无视70%防御",
		"威力+600，必冰封必灼烧",
		"变成面功，气功+1000",
		"无视闪避，威力+500",
		"无视50%防御，威力+300",
		"御剑+30 拳掌+30",
		"强制杀气150至250",
		"范围+3，拳掌+30，指法+30",
		"无视35%防御，受到的拳法指法伤害减少35%",
		"受到拳指攻击，反弹35%伤害，其它攻击反弹15%",
		"范围+3，必封穴",
		"气功+1200，必封穴，攻击距离+3",
		"范围+2，必冰封，必封穴，强制中毒50",
		"气功+3000",
		
		"必定触发极意，攻击带毒+100",
		"无视气防",
		"范围+2，招式几率提高",
		"范围+3，必连击",
		"攻击范围+1，无使用限制，伤害提高25%",
		"攻击范围+1，必定极意，主运擒龙功必定三连",
		"攻击范围+3，攻击不产生怒气",
		"攻击造成闪电随机攻击敌方",
		"所有武功攻击范围+1，三分剑法无冷却，威力+500",
		"同时锁定自身周围7格攻击",
		"防御+30，使用后20时序气防+1800",
		"御剑+30，使用后20时序集气速度+13",
		"范围+3，必冰封",
		"威力+300，必暴击",
		"威力+300，攻击范围可移动，必冰封",
		"受到非拳指攻击，伤害减少20%",
		"攻击力+40，防御力+40，受到的伤害减少40",
		"范围+2，必连击",
		"必连击，必暴击",
		"必暴击，威力+300",
		
		"伤害提高25%，装备倚天剑伤害再提高25%",
		"必连击，连击伤害提高30%",
		nil,
		"威力+800",
		"范围+1，无视50%防御",
		"受到刀剑奇攻击，反弹30%伤害，其它攻击反弹15%",
		"御剑上限+100",--48
		"攻击+30，集气速度+10，剑法附带集气速度的伤害",--辟邪
		"范围+1，所有指法威力提高10%，御剑+30，指法+50",
		"威力+600，必定三连",
		"33%几率全屏攻击",
		"伤害提高50%",
		"防御+30，使用后10时序不动如山",
		"所有刀法威力+250",
		"所有刀法气功+1100",
		"攻击力+20，防御力+20，轻功+20",
		"攻击造成虚弱状态",
		"范围+4",
		"暴怒必定五连击",
		"攻击力+40，防御力+40，受到的伤害减少40",
		
		"必灼烧，必暴击",
		"所有刀法范围+2",
		"威力提高700，免疫流血",
		"15%几率免疫伤害",
		"所有刀法必灼烧、必暴击",
		"攻击力+50，刀法+50，拳掌+50",
		"威力+600，50%几率极意",
		"所有武功范围+2",
		"威力+1000",
		"所有武功气功+1000",
		"奇门+50",
		"威力+500",
		"威力+700",
		"威力+300，必击中破绽",
		"暴怒时攻击造成三倍伤害",
		"范围+10",
		"剑法+40，刀法+40，奇门+40",
		"范围+1，攻击定身敌方",
		"伤害减少60%，全屏攻击",
		"攻击使敌方集气减少40%，持续10时序",
		
		"装备蛇杖威力+800，攻击带毒+100",
		"所有敌方攻击范围-1",
		"无视气防",
		"范围+2，威力+300",
		"可以吸血，时序吸取所有敌方内力最大值1%，内力不足则吸10血",
		"伤害提高33%，必暴击",
		"额外化去目标当前10%内力",
		"所有武功范围+1，额外吸取2~3点体力",
		"攻击强制杀气100，暴怒时加倍",
		"生命上限提高15%",
		nil,
		"攻击时全体敌方受到50点伤害",
		"攻击后可移动范围+3，击中破绽的伤害提高15%",
		"拳掌攻击15%几率触发无影神拳",
		"蓄力下回合集气+300",
		"受到的伤害减少15%，时序回复2点生命",
		"额外反弹攻击者且伤害+100",
		"五系兵器值+20，反击不需要运功",
		"受到的伤害减少20%",
		"阴阳内属等级+1，时序回复4内、2血、1体",
		
		"时序回复5点生命内力",
		"可以用太玄神功攻击，太玄之重和太玄之轻有主运一半几率触发",
		"伤害提高25%",
		"暴击伤害提高20%",
		"集气速度提高20%",
		"内力上限+2500",
		"武学常识+70",
		"受到的伤害减少15%，伤害提高15%",
		"威力+1000",
		"威力+1000",
		"威力+1000",
		"威力+1000",
		nil,
		"范围+3，必连击",
		"攻击造成目标时停8时序",
		"威力+1000",
		"威力+800",
		"无视70%防御，威力+400",
		"威力+700",
		"所有拳掌必暴击，必冰封",
		
		"范围+6，必封穴",
		"范围+4，必暴击",
		"敌方有10%几率在被攻击时被释放噬魂",
		"威力+800",
		"范围+4，无视闪避",
		"威力+500，范围变为面",
		"威力+700，必封穴",
		"所有指法伤害提高10%",
		"轻功+40，移动范围+4，可突破上限",
		"范围+4",
		"范围改变，威力+500",
		"所有指法必连击、必封穴、威力+400",
		"范围变为面，气功+1500",
		"根据攻击伤害转化为护盾",
		"无视气防",
		"必暴击，必灼烧，无视闪避，附带200额外伤害",
		"威力+400，不造成怒气",
		"范围+3",
		"威力+300，必连击",
		"范围改变，气功+1000，无误伤，追加120真伤",
		
		"所有刀法强制杀气150",
		"威力+800",
		nil,
		"受到的伤害减少10%+100",
		"下回合集气+150",
		"集气速度+10",
		"8%几率闪避",
		"攻击范围+1",
		"移动范围+3",
		"暴怒集气速度再提高15%",
		nil,
		nil,
		"威力+600，阴内等级+3",
		"所有武功必连，古墓派武功威力+200",
		"无视60%防御",
		"攻击时，敌方御剑按0计算",
		"范围+5",
		"根据轮子随机造成五种效果",
		"受到攻击会获得双倍怒气",
		"暴怒时第一击攻击全屏，伤害提高",
		
		"威力+100，必连击",
		"必三连击",
		"五倍流血伤害",
		"威力+300，所有奇门有25%几率定身",
		"奇门+50",
		"攻防轻+30",
		nil,
		nil,
		"主运免疫杀气",
		"直接引爆紫气天罗",
		"受到攻击反弹15%的伤害，回复15%伤害值的生命",
		nil,
		nil,
		"所有刀法必冰封，必连击",
		"五岳剑法威力+500",
		"刀刀烈火",
		"无视防御提高到50%",
		"轻功+30，集气速度+2",
		"轻功+30，移动范围+2",
		"集气速度+3，伤害提高10%",
		
		"免疫攻击时序提高到20",
		nil,
		"威力+500，强制中毒50，攻击带毒+100",
		"范围+1，威力+500，无视闪避",
		"必定三连击",
		"第一击回复内力消耗25%的生命",
		"伤害+10",
		"敌方攻击范围-1",
		"装备圆月弯刀，威力+900，使用不减生命上限",
		nil,
		nil,
		nil,
		"第二击也能杀内",
		"伤害+100",
		nil,
		"威力+500，每本天书+100",
		"必连击",
		"每一剑伤害+0.07",
		"无冷却",
		nil,
		
		"强制杀气，随阴内等级提高",
		nil,
		nil,
		nil,
		nil,
		"威力+500，内力上限提高1500",
		"阴内等级+3",
		"100%触发涯角枪特效",
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		"所有刀法范围和霹雳刀法相同、威力+300",
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		"范围+3",
		"效果持续时间加倍",
		"范围变宽，距离变长",
		"杀内量提高30%，范围+1",
		"伤害加成效果提升100%",
		"必定三连，冷却额外-1",
		nil,
		"熔炉精灵属性提高，并且教会它一个随机法术",
		"范围变为正方形",
		nil,--235
		nil,
		"主运伤害杀内提高到450，杀体力提高到10",
		nil,
		"威力+500，必定触发【天人五衰】",
		}
	--实战经验
	WARSZJY = {3, 2, 5, 2, 40, 15, 5, 5, 5, 5, 5, 5, 5, 5, 3, 2, 2,
	10, 5, 4, 4, 5, 4, 2, 2, 20, 40, 2, 3, 3, 3, 3, 3, 3, 5, 3, 4, 4,
	8, 8, 4, 4, 4, 4, 2, 5, 3, 4, 3, 30, 4, 2, 3, 3, 4, 4, 15, 5, 5,
	15, 3, 15, 3, 15, 10, 2, 8, 3, 15, 7, 8, 3, 3, 3, 4, 2, 2, 2, 2,
	4, 2, 2, 2, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 7, 7, 4, 4, 2,
	2, 12, 2, 2, 2, 3, 3, 3, 3, 3, 7, 7, 50, 3, 3, 5, 6, 3, 3, 3, 3,
	3, 3, 3, 3, 3, 3, 20, 3, 3, 3, 3, 3, 3, 3, 2, 3, 2, 35, 2, 2, 2,
	2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
	3, 3, 3, 3, 3, 4, 3, 4, 4, 4, 2, 2, 2, 2, 2, 2, 2, 3, 7, 7, 4, 3, 5, 5, 3}
	--称号
	RWWH = {}
	RWWH[1] = "雪山飞狐"
	RWWH[2] = "灵枢素问"
	RWWH[3] = "金面佛"
	RWWH[4] = "雁过拨毛"
	RWWH[5] = "太极宗师"
	RWWH[6] = "灭绝师太"
	RWWH[7] = "铁琴先生"	--何太冲
	RWWH[8] = "崆峒掌门"	--唐文亮
	RWWH[9] = "九阳明尊"
	RWWH[10] = "光明右使"
	RWWH[11] = "光明左使"
	RWWH[12] = "白眉鹰王"
	RWWH[13] = "金毛狮王"
	RWWH[14] = "青翼蝠王"
	RWWH[15] = "紫衫龙王"
	RWWH[16] = "蝶谷医仙"
	RWWH[17] = "蝶谷毒仙"
	RWWH[18] = "混元霹雳手"
	RWWH[19] = "君子剑"
	RWWH[20] = "潇湘夜雨"
	RWWH[21] = "恒山掌门"
	RWWH[22] = "嵩山掌门"
	RWWH[23] = "泰山掌门"
	RWWH[24] = "青城掌门"
	
	RWWH["24"] = "松风剑神"
	
	RWWH[25] = "五毒教主"
	RWWH[26] = "日月魔帝"
	RWWH[27] = "风云再起"
	RWWH[28] = "杀人名医"
	RWWH[29] = "万里独行"
	RWWH["29"] = "狂风刀神"
	RWWH[30] = "傻小子"
	RWWH[31] = "梅庄四友"
	RWWH[32] = "梅庄四友"
	RWWH[33] = "梅庄四友"
	RWWH[34] = "梅庄四友"
	RWWH[35] = "九剑传人"
	RWWH["35"] = "剑魔再临"
	RWWH[36] = "辟邪剑客"
	RWWH[37] = "真名神照"
	RWWH["38"] = "混沦太玄"
	RWWH[39] = "侠客岛主"
	RWWH[40] = "侠客岛主"
	RWWH[41] = "赏善使者"
	RWWH[42] = "罚恶使者"
	RWWH[43] = "雪山掌门"
	RWWH[44] = "凶神恶煞"
	RWWH[45] = "阎王敌"
	RWWH[46] = "星宿老怪"
	RWWH[47] = "曼珠沙华"
	RWWH[48] = "铁面侠"
	RWWH[49] = "小和尚"
	RWWH["49"] = "逍遥掌门"
	RWWH[50] = "狂龙天征"
	RWWH[51] = "姑苏慕容"
	RWWH[52] = "中平神枪"
	RWWH[53] = "六脉真传"
	RWWH[54] = "碧血长风"
	RWWH[55] = "侠之大者"
	RWWH[56] = "兰质蕙心"
	RWWH[57] = "桃花岛主"
	RWWH[58] = "西狂"
	RWWH[59] = "冷若天仙"
	RWWH[60] = "西毒"
	RWWH[62] = "元蒙帝师"
	RWWH[63] = "青箫落瑛"
	RWWH[64] = "顽童武痴"
	RWWH[65] = "南僧"
	RWWH[66] = "波斯圣女"
	RWWH[67] = "铁掌帮主"
	RWWH[68] = "长春子"
	RWWH[69] = "北丐"
	RWWH[71] = "神龙教主"
	RWWH[72] = "天龙掌门"
	RWWH[73] = "日月圣姑"
	RWWH[74] = "翠羽黄衫"
	RWWH["74"] = "手刃陈哥"
 	RWWH[75] = "天池红花"
	RWWH[76] = "琅嬛仙子"
	RWWH[77] = "秀外慧中"
	RWWH[78] = "铁尸魔煞"
	RWWH[79] = "慧中灵剑"
	RWWH[80] = "火手判官"
	RWWH[81] = "雪岭双姝"
	RWWH[82] = "玉面孟尝"
	RWWH[83] = "五毒教主"
	RWWH[84] = "吾乃蛮夷"
	RWWH[85] = "老谋深算"
	RWWH[86] = "金枝玉叶"
	RWWH[87] = "媚眼如丝"
	RWWH[88] = "酒神"
	RWWH[89] = "食神"
	RWWH[90] = "毓秀灵姝"	
	RWWH[91] = "青青子衿"
	RWWH[92] = "仙剑奇侠"
	RWWH[94] = "仁义刀"
	RWWH[95] = "柔云剑"
	RWWH[96] = "冷月剑"
	RWWH[97] = "血刀老祖"
	RWWH[98] = "恶贯满盈"
	RWWH[101] = "笔砚生"
	RWWH[102] = "天龙禅师"
	RWWH[103] = "大轮明王"
	RWWH[104] = "云舞霓裳"
	RWWH[105] = "琴韵温香"
	RWWH[106] = "金刀无敌"
	RWWH[112] = "震天魔狼"
	RWWH[113] = "参合潜龙"
	RWWH[114] = "达摩再世"
	RWWH[115] = "聪辩先生"
	RWWH[116] = "风月无间"
	RWWH[117] = "不老长春"
	RWWH[118] = "秋水无尘"
	RWWH[129] = "中神通"
	RWWH[131] = "妙手书生"
	RWWH[138] = "一指震江南"	--瓦尔拉齐
	RWWH[140] = "剑术通神"		--风清扬
	RWWH[142] = "狂风快剑"
	RWWH[149] = "少林掌门"
	RWWH[153] = "暗器之王"
	RWWH[154] = "鸳鸯刀"
	RWWH[157] = "湘西尸王"
	RWWH[158] = "波斯大贾"
	RWWH[159] = "瑜伽鬼王"
	RWWH[160] = "尊师重道"		--达尔巴
	RWWH[161] = "赤练仙子"
	RWWH[164] = "摩天居士"
	RWWH[170] = "四大神僧"
	RWWH[171] = "武当儒侠"
	RWWH[185] = "神剑仙猿"
	RWWH[186] = "神拳无敌"
	RWWH[189] = "仁者无敌"
	RWWH[597] = "物我两忘"	
	RWWH[459] = "丐帮帮主"
	RWWH[553] = "真田一之兵"
	RWWH[589] = "铃剑侠女"		--水笙
	RWWH[590] = "古道西风"		--李文秀
	RWWH[592] = "无我无剑"		--独孤求败
	RWWH[594] = "铁索横江"		--戚长发
	RWWH[601] = "天魁地宝"		--韦小宝
	RWWH[602] = "大内总管"		--海大富
	RWWH[603] = "满洲勇士"		--鳌拜
	RWWH[604] = "越女剑仙"		--阿青
	RWWH[605] = "姑射仙姿"		--林朝英
	RWWH[606] = "西域战神"		--阿凡提
	RWWH[607] = "乱世浮萍"		--焦宛儿
	RWWH[609] = "绍敏郡主"		--赵敏
	RWWH[616] = "绝情谷主"		--公孙止
	RWWH[617] = "铁掌莲花"		--裘千尺
	RWWH[626] = "小东邪"		--郭襄
	RWWH["626"] = "峨眉祖师"
	RWWH[627] = "上帝之鞭"		--蒙哥
	RWWH[628] = "雕兄"			--神雕
	RWWH[629] = "长平公主"		--阿九
	RWWH[631] = "谁与争锋"		--周芷若
	RWWH[635] = "天池怪侠"		--袁士霄
	RWWH[642] = "精心打磨"		--四大山
	RWWH[643] = "八臂神剑"		--阿大
	RWWH[644] = "天生神力"		--阿二
	RWWH[645] = "金刚伏魔"		--阿三
	RWWH[647] = "玄冥二老"		--鹤笔翁
	RWWH[648] = "玄冥二老"		--鹿杖客
	RWWH[649] = "娇美人妻"		--宁中则
	RWWH[650] = "小王爷"		--杨康
	RWWH[651] = "影帝"			--张家辉
	RWWH[653] = "龙骑士"		--尹志平
	RWWH[655] = "仙剑奇侠"		--李逍遥
	RWWH[656] = "明夕何夕"		--赵灵儿
	RWWH[657] = "生死别离"		--林月如
	RWWH[658] = "一往情深"		--阿奴
	RWWH[669] = "武侠大师"		--金先生
	RWWH[670] = "异世奇侠"      --雷震
	RWWH[681] = "风中之神"
	RWWH[682] = "不哭死神"
	RWWH[683] = "剑神"
	RWWH[684] = "小李探花"
	RWWH[685] = "迷之仙人"
	RWWH[693] = "不朽铁拳"
	RWWH[694] = "大贤良师"
	RWWH[686] = "二爷"
	RWWH[687] = "大理太祖"
	RWWH[688] = "虎威将军"
	RWWH[689] = "祈求者"
	RWWH[691] = "刀神"
	RWWH[692] = "武状元"
	RWWH[634] = "开派祖师"
	RWWH[637] = "九阴至尊"
	RWWH[638] = "九阳至尊"
	RWWH[636] = "谪仙人"
	
	
	RWWH["671"] = "武林神话"      --无名
	RWWH[672] = "菊花剑客"      --丁典
	RWWH[673] = "拳之极者"      --豪鬼
	RWWH[675] = "中华英雄"      --华英雄
	RWWH[676] = "奈非天" 
	RWWH["677"] = "一代传奇"
	RWWH[678] = "侠探"
	RWWH[420] = "雪山灵兽"

	--天赋
	RWTFLB = {}
	RWTFLB[1] = "魂系一刀"
	RWTFLB[3] = "打遍天下"
	RWTFLB[4] = "跌打医生"
	RWTFLB[9] = "运转乾坤"
	RWTFLB[24] = "剑掌双绝"
	RWTFLB[35] = "灵奇洒脱"
	RWTFLB[36] = "血海深仇"
	RWTFLB[37] = "赤心连城"
	RWTFLB[38] = "名相皆无"
    RWTFLB[39] = "威震中原"	
    RWTFLB[40] = "威震中原"		
	RWTFLB[48] = "冰蚕毒掌"
	RWTFLB[49] = "福缘深厚"
	RWTFLB[50] = "奋英雄怒"
	RWTFLB[51] = "离合参商"
	RWTFLB[53] = "磊落仁心"
	RWTFLB[54] = "志垂日月"
	RWTFLB[55] = "大器晚成"
	RWTFLB[56] = "奇门遁甲"
	RWTFLB[58] = "逆流勇进"
	RWTFLB[59] = "一片冰心"
	RWTFLB[60] = "倒行逆施"
	RWTFLB[63] = "外和内刚"
	RWTFLB[64] = "返璞归真"
	RWTFLB[73] = "琴铮盈盈"
	RWTFLB[74] = "巾帼之才"
	RWTFLB[76] = "武中无相"
	RWTFLB[77] = "珠联璧合"
	RWTFLB[80] = "勇猛精进"
	RWTFLB[83] = "纤纤铁手"
	RWTFLB[85] = "久病成医"
	RWTFLB[92] = "泪梦魂牵"
	RWTFLB[97] = "借刀杀人"
	RWTFLB[646] = "千蛛万毒"
	RWTFLB[102] = "双树枯荣"
	RWTFLB[112] = "天威奋烈"
	RWTFLB[116] = "北冥极渊"
	RWTFLB[117] = "转瞬红颜"
	RWTFLB[118] = "无相转身"
	RWTFLB[153] = "千臂如来"
	RWTFLB[553] = "赤胆忠魂"
	RWTFLB[589] = "似水柔情"	--水笙
	RWTFLB[590] = "心秀天铃"		--李文秀
	RWTFLB[592] = "意在形先"	--独孤求败
	RWTFLB[601] = "机敏无双"	--韦小宝
	RWTFLB[605] = "惊才绝艳"	--林朝英
	RWTFLB[606] = "踏沙无痕"	--阿凡提
	RWTFLB[609] = "机智多谋"	--赵敏
	RWTFLB[631] = "秀若芝兰"	--周芷若
	RWTFLB[635] = "世外高人"	--袁士霄
	RWTFLB[642] = "亿万小时"	--四大山
	RWTFLB[655] = "一贫道长"	--李逍遥
	RWTFLB[656] = "君已陌路"	--赵灵儿
	RWTFLB[657] = "共结连理"	--林月如
	RWTFLB[658] = "海棠夫人"	--阿奴
	RWTFLB[669] = "文学巨匠"	--金先生
	RWTFLB[670] = "八部神威"    --雷震
	RWTFLB[681] = "刀腿双绝" 
	RWTFLB[682] = "剑掌双绝" 
	RWTFLB[683] = "剑道巅峰"
	RWTFLB[684] = "小李飞刀"
	RWTFLB[685] = "炼化之术"
	RWTFLB[693] = "天国之龙"
	RWTFLB[694] = "太平要术"
	RWTFLB[686] = "北斗神拳"
	RWTFLB[687] = "六脉一阳"
	RWTFLB[634] = "旷世奇才"
	RWTFLB[637] = "大道归藏"
	RWTFLB[638] = "不动如山"
	RWTFLB[636] = "酒龙诗虎"
	RWTFLB[688] = "龙胆"
	RWTFLB[689] = "元素召唤"
	RWTFLB[691] = "人刀合一"
	RWTFLB[692] = "苏乞儿"
	
	RWTFLB[671] = "天剑化身"    --无名
	RWTFLB[672] = "神照真传"    --丁典
	RWTFLB[675] = "天煞孤星"    --华英雄
	RWTFLB[676] = "翻云破浪"    --武僧
	RWTFLB[677] = "故地重游"
	RWTFLB[678] = "灵犀一指"
	RWTFLB[420] = "皮糙肉厚"
	
	
	--天赋介绍
	TFJS = {}
	TFJS[1] = {"Ｌ魂系一刀","Ｗ使用胡家刀法有50%几率触发极意，暴怒必触发",
	"Ｎ",
	"Ｌ雪山飞狐",
	"Ｗ集气速度提升8点",
	"Ｎ",
	"Ｒ特色指令：飞狐",
	"Ｗ效果：无视障碍物移动，在战场上来去自如",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ得到《雪山飞狐》后，找苗人凤可洗第二格武功"
	}
	TFJS[2] = {"Ｌ灵枢素问",
	"Ｗ医疗能力上限400",
	"Ｗ用毒能力上限500",
	"Ｗ攻击时附带【七心海棠】，敌方全体中毒20点，并扣除7%当前血量",
	"Ｗ攻击时即使杀死敌方，也不会中断连击"
	}
	TFJS[3] = {"Ｌ金面佛",
	"Ｗ攻击时高几率附带灼烧",
	"Ｗ每100点御剑系数增加苗家剑法攻击范围1格",
	"Ｗ根据实战，苗家剑法几率极意三连",
	"Ｌ打遍天下",
	"Ｗ根据实战获得固定增减伤，最高50",
	"Ｎ",
	"Ｒ特色指令：破军",
	"Ｗ效果：攻击敌方，并使其内功停运50时序",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ雪山飞狐闯王宝藏剧情，可选择洗第二格武功及天赋轻功"
	}
	TFJS[4] = {"Ｌ跌打医生",
	"Ｗ医疗能力上限300",
	"Ｗ用毒能力上限300",
	"Ｎ",
	"Ｌ雁过拔毛",
	"Ｗ击退敌方后可获得银两",
	"Ｗ让田归农的攻击中附加带毒",
	"Ｎ",
	"Ｒ特色指令：虚弱",
	"Ｗ用毒药侵蚀一名敌人的神经，使其在40时序内造成的伤害杀气减半",
	"Ｇ福缘际遇",
	"Ｗ飞狐邪线杀苗人凤后，洗第一格武功洗为胡家刀法一级"
	}
	TFJS[72] = {"Ｌ天龙掌门",
	"Ｗ无视兵器值需求装备『闯王军刀』",
	"Ｗ装备『闯王军刀』，攻击时必定附加流血效果",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ飞狐邪线杀苗人凤后，洗第一、二格武功，天赋外功洗为胡刀苗剑"
	}
	TFJS[37] = {"Ｌ赤心连城",
	"Ｗ使用连城剑法高连击",
	"Ｗ修炼血刀大法无惩罚，不会降低生命上限",
	"Ｚ畅想主角专属",
	"Ｗ如本次攻击造成伤害低于200，则追加一次连击（一轮追加上限3次）",
	"Ｎ",
	"Ｌ真名神照",
	"Ｗ主运神照功时免疫杀气",
	"Ｗ神照功复活效果强化，回复百分比为100%，并且立即行动，无需运功",
	"Ｗ可使用神照功攻击",
	"Ｗ神照功等级修炼至极，轻功+20",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ连城诀雪山剧情，洗第二、三格武功"
	}
	TFJS[589] = {"Ｌ似水柔情",
	"Ｗ误伤队友时恢复其血量",
	"Ｗ自带龙蛇演义",
	"Ｎ",
	"Ｌ铃剑侠女",
	"Ｗ使用连城剑法高连击"
	}
	TFJS[594] = {"Ｌ铁索横江",
	"Ｗ【闭气离墙.起死回生】，战斗中可以复活一次",
	"Ｗ自带“铁索横江”加力、护体，600威力，可叠加（几率与天书数、实战相关）",
	"Ｗ基础连击率大幅度提高"
	}
	TFJS[52] = {"Ｌ中平神枪",
	"Ｗ使用中平枪法时，气攻+1500",
	"Ｗ七书后中平神枪威力翻倍",
	"Ｗ六如觉醒后中平神枪威力翻倍，范围+3，无视气防",
	"Ｗ十四书后中平神枪威力翻倍"
	}
	TFJS[94] = {"Ｌ仁义刀",
	"Ｗ "
	}
	TFJS[95] = {"Ｌ柔云剑",
	"Ｗ "
	}
	TFJS[96] = {"Ｌ冷月剑",
	"Ｗ "
	}
	TFJS[97] = {"Ｌ借刀杀人",
	"Ｗ将击退的敌人复活为己方，血内为30%，随天书提升",
	"Ｎ",
	"Ｌ诡谲",
	"Ｗ初始集气位置加400，且移动+3格",
	"Ｎ",
	"Ｌ血刀老祖",
	"Ｗ基础暴击率大幅度提高",
	"Ｗ战场上其他角色不能回复生命"
	}
	TFJS[45] = {"Ｌ阎王敌",
	"Ｗ医疗上限500点",
	"Ｗ战斗中满血复活自己或者同伴一次"
	}
	TFJS[46] = {"Ｌ星宿老怪",
	"Ｌ欺师灭祖",
	"Ｗ根据道德值提升伤害，道德越低伤害越高",	
	"Ｗ道德为0时，防御提升20%",
	"Ｇ星河思达（需充值V6激活）",	
	"Ｗ被攻击时1%几率触发星河真气·免疫伤害",
	"Ｇ心狠手辣（需充值V6激活）",
	"Ｗ自带【紫气天罗】效果",
	"Ｇ北冥重生（需充值V6激活）",
	"Ｗ战斗中首次被击退可复活一次，提升25%攻击力防御力并重新长出JJ"
	}
	TFJS["46"] = {"Ｌ星宿老怪",
	"Ｌ欺师灭祖",
	"Ｗ根据道德值提升伤害，道德越低伤害越高",	
	"Ｗ道德为0时，防御提升20%",
	"Ｇ星河思达（已激活）",	
	"Ｗ被攻击时1%几率触发星河真气·免疫伤害",
	"Ｇ心狠手辣（已激活）",
	"Ｗ自带【紫气天罗】效果",
	"Ｇ北冥重生（已激活）",
	"Ｗ战斗中首次被击退可复活一次，提升25%攻击力防御力并重新长出JJ"
	}
	TFJS[47] = {"Ｌ曼珠沙华",
	"Ｗ每击退一个敌方，自身气攻气防提高200点",
	"Ｎ",
	"Ｒ特色指令：禁药",
	"Ｗ使用禁药刺激神经，自身每时序损失1%最大血量",
	"Ｗ此状态下自身血量越低，伤害/集气越高，不消耗回合"
	}
	TFJS[48] = {
	"Ｌ铁面侠",
	"Ｗ受到暴击伤害减少20%",
	"Ｌ血海深仇",
	"Ｗ怒气时序+1",
	"Ｌ冰蚕毒掌",
	"Ｗ攻击带毒340点",
	"Ｗ攻击时，如敌方身上的冰封大于50，则有60%几率将其冻结10时序",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ随实战和天书提升战斗中领悟四个天赋",
	}
	TFJS[49] = {"Ｌ福缘深厚",
	"Ｗ攻击时50%概率触发【福泽加护】，下回合集气+200",
	"Ｎ",
	"Ｌ逍遥掌门",
	"Ｗ擂鼓山剧情后，自带北冥真气护体",
	"Ｗ学会八荒六合功后，使用天山六阳掌/天山折梅手攻击可触发【生死符】",
	"Ｗ生死符追加1700气攻，对被生死符击中的敌人，可使用【催符】指令",
	"Ｗ面板上每多一个武功到极，天山折梅手威力+50",
	"Ｗ天山折梅手修炼到极，资质变为50",
	"Ｎ",
	"Ｒ特色指令：催符",
	"Ｗ催动敌人身上的生死符，使其封穴25时序",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ擂鼓山支线剧情，第一格洗为北冥神功",
	"Ｗ灵鹫宫胜李秋水，第二格洗为小无相功",
	"Ｗ灵鹫宫观看壁画，第三格洗为八荒六合功",
	"Ｗ灵鹫宫搜索书柜，第四格洗为天山六阳掌",
	"Ｗ灵鹫宫搜索书柜，第五格洗为天山折梅手",
	"Ｗ天正少林寺大战，第四格洗为打狗棒法",
	"Ｗ天正少林寺大战，第五格洗为降龙十八掌"
	}
	TFJS[50] = {"Ｌ奋英雄怒",
	"Ｗ攻击时必定造成暴击并有红字特效",
	"Ｌ见龙在田",
	"Ｗ暴怒时使用降龙十八掌必破气防",
	"Ｎ",
	"Ｌ狂龙天征",
	"Ｗ使用降龙十八掌，必定发动【降龙.极意】",
	"Ｗ使用降龙十八掌，40%几率发动【降龙.三叠浪】，暴怒时必定发动",
	"Ｗ使用降龙十八掌攻击无误伤",
	"Ｎ",
	"Ｌ化朽为奇",
	"Ｗ外功至少具有1000点威力",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ天龙八部正线挑战扫地老僧胜利后，可获得专属武器"
	}
	TFJS[51] = {"Ｌ离合参商",
	"Ｗ斗转反击时，无视兵器值需求必定发动离合参商",
	"Ｗ斗转星移发动几率100%",
	"Ｎ",
	"Ｌ姑苏慕容",
	"Ｗ可使用斗转星移进行攻击",
	"Ｎ",
	"Ｒ特色指令：幻梦",
	"Ｗ至该角色下次行动为止，被攻击必定发动幻梦星辰反击"
	}
	TFJS[53] = {"Ｌ磊落仁心",
	"Ｗ内力上限9999",
	"Ｎ",
	"Ｌ六脉真传",
	"Ｗ六脉神剑出招式几率追加二次判定，伤害随实战随机变化，最高1-2倍",
	"Ｗ六脉神剑耗内降低50%（与天赋外功效果叠加，降低75%内力消耗）",
	"Ｎ",
	"Ｗ攻击时，北冥神功会吸取少量生命",
	"Ｎ",
	"Ｒ特色指令：凌波",
	"Ｗ至该角色下次行动为止，被攻击有60%几率闪避",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ无量山洞剧情，洗第一、二格武功",
	"Ｗ天龙寺剧情，洗第三格武功"
	}
	TFJS[70] = {"Ｌ少林掌门",
	"Ｚ一空到底",
	"Ｗ使用般若掌30%几率出最高境界，范围攻击，杀气+1000，敌我双方集气倒走10时序"
	}
	TFJS[76] = {"Ｌ武中无相",
	"Ｗ无视限制条件修炼武学秘籍",
	"Ｗ初始自带100点武常",
	"Ｎ",
	"Ｌ琅嬛仙子",
	"Ｗ作为主角时，初始五系兵器值提升至30点",
	"Ｎ",
	"Ｚ妙法无形",
	"Ｗ在场时，我方全体攻击范围增加一格",
	"Ｎ",
	"Ｚ御法绝尘",
	"Ｗ☆需要自身五系兵器值之和大于等于500",
	"Ｗ在场时，敌方全体攻击时不会出招式",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ获得凌波微步后，天赋轻功洗为凌波微步"
	}
	TFJS[90] = {"Ｌ毓秀灵姝",
	"Ｗ攻击时必定造成流血",
	"Ｎ",
	"Ｒ特色指令：灵貂",
	"Ｗ☆找到闪电貂后可激活",
	"Ｗ偷窃敌方携带的物品，并对其强制上毒50点",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ天龙正线收段誉，洗第一格武功，天赋外功洗为六脉神剑"
	}
	TFJS[98] = {"Ｌ恶贯满盈",
	"Ｗ暴击攻击加成提升至200%",
	"Ｗ自带“恶贯满盈”加力护体，200威力，可叠加（几率与天书数、实战相关）"
	}
	TFJS[99] = {"Ｌ无恶不作",
	"Ｗ暴击攻击加成提升至200%",
	"Ｗ自带“无恶不作”加力护体，200威力，可叠加（几率与天书数、实战相关）"
	}
	TFJS[100] = {"Ｌ穷凶极恶",
	"Ｗ暴击攻击加成提升至200%",
	"Ｗ自带“穷凶极恶”加力护体，200威力，可叠加（几率与天书数、实战相关）"
	}
	TFJS[44] = {"Ｌ凶神恶煞",
	"Ｗ暴击攻击加成提升至200%",
	"Ｗ自带“凶神恶煞”加力护体，200威力，可叠加（几率与天书数、实战相关）"
	}
	TFJS[101] = {"Ｌ大理家臣",
	"Ｗ "
	}
	TFJS[102] = {"Ｌ双树枯荣",
	"Ｗ灼烧恢复能力加倍（时序恢复2点灼烧）",
	"Ｗ自带“枯荣真气”护体，600威力，可叠加（几率与天书数、实战相关）",
	"Ｗ攻击时几率追加600气攻，可叠加（几率与天书数、实战相关）",
	"Ｗ7书后枯禅境界提升，主运枯禅功生效",
	"Ｎ",
	"Ｌ天龙禅师",
	"Ｗ使用一阳指高几率连击"
	}
	TFJS[103] = {"Ｌ大轮明王",
	"Ｗ火焰刀法【大轮密宗.火焰刀】发动几率100%",
	"Ｗ自带“明王真气”加力、护体，600威力，可叠加（几率与天书数、实战相关）",
	"Ｚ不动明王",
	"Ｗ30%概率免疫非连击伤害",
	"Ｎ",
	"Ｒ特色指令：幻化",
	"Ｗ使用小无相功模拟天下武学，必须要拥有对应的秘籍"
	}
	TFJS[104] = {"Ｌ云舞霓裳",
	"Ｗ无视限制条件穿戴任何装备"
	}
	TFJS[105] = {"Ｌ琴韵温香",
	"Ｗ "
	}
	TFJS[110] = {"Ｌ聚贤庄主",
	"Ｗ "
	}
	TFJS[111] = {"Ｌ聚贤庄主",
	"Ｗ "
	}
	TFJS[112] = {"Ｌ震天魔狼",
	"Ｗ开场进入杀破狼状态",
	"Ｚ杀破狼",
	"Ｗ三回合内保持满怒，基础攻防轻提高50%，必定三连击，杀气提高5000",
	"Ｌ走火入魔",	
	"Ｗ三回合后走火入魔，行动后集气停止5时序，每行动一轮停止时序+1"
	}
	TFJS[113] = {"Ｌ参合潜龙",
	"Ｗ斗转反击时，无视兵器值需求必定发动离合参商反击两次",
	"Ｗ自带“参合真气”加力、护体，600威力，可叠加（几率与天书数、实战相关）",
	"Ｌ走火入魔",	
	"Ｗ100时序后走火入魔，行动前停止主运内功5时序，每行动一轮停止时序+1"
	}
	TFJS[114] = {"Ｌ达摩再世",
	"Ｗ内力上限9999，初始武学常识100",
	"Ｗ被攻击100%触发【天地独尊】，完全免疫杀气",
	"Ｗ攻击时高几率触发封穴",
	"Ｗ攻击时武功视觉特效随机触发，攻击无误伤",
	"Ｌ业由心生·回转有道",
	"Ｗ满怒时，怒气封穴内伤清0，集气速度*2，持续15时序，持续期间不产生怒气",
	"Ｌ舍己度人",
	"Ｗ被攻击几率发动，内功不会护体，使攻击者集气倒走6时序",
	"Ｎ",
	"Ｌ天佛化生·金刚护体",
	"Ｗ降低受到的伤害50%，初始几率25%，每20点实战增加1%",
	"Ｌ我佛慈悲·普度众生",
	"Ｗ慈悲刀法威力翻倍，根据品德增加真实伤害"
	}
	TFJS[115] = {"Ｌ聪辩先生",
	"Ｗ拥有琴棋书画四种天赋外功"
	}
	TFJS[116] = {"Ｌ北冥极渊",
	"Ｗ被攻击时必定发动北冥真气护体",
	"Ｚ畅想主角专属",
	"Ｗ主动攻击触发北冥神功吸内时，增加自身属性",
	"Ｎ",
	"Ｌ风月无间",
	"Ｗ对男性伤害提高20%，被女性伤害减少20%"
	}
	TFJS[117] = {"Ｌ转瞬红颜",
	"Ｗ每过100时序，自动回满血内体并解除自身异常状态",
	"Ｎ",
	"Ｌ不老长春",
	"Ｗ被攻击时恢复80点生命",
	}
	TFJS[118] = {"Ｌ无相转身（畅想主角专属）",
	"Ｗ被攻击时概率触发，免疫本次攻击并获得一次移动机会",
	"Ｗ移动后会在自身位置留下一个幻象",
	"Ｗ幻象生命为1点，且无法攻击",
	"Ｗ幻象消失前，不会再次触发无相转身",
	"Ｎ",
	"Ｌ秋水无尘",
	"Ｗ自身集气速度不受异常状态影响"
	}
	TFJS[55] = {"Ｌ大器晚成",
	"Ｗ左右互搏发动概率固定为80%",
	"Ｌ中人之姿",
	"Ｗ升级属性成长固定为5点",
	"Ｎ",
	"Ｌ侠之大者",
	"Ｗ使用降龙十八掌，40%几率发动【降龙.极意】",
	"Ｗ使用降龙十八掌发动连击时，在第二击附加随机多重后劲，额外增加伤害和杀气",
	"Ｗ后劲上限随天书数而增加，最多13道；后劲超过11道时，无视敌方绝对气防",
	"Ｗ每道后劲增加8%的高优先级伤害和150点气攻，NPC郭靖上限固定为10道后劲",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ射雕桃花岛招亲剧情，洗第一、二、三格武功",
	"Ｗ射雕正线桃花岛收郭靖时，可重新选择内力属性"
	}
	TFJS[56] = {"Ｌ奇门遁甲",
	"Ｗ战斗开始前可布置奇阵，不同颜色的地面有不同效果:",
	"Ｒ红色——造成的伤害提高20%",
	"Ｌ绿色——受到的伤害减少20%",
	"Ｄ蓝色——攻击时追加2000点气攻",
	"Ｚ紫色——被攻击时有30%几率闪避",
	"Ｎ",
	"Ｌ兰质蕙心",
	"Ｗ修炼武功秘籍时，兵器值成长翻倍",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ射雕明霞岛剧情，洗第一、二格武功"
	}
	TFJS[57] = {"Ｌ东邪",
	"Ｗ主运碧池神功攻击时发动碧海潮生曲,杀全体敌人内力500（连击无效）",
	"Ｗ攻击时高几率造成封穴",
	"Ｗ自带“奇门奥义”加力、护体，600威力，可叠加（几率与天书数、实战相关）"
	}
	TFJS[60] = {"Ｌ倒行逆施",
	"Ｗ集气时有小概率跳跃（集气值随机增加）",
	"Ｗ学会逆运后，被攻击必定进入【真.逆运经脉-走火入魔】状态",
	"Ｗ走火状态必定暴击，攻击/防御效果提高10%，加力/护体/出招几率大幅提高",
	"Ｗ走火状态无法休息，如体力低于20点，则停止走火",
	"Ｎ",
	"Ｌ西毒",
	"Ｗ所有攻击无误伤",
	"Ｗ攻击时无视敌方毒抗强制上毒30点",
	"Ｗ蛤蟆功.蟾震九天效果加强，会根据蓄力值追加伤害",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ射雕明霞岛剧情后，洗第二格武功，天赋内功洗为逆运经脉",
	"Ｗ华山绝顶支线剧情，洗第三格武功"
	}
	TFJS[61] = {"Ｌ白驼少主",
	"Ｗ暴怒时，使用拳法可触发灵蛇拳，击中的敌人集气进入波动状态20时序",
	"Ｗ七书后白驼雪山掌威力翻倍"
	}
	TFJS[64] = {"Ｌ返璞归真",
	"Ｗ左右互搏发动概率100%",
	"Ｎ",
	"Ｌ顽童武痴",
	"Ｗ每行动一次，攻击效果提升10%",
	"Ｎ",
	"Ｚ空明之武道",
	"Ｗ攻击时，有(25+实战/20)%几率使敌方无法触发内功护体",
	"Ｎ",
	"Ｚ左右补偿（畅想主角专属）",
	"Ｗ发动左右互搏后，会根据资质补偿一次额外的左右机会",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ神雕获得黯然时，洗第四格武功",
	}
	TFJS[65] = {"Ｌ南僧",
	"Ｗ使用一阳指，给敌方追加“无明业火”状态，持续30时序",
	"Ｗ处于“无明业火”状态的人攻击时，会损失50%内力消耗量的生命",
	"Ｗ攻击时高几率造成封穴",
	"Ｌ佛本是道",
	"Ｗ行动开始前提升我方全体100集气",
	"Ｌ业由心生·回转有道",
	"Ｗ满怒时，怒气封穴内伤清0，集气速度*2，持续15时序，持续期间不产生怒气",
	"Ｌ舍己度人",
	"Ｗ被攻击几率发动，内功不会护体，使攻击者集气倒走6时序",
	"Ｎ",
	"Ｚ先天一阳",
	"Ｗ战斗中首次被击退可复活一次",
	"Ｗ回复70%生命值，部分状态，并立即行动",
	"Ｗ复活后，集气速度+5",
	"Ｎ",
	"Ｚ不动明王",
	"Ｗ复活后，免疫敌方连击的第二三下伤害"
	}
	TFJS[68] = {"Ｌ长春子",
	"Ｗ七书后全真剑法威力翻倍"
	}
	TFJS[67] = {"Ｌ铁掌帮主",
	"Ｗ使用任何武功高连击，高暴击",
	"Ｗ铁掌威力增加200",
	"Ｌ水上漂",
	"Ｗ移动格数+3",
	}
	TFJS[69] = {"Ｌ北丐",
	"Ｗ使用降龙十八掌，40%几率发动【降龙.极意】",
	"Ｗ使用降龙十八掌攻击无误伤",
	"Ｗ自带“丐王真气”加力、护体，600威力，可叠加（几率与天书数、实战相关）",
	"Ｗ使用降龙50%几率触发盖世无双，连击加一，连击变为打狗棒法",
	"Ｗ使用打狗50%几率触发盖世无双，连击加一，连击变为降龙十八掌",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ华山绝顶支线剧情，洗第三格武功，天赋内功洗为九阴神功，内力属性转为阴内"
	}
	TFJS[78] = {"Ｌ铁尸魔煞",
	"Ｗ七书后，九阴白骨爪威力增加50%"
	}
	TFJS[119] = {"Ｌ渔",
	"Ｗ一阳指必冰封"
	}
	TFJS[120] = {"Ｌ樵",
	"Ｗ一阳指必灼烧"
	}
	TFJS[121] = {"Ｌ耕",
	"Ｗ一阳指必暴击"
	}
	TFJS[122] = {"Ｌ读",
	"Ｗ一阳指必连击"
	}
	TFJS[123] = {"Ｌ丹阳子",
	"Ｗ七书后全真剑法威力翻倍"
	}
	TFJS[124] = {"Ｌ长真子",
	"Ｗ七书后全真剑法威力翻倍"
	}
	TFJS[125] = {"Ｌ长生子",
	"Ｗ七书后全真剑法威力翻倍"
	}
	TFJS[126] = {"Ｌ玉阳子",
	"Ｗ七书后全真剑法威力翻倍"
	}
	TFJS[127] = {"Ｌ广宁子",
	"Ｗ七书后全真剑法威力翻倍"
	}
	TFJS[128] = {"Ｌ清净散人",
	"Ｗ七书后全真剑法威力翻倍"
	}
	TFJS[129] = {"Ｌ中神通",
	"Ｗ七书后，全真剑法威力翻倍",
	"Ｗ使用全真剑法，60%几率发动重阳剑气，追加777气攻",
	"Ｗ攻击时高几率造成封穴",
	"Ｌ清静无为",
	"Ｗ受到攻击随机回复20~50点生命值",
	"Ｎ",
	"Ｚ神通技·重阳再现",
	"Ｗ战斗中首次被击退可复活一次",
	"Ｗ回复70%生命值，部分状态，并立即行动",
	"Ｗ复活后，集气速度+5",
	"Ｎ",
	"Ｚ神通技·北斗七闪",
	"Ｗ发动重阳再现后，自身进入北斗真打状态",
	"Ｗ获得两本天书后习得第一层效果",
	"Ｗ之后每获得两本天书增加一层，共七层",
	"Ｗ层数即代表可维持真打状态的轮数",
	"Ｗ自身每行动一次减少一层，耗完即消去真打状态",
	"Ｗ在真打状态下，全程怒气爆发",
	"Ｗ必定发动内功加力且气攻值增幅"
	}
	TFJS[130] = {"Ｌ飞天蝙蝠",
	"Ｗ自动主运所有学会的轻功",
	"Ｗ倚正救治韦一笑后觉醒，集气速度+10",
	"Ｗ天正挑战扫地，武学常识+100，扫地不再参加华山论剑",
	"Ｌ回声定位",
	"Ｗ攻击无视闪避",
	"Ｌ悉听尊便",
	"Ｗ生命30%以下时，受到的伤害减少10%，并有几率闪避",
	}
	TFJS[131] = {"Ｌ妙手书生",
	"Ｗ使用妙手空空攻击，可盗取敌方身上携带的物品"
	}
	TFJS[132] = {"Ｌ马王神",
	"Ｚ人马合一",
	"Ｗ装备白马，承受伤害降低25%",
	"Ｗ装备瘦黄马，造成伤害提高25%",	
	"Ｗ装备飞云骓，集气速度提高25%",
	"Ｗ装备汗血宝马，时序回复15点生命值",	
	"Ｗ装备夜照玉狮子，攻击不消耗体力",
	}
	TFJS[133] = {"Ｌ南山樵子",
	"Ｚ悠悠见南山",
	"Ｗ使用南山刀法后10时序内不动如山",
	}
	TFJS[134] = {"Ｌ笑弥陀",
	"Ｗ使用罗汉拳必出般若掌",
	"Ｗ使用大力金刚掌必出达摩掌",
	"Ｗ使用一指禅必出摩柯指",
	"Ｗ使用伏魔杖法必出八法神禅",
	}
	TFJS[135] = {"Ｌ闹市侠隐",
	"Ｗ受到攻击时承受130%伤害,判定变为误伤"
	}
	TFJS[136] = {"Ｌ越女剑",
	"Ｗ挑战阿青独孤求败获胜后洗天外越女剑"
	}
	TFJS[590] = {"Ｌ心秀天铃",
	"Ｗ使用奇门武功，有（天书数*2+实战/25）%的几率发动“心秀天铃·星月争辉”，",
	"Ｗ追加1200点气攻，如已有14本天书，则触发此特效必破气防",
	"Ｎ",
	"Ｌ古道西风",
	"Ｗ装备白马时的集气加成效果翻倍",
	"Ｚ畅想主角专属",
	"Ｗ每修炼一个奇门武功到极，集气速度+2（上限7个）"
	}
	TFJS[137] = {"Ｌ青蟒剑",
	"Ｗ "
	}
	TFJS[138] = {"Ｌ一指镇江南",
	"Ｗ每拥有一本天书，指法威力提升8%",
	"Ｗ使用指法攻击几率触发特效，全体敌方集气暂停，时序可叠加"
	}
	TFJS[86] = {"Ｌ金枝玉叶",
	"Ｗ敌方全体防御效果降低10%"
	}
	TFJS[87] = {"Ｌ媚眼如丝",
	"Ｗ敌方全体攻击效果降低10%"
	}
	TFJS[139] = {"Ｌ延平郡王",
	"Ｗ "
	}
	TFJS[150] = {"Ｌ一剑无血",
	"Ｗ攻击不会造成流血效果",
	"Ｗ攻击高几率造成封穴",
	"Ｗ剑法伤害提高25%",
	}
	TFJS[71] = {"Ｌ神龙教主",
	"Ｗ使用任何武功高连击，高暴击",
	"Ｎ",
	"Ｌ特技：豹胎易筋丸",
	"Ｗ在敌方要服用的药品中加入豹胎易筋丸，使其加血效果变为减血"
	}
	TFJS[19] = {"Ｌ君子剑",
	"Ｗ自带五岳剑法组合",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ笑傲福威镖局选择正邪剧情，洗第一、三格武功"
	}
	TFJS[20] = {"Ｌ潇湘夜雨",
	"Ｗ自带五岳剑法组合",
	"Ｗ攻击几率触发【剑发琴音】，造成全体敌方集气波动",
	"Ｗ战斗中随实战领悟五式衡山五神剑，每次御剑+20"
	}
	TFJS[21] = {"Ｌ恒山掌门",
	"Ｗ自带五岳剑法组合",
	"Ｗ "
	}
	TFJS[420] = {"Ｌ皮糙肉厚",
	"Ｗ生命上限提高",
	"Ｗ受到的伤害价低15%",
	"Ｌ雪山灵兽",
	"Ｗ雪怪也要畅想",
	"Ｗ无视资质修炼左右互搏和太玄神功",
	"Ｗ攻击时高几率附带冰封",
	}
	TFJS[22] = {"Ｌ嵩山掌门",
	"Ｗ自带五岳剑法组合",
	"Ｗ攻击时高几率附带冰封",
	"Ｗ自带“寒冰真气”加力、护体，500威力，可叠加（几率与天书数、实战相关）"
	}
	TFJS[23] = {"Ｌ泰山掌门",
	"Ｗ自带五岳剑法组合",
	"Ｗ攻击时高几率附带灼烧"
	}
	TFJS[24] = {"Ｌ青城掌门",
	"Ｗ使用松风剑法伤害翻倍，无视无我无剑",
	"Ｗ七书后松风剑法威力翻倍",
	"Ｗ自带松风剑神加力、护体，大概100威力，可叠加,几率与实战及天书数量有关",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ单挑战胜余沧海，第一二格武功重新洗为一级",
	"Ｗ战胜剑魔剑仙，获得称号松风剑神，松风剑法威力5倍",
	"Ｗ战胜剑魔剑仙，若拳掌大于250，摧心掌威力5倍"
	}
	TFJS["24-1"] = {"Ｌ松风剑神",
	"Ｗ使用松风剑法伤害翻倍，无视无我无剑",
	"Ｗ七书后松风剑法威力翻倍",
	"Ｗ自带松风剑神加力、护体，大概2000威力，可叠加,几率与实战及天书数量有关",
	"Ｒ松风剑法威力巨大",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ单挑战胜余沧海，第一二格武功重新洗为一级",
	"Ｗ战胜剑魔剑仙，获得称号松风剑神，松风剑法威力5倍",
	"Ｗ战胜剑魔剑仙，若拳掌大于200，摧心掌威力5倍"
	}
	TFJS["24-2"] = {"Ｌ松风剑神",
	"Ｗ使用松风剑法伤害翻倍，无视无我无剑",
	"Ｗ七书后松风剑法威力翻倍",
	"Ｗ自带松风剑神加力、护体，大概2000威力，可叠加,几率与实战及天书数量有关",
	"Ｒ松风剑法威力巨大",
	"Ｎ",
	"Ｌ剑掌双绝",
	"Ｒ摧心掌威力也不小",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ单挑战胜余沧海，第一二格武功重新洗为一级",
	"Ｗ战胜剑魔剑仙，获得称号松风剑神，松风剑法威力5倍",
	"Ｗ战胜剑魔剑仙，若拳掌大于200，摧心掌威力5倍"
	}
	TFJS[25] = {"Ｌ五毒教主",
	"Ｗ攻击效果提升10%",
	"Ｗ用毒能力上限400"
	}
	TFJS[646] = {"Ｌ千蛛万毒",
	"Ｗ攻击时，追加等同于敌方中毒量的伤害",
	"Ｗ全场敌方时序增加中毒",
	"Ｇ福缘际遇",
	"Ｗ随实战增加，战斗中领悟三个天赋",
	}
	TFJS[692] = {"Ｌ武状元",
	"Ｗ初始高兵器值，普通攻击等级提高",
	"Ｌ苏乞儿",
	"Ｗ击退敌方后可获得银两",
	"Ｇ福缘际遇",
	"Ｗ随实战和天书增加，战斗中领悟四个天赋",
	"Ｗ五书后，破庙可触发专属剧情，领悟睡梦罗汉拳",
	"Ｗ领悟睡梦罗汉拳，面板不需有罗汉拳，反击伤害加倍",
	}
	TFJS[26] = {"Ｌ日月魔帝",
	"Ｗ吸星大法吸体力效果提高",
	"Ｗ自带加力护体（600威力，可叠加）几率与天书数、实战有关",
	"Ｗ使用任何武功高暴击",
	"Ｗ攻击时高几率造成封穴"
	}
	TFJS[27] = {"Ｌ风云再起",
	"Ｗ攻击无误伤",
	"Ｗ集气速度提升6点",
	"Ｗ必连击，且连击时伤害、气攻不减",
	"Ｎ",
	"Ｌ葵花点穴手",
	"Ｗ攻击时概率追加1000气攻，且必定造成封穴",
	"Ｎ",
	"Ｌ葵花秘法·化凤为凰",
	"Ｗ暴怒时触发，直至暴怒解除前无法被杀气"
	}
	TFJS[28] = {"Ｌ杀人名医",
	"Ｗ每击退一名敌人集气速度+3点、医疗能力+50（最多5个有效）",
	"Ｗ攻击伤害10%转换为生命回复，每击退一个敌人效果提升2%",
	"Ｗ医疗能力上限500"
	}
	TFJS[29] = {"Ｌ万里独行",
	"Ｗ战场上已方人员越少集气速度提升越多",
	"Ｗ集气速度提升值为：20-在场队友数量×4",
	"Ｇ福缘际遇（畅想专属）",
	"Ｗ天上人间战胜余沧海，御剑+30",
	"Ｗ思过崖与令狐冲切磋，每次胜利，攻击+10，御剑+20",
	"Ｗ河洛客栈击败萧中慧，洗二、三格武功",
	"Ｗ梦境中每次战斗胜利，狂风刀法威力气攻+500",
	}
	TFJS["29-1"] = {"Ｌ狂风刀神",
	"Ｗ所有刀法威力增加20%",
	"Ｌ万里独行",
	"Ｗ战场上已方人员越少集气速度提升越多",
	"Ｗ集气速度提升值为：20-在场队友数量×4",
	"Ｌ狂风绝息斩",
	"Ｗ同时习得神刀斩+狂风刀法，暴怒发动狂风绝息斩",
	"Ｇ福缘际遇（畅想专属）",
	"Ｗ天上人间战胜余沧海，御剑+30",
	"Ｗ思过崖与令狐冲切磋，每次胜利，攻击+10，御剑+20",
	"Ｗ河洛客栈击败萧中慧，洗二、三格武功",
	"Ｗ梦境中每次战斗胜利，狂风刀法威力气攻+500",
	}
	TFJS[31] = {"Ｌ江南四友",
	"Ｗ七书后妙笔丹青威力翻倍"
	}
	TFJS[32] = {"Ｌ江南四友",
	"Ｗ七书后倚天屠龙功威力翻倍"
	}
	TFJS[33] = {"Ｌ江南四友",
	"Ｗ七书后棋盘招式威力翻倍"
	}
	TFJS[34] = {"Ｌ江南四友",
	"Ｗ七书后持瑶琴威力翻倍"
	}
	TFJS[35] = {"Ｌ灵奇洒脱",
	"Ｗ移动格数+3",
	"Ｎ",
	"Ｌ九剑传人",
	"Ｗ被风清扬指点后，进入战斗初始集气位置加500",
	"Ｗ暴怒时消耗20%内力体力，攻击变为面攻，附带刺目效果",
	"Ｎ",
	"Ｌ剑魔再临（独孤剑冢剧情后）",
	"Ｗ连击率大幅提升",
	"Ｗ使用独孤九剑攻击无误伤",
	"Ｗ攻击时有几率发动『剑魔再临·动如雷震』特效，三连击，暴怒必触发",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ笑傲思过崖剧情，洗第一格武功，天赋外功洗为独孤九剑",
	"Ｗ笑傲梅庄地牢剧情，洗第二格武功，天赋内功洗为吸星大法",
	"Ｗ笑傲正线救任盈盈后，洗第一格武功"
	}
	TFJS[36] = {"Ｌ辟邪剑客",
	"Ｗ初始集气位置加400",
	"Ｗ使用辟邪剑法招式无冷却",
	"Ｗ使用辟邪剑法攻击追加集气速度值的真实伤害，暴怒时加倍",
	"Ｌ血海深仇",
	"Ｗ怒气时序+1",
	"Ｎ",
	"Ｌ特技：血海飘香（杀余沧海后领悟）",
	"Ｗ根据本轮造成的伤害提高下一轮的集气位置，上限400",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ笑傲福威镖局选择正邪剧情，洗第一、二格武功",
	"Ｗ笑傲福威镖局选择正邪剧情，天赋内功洗为葵花神功",
	"Ｗ随实战和天书提升战斗中领悟四个天赋",
	}
	TFJS[140] = {"Ｌ剑术通神",
	"Ｗ攻击和被攻击时，无论任何系，均按敌我御剑系数计算加成",
	"Ｎ",
	"Ｚ无招胜有招",
	"Ｗ暴怒时，使用独孤九剑攻击，追加2000点气攻，和10时序的静止状态，可叠加"
	}
	TFJS[73] = {"Ｌ琴铮盈盈",
	"Ｗ使用持瑶琴，必定发动“七弦无形剑气”，对敌方全体造成100点伤害",
	"Ｎ",
	"Ｌ日月圣姑",
	"Ｗ每时序回复自身5点中毒"
	}
	TFJS[79] = {"Ｌ慧中灵剑",
	"Ｗ每修炼一门剑法，攻击效果提升10%",
	"Ｗ每修炼一门剑法，初始集气+50",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ笑傲福威镖局选择正邪剧情，洗第一、二、三、四、五、六格武功",
	}
	TFJS[88] = {"Ｌ酒神",
	"Ｗ被攻击时有30%几率发动\"酒神秘踪步\"闪避",
	"Ｎ",
	"Ｒ特色指令：传功",
	"Ｗ将五格范围内我方任一队友当前集气提升500点"
	}
	TFJS[106] = {"Ｌ金刀无敌",
	"Ｗ装备金刀，五虎断门刀威力+300",
	"Ｗ七书后五虎断门刀威力翻倍"
	}
	TFJS[141] = {"Ｌ剑宗弃徒",
	"Ｗ "
	}
	TFJS[142] = {"Ｌ狂风快剑",
	"Ｗ夺命三仙剑连击时，伤害提高20%，一轮攻击中可叠加",
	"Ｗ使用剑法攻击，下回合集气+300"
	}
	TFJS[143] = {"Ｌ桃谷六仙",
	"Ｗ "
	}
	TFJS[144] = {"Ｌ桃谷六仙",
	"Ｗ "
	}
	TFJS[145] = {"Ｌ桃谷六仙",
	"Ｗ "
	}
	TFJS[146] = {"Ｌ桃谷六仙",
	"Ｗ "
	}
	TFJS[147] = {"Ｌ桃谷六仙",
	"Ｒ六位一体",
	"Ｗ单通模式下桃谷六仙可集体出战",
	"Ｗ单通模式下继承桃花仙全部属性",
	"Ｗ单通模式下桃花仙升级没有自由属性点",
	"Ｒ阵法：桃谷六仙",
	"Ｗ气防+600",	
	}
	TFJS[148] = {"Ｌ桃谷六仙",
	"Ｗ "
	}
	TFJS[149] = {"Ｌ少林掌门",
	"Ｗ无视限制条件修炼金刚不坏体",
	"Ｌ业由心生·回转有道",
	"Ｗ满怒时，怒气封穴内伤清0，集气速度*2，持续15时序，持续期间不产生怒气",
	"Ｌ舍己度人",
	"Ｗ被攻击几率发动，内功不会护体，使攻击者集气倒走6时序",
	"Ｎ",
	"Ｌ特技：千手如来掌",
	"Ｗ使用拳法攻击时，攻击范围增加一格",
	"Ｎ",
	"Ｌ特技：易筋经大成",
	"Ｗ免疫敌方三大吸功的吸内效果",
	"Ｎ",
	"Ｒ特色指令：金身",
	"Ｗ开启后，自身受到的伤害降低50%，但被攻击时将无法获得怒气值",
	"Ｗ在开启状态下再次使用则关闭"
	}
	TFJS[74] = {"Ｌ翠羽黄衫",
	"Ｗ使用三分剑术攻击杀敌体力7-8点",
	"Ｗ七书后三分剑术威力+300",
	"Ｎ",
	"Ｒ特色指令：兵法",
	"Ｗ2书解锁  <借刀杀人> — 指定一名敌方角色令其强制攻击一次",
	"Ｗ4书解锁  <固若金汤> — 100时序内我方全体角色受伤害降低30%",
	"Ｗ6书解锁  <火烧连营> — 对敌方全体角色强制追加灼烧50点",
	"Ｗ8书解锁  <霸王别姬> — 指定一名敌方女性角色令其强制退场",
	"Ｗ10书解锁 <军神再临> — 100时序内自身行动时可连续行动两次",
	}
	TFJS["74-1"] = {"Ｌ手刃陈哥",
	"Ｗ使用三分剑术攻击杀敌体力7-8点",
	"Ｗ七书后三分剑术威力+300",
	"Ｗ个人觉醒后三分剑术威力+600",
	"Ｎ",
	"Ｒ特色指令：兵法",
	"Ｗ2书解锁  <借刀杀人> — 指定一名敌方角色令其强制攻击一次",
	"Ｗ4书解锁  <固若金汤> — 100时序内我方全体角色受伤害降低30%",
	"Ｗ6书解锁  <火烧连营> — 对敌方全体角色强制追加灼烧100点",
	"Ｗ8书解锁  <霸王别姬> — 指定一名敌方女性角色令其强制退场",
	"Ｗ10书解锁 <军神再临> — 100时序内自身行动时可连续行动两次",
	}
	TFJS[75] = {"Ｌ天池红花",
	"Ｗ升级时兵器值大幅提高",
	"Ｗ七书后五系兵器值可突破上限",
	"Ｎ",
	"Ｌ特技：庖丁解牛（畅想主角专属）",
	"Ｗ攻击时有50%几率无视敌方70%防御",
	"Ｎ",	
	"Ｒ香魂",
	"Ｗ被女性攻击伤害×150%，对女性攻击伤害×75%"
	}
	TFJS[80] = {"Ｌ勇猛精进",
	"Ｗ我方全体攻击效果提高10%",
	"Ｎ",
	"Ｌ火手判官",
	"Ｗ攻击时所造成内伤效果加倍",
	"Ｎ",
	"Ｌ天赋内功",
	"Ｗ修炼纯阳无极功与九阳神功一脉相承后，天赋内功变为九阳神功",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ武当山偷太极三宝支线，洗第二、三格武功"
	}
	TFJS[151] = {"Ｌ奔雷手",
	"Ｗ拳掌攻击附加雷电，随机攻击敌方",
	"Ｗ暴怒行动后不清空怒气",
	"Ｗ暴怒不增加集气速度，免疫杀气",
	"Ｗ队友被击退立即行动，自身生命值35%以下被攻击也有几率触发",
	}
	TFJS[152] = {"Ｌ追魂夺命剑",
	"Ｗ使用剑法时附加追魂夺命效果，使敌人10时序内集气紊乱"
	}
	TFJS[153] = {"Ｌ千臂如来",
	"Ｗ初始暗器值200点",
	"Ｒ回龙壁",
	"Ｗ释放暗器后30%概率再次释放暗器，伤害降低40%",
	"Ｎ",
	"Ｌ暗器之王",
	"Ｗ战斗胜利后随机获得暗器"
	}
	TFJS[154] = {"Ｌ鸳鸯刀",
	"Ｗ战场上男性角色越多其攻击效果越高"
	}
	TFJS[155] = {"Ｌ黑无常",
	"Ｒ不屈",
	"Ｗ战斗中被击退时30%概率重生，第一次必定成功"
	}
	TFJS[156] = {"Ｌ白无常",
	"Ｒ不屈",
	"Ｗ战斗中被击退时30%概率重生，第一次必定成功"
	}
	TFJS[58] = {"Ｌ逆流勇进",
	"Ｗ生命值低于50%时暴击率两倍，生命值低于25%时暴击率3倍",
	"Ｗ当生命值50%时，生命值每再降低1%，下回合集气位置+10点",
	"Ｌ独臂大侠",
	"Ｗ独臂也能修炼不一样的左右互搏",
	"Ｎ",
	"Ｌ西狂",
	"Ｗ每本天书获得的感悟点+40",
	"Ｗ玄铁剑法『重剑真传』的触发几率提高，追加二次判定",
	"Ｗ攻击时附带“西狂之怒啸”，敌方全体集气倒退100点",
	"Ｗ战斗中，当小龙女被击退时，杨过立即出手并发动【西狂之震怒·雷霆狂啸】",
	"Ｎ",
	"Ｄ黯然极意",
	"Ｗ血量低于70%或内伤大于30时，使用黯然销魂掌有几率触发极意",
	"Ｗ血量越低，内伤越高，几率越高，满足条件时暴怒必定触发",
	"Ｗ资质大于等于50，触发黯然极意必出三叠浪",
	"Ｗ资质低于50，触发黯然极意必定连击",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ作为畅想主角时，有大量专属剧情",
	"Ｗ独孤剑冢拿玄铁剑法时，洗第一格武功",
	"Ｗ神雕重阳宫大战后，洗第三格武功，可选择洗天赋内功",
	"Ｗ神雕剧情十六年后，可选择洗第三格武功和天赋内功",
	"Ｗ神雕百花谷剧情后，洗第二格武功",
	"Ｗ射雕牛家村支线，可选择洗第三格武功和天赋内功",
	"Ｗ华山绝顶支线剧情，可选择洗第五格武功"
	}
	TFJS[59] = {"Ｌ一片冰心",
	"Ｗ左右互搏发动概率70%",
	"Ｎ",
	"Ｌ冷若天仙",
	"Ｗ使用玉女素心剑法高几率连击",
	"Ｌ进趋如风",
	"Ｗ额外增加一次攻击"
	}
	TFJS[62] = {"Ｌ元蒙帝师",
	"Ｗ任何攻击追加2500点气攻",
	"Ｎ",
	"Ｒ特色指令：龙象",
	"Ｗ使用后自动执行蓄力，并使下一次的攻击附加昏迷效果",
	"Ｗ昏迷的敌人将丧失一次行动机会",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ神雕重阳宫大战后，洗第二格武功，天赋外功洗为五轮大转"
	}
	TFJS[63] = {"Ｌ外和内刚",
	"Ｗ生命值低于50%时，攻击效果提升20%",
	"Ｎ",
	"Ｌ青箫落瑛",
	"Ｗ使用玉箫剑法攻击，可杀敌内力300点",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ射雕正线牛家村剧情，洗第二、三格武功"
	}
	TFJS[84] = {"Ｌ吾乃蛮夷",
	"Ｗ任何攻击追加1000点气攻",
	"Ｗ攻击时概率发动\"暗箭·扇中钉\"，无视敌方毒抗强制上毒13-16点"
	}
	TFJS[89] = {"Ｌ食神",
	"Ｗ攻击不消耗体力",
	"Ｎ",
	"Ｒ特色指令：气补",
	"Ｗ回复指定邻接队友体力50点"
	}
	TFJS[157] = {"Ｌ湘西尸王",
	"Ｗ七书后鹤蛇八打威力翻倍"
	}
	TFJS[158] = {"Ｌ波斯大贾",
	"Ｗ作为畅想主角时开局获得一万银两"
	}
	TFJS[159] = {"Ｌ释迦掷象功",
	"Ｗ必定单击，伤害永久提高1.5倍（天赋外功与如雷的额外连击有效）"
	}
	TFJS[160] = {"Ｌ尊师重道",
	"Ｎ",
	"Ｒ特色指令：死战",
	"Ｗ锁定一名敌人，至其死亡之前，达尔巴对其的攻击效果提高50%，且必定命中",
	"Ｗ在目标死亡之前无法更换目标"
	}
	TFJS[161] = {"Ｌ赤练仙子",
	"Ｗ对男性伤害提高10%",
	"Ｗ使用五毒神掌时，有70%几率变为赤练神掌，追加70点伤害，并强制上毒20点",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ神雕邪线古墓密道剧情，洗第二、三格武功，天赋内功洗为玉女心经"
	}
	TFJS[38] = {"Ｌ名相皆无",
	"Ｗ计算加力/护体/出招几率时必定开启二次判定",
	"Ｗ学有罗汉伏魔功，攻击时必出【罗汉伏魔】特效",
	"Ｗ【罗汉伏魔】特效效果增强10%（包括伤害和杀气）",
	"Ｗ内力上限9999",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ侠客正线挑战岛主剧情，洗第二格武功，天赋内功洗为太玄神功"
	}
	TFJS["38-1"] = {"Ｌ名相皆无",
	"Ｗ计算加力/护体/出招几率时必定开启二次判定",
	"Ｗ学有罗汉伏魔功，攻击时必出【罗汉伏魔】特效",
	"Ｗ【罗汉伏魔】特效效果增强10%（包括伤害和杀气）",
	"Ｗ内力上限9999",
	"Ｎ",
	"Ｌ混沦太玄",
	"Ｗ可使用太玄神功攻击，并可选择招式",
	"Ｗ太玄神功耗内降低50%（与天赋外功效果叠加，降低75%内力消耗）",
	"Ｗ被攻击时，有50%概率触发太玄反震，对攻击方造成10点封穴",
	"Ｗ被攻击时，有30%概率将受到的伤害转化为减半回血",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ侠客正线挑战岛主剧情，洗第二格武功，天赋内功洗为太玄神功"
	}
	TFJS[39] = {"Ｌ侠客岛主",
	"Ｗ攻击效果提升20%",
	"Ｗ攻击范围+2，敌方攻击范围-1",
	"Ｗ使用任何武功高几率造成封穴",
	"Ｌ威震中原",
	"Ｗ所有敌方伤害降低20%",
	"Ｇ福缘际遇",
	"Ｗ侠客邪线剧情，洗第二格武功，天赋内功洗为太玄神功"
	}
	TFJS[40] = {"Ｌ侠客岛主",
	"Ｗ防御效果提升20%",
	"Ｗ攻击范围+1，敌方攻击范围-2",
	"Ｌ威震中原",
	"Ｗ所有友方伤害增加20%",
	"Ｇ福缘际遇",
	"Ｗ侠客邪线剧情，洗第二格武功，天赋内功洗为太玄神功"
	}
	TFJS[41] = {"Ｌ赏善罚恶",
	"Ｗ攻击时高几率附带灼烧",
	"Ｗ单通模式张三李四同时出战",
	"Ｗ李四继承张三武功和属性",
	}
	TFJS[42] = {"Ｌ罚恶使者",
	"Ｗ攻击时高几率附带冰封"
	}
	TFJS[43] = {"Ｌ雪山派掌门",
	"Ｗ七书后雪山剑法威力翻倍",
	"Ｗ使用雪山剑法几率冻结",
	}
	TFJS[162] = {"Ｌ一日不过三",
	"Ｗ "
	}
	TFJS[163] = {"Ｌ一日不过四",
	"Ｗ "
	}
	TFJS[164] = {"Ｌ摩天居士",
	"Ｗ自带“控鹤功”加力护体（1000威力，可叠加）几率与天书数、实战有关",
	"Ｗ伤害随距离递增，上限11格，最多增加30%",
	"Ｌ擒龙控鹤",
	"Ｗ敌方攻击范围-1，自身攻击范围+1",
	"Ｗ敌方移动范围-1，自身移动范围+1",
	"Ｗ学有擒龙功，使敌方攻击范围-1，自身攻击范围+1",
	"Ｗ学有擒龙功，使敌方移动范围-1，自身移动范围+1",
	"Ｇ福缘际遇",
	"Ｗ战斗中实战300以上，第三格武功洗为碧针清掌 极",
	}
	TFJS[85] = {"Ｌ老谋深算",
	"Ｗ医疗能力上限400",
	"Ｗ五行六合掌攻击会附带负面状态",
	"Ｎ",
	"Ｌ久病成医",
	"Ｗ受到伤害回复（伤害的35%+30）生命值",
	"Ｗ时序回复2点生命值",
	}
	TFJS[5] = {"Ｌ太极宗师",
	"Ｗ太极拳连击时亦享受借力打力效果",
	"Ｗ太极奥义发动概率无视资质固定为75%",
	"Ｗ攻击时概率发动万法自然，下回合集气+500",
	"Ｗ攻击时几率触发化朽为奇，追加1000气攻",
	"Ｗ被攻击几率发动无根无形，防御效果提升50%",
	"Ｗ移动格数至少为8格",
	"Ｚ◇<开太极>",
	"Ｗ◇学会太极神功，使用太极拳剑蓄力值超过500且暴怒触发",
	"Ｗ◇根据当前生命值跟内力值追加大范围伤害，生命越低/内力越高伤害越高",
	"Ｗ◇触发将消耗自己10%当前体力值+10%当前内力值",  
	"Ｇ福缘际遇",
	"Ｗ战斗中实战增加时，攻防轻拳御指刀特以及武学常识中随机一项提升1点",
	"Ｗ实战大于100，第一格领悟太极拳",
	"Ｗ实战大于200，第二格领悟纯阳无极功",
	"Ｗ实战大于300，第三格领悟梯云纵",	
	"Ｗ实战大于400，第四格领悟太极剑",
	"Ｗ实战等于500，第五格领悟太极神功",
    }
	TFJS[6] = {"Ｌ灭绝师太",
	"Ｗ使用任何武功高连击，必暴击",
	"Ｗ移动格数+3",
	"Ｗ装备倚天剑，攻击强制杀气100点",
	"Ｎ",
	"Ｒ特色指令：俱焚",
	"Ｗ开启后100时序，自身造成和受到的伤害皆提高50%，不消耗回合"
	}
	TFJS[7] = {"Ｌ铁琴先生",
	"Ｗ攻击时，有60%几率给敌方附加1-3层琴音状态",
	"Ｗ每层琴音状态降低敌方1%集气速度",
	"Ｗ琴音状态叠加上限为20层",
	"Ｎ",
	"Ｒ特色指令：铁琴",
	"Ｗ使全场敌人受到其身上琴音层数×50点伤害，并清除其身上的琴音状态"
	}
	TFJS[8] = {"Ｌ崆峒掌门",
	"Ｗ "
	}
	TFJS[9] = {"Ｌ运转乾坤",
	"Ｗ内力上限9999",
	"Ｗ乾坤大挪移反弹效果 强化至反弹40%伤害（无需运功）",
	"Ｗ乾坤大挪移可同时反弹给两个人",
	"Ｗ习得乾坤大挪移后自动运功",
	"Ｎ",
	"Ｌ特技：逆转乾坤（畅想主角专属）",
	"Ｄ学会乾坤后，被攻击时，有（35+天书数）%的几率触发，可以选择",
	"ＷA.在两格范围内对敌方的攻击落点进行挪移（消耗300点内力）",
	"ＷB.按ESC键取消挪移，本次被攻击必定发动乾坤反弹50%伤害（无需运功）",
	"Ｚ触发『逆转乾坤』后，敌方的误伤伤害将大幅提高，并且对误伤者有杀气效果",
	"Ｚ主角处于爆豆状态时，『逆转乾坤』触发几率提升10%",	
	"Ｎ",
	"Ｌ宅心仁厚",
	"Ｗ攻击时25%概率伤害杀气减少25%",
	"Ｎ",
	"Ｌ九阳明尊",
	"Ｗ未触发内功加力，护体时，补偿九阳神功加力，护体",
	"Ｎ",
	"Ｒ特色指令：挪移",
	"Ｗ将八格范围内的我方任一队友挪移到指定位置",
	"Ｎ",	
	"Ｇ福缘际遇",
	"Ｗ光明顶密道拿到乾坤时，洗第二格武功",
	"Ｗ武当山见张三丰，洗第三、四格武功",
	"Ｗ获得七伤拳时，洗第五格武功"
	}
	TFJS[10] = {"Ｌ光明右使",
	"Ｗ战斗中实战每50点可选择五系其一提高10点",
	"Ｗ每次受到攻击，增加自身1%的减伤，上限20%"
	}
	TFJS[11] = {"Ｌ光明左使",
	"Ｗ每次攻击，使敌方受到的伤害提高3%，上限50%"
	}
	TFJS[12] = {"Ｌ白眉鹰王",
	"Ｗ七书后，鹰爪功威力加倍",
	"Ｗ自带“鹰王真气”，提供额外的气攻气防"
	}
	TFJS[13] = {"Ｌ金毛狮王",
	"Ｗ狮子吼发动条件放宽为敌方内力低于自身即可",
	"Ｗ七伤拳效果概率提高",
	"Ｗ防御效果提升40%",
	"Ｎ",
	"Ｒ特色指令：咆哮",
	"Ｗ使全场敌人进入混乱状态20时序，此状态下敌人行动时的敌我关系为随机",
	"Ｗ不会全部随机到我方，以免出现直接获胜的情况"
	}
	TFJS[14] = {"Ｌ青翼蝠王",
	"Ｗ随实战集气速度最高提升20点，移动范围最高提升10",
	"Ｗ七书后，寒冰绵掌威力加倍",
	"Ｎ",
	"Ｌ吸血蝙蝠",
	"Ｗ攻击时，恢复造成伤害20%的血量（单次攻击吸血上限500点）"
	}
	TFJS[15] = {"Ｌ紫衫龙王",
	"Ｗ进入战斗随实战最高获得6层倾国层数",
	"Ｎ",
	"Ｒ特色指令：倾国",
	"Ｗ开启后，接下来受到的前6次攻击将折射给在场随机第三方人物"
	}
	TFJS[16] = {"Ｌ蝶谷医仙",
	"Ｗ医疗上限500点",
	"Ｗ可向队友用药",
	"Ｗ全场友军使用药品效果上升30%",
	"Ｎ",
	"Ｒ特色指令：群疗",
	"Ｗ周围五格范围内的队友时序回内伤并按比例回血，持续20时序"
	}
	TFJS[17] = {"Ｌ蝶谷毒仙",
	"Ｗ用毒能力上限500",
	"Ｎ",
	"Ｒ特色指令：施毒",
	"Ｗ周围五格范围内的敌人时序中毒，持续50时序"
	}
	TFJS[18] = {"Ｌ混元霹雳手",
	"Ｗ自带混元霹雳功加力、护体，大概600威力，可叠加,几率与实战及天书数量有关",
	"Ｗ幻阴指威力+200，必冰封",
	"Ｗ使用任何武功高几率连击",
	"Ｗ使用任何武功高几率封穴"
	}
	TFJS[66] = {"Ｌ波斯圣女",
	"Ｗ敌全体移动减三格",
	"Ｗ可使用圣火神功攻击，并追加1500点气攻",
	"Ｗ使用圣火神功攻击时，兵器值判定必定不低于敌方",
	"Ｎ",
	"Ｒ特色指令：影步",
	"Ｗ标记自身周围一点，被攻击则移动至该处，且追加一次攻击"
	}
	TFJS[81] = {"Ｌ雪岭双姝",
	"Ｗ战场上我方男性角色越多其攻击效果越高",
	"Ｒ倚邪莫声谷支线后觉醒：娇媚婉转",
	"Ｗ使用一阳指如暴击，暴击系数叠加，再次判定暴击"
	}
	TFJS[82] = {"Ｌ玉面孟尝",
	"Ｗ战场上我方女性角色越多其攻击效果越高",
	"Ｒ倚邪莫声谷支线后觉醒：情意绵绵",
	"Ｗ使用绵掌如连击，连击次数+1，再次判定连击",
	}
	TFJS[107] = {"Ｌ华山门人",
	"Ｗ "
	}
	TFJS[108] = {"Ｌ华山门人",
	"Ｗ "
	}
	TFJS[109] = {"Ｌ华山门人",
	"Ｗ "
	}
	TFJS[165] = {"Ｌ子柳传人",
	"Ｗ "
	}
	TFJS[166] = {"Ｌ太上掌门",
	"Ｗ "
	}
	TFJS[167] = {"Ｌ崆峒五老",
	"Ｗ "
	}
	TFJS[169] = {"Ｌ四大神僧",
	"Ｗ "
	}
	TFJS[170] = {"Ｌ四大神僧",
	"Ｗ《倚天屠龙记》中，少林派的四大神僧“见闻智性”之一",
	"Ｎ",
	"Ｒ特色指令：检测",
	"Ｗ检测指定敌方的战斗力，并根据情况调整自己的策略",
	}
	TFJS[168] = {"Ｌ崆峒五老",
	"Ｗ "
	}
	TFJS[171] = {"Ｌ武当儒侠",
	"Ｗ使用太极拳或太极剑攻击后自动进入防御状态",
	"Ｎ",
	"Ｌ天赋内功",
	"Ｗ修炼纯阳无极功与九阳神功一脉相承后，天赋内功变为九阳神功"
	}
	TFJS[172] = {"Ｌ武当七侠",
	"Ｗ ",
	"Ｎ",
	"Ｌ天赋内功",
	"Ｗ修炼纯阳无极功与九阳神功一脉相承后，天赋内功变为九阳神功"
	}
	TFJS[173] = {"Ｌ波斯风使",
	"Ｗ主运圣火时必定击中破绽"
	}
	TFJS[174] = {"Ｌ波斯云使",
	"Ｗ主运圣火时必定击中破绽"
	}
    TFJS[175] = {"Ｌ波斯月使",
	"Ｗ主运圣火时必定击中破绽"
	}
	TFJS[54] = {"Ｌ志垂日月",
	"Ｗ基础暴击率提升",
	"Ｗ暴击效果随天书数量提升（仅我方有效）",
	"Ｎ",
	"Ｌ碧血长风（畅想主角专属）",
	"Ｗ本次行动如击退至少一名敌方，则可再次行动",
	"Ｎ",
	"Ｌ金蛇传人",
	"Ｗ使用暗器金蛇锥必定造成最高倍伤害",
	"Ｎ",
	"Ｚ＜未解锁＞",
	"Ｗ？？？？？？",
	"Ｗ？？？？？？"
	}
	TFJS["54-1"] = {"Ｌ志垂日月",
	"Ｗ基础暴击率提升",
	"Ｗ暴击效果随天书数量提升（仅我方有效）",
	"Ｎ",
	"Ｌ碧血长风（畅想主角专属）",
	"Ｗ本次行动如击退至少一名敌方，则可再次行动",
	"Ｎ",
	"Ｌ金蛇传人",
	"Ｗ使用暗器金蛇锥必定造成最高倍伤害",
	"Ｎ",
	"Ｚ长平公主的眷恋",
	"Ｗ神行百变闪避/减伤几率提高",
	"Ｗ生命值低于30%时，可触发金蛇奥义"
	}
	TFJS[91] = {"Ｌ青青子衿",
	"Ｗ爱她请救活她",
	"Ｗ暴击无视100%防御",
	"Ｗ连击伤害提高35%",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ7书后雷震剑法自带专精效果",
	"Ｗ金蛇山洞拔出金蛇剑，洗第一格武功和天赋外功"
	}
	TFJS["91-1"] = {"Ｌ青青子衿",
	"Ｗ暴击无视100%防御",
	"Ｗ连击伤害提高35%",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ7书后雷震剑法自带专精效果",
	"Ｗ金蛇山洞拔出金蛇剑，洗第一格武功和天赋外功",
	"Ｗ碧血正线华山后山，用十颗天王保命丹救活后洗天赋轻功",
	"Ｎ",
	"Ｒ特色指令：大暴",
	"Ｗ本次攻击必定连击，且连击时伤害/气攻不减"
	}
	TFJS[83] = {"Ｌ纤纤铁手",
	"Ｗ使用五毒神掌攻击，随机2-5倍威力",
	"Ｗ自带“红袖拂风”加力、护体，500威力，可叠加（几率与天书数、实战相关）",
	"Ｎ",
	"Ｌ五毒教主",
	"Ｗ被攻击无视毒抗使攻击者中毒45~50点",
	"Ｗ用毒能力上限500",
	"Ｎ",
	"Ｌ特技：含沙射影",
	"Ｗ暗器攻击范围提升至7×7方阵"
	}
	TFJS[176] = {"Ｌ五毒教姑",
	"Ｗ "
	}
	TFJS[182] = {"Ｌ五丁手",
	"Ｗ "
	}
	TFJS[183] = {"Ｌ没影子",
	"Ｗ "
	}
	TFJS[184] = {"Ｌ护国真人",
	"Ｗ使用铁血十二式，随机1-12倍威力",
	"Ｗ自带冰火毒龙",
	"Ｚ攀云乘龙",
	"Ｗ神行百变闪避/减伤几率提高",
	}
	TFJS[185] = {"Ｌ神剑仙猿",
	"Ｗ攻击时高几率造成封穴",
	"Ｚ天地玄黄",
	"Ｗ天：被攻击时8%概率免疫攻击",
	"Ｗ地：被攻击时8%概率伤害降为30点",
	"Ｗ玄：被攻击时8%概率将伤害转化为回血",
	"Ｗ黄：被攻击时8%概率用内力抵消一半伤害",
	"Ｚ神游太虚",
	"Ｗ神：被攻击时5%概率敌方变为蓄力，停止攻击",
	"Ｗ游：被攻击时5%概率敌方变为防御，停止攻击",
	"Ｗ太：被攻击时5%概率敌方变为集中，停止攻击",
	"Ｗ虚：被攻击时5%概率敌方变为等待，停止攻击",
	}
	TFJS[186] = {"Ｌ神拳无敌",
	"Ｗ使用拳法攻击追加100点真实伤害，额外提供50%拳掌系数的伤害。",
	"Ｗ如未装备武器，则此加成翻倍"
	}
	TFJS[187] = {"Ｌ八面威风",
	"Ｗ "
	}
	TFJS[188] = {"Ｌ铜笔铁算盘",
	"Ｗ "
	}
	TFJS[459] = {"Ｌ丐帮帮主",
	"Ｗ降龙十八掌加打狗棒法不会触发盖世无双",
	}
	TFJS[77] = {"Ｌ珠联璧合",
	"Ｗ使用夫妻刀法无误伤",
	"Ｗ可装备专属武器鸯刀",
	"Ｗ在队伍中时，可以在战斗开始前布阵",
	"Ｗ与主角同时在场时，主角集气速度增加2点",
	"Ｎ",
	"Ｌ秀外慧中",
	"Ｗ这妹子不光外表美丽，内心也是极美的",
	"Ｎ",
	"Ｒ特色指令：慧心",
	"Ｗ回复主角的状态，主角满怒气并满集气",
	"Ｎ",
	"Ｒ特殊天赋：绝代佳人",
	"Ｗ天生的美人胚子，食用大蟠桃可以变得更美",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ书剑双线剧情，洗第一格武功",
	"Ｗ鸳鸯岛见萧半和，洗第一格武功"
	}
	TFJS[592] = {"Ｌ意在形先",
	"Ｗ进入战斗的初始集气位置加500，自身移动步数锁定为10格，免疫暗器",
	"Ｎ",
	"Ｌ无我无剑",
	"Ｗ被攻击时，根据敌我御剑系数/攻防/内力/武常差值先手反击敌方全体",
	"Ｎ",
	"Ｇ剑道神话",
	"Ｗ战斗中，个人武常计算结果必定不会低于敌方，集气速度锁定全场最高"
	}
--[[	TFJS[92] = {"Ｌ东方菇凉",
	"Ｗ所有攻击无误伤",
	"Ｎ",
	"Ｌ扑朔迷离",
	"Ｒ特色指令：换装",
	"Ｗ使用后改变自身外形"
	}--]]
	--韦小宝
	TFJS[601] = {"Ｌ机敏无双",
	"Ｗ战斗开始前50时序，受到的伤害不超过50点",
	"Ｎ",
	"Ｒ特色指令：口才",
	"Ｗ使一名敌方进入沉睡状态，此状态无法集气，不会自行解除，受到攻击会醒来",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ鹿鼎记鳌府密室剧情，洗第一、二格武功"
	}
	--海大富
	TFJS[602] = {"Ｌ大内总管",
	"Ｗ使用化骨绵掌附加腐蚀状态20时序，使敌人伤害杀气降低25%，持续损失生命",
	"Ｗ自带化骨绵掌专精效果",
	"Ｗ七书后，化骨绵掌威力加倍",
	}
	--鳌拜
	TFJS[603] = {"Ｌ满洲勇士",
	"Ｗ主运金刚不坏体，必定发动\"金钟罩护体\"特效"
	}
	TFJS[604] = {"Ｌ天元剑气",
	"Ｗ使用剑系武功攻击时，敌方御剑系数按零计算",
	"Ｎ",
	"Ｌ听风辨位",
	"Ｗ无视敌方的闪避效果（包括刺目，轻功，天赋等）",
	"Ｎ",
	"Ｌ越女剑仙",
	"Ｗ使用越女剑法攻击无误伤",
	"Ｗ每次行动前解除自身内伤中毒",
	"Ｗ自带“九霄仙息”护体，几率增加自身御剑系数×10点气防"
	}
	TFJS[605] = {"Ｌ惊才绝艳",
	"Ｗ武功威力提高10%，加力/护体/出招几率提高10%，总气攻提高10%",
	"Ｎ",
	"Ｌ夭矫空碧",
	"Ｗ连击时伤害、杀气不减",
	"Ｌ姑射仙姿",
	"Ｗ被攻击时必发动\"轻云蔽月\"，免疫攻击10时序，冷却时间50时序",
	"Ｗ攻击时几率发动\"流风回雪\"，本次攻击必定造成冰封"	
	}
	--阿凡提
	TFJS[606] = {"Ｌ踏沙无痕",
	"Ｗ移动格数+3，攻击后可以再次移动",
	"Ｎ",
	"Ｌ西域战神",
	"Ｗ拥有专属坐骑毛驴",
	"Ｗ休息时自带蓄力兼防御效果"
	}
	--焦宛儿
	TFJS[607] = {"Ｌ乱世浮萍",
	"Ｗ我方全体连击率提高10%"
	}
	--赵敏
	TFJS[609] = {"Ｌ机智多谋",
	"Ｗ在场时，我方全体获得如下光环：",
	"Ｗ处于蓄力状态时，增加自身20%减伤（蓄力必定成功）",
	"Ｗ处于防御状态时，有20%几率闪避",
	"Ｎ",
	"Ｌ绍敏郡主",
	"Ｗ被攻击时，攻击方会损失其造成伤害30%的血量",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ神雕邪线襄阳剧情，洗第二格武功，天赋内功洗为天魔功"
	}
	--公孙止
	TFJS[616] = {"Ｌ绝情谷主",
	"Ｗ本方每阵亡一名队友，集气速度增加3点",
	"Ｎ",
	"Ｌ特技：闭穴功",
	"Ｗ受到的封穴降低50%"
	}
	--裘千尺
	TFJS[617] = {"Ｌ铁掌莲花",
	"Ｗ作为畅想主角时可以获得年轻漂亮的头像贴图",
	"Ｗ枣核钉可触发花开花落特效"
	}
	--郭襄
	TFJS[626] = {"Ｌ小东邪",
	"Ｗ无需修炼三种武功即可触发桃花绝技",
	"Ｎ",
	"Ｒ特色指令：玲珑",
	"Ｗ可自由切换第一格武功为弹指神通/玉萧剑法/落英神剑掌，不消耗回合"
	}
	--郭襄
	TFJS["626-1"] = {"Ｌ小东邪",
	"Ｗ无需修炼三种武功即可触发桃花绝技",
	"Ｎ",
	"Ｌ峨眉祖师",
	"Ｗ领悟“诸天化身步”，被攻击时有30%概率完全闪避，并锁定反击全场",
	"Ｗ造成的伤害等同于自身五系兵器值中最高的一项",
	"Ｎ",
	"Ｒ特色指令：玲珑",
	"Ｗ可自由切换第一格武功为弹指神通/玉萧剑法/落英神剑掌，不消耗回合"
	}
	--神雕
	TFJS[628] = {"Ｌ雕兄",
	"Ｗ玄铁剑法『重剑真传』的触发几率提高，追加二次判定",
	"Ｎ",
	"Ｌ鹏程万里",
	"Ｗ移动格数+3"
	}
	--阿九
	TFJS[629] = {"Ｌ长平公主",
	"Ｗ使用铁血十二式，随机4-8倍威力",
	"Ｗ每次行动前有60%几率使敌方全体集气位置倒退100"
	}
	--四大山
	TFJS[642] = {"Ｌ精心打磨",
	"Ｗ使用达摩掌攻击获得6000银两。",
	}
	--阿大
	TFJS[643] = {"Ｌ八臂神剑",
	"Ｗ使用剑法攻击敌人，附加20时序负面效果，时序内冰封、内伤、中毒的减速效果翻倍。",
	}
	--阿二
	TFJS[644] = {"Ｌ天生神力",
	"Ｗ使用龙爪手后自动蓄力",
	}
	--阿三
	TFJS[645] = {"Ｌ金刚伏魔",
	"Ｗ使用大力金刚指30%几率使目标瘫痪10时序",
	}
	--尹志平
	TFJS[653] = {"Ｌ龙骑士",
	"Ｗ真实历史人物，在道教成就很高，在战乱，灾年多救助百姓，品德高尚。",
	"Ｗ懂医术，多治病救人。是一位得道高人，深受百姓爱戴。",
	}
	--李逍遥
	TFJS[655] = {"Ｌ仙剑奇侠",
	"Ｗ原是一乡下客栈店小二，经历重重磨难成长为一代旷世奇侠。",
	"Ｎ",
	"Ｒ特色指令：探云",
	"Ｗ偷窃敌方携带的物品"
	}
	--赵灵儿
	TFJS[656] = {"Ｌ女娲后人",
	"Ｗ受天命眷顾，女娲族裔与人类共生之女。",
	"Ｌ五气朝元",
	"Ｗ每回合行动后，回复我方全体20%损失生命，上限100点。"	
	}
	--林月如
	TFJS[657] = {"Ｌ武门千金",
	"Ｗ南武林盟主林天南独女，后为蜀山派掌门李逍遥夫人。",
	"Ｌ乾坤一掷",
	"Ｗ消耗5000银两，对目标造成1999点伤害。"	
	}
	--阿奴
	TFJS[658] = {"Ｌ海棠夫人",
	"Ｗ对李逍遥一往情深，但逍遥已有所爱，只得默默伴随一旁。",
	"Ｌ万蛊蚀天",
	"Ｗ每回合行动前敌方全体中毒+100，扣除5%当前生命。"	
	}
	--金先生
	TFJS[669] = {"Ｇ查良镛",
	"Ｒ飞雪连天射白鹿，笑书神侠倚碧鸳",
	"Ｚ自带14本天书",
	"Ｗ受到的伤害减少，随天书数提高",
	"Ｇ金庸点评",
	"Ｗ战斗中被攻击或攻击可观察目标，达到9次可以点评其演技",
	"Ｗ每获得一本天书，五系兵器值、三维、武学常识+10",
	"Ｗ进入战斗获得已拥有天书中随机角色天赋",
	}
	--雷震
	TFJS[670] = {"Ｌ八部神威",
	"Ｎ",
	"Ｗ降龙十八掌，打狗棍法，六脉神剑，参合指，火焰刀法，斗转星移获得强化",
	"Ｄ降龙十八掌：气攻提升1800",
	"Ｄ打狗棍法：攻击范围变为面攻",
	"Ｄ六脉神剑：威力提升15%，攻击距离+1",
	"Ｄ参合指：必暴击",
	"Ｄ火焰刀法：必灼烧，额外追加灼烧伤害，修炼拳掌额外+5",
	"Ｄ斗转星移：斗转概率提升10%",
	"Ｎ",
	"Ｒ天怒十方：",
	"Ｗ天龙八部天书剧情中，可获得4种防具，集齐时可获得天怒十方：",
	"Ｗ*集齐四件防具，对铁匠使用银两合成天怒十方：",
	"Ｎ",
	"Ｗ广目无边：每拥有三本天书，移动范围加1",
	"Ｗ多闻无双：五系兵器值+20",
	"Ｗ持国无敌：受到的伤害减少，效果随天书数增加",
	"Ｗ增长无量：攻击伤害随天书数量而增加",
	"Ｎ",
	"Ｚ异世奇侠",
	"Ｗ初始自带六种特效，攻击或被攻击几率触发：",
	"Ｒ挪移掌：被攻击几率发动，减少并反弹伤害",
	"Ｒ金钟罩：被攻击几率发动，减少30%受到的伤害和气攻",
	"Ｒ虚空藏：被攻击几率发动，移动闪避攻击",
	"Ｒ借气回元：被攻击几率发动，减少攻击者集气转为自己的上升集气",
	"Ｒ浊浪排空：攻击几率发动，随指法系数提高增加气攻，满系数暴怒必发动且无视气防",
	"Ｒ地涌天泉：攻击时几率发动，攻击后持续回复状态",
	"Ｎ",
	"Ｗ修炼或使用五系武功，有对应的特效：",
	"Ｄ拳法：提高挪移掌的反弹和减免伤害",
	"Ｄ指法：提高浊浪排空和借气回元的概率效果",
	"Ｄ剑法：使用剑法几率发动全屏攻击、提高气防",
    "Ｄ刀法：提高连击率和连击伤害以及金钟罩概率",
	"Ｄ奇门：增加虚空藏的几率和移动范围以及武功范围",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ游戏开始时在华山后山选择天外时对应兵器值+30",
	"Ｗ每领悟一项六如，五系兵器值各+10",
	"Ｗ天龙八部天书剧情中，可获得4种防具，集齐时可获得天怒十方",
	"Ｗ领悟六如后战胜谢无悠，第一格武功洗为【天佛降世】极",
	"Ｗ7书后可找谢无悠领悟天赋内功，洗第二格武功为天内1级",
	"Ｗ修炼天赋内功会有额外的属性成长和效果：",
	"Ｎ",
	"Ｄ八荒六合功：发动特效时，减少的伤害额外增加35%，受到攻击恢复35血",
	"Ｒ功+2，防+2，轻+1",
	"Ｎ",
	"Ｄ小无相功：主运提高30%气攻，总气防翻倍，被动气防效果提升",
	"Ｒ功+1，防+1，五系兵器值各+1",
	"Ｎ",
	"Ｄ北冥神功：吸内值提高，攻击吸内时，若敌方内力不足，扣除等量血量",
	"Ｒ武学常识+3，功+2，轻+1",
	"Ｎ",
	"Ｄ化功大法：额外化去250内力，并对敌方造成中毒量的伤害",
	"Ｒ攻击带毒+15，功+2，防+1",
	"Ｎ",
	"Ｄ易筋神功：所有武功威力提升20%,平均2时序回复1体力",
	"Ｒ功+2，防+2，轻+2",
	}
	
	TFJS[671] = {"Ｒ天剑化身",
	"Ｗ每习得一个剑法，剑法上限提高50",
	"Ｗ无视条件修炼剑法秘籍",
	"Ｗ剑法范围提升1",
	"Ｗ修炼剑法秘籍御剑系数额外+2，修炼其它秘籍御剑系数额外+1",
	"Ｗ用剑法攻击几率发动无天绝剑扣除全体敌方无名当前内力2%的生命",
	"Ｗ用剑法攻击附带圣灵剑法：剑一至剑二十三，剑十之后每层伤害提高2%",
	"Ｗ最高使出剑（御剑能力/27），最低为上限-4",
	"Ｗ发动剑廿三时，时停10时序，每100点御剑系数延长1时序",
	"Ｗ每100点御剑系数，受到的伤害减少2%，连击暴击率提升2%",
	"Ｎ",
	"Ｒ满血拉二胡",
	"Ｗ生命50%以上时，受到的伤害增加30%,造成的伤害减少30%",
	"Ｒ残血到处浪",
	"Ｗ生命30%以下时，受到的伤害减少30%，每100御剑集气速度提升3点",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ每领悟一项六如，御剑+30",
	"Ｗ领悟六如后与谢无忧战斗胜利后第二格洗【万剑归宗】",
	"Ｒ洗掉所有内功，内力最大值变为0",
	"Ｗ14本天书后，南贤对话，领悟【剑血浮生】，洗1-4格其中一格"
	}
	
	TFJS["671-1"] = {"Ｌ武林神话",
	"Ｗ攻击修为不足的敌人直接秒杀",
	"Ｗ内力硬上限增加3000",
	"Ｎ",
	"Ｒ天剑化身",
	"Ｗ每习得一个剑法，剑法上限提高50",
	"Ｗ无视条件修炼剑法秘籍",
	"Ｗ剑法范围提升1",
	"Ｗ修炼剑法秘籍御剑系数额外+2，修炼其它秘籍御剑系数额外+1",
	"Ｗ用剑法攻击几率发动无天绝剑扣除全体敌方无名当前内力2%的生命",
	"Ｗ用剑法攻击附带圣灵剑法：剑一至剑二十三，剑十之后每层伤害提高2%",
	"Ｗ最高使出剑（御剑能力/27），最低为上限-4",
	"Ｗ发动剑廿三时，时停10时序，每100点御剑系数延长1时序",
	"Ｗ每100点御剑系数，受到的伤害减少2%，连击暴击率提升2%",
	"Ｎ",
	"Ｒ满血拉二胡",
	"Ｗ生命50%以上时，受到的伤害增加30%,造成的伤害减少30%",
	"Ｒ残血到处浪",
	"Ｗ生命30%以下时，受到的伤害减少30%，每100御剑集气速度提升3点",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ每领悟一项六如，御剑+30",
	"Ｗ领悟六如后与谢无忧战斗胜利后第二格洗【万剑归宗】",
	"Ｒ洗掉所有内功，内力最大值变为0",
	"Ｗ14本天书后，南贤对话，领悟【剑血浮生】，洗1-4格其中一格"
	}
	
	TFJS[672] = {"Ｌ菊花剑客",
	"Ｗ剑法攻击连击率提高",
	"Ｗ剑法攻击范围为菊花形",
	"Ｗ连城剑法高连击",
	"Ｎ",
	"Ｒ神照真传",
	"Ｗ主运神照功，受到致命伤有几率不死并恢复一定血量，集气提前",
	"Ｗ主运神照功，攻击伤害增加10%，受到伤害减少10%，时序回复血内3点",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ连城诀剧情，破庙战胜宝象，领悟无影神拳，拳掌+30",
	"Ｗ*攻击几率发动无影神拳特效，除神照功和拳掌攻击外触发几率减半",
	"Ｗ连城诀获得连城剑法时，第二格洗为连城剑法一级，御剑+50",
	"Ｗ正线天宁寺获得神照经时，第一格洗为神照功一级",
	"Ｗ*正：气防+800，减伤10%，行动结束回复生命，无影神拳伤害增加",
	"Ｗ邪线战胜血刀老祖，第一格洗为神照功一级",
	"Ｗ*邪：气攻+800，增伤10%，攻击必造成流血，无影神拳几率增加",
	"Ｗ重学神照后，自带主动效果，集气速度+10，神照功重新到极，拳掌+30",
	"Ｗ重新到极后，用神照功攻击，计算系数会额外加上拳掌系数",
	}
	
	TFJS[693] = {"Ｌ不朽铁拳",
	"Ｗ每获得一本天书，拳掌和拳掌上限提高20",
	"Ｗ普通攻击等级为极",
	"Ｗ连击率提高50%",
	"Ｗ每30点拳掌系数提高1点集气速度",
	"Ｗ拳掌攻击最终伤害附带7%武功威力值",
	"Ｗ攻击伤害减少25%，每次连击使最终伤害提高15%",
	"Ｗ满怒不提供额外集气速度，行动后怒气不清空",
	"Ｎ",
	"Ｒ【气】",
	"Ｗ时序回复1%最大内力值",
	"Ｗ时序回复0.5%已损失生命值",
	"Ｗ行动前35%释放三种气之一（几率随实战和天书数量提升）",
	"Ｗ攻击：攻击伤害提高25%，气功提高2000",
	"Ｗ防御：受到的伤害减少25%，气防提高2000",
	"Ｗ灵巧：集气速度提高25%，25%概率闪避",
	"Ｎ",
	"Ｒ天国之龙",
	"Ｗ五本天书后，连击结束后有几率使用怒气用特殊拳法追加连招",
	"Ｗ受到的最终伤害减少20%",
	"Ｗ集气速度时序提高1",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ随实战和天书增加，战斗中会领悟四种天赋",
	}
	
	TFJS[694] = {"Ｌ大贤良师",
	"Ｗ医疗、解毒和用毒用【祝由】代替",
	"Ｗ对友方使用：解毒、恢复生命值和少量体力",
	"Ｗ对敌方使用：造成中毒和伤害",
	"Ｎ",
	"Ｌ阴阳道",
	"Ｗ当生命百分比小于内力百分比时，时序回复已损失生命值的1%",
	"Ｗ当生命百分比大于内力百分比时，时序回复已损失内力值的1%",
	"Ｎ",
	"Ｌ黄天",
	"Ｗ每有一个队友在队，最终伤害提高3%，受到的伤害减少3%，闪避几率提高3%",
	"Ｗ（14书后视为满队友）",
	"Ｗ闪避之前，每次受到攻击闪避概率会提高",
	"Ｗ闪避之后，对自身使用【祝由】",
	"Ｌ天雷",
	"Ｗ攻击如果被闪避，释放一道闪电攻击目标",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ随实战和天书增加，战斗中会领悟四种天赋",
	}
	
	TFJS[681] = {
	"Ｌ风中之神",
	"Ｗ集气速度提升10",
	"Ｎ",
	"Ｒ刀腿双绝",
	"Ｗ每修炼一个刀法，刀法上限提高30",
	"Ｗ刀法威力提升10%",
	"Ｗ修炼刀法秘籍兵器值额外+1",
	"Ｗ领悟【神风怒嚎】，攻击时全体敌方杀集气100",
	"Ｎ",
	"Ｒ疯血",
	"Ｗ暴怒状态免疫杀气，受到的伤害减少20%",
	"Ｎ",
	"Ｚ不在我之下神功",
	"Ｗ被攻击几率发动",
	"Ｗ攻击者伤害降低30%，受到的伤害增加30%，集气速度降低30%，持续1~30时序",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ随实战增加，领悟【风神腿】，获得属性提高，连击伤害提高",
	"Ｗ随实战和天书增加，战斗中会领悟四种天赋",
	"Ｗ领悟所有六如后，学有冰心诀，暴怒时获得“入魔”指令",
	}
	TFJS[682] = {
	"Ｌ不哭死神",
	"Ｗ集气不受异常状态影响",
	"Ｎ",
	"Ｒ剑掌双绝",
	"Ｗ剑法攻击附带圣灵剑法剑一至剑十，随天书数量提高到二十二",
	"Ｗ十二书后，暴怒有几率发动剑廿三，全场时停9时序",
	"Ｗ拳掌范围+1",
	"Ｌ排云掌",
	"Ｗ拳掌攻击几率触发虚云劲：气功+1000，伤害提高20%，无视20%防御",
	"Ｗ云踪魅影：移动范围+3，10%几率闪避",
	"Ｎ",
	"Ｒ麒麟臂",
	"Ｗ初始攻击力提高，攻击力上限提高100",
	"Ｗ左右互搏第二下伤害提高35%",
	"Ｎ",
	"Ｚ连消带打神功",
	"Ｗ被攻击杀气不会高于250，攻击造成的伤害不会低于250",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ实战100，领悟云十掌，洗第一格",
	"Ｗ实战200，领悟云十剑，洗第二格",
	"Ｗ实战300，天书3本，选择领悟天赋",
	"Ｗ实战450，天书7本，选择领悟天赋",
	"Ｗ七气归一：主运内功时，运行所有内功",
	"Ｗ每运行一个内功，时序额外消耗10点内力",
	"Ｗ逆乾坤：战斗可以复活三次",
	"Ｗ每一次复活，伤害、集气速度提高35%，受到的伤害减少35%",
	"Ｗ每一次复活，时序消耗的生命值会增加",
	}
	
	TFJS[683] = {
	"Ｌ剑神",
	"Ｗ有一种人，已接近神的境界，因为他已无情。",
	"Ｎ",
	"Ｗ修炼剑法秘籍御剑额外+1",
	"Ｗ每修炼一个剑法到极，剑法伤害提高3%",
	"Ｎ",
	"Ｒ剑术超绝",
	"Ｗ剑法攻击必造成流血",
	"Ｗ受到剑法攻击，伤害减少50%",
	"Ｗ剑法攻击无视闪避",
	"Ｗ连击率若超过100%，则超过部分判定第三击",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ随实战和天书提升战斗中领悟四个天赋",
	}
	
	TFJS[684] = {
	"Ｌ小李探花",
	"Ｗ修炼秘籍兵器值额外+1",
	"Ｗ特效几率有二次判定",
	"Ｎ",
	"Ｌ小李飞刀",
	"Ｗ初始暗器提高，连击几率对暗器有效",
	"Ｗ暗器飞刀可以造成暴击，双倍伤害",
	"Ｒ蜻蜓三抄水",
	"Ｗ15%几率闪避",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ随实战提升战斗中领悟四个天赋",
	}
	
	TFJS[685] = {
	"Ｌ迷之仙人",
	"Ｗ无条件修炼秘籍",
	"Ｗ所有武功可练到极",
	"Ｗ初始15%几率免疫伤害，几率随实战提升到30%",
	"Ｎ",
	"Ｌ炼丹之术",
	"Ｗ可修炼太清丹经，炼制丹药",
	"Ｒ炼人",
	"Ｗ可以炼化队伍中一个队友，道德-30",
	"Ｗ被炼化的队友全属性上限变为1点",
	"Ｗ左慈获得被炼化队友的天赋",
	"Ｗ6本天书实战250、12本天书实战500分别可以再次炼化",
	}
	
	TFJS[686] = {
	"Ｌ二爷",
	"Ｒ重病缠身",
	"Ｗ进入战斗，生命为最大值的70%",
	"Ｗ生命值时序减少当前生命的1%",
	"Ｎ",
	"Ｌ北斗神拳",
	"Ｗ拳掌上限+200",
	"Ｗ指法上限+100",
	"Ｗ拳指攻击必封穴",
	"Ｗ拳掌攻击几率触发特殊效果：",
	"Ｄ斗劲呼法：强制杀气（100+拳掌系数），几率杀气到-500",
	"Ｄ天翔百裂拳：必连击，根据封穴值造成额外伤害",
	"Ｄ三尖破孔击：三连击，无视50%防御",
	"Ｄ北斗有情鸿翔波：范围扩大，气功提高",
	"Ｎ",
	"Ｒ柔拳",
	"Ｗ受到的伤害杀气减少35%",
	"Ｒ有情拳",
	"Ｗ拳掌误伤队友时恢复其血量",
	"Ｎ",
	"Ｌ天资无双",
	"Ｗ无条件修炼所有秘籍",
	"Ｗ修炼秘籍系数额外+2",
	"Ｗ三围及兵器值上限+100",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ随实战和天书提升战斗中领悟四个能力",
	}
	
	TFJS[689] = {
	"Ｌ祈求者",
	"Ｒ不会武功",
	"Ｎ",
	"Ｌ元素召唤",
	"Ｗ吾心即为奥术宝典",
	"Ｎ",
	"Ｒ天赋绝顶",
	"Ｗ无条件修炼所有秘籍",
	"Ｗ修炼秘籍所有系数同时成长",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ随实战提升战斗中领悟天赋和成长技能",
	}
	
	TFJS[691] = {
	"Ｌ刀神",
	"Ｗ刀法范围+1，威力提高300，刀法上限+100",
	"Ｗ刀法几率直接杀死生命值30%以下的敌人，生命值越低，几率越高",
	"Ｎ",
	"Ｌ圆月弯刀",
	"Ｗ神刀斩自带专精效果",
	"Ｗ装备圆月弯刀，神刀斩范围+1，所有刀法范围和神刀斩相同",
	"Ｗ神刀斩无视（30+实战/10）%防御",
	"Ｗ使用神刀斩不减生命上限",
	"Ｎ",
	"Ｒ人刀合一",
	"Ｗ刀法连击暴击率和连击伤害随实战大幅提升",
	"Ｎ",
	"Ｒ平平无奇",
	"Ｗ敌方偶尔能忽视你的存在",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ随实战和天书提升战斗中领悟四个能力",
	"Ｗ梦境中胜利两次，第二格变为阴阳大悲赋，胜利三次，第一格变为神刀斩",
	"Ｒ天地交征阴阳大悲赋",
	"Ｗ主运：攻击时60%几率触发天绝地灭大搜魂手，所有敌人生命内力-200，体力-5",
	"Ｗ被动：天移地转大移穴法，免疫封穴，受到的伤害减少20%",
	}
	
	TFJS[687] = {
	"Ｌ大理太祖",
	"Ｗ六脉神剑可选招式",
	"Ｗ一阳指可根据使用次数提升品级",
	"Ｗ进入战斗枯禅功自动运功",
	"Ｎ",
	"Ｌ六脉一阳",
	"Ｗ六脉神剑招式随天书数增加",
	"Ｗ六脉神剑消耗内力减少75%，威力增加20%",
	"Ｗ每练成一招，内力上限增加500",
	"Ｗ一阳指根据品级，增加范围和威力",
	"Ｗ一阳指根据品级，提高暴击几率",
	"Ｗ一阳指根据品级，造成的伤害（4%-20%）转换为生命回复",
	"Ｎ",
	"Ｒ宝刀未老",
	"Ｗ站斗图为老年段思平",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ随实战和天书提升战斗中领悟三个天赋",
	}
	
	TFJS[634] = {
	"Ｌ开派祖师",
	"Ｗ开局获得七宝指环",
	"Ｗ逍遥派武功威力提高30%",
	"Ｎ",
	"Ｌ旷世奇才",
	"Ｗ五系和攻防轻及武学常识上限增加100",
	"Ｗ修炼武功所有兵器值同时增加",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ随实战和天书提升战斗中领悟四个天赋洗2~6格武功",
	}
	
	TFJS[636] = {
	"Ｌ谪仙人",
	"Ｗ特效几率有二次判定",
	"Ｎ",
	"Ｌ酒龙诗虎",
	"Ｗ被攻击15%几率闪避",
	"Ｗ发动攻击时几率吟诗，附加额外效果",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ实战300，第二格洗为太玄神功，天内洗为太玄神功",
	"Ｗ随实战和天书提升战斗中领悟三个天赋",
	}
	
	TFJS[637] = {
	"Ｌ九阴至尊",
	"Ｗ修炼的阳内武功内属视为阴",
	"Ｗ攻击概率给全体敌方附加冰封",
	"Ｗ修炼阳内武功无视内属条件",
	"Ｗ九阴白骨爪、摧心掌和白蟒鞭法无冷却",
	"Ｗ领悟大道归藏后，行动前普通攻击随机变为：",
	"Ｗ九阴白骨爪、摧心掌或者白蟒鞭法，威力提高500",
	"Ｗ领悟大道归藏后，自动主运九阴真经和螺旋九影",
	"Ｗ领悟大道归藏后，同时拥有刚柔并济的效果",
	"Ｎ",
	"Ｌ大道归藏",
	"Ｗ武学常识上限增加200",
	"Ｗ每获得一本天书，武学常识增加20",
	"Ｌ道法自然",
	"Ｗ每100时序可免疫攻击10时序",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ随感悟点增加，领悟九阴真经",
	}
	
	TFJS[638] = {
	"Ｌ九阳至尊",
	"Ｗ修炼的阴内武功内属视为阳",
	"Ｗ修炼阴内武功无视内属条件",
	"Ｗ九阳神功可攻击，且无冷却",
	"Ｗ同时拥有刚柔并济的效果",
	"Ｗ自动主运九阳神功",
	"Ｎ",
	"Ｌ不动如山",
	"Ｗ受到攻击后，受到的伤害减少1%",
	"Ｗ气防增加1500",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ随感悟点增加，领悟九阳真经",
	}
	
	TFJS[688] = {
	"Ｌ虎威将军",
	"Ｗ全体敌方集气速度减少10%，随实战增加到20%",
	"Ｗ集气速度+10，随实战增加到20",
	"Ｎ",
	"Ｌ龙胆",
	"Ｗ涯角枪特效100%触发",
	"Ｗ单枪匹马效果额外提升10%",
	"Ｒ七进七出",
	"Ｗ前七次行动后回气700",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ随实战和天书提升战斗中领悟三个能力",
	}
	
	TFJS["673-1"] = {"Ｌ拳之极者",
	"Ｗ初始拥有400感悟点",
	"Ｗ用拳掌攻击强制杀气，并附带额外伤害",
	"Ｗ无条件修炼拳掌秘籍，外功只能修炼拳法",
	"Ｗ拳掌系数无上限",
	"Ｗ生命硬上限减少30%",
	"Ｗ防御的减伤效果提升至80%",
	"Ｗ集气速度增加10",
	"Ｗ暴击率提升20%",
	"Ｎ",
	"Ｒ修罗道",
	"Ｗ集气从500开始",
	"Ｎ",
	"Ｒ罗汉断塔刃",
	"Ｗ被攻击几率免疫负面效果，数时序内回复受到的伤害，被攻击回复效果会消失",
	"Ｗ触发罗汉断塔刃会打断连击",
	"Ｗ触发罗汉断塔刃几率直接行动",
	"Ｎ",
	"Ｒ阿修罗闪空",
	"Ｗ被攻击几率移动闪避，闪避移动不受站位限制",
	"Ｗ闪避后几率立即行动",
	"Ｎ",
	"Ｗ拥有能量槽，大于50以上，消耗50能量并强化部分招式：",
	"Ｗ灭杀豪波动：范围改变",
	"Ｗ灭杀豪升龙：攻击距离增加，带点燃效果",
	"Ｗ*每学一个拳法，能量值上限增加10，资质越低，上限越高",
	"Ｗ怒气不清空，不加集气速度，指令状态期间不获得怒气",
	"Ｒ怒火冲天",
	"Ｗ满怒状态使用指令消耗所有怒气，获得杀意波动状态100时序：",
	"Ｗ伤害提高30%，每击中一个敌人减少状态1时序",
	"Ｗ攻击必定暴击",
	"Ｗ豪升龙拳伤害提高",
	"Ｗ攻击几率附加致残状态",
	"Ｗ集气速度大幅提升",
	"Ｗ能量值150以上，杀意85以上，可以使用绝技",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ实战150以上，战斗时领悟武功，第一格变为豪波动拳 极，拳掌+100",
	"Ｗ实战300以上，战斗时领悟武功，第二格变为豪升龙拳 极，拳掌+100",
	"Ｗ论剑击败丁典，第三格武功变为瞬狱杀 极，拳掌+100",
	}
	TFJS["673-2"] = {"Ｌ拳之极者",
	"Ｗ初始拥有400感悟点",
	"Ｗ用拳掌攻击强制杀气，并附带额外伤害",
	"Ｗ无条件修炼拳掌秘籍，外功只能修炼拳法",
	"Ｗ拳掌系数无上限",
	"Ｗ生命硬上限减少30%",
	"Ｗ防御的减伤效果提升至80%",
	"Ｗ集气速度增加10",
	"Ｗ连击率提升20%",
	"Ｎ",
	"Ｒ修罗道",
	"Ｗ集气从500开始",
	"Ｎ",
	"Ｒ罗汉断塔刃",
	"Ｗ被攻击几率免疫负面效果，数时序内回复受到的伤害，被攻击回复效果会消失",
	"Ｗ触发罗汉断塔刃会打断连击",
	"Ｗ触发罗汉断塔刃几率直接行动",
	"Ｎ",
	"Ｒ阿修罗闪空",
	"Ｗ被攻击几率移动闪避，闪避移动不受站位限制",
	"Ｗ闪避后几率立即行动",
	"Ｎ",
	"Ｗ拥有能量槽，大于50以上，消耗50能量并强化部分招式",
	"Ｗ狱炎豪波动：范围扩大，带点燃效果",
	"Ｗ天魔豪斩空：范围改变",
	"Ｗ*每学一个拳法，能量值上限增加10，资质越低，上限越高",
	"Ｗ怒气不清空，不加集气速度，指令状态期间不获得怒气",
	"Ｒ炽烈爆发",
	"Ｗ满怒状态使用指令消耗所有怒气，获得杀意波动状态100时序：",
	"Ｗ可连续行动两次，第二次行动可以攻击和移动，每次减少状态20时序",
	"Ｗ攻击必定暴击",
	"Ｗ豪波动拳必连，几率三连",
	"Ｗ移动范围+5",
	"Ｗ集气速度提升",
	"Ｗ能量值150以上，可以使用绝技",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ实战150以上，战斗时领悟武功，第一格变为豪波动拳 极，拳掌+100",
	"Ｗ实战300以上，战斗时领悟武功，第二格变为豪升龙拳 极，拳掌+100",
	"Ｗ论剑击败丁典，第三格武功变为赤鸦空裂破 极，拳掌+100",
	}
	TFJS["673-3"] = {"Ｌ拳之极者",
	"Ｗ初始拥有400感悟点",
	"Ｗ用拳掌攻击强制杀气，并附带额外伤害",
	"Ｗ无条件修炼拳掌秘籍，外功只能修炼拳法",
	"Ｗ拳掌系数无上限",
	"Ｗ生命硬上限减少30%",
	"Ｗ防御的减伤效果提升至80%",
	"Ｗ集气速度增加10",
	"Ｗ暴击率提升20%",
	"Ｎ",
	"Ｒ修罗道",
	"Ｗ集气从500开始",
	"Ｎ",
	"Ｒ气合天人",
	"Ｗ被攻击几率免疫伤害并且反弹攻击者",
	"Ｗ被攻击触发气合几率使集气提前",
	"Ｗ攻击时几率发动",
	"Ｗ触发气合后，下次攻击范围增加并且杀气提高",
	"Ｎ",
	"Ｒ阿修罗闪空",
	"Ｗ被攻击几率移动闪避，闪避移动不受站位限制",
	"Ｗ闪避后几率立即行动",
	"Ｎ",
	"Ｗ拥有能量槽，大于50以上，消耗50能量并强化部分招式：",
	"Ｗ灭杀豪波动：范围改变",
	"Ｗ灭杀豪升龙：攻击距离增加，带点燃效果",
	"Ｗ*每学一个拳法，能量值上限增加10，资质越低，上限越高",
	"Ｗ怒气不清空，不加集气速度，指令状态期间不获得怒气",
	"Ｒ怒火冲天",
	"Ｗ满怒状态使用指令消耗所有怒气，获得杀意波动状态100时序：",
	"Ｗ伤害提高30%，每击中一个敌人减少状态1时序",
	"Ｗ攻击必定暴击",
	"Ｗ豪升龙拳伤害提高",
	"Ｗ攻击几率附加致残状态",
	"Ｗ集气速度大幅提升",
	"Ｗ能量值150以上，杀意85以上，可以使用绝技",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ实战150以上，战斗时领悟武功，第一格变为豪波动拳 极，拳掌+100",
	"Ｗ实战300以上，战斗时领悟武功，第二格变为豪升龙拳 极，拳掌+100",
	"Ｗ论剑击败丁典，第三格武功变为瞬狱杀 极，拳掌+100",
	}
	TFJS["673-4"] = {"Ｌ拳之极者",
	"Ｗ初始拥有400感悟点",
	"Ｗ用拳掌攻击强制杀气，并附带额外伤害",
	"Ｗ无条件修炼拳掌秘籍，外功只能修炼拳法",
	"Ｗ拳掌系数无上限",
	"Ｗ生命硬上限减少30%",
	"Ｗ防御的减伤效果提升至80%",
	"Ｗ集气速度增加10",
	"Ｗ连击率提升20%",
	"Ｎ",
	"Ｒ修罗道",
	"Ｗ集气从500开始",
	"Ｎ",
	"Ｒ气合天人",
	"Ｗ被攻击几率免疫伤害并且反弹攻击者",
	"Ｗ被攻击触发气合几率使集气提前",
	"Ｗ攻击时几率发动",
	"Ｗ触发气合后，下次攻击范围增加并且杀气提高",
	"Ｎ",
	"Ｒ阿修罗闪空",
	"Ｗ被攻击几率移动闪避，闪避移动不受站位限制",
	"Ｗ闪避后几率立即行动",
	"Ｎ",
	"Ｗ拥有能量槽，大于50以上，消耗50能量并强化部分招式",
	"Ｗ狱炎豪波动：范围扩大，带点燃效果",
	"Ｗ天魔豪斩空：范围改变",
	"Ｗ*每学一个拳法，能量值上限增加10，资质越低，上限越高",
	"Ｗ怒气不清空，不加集气速度，指令状态期间不获得怒气",
	"Ｒ炽烈爆发",
	"Ｗ满怒状态使用指令消耗所有怒气，获得杀意波动状态100时序：",
	"Ｗ可连续行动两次，第二次行动可以攻击和移动，每次减少状态20时序",
	"Ｗ攻击必定暴击",
	"Ｗ豪波动拳必连，几率三连",
	"Ｗ移动范围+5",
	"Ｗ集气速度提升",
	"Ｗ能量值150以上，可以使用绝技",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ实战150以上，战斗时领悟武功，第一格变为豪波动拳 极，拳掌+100",
	"Ｗ实战300以上，战斗时领悟武功，第二格变为豪升龙拳 极，拳掌+100",
	"Ｗ论剑击败丁典，第三格武功变为赤鸦空裂破 极，拳掌+100",
	}
	TFJS[675] = {"Ｌ天煞孤星",
	"Ｗ也有选择群通的权利",
	"Ｎ",
	"Ｌ中华英雄",
	"Ｗ集气速度随生命值降低提高，最多50%",
	"Ｎ",
	"Ｒ四季剑法",
	"Ｗ用剑法攻击会提高白家剑法威力，并领悟四季剑法五式：",
	"Ｗ春雾迷蒙：威力+50时，攻击后可移动",
	"Ｗ夏雨点点：威力+110时，全体敌方强制杀气200，范围扩大",
	"Ｗ秋风卷叶：威力+220时，攻击后回气800",
	"Ｗ冬寒刺骨：威力+360时，伤害增加50%，必造成冰封",
	"Ｗ四季不休：威力+600时，四季效果",
	"Ｗ御剑至少210，几率触发四季中两个效果",
	"Ｗ御剑至少420，几率触发四季中三个效果",
	"Ｗ每学有一个剑法，伤害提升5%，上限6个",
	"Ｎ",
	"Ｒ无量神掌",
	"Ｗ随实战增加，战斗中会领悟无量神掌后六式",
	"Ｗ每领悟一式，受到的伤害减少3%，拳掌+20，内力硬上限+300",
	"Ｗ每领悟一式，剑法和拳掌气攻+200，无量神掌威力+170",
	"Ｗ每学有一个拳法，受到的伤害减少5%，上限6个",
	"Ｗ全部领悟后，拳掌上限+180，剑法和拳掌攻击50%几率无视绝对气防",
	"Ｎ",
	"Ｒ中华傲诀",
	"Ｗ中华傲诀被动：伤害+御剑能力x30%，御剑能力上限+100",
	"Ｗ主运中华傲诀：",
	"Ｗ时序耗内+32",
	"Ｗ免疫杀气，受到的伤害减少20%",
	"Ｗ集气速度加倍",
	"Ｗ武功攻击移动范围+3，剑法范围+2",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ华山后山战胜剑仙剑魔，第三格洗为【中华傲诀】极，御剑+50",
	"Ｗ实战50以上，第二格洗为【无量神掌】极",
	"Ｗ星河海限定剧情可取回【赤剑】",
	}
	
	TFJS[676] = {"Ｌ翻云破浪",
	"Ｗ攻击必连击，几率三连，暴怒必出",
	"Ｎ",
	"Ｌ奈非天",
	"Ｗ身份高贵",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ实战10，战斗中选择领悟第一个天赋：",	
	"Ｒ先知先觉：受到的伤害降低20%",
	"Ｒ濒死觉悟：第一次被击退会恢复35%血内，且15时序无敌",
	"Ｎ",
	"Ｗ实战80，战斗中选择领悟第二个天赋：",
	"Ｒ奇筋异骨：内力硬上限提高3000，时序回内+3",
	"Ｒ以攻为守：装备武器但未装备防具时，30%几率闪避",
	"Ｎ",
	"Ｗ实战220，战斗中选择领悟第三个天赋：",
	"Ｒ健步如飞：集气速度+10，每有一本天书，额外+1",
	"Ｒ斗志坚决：伤害提高15%，战场上每有一个敌人，伤害提高2%",
	"Ｎ",
	"Ｗ实战400，战斗中选择领悟第四个天赋：",
	"Ｒ天人合一：所有武功威力增加50%",
	"Ｒ脱凡入化：攻击回复消耗内力值20%的生命",
	"Ｎ",
	"Ｗ1书领悟断筋诀，拳掌攻击第三击会使敌人集气暂停7时序",
	"Ｎ",
	"Ｗ3书领悟回天息，休息额外恢复10%已损失生命",
	"Ｎ",
	"Ｗ7书领悟爆裂掌，拳掌攻击连击几率触发，中招敌人生命时序-1",
	"Ｗ*中了爆裂掌的敌人被击杀会9*9格爆炸",
	"Ｗ*爆炸会引起爆炸",
	"Ｎ",
	"Ｗ9书领悟七相拳，拳掌攻击几率触发，伤害提高25%，直接引爆爆裂掌",
	}
	
	TFJS[678] = {"Ｌ灵犀一指",
	"Ｗ指系数上限+50",
	"Ｗ指法攻击高几率造成封穴",
	"Ｗ攻击发动灵犀一指，气攻增加，无视绝对气防",
	"Ｗ被攻击发动灵犀一指，气攻变为0，受到的伤害减少",
	"Ｗ随实战增加，灵犀一指的效果逐渐增加",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ随实战和天书提高，战斗中会领悟天赋",
    "Ｗ实战300，战斗中领悟轻功【凤舞九天】，洗第二格",	
	"Ｗ领悟灵犀一指时，指法上限+100",
	}
	
	TFJS[677] = {"Ｌ故地重游",
	"Ｗ修炼秘籍获得的属性点+1",
	"Ｗ特效有二次判定",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ每领悟一个六如，五系兵器值+20，领悟一个天赋",
    "Ｗ领悟所有六如，战斗中第三格武功洗为【真野球拳】七",
    "Ｗ资质越高，真野球拳伤害越高",		
	}
	
	TFJS["677-1"] = {"Ｌ故地重游",
	"Ｗ修炼秘籍获得的属性点+1",
	"Ｗ特效有二次判定",
	"Ｎ",
	"Ｌ武林传奇",
	"Ｗ一代传奇小虾米",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ每领悟一个六如，同时五系兵器值+20，领悟一个天赋",
    "Ｗ领悟所有六如，战斗中第三格武功洗为【真野球拳】七",	
	"Ｗ资质越高，真野球拳伤害越高",
	}
	
	--周芷若
	TFJS[631] = {"Ｌ秀若芝兰",
	"Ｗ面板上每个外功增加1点集气，每个内功增加4%减伤",
	"Ｎ",
	"Ｌ谁与争锋",
	"Ｗ装备『倚天剑』时，全部剑法威力+500",
	"Ｗ使用九阴白骨爪，攻击时无视敌方毒抗",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ倚天邪线少林剧情，可选择洗第一格武功",
	"Ｗ倚天邪线少林剧情，洗第二格武功，天赋内功洗为九阴神功",
	"Ｗ倚天邪线少林剧情，天赋轻功洗为螺旋九影",
	"Ｗ倚天邪线战三渡时，可领悟左右互搏术（发动概率70%）"
	}
	--袁士霄
	TFJS[635] = {"Ｌ天池怪侠",
	"Ｗ升级时兵器值大幅提高",
	"Ｗ百花错拳威力翻倍，必定击中破绽"
	}
	--鹤笔翁
	TFJS[647] = {"Ｌ玄冥二老",
	"Ｗ使用玄冥神掌，必定发动极意"
	}
	--鹿杖客
	TFJS[648] = {"Ｌ玄冥二老",
	"Ｗ使用玄冥神掌，必定发动极意"
	}
	--宁中则
	TFJS[649] = {"Ｌ娇美人妻",
	"Ｚ如狼又似虎",
	"Ｗ被攻击时，消耗攻击方5-10点体力",
	"Ｚ坐地能吸土",
	"Ｗ每修炼一门剑法，增加5%防御",
	"Ｚ鲸吞镇海杵",
	"Ｗ被攻击时，15%概率吸收伤害转化为回血",
	}
	--萧半河	
	TFJS[189] = {"Ｌ仁者无敌", 
	"Ｗ初始道德值100，无法在天宁寺偷钱",
	"Ｗ风林/六如特效发动几率大幅度提高，可同时触发两种效果",
	}
	--渡厄	
	TFJS[597] = {"Ｌ物我两忘", 
	"Ｗ自带真.金刚伏魔圈护体，提升30%防御且气防+1000",
	"Ｗ自带金刚伏魔圈专精效果",
	}
	--杨康
	TFJS[650] = {"Ｌ小王爷",
	"Ｗ使用杨家枪法时，自带爆炸的动画特效",
	"Ｇ福缘际遇",
	"Ｗ拜师重阳宫，可觉醒杨家枪，根据使用次数提升威力和杀气",
	"Ｗ射雕邪线梅超风复仇剧情，杀死江南七怪，洗第一格武功，天赋外功洗为九阴白骨爪",
	"Ｗ射雕邪线梅超风复仇剧情，杀死江南七怪，洗第二格武功，天赋内功洗为九阴神功"
	}
	TFJS[6000] = {"Ｚ至尊江湖V6会员",
	"Ｌ一款绝对值得一玩的武侠单机游戏",
	"Ｌ有没有遇到过哪一款单机游戏让你玩十几二十几周目都不腻的？",
	"Ｌ至尊江湖的玩家中有很多可是玩了几百周目还兴致勃勃的",
	"Ｌ这个游戏没有华丽的游戏界面，玩的是合理的规划、队友的合作、战斗的技巧",
	"Ｒ『至尊爱心支持者』特别回馈",
	"Ｇ蓄力必成功,暴击连击概率额外+20%,特效几率+20,加力护体概率三倍,吃药双倍",
	}
	--拳王
	TFJS[281] = {"Ｌ盖世神拳",
	"Ｗ拳掌上限400，修炼拳掌秘籍系数额外+1",
	"Ｗ每修炼一个拳法到极，伤害提升5%、受伤害降低5%（上限7个）",
	"Ｎ",
	"Ｄ降龙极意",
	"Ｗ使用降龙十八掌，40%几率发动极意",
	"Ｎ",
	"Ｄ黯然极意",
	"Ｗ血量低于70%或内伤大于30时，使用黯然销魂掌有几率触发极意",
	"Ｗ血量越低，内伤越高，几率越高，满足条件时暴怒必定触发",
	"Ｗ触发黯然极意必定连击",
	"Ｎ",
	"Ｚ绝技：天道惊雷撼",
	"Ｗ华山后山觉醒后领悟",
	"Ｗ至少修炼9个武功，拳掌系数>=120，使用拳掌武功攻击几率触发",
	"Ｗ资质越高，触发几率越高",
	"Ｗ攻击无误伤，无视绝对气防，大幅提高封穴几率，追加1200气攻",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ可以花一万银两在云岭洞学习\"迷踪步\""
	}
	TFJS[282] = {"Ｌ灵犀一指",
	"Ｗ指法上限400，修炼指法秘籍系数额外+1",
	"Ｗ初始自带30%独立封穴几率",
	"Ｗ每修炼一个指法武功到极，连击、封穴几率提高5%（上限7个）",
	"Ｗ使用六脉神剑的内力消耗减半",
	"Ｎ",
	"Ｚ绝技：点墨山河",
	"Ｗ华山后山觉醒后领悟",
	"Ｗ至少修炼9个武功，指法系数>=120，使用指法武功攻击几率触发",
	"Ｗ资质越高，触发几率越高",
	"Ｗ攻击无误伤，不造成怒气，同时清除敌方一半怒气，追加1100气攻",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ可以花一万银两在云岭洞学习\"迷踪步\""
	}
	TFJS[283] = {"Ｌ剑神一笑", 
	"Ｗ御剑上限400，修炼剑法秘籍系数额外+1",
	"Ｗ每修炼一个剑法到极，集气速度+2（上限7个）",
	"Ｗ可无视自宫需求修炼葵花宝典、辟邪剑法",
	"Ｎ",
	"Ｚ绝技：一剑镇神州",
	"Ｗ华山后山觉醒后领悟",
	"Ｗ至少修炼9个武功，御剑系数>=120，使用剑系武功攻击几率触发",
	"Ｗ资质越高，触发几率越高",
	"Ｗ攻击无误伤，锁定攻击战场上所有敌方目标，追加1500气攻",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ可以花一万银两在云岭洞学习\"迷踪步\""
	}
	TFJS[284] = {"Ｌ傲世狂刀", 
	"Ｗ耍刀上限400，修炼刀法秘籍系数额外+1",
	"Ｗ每修炼一个刀法到极，受伤害、杀气降低5%（上限7个）",
	"Ｗ使用胡家刀法有40%几率触发极意，暴怒必触发",
	"Ｗ使用火焰刀法和沧溟刀法时，特效触发几率追加二次判定",
	"Ｎ",
	"Ｚ绝技：羽葬煌炎斩",
	"Ｗ华山后山觉醒后领悟",
	"Ｗ至少修炼9个武功，耍刀系数>=120，使用刀系武功攻击几率触发",
	"Ｗ资质越高，触发几率越高",
	"Ｗ攻击无误伤，伤害提高30%，无视绝对气防，追加1500气攻，行动后自身怒气",
	"Ｗ恢复25点（可叠加）",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ可以花一万银两在云岭洞学习\"迷踪步\""
	}
	TFJS[285] = {"Ｌ奇门无双", 
	"Ｗ特殊上限400，修炼奇门秘籍系数额外+1",
	"Ｗ初始自带15%闪避",
	"Ｗ每修炼一个奇门武功到极，闪避率提高5%（上限7个）",
	"Ｗ打狗棒法『天下无狗』的触发几率提高，追加二次判定",
	"Ｎ",
	"Ｚ绝技：千机龙绝闪",
	"Ｗ华山后山觉醒后领悟",
	"Ｗ至少修炼9个武功，奇门系数>=120，使用奇门武功攻击几率触发",
	"Ｗ资质越高，触发几率越高",
	"Ｗ攻击无误伤，必定造成流血及封穴，追加1000气攻",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ可以花一万银两在云岭洞学习\"迷踪步\""
	}
	TFJS[286] = {"Ｌ绝世天罡", 
	"Ｗ修炼内功，五系兵器值额外+1",
	"Ｗ初始内力属性为调和",
	"Ｗ内功可攻击，可修炼至极",
	"Ｗ斗转反击时，无视兵器值需求必定发动离合参商",
	"Ｎ",
	"Ｄ天罡真气",
	"Ｗ攻击时50%几率触发天罡真气，提升气攻",
	"Ｎ",
	"Ｚ天赋内功",
	"Ｗ游戏开始时可以选择九阴/九阳之一为天赋内功",
	"Ｗ学会天赋内功后，进入战斗会自动运行，无消耗",
	"Ｗ天赋内功不影响正常运功，即可同时运行两种内功",
	"Ｗ手动选择运功时，无法选择九阴/九阳",
	"Ｎ",
	"Ｚ绝技：斗焰霸罡劲",
	"Ｗ华山后山觉醒后领悟",
	"Ｗ至少修炼9个武功，攻击几率触发",
	"Ｗ资质越高，触发几率越高",
	"Ｗ用内功攻击触发时，兵器值判定至少比敌方高40",
	"Ｗ攻击无误伤，无视绝对气防，追加1300气攻",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ可以花一万银两在云岭洞学习\"迷踪步\""
	}
	TFJS[287] = {"Ｌ仁者无敌", 
	"Ｗ初始道德值100，无法在天宁寺偷钱",
	"Ｗ风林/六如特效发动几率大幅度提高，可同时触发两种效果",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ可以花一万银两在云岭洞学习\"迷踪步\""
	}
	TFJS[288] = {"Ｌ回天圣手", 
	"Ｗ初始医疗200，解毒200，用毒200；医疗上限400，用毒上限400，解毒上限400",
	"Ｗ医疗范围提升至7×7方阵",
	"Ｗ每时序随机恢复自身生命、内力、中毒、内伤",
	"Ｎ",
	"Ｚ绝技：八门聚万象",
	"Ｗ华山后山觉醒后领悟",
	"Ｗ至少修炼9个武功，体力大于50点，行动结束后几率触发",
	"Ｗ资质越高，触发几率越高",
	"Ｗ发动之后立即获得再次行动机会，需消耗10点体力",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ可以花一万银两在云岭洞学习\"迷踪步\""
	}
	TFJS[289] = {"Ｌ欲天摩罗",
	"Ｗ初始解毒300，用毒300；用毒上限500，解毒上限500",
	"Ｗ上毒范围提升至7×7方阵，可以给自己上毒",
	"Ｗ每时序随机增加自身中毒程度",
	"Ｗ自身中毒越深，能力反而越强",
	"Ｎ",
	"Ｚ绝技：天人五衰",
	"Ｗ华山后山觉醒后领悟",
	"Ｗ至少修炼9个武功，自身中毒100点，攻击时几率触发",
	"Ｗ资质越高，触发几率越高",
	"Ｗ攻击无误伤，伤害提高30%，本次攻击必定附加五种异常状态",
	"Ｎ",
	"Ｇ福缘际遇",
	"Ｗ可以花一万银两在云岭洞学习\"迷踪步\""
	}
	--张家辉
	TFJS[291] = {"Ｒ人物介绍",
	"Ｗ大扎好，我系渣渣辉，探挽懒月，介四里没有挽过的船新版本，挤需体验三番钟，",
	"Ｗ里造会干我一样，爱象节款游戏。",
	"Ｎ",
	"Ｌ人物特性",
	"Ｗ自带四件传奇饰品，拥有极强大的特效"
	}
	
	--主角专属介绍
	ZJZSJS = {"Ｌ六如苍龙决",
	"Ｄ获得方式：从第一本开始，之后每拿到两本天书，场景【华山后山】对话谢无悠",
	"Ｗ战斗中可以触发风/林/火/山四种强力特效",
	"Ｗ其疾如风：攻击时几率触发，我方全体集气位置+100，自身行动后集气恢复500",
	"Ｗ其徐如林：被攻击几率触发，集气速度提高2～3点，上限20点",
	"Ｗ侵略如火：攻击时几率触发，追加3000点气攻，提高20%伤害",
	"Ｗ不动如山：被攻击几率触发，受到伤害强制降低为30点，并免疫杀气",
	"Ｗ难知如阴：被攻击几率触发，中断对方的连击，并获得一次移动机会",
	"Ｗ动如雷震：攻击时几率触发，追加一次连击，单次攻击最多触发3次",
	}
	
	--物品特效说明
	WPTX = {}
	--玄铁剑
	WPTX[36] = {"使用玄铁剑法时，增加50%暴击率",
	"使用玄铁剑法时，增加60%暴击率",
	"使用玄铁剑法时，增加70%暴击率",
	"使用玄铁剑法时，增加80%暴击率",
	"使用玄铁剑法时，增加90%暴击率",
	"使用玄铁剑法时，必定暴击，并可发动“破尽天下”"
	}
	--涯角枪
	WPTX[344] = {"使用枪法时，17%几率扩大范围，气攻提高",
	"使用枪法时，22%几率扩大范围，气攻提高",
	"使用枪法时，27%几率扩大范围，气攻提高",
	"使用枪法时，32%几率扩大范围，气攻提高",
	"使用枪法时，37%几率扩大范围，气攻提高",
	"使用枪法时，42%几率扩大范围，气攻提高，追加连击",
	}
	--英雄剑
	WPTX[353] = {"攻防均以剑系数计算伤害",
	"攻防均以剑系数计算伤害",
	"攻防均以剑系数计算伤害",
	"攻防均以剑系数计算伤害",
	"攻防均以剑系数计算伤害",
	"攻防均以剑系数计算伤害",
	}
	--翔龙
	WPTX[354] = {"攻击时，10%概率使自身集气速度加倍5时序",
	"攻击时，11%概率使自身集气速度加倍6时序",
	"攻击时，12%概率使自身集气速度加倍7时序",
	"攻击时，13%概率使自身集气速度加倍8时序",
	"攻击时，14%概率使自身集气速度加倍9时序",
	"攻击时，15%概率使自身集气速度加倍10时序",
	}
	--雪饮刀
	WPTX[360] = {"攻击时，15%概率造成冰封，追加等于冰封值的伤害（+阴内等级x10）",
	"攻击时，30%概率造成冰封，追加等于冰封值的伤害（+阴内等级x10）",
	"攻击时，35%概率造成冰封，追加等于冰封值的伤害（+阴内等级x10）",
	"攻击时，40%概率造成冰封，追加等于冰封值的伤害（+阴内等级x10）",
	"攻击时，45%概率造成冰封，追加等于冰封值的伤害（+阴内等级x10）",
	"攻击时，50%概率造成冰封，追加等于冰封值的伤害（+阴内等级x10）",
	}
	WPTX[362] = {"剑法攻击时，吸取敌方内力",
	"剑法攻击时，吸取敌方内力",
	"剑法攻击时，吸取敌方内力",
	"剑法攻击时，吸取敌方内力",
	"剑法攻击时，吸取敌方内力，无视25%防御",
	}
	--全能
	WPTX[355] = {"拳·指·剑·刀·奇，依次伤害提高50%，20时序",
	"拳·指·剑·刀·奇，依次伤害提高60%，20时序",
	"拳·指·剑·刀·奇，依次伤害提高70%，20时序",
	"拳·指·剑·刀·奇，依次伤害提高80%，20时序",
	"拳·指·剑·刀·奇，依次伤害提高90%，20时序",
	"拳·指·剑·刀·奇，依次伤害提高100%，20时序",
	}
	--两极
	WPTX[356] = {"30%几率触发：受到的伤害减少20%或反弹20%的伤害",
	"33%几率触发：受到的伤害减少24%或反弹24%的伤害",
	"36%几率触发：受到的伤害减少28%或反弹28%的伤害",
	"39%几率触发：受到的伤害减少32%或反弹32%的伤害",
	"42%几率触发：受到的伤害减少36%或反弹36%的伤害",
	"45%几率触发：受到的伤害减少40%或反弹40%的伤害",
	}
	--汗血
	WPTX[262] = {nil, nil, nil, nil,
	"攻击体力消耗减少2点",
	"攻击体力消耗减少2点",
	}
	--闪电貂
	WPTX[350] = {"攻击上毒8点，25%几率偷取物品",
	"攻击上毒12点，28%几率偷取物品",
	"攻击上毒16点，31%几率偷取物品",
	"攻击上毒20点，34%几率偷取物品",
	"攻击上毒24点，37%几率偷取物品",
	"攻击上毒28点，40%几率偷取物品",
	}
	--冰蚕
	WPTX[351] = {"攻击6%几率冻结敌方，50%造成冰封，攻击上毒12点",
	"攻击8%几率冻结敌方，60%造成冰封，攻击上毒12点",
	"攻击10%几率冻结敌方，70%造成冰封，攻击上毒12点",
	"攻击12%几率冻结敌方，80%造成冰封，攻击上毒12点",
	"攻击14%几率冻结敌方，90%造成冰封，攻击上毒12点",
	"攻击16%几率冻结敌方，100%造成冰封，攻击上毒12点",
	}
	--混沌虺
	WPTX[345] = {"内力为阴，使用拳掌攻击几率附加“寒”，内力为阳则几率附加“烈”",
	"内力为阴，使用拳掌攻击几率附加“寒”，内力为阳则几率附加“烈”",
	"内力为阴，使用拳掌攻击几率附加“寒”，内力为阳则几率附加“烈”",
	"内力为阴，使用拳掌攻击几率附加“寒”，内力为阳则几率附加“烈”",
	"内力为阴，使用拳掌攻击几率附加“寒”，内力为阳则几率附加“烈”",
	"内力为阴，使用拳掌攻击几率附加“寒”，内力为阳则几率附加“烈”",
	}
	--倚天剑
	WPTX[37] = {"攻击时70%几率造成流血效果",
	"攻击时80%几率造成流血效果",
	"攻击时90%几率造成流血效果",
	"攻击时必定造成流血效果，并追加5点灼烧",
	"攻击时必定造成流血效果，并追加10点灼烧",
	"攻击时必定造成流血效果，并追加15点灼烧"
	}
	--流星剑
	WPTX[38] = {"攻击时50%几率追加10点冰封效果",
	"攻击时60%几率追加10点冰封效果",
	"攻击时70%几率追加10点冰封效果",
	"攻击时80%几率追加10点冰封效果",
	"攻击时90%几率追加10点冰封效果",
	"攻击时必定追加10点冰封效果"
	}
	--屠龙刀
	WPTX[43] = {"使用刀法攻击时，有几率触发两种特效",
	"使用刀法攻击时，有几率触发两种特效",
	"使用刀法攻击时，有几率触发两种特效",
	"使用刀法攻击时，有几率触发两种特效",
	"使用刀法攻击时，有几率触发两种特效",
	"使用刀法攻击时，有几率触发两种特效"
	}
	--血刀
	WPTX[44] = {"攻击后根据伤害恢复生命值，上限100点",
	"攻击后根据伤害恢复生命值，上限100点",
	"攻击后根据伤害恢复生命值，上限100点",
	"攻击后根据伤害恢复生命值，上限100点",
	"攻击后根据伤害恢复生命值，上限100点",
	"攻击后根据伤害恢复生命值，上限100点"
	}
	--软猬甲
	WPTX[58] = {"减伤20点，被拳指系武功攻击时，使攻击方流血10点",
	"减伤22点，被拳指系武功攻击时，使攻击方流血10点",
	"减伤24点，被拳指系武功攻击时，使攻击方流血10点",
	"减伤26点，被拳指系武功攻击时，使攻击方流血10点",
	"减伤28点，被拳指系武功攻击时，使攻击方流血10点",
	"减伤30点，被拳指系武功攻击时，使攻击方流血10点"
	}
	--乌蚕衣
	WPTX[59] = {"被攻击时，受到的内伤减少5点",
	"被攻击时，受到的内伤减少6点",
	"被攻击时，受到的内伤减少7点",
	"被攻击时，受到的内伤减少8点",
	"被攻击时，受到的内伤减少9点",
	"被攻击时，受到的内伤减少10点"
	}
	--金丝背心
	WPTX[60] = {"被攻击时，受到的封穴减少5点",
	"被攻击时，受到的封穴减少6点",
	"被攻击时，受到的封穴减少7点",
	"被攻击时，受到的封穴减少8点",
	"被攻击时，受到的封穴减少9点",
	"被攻击时，受到的封穴减少10点"
	}
	--鳄皮护甲
	WPTX[61] = {"每次行动结束后解毒25点",
	"每次行动结束后解毒35点",
	"每次行动结束后解毒45点",
	"每次行动结束后解毒55点",
	"每次行动结束后解毒65点",
	"每次行动结束后解毒75点"
	}
	--佛心甲
	WPTX[62] = {"被攻击时，受到的灼烧减少50%",
	"被攻击时，受到的灼烧减少60%",
	"被攻击时，受到的灼烧减少70%",
	"被攻击时，受到的灼烧减少80%",
	"被攻击时，受到的灼烧减少90%",
	"被攻击时，免疫灼烧状态"
	}
	--皮衣
	WPTX[63] = {"被攻击时，受到的冰封减少50%",
	"被攻击时，受到的冰封减少60%",
	"被攻击时，受到的冰封减少70%",
	"被攻击时，受到的冰封减少80%",
	"被攻击时，受到的冰封减少90%",
	"被攻击时，免疫冰封状态"
	}
	--白马
	WPTX[230] = {"集气速度增加2点",
	"集气速度增加2点",
	"集气速度增加3点",
	"集气速度增加3点",
	"集气速度增加4点",
	"集气速度增加4点"
	}
	--真武剑
	WPTX[236] = {"使用太极剑法时，必定连击",
	"使用太极剑法时，必定连击",
	"使用太极剑法时，必定连击",
	"使用太极剑法时，必定连击",
	"使用太极剑法时，必定连击",
	"使用太极剑法时，必定连击"
	}
	--鸳鸯刀
	WPTX[217] = {"使用夫妻刀法时，必定连击",
	"使用夫妻刀法时，必定连击",
	"使用夫妻刀法时，必定连击",
	"使用夫妻刀法时，必定连击",
	"使用夫妻刀法时，必定连击，追加500气攻",
	"使用夫妻刀法时，必定连击，追加500气攻，伤害提高20%"
	}
	WPTX[218] = {"使用夫妻刀法时，必定连击",
	"使用夫妻刀法时，必定连击",
	"使用夫妻刀法时，必定连击",
	"使用夫妻刀法时，必定连击",
	"使用夫妻刀法时，必定连击，追加500气攻",
	"使用夫妻刀法时，必定连击，追加500气攻，伤害提高20%"
	}
	--毛驴
	WPTX[279] = {"集气速度增加10点",
	"集气速度增加10点",
	"集气速度增加10点",
	"集气速度增加10点",
	"集气速度增加10点",
	"集气速度增加10点"
	}
	--西毒蛇杖
	WPTX[244] = {"攻击时无视敌方毒抗强制上毒10点",
	"攻击时无视敌方毒抗强制上毒15点",
	"攻击时无视敌方毒抗强制上毒20点",
	"攻击时无视敌方毒抗强制上毒25点",
	"攻击时无视敌方毒抗强制上毒30点",
	"攻击时无视敌方毒抗强制上毒35点"
	}
	--瘦黄马
	WPTX[284] = {	"血量越低，集气速度越快",
	"血量越低，集气速度越快",
	"血量越低，集气速度越快",
	"血量越低，集气速度越快",
	"血量越低，集气速度越快",
	"血量越低，集气速度越快"
	}
	--喵大山
	WPTX[321] = {"免疫前三次攻击",
	"免疫前三次攻击",
	"免疫前三次攻击",
	"免疫前三次攻击",
	"免疫前三次攻击",
	"免疫前三次攻击"
	}
	--喵大山
	WPTX[322] = {"免疫前三次攻击",
	"免疫前三次攻击",
	"免疫前三次攻击",
	"免疫前三次攻击",
	"免疫前三次攻击",
	"免疫前三次攻击"
	}
	
	--七宝指环
	WPTX[200] = {"攻击后下回合集气位置+100",
	"攻击后下回合集气位置+100",
	"攻击后下回合集气位置+100",
	"攻击后下回合集气位置+100",
	"攻击后下回合集气位置+100",
	"攻击后下回合集气位置+100"
	}
	
	--金丝手套
	WPTX[239] = {"提高自身拳/指系数10点",
	"提高自身拳/指系数15点",
	"提高自身拳/指系数20点",
	"提高自身拳/指系数25点",
	"提高自身拳/指系数30点",
	"提高自身拳/指系数30点，免疫流血"
	}
	
	--音箱
	WPTX[300] = {"降龙三叠浪几率提高5%，暴怒时有几率触发四叠浪",
	"降龙三叠浪几率提高10%，暴怒时有几率触发四叠浪",
	"降龙三叠浪几率提高15%，暴怒时有几率触发四叠浪",
	"降龙三叠浪几率提高20%，暴怒时有几率触发四叠浪",
	"降龙三叠浪几率提高25%，暴怒时有几率触发四叠浪",
	"降龙三叠浪几率提高30%，暴怒时有几率触发四叠浪"
	}
	
	--麻痹戒指
	WPTX[301] = {"令击中的敌方进入麻痹状态，下回合移动能力-1",
	"令击中的敌方进入麻痹状态，下回合移动能力-1",
	"令击中的敌方进入麻痹状态，下回合移动能力-2",
	"令击中的敌方进入麻痹状态，下回合移动能力-2",
	"令击中的敌方进入麻痹状态，下回合移动能力-3",
	"令击中的敌方进入麻痹状态，下回合移动能力-3"
	}
	--护身戒指
	WPTX[302] = {"用内力抵消一半伤害，抵消比例为3内力=1伤害",
	"用内力抵消一半伤害，抵消比例为3内力=1伤害",
	"用内力抵消一半伤害，抵消比例为2内力=1伤害",
	"用内力抵消一半伤害，抵消比例为2内力=1伤害",
	"用内力抵消一半伤害，抵消比例为1内力=1伤害",
	"用内力抵消一半伤害，抵消比例为1内力=1伤害"
	}
	--复活戒指
	WPTX[303] = {"被击退时，满状态复活，复活6次之后物品损坏",
	"被击退时，满状态复活，复活6次之后物品损坏",
	"被击退时，满状态复活，复活6次之后物品损坏",
	"被击退时，满状态复活，复活6次之后物品损坏",
	"被击退时，满状态复活，复活6次之后物品损坏",
	"被击退时，满状态复活，复活6次之后物品损坏"
	}
	--隐身戒指
	WPTX[304] = {"敌方无法察觉你的存在，攻击后现形40时序",
	"敌方无法察觉你的存在，攻击后现形40时序",
	"敌方无法察觉你的存在，攻击后现形30时序",
	"敌方无法察觉你的存在，攻击后现形30时序",
	"敌方无法察觉你的存在，攻击后现形20时序",
	"敌方无法察觉你的存在，攻击后现形20时序"
	}
	--多闻无双
	WPTX[323] = {"五系兵器值提升",
	"五系兵器值提升",
	"五系兵器值提升",
	"五系兵器值提升",
	"五系兵器值提升",
	"五系兵器值提升"
	}
	
	--广目无边
	WPTX[324] = {"移动范围和集气速度增加，持续消耗生命内力",
	"移动范围和集气速度增加，持续消耗生命内力",
	"移动范围和集气速度增加，持续消耗生命内力",
	"移动范围和集气速度增加，持续消耗生命内力",
	"移动范围和集气速度增加，持续消耗生命内力",
	"移动范围和集气速度增加，持续消耗生命内力"
	}
	
	--增长无量
	WPTX[325] = {"造成的伤害提高，持续消耗生命",
	"造成的伤害提高，持续消耗生命",
	"造成的伤害提高，持续消耗生命",
	"造成的伤害提高，持续消耗生命",
	"造成的伤害提高，持续消耗生命",
	"造成的伤害提高，持续消耗生命"
	}
	
	--持国无敌
	WPTX[326] = {"受到的伤害减少，持续消耗内力",
	"受到的伤害减少，持续消耗内力",
	"受到的伤害减少，持续消耗内力",
	"受到的伤害减少，持续消耗内力",
	"受到的伤害减少，持续消耗内力",
	"受到的伤害减少，持续消耗内力"
	}
	
	--天怒十方
	WPTX[327] = {"不止是四合一的强大",
	"不止是四合一的强大",
	"不止是四合一的强大",
	"不止是四合一的强大",
	"不止是四合一的强大",
	"不止是四合一的强大"
	}
	WPTX[337] = {"圣火神功威力+50",
	"圣火神功威力+100",
	"圣火神功威力+150",
	"圣火神功威力+200",
	"圣火神功威力+250",
	"圣火神功威力+300"
	}
	WPTX[338] = {"五轮大转攻击使敌方集气停止1时序",
	"五轮大转攻击使敌方集气停止2时序",
	"五轮大转攻击使敌方集气停止3时序",
	"五轮大转攻击使敌方集气停止4时序",
	"五轮大转攻击使敌方集气停止5时序",
	"五轮大转攻击使敌方集气停止6时序"
	}
	WPTX[346] = {"剑法攻击附带当前生命值4%的伤害",
	"剑法攻击附带当前生命值5%的伤害",
	"剑法攻击附带当前生命值6%的伤害",
	"剑法攻击附带当前生命值7%的伤害",
	"剑法攻击附带当前生命值8%的伤害",
	"剑法攻击附带当前生命值9%的伤害"
	}
	WPTX[347] = {"攻击13%几率使敌方得狂犬病，气攻+250",
	"攻击16%几率使敌方得狂犬病，气攻+500",
	"攻击19%几率使敌方得狂犬病，气攻+750",
	"攻击22%几率使敌方得狂犬病，气攻+1000",
	"攻击25%几率使敌方得狂犬病，气攻+1250",
	"攻击28%几率使敌方得狂犬病，气攻+1500"
	}
	WPTX[348] = {"13%概率用玄铁剑额外攻击一次",
	"16%概率用玄铁剑额外攻击一次",
	"19%概率用玄铁剑额外攻击一次",
	"22%概率用玄铁剑额外攻击一次",
	"25%概率用玄铁剑额外攻击一次",
	"28%概率用玄铁剑额外攻击一次"
	}
	WPTX[349] = {"6%几率闪避攻击，集气速度+2",
	"7%几率闪避攻击，集气速度+3",
	"8%几率闪避攻击，集气速度+4",
	"9%几率闪避攻击，集气速度+5",
	"10%几率闪避攻击，集气速度+6",
	"11%几率闪避攻击，集气速度+7"
	}
	
	
	--独孤九剑
	WPTX[114] = "在一定机缘下可领悟九剑真传"
	--六脉神剑
	WPTX[113] = "连击时，伤害、气攻不会减少"
	--夫妻刀法
	WPTX[140] = "连击时，伤害、气攻不会减少"
	--葵花神功
	WPTX[93] = "男性需自宫方可修炼，女性可直接修炼"
	--暗香月影
	WPTX[311] = "男性需自宫方可修炼，女性可直接修炼"
	--辟邪剑法
	WPTX[78] = "男性自宫方可修炼"
	
	--难度文字
	MODEXZ2 = {"入门", "少侠", "大侠","掌门","宗师","传说","至尊","星河"}
	--标主选天赋文字
	TFXZSAY1 = " 天下风云出我辈 * 一入江湖岁月催 * 皇图霸业谈笑中 * 不胜人生一场醉 "
	
	--特色指令
	GRTS = {}
	GRTSSAY = {}
	
	--段誉
	GRTS[53] = "凌波"
	GRTSSAY[53] = "效果：至该角色下次行动为止*      被攻击有50%几率闪避*消耗：体力10点"
	
	--虚竹
	GRTS[49] = "催符"
	GRTSSAY[49] = "效果：催动敌人身上的生死符*      使其封穴25时序*消耗：体力5点 内力500点"
	
	--人厨子
	GRTS[89] = "气补"
	GRTSSAY[89] = "效果：回复指定邻接队友体力50点**消耗：体力25点 内力300点"
	
	--张无忌
	GRTS[9] = "挪移"
	GRTSSAY[9] = "效果：将八格范围内任一队友*      挪移到指定位置*消耗：体力10点 内力500点"
	
	--祖千秋
	GRTS[88] = "传功"
	GRTSSAY[88] = "效果：将五格范围内我方任一队友*      当前集气提升500点*消耗：体力10点 内力700点"
  
	--霍青桐
	GRTS[74] = "兵法"
	GRTSSAY[74] = "<借刀杀人> 指定一名敌方角色令其强制攻击一次*<固若金汤> 100时序内我方全体角色受伤害降低30%  *<火烧连营> 对敌方全体角色强制追加灼烧100点*<霸王别姬> 指定一名敌方女性角色令其强制退场*<军神再临> 100时序内自身行动时可连续行动两次*"
	
	--王难姑
	GRTS[17] = "施毒"
	GRTSSAY[17] = "效果：周围五格范围内的敌人时序中毒*      持续50时序*消耗：体力15点 内力300点"
	
	--胡青牛
	GRTS[16] = "群疗"
	GRTSSAY[16] = "效果：周围五格范围内的队友时序回内伤*      并按比例回血，持续20时序*消耗：体力15点 内力300点"
	
	--萧中慧
	GRTS[77] = "慧心"
	GRTSSAY[77] = "效果：回复主角的状态，主角满怒气并满集气**消耗：使用后自己将奄奄一息"
	
	--慕容复
	GRTS[51] = "幻梦"
	GRTSSAY[51] = "效果：至该角色下次行动为止*      被攻击必定发动幻梦星辰反击*消耗：体力10点"
	
	--小昭
	GRTS[66] = "影步"
	GRTSSAY[66] = "效果：标记自身周围一点*      被攻击则移动至该处*      且追加一次攻击*消耗：体力20点 内力1000点"
	
	--钟灵
	GRTS[90] = "灵貂"
	GRTSSAY[90] = "效果：偷窃敌方携带的物品*      并对其强制上毒50点*消耗：体力5点"
	
	--李逍遥
	GRTS[655] = "探云"
	GRTSSAY[655] = "效果：偷窃敌方携带的物品*      消耗：体力5点"
	
	--大暴
	GRTS[91] = "大暴"
	GRTSSAY[91] = "效果：本次攻击必定连击*      且连击时伤害、气攻不减*消耗：内力200点 体力5点"
	
	--郭襄
	GRTS[626] = "玲珑"
	GRTSSAY[626] = "效果：可自由切换第一格武功为*      弹指神通/玉萧剑法/落英神剑掌*      不消耗回合"
	
	--豪鬼
	GRTS[673] = "杀意"
	GRTSSAY[673] = "效果：开启100时序杀意波动状态*      消耗所有怒气*      不消耗回合"
	--聂风
	GRTS[681] = "入魔"
	GRTSSAY[681] = "效果：开启50时序魔心渡状态*            不消耗回合"
	--左慈
	GRTS[685] = "指令"
	GRTSSAY[685] = "效果：开启某个炼化队友的指令"
	--托奇
	
	GRTS[686] = "秘孔"
	GRTSSAY[686] = "效果：点击自己穴位获得效果*      消耗：体力25点"
	--武僧
	GRTS[676] = "灵悟"
	GRTSSAY[676] = "效果：开启60时序减伤状态*     *消耗：体力15点 内力1000点"
	
	--金庸
	GRTS[669] = "评价"
	GRTSSAY[669] = "效果：评价一位演员的表演*      消耗10点体力*      不消耗回合"
	
	--胡斐
	GRTS[1] = "飞狐"
	GRTSSAY[1] = "效果：无视障碍物移动*      在战场上来去自如*消耗：体力10点"
	
	--鸠摩智
	GRTS[103] = "幻化"
	GRTSSAY[103] = "效果：使用小无相功模拟天下武学*      必须要拥有对应的秘籍*消耗：体力10点 内力500点"
	
	--达尔巴
	GRTS[160] = "死战"
	GRTSSAY[160] = "效果：锁定一名敌人，至其死亡之前，达尔巴*      对其的攻击效果提高50%，且必定命中*      在目标死亡之前无法更换目标*消耗：体力10点 内力500点"
	
	--金轮
	GRTS[62] = "龙象"
	GRTSSAY[62] = "效果：使用后自动执行蓄力*      并使下一次的攻击附加昏迷效果*      昏迷的敌人将丧失一次行动机会*消耗：体力10点 内力500点"
	
	--黄蓉
	GRTS[56] = "遁甲"
	GRTSSAY[56] = "效果：使用奇门遁甲*      重新布置战场地形效果*消耗：体力10点 内力500点"
	
	--阿紫
	GRTS[47] = "禁药"
	GRTSSAY[47] = "效果：使用禁药刺激神经*      自身每时序损失1%最大血量*      此状态下自身血量越低，伤害/集气越高*      不消耗回合"
	
	--韦小宝
	GRTS[601] = "口才"
	GRTSSAY[601] = "效果：使一名敌方进入沉睡状态*      此状态无法集气，不会自行解除*      受到攻击会醒来*消耗：体力50点"
	
	--苗人凤
	GRTS[3] = "破军"
	GRTSSAY[3] = "效果：攻击敌方*      并使其内功停运50时序*消耗：体力10点 内力300点"
	
	--灭绝
	GRTS[6] = "俱焚"
	GRTSSAY[6] = "效果：开启后100时序*      自身造成和受到的伤害皆提高50% *      不消耗回合"
	
	--谢逊
	GRTS[13] = "咆哮"
	GRTSSAY[13] = "效果：使全场敌人进入混乱状态20时序*      此状态下敌人行动时的敌我关系为随机*      不会全部随机到我方，以免出现直接获胜的情况*消耗：体力10点 2000内力"
	
	--何太冲
	GRTS[7] = "铁琴"
	GRTSSAY[7] = "效果：使全场敌人受到其身上琴音层数×50点伤害*      并清除其身上的琴音状态*消耗：体力10点 内力500点"
	
	--阎基
	GRTS[4] = "虚弱"
	GRTSSAY[4] = "效果：用毒药侵蚀一名敌人的神经*      使其在40时序内造成的伤害杀气减半*消耗：体力10点"
	
	--黛绮丝
	GRTS[15] = "倾国"
	GRTSSAY[15] = "效果：开启后，接下来受到的前6次攻击*      将折射给在场随机第三方人物*消耗：体力10点 内力2000点"
	
--[[	--猫姐
	GRTS[92] = "换装"
	GRTSSAY[92] = "效果：使用后改变自身外形*消耗：体力10点"--]]
	
	--方证
	GRTS[149] = "金身"
	GRTSSAY[149] = "效果：开启后，自身受到的伤害降低50% *      但被攻击时将无法获得怒气值*      在开启状态下再次使用则关闭*消耗：体力10点 内力500点"
	
	--尹志平
	GRTS[653] = "降龙"
	GRTSSAY[653] = "效果：召唤小龙女*      冻结自身20时序*消耗：体力50点"
	
	--空性
	GRTS[170] = "检测"
	GRTSSAY[170] = "效果：检测指定敌方的战斗力*      并根据情况调整自己的策略*消耗：体力5点"
	
	CC.Kungfunum = 15;	--人物武功数量
	
--队友攻击加成
CC.AddAtk = {
{10, 15, 50}, 		--金花给范遥加攻
{11, 15, 50}, 		--金花给杨逍加攻
{12, 15, 50}, 		--金花给殷天正加攻
{13, 15, 50}, 		--金花给谢逊加攻
{14, 15, 50}, 		--金花给韦一笑加攻
{48, 47, 100}, 		--阿紫给游坦之加攻
{47, 50, 100}, 		--乔峰给阿紫加攻
{53, 76, 100}, 		--王语嫣给段誉加攻
{79, 36, 60}, 		--林平之给岳灵珊加攻
{74, 75, 50}, 		--陈家洛给霍青桐加攻
{59, 58, 100}, 		--杨过给小龙女加攻
{615, 614, 100}, 
{59, 653, 100}, 	--尹志平给小龙女加攻
{54, 91, 100}, 		--温青青给袁承志加攻
{629, 54, 100}, 	--袁承志给阿九加攻
{99, 70, 100}, 		--玄慈给叶二娘加攻
{119, 65, 50}, 		--一灯给渔加攻
{120, 65, 50}, 		--一灯给樵加攻
{121, 65, 50}, 		--一灯给耕加攻
{122, 65, 50}, 		--一灯给读加攻
{68, 129, 50}, 		--王重阳给全真七子加攻
{123, 129, 50}, 
{124, 129, 50}, 
{125, 129, 50}, 
{126, 129, 50}, 
{127, 129, 50}, 
{128, 129, 50},
{37, 589, 50},		--狄云、水笙在场，攻各加50
{589, 37, 50},
{88, 89, 50},		--人厨子给祖千秋加攻
{604, 592, 100} 	--独孤求败给阿青加攻
}

--队友防御加成
CC.AddDef = {	
{76, 51, 100}, 		--慕容复给王语嫣加防
{55, 56, 50}, 		--黄蓉给郭靖加防
{612, 613, 50}, 		--小龙女给杨过加防
{56, 55, 200}, 		--郭靖给黄蓉加防
{613, 612, 100}, 		--小龙女给杨过加防
{35, 73, 100}, 		--任盈盈给令狐冲加防
{79, 36, 60}, 		--岳灵珊给林平之加防
{73, 35, 50}, 		--令狐冲给任盈盈加防
{74, 75, 50}, 		--陈家洛给霍青桐加防
{58, 59, 50}, 		--小龙女给杨过加防
{614, 615, 100}, 		
{59, 653, 100}, 	--尹志平给小龙女加防
{59, 58, 50}, 		--杨过给小龙女加防	
{66, 9, 50}, 		--张无忌给小昭加防
{91, 54, 100}, 		--袁承志给温青青加防
{119, 65, 50}, 		--一灯给渔加防
{120, 65, 50}, 		--一灯给樵加防
{121, 65, 50}, 		--一灯给耕加防
{122, 65, 50}, 		--一灯给读加防
{68, 129, 50}, 		--王重阳给全真七子加防
{123, 129, 50}, 
{124, 129, 50}, 
{125, 129, 50}, 
{126, 129, 50}, 
{127, 129, 50}, 
{128, 129, 50},
{37, 589, 50},		--狄云、水笙在场，防各加50
{589, 37, 50}
}

--队友速度加成
CC.AddSpd = {
{25, 35, 50}, 		--令狐冲给蓝凤凰加轻
{90, 53, 50}, 		--段誉给钟灵加轻
{55, 56, 100}, 		--黄蓉给郭靖加轻
{612, 613, 100}, 		--小龙女给杨过加防
{56, 55, 100}, 		--郭靖给黄蓉加轻
{613, 612, 50}, 		--小龙女给杨过加防
{35, 79, 100}, 		--小师妹给令狐加轻
{73, 35, 50}, 		--令狐给盈盈加轻
{74, 75, 50}, 		--陈家洛给霍青桐加轻
{58, 59, 100}, 		--小龙女给杨过加轻
{614, 615, 100}, 		--小龙女给杨过加防
{59, 653, 100}, 	--尹志平给小龙女加轻
{63, 58, 60}, 		--杨过给程英加轻
{83, 54, 50},		--袁承志给何铁手加轻
{54, 629, 100}, 	--阿九给袁承志加轻
{37, 589, 50},		--狄云、水笙在场，轻各加50
{589, 37, 50},
{89, 88, 50},		--祖千秋给人厨子加轻
{592, 604, 100} 	--阿青给独孤求败加轻
}

CC.AddDoc = {
{2, 1, 120}, 		--胡斐给程灵素加医疗
{16, 17, 50}}		--王难姑给胡青牛加医疗

CC.AddPoi = {
{17, 16, 50}}		--胡青牛给王难姑加用毒

--组合名称
CC.COMBO = {
	{1, 2, "海棠烛泪"},
	--{4, 72, "狼狈为奸"},
	--{37, 38, "赤诚仁心"},
	--{47, 48, "铁怪毒娇"},
	{51, 76, "姑苏表亲"},
	{53, 76, "仙洞眷侣"},
	--{90, 582, "灵婉双娇"},
	{55, 56, "铁血丹心"},
	{612, 613, "铁血丹心"},
	--{87, 86, "鹿鼎双妹"},
	{35, 73, "剑胆琴心"},
	{36, 79, "苦命鸳鸯"},
	{75, 74, "巾帼红花"},
	{58, 59, "神雕侠侣"},
	{614, 615, "神雕侠侣"},	
	{653, 59, "当然是选择原谅她"},
	{9, 66, "倚天奇情"},
	{16, 17, "蝶谷怪医"},
	{54, 91, "碧血情侠"},
	{54, 629, "情天长恨"},
	{88, 89, "酒食为天"},
	--{35, 58, "独孤传人"},
	--{83, 25, "五毒五仙"},
	--{35, 29, "酒肉冤家"},
	--{0, 92, "前尘如梦"},
	{37, 589, "雪山隐士"},
	--{38, 661, "金乌玉兔"},
	--{29, 591, "风流浪荡"},
	--{10, 11, "逍遥二仙"},
	--{162, 163, "不三不四"},
	--{60, 61, "雪山白驼"},
	--{620, 61, "雪山白驼"},
	--{51, 113, "燕国遗脉"},
	--{50, 112, "大辽战神"},
	--{3, 621, "刀剑双绝"},
	--{632, 633, "人淡如菊"},
	--{616, 635, "情义无解"},	
	--{77, 625, "女貌郎才"},		
	--{643, 644, "玄冥二老"},	
	--{663, 664, "义重情深"},	
	--{9, 638, "情深不寿"},
	--{9, 639, "张郎画眉"},
	{592, 604, "剑试天霄"}
}

	CC.CoupleDisplay = 0;
	
	--显示组合动画开关
	if CONFIG.CoupleDisplay == 1 then
		CC.CoupleDisplay = 1;
	end
	
	--萧中慧的容貌描写
	XZH_d = {
	"眉清目秀",
	"明眸皓齿",
	"楚楚动人",
	"婀娜多姿",
	"袅袅婷婷",
	"风姿绰约",
	"秀色可餐",
	"螓首蛾眉",
	"花颜月貌",
	"玉质天成",
	"仪态万方",
	"沉鱼落雁",
	"闭月羞花",
	"风华绝代",
	"倾国倾城",
	"国色天香",
	"翩若惊鸿",
	"出尘绝世",
	"仙姿佚貌"
	}
	
	--无酒不欢：人物换装设定
	Avatar = {}
	
	--标准男主角
	Avatar[0] = {{},{}}
	Avatar[0][1].name = "经典主角"
	Avatar[0][1].num = 0
	Avatar[0][1].frameNum = {10,12,11,11,15}
	Avatar[0][1].frameDelay = {7,10,9,9,10}
	Avatar[0][1].soundDelay = {0,8,5,7,0}
	
	Avatar[0][2].name = "新颖主角"
	Avatar[0][2].num = 390
	Avatar[0][2].frameNum = {10,12,11,11,15}
	Avatar[0][2].frameDelay = {7,10,9,9,10}
	Avatar[0][2].soundDelay = {0,8,5,7,0}
	
	--标准男刀主角
	Avatar[4] = {{},{}}
	Avatar[4][1].name = "经典主角"
	Avatar[4][1].num = 0
	Avatar[4][1].frameNum = {10,12,11,11,15}
	Avatar[4][1].frameDelay = {7,10,9,9,10}
	Avatar[4][1].soundDelay = {0,8,5,7,0}
	
	Avatar[4][2].name = "傲视狂刀"
	Avatar[4][2].num = 391
	Avatar[4][2].frameNum = {0,0,0,13,0}
	Avatar[4][2].frameDelay = {0,0,0,13,0}
	Avatar[4][2].soundDelay = {0,0,0,11,0}
	
	--杨过
	Avatar[58] = {{},{}}
	Avatar[58][1].name = "神雕大侠"
	Avatar[58][1].num = 58
	Avatar[58][1].frameNum = {0,13,12,0,0}
	Avatar[58][1].frameDelay = {0,6,5,0,0}
	Avatar[58][1].soundDelay = {0,4,3,0,0}
	
	Avatar[58][2].name = "重剑无锋"
	Avatar[58][2].num = 376
	Avatar[58][2].frameNum = {0,0,13,0,0}
	Avatar[58][2].frameDelay = {0,0,11,0,0}
	Avatar[58][2].soundDelay = {0,0,9,0,0}
	
	--黛绮丝
	Avatar[15] = {{},{}}
	Avatar[15][1].name = "金花婆婆"
	Avatar[15][1].num = 15
	Avatar[15][1].frameNum = {0,0,0,0,14}
	Avatar[15][1].frameDelay = {0,0,0,0,12}
	Avatar[15][1].soundDelay = {0,0,0,0,10}
	
	Avatar[15][2].name = "紫衫龙王"
	Avatar[15][2].num = 377
	Avatar[15][2].frameNum = {0,0,0,0,12}
	Avatar[15][2].frameDelay = {0,0,0,0,10}
	Avatar[15][2].soundDelay = {0,0,0,0,10}

	--韦小宝
	Avatar[601] = {{},{}}
	Avatar[601][1].name = "游手好闲"
	Avatar[601][1].num = 225
	Avatar[601][1].frameNum = {0,8,0,7,0}
	Avatar[601][1].frameDelay = {0,6,0,5,0}
	Avatar[601][1].soundDelay = {0,6,0,5,0}
	
	Avatar[601][2].name = "一人之下"
	Avatar[601][2].num = 378
	Avatar[601][2].frameNum = {0,0,0,14,0}
	Avatar[601][2].frameDelay = {0,0,0,12,0}
	Avatar[601][2].soundDelay = {0,0,0,10,0}
	
	--乔峰
	Avatar[50] = {{},{}}
	Avatar[50][1].name = "奋英雄怒"
	Avatar[50][1].num = 50
	Avatar[50][1].frameNum = {0,14,0,0,0}
	Avatar[50][1].frameDelay = {0,8,0,0,0}
	Avatar[50][1].soundDelay = {0,5,0,0,0}
	
	Avatar[50][2].name = "狂龙天征"
	Avatar[50][2].num = 388
	Avatar[50][2].frameNum = {0,14,0,0,0}
	Avatar[50][2].frameDelay = {0,8,0,0,0}
	Avatar[50][2].soundDelay = {0,5,0,0,0}
	
	--文字颜色定义
	CC.Color = {["R"]=C_RED, ["G"]=M_Green, ["B"]=M_Blue}
  
	--是否显示滚动提醒，1打开，0关闭
	CC.OpenTimmerRemind = 0;
  
	--windows版本默认是打开
	if CONFIG.Operation == 0 then
		CC.OpenTimmerRemind = 1;
	end
	
	require("MyOEvent");
end

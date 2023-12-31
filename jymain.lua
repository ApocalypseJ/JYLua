
function IncludeFile()
	package.path=CONFIG.ScriptLuaPath;  --设置加载路径
	require("jyconst")					--加载其他文件，使用require避免重复加载
	require("jywar")
	require("jyacvmts")
end

function SetGlobal()  	 --设置游戏内部使用的全程变量
	JY={};

	JY.Status=GAME_INIT; --游戏当前状态

	--保存R×数据
	JY.Base={};          --基本数据
	JY.PersonNum=0;      --人物个数
	JY.Person={};        --人物数据
	JY.ThingNum=0        --物品数量
	JY.Thing={};         --物品数据
	JY.SceneNum=0        --场景数量
	JY.Scene={};         --场景数据
	JY.WugongNum=0       --物品数量
	JY.Wugong={};        --物品数据
	JY.ShopNum=0 		 --商店数量
	JY.Shop={};    		 --商店数据
	
   
	JY.MyCurrentPic = 0		--主角当前走路贴图在贴图文件中偏移
	JY.MyPic = 0     		--主角当前贴图
	JY.Mytick = 0			--主角没有走路的持续帧数
	JY.MyTick2 = 0			--显示事件动画的节拍
	JY.LOADTIME = 0
	JY.SAVETIME = 0
	JY.GTIME = 0			--游戏时间
	JY.GOLD = 0				--游戏银两

	JY.SubScene=-1;         --当前子场景编号
	JY.SubSceneX=0;         --子场景显示位置偏移，场景移动指令使用
	JY.SubSceneY=0;

	JY.Darkness=0;          --=0 屏幕正常显示，=1 不显示，屏幕全黑

	JY.CurrentD=-1;         --当前调用D*的编号
	JY.OldDPass=-1;         --上次触发路过事件的D*编号, 避免多次触发
	JY.CurrentEventType=-1  --当前触发事件的方式 1 空格 2 物品 3 路过

	JY.CurrentThing=-1;     --当前选择物品，触发事件使用

	JY.MmapMusic=-1;        --切换大地图音乐，返回主地图时，如果设置，则播放此音乐

	JY.CurrentMIDI=-1;      --当前播放的音乐id，用来在关闭音乐时保存音乐id。
	JY.EnableMusic=1;       --是否播放音乐 1 播放，0 不播放
	JY.EnableSound=1;       --是否播放音效 1 播放，0 不播放
	JY.EnableSay=1;			--是否启动对话 1 开启，0 关闭

	WAR={};					--战斗使用的全程变量 这里占个位置，因为程序后面不允许定义全局变量了。具体内容在WarSetGlobal函数中

	AutoMoveTab = {[0] = 0}
	
	JY.Restart = 0			--返回游戏初始界面
	JY.WalkCount = 0		--走路计步
	
	ItemInfo = {}			--物品详细说明
	IsViewingKungfuScrolls = 0
	
	Achievements = {}
	Achievements.pChar = {}
	
	YC={}
	YC.ZJH = 0				--隐藏主角张家辉
	YC.Kael = 0
	G = {}					--常用函数
	
	JY.Dream = 0			--梦中世界纪录
end

function JY_Main()        --主程序入口
	os.remove("debug.txt");      	  --清除以前的debug输出
    xpcall(JY_Main_sub,myErrFun);     --捕获调用错误
end

function myErrFun(err)      --错误处理，打印错误信息
    lib.Debug(err);                 --输出错误信息
    lib.Debug(debug.traceback());   --输出调用堆栈信息
end

function JY_Main_sub()		--真正的游戏主程序入口
    SetGlobal()				--设置全程变量JY
	IncludeFile()			--导入其他模块
	SetGlobalConst()		--设置全程变量CC, 程序使用的常量

    --禁止访问全程变量
    setmetatable(_G,{ __newindex =function (_,n)
                       error("attempt read write to undeclared variable " .. n,2);
                       end,
                       __index =function (_,n)
                       error("attempt read read to undeclared variable " .. n,2);
                       end,
                     }  );
					
	
    lib.Debug("JY_Main start.");

	math.randomseed(os.time());			--初始化随机数发生器

    JY.Status=GAME_START;				--改变游戏状态

    lib.PicInit(CC.PaletteFile);		--加载原来的256色调色板
	
	lib.FillColor(0,0,0,0,0);
	
	lib.LoadPNGPath(CC.HeadPath, 1, CC.HeadNum, limitX(CC.ScreenW/936*100,0,100))	--设置读取PNG图片的路径
	
	lib.LoadPNGPath(CC.PTPath, 95, CC.PTNum, limitX(CC.ScreenW/936*100,0,100))
	
	lib.LoadPNGPath(CC.UIPath, 96, CC.UINum, limitX(CC.ScreenW/936*100,0,100))
	
	while true do
		if JY.Restart == 1 then
			JY.Restart = 0
			JY.Status=GAME_START;
		end
		if JY.Status == GAME_END then
			break;
		end
		
		PlayMIDI(70);
		Cls();
		lib.ShowSlow(20,0);
		
		local r = StartMenu();
		if r ~= nil then
			return;
		end

		lib.LoadPicture("",0,0);
		lib.GetKey();
		
		Game_Cycle();
	end
end

function TitleSelection()
	local choice = 1
	local buttons ={
	{961,964,351,340,613,387},
	{962,965,351,405,613,452},
	{963,966,351,470,613,517}
	}
	local function on_button(mx, my)
		local r = 0
			for i = 1, #buttons do
				if mx >= buttons[i][3] and mx <= buttons[i][5] and my >= buttons[i][4] and my <= buttons[i][6] then
					r = i
					break
				end
			end
		return r
	end
	while true do
		if JY.Restart == 1 then
			return
		end
		local keypress, ktype, mx, my = lib.GetKey()
		if keypress == VK_DOWN then
			choice = choice + 1
			if choice > #buttons then
				choice = 1
			end
		elseif keypress == VK_UP then
			choice = choice - 1
			if choice < 1 then
				choice = #buttons
			end
		else
			if (ktype == 2 or ktype == 3) then
				local r = on_button(mx, my)
				if r > 0 then
					choice = r
				end
			end
			if keypress == VK_RETURN or (ktype == 3 and on_button(mx, my)>0) then
				break
			end
		end
		Cls()
		for i = 1, #buttons do
			local picid = buttons[i][1]
			if i == choice then
				picid = buttons[i][2]
			end
			lib.LoadPNG(1, picid * 2 , buttons[i][3], buttons[i][4], 1)
		end
		--版本号
		DrawString(CC.ScreenW-160,CC.ScreenH-30,CC.Version,C_BLACK,CC.Fontsmall)
		ShowScreen()
		lib.Delay(CC.Frame)
	end
	return choice
end

function StartMenu()
	Cls()
	--[[
	local menu={  {"重新开始",nil,1},
	              {"载入进度",nil,1},
	              {"离开游戏",nil,1}  };
	local menux=(CC.ScreenW-4*CC.StartMenuFontSize-2*CC.MenuBorderPixel)/2

	local menuReturn=ShowMenu(menu,3,0,menux,CC.StartMenuY,0,0,0,0,CC.StartMenuFontSize,C_STARTMENU, C_RED)
	Cls();]]
	local menuReturn = TitleSelection()
    if menuReturn == 1 then        --重新开始游戏
		NewGame();   		       --设置新游戏数据
		if JY.Restart == 1 then
			do return end
		end
		--畅想杨过初始场景
		if JY.Base["畅想"] == 58 then
			JY.SubScene = 18
			JY.Base["人X"] = 144
			JY.Base["人Y"] = 218
			JY.Base["人X1"] = 30
			JY.Base["人Y1"] = 32
		elseif	JY.Base["畅想"] == 5 then
			JY.SubScene = 28
		else
			JY.SubScene = CC.NewGameSceneID
			JY.Base["人X1"] = CC.NewGameSceneX
			JY.Base["人Y1"] = CC.NewGameSceneY
		end
		--无酒不欢：男女主角判定
		if JY.Person[0]["性别"] == 0 then
			JY.MyPic = CC.NewPersonPicM
		else
			JY.MyPic = CC.NewPersonPicF
		end
		JY.Status = GAME_SMAP
		JY.MmapMusic = -1
		CleanMemory()
		Init_SMap(0)
        lib.ShowSlow(20,0)
        
		--if DrawStrBoxYesNo(-1, -1, "是否观看序章剧情？", C_GOLD, CC.DefaultFont, LimeGreen) == true then 
			--oldCallEvent(CC.NewGameEvent)
		--end
		
		--开局事件
		if JY.Base["畅想"] == 58 then		--畅想杨过
			CallCEvent(4187)
		elseif JY.Base["畅想"] == 5 then		--畅想杨过
			CallCEvent(7006)
		else								--其他人
			CallCEvent(691)
		end
		
		--畅想开局获得自身的装备
		if JY.Base["畅想"] > 0 then
			if JY.Person[0]["武器"] ~= - 1 then
				instruct_2(JY.Person[0]["武器"], 1)
				JY.Person[0]["武器"] = - 1
			end
			if JY.Person[0]["防具"] ~= - 1 then
				instruct_2(JY.Person[0]["防具"], 1)
				JY.Person[0]["防具"] = - 1
			end
			if JY.Person[0]["动物"] ~= - 1 then
				instruct_2(JY.Person[0]["动物"], 1)
				JY.Person[0]["动物"] = - 1
			end
		end
		--畅想尹克西获得一万两
		if JY.Base["畅想"] == 158 then
			instruct_2(174, 10000)
		end
		--标主可以在云岭洞花钱学习迷踪步
		if JY.Base["标准"] > 0 then
			addevent(41, 0, 1, 4144, 1, 8694)
		end
		--张家辉的专属装备
		if JY.Base["特殊"] == 2 then
			for i = 301, 304 do
				instruct_2(i, 1)
			end
		end
		--周目奖励 洗髓
		for i = 1, 8 do
			if Achievements.bonus[i] > 0 and i < 4 then
				instruct_2(304+i,Achievements.bonus[i])
				Achievements.bonus[i] = 0
			elseif Achievements.bonus[i] > 0 and i >= 4 and i < 8 then
			    instruct_2(329+i,Achievements.bonus[i])
				Achievements.bonus[i] = 0
			elseif Achievements.bonus[i] > 0 and i >= 8 then
			    instruct_2(332+i,Achievements.bonus[i])
				Achievements.bonus[i] = 0	
			end
			SaveTable(Achievements)
		end
	elseif menuReturn == 2 then         --载入旧的进度

    	DrawStrBox(-1,CC.ScreenH*1/6-20,"读取进度",LimeGreen,CC.Fontbig,C_GOLD);
		DrawStrBox(104,CC.ScreenH*1/6+26,string.format("%-6s %-4s %-10s %-4s %-4s %-4s %-10s","存档名", "主角", "姓名", "难度", "资质", "天书", "位置"),C_ORANGE,CC.DefaultFont,C_GOLD);
	
    	local r = SaveList();
    	--ESC 重新返回选项
    	if r < 1 then
    		local s = StartMenu();
    		return s;
    	end
    	
    	Cls();
		DrawStrBox(-1,CC.StartMenuY,"请稍候...",C_GOLD,CC.DefaultFont);
		ShowScreen();
    	local result = LoadRecord(r);
    	if result ~= nil then
    		return StartMenu();
    	end

		if JY.Base["无用"] ~= -1 then
			if JY.SubScene < 0 then
				CleanMemory()
				lib.UnloadMMap()
			end
			lib.PicInit()
			lib.ShowSlow(20, 1)
			JY.Status = GAME_SMAP
			JY.SubScene = JY.Base["无用"]
			JY.MmapMusic = -1
			JY.MyPic = GetMyPic()
			Init_SMap(1)
		else
			JY.SubScene = -1
			JY.Status = GAME_FIRSTMMAP
		end
	elseif menuReturn == 3 then
        return -1;
	end
end

function CleanMemory()            --清理lua内存
    if CONFIG.CleanMemory==1 then
		collectgarbage("collect");
    end
end

function NewGame()     --选择新游戏，设置主角初始属性
	Cls();
	ShowScreen();
	LoadRecord(0); --  载入新游戏数据
	
	--执行成就文件
	if existFile(CC.Acvmts) then
		dofile(CC.Acvmts)
	--一周目
	else
		Achievements.Round = JY.Base["周目"]
		Achievements.pChar = {}
		Achievements.rdsCpltd = {}
		for i = 1, JY.PersonNum do
			Achievements.rdsCpltd[i] = {}
			Achievements.rdsCpltd[i].n = 0
			Achievements.rdsCpltd[i].lvlReached1 = 0
			Achievements.rdsCpltd[i].lvlReached2 = 0
		end
		Achievements.sp = 0
		Achievements.bonus = {}
		for i = 1, 8 do
			Achievements.bonus[i] = 0
		end
		--以表格形式保存新文件
		SaveTable(Achievements)
	end

	JY.Base["周目"] = 1
	if Achievements.rdsCpltd[680].n>0 then
	JY.Person[680]["品德"]=100
	end
	if Achievements.rdsCpltd[92].n>0 then
	JY.Person[92]["天1"] = 1
	end
	if Achievements.rdsCpltd[642].n>0 then
	JY.Person[642]["畅想分阶"]=2
	end
	if Achievements.rdsCpltd[670].n>0 then
	   JY.Person[674]["无用"]=100
	end
	if Achievements.rdsCpltd[675].n>0 then
	   JY.Person[675]["无用"]=100
	end
	JY.Status = GAME_NEWNAME
	--周目系统
	while true do
		if JY.Restart == 1 then
			break
		end
		ClsN()
		local zmxt = JYMsgBox("周目系统", "在正式开始游戏之前，可以选择本次游戏的周目。*☆注意：2周目及以上，每周目敌方武常增加10☆*周目商店中可用通关获得的秘武残章兑换各种奖励！**当前周目："..JY.Base["周目"].."周目*最高周目："..Achievements.Round.."周目*", {"周目选择","周目商店","开始游戏"}, 3, 290)
		ClsN()
		if zmxt == 1 then
			JY.Base["周目"] = InputNum("选择周目",1,Achievements.Round);
		elseif zmxt == 2 then
			zmStore()
		elseif zmxt == 3 then
			break
		end
	end
	ClsN()
	
	--选择难度
	JY.Base["难度"] = JYMsgBox("请选择游戏难度", "本作品注重思考和规划，但是更加注重SL。*忽略成长过程直接追求无敌是很无聊的事情。*新人、准新人请务必选择入门难度。*放心，入门难度足够低，可以让你轻松上手*·追求轻松休闲、高自由度的老玩家，*推荐选择入门或第二难度。*·倘若为追求挑战，你选择了高难度，*记得提醒自己做好降龙十八窗的准备！*", MODEXZ2, 8, 35)
	ClsN()
	
	--jh
	local jhyz = JYMsgBox("请选择是否使用冷却", "                          ",{"使用","放弃"},2)
	      if jhyz == 1 then
		     JY.Person[123]["天2"] = 1
		  elseif jhyz == 2 then
		     JY.Person[123]["天2"] = 2
          end	  
	ClsN()
	
	--jh
	--[[local jhyz = JYMsgBox("请选择压制等级", "压制等级越高，敌人的属性就会越高。*每升级一个压制等级，主角会在实战中选择一个天赋领悟。*敌人的部分额外属性会随游戏进程平滑提高。",{"无","一","二","三","四"},5,516)
	      if jhyz == 2 then
		     JY.Person[123]["天1"] = 1
		  elseif jhyz == 3 then
		     JY.Person[123]["天1"] = 2
		  elseif jhyz == 4 then
		     JY.Person[123]["天1"] = 3
		  elseif jhyz == 5 then
		     JY.Person[123]["天1"] = 4
          end	  
	ClsN()]]
	   
	
	--武功数量
	local kfnum = JYMsgBox("请选择武功数量上限", "十二武为标准，十五武敌人会更强。",{"十二","十三","十四","十五"},4,58)
	      if kfnum == 1 then
		     JY.Person[671]["品德"] = 12
		  elseif kfnum == 2 then
		     JY.Person[671]["品德"] = 13
		  elseif kfnum == 3 then
		     JY.Person[671]["品德"] = 14
		  elseif kfnum == 4 then
		     JY.Person[671]["品德"] = 15
          end	  
	ClsN()
	
	--选择标主还是畅想
	local player_type = JYMsgBox("主角选择", "选择你想要的主角模式*", {"标准主角","畅想主角"}, 2, 378)
	ClsN()

	JY.Person[0]["姓名"]=CC.NewPersonName;
		  
	JY.Person[0]["生命最大值"] = 50
	JY.Person[0]["内力最大值"] = 100
	JY.Person[0]["生命"] = JY.Person[0]["生命最大值"]
	JY.Person[0]["内力"] = JY.Person[0]["内力最大值"]
	JY.Person[0]["攻击力"] = 30
	JY.Person[0]["防御力"] = 30
	JY.Person[0]["轻功"] = 30
	JY.Person[0]["医疗能力"] = 30
	JY.Person[0]["用毒能力"] = 30
	JY.Person[0]["解毒能力"] = 30
	JY.Person[0]["抗毒能力"] = 0
	JY.Person[0]["拳掌功夫"] = 30
	JY.Person[0]["指法技巧"] = 30
	JY.Person[0]["御剑能力"] = 30
	JY.Person[0]["耍刀技巧"] = 30
	JY.Person[0]["特殊兵器"] = 30
	JY.Person[0]["暗器技巧"] = 30
	
	--标准主角+特殊主角
	if player_type == 1 then	
		--特殊主角
		if DrawStrBoxYesNo(-1, -1, "是否选用特殊主角进行游戏？", C_WHITE, CC.DefaultFont) == true then
			ClsN()
			local t = 1
			if JY.Person[680]["品德"]==100 then
			   t = 2
			end   
		local ch = JYMsgBox("请选择特殊主角", "                               ", {"无酒不欢","正义玩家"},t)
		if ch == 1 then
			--特殊主角的贴图
			JY.Person[0]["姓名"] = "无酒不欢"
			JY.Person[0]["头像代号"] = 355
			local T_ani = {
				{0, 0, 0}, 
				{0, 0, 0}, 
				{10, 8, 6}, 
				{0, 0, 0}, 
				{0, 0, 0}}
			for i = 1, 5 do
				JY.Person[0]["出招动画帧数" .. i] = T_ani[i][1]
				JY.Person[0]["出招动画延迟" .. i] = T_ani[i][3]
				JY.Person[0]["武功音效延迟" .. i] = T_ani[i][2]
			end
			
			ClsN()
			
			JY.Person[0]["资质"] = InputNum("输入资质",1,100);
			if JY.Person[0]["资质"] == 1 then
			   JY.Person[670]["无用"] = 1
			elseif JY.Person[0]["资质"] == 100 then
			   JY.Person[670]["无用"] = 2
            end			

			ClsN()
			
			JY.Base["特殊"] = 1
			JY.Person[0]["攻击力"] = 40
			JY.Person[0]["防御力"] = 40
			JY.Person[0]["轻功"] = 40
			JY.Person[0]["拳掌功夫"] = 50
			JY.Person[0]["指法技巧"] = 50
			JY.Person[0]["御剑能力"] = 50
			JY.Person[0]["耍刀技巧"] = 50
			JY.Person[0]["特殊兵器"] = 50
		else
		    JY.Person[0]["姓名"] = "正义玩家"
			JY.Person[0]["头像代号"] = 355
            local i = 0
			local t = 2
			if JY.Person[92]["天1"] == 1 then
			t = 4
			end
			while i < t do
			   i = 0
			   JY.Person[0]["地"..math.random(9)] = 8
			   for j = 1, 9 do
			      if JY.Person[0]["地"..j] == 8 then
				     i = i + 1
				  end
				  
			   end	  
			end   
			local T_ani = {
				{0, 0, 0}, 
				{0, 0, 0}, 
				{10, 8, 6}, 
				{0, 0, 0}, 
				{0, 0, 0}}
			for i = 1, 5 do
				JY.Person[0]["出招动画帧数" .. i] = T_ani[i][1]
				JY.Person[0]["出招动画延迟" .. i] = T_ani[i][3]
				JY.Person[0]["武功音效延迟" .. i] = T_ani[i][2]
			end
			
			ClsN()
			
			JY.Person[0]["资质"] = InputNum("输入资质",1,100);
			if JY.Person[0]["资质"] == 1 then
			   JY.Person[670]["无用"] = 1
			elseif JY.Person[0]["资质"] == 100 then
			   JY.Person[670]["无用"] = 2
            end			

			ClsN()
			
			JY.Base["特殊"] = 3
			JY.Person[0]["攻击力"] = 40
			JY.Person[0]["防御力"] = 40
			JY.Person[0]["轻功"] = 40
			JY.Person[0]["拳掌功夫"] = 50
			JY.Person[0]["指法技巧"] = 50
			JY.Person[0]["御剑能力"] = 50
			JY.Person[0]["耍刀技巧"] = 50
			JY.Person[0]["特殊兵器"] = 50
		end
		--标准主角
		else
			ClsN()
			
			local gender;
			
			gender = JYMsgBox("请选择", "请选择你的主角性别 ", {"男", "女"}, 2, 291)
			
			--女主角初始化
			if gender == 2 then
				JY.Person[0]["性别"] = 1
				JY.Person[0]["外号"] = "姑娘"
				JY.Person[0]["外号2"] = "丫头"
				JY.Person[0]["头像代号"] = 303
				local f_ani = {
				{0, 0, 0}, 
				{0, 0, 0}, 
				{10, 8, 6}, 
				{0, 0, 0}, 
				{0, 0, 0}}
				for i = 1, 5 do
					JY.Person[0]["出招动画帧数" .. i] = f_ani[i][1]
					JY.Person[0]["出招动画延迟" .. i] = f_ani[i][3]
					JY.Person[0]["武功音效延迟" .. i] = f_ani[i][2]
				end
			end
			
			ClsN()
			
			JY.Person[0]["资质"] = InputNum("输入资质",1,100);
			if JY.Person[0]["资质"] == 1 then
			   JY.Person[670]["无用"] = 1
			elseif JY.Person[0]["资质"] == 100 then
			   JY.Person[670]["无用"] = 2
            end

			ClsN()
			
			--选择系
			local TF = JYMsgBox("请选择主角的天赋能力", TFXZSAY1, TFE, 9, 50)
			--是标主
			SetS(10, 0, 6, 0, 1)
			if TF == 1 then         --拳
				SetS(4, 5, 5, 5, 1)
				JY.Person[0]["拳掌功夫"] = 70
				JY.Base["标准"] = 1
			elseif TF == 2 then     --指
				JY.Person[0]["指法技巧"] = 70
				JY.Base["标准"] = 2
			elseif TF == 3 then     --剑
				SetS(4, 5, 5, 5, 2)
				JY.Person[0]["御剑能力"] = 70
				JY.Base["标准"] = 3			
			elseif TF == 4 then     --刀
				SetS(4, 5, 5, 5, 3)
				JY.Person[0]["耍刀技巧"] = 70
				JY.Base["标准"] = 4
			elseif TF == 5 then		 --特 
				SetS(4, 5, 5, 5, 4)
				JY.Person[0]["特殊兵器"] = 70
				JY.Base["标准"] = 5
			elseif TF == 6 then		 --天罡
				JY.Person[0]["内力最大值"] = 500
				JY.Person[0]["内力"] = 500
				JY.Person[0]["拳掌功夫"] = 20
				JY.Person[0]["指法技巧"] = 20
				JY.Person[0]["御剑能力"] = 20
				JY.Person[0]["耍刀技巧"] = 20
				JY.Person[0]["特殊兵器"] = 20
				SetS(4, 5, 5, 5, 5)
				JY.Base["标准"] = 6
			elseif TF == 7 then		 --仁者
				JY.Person[0]["品德"] = 100
				JY.Person[0]["拳掌功夫"] = 70
				JY.Person[0]["指法技巧"] = 70
				JY.Person[0]["御剑能力"] = 70
				JY.Person[0]["耍刀技巧"] = 70
				JY.Person[0]["特殊兵器"] = 70
				SetS(4, 5, 5, 5, 6)
				JY.Base["标准"] = 7
			elseif TF == 8 then		 --医生
				JY.Person[0]["拳掌功夫"] = 70
				JY.Person[0]["指法技巧"] = 70
				JY.Person[0]["御剑能力"] = 70
				JY.Person[0]["耍刀技巧"] = 70
				JY.Person[0]["特殊兵器"] = 70
				JY.Person[0]["医疗能力"] = 200
				JY.Person[0]["用毒能力"] = 200
				JY.Person[0]["解毒能力"] = 200
				SetS(4, 5, 5, 5, 7)
				JY.Base["标准"] = 8
			elseif TF == 9 then		 --毒王
				JY.Base["标准"] = 9
				JY.Person[0]["拳掌功夫"] = 70
				JY.Person[0]["指法技巧"] = 70
				JY.Person[0]["御剑能力"] = 70
				JY.Person[0]["耍刀技巧"] = 70
				JY.Person[0]["特殊兵器"] = 70
				JY.Person[0]["用毒能力"] = 300
				JY.Person[0]["解毒能力"] = 300
				JY.Person[0]["攻击带毒"] = 50
			end
			ClsN()
		end
	--畅想主角
	elseif player_type == 2 then
		lib.LoadPNG(1, 1000 * 2 , 0 , 0, 1)
		
	    local menu = {}
		for i = 1, JY.PersonNum - 1 do
			menu[#menu + 1] = {JY.Person[i]["姓名"], nil, JY.Person[i]["畅想分阶"], i}
		end
		
		--无酒不欢：分出一个菜单函数来显示畅想选单
		local clone_choice = ShowMenu3(menu,#menu,8,15,CC.MainMenuX+CC.Fontsmall*1-13,CC.MainMenuY+CC.Fontsmall*3+10,CC.Fontsmall, C_GOLD, C_WHITE)
	
		ClsN()
		
		JY.Base["畅想"] = clone_choice
		
		JY.Person[0]["代号"]=JY.Person[clone_choice]["代号"]
		JY.Person[0]["头像代号"]=JY.Person[clone_choice]["头像代号"]
		JY.Person[0]["生命增长"]=JY.Person[clone_choice]["生命增长"]
		JY.Person[0]["无用"]=JY.Person[clone_choice]["无用"]
		JY.Person[0]["姓名"]=JY.Person[clone_choice]["姓名"]
		JY.Person[0]["外号"]=JY.Person[clone_choice]["外号"]
		JY.Person[0]["性别"]=JY.Person[clone_choice]["性别"]

		JY.Person[0]["武器"]=JY.Person[clone_choice]["武器"]
		JY.Person[0]["防具"]=JY.Person[clone_choice]["防具"]
		JY.Person[0]["动物"]=JY.Person[clone_choice]["动物"]

		for i=1,5 do
			JY.Person[0]["出招动画帧数" .. i]=JY.Person[clone_choice]["出招动画帧数" .. i]
			JY.Person[0]["出招动画延迟" .. i]=JY.Person[clone_choice]["出招动画延迟" .. i]
			JY.Person[0]["武功音效延迟" .. i]=JY.Person[clone_choice]["武功音效延迟" .. i]
		end
		
		--畅想攻防轻最低25
		JY.Person[0]["攻击力"]=limitX(JY.Person[clone_choice]["攻击力"]/4,25)
		JY.Person[0]["防御力"]=limitX(JY.Person[clone_choice]["防御力"]/4,25)
		JY.Person[0]["轻功"]=limitX(JY.Person[clone_choice]["轻功"]/4,25)
		--医疗用毒解毒最低30
		JY.Person[0]["医疗能力"]=limitX(JY.Person[clone_choice]["医疗能力"],30)
		JY.Person[0]["用毒能力"]=limitX(JY.Person[clone_choice]["用毒能力"],30)
		JY.Person[0]["解毒能力"]=limitX(JY.Person[clone_choice]["解毒能力"],30)

		JY.Person[0]["抗毒能力"]=JY.Person[clone_choice]["抗毒能力"]
		JY.Person[0]["拳掌功夫"]=JY.Person[clone_choice]["拳掌功夫"]
		JY.Person[0]["指法技巧"]=JY.Person[clone_choice]["指法技巧"]
		JY.Person[0]["御剑能力"]=JY.Person[clone_choice]["御剑能力"]
		JY.Person[0]["耍刀技巧"]=JY.Person[clone_choice]["耍刀技巧"]
		JY.Person[0]["特殊兵器"]=JY.Person[clone_choice]["特殊兵器"]
		--暗器技巧至少30
		JY.Person[0]["暗器技巧"]=limitX(JY.Person[clone_choice]["暗器技巧"],30)

		JY.Person[0]["武学常识"]=JY.Person[clone_choice]["武学常识"]
		JY.Person[0]["攻击带毒"]=JY.Person[clone_choice]["攻击带毒"]
		JY.Person[0]["左右互搏"]=JY.Person[clone_choice]["左右互搏"]
		JY.Person[0]["出战"]=JY.Person[clone_choice]["出战"]
	
		for i=1,JY.Person[671]["品德"] do
			JY.Person[0]["武功" .. i]=JY.Person[clone_choice]["武功" .. i]
			JY.Person[0]["武功等级" .. i]=JY.Person[clone_choice]["武功等级" .. i]
		end

		for i=1,4 do
			JY.Person[0]["携带物品" .. i]=JY.Person[clone_choice]["携带物品" .. i]
			JY.Person[0]["携带物品数量" .. i]=JY.Person[clone_choice]["携带物品数量" .. i]
		end
		
		for i=1,4 do
			JY.Person[0]["天赋外功"..i]=JY.Person[clone_choice]["天赋外功"..i]
		end
		
		JY.Person[0]["天赋内功"]=JY.Person[clone_choice]["天赋内功"]
		JY.Person[0]["天赋轻功"]=JY.Person[clone_choice]["天赋轻功"]
		JY.Person[0]["畅想分阶"]=JY.Person[clone_choice]["畅想分阶"]
		JY.Person[0]["外号2"]=JY.Person[clone_choice]["外号2"]
		JY.Person[0]["特色指令"] = JY.Person[clone_choice]["特色指令"]
		
		--畅想萧中慧无法慧心
		if JY.Base["畅想"] == 77 then
			JY.Person[0]["特色指令"] = 0	
		end
		
		--雷震
		if JY.Base["畅想"] == 670 then
			JY.Person[0]["拳掌功夫"]=10
			JY.Person[0]["指法技巧"]=10
			JY.Person[0]["御剑能力"]=10
			JY.Person[0]["耍刀技巧"]=10
			JY.Person[0]["特殊兵器"]=10
		end
		
		--畅想王语嫣初始兵器值
		if JY.Base["畅想"] == 76 then
			JY.Person[0]["拳掌功夫"]=30
			JY.Person[0]["指法技巧"]=30
			JY.Person[0]["御剑能力"]=30
			JY.Person[0]["耍刀技巧"]=30
			JY.Person[0]["特殊兵器"]=30
		end
		
		--畅想郭靖初始20拳
		if JY.Base["畅想"] == 55 then
			JY.Person[0]["拳掌功夫"]=20
		end
		
		--畅想韦小宝初始20拳
		if JY.Base["畅想"] == 601 then
			JY.Person[0]["特殊兵器"]=30
		end
		
		--畅想无名
		if JY.Base["畅想"] == 671 then
			JY.Person[0]["攻击力"]= 50
			JY.Person[0]["防御力"]= 50
			JY.Person[0]["轻功"]= 50
			JY.Person[0]["武学常识"]= 100
		end
	
		
		--畅想张三丰
		if JY.Base["畅想"] == 5 then
			JY.Person[0]["姓名"]="张君宝"
			local clone_choice = 652
			JY.Person[0]["头像代号"]=JY.Person[clone_choice]["头像代号"]
			for i=1,5 do
			JY.Person[0]["出招动画帧数" .. i]=JY.Person[clone_choice]["出招动画帧数" .. i]
			JY.Person[0]["出招动画延迟" .. i]=JY.Person[clone_choice]["出招动画延迟" .. i]
			JY.Person[0]["武功音效延迟" .. i]=JY.Person[clone_choice]["武功音效延迟" .. i]
		end
		end
		
		--难7畅想海大富割鸡
		if JY.Base["畅想"] == 602 and JY.Base["难度"]>=7 then
			JY.Person[0]["性别"]=2
		end

		--难7畅想东方不败割鸡		
		if JY.Base["畅想"] == 27 and JY.Base["难度"]>=7 then
			JY.Person[0]["性别"]=2
		end
		
		--难7畅想萧半河割鸡		
		if JY.Base["畅想"] == 189 and JY.Base["难度"]>=7 then
			JY.Person[0]["性别"]=2
		end
		
		--难7畅想林平之割鸡		
		if JY.Base["畅想"] == 36 and JY.Base["难度"]>=7 then
			JY.Person[0]["性别"]=2
		end
		
		--难7畅想岳不群割鸡		
		if JY.Base["畅想"] == 19 and JY.Base["难度"]>=7 then
			JY.Person[0]["性别"]=2
		end
		
		if JY.Base["畅想"] == 669 then
			JY.Base["天书数量"] =14
		end
		
		--畅想王重阳开局选择外功
		if JY.Base["畅想"] == 129 then
			local wcywg = JYMsgBox("请选择", "请选择你的初始外功", {"全真剑法","一阳指"}, 2, 129)
			if wcywg == 1 then
				JY.Person[0]["武功1"]=39
				JY.Person[0]["武功等级1"]=999
			elseif wcywg == 2 then
				JY.Person[0]["武功1"]=17
				JY.Person[0]["武功等级1"]=999
			end
			JY.Person[0]["武功2"]=100
			JY.Person[0]["武功等级2"]=999
			JY.Person[0]["武功3"]=0
			JY.Person[0]["武功等级3"]=0
			ClsN()
		end
		
		--畅想裘千尺头像变美
		if JY.Base["畅想"] == 617 then
			JY.Person[0]["头像代号"]=353
			JY.Person[0]["出招动画帧数3"]=24
			JY.Person[0]["出招动画延迟3"]=22
			JY.Person[0]["武功音效延迟3"]=22
		end
		
		if JY.Base["畅想"] == 189 then		
		JY.Person[0]["品德"] = 100
		end
		
		--大雪怪初始化
		if JY.Base["畅想"] == 420 then
			JY.Person[0]["攻击力"]=30
			JY.Person[0]["防御力"]=30
			JY.Person[0]["轻功"]=30
			JY.Person[0]["拳掌功夫"]=40
			JY.Person[0]["指法技巧"]=20
			JY.Person[0]["御剑能力"]=10
			JY.Person[0]["特殊兵器"]=10
			JY.Person[0]["耍刀技巧"]=10
		end
		
		if JY.Base["畅想"] == 678 then
			JY.Person[0]["攻击力"]=50
			JY.Person[0]["防御力"]=50
			JY.Person[0]["轻功"]=70
		end
		
		--丁典初始化
		if JY.Base["畅想"] == 672 then
			JY.Person[0]["攻击力"]=30
			JY.Person[0]["防御力"]=30
			JY.Person[0]["轻功"]=30
			JY.Person[0]["拳掌功夫"]=40
			JY.Person[0]["指法技巧"]=40
			JY.Person[0]["御剑能力"]=50
			JY.Person[0]["特殊兵器"]=30
			JY.Person[0]["耍刀技巧"]=30
			JY.Person[0]["武功1"]=94
			JY.Person[0]["武功等级1"]=999
			JY.Person[0]["天赋内功"]=94
			JY.Person[0]["天赋外功1"]=114
			JY.Person[672]["品德"]=80
			JY.Person[672]["声望"]=80
		end
		
		--丁典初始化
		if JY.Base["畅想"] == 676 then
			JY.Person[0]["攻击力"]=50
			JY.Person[0]["防御力"]=50
			JY.Person[0]["轻功"]=50
			
		end
		
		--华英雄初始化
		if JY.Base["畅想"] == 675 then
			JY.Person[0]["攻击力"]=50
			JY.Person[0]["防御力"]=30
			JY.Person[0]["轻功"]=50
			JY.Person[0]["拳掌功夫"]=80
			JY.Person[0]["指法技巧"]=50
			JY.Person[0]["御剑能力"]=100
			JY.Person[0]["特殊兵器"]=50
			JY.Person[0]["耍刀技巧"]=50
			JY.Person[0]["暗器技巧"]= 80
			JY.Person[0]["武功2"]=0
			JY.Person[0]["武功等级2"]=0
			JY.Person[0]["武功3"]=0
			JY.Person[0]["武功等级3"]=0
			JY.Person[0]["天赋内功"]=0
			JY.Person[0]["天赋外功1"]=211
			JY.Person[0]["天赋外功2"]=0
			JY.Person[0]["天赋外功3"]=0
		end
		
		
		--范瑶
		if JY.Base["畅想"] == 10 then
			JY.Person[0]["特殊兵器"]=60
			JY.Person[0]["耍刀技巧"]=60
			JY.Person[0]["武功1"]=0
			JY.Person[0]["武功等级1"]=0
			JY.Person[0]["武功2"]=0
			JY.Person[0]["武功等级2"]=0
			JY.Person[0]["天赋内功"]=0
			JY.Person[0]["天赋外功1"]=0
			JY.Person[10]["品德"]=1
		end
		
		--if
		if JY.Base["畅想"] == 693 then
			JY.Person[0]["攻击力"]=50
			JY.Person[0]["防御力"]=30
			JY.Person[0]["轻功"]=50
			JY.Person[0]["拳掌功夫"]=100
			JY.Person[0]["指法技巧"]=80
			JY.Person[0]["御剑能力"]=60
			JY.Person[0]["特殊兵器"]=60
			JY.Person[0]["耍刀技巧"]=60
			JY.Person[0]["暗器技巧"]=50
			JY.Person[0]["武功等级16"] = 999
		end
		
		
		--豪鬼
		if JY.Base["畅想"] == 673 then
		local wh = JYMsgBox("请选择天赋I类型", "I怒火冲天：*指令状态提高爆发伤害能力*II炽烈爆发：*指令状态提高连续进攻能力",{"怒火冲天","炽烈爆发"},2,402)
	      if wh == 1 then
		     JY.Person[673]["外号2"] = "怒"
		  else	 
		     JY.Person[673]["外号2"] = "烈"
          end	  
	    ClsN()
		local wh = JYMsgBox("请选择天赋II类型", "I  罗汉**II  气合",{"罗汉","气合"},2,402)
	      if wh == 1 then
		     JY.Person[673]["天1"] = 1
		  else	 
		     JY.Person[673]["天1"] = 2
          end	  
	    ClsN()
			JY.Person[0]["攻击力"]=50
			JY.Person[0]["防御力"]=30
			JY.Person[0]["轻功"]=50
			JY.Person[0]["拳掌功夫"]=140
			JY.Person[0]["指法技巧"]=100
			JY.Person[0]["御剑能力"]=0
			JY.Person[0]["特殊兵器"]=0
			JY.Person[0]["耍刀技巧"]=0
			JY.Person[0]["武功1"]=0
			JY.Person[0]["武功等级1"]= 0
			JY.Person[0]["武功2"]=0
			JY.Person[0]["武功等级2"]= 0
            JY.Person[0]["武功3"]=0
			JY.Person[0]["武功等级3"]= 0
			JY.Person[0]["武功4"]=0
			JY.Person[0]["武功等级4"]= 0
			JY.Person[0]["医疗能力"]= 0
		    JY.Person[0]["用毒能力"]= 0
		    JY.Person[0]["解毒能力"]= 0
			JY.Person[0]["暗器技巧"]= 0
			JY.Person[0]["武学常识"]= 100
			JY.Person[0]["天赋外功1"]=0
			JY.Person[0]["天赋外功2"]=0
			JY.Person[673]["声望"]=1
			
		end
		
		--xyz
		if JY.Base["畅想"] == 634 then
			JY.Person[0]["攻击力"]=50
			JY.Person[0]["防御力"]=50
			JY.Person[0]["轻功"]=50
			JY.Person[0]["拳掌功夫"]=100
			JY.Person[0]["指法技巧"]=100
			JY.Person[0]["御剑能力"]=100
			JY.Person[0]["特殊兵器"]=100
			JY.Person[0]["耍刀技巧"]=100
			JY.Person[0]["武学常识"]=100
			JY.Person[0]["暗器技巧"]=100
			JY.Person[0]["武功1"]=8
			JY.Person[0]["武功等级1"]= 999
			JY.Person[0]["武功2"]=0
			JY.Person[0]["武功等级2"]= 0
            JY.Person[0]["武功3"]=0
			JY.Person[0]["武功等级3"]= 0
			JY.Person[0]["武功4"]=0
			JY.Person[0]["武功等级4"]= 0
			JY.Person[0]["武功5"]=0
			JY.Person[0]["武功等级5"]= 0
			JY.Person[0]["天赋外功2"]= 8
			JY.Person[0]["天赋外功3"]= 14
			JY.Person[0]["天赋外功4"]= 184
			JY.Person[0]["天赋内功"]= 0
			JY.Person[0]["天赋轻功"]= 0
			
		end
		--xyz
		if JY.Base["畅想"] == 637 then
			JY.Person[0]["攻击力"]=50
			JY.Person[0]["防御力"]=50
			JY.Person[0]["轻功"]=50
			JY.Person[0]["拳掌功夫"]=70
			JY.Person[0]["指法技巧"]=70
			JY.Person[0]["御剑能力"]=70
			JY.Person[0]["特殊兵器"]=70
			JY.Person[0]["耍刀技巧"]=70
			JY.Person[0]["武学常识"]=70
			JY.Person[0]["暗器技巧"]=70
			JY.Person[0]["武功1"]=0
			JY.Person[0]["武功等级1"]= 0
			JY.Person[0]["武功2"]=0
			JY.Person[0]["武功等级2"]= 0
            JY.Person[0]["武功3"]=0
			JY.Person[0]["武功等级3"]= 0
			JY.Person[0]["武功4"]=0
			JY.Person[0]["武功等级4"]= 0
			JY.Person[0]["武功5"]=0
			JY.Person[0]["武功等级5"]= 0
			JY.Person[0]["天赋外功2"]= 164
			JY.Person[0]["天赋外功3"]= 201
			
		end
		if JY.Base["畅想"] == 638 then
			JY.Person[0]["攻击力"]=90
			JY.Person[0]["防御力"]=90
			JY.Person[0]["轻功"]=90
			JY.Person[0]["拳掌功夫"]=100
			JY.Person[0]["指法技巧"]=100
			JY.Person[0]["御剑能力"]=100
			JY.Person[0]["特殊兵器"]=100
			JY.Person[0]["耍刀技巧"]=100
			JY.Person[0]["武学常识"]=100
			JY.Person[0]["暗器技巧"]=100
			JY.Person[0]["武功1"]=106
			JY.Person[0]["武功等级1"]= 999
			JY.Person[0]["武功2"]=0
			JY.Person[0]["武功等级2"]= 0
            JY.Person[0]["武功3"]=0
			JY.Person[0]["武功等级3"]= 0
			JY.Person[0]["天赋外功1"]= 106
			JY.Person[0]["天赋轻功"]= 0	
		end
		--李白
		if JY.Base["畅想"] == 636 then
			JY.Person[0]["攻击力"]=50
			JY.Person[0]["防御力"]=50
			JY.Person[0]["轻功"]=50
			JY.Person[0]["拳掌功夫"]=60
			JY.Person[0]["指法技巧"]=50
			JY.Person[0]["御剑能力"]=100
			JY.Person[0]["特殊兵器"]=50
			JY.Person[0]["耍刀技巧"]=80
			JY.Person[0]["武学常识"]=50
			JY.Person[0]["暗器技巧"]=100
			JY.Person[0]["武功2"]=0
			JY.Person[0]["天赋内功"]= 0
		end
		
		--聂风
		if JY.Base["畅想"] == 681 then
			JY.Person[0]["攻击力"]=40
			JY.Person[0]["防御力"]=30
			JY.Person[0]["轻功"]=50
			JY.Person[0]["拳掌功夫"]=40
			JY.Person[0]["指法技巧"]=40
			JY.Person[0]["御剑能力"]=40
			JY.Person[0]["特殊兵器"]=40
			JY.Person[0]["耍刀技巧"]=80
			JY.Person[0]["武学常识"]=50
			JY.Person[0]["暗器技巧"]=100
			
		end
		
		if JY.Base["畅想"] == 682 then
			JY.Person[0]["攻击力"]=70
			JY.Person[0]["防御力"]=20
			JY.Person[0]["轻功"]=30
			JY.Person[0]["拳掌功夫"]=80
			JY.Person[0]["指法技巧"]=40
			JY.Person[0]["御剑能力"]=80
			JY.Person[0]["特殊兵器"]=30
			JY.Person[0]["耍刀技巧"]=30
			JY.Person[0]["武学常识"]=50
			JY.Person[0]["暗器技巧"]=60
			
		end
		
		if JY.Base["畅想"] == 683 then
			JY.Person[0]["攻击力"]=50
			JY.Person[0]["防御力"]=35
			JY.Person[0]["轻功"]=50
			JY.Person[0]["拳掌功夫"]=50
			JY.Person[0]["指法技巧"]=50
			JY.Person[0]["御剑能力"]=180
			JY.Person[0]["特殊兵器"]=40
			JY.Person[0]["耍刀技巧"]=60
			JY.Person[0]["武学常识"]=50
			JY.Person[0]["暗器技巧"]=60
			
		end
		
		if JY.Base["畅想"] == 684 then
			JY.Person[0]["攻击力"]=30
			JY.Person[0]["防御力"]=35
			JY.Person[0]["轻功"]=60
			JY.Person[0]["拳掌功夫"]=50
			JY.Person[0]["指法技巧"]=50
			JY.Person[0]["御剑能力"]=50
			JY.Person[0]["特殊兵器"]=50
			JY.Person[0]["耍刀技巧"]=50
			JY.Person[0]["暗器技巧"]=120
			
		end
		if JY.Base["畅想"] == 685 then
			JY.Person[0]["攻击力"]=20
			JY.Person[0]["防御力"]=20
			JY.Person[0]["轻功"]=20
			JY.Person[0]["拳掌功夫"]=1
			JY.Person[0]["指法技巧"]=1
			JY.Person[0]["御剑能力"]=1
			JY.Person[0]["特殊兵器"]=1
			JY.Person[0]["耍刀技巧"]=1
			JY.Person[0]["暗器技巧"]=1
			
		end
		if JY.Base["畅想"] == 686 then
			JY.Person[0]["攻击力"]=50
			JY.Person[0]["防御力"]=30
			JY.Person[0]["轻功"]=40
			JY.Person[0]["拳掌功夫"]=80
			JY.Person[0]["指法技巧"]=60
			JY.Person[0]["御剑能力"]=30
			JY.Person[0]["特殊兵器"]=30
			JY.Person[0]["耍刀技巧"]=30
			JY.Person[0]["暗器技巧"]=50
			
		end
		if JY.Base["畅想"] == 687 then
			JY.Person[0]["攻击力"]=50
			JY.Person[0]["防御力"]=40
			JY.Person[0]["轻功"]=50
			JY.Person[0]["拳掌功夫"]=60
			JY.Person[0]["指法技巧"]=100
			JY.Person[0]["御剑能力"]=80
			JY.Person[0]["特殊兵器"]=40
			JY.Person[0]["耍刀技巧"]=40
			JY.Person[0]["暗器技巧"]=75
		end
		if JY.Base["畅想"] == 688 then
			JY.Person[0]["攻击力"]=50
			JY.Person[0]["防御力"]=50
			JY.Person[0]["轻功"]=50
			JY.Person[0]["拳掌功夫"]=50
			JY.Person[0]["指法技巧"]=40
			JY.Person[0]["御剑能力"]=60
			JY.Person[0]["特殊兵器"]=100
			JY.Person[0]["耍刀技巧"]=60
			JY.Person[0]["暗器技巧"]=30
		end
		if JY.Base["畅想"] == 691 then
			JY.Person[0]["攻击力"]=50
			JY.Person[0]["防御力"]=50
			JY.Person[0]["轻功"]=50
			JY.Person[0]["拳掌功夫"]=50
			JY.Person[0]["指法技巧"]=50
			JY.Person[0]["御剑能力"]=80
			JY.Person[0]["特殊兵器"]=50
			JY.Person[0]["耍刀技巧"]=60
			JY.Person[0]["暗器技巧"]=55
		end
		if JY.Base["畅想"] == 692 then
			JY.Person[0]["攻击力"]=50
			JY.Person[0]["防御力"]=50
			JY.Person[0]["轻功"]=50
			JY.Person[0]["拳掌功夫"]=70
			JY.Person[0]["指法技巧"]=70
			JY.Person[0]["御剑能力"]=70
			JY.Person[0]["特殊兵器"]=70
			JY.Person[0]["耍刀技巧"]=70
			JY.Person[0]["暗器技巧"]=60
		end
		
			--袁承志
		if JY.Base["畅想"] == 54 then
			JY.Person[0]["暗器3"]=100
            JY.Person[0]["暗器技巧"]=JY.Person[0]["暗器技巧"]+40			
		end
		
		--何铁手
			--袁承志
		if JY.Base["畅想"] == 83 then
			JY.Person[0]["暗器2"]=100
            JY.Person[0]["暗器技巧"]=JY.Person[0]["暗器技巧"]+40			
		end
		
		
		--畅想杨过初始化
		if JY.Base["畅想"] == 58 then
			JY.Person[0]["攻击力"]=30
			JY.Person[0]["防御力"]=30
			JY.Person[0]["轻功"]=30
			JY.Person[0]["拳掌功夫"]=50
			JY.Person[0]["指法技巧"]=30
			JY.Person[0]["御剑能力"]=50
			JY.Person[0]["特殊兵器"]=10
			JY.Person[0]["武功1"]=42
			JY.Person[0]["武功等级1"]=999
			JY.Person[0]["武功2"]=95
			JY.Person[0]["武功等级2"]=900
			JY.Person[0]["武功3"]=0
			JY.Person[0]["武功等级3"]=0
			JY.Person[0]["武功4"]=0
			JY.Person[0]["武功等级4"]=0
			JY.Person[0]["天赋内功"]=95
			JY.Person[0]["天赋外功1"]=42
			JY.Person[0]["天赋外功2"]=0
			JY.Scene[18]["进入条件"] = 0
			JY.Scene[19]["进入条件"] = 1
			JY.Scene[101]["进入条件"] = 1
			JY.Scene[36]["进入条件"] = 1
			JY.Scene[28]["进入条件"] = 1
			JY.Scene[93]["进入条件"] = 1
			JY.Scene[105]["进入条件"] = 1
			null(18, 6)
			null(70, 87)
			addevent(70, 95, 0, 4188, 3, 0)
		end
		
		JY.Person[0]["资质"] = InputNum("输入资质",1,100);
		if JY.Person[0]["资质"] == 1 then
			JY.Person[670]["无用"] = 1
		elseif JY.Person[0]["资质"] == 100 then
			JY.Person[670]["无用"] = 2
        end

		ClsN()
	--张家辉
	elseif player_type == 3 then
		local clone_choice = 651
		
		JY.Base["特殊"] = 2
		
		JY.Person[0]["代号"]=JY.Person[clone_choice]["代号"]
		JY.Person[0]["头像代号"]=JY.Person[clone_choice]["头像代号"]
		JY.Person[0]["生命增长"]=JY.Person[clone_choice]["生命增长"]
		JY.Person[0]["无用"]=JY.Person[clone_choice]["无用"]
		JY.Person[0]["姓名"]=JY.Person[clone_choice]["姓名"]
		JY.Person[0]["外号"]=JY.Person[clone_choice]["外号"]
		JY.Person[0]["性别"]=JY.Person[clone_choice]["性别"]

		JY.Person[0]["武器"]=JY.Person[clone_choice]["武器"]
		JY.Person[0]["防具"]=JY.Person[clone_choice]["防具"]
		JY.Person[0]["动物"]=JY.Person[clone_choice]["动物"]

		for i=1,5 do
			JY.Person[0]["出招动画帧数" .. i]=JY.Person[clone_choice]["出招动画帧数" .. i]
			JY.Person[0]["出招动画延迟" .. i]=JY.Person[clone_choice]["出招动画延迟" .. i]
			JY.Person[0]["武功音效延迟" .. i]=JY.Person[clone_choice]["武功音效延迟" .. i]
		end
		
		--畅想攻防轻最低25
		JY.Person[0]["攻击力"]=limitX(JY.Person[clone_choice]["攻击力"]/4,25)
		JY.Person[0]["防御力"]=limitX(JY.Person[clone_choice]["防御力"]/4,25)
		JY.Person[0]["轻功"]=limitX(JY.Person[clone_choice]["轻功"]/4,25)
		--医疗用毒解毒最低30
		JY.Person[0]["医疗能力"]=limitX(JY.Person[clone_choice]["医疗能力"],30)
		JY.Person[0]["用毒能力"]=limitX(JY.Person[clone_choice]["用毒能力"],30)
		JY.Person[0]["解毒能力"]=limitX(JY.Person[clone_choice]["解毒能力"],30)

		JY.Person[0]["抗毒能力"]=JY.Person[clone_choice]["抗毒能力"]
		JY.Person[0]["拳掌功夫"]=JY.Person[clone_choice]["拳掌功夫"]
		JY.Person[0]["指法技巧"]=JY.Person[clone_choice]["指法技巧"]
		JY.Person[0]["御剑能力"]=JY.Person[clone_choice]["御剑能力"]
		JY.Person[0]["耍刀技巧"]=JY.Person[clone_choice]["耍刀技巧"]
		JY.Person[0]["特殊兵器"]=JY.Person[clone_choice]["特殊兵器"]
		--暗器技巧至少30
		JY.Person[0]["暗器技巧"]=limitX(JY.Person[clone_choice]["暗器技巧"],30)

		JY.Person[0]["武学常识"]=JY.Person[clone_choice]["武学常识"]
		JY.Person[0]["攻击带毒"]=JY.Person[clone_choice]["攻击带毒"]
		JY.Person[0]["左右互搏"]=JY.Person[clone_choice]["左右互搏"]
	
		for i=1,JY.Person[671]["品德"] do
			JY.Person[0]["武功" .. i]=JY.Person[clone_choice]["武功" .. i]
			JY.Person[0]["武功等级" .. i]=JY.Person[clone_choice]["武功等级" .. i]
		end

		for i=1,4 do
			JY.Person[0]["携带物品" .. i]=JY.Person[clone_choice]["携带物品" .. i]
			JY.Person[0]["携带物品数量" .. i]=JY.Person[clone_choice]["携带物品数量" .. i]
		end
		
		for i=1,4 do
			JY.Person[0]["天赋外功"..i]=JY.Person[clone_choice]["天赋外功"..i]
		end
		
		JY.Person[0]["天赋内功"]=JY.Person[clone_choice]["天赋内功"]
		JY.Person[0]["天赋轻功"]=JY.Person[clone_choice]["天赋轻功"]
		JY.Person[0]["畅想分阶"]=JY.Person[clone_choice]["畅想分阶"]
		JY.Person[0]["外号2"]=JY.Person[clone_choice]["外号2"]
		JY.Person[0]["特色指令"] = JY.Person[clone_choice]["特色指令"]
		
		JY.Person[0]["资质"] = InputNum("输入资质",1,100)
		if JY.Person[0]["资质"] == 1 then
			JY.Person[670]["无用"] = 1
		elseif JY.Person[0]["资质"] == 100 then
			JY.Person[670]["无用"] = 2
        end

		ClsN()
		elseif player_type == 4 then
		
		JY.Base["畅想"] = 689
			JY.Person[0]["攻击力"]=50
			JY.Person[0]["防御力"]=50
			JY.Person[0]["轻功"]=50
			JY.Person[0]["拳掌功夫"]=0
			JY.Person[0]["指法技巧"]=0
			JY.Person[0]["御剑能力"]=0
			JY.Person[0]["特殊兵器"]=0
			JY.Person[0]["耍刀技巧"]=0
			JY.Person[0]["暗器技巧"]=0
			JY.Person[0]["医疗能力"]=0
			JY.Person[0]["解毒能力"]=0
			JY.Person[0]["用毒能力"]=0
			
			JY.Person[0]["代号"]=JY.Person[689]["代号"]
		JY.Person[0]["头像代号"]=JY.Person[689]["头像代号"]
		JY.Person[0]["生命增长"]=JY.Person[689]["生命增长"]
		JY.Person[0]["无用"]=JY.Person[689]["无用"]
		JY.Person[0]["姓名"]=JY.Person[689]["姓名"]
		JY.Person[0]["外号"]=JY.Person[689]["外号"]
		JY.Person[0]["性别"]=JY.Person[689]["性别"]

		JY.Person[0]["武器"]=JY.Person[689]["武器"]
		JY.Person[0]["防具"]=JY.Person[689]["防具"]
		JY.Person[0]["动物"]=JY.Person[689]["动物"]

		for i=1,5 do
			JY.Person[0]["出招动画帧数" .. i]=JY.Person[689]["出招动画帧数" .. i]
			JY.Person[0]["出招动画延迟" .. i]=JY.Person[689]["出招动画延迟" .. i]
			JY.Person[0]["武功音效延迟" .. i]=JY.Person[689]["武功音效延迟" .. i]
		end
		
		for i=1,JY.Person[671]["品德"] do
			JY.Person[0]["武功" .. i]=JY.Person[689]["武功" .. i]
			JY.Person[0]["武功等级" .. i]=JY.Person[689]["武功等级" .. i]
		end
		
		JY.Person[0]["资质"] = InputNum("输入资质",1,100)
		if JY.Person[0]["资质"] == 1 then
			JY.Person[670]["无用"] = 1
		elseif JY.Person[0]["资质"] == 100 then
			JY.Person[670]["无用"] = 2
        end
		ClsN()
        local nl = JYMsgBox("请选择", "初始元素*冰：时序回复2生命，每级回复量提高60%*雷：每级提高10%集气速度和5点法力回复  *火：每级提高10%+100武功威力", {"冰", "雷", "火"}, 3, 414)
		if nl > 0 then
		   JY.Person[689]["天"..nl] = 1
		end
		ClsN()
	end
	if JY.Person[123]["天2"] == 1 then
	JY.Person[0]["拳掌功夫"]=JY.Person[0]["拳掌功夫"] + 20
	JY.Person[0]["指法技巧"]=JY.Person[0]["指法技巧"] + 20
	JY.Person[0]["御剑能力"]=JY.Person[0]["御剑能力"] + 20
	JY.Person[0]["特殊兵器"]=JY.Person[0]["特殊兵器"] + 20
	JY.Person[0]["耍刀技巧"]=JY.Person[0]["耍刀技巧"] + 20
	end
	
	if existFile(CC.Acvmts) then
       dofile(CC.Acvmts)
	   if Achievements.pChar[1000] ~= nil then
	     if JY.Base["畅想"] > 0 then
		       local menu = {{"无                                                         ", nil, 1}}
			   if Tier[JY.Base["畅想"]] ~= nil then
			       for i = 2, 4 do  
			       menu[i] = {Number[i-1].."阶："..Tier[JY.Base["畅想"]][i-1],nil,1}
				   end
				   
			   else
				     menu[2] = {"武学常识提高30，生命上限提高10%", nil, 1}
				     menu[3] = {"武学常识提高30，内力上限提高10%", nil, 1}
				     menu[4] = {"伤害提高10%，受到的伤害减少10%", nil, 1}
			   end
			         
			   for i = 2, 4 do
			   if Achievements.rdsCpltd[JY.Base["畅想"]].n + 1 < i then
			       menu[i][3] = 3
			   end	   
			   end
			   local nexty = CC.ScreenH/4-CC.DefaultFont*4 + CC.SingleLineHeight
	           local r = ShowMenu2(menu, #menu, 1, 4, CC.ScreenW/2-CC.DefaultFont*13-60, nexty, 0, 0, 1, 0, CC.DefaultFont, C_ORANGE, C_WHITE,"选择"..JY.Person[JY.Base["畅想"]]["姓名"].."觉醒阶级")
			   JY.Person[JY.Base["畅想"]]["阶"] = r - 1
		 end
		    if JY.Base["标准"] > 0 then
			   local menu = {{"无                                                         ", nil, 1}}--{kfname,nil,2}
			   for i = 2, 4 do
			       menu[i] = {Number[i-1].."阶："..Tier[999+JY.Base["标准"]][i-1],nil,1}
			   end
			   for i = 2, 4 do
			   if Achievements.pChar[999][JY.Base["标准"]] + 1 < i then
			       menu[i][3] = 3
			   end	   
			   end
			   local nexty = CC.ScreenH/4-CC.DefaultFont*4 + CC.SingleLineHeight
	           local r = ShowMenu2(menu, #menu, 1, 4, CC.ScreenW/2-CC.DefaultFont*13-60, nexty, 0, 0, 1, 0, CC.DefaultFont, C_ORANGE, C_WHITE,"选择主角觉醒阶级")
			   JY.Person[0]["阶"] = r - 1
		   -- end
			end

	---------------
	     if Achievements.pChar[1000].CharAw1 == 1 then
		    instruct_2(361, 1)
	        JY.Person[0]["专1"] = 999
	     end
		 if Achievements.pChar[1000].CharAw2 == 1 then
	        JY.Person[0]["专2"] = 999
	     end
		 if Achievements.pChar[1000].CharAw3 == 1 then
			instruct_2(359, 6)
			JY.Person[0]["专1"] = 999
			JY.Person[0]["专2"] = 999
	     end
		 ClsN()
		 if Achievements.pChar[1000].CharAw4 > 0 then
			local x,y = Achievements.pChar[1000].CharAw4, Achievements.pChar[1000].CharAw5
			local nl = JYMsgBox("请选择", "是否增加随机性难度？*选择是，随游戏进程，敌人有概率获得随机天赋。", {"是", "否"}, 2)
			if nl == 1 then
			JY.Person[126]["声望"] = 100
			end
			JY.Person[0]["地"..x] = y
			      if x == 1 and y == 5 then
				     AddPersonAttrib(0, "暗器技巧", 100)
					 DrawStrBoxWaitKey(JY.Person[0]["姓名"].."暗器提升100点", LimeGreen, 36,nil, C_GOLD)
				  end
				  if x == 3 and y == 1 then
				     AddPersonAttrib(0, "拳掌功夫", 30)
	                 AddPersonAttrib(0, "指法技巧", 30)
	                 AddPersonAttrib(0, "御剑能力", 30)
	                 AddPersonAttrib(0, "耍刀技巧", 30)
	                 AddPersonAttrib(0, "特殊兵器", 30)
					 DrawStrBoxWaitKey(JY.Person[0]["姓名"].."兵器值提高", LimeGreen, 36,nil, C_GOLD)
				  end
				  if x == 9 and y == 2 then
				  local str = {"拳掌功夫","指法技巧","御剑能力","耍刀技巧","特殊兵器","攻击力","防御力","轻功","暗器技巧","武学常识","攻击带毒","医疗能力","用毒能力","解毒能力","抗毒能力","生命最大值","内力最大值"}
				     for a = 1, #str do
					     AddPersonAttrib(0, str[a], 9999)
					 end	 
					 DrawStrBoxWaitKey(JY.Person[0]["姓名"].."属性全满", LimeGreen, 36,nil, C_GOLD)
				  end
				  if x == 6 then
				     if y == 1 then
					    JY.Person[0]["出战"] = 1
					 elseif y == 2 then	
					    JY.Person[0]["左右互搏"] = 1
					 end
				  end
	     end
		 Achievements.pChar[1000].CharAw1 = 0
		 Achievements.pChar[1000].CharAw2 = 0
		 Achievements.pChar[1000].CharAw3 = 0
		 Achievements.pChar[1000].CharAw4 = 0
		 Achievements.pChar[1000].CharAw5 = 0
		 
	     SaveTable(Achievements)
	   end
	end
	ClsN() 
	--选择内力性质
	if JY.Base["畅想"] ~= 689 then
	local nl = JYMsgBox("请选择", "想要哪种属性的内力", {"阴性", "阳性", "调和"}, 3, 261)
	if nl == 1 then
		JY.Person[0]["内力性质"] = -1
		if JY.Base["标准"] == 6 then
			JY.Person[0]["天赋内功"] = 107
		end	
	elseif nl == 2 then
		JY.Person[0]["内力性质"] = 1
		if JY.Base["标准"] == 6 then
			JY.Person[0]["天赋内功"] = 106
		end
	elseif nl == 3 then
		JY.Person[0]["内力性质"] = 0
        if JY.Base["标准"] == 6 then
			JY.Person[0]["天赋内功"] = 108
		end		
	end
	end
	
	ClsN()
	
	if JY.Base["畅想"] == 653 then
	JY.Base["单通"] = 1
	else
	--是否开启单通模式
	local nl = JYMsgBox("请选择游戏模式", "注意：如果选择了单通模式*则游戏中的全部战斗*都只能使用主角一人单独完成！*☆新手玩家建议选择普通模式*", {"普通模式", "单通模式"}, 2, 76)
	if nl == 2 then
		JY.Base["单通"] = 1
	end
	end
	
	ClsN()
	if JY.Base["畅想"] == 650 then
	local nl = JYMsgBox("请选择", "小王爷的杨家枪是否需要爆炸特效", {"普通模式", "华丽模式"}, 2)
	if nl == 2 then
		JY.Person[650]["天1"] = 1
	end
	
	ClsN()
	end
	if JY.Base["畅想"] == 694 and JY.Person[694]["阶"] >= 3 then
	local nl = JYMsgBox("请选择", "张角的造型", {"朴素", "花哨"}, 2)
	if nl == 2 then
		JY.Person[0]["头像代号"] = 421
				local f_ani = {
				{0, 0, 0}, 
				{25, 16, 16}, 
				{25, 15, 15}, 
				{0, 0, 0}, 
				{0, 0, 0}}
				for i = 1, 5 do
					JY.Person[0]["出招动画帧数" .. i] = f_ani[i][1]
					JY.Person[0]["出招动画延迟" .. i] = f_ani[i][3]
					JY.Person[0]["武功音效延迟" .. i] = f_ani[i][2]
				end
	end
	ClsN()
	end
	
	ShowScreen()
	
	--其他人物初始化
	for p = 0, JY.PersonNum-1 do
		local r = 0
		for i,v in pairs(CC.PersonExit) do
			if v[1] == p then
				r = 1
			end
		end
		if p == 0 then
			r = 1
		end
		
		--敌方的初始化
		if r == 0 then
			for i = 1, JY.Person[671]["品德"] do
				if JY.Person[p]["武功" .. i] > 0 then
					if p < 191 then
						--JY.Person[p]["武功等级" .. i] = 999    --BOSS武功是为极
					else
						--不到10级的加到10级
						if JY.Person[p]["武功等级" .. i] < 900 then
							JY.Person[p]["武功等级" .. i] = 900
						end
					end
				else
					break;
				end
			end
			
			if JY.Person[p]["天赋内功"] <1 then
				JY.Person[p]["天赋内功"]=190
			end
			
			if JY.Person[p]["天赋轻功"] <1 then
				JY.Person[p]["天赋轻功"]=191
			end
		
			--生命不足200的加到200
			if JY.Person[p]["生命最大值"] < 200 then
				JY.Person[p]["生命最大值"] = 200
			end
			
			--内力不足200的加到200
			if JY.Person[p]["内力最大值"] < 200 then
				JY.Person[p]["内力最大值"] = 200
			end
			
			if JY.Person[p]["生命最大值"] == 999 then
				JY.Person[p]["生命最大值"] = 1000 
			end
			
			--血量再次设定
			JY.Person[p]["生命最大值"] = JY.Person[p]["生命最大值"] * 4
			
			--李秋水的无相分身为1血
			if p == 600 then
				JY.Person[p]["生命最大值"] = 1
			--谢无悠 027 9999血
			elseif p == 596 or p == 666 then
				JY.Person[p]["生命最大值"] = 9999
			--weyl7777血
			elseif p == 667 then
				JY.Person[p]["生命最大值"] = 7777
			--苍天泰坦32767血内
			elseif p == 668 then
				JY.Person[p]["生命最大值"] = 32767
				JY.Person[p]["内力最大值"] = 32767
			end
			
	        JY.Person[p]["生命最大值"] = JY.Person[p]["生命最大值"]*(1+JY.Person[123]["天1"]*0.15)
			JY.Person[p]["内力最大值"] = JY.Person[p]["内力最大值"]*(1+JY.Person[123]["天1"]*0.15)
			
			JY.Person[p]["生命"] = JY.Person[p]["生命最大值"]
			JY.Person[p]["内力"] = JY.Person[p]["内力最大值"]
			
			--每周目敌方武常+20
			JY.Person[p]["武学常识"] = JY.Person[p]["武学常识"] + (JY.Base["周目"] -1)*10
		end
	end
	if JY.Base["难度"] >= 7 or JY.Base["难度"] == 1 then
	   instruct_2(174, 3000)
	end
	ClsN()
	if JY.Base["难度"] == 1 then
	JY.Person[0]["感悟"] = JY.Person[0]["感悟"] + 600   
	end
	JY.Person[0]["感悟"] = JY.Person[0]["感悟"] + JY.Base["难度"]*20
	   if JY.Base["标准"] > 0 then
	      JY.Person[0]["感悟"] = JY.Person[0]["感悟"] + 200
	     if JY.Base["标准"] == 7 or JY.Base["标准"] == 8 then
	      JY.Person[0]["感悟"] = JY.Person[0]["感悟"] + 100
	     end
	   end
	   if JY.Base["畅想"] > 0 then
	      if JY.Person[JY.Base["畅想"]]["畅想分阶"] == 1 or JY.Base["畅想"] == 673 then
		     JY.Person[0]["感悟"] = JY.Person[0]["感悟"] + 300 + JY.Base["难度"]*20
		  elseif JY.Person[JY.Base["畅想"]]["畅想分阶"] == 2 then
		     JY.Person[0]["感悟"] = JY.Person[0]["感悟"] + 100	 
	      end
	   end
	--enm	
	for i = 1, 692 do
	    if is_inc(i, NAN3) then
		   JY.Person[i]["感悟"] = JY.Person[i]["感悟"] + 500
		elseif is_inc(i, NAN2) then
		   JY.Person[i]["感悟"] = JY.Person[i]["感悟"] + 300
		elseif is_inc(i, NAN1) then
		   JY.Person[i]["感悟"] = JY.Person[i]["感悟"] + 100   
		end
	end
	
	if JY.Base["难度"] == 8 then
	   for i = 1, JY.Person[671]["品德"] do
	       JY.Person[642]["武功"..i] = 0
		   JY.Person[642]["武功等级"..i] = 999
	   end
	end
	ClsN()
	if JY.Base["特殊"] == 3 then
	   if JY.Person[92]["天1"] == 1 then
	   instruct_2(359, 12)
	   else
	   instruct_2(359, 6)
	   end
	end
	if JY.Base["畅想"] == 39 or JY.Base["畅想"] == 40 then
       instruct_2(333, 2)
    end
	if JY.Base["畅想"] == 634 then
       instruct_2(200, 1)
    end
	if JY.Base["畅想"] == 681 then
       instruct_2(360, 1)
    end
    if JY.Base["畅想"] == 684 then
       instruct_2(29, 99)
    end
    if JY.Base["畅想"] == 685 then
       instruct_2(363, 1)
    end	
	if JY.Base["畅想"] == 682 then
       instruct_2(362, 1)
    end
	if JY.Base["畅想"] == 687 then
       instruct_2(96, 1)
	   ClsN()
	   instruct_2(113, 1)
	   ClsN()
	   instruct_2(317, 1)
    end
	if JY.Base["畅想"] == 688 then
       instruct_2(344, 1)
    end
	
	--阶
	if JY.Person[1]["阶"] >= 2 then
	   JY.Person[0]["轻功"] = JY.Person[0]["轻功"] + 100
	end
	if JY.Person[67]["阶"] >= 2 then
	   JY.Person[0]["轻功"] = JY.Person[0]["轻功"] + 100
	end
	if JY.Person[2]["阶"] >= 1 then
	   JY.Person[0]["攻击带毒"] = JY.Person[0]["攻击带毒"] + 100
	end
	if JY.Person[10]["阶"] >= 1 then
	   JY.Person[0]["武学常识"] = JY.Person[0]["武学常识"] + 100
	   JY.Person[0]["拳掌功夫"] = JY.Person[0]["拳掌功夫"] + 50
		JY.Person[0]["指法技巧"]=JY.Person[0]["指法技巧"]+50
		JY.Person[0]["御剑能力"]=JY.Person[0]["御剑能力"]+50
		JY.Person[0]["特殊兵器"]=JY.Person[0]["特殊兵器"]+50
		JY.Person[0]["耍刀技巧"]=JY.Person[0]["耍刀技巧"]+50
	end
	if JY.Person[38]["阶"] >= 1 then
	   JY.Person[0]["拳掌功夫"] = JY.Person[0]["拳掌功夫"] + 150
		JY.Person[0]["指法技巧"]=JY.Person[0]["指法技巧"]+150
		JY.Person[0]["御剑能力"]=JY.Person[0]["御剑能力"]+150
		JY.Person[0]["特殊兵器"]=JY.Person[0]["特殊兵器"]+150
		JY.Person[0]["耍刀技巧"]=JY.Person[0]["耍刀技巧"]+150
	end
	if JY.Person[103]["阶"] >= 2 then
	   JY.Person[0]["拳掌功夫"] = JY.Person[0]["拳掌功夫"] + 100
		JY.Person[0]["指法技巧"]=JY.Person[0]["指法技巧"]+100
		JY.Person[0]["御剑能力"]=JY.Person[0]["御剑能力"]+100
		JY.Person[0]["特殊兵器"]=JY.Person[0]["特殊兵器"]+100
		JY.Person[0]["耍刀技巧"]=JY.Person[0]["耍刀技巧"]+100
	end
	if JY.Person[112]["阶"] >= 2 then
	   JY.Person[0]["拳掌功夫"] = JY.Person[0]["拳掌功夫"] + 100
		JY.Person[0]["指法技巧"]=JY.Person[0]["指法技巧"]+100
		JY.Person[0]["御剑能力"]=JY.Person[0]["御剑能力"]+100
		JY.Person[0]["特殊兵器"]=JY.Person[0]["特殊兵器"]+100
		JY.Person[0]["耍刀技巧"]=JY.Person[0]["耍刀技巧"]+100
	end
	if JY.Person[51]["阶"] >= 1 then
	   JY.Person[0]["武学常识"] = JY.Person[0]["武学常识"] + 50
	   JY.Person[0]["拳掌功夫"] = JY.Person[0]["拳掌功夫"] + 100
		JY.Person[0]["指法技巧"]=JY.Person[0]["指法技巧"]+100
		JY.Person[0]["御剑能力"]=JY.Person[0]["御剑能力"]+100
		JY.Person[0]["特殊兵器"]=JY.Person[0]["特殊兵器"]+100
		JY.Person[0]["耍刀技巧"]=JY.Person[0]["耍刀技巧"]+100
	end
	if JY.Person[113]["阶"] >= 3 then
	   JY.Person[0]["武学常识"] = JY.Person[0]["武学常识"] + 200
	end
	if JY.Person[130]["阶"] >= 2 then
	   JY.Person[0]["攻击带毒"] = JY.Person[0]["攻击带毒"] + 100
	end
	if JY.Person[52]["阶"] >= 3 then
	   JY.Person[0]["天赋外功2"] = 241
	end
	if JY.Person[153]["阶"] >= 1 then
	   JY.Person[0]["暗器技巧"] = JY.Person[0]["暗器技巧"] + 80*JY.Person[153]["阶"]
	end
	if JY.Person[0]["阶"] >= 1 and JY.Base["标准"] == 4 then
		JY.Person[0]["耍刀技巧"]=JY.Person[0]["耍刀技巧"]+100
	end
	if JY.Person[JY.Base["畅想"]]["阶"] >= 1 and JY.Base["畅想"] > 0 and Tier[JY.Base["畅想"]] == nil then
		JY.Person[0]["武学常识"] = JY.Person[0]["武学常识"] + 30
		if JY.Person[JY.Base["畅想"]]["阶"] >= 2 then
		JY.Person[0]["武学常识"] = JY.Person[0]["武学常识"] + 30
	    end
	end
	if JY.Person[670]["阶"] >= 1 then
	   JY.Person[0]["拳掌功夫"] = JY.Person[0]["拳掌功夫"] + 50*JY.Person[670]["阶"]
		JY.Person[0]["指法技巧"]=JY.Person[0]["指法技巧"]+50*JY.Person[670]["阶"]
		JY.Person[0]["御剑能力"]=JY.Person[0]["御剑能力"]+50*JY.Person[670]["阶"]
		JY.Person[0]["特殊兵器"]=JY.Person[0]["特殊兵器"]+50*JY.Person[670]["阶"]
		JY.Person[0]["耍刀技巧"]=JY.Person[0]["耍刀技巧"]+50*JY.Person[670]["阶"]
	end
	if JY.Person[677]["阶"] >= 1 then
	   JY.Person[246]["品德"] = 100
	end
	if JY.Person[673]["阶"] >= 3 then
	   JY.Person[0]["拳掌功夫"] = JY.Person[0]["拳掌功夫"] + 300
	end
	if JY.Person[689]["阶"] >= 1 then
	   JY.Person[689]["天1"] = JY.Person[689]["天1"] + 1
	   JY.Person[689]["天2"] = JY.Person[689]["天2"] + 1
	   JY.Person[689]["天3"] = JY.Person[689]["天3"] + 1
	   if JY.Person[689]["阶"] >= 2 then
	   JY.Person[689]["天1"] = JY.Person[689]["天1"] + 1
	   JY.Person[689]["天2"] = JY.Person[689]["天2"] + 1
	   JY.Person[689]["天3"] = JY.Person[689]["天3"] + 1
	   end
	   if JY.Person[689]["阶"] >= 3 then
	   JY.Person[689]["天1"] = JY.Person[689]["天1"] + 2
	   JY.Person[689]["天2"] = JY.Person[689]["天2"] + 2
	   JY.Person[689]["天3"] = JY.Person[689]["天3"] + 2
	   local nl = JYMsgBox("请选择", "元素等级+1*冰：时序回复2生命，每级回复量提高60%*雷：每级提高10%集气速度和5点法力回复  *火：每级提高10%+100武功威力", {"冰", "雷", "火"}, 3, 414)
		if nl > 0 then
		   JY.Person[689]["天"..nl] = JY.Person[689]["天"..nl] + 1
		end
		ClsN()
	   end
	end
	--无酒不欢：增加一些初始化设定
	
	--华山后山谢无悠
	instruct_3(80, 17, 1, 0, 4105, 0, 0, 4133*2, 4133*2, 4133*2, 0, -2, -2)
	
	--鸠摩智贴图
	instruct_3(16, 10, -2,-2,-2,-2,-2,4153*2,4153*2,4153*2,-2,-2,-2)
	
	--李文秀贴图
	instruct_3(62,4,0,0,0,0,0,9238,9238,9238,0,0,0);
	
	if JY.Base["畅想"] == 692 then
	   addevent(62, 17, 1, 4296, 1, 3132*2, 27, 14)
	end
    
end

--无酒不欢：机率判定函数
function JLSD(s1, s2, dw)
	local s = math.random(100)
	local chance_up = 0;
	--论剑打赢阿凡提奖励，几率+6
	--[[
	if dw == 0 and JY.Person[606]["论剑奖励"] == 1 then
		chance_up = 3
	end]]
	if Curr_NG(dw,102) then
		chance_up = chance_up+5	
	end	
	--如果不在队伍中，几率+20
	if inteam(dw) == false then
		chance_up = chance_up+10
	end
	if inteam(dw) == true and JY.Person[642]["血量翻倍"] == 1 then
		chance_up = chance_up+10
	end
	if dw == 0 and JY.Person[0]["天1"] == 4 then
		chance_up = chance_up+7
	end
	if JY.Person[dw]["人21"] == 1 then
	   chance_up = chance_up+2
	end
	if JY.Person[601]["阶"] >= 1 and match_ID(dw, 601) then
	   chance_up = chance_up+10
	end
	--判定是否成功
	if s1 - chance_up < s and s <= s2 + chance_up then
		return true
	else
		return false
	end
end

--游戏主循环
function Game_Cycle()
    lib.Debug("Start game cycle");

    while JY.Status ~=GAME_END and JY.Status ~=GAME_START do
		if JY.Restart == 1 then
			break
		end
        local t1=lib.GetTime();

	    JY.Mytick=JY.Mytick+1;    --20个节拍无击键，则主角变为站立状态
		if JY.Mytick%20==0 then
            JY.MyCurrentPic=0;
		end

        if JY.Mytick%1000==0 then
            JY.MYtick=0;
        end

        if JY.Status==GAME_FIRSTMMAP then  --首次显示主场景，重新调用主场景贴图，渐变显示。然后转到正常显示
			CleanMemory()
			lib.ShowSlow(20, 1)
			JY.MmapMusic = 57
			JY.Status = GAME_MMAP
			Init_MMap()
			lib.DrawMMap(JY.Base["人X"], JY.Base["人Y"], GetMyPic())
			lib.ShowSlow(20, 0)
        elseif JY.Status==GAME_MMAP then
            Game_MMap();
 		elseif JY.Status==GAME_SMAP then
            Game_SMap();
		end
		collectgarbage("step", 0)
        local t2=lib.GetTime();
	    if t2-t1<CC.Frame then
            lib.Delay(CC.Frame-(t2-t1));
	    end
	end
end

function Game_MMap()      --主地图
	if JY.Restart == 1 then
		return
	end

    local direct = -1;
    local keypress, ktype, mx, my = lib.GetKey();
	--先检测跟上次不同的方向是否被按下
    for i = VK_RIGHT,VK_UP do
        if i ~= CC.PrevKeypress and lib.GetKeyState(i) ~=0 then
			keypress = i
		end
	end 
    --如果与上次不同的方向未被按下，则检测与上次相同的方向是否被按下
	if keypress==-1 and	lib.GetKeyState(CC.PrevKeypress) ~=0 then
		keypress = CC.PrevKeypress
	end
    CC.PrevKeypress = keypress
    if keypress==VK_UP then
		direct=0;
		JY.WalkCount = JY.WalkCount + 1
	elseif keypress==VK_DOWN then
		direct=3;
		JY.WalkCount = JY.WalkCount + 1
	elseif keypress==VK_LEFT then
		direct=2;
		JY.WalkCount = JY.WalkCount + 1
	elseif keypress==VK_RIGHT then
		direct=1;
		JY.WalkCount = JY.WalkCount + 1
	else
		JY.WalkCount = 0
	end
    
    if ktype == 1 then
	    JY.Mytick=0;
		if keypress==VK_ESCAPE then
			Cls()
			MMenu();
			if JY.Status ~= GAME_MMAP  then
				return ;
			end
		elseif keypress == VK_H then		--按h直接回家
			My_Enter_SubScene(70, 35, 31, 2);
			return;
		--无酒不欢：全套快捷键 7-30
		elseif keypress == VK_S then	--存档
			Menu_SaveRecord()
			if JY.Status ~= GAME_MMAP  then
				return ;
			end
		elseif keypress == VK_L then	--读档
			Menu_ReadRecord()
			if JY.Status ~= GAME_MMAP  then
				return ;
			end
		elseif keypress == VK_Z then	--状态
			Cls()
			Menu_Status()
		elseif keypress == VK_E then	--物品
			Cls()
			Menu_Thing()
		elseif keypress == VK_F1 then	--马车	
			Cls()
			My_ChuangSong_Ex()
			if JY.Status ~= GAME_MMAP then
				return;
			end
		elseif keypress == VK_F3 then	--队友排位
			Cls()
			Menu_TZDY()
		elseif keypress == VK_F4 then	--整理
			Cls()		
			Menu_WPZL()
		end
	elseif ktype == 2 or ktype == 3 then
		local tmpx,tmpy = mx, my
		mx = mx - CC.ScreenW / 2
		my = my - CC.ScreenH / 2
		mx = (mx) / CC.XScale
		my = (my) / CC.YScale
		mx, my = (mx + my) / 2, (my - mx) / 2
		if mx > 0 then
			mx = mx + 0.99
		else
			mx = mx - 0.01
		end
		if my > 0 then
			my = my + 0.99
		else
			mx = mx - 0.01
		end
		mx = math.modf(mx)+JY.Base["人X"];
		my = math.modf(my)+ JY.Base["人Y"]
				
		--鼠标移动
		if ktype == 2 then
			if lib.GetMMap(mx, my, 3) > 0 then				--如果有建筑，判断是否可进入
				for i=0, 4 do
		    		for j=0, 4 do
		    			local xx, yy = mx-i, my-j;
				    	local sid=CanEnterScene(xx,xx);
				    	if sid < 0 then
				    		xx, yy = mx+i, my+j;
				    		sid=CanEnterScene(xx,yy);
				    	end
						if sid>=0 then
							CC.MMapAdress[0] = sid;
							CC.MMapAdress[1] = tmpx;
							CC.MMapAdress[2] = tmpy;
							CC.MMapAdress[3] = xx;
							CC.MMapAdress[4] = yy;
		
							i=5;		--退出循环
							break;
						end
					end
				end
			else
				CC.MMapAdress[0]= nil;
			end
		--鼠标左键
		elseif ktype == 3 then
			if CC.MMapAdress[0] ~= nil then
				mx = CC.MMapAdress[3] - JY.Base["人X"];
				my = CC.MMapAdress[4] - JY.Base["人Y"];
				CC.MMapAdress[0]= nil;
			else
				AutoMoveTab = {[0] = 0}
				mx = mx - JY.Base["人X"]
				my = my - JY.Base["人Y"]
			end
			walkto(mx, my)
		end
	elseif ktype == 4 then
		JY.Mytick=0;
		Cls()
		MMenu();
		if JY.Status ~= GAME_MMAP then
			return ;
		end
	end
    
    if AutoMoveTab[0] ~= 0 then
	    if direct == -1 then
			direct = AutoMoveTab[AutoMoveTab[0]]
			AutoMoveTab[AutoMoveTab[0]] = nil
			AutoMoveTab[0] = AutoMoveTab[0] - 1
	    end
	else
	    AutoMoveTab = {[0] = 0}
	end


    local x,y;              --按照方向键要到达的坐标
	local CanMove = function(nd, nnd)
		local nx, ny = JY.Base["人X"] + CC.DirectX[nd + 1], JY.Base["人Y"] + CC.DirectY[nd + 1]
		if nnd ~= nil then
			nx, ny = nx + CC.DirectX[nnd + 1], ny + CC.DirectY[nnd + 1]
		end
		if CC.hx == nil and ((lib.GetMMap(nx, ny, 3) == 0 and lib.GetMMap(nx, ny, 4) == 0) or CanEnterScene(nx, ny) ~= -1) then
			return true
		else
			return false
		end
	end
    if direct ~= -1 then   --按下了光标键
        AddMyCurrentPic();         --增加主角贴图编号，产生走路效果
        x=JY.Base["人X"]+CC.DirectX[direct+1];
        y=JY.Base["人Y"]+CC.DirectY[direct+1];
        JY.Base["人方向"]=direct;
		if JY.WalkCount == 1 then
			lib.Delay(90)
		end
    else
        x=JY.Base["人X"];
        y=JY.Base["人Y"];

    end

	if direct~=-1 then
		JY.SubScene=CanEnterScene(x,y);   --判断是否进入子场景
	end

    if lib.GetMMap(x,y,3)==0 and lib.GetMMap(x,y,4)==0 then     --没有建筑，可以到达
        JY.Base["人X"]=x;
        JY.Base["人Y"]=y;
    end
    JY.Base["人X"]=limitX(JY.Base["人X"],10,CC.MWidth-10);           --限制坐标不能超出范围
    JY.Base["人Y"]=limitX(JY.Base["人Y"],10,CC.MHeight-10);

    if CC.MMapBoat[lib.GetMMap(JY.Base["人X"],JY.Base["人Y"],0)]==1 then
	    JY.Base["乘船"]=1;
	else
	    JY.Base["乘船"]=0;
	end

    lib.DrawMMap(JY.Base["人X"],JY.Base["人Y"],GetMyPic());             --绘画主地图

	--当前XY坐标显示
    if CC.ShowXY==1 then
	    DrawString(10,CC.ScreenH-60,string.format("%s %d %d","大地图",JY.Base["人X"],JY.Base["人Y"]) ,C_GOLD,CC.Fontsmall);
	end
	
	DrawTimer();		--最下方动态提示
	JYZTB();			--左上角简易信息
		
		
	--显示鼠标指中的场景名称
	if CC.MMapAdress[0] ~= nil then
		DrawStrBox(CC.MMapAdress[1]+10,CC.MMapAdress[2],JY.Scene[CC.MMapAdress[0]]["名称"],C_GOLD,CC.DefaultFont);
	end
		
    ShowScreen();

    if JY.SubScene >= 0 then          --进入子场景
		if JY.Base["畅想"] == 5 and JY.SubScene==43 then
		say("１Ｒ需要先通关黑山大会。", 119, 5, "车夫");
		return
		else	
        CleanMemory();
		lib.UnloadMMap();
        lib.PicInit();
        lib.ShowSlow(20,1)

		JY.Status=GAME_SMAP;
        JY.MmapMusic=-1;

        JY.MyPic=GetMyPic();
        JY.Base["人X1"]=JY.Scene[JY.SubScene]["入口X"]
        JY.Base["人Y1"]=JY.Scene[JY.SubScene]["入口Y"]

        Init_SMap(1);
		return
		end
    end
end

--主角走路
function walkto(xx,yy,x,y,flag)
	local x,y
	AutoMoveTab={[0]=0}
	if JY.Status==GAME_SMAP  then
		x=x or JY.Base["人X1"]
		y=y or JY.Base["人Y1"]
	elseif JY.Status==GAME_MMAP then
		x=x or JY.Base["人X"]
		y=y or JY.Base["人Y"]
	end
	xx,yy=xx+x,yy+y
	if JY.Status==GAME_SMAP then
		CC.AutoMoveEvent[0] = 0;
		CC.AutoMoveEvent[1] = 0;
		CC.AutoMoveEvent[2] = 0;

		if SceneCanPass(xx, yy) == false then
			if GetS(JY.SubScene, xx, yy, 3) > 0 and GetD(JY.SubScene, GetS(JY.SubScene, xx, yy, 3), 2) > 0 then
				CC.AutoMoveEvent[1] = xx;
				CC.AutoMoveEvent[2] = yy;
				--无酒不欢：一处蛋疼的细节修改，自动触发事件的站位优先级
				if x < xx then
					if SceneCanPass(xx-1,yy) then
						xx = xx-1;
					elseif SceneCanPass(xx,yy+1) then
						yy = yy+1;
					elseif SceneCanPass(xx,yy-1) then
						yy = yy-1;
					elseif SceneCanPass(xx+1,yy) then
						xx = xx+1;
					else
						return;
					end
				else
					if SceneCanPass(xx+1,yy) then
						xx = xx+1;
					elseif SceneCanPass(xx,yy+1) then
						yy = yy+1;
					elseif SceneCanPass(xx,yy-1) then
						yy = yy-1;
					elseif SceneCanPass(xx-1,yy) then
						xx = xx-1;
					else
						return;
					end
				end
			else
				return;
			end
		end

	end
	if JY.Status==GAME_MMAP and ((lib.GetMMap(xx,yy,3)==0 and lib.GetMMap(xx,yy,4)==0) or CanEnterScene(xx,yy)~=-1)==false then
		return
	end
	local steparray={};
	local stepmax;
	local xy={}
	if JY.Status==GAME_SMAP then
		for i=0,CC.SWidth-1 do
			xy[i]={}
		end
	elseif JY.Status==GAME_MMAP then
		for i=0,479 do
			xy[i]={}
		end
	end
	if flag~=nil then
		stepmax=640
	else
		stepmax=240
	end
	for i=0,stepmax do
	    steparray[i]={};
        steparray[i].x={};
        steparray[i].y={};
	end
	local function canpass(nx,ny)
		if JY.Status==GAME_SMAP and (nx>CC.SWidth-1 or ny>CC.SWidth-1 or nx<0 or ny<0) then
			return false
		end
		if JY.Status==GAME_MMAP and (nx>479 or ny>479 or nx<1 or ny<1) then
			return false
		end
		if xy[nx][ny]==nil then
			if JY.Status==GAME_SMAP then
				if  SceneCanPass(nx,ny) then
					return true
				end
			elseif JY.Status==GAME_MMAP then
				if (lib.GetMMap(nx,ny,3)==0 and lib.GetMMap(nx,ny,4)==0) or CanEnterScene(nx,ny)~=-1 then
					return true
				end
			end
		end
		return false
	end

	local function FindNextStep(step)
		if step==stepmax then
			return
		end
		local step1=step+1
		local num=0
		for i=1,steparray[step].num do

			if steparray[step].x[i]==xx and steparray[step].y[i]==yy then
				return
			end

			if canpass(steparray[step].x[i]+1,steparray[step].y[i]) then
				num=num+1
				steparray[step1].x[num]=steparray[step].x[i]+1
				steparray[step1].y[num]=steparray[step].y[i]
				xy[steparray[step1].x[num]][steparray[step1].y[num]]=step1
			end
			if canpass(steparray[step].x[i]-1,steparray[step].y[i]) then
				num=num+1
				steparray[step1].x[num]=steparray[step].x[i]-1
				steparray[step1].y[num]=steparray[step].y[i]
				xy[steparray[step1].x[num]][steparray[step1].y[num]]=step1
			end
			if canpass(steparray[step].x[i],steparray[step].y[i]+1) then
				num=num+1
				steparray[step1].x[num]=steparray[step].x[i]
				steparray[step1].y[num]=steparray[step].y[i]+1
				xy[steparray[step1].x[num]][steparray[step1].y[num]]=step1
			end
			if canpass(steparray[step].x[i],steparray[step].y[i]-1) then
				num=num+1
				steparray[step1].x[num]=steparray[step].x[i]
				steparray[step1].y[num]=steparray[step].y[i]-1
				xy[steparray[step1].x[num]][steparray[step1].y[num]]=step1
			end
		end
		if num>0 then
			steparray[step1].num=num
			FindNextStep(step1)
		end
	end

	steparray[0].num=1;
	steparray[0].x[1]=x;
	steparray[0].y[1]=y;
	xy[x][y]=0
	FindNextStep(0);

    local movenum=xy[xx][yy];

	if movenum==nil then
		return
	end
	AutoMoveTab[0]=movenum
	for i=movenum,1,-1 do
        if xy[xx-1][yy]==i-1 then
            xx=xx-1;
            AutoMoveTab[1+movenum-i]=1;
        elseif xy[xx+1][yy]==i-1 then
            xx=xx+1;
            AutoMoveTab[1+movenum-i]=2;
        elseif xy[xx][yy-1]==i-1 then
            yy=yy-1;
            AutoMoveTab[1+movenum-i]=3;
        elseif xy[xx][yy+1]==i-1 then
            yy=yy+1;
            AutoMoveTab[1+movenum-i]=0;
        end
	end
end

function GetMyPic()      --计算主角当前贴图
    local n;
	if JY.Status==GAME_MMAP and JY.Base["乘船"]==1 then
		if JY.MyCurrentPic >=4 then
			JY.MyCurrentPic=0
		end
	else
		if JY.MyCurrentPic >6 then
			JY.MyCurrentPic=1
		end
	end

	if JY.Base["乘船"]==0 then
		if JY.Person[0]["性别"] == 0 then
			n=CC.MyStartPicM+JY.Base["人方向"]*7+JY.MyCurrentPic;
		else
			n=CC.MyStartPicF+JY.Base["人方向"]*7+JY.MyCurrentPic;
		end
	else
	    n=CC.BoatStartPic+JY.Base["人方向"]*4+JY.MyCurrentPic;
	end
	return n;
end

--增加当前主角走路动画帧, 主地图和场景地图都使用
function AddMyCurrentPic()
    JY.MyCurrentPic=JY.MyCurrentPic+1;
end

--场景是否可进
--id 场景代号
--x,y 当前主地图坐标
--返回：场景id，-1表示没有场景可进
function CanEnterScene(x,y)         --场景是否可进
    for id = 0,JY.SceneNum-1 do
		local scene=JY.Scene[id];
		if (x==scene["外景入口X1"] and y==scene["外景入口Y1"]) or
		   (x==scene["外景入口X2"] and y==scene["外景入口Y2"]) then
			local e=scene["进入条件"];
			if e==0 then        --可进
				return id;
			elseif e==1 then    --不可进
				return -1
			end
		end
	end
    return -1;
end

--主菜单
function MMenu()
    local menu={{"队伍",Menu_Teaminfo,1},
	            {"物品",Menu_Thing,1},
				{"医疗",Menu_Doctor,1},
	            {"解毒",Menu_DecPoison,1},
	            {"离队",Menu_PersonExit,1},
	            {"系统",Menu_System,1}
				};

    ShowMenu(menu,6,0,CC.MainMenuX,CC.MainMenuY,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE)
end

--系统子菜单
function Menu_System()
	local menu = {
	{"读取进度", Menu_ReadRecord, 1}, 
	{"保存进度", Menu_SaveRecord, 1}, 
	{"关闭音乐", Menu_SetMusic, 1}, 
	{"关闭音效", Menu_SetSound, 1}, 
	{"关闭对话", Menu_SetSay, 1},
	
	{"战斗显示", Menu_SetXS, 1},
	{"物品整理", Menu_WPZL, 1}, 
	--{"系统攻略", Menu_Help, 1},
	{"通关记录", pastReview, 1},
	{"我的代码", Menu_MYDIY, 1},
	{"离开游戏", Menu_Exit2, 1}
	}
	if JY.EnableMusic == 0 then
		menu[3][1] = "打开音乐"
	end
	if JY.EnableSound == 0 then
		menu[4][1] = "打开音效"
	end
	if JY.EnableSay == 0 then
		menu[5][1] = "开启对话"
	end
	local r = ShowMenu(menu, #menu, 0, CC.MainSubMenuX, CC.MainSubMenuY, 0, 0, 1, 1, CC.DefaultFont, C_ORANGE, C_WHITE)
	if r == 0 then
		return 0
	elseif r < 0 then
		return 1
	end
end

function Menu_MYDIY()
	local r = JYMsgBox("我的代码","执行自定义代码*指定在script/DIY.lua文件",{"确定","取消"},2,nil,1);
	if r == 1 then
		dofile(CONFIG.ScriptPath.."DIY.lua");
	end
end

function Menu_Help()
	--暂时取消
	--[[
	local title = "系统攻略";
	local str ="装备说明：查看各种装备的说明。"
						.."*武功说明：查看各种武功的说明。"
						.."*天书攻略：各种天书的拿法，以及游戏技攻略。"
	local btn = {"装备说明","武功说明","天书攻略"};
	local num = #btn;
	local r = JYMsgBox(title,str,btn,num,nil,1);

	if r == 1 then
		ZBInstruce();
	elseif r == 2 then
		WuGongIntruce();
	elseif r == 3 then
		TSInstruce();
	end]]
	return 1;
end

--音乐开关
function Menu_SetMusic()
	if JY.EnableMusic == 0 then
		JY.EnableMusic = 1
		PlayMIDI(JY.CurrentMIDI)
	else
		JY.EnableMusic = 0
		lib.PlayMIDI("")
	end
	return 1
end

--音效开关
function Menu_SetSound()
	if JY.EnableSound == 0 then
		JY.EnableSound = 1
	else
		JY.EnableSound = 0
	end
	return 1
end

--对话开关
function Menu_SetSay()
	if JY.EnableSay== 0 then
		JY.EnableSay = 1
	else
		JY.EnableSay = 0
	end
	return 1
end


function Menu_SetXS()
	local menu2 = {
	{"内力隐藏", Menu_SetNL, 1},{"怒气隐藏", Menu_SetNQ, 1}
	}
	if JY.Person[125]["天1"] == 1 then
		menu2[1][1] = "内力显示"
	end
	if JY.Person[125]["天2"] == 1 then
		menu2[2][1] = "怒气显示"
	end
	   local s = ShowMenu(menu2, #menu2, 0, CC.MainSubMenuX+135, CC.MainSubMenuY, 0, 0, 1, 1, CC.DefaultFont, C_ORANGE, C_WHITE)
	return 1
end

function Menu_SetNL()
	if JY.Person[125]["天1"] == 0 then
		JY.Person[125]["天1"] = 1
	else
		JY.Person[125]["天1"] = 0
	end
	return 1
end

function Menu_SetNQ()
	if JY.Person[125]["天2"] == 0 then
		JY.Person[125]["天2"] = 1
	else
		JY.Person[125]["天2"] = 0
	end
	return 1
end

--队伍菜单
function Menu_Teaminfo()
    local m = 2
	local menu = {
		{"状态查看", Menu_Status, 1}, 
		{"队伍排序", Menu_TZDY, 1},
		}
		if GetTeamNum() > 1 then
		   menu[m+1]={"队友切磋", Menu_DYQC, 1}
		   m = m + 1
		end
		if JY.Base["畅想"] == 685 and JY.Person[685]["天3"] == 0 then
		   menu[m+1]={"炼化角色", Menu_LHDY, 1}
		   m = m + 1
		end
	
	ShowMenu(menu, m, 0, CC.MainSubMenuX, CC.MainSubMenuY, 0, 0, 1, 1, CC.DefaultFont, C_ORANGE, C_WHITE)
end

--物品菜单
function Menu_Thing()
	local menu = {
	{"全部物品", nil, 1}, 
	{"剧情物品", nil, 1}, 
	{"神兵宝甲", nil, 1}, 
	{"武功秘笈", nil, 1}, 
	{"灵丹妙药", nil, 1}, 
	{"伤人暗器", nil, 1}}
	local r = ShowMenu(menu, 6, 0, CC.MainSubMenuX, CC.MainSubMenuY, 0, 0, 1, 1, CC.DefaultFont, C_ORANGE, C_WHITE)
	if r > 0 then
		local thing = {}
		local thingnum = {}
		for i = 0, CC.MyThingNum - 1 do
			thing[i] = -1
			thingnum[i] = 0
		end
		local num = 0
		for i = 0, CC.MyThingNum - 1 do
			local id = JY.Base["物品" .. i + 1]
			if id >= 0 then
				if r == 1 then
					thing[i] = id
					thingnum[i] = JY.Base["物品数量" .. i + 1]
				else
					if JY.Thing[id]["类型"] == r - 2 then
						thing[num] = id
						thingnum[num] = JY.Base["物品数量" .. i + 1]
						num = num + 1
					end
				end
			end 
		end
		--无酒不欢：秘笈显示区分
		if r == 4 then
			IsViewingKungfuScrolls = 1
		end
		local r = SelectThing(thing, thingnum)
		if r >= 0 then
			UseThing(r)
			return 1
		end
	end
	return 0
end

--物品整理
function Menu_WPZL()
	local function swap(a, b) 
		JY.Base["物品" .. a], JY.Base["物品" .. b] = JY.Base["物品" .. b], JY.Base["物品" .. a]
		JY.Base["物品数量" .. a], JY.Base["物品数量" .. b] = JY.Base["物品数量" .. b], JY.Base["物品数量" .. a]
	end
	
	local flag = 0;
	for i=1, CC.MyThingNum do
        flag = 0;
        for j=1, CC.MyThingNum-i+1 do
             if JY.Base["物品"..j] > -1 and JY.Base["物品" .. j+1] > -1 then				--如果两个物品有效
				local wg1 = JY.Thing[JY.Base["物品"..j]]["练出武功"];
				local wg2 = JY.Thing[JY.Base["物品"..j+1]]["练出武功"];                           
				if wg2 < 0 then								--不可练出武功的根据编号排序
					if wg1 > 0 or  (wg1 < 0 and JY.Base["物品"..j] > JY.Base["物品"..j+1])  then                
						swap(j, j+1);
						flag = 1;
					end   
                elseif wg1 > 0 then							--可练出武功的根据类型排序，如果类型相同，再根据武功10级威力排序                         
					if JY.Wugong[wg1]["武功类型"] > JY.Wugong[wg2]["武功类型"] or (JY.Wugong[wg1]["武功类型"] == JY.Wugong[wg2]["武功类型"] and JY.Wugong[wg1]["攻击力10"] > JY.Wugong[wg2]["攻击力10"]) then
						swap(j, j+1);
						flag = 1;
					end
				end
			end
		end
		if flag == 0 then									--如果一轮下来没有任何的交换，肯定就是已经排好序了，直接退出
			break;
		end
	end
	Cls()
	DrawStrBoxWaitKey("行囊整理完毕", C_WHITE, CC.DefaultFont)
end

--大商家卖物品菜单
function MenuDSJ()
	local menu = {
	{"全部物品", nil, 0}, 
	{"剧情物品", nil, 0}, 
	{"神兵宝甲", nil, 1}, 
	{"武功秘笈", nil, 1}, 
	{"灵丹妙药", nil, 1}, 
	{"伤人暗器", nil, 1}}
	local r = ShowMenu(menu, 6, 0, CC.ScreenW/2-CC.DefaultFont*2-10, CC.ScreenH/2-CC.DefaultFont*3, 0, 0, 1, 1, CC.DefaultFont, C_ORANGE, C_WHITE)
	if r > 0 then
		local thing = {}
		local thingnum = {}
		for i = 0, CC.MyThingNum - 1 do
			thing[i] = -1
			thingnum[i] = 0
		end
		local num = 0
		for i = 0, CC.MyThingNum - 1 do
			local id = JY.Base["物品" .. i + 1]
			if id >= 0 then
				if r == 1 then
					thing[i] = id
					thingnum[i] = JY.Base["物品数量" .. i + 1]  
				else
					if JY.Thing[id]["类型"] == r - 2 then
						thing[num] = id
						thingnum[num] = JY.Base["物品数量" .. i + 1]
						num = num + 1
					end
				end
			end
		end
		--无酒不欢：秘笈显示区分
		if r == 4 then
			IsViewingKungfuScrolls = 1
		end
		local r = SelectThing(thing, thingnum)
		if r >= 0 then
			return r
		end
	end
	return -1
end

--铁匠强化物品菜单
function MenuTJQH()
	local thing = {}
	local thingnum = {}
	for i = 0, CC.MyThingNum - 1 do
		thing[i] = -1
		thingnum[i] = 0
	end
	local num = 0
	for i = 0, CC.MyThingNum - 1 do
		local id = JY.Base["物品" .. i + 1]
		if id >= 0 then
			if JY.Thing[id]["类型"] == 1 then
				thing[num] = id
				thingnum[num] = JY.Base["物品数量" .. i + 1]
				num = num + 1
			end	
		end
	end
	local r = SelectThing(thing, thingnum)
	if r >= 0 then
		return r
	end
	return -1
end

--回营整备
function Menu_HYZB()
	if JY.SubScene ~= 25 then
		JY.SubScene = 70
		JY.Base["人X1"] = 8
		JY.Base["人Y1"] = 28
		JY.Base["人X"] = 358
		JY.Base["人Y"] = 235
	end
end

--无酒不欢：新版X菜单
function Menu_Exit()      --离开菜单
	local surid = lib.SaveSur(0, 0, CC.ScreenW, CC.ScreenH)
	lib.SetClip(0,0,0,0)
	local t = 0
	for i = 0, (CC.ScreenH/2), 3 do
		lib.Background(0,i,CC.ScreenW,i + 3,t)
		t = t + 1
	end
	for i = (CC.ScreenH/2)+1, CC.ScreenH-3, 3 do
		lib.Background(0,i,CC.ScreenW,i + 3,t)
		t = t - 1
	end
	lib.GetKey()
	local menu = {
	{"离开游戏", nil, 1}, 
	{"返回标题", nil, 1},
	{"继续游戏", nil, 2}}
	local r = ShowMenu(menu, 3, 0, CC.ScreenW/2-105, CC.ScreenH/2-89, 0, 0, 0, 0, 50, C_GOLD, C_WHITE)
	if r == 1 then
        JY.Status =GAME_END;
        return 1;
	elseif r == 2 then
		JY.Restart = 1
        JY.Status =GAME_START;
        return 0;
	end
	lib.LoadSur(surid, 0, 0)
	ShowScreen();
	lib.FreeSur(surid)
    return 0;
end

--离开菜单
function Menu_Exit2()
    Cls();
    if DrawStrBoxYesNo(-1,-1,"是否真的要离开游戏(Y/N)?",C_WHITE,CC.DefaultFont) == true then
        JY.Status =GAME_END;
    end
    return 1;
end

--保存进度
function Menu_SaveRecord()
	Cls();
	DrawStrBox(-1,CC.ScreenH*1/6-20,"保存进度",LimeGreen,CC.Fontbig,C_GOLD);
	DrawStrBox(104,CC.ScreenH*1/6+26,string.format("%-6s %-4s %-10s %-4s %-4s %-4s %-10s","存档名", "主角", "姓名", "难度", "资质", "天书", "位置"),C_ORANGE,CC.DefaultFont,C_GOLD);
	local r = SaveList();
    if r>0 then
        DrawStrBox(CC.MainSubMenuX2,CC.MainSubMenuY,"请稍候......",C_WHITE,CC.DefaultFont);
        ShowScreen();
        SaveRecord(r);
        Cls();
	end
    return 0;
end

--读取进度
function Menu_ReadRecord()
	Cls();
	DrawStrBox(-1,CC.ScreenH*1/6-20,"读取进度",LimeGreen,CC.Fontbig,C_GOLD);
	DrawStrBox(104,CC.ScreenH*1/6+26,string.format("%-6s %-4s %-10s %-4s %-4s %-4s %-10s","存档名", "主角", "姓名", "难度", "资质", "天书", "位置"),C_ORANGE,CC.DefaultFont,C_GOLD);
	local r = SaveList();
	if r < 1 then
		return 0;
	end
    	
	Cls();
	DrawStrBox(-1,CC.StartMenuY,"请稍候...",C_GOLD,CC.DefaultFont);
	ShowScreen();
	local result = LoadRecord(r);
	if result ~= nil then
		return 0;
	end
	--子场景
	if JY.Base["无用"] ~= -1 then
		if JY.SubScene < 0 then
			CleanMemory()
			lib.UnloadMMap()
		end
		lib.PicInit()
		lib.ShowSlow(20, 1)
		JY.Status = GAME_SMAP
		JY.SubScene = JY.Base["无用"]
		JY.MmapMusic = -1
		JY.MyPic = GetMyPic()
		Init_SMap(1)
	--大地图
	else
		JY.SubScene = -1
		JY.Status = GAME_FIRSTMMAP
	end
    return 1;
end

--状态子菜单
function Menu_Status()
	--无酒不欢：各状态下对应X轴
	local xcor = CC.MainSubMenuX +2*CC.MenuBorderPixel+4*CC.DefaultFont+5
	if JY.Status == GAME_WMAP then
		xcor = CC.MainSubMenuX + 15
	end
    DrawStrBox(xcor,CC.MainSubMenuY,"要查阅谁的状态",LimeGreen,CC.DefaultFont,C_GOLD);
	local nexty=CC.MainSubMenuY+CC.SingleLineHeight;

    local r=SelectTeamMenu(xcor,nexty);
    if r >0 then
        ShowPersonStatus(r)
		return 1;
	else
        Cls(xcor,CC.MainSubMenuY,CC.ScreenW,CC.ScreenH);
        return 0;
	end
end


--离队菜单
function Menu_PersonExit()
	DrawStrBox(CC.MainSubMenuX, CC.MainSubMenuY, "要求谁离队", C_WHITE, CC.DefaultFont)
	local nexty = CC.MainSubMenuY + CC.SingleLineHeight
	local r = SelectTeamMenu(CC.MainSubMenuX, nexty)
	if r == 1 then
		DrawStrBoxWaitKey("抱歉！没有你游戏进行不下去", C_GOLD, CC.DefaultFont, nil, LimeGreen)
	else
		if JY.SubScene == 82 then
			do return end
		end
	end
	if r > 0 and JY.SubScene == 55 and JY.Base["队伍" .. r] == 35 then
		do return end
	end
	if r > 1 then
		local personid = JY.Base["队伍" .. r]
		for i,v in ipairs(CC.PersonExit) do
			if personid == v[1] then
				CallCEvent(v[2])
				break;
			end
		end
	end
	Cls()
	return 0
end

--队伍选择人物菜单
function SelectTeamMenu(x,y)
	local menu={};
	for i=1,CC.TeamNum do
        menu[i]={"",nil,0};
		local id=JY.Base["队伍" .. i]
		if id>=0 then
            if JY.Person[id]["生命"]>0 then
                menu[i][1]=JY.Person[id]["姓名"];
                menu[i][3]=1;
            end
		end
	end
    return ShowMenu(menu,CC.TeamNum,0,x,y,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE);
end

--计算当前队友个数
function GetTeamNum()
    local r=CC.TeamNum;
	for i=1,CC.TeamNum do
	    if JY.Base["队伍" .. i]<0 then
		    r=i-1;
		    break;
		end
    end
	return r;
end


---显示队伍状态
-- 左右键翻页，上下键换队友
function ShowPersonStatus(teamid)
	local page = 1
	local pagenum = 4
	local teamnum = GetTeamNum()
	local istart = 1
	local AI_s1 = 1
	local AI_menu_selected = 0
	local WG_num = 0
	local NG_num = 0
	local QG_num = 0
	local AniFrame = 0
	local ST_selected = 0
	local SK = 0
	while true do
		if JY.Restart == 1 then
			break
		end
		Cls()
		local id = JY.Base["队伍" .. teamid]
		local sp = JY.Person[id]
		--
		--天赋ID
		local tfid;
		--主角
		if id == 0 then
			--标主
			if JY.Base["标准"] > 0 then
				tfid = 280 + JY.Base["标准"]
			--特殊
			elseif JY.Base["特殊"] > 0 then
				tfid = 289 + JY.Base["特殊"]
			--畅想
			else
				tfid = JY.Base["畅想"]
				--畅想袁承志
				if tfid == 54 and JY.Person[id]["个人觉醒"] >= 1 then
					tfid = "54-1"
				--畅想石破天
				elseif tfid == 38 and JY.Person[id]["个人觉醒"] >= 1 then
					tfid = "38-1"
				--霍青桐
				elseif tfid == 74 and JY.Person[id]["个人觉醒"] >= 1 then
					tfid = "74-1"
				--畅想郭襄
				elseif tfid == 626 and JY.Person[id]["个人觉醒"] >= 1 then
					tfid = "626-1"
				--畅想温青青
				elseif tfid == 91 and JY.Person[id]["个人觉醒"] >= 1 then
					tfid = "91-1"
				--无名	
				elseif tfid == 671 and JY.Person[id]["个人觉醒"] >= 1 then
				    tfid = "671-1"
				--余沧海	
				elseif tfid == 24 and JY.Person[id]["个人觉醒"] >= 2 then
				    tfid = "24-2"
				elseif tfid == 24 and JY.Person[id]["个人觉醒"] >= 1 then
				    tfid = "24-1"
				elseif tfid == 673 and JY.Person[673]["外号2"] == "怒" and JY.Person[673]["天1"] == 1 then
				    tfid = "673-1"
				elseif tfid == 673 and JY.Person[673]["外号2"] == "烈" and JY.Person[673]["天1"] == 1 then
				    tfid = "673-2"
				elseif tfid == 673 and JY.Person[673]["外号2"] == "怒" and JY.Person[673]["天1"] == 2 then
				    tfid = "673-3"
				elseif tfid == 673 and JY.Person[673]["外号2"] == "烈" and JY.Person[673]["天1"] == 2 then
				    tfid = "673-4"	
				elseif tfid == 29 and JY.Person[654]["品德"] == 93 then
                    tfid = "29-1"
				--小虾米	
				elseif tfid == 677 and JY.Person[id]["个人觉醒"] >= 1 then
				    tfid = "677-1"	
				end
			end
		--队友
		else
			tfid = id
			--袁承志
			if id == 54 and JY.Person[id]["个人觉醒"] >= 1 then
				tfid = "54-1"
			--石破天
			elseif id == 38 and JY.Person[id]["个人觉醒"] >= 1 then
				tfid = "38-1"
			--霍青桐
			elseif id == 74 and JY.Person[id]["个人觉醒"] >= 1 then
				tfid = "74-1"
			--郭襄
			elseif id == 626 and JY.Person[id]["个人觉醒"] >= 1 then
				tfid = "626-1"
			--温青青
			elseif id == 91 and JY.Person[id]["个人觉醒"] >= 1 then
				tfid = "91-1"
			end
			
		end
		--无酒不欢：第二页的翻页上限判定需要因人而异
		local max_row = -17;
		
		if TFJS[tfid] ~= nil then
			max_row = max_row + #TFJS[tfid] + 10
		end
		if id == 0 then
			max_row = max_row + #ZJZSJS
		end
		--AI的子选项默认值获取
		local AI_s2 = {sp["行为模式"],sp["优先使用"],sp["主运内功"],sp["主运轻功"],sp["是否吃药"],sp["生命阈值"],sp["内力阈值"],sp["体力阈值"],sp["禁用自动"]}
		local yxsy = {}
		local yxsynum = 0
		yxsy[0] = 0
		for j = 1, JY.Person[671]["品德"] do
			if sp["武功"..j] == 0 then
				break
			end
			--外功，不能选斗转
			--石破天可以选太玄
			if (JY.Wugong[sp["武功"..j]]["武功类型"] <= 5 and sp["武功"..j] ~= 43) 
			or (match_ID_awakened(id, 38 ,1) and sp["武功"..j] == 102)
			or (match_ID(id, 638) and sp["武功"..j] == 106)
			or (match_ID(id, 672) and sp["武功"..j] == 94)
			or (JY.Base["标准"] == 6 and id == 0 and JY.Wugong[sp["武功"..j]]["武功类型"] == 6 and sp["武功"..j] ~= 144 and sp["武功"..j] ~= 87) and sp["武功"..j] ~= 175 then
				yxsynum = yxsynum + 1
				yxsy[yxsynum] = sp["武功"..j]
			end
		end
		local zyng = {}
		local zyngnum = 0
		zyng[0] = 0
		for j = 1, JY.Person[671]["品德"] do
			if sp["武功"..j] == 0 then
				break
			end
			--五岳剑诀不能运
			if JY.Wugong[sp["武功"..j]]["武功类型"] == 6 and sp["武功"..j] ~= 175 and sp["武功"..j] ~= 171 then
				--天罡不能运三大
				if id == 0 and JY.Base["标准"] == 6 then
					if sp["武功"..j] == 106 or sp["武功"..j] == 107 then
					else
						zyngnum = zyngnum + 1
						zyng[zyngnum] = sp["武功"..j]
					end
				else
					zyngnum = zyngnum + 1
					zyng[zyngnum] = sp["武功"..j]
				end
			end
		end
		local zyqg = {}
		local zyqgnum = 0
		zyqg[0] = 0
		for j = 1, JY.Person[671]["品德"] do
			if sp["武功"..j] == 0 then
				break
			end
			if JY.Wugong[sp["武功"..j]]["武功类型"] == 7 then
				zyqgnum = zyqgnum + 1
				zyqg[zyqgnum] = sp["武功"..j]
			end
		end
		--状态界面动画显示，97号
		lib.PicLoadFile(string.format(CC.FightPicFile[1],JY.Person[id]["头像代号"]),
		string.format(CC.FightPicFile[2],JY.Person[id]["头像代号"]), 97)
		local m = 0
		local dl = 0
		for j=1,5 do
			if JY.Person[id]['出招动画帧数'..j]>0 then
				if j>1 then
					m=j
					break;
				end
				dl=dl+JY.Person[id]['出招动画帧数'..j]*4
			end
		end
		dl=dl+JY.Person[id]['出招动画帧数'..m]*3
		ShowPersonStatus_sub(id, page, istart, tfid, max_row, nil, AI_s1, AI_s2, AI_menu_selected,AniFrame,dl,ST_selected,SK)
		ShowScreen()
		local keypress, ktype, mx, my = lib.GetKey()
		lib.Delay(CC.Frame)
		--ktype  1：键盘，2：鼠标移动，3:鼠标左键，4：鼠标右键，5：鼠标中键，6：滚动上，7：滚动下
		if keypress == VK_ESCAPE or ktype == 4 then
			if page == 3 and AI_menu_selected > 0 then
				AI_menu_selected = 0
			else
				break;
			end
		--换装
		elseif keypress == VK_Q and page == 1 and JY.Status ~= GAME_WMAP then	
			Avatar_Switch(id)
			AniFrame = 0
		elseif keypress == VK_UP then
			if page == 1 then
				teamid = teamid - 1
				AniFrame = 0
			elseif page == 2 then
				if ST_selected == 1 then
					if SkillT[SK][4] ~= nil then
					   SK = SkillT[SK][4]
					end
				end	
			elseif page == 3 then
				if istart > 1 then
					istart = istart - 1
				end
			elseif page == 4 then
				if AI_menu_selected == 0 then
					AI_s1 = AI_s1 - 1
					--战斗中不能在此切换主运内轻
					if JY.Status == GAME_WMAP and AI_s1 == 4 then
						AI_s1 = AI_s1 - 2
					end
					if AI_s1 < 1 then
						AI_s1 = 9
					end
				end
			end
		elseif keypress == VK_DOWN then
			if page == 1 then
				teamid = teamid + 1
				AniFrame = 0
			elseif page == 2 then
			    if ST_selected == 1 then
					if SkillT[SK][5] ~= nil then
					   SK = SkillT[SK][5]
					end
				end
			elseif page == 3 then
				if istart < max_row then
					istart = istart + 1
				end
			elseif page == 4 then
				if AI_menu_selected == 0 then
					AI_s1 = AI_s1 + 1
					--战斗中不能在此切换主运内轻
					if JY.Status == GAME_WMAP and AI_s1 == 3 then
						AI_s1 = AI_s1 + 2
					end
					if AI_s1 > 9 then
						AI_s1 = 1
					end
				end
			end
		elseif keypress == VK_LEFT then
			if page == 4 and AI_menu_selected > 0 then
				if AI_menu_selected == 1 then
					JY.Person[id]["行为模式"] = JY.Person[id]["行为模式"] - 1
					if JY.Person[id]["行为模式"] < 1 then
						JY.Person[id]["行为模式"] = 4
					end
				elseif AI_menu_selected == 2 then
					if WG_num > 0 then
						WG_num = WG_num - 1
						JY.Person[id]["优先使用"] = yxsy[WG_num]
					end
				elseif AI_menu_selected == 3 then
					if NG_num > 0 then
						NG_num = NG_num - 1
						JY.Person[id]["主运内功"] = zyng[NG_num]
					end
				elseif AI_menu_selected == 4 then
					if QG_num > 0 then
						QG_num = QG_num - 1
						JY.Person[id]["主运轻功"] = zyqg[QG_num]
					end
				elseif AI_menu_selected == 5 then
					JY.Person[id]["是否吃药"] = JY.Person[id]["是否吃药"] - 1
					if JY.Person[id]["是否吃药"] < 1 then
						JY.Person[id]["是否吃药"] = 2
					end
				elseif AI_menu_selected == 6 then
					JY.Person[id]["生命阈值"] = JY.Person[id]["生命阈值"] - 1
					if JY.Person[id]["生命阈值"] < 1 then
						JY.Person[id]["生命阈值"] = 3
					end
				elseif AI_menu_selected == 7 then
					JY.Person[id]["内力阈值"] = JY.Person[id]["内力阈值"] - 1
					if JY.Person[id]["内力阈值"] < 1 then
						JY.Person[id]["内力阈值"] = 3
					end
				elseif AI_menu_selected == 8 then
					JY.Person[id]["体力阈值"] = JY.Person[id]["体力阈值"] - 1
					if JY.Person[id]["体力阈值"] < 1 then
						JY.Person[id]["体力阈值"] = 3
					end
				elseif AI_menu_selected == 9 then
					JY.Person[id]["禁用自动"] = JY.Person[id]["禁用自动"] - 1
					if JY.Person[id]["禁用自动"] < 1 then
						JY.Person[id]["禁用自动"] = 2
					end
				end
			elseif page == 2 and ST_selected == 1 then
				if SkillT[SK][6] ~= nil then
				   SK = SkillT[SK][6]
				end
			else
				page = page - 1
				if istart > 1 then
					istart = 1
				end
				if AI_s1 > 1 then
					AI_s1 = 1
				end
				if SK > 1 then
					SK = 1
				end
			end
		elseif keypress == VK_RIGHT then
			if page == 4 and AI_menu_selected > 0 then
				if AI_menu_selected == 1 then
					JY.Person[id]["行为模式"] = JY.Person[id]["行为模式"] + 1
					if JY.Person[id]["行为模式"] > 4 then
						JY.Person[id]["行为模式"] = 1
					end
				elseif AI_menu_selected == 2 then
					if WG_num < yxsynum then
						WG_num = WG_num + 1
						JY.Person[id]["优先使用"] = yxsy[WG_num]
					end
				elseif AI_menu_selected == 3 then
					if NG_num < zyngnum then
						NG_num = NG_num + 1
						JY.Person[id]["主运内功"] = zyng[NG_num]
					end
				elseif AI_menu_selected == 4 then
					if QG_num < zyqgnum then
						QG_num = QG_num + 1
						JY.Person[id]["主运轻功"] = zyqg[QG_num]
					end
				elseif AI_menu_selected == 5 then
					JY.Person[id]["是否吃药"] = JY.Person[id]["是否吃药"] + 1
					if JY.Person[id]["是否吃药"] > 2 then
						JY.Person[id]["是否吃药"] = 1
					end	
				elseif AI_menu_selected == 6 then
					JY.Person[id]["生命阈值"] = JY.Person[id]["生命阈值"] + 1
					if JY.Person[id]["生命阈值"] > 3 then
						JY.Person[id]["生命阈值"] = 1
					end	
				elseif AI_menu_selected == 7 then
					JY.Person[id]["内力阈值"] = JY.Person[id]["内力阈值"] + 1
					if JY.Person[id]["内力阈值"] > 3 then
						JY.Person[id]["内力阈值"] = 1
					end	
				elseif AI_menu_selected == 8 then
					JY.Person[id]["体力阈值"] = JY.Person[id]["体力阈值"] + 1
					if JY.Person[id]["体力阈值"] > 3 then
						JY.Person[id]["体力阈值"] = 1
					end	
				elseif AI_menu_selected == 9 then
					JY.Person[id]["禁用自动"] = JY.Person[id]["禁用自动"] + 1
					if JY.Person[id]["禁用自动"] > 2 then
						JY.Person[id]["禁用自动"] = 1
					end	
				end
			elseif page == 2 and ST_selected == 1 then
				if SkillT[SK][7] ~= nil then
				   SK = SkillT[SK][7]
				end	
			else
				page = page + 1
				if istart > 1 then
					istart = 1
				end
			end
		elseif keypress == VK_SPACE or keypress == VK_RETURN then
			if page == 4 then
				if AI_menu_selected == 0 then
					AI_menu_selected = AI_s1
				else
					AI_menu_selected = 0
				end
			end
			if page == 2 then
				if ST_selected == 0 then
					ST_selected = 1
					SK = 1
				elseif SK > 0 then
					if SkillT[SK][8] ~= nil then
					   local v = 1
					   for i = 1, #SkillT[SK][8] do
					       if JY.Person[id]["人"..SkillT[SK][8][i]] == 0 then
						      v = 0
						   end	  
					   end
					   if JY.Base["天书数量"] < SkillT[SK][9] then
					      v = 0
					   end
					   if JY.Person[id]["感悟"] < SkillT[SK][10] then
					      v = 0
					   end
					   if JY.Person[id]["人"..SK] == 1 then
					      v = 0
					   end
					   if v == 1 then
					      local nl = JYMsgBox("请选择", "是否确定感悟此项能力", {"是", "否"}, 2)
						  if nl == 1 then
						  PlayWavE(55)
					      JY.Person[id]["感悟"] = JY.Person[id]["感悟"] - SkillT[SK][10]
					      JY.Person[id]["人"..SK] = 1
						     if SK == 23 then
							    AddPersonAttrib(id, "攻击带毒", 100)
		                        AddPersonAttrib(id, "用毒能力", 100)
								AddPersonAttrib(id, "解毒能力", 100)
							 end
						  end
					   else
					      PlayWavE(54)
					   end
					end
				end
			end
		elseif keypress == VK_BACKSPACE	then
		    if page == 2 then
				if ST_selected == 1 then
					ST_selected = 0
					SK = 0
				end
			end
		end
		AniFrame = AniFrame + 1
		if AniFrame == JY.Person[id]['出招动画帧数'..m] then
			AniFrame = 0
		end
		teamid = limitX(teamid, 1, teamnum)
		page = limitX(page, 1, pagenum)
	end
end


--无酒不欢：人物属性面板
--case：nil=正常浏览，else加点
function ShowPersonStatus_sub(id, page, istart, tfid, max_row, case, AI_s1, AI_s2, AI_menu_selected,AniFrame,dl,ST_selected,SK)
    
	if JY.Restart == 1 then
		do return end
	end
	local size = CC.FontSmall4
	local p = JY.Person[id]
	local p0 = JY.Person[0]
	local h = size + CC.PersonStateRowPixel
	local dx = (CC.ScreenW) / 3
	local dy = (CC.ScreenH) / 3
	local i = 1
	local x1, y1 = nil, nil
	
	local tfnum = 1
		for i = 1, 10 do
		    if p["地"..i] > 0 then
			   tfnum = tfnum + 1
			end
		end
	max_row = max_row + tfnum
  
	--无酒不欢：属性显示
	local function DrawAttrib(str, color1, color2)
		if str == "实战" and p[str] == 500 then
			DrawString(x1 + size*4 -27, y1 + h * i, string.format("%s", "极"), C_RED, size)
		else
			DrawString(x1 + size*2 -15, y1 + h * i, string.format("%5d", p[str]), color2, size)
		end
		if str == "武学常识" then
			str = "武常"
		elseif str == "特殊兵器" then	
			str = "奇门"
		elseif str == "攻击带毒" then	
			str = "带毒"
		end
		DrawString(x1, y1 + h * i, string.sub(str, 1, 4), color1, size)
		--额外系数显示
		if str == "拳掌功夫" then
			local bonus = 0
			local gxs = 0
			if match_ID(id, 186) and JY.Person[186]["阶"] >= 2 and JY.Status == GAME_WMAP then
			   gxs = JY.Person[id][str]
			end
			--金丝手套
			if JY.Person[id]["武器"] == 239 then
				bonus = 10
				if JY.Thing[239]["装备等级"] >= 5 then
					bonus = 30
				elseif JY.Thing[239]["装备等级"] >= 4 then
					bonus = 25
				elseif JY.Thing[239]["装备等级"] >= 3 then
					bonus = 20
				elseif JY.Thing[239]["装备等级"] >= 2 then
					bonus = 15
				end
			end
			--天怒十方
			local dw = 0
			if JY.Person[id]["防具"] == 323 then
		       dw = 20
	        end
			if JY.Person[id]["防具"] == 327 then
		       dw = 40
	        end
			--太玄，战场系数*140%
			local ts = 0
			if PersonKF(id, 102) and JY.Status == GAME_WMAP then
				ts = math.modf((JY.Person[id][str]+bonus+dw)*0.4)
			end
			if JY.Base["周目"]>1 then
			ts = ts +(JY.Base["周目"]-1)*5 
			end
			if bonus > 0 or ts > 0 or dw > 0 or gxs > 0 then
				DrawString(x1+size*4+10, y1 + h * i, string.format("+ %s",bonus+ts+dw+gxs), LimeGreen, size)
			end
		end
		if str == "指法技巧" then
			local bonus = 0
			--金丝手套
			if JY.Person[id]["武器"] == 239 then
				bonus = 10
				if JY.Thing[239]["装备等级"] >= 5 then
					bonus = 30
				elseif JY.Thing[239]["装备等级"] >= 4 then
					bonus = 25
				elseif JY.Thing[239]["装备等级"] >= 3 then
					bonus = 20
				elseif JY.Thing[239]["装备等级"] >= 2 then
					bonus = 15
				end
			end
			--天怒十方
			local dw = 0
			if JY.Person[id]["防具"] == 323 then
		       dw = 20
	        end
			if JY.Person[id]["防具"] == 327 then
		       dw = 40
	        end
			--太玄，战场系数*140%
			local ts = 0
			if PersonKF(id, 102) and JY.Status == GAME_WMAP then
				ts = math.modf((JY.Person[id][str]+bonus+dw)*0.4)
			end
			if JY.Base["周目"]>1 then
			ts = ts +(JY.Base["周目"]-1)*5 
			end
			if bonus > 0 or ts > 0 or dw > 0 then
				DrawString(x1+size*4+10, y1 + h * i, string.format("+ %s",bonus+ts+dw), LimeGreen, size)
			end
		end
		if str == "御剑能力" then
			local bonus = 0
			--五岳剑法
			if WuyueJF(id) then
				bonus=bonus+50
			end
			--战斗中的剑胆琴心加成
			if JY.Status == GAME_WMAP then
				if WAR.JDYJ[id] then
					bonus = bonus + WAR.JDYJ[id]
				end
			end
			--天怒十方
			local dw = 0
			if JY.Person[id]["防具"] == 323 then
		       dw = 20
	        end
			if JY.Person[id]["防具"] == 327 then
		       dw = 40
	        end
			--太玄，战场系数*140%
			local ts = 0
			if PersonKF(id, 102) and JY.Status == GAME_WMAP then
				ts = math.modf((JY.Person[id][str]+bonus+dw)*0.4)
			end
			if JY.Base["周目"]>1 then
			ts = ts +(JY.Base["周目"]-1)*5 
			end
			local wm = 0
			if match_ID(id, 671) and JY.Status == GAME_WMAP and WAR.WMJY[id] ~= nil then		
				wm = math.modf((JY.Person[id][str]+bonus+dw)*WAR.WMJY[id]*0.01)
			end
			if bonus > 0 or ts > 0 or dw > 0 or wm > 0 then
			local col = LimeGreen
			if wm > 0 then
			col = C_RED
			end
				DrawString(x1+size*4+10, y1 + h * i, string.format("+ %s",bonus+ts+dw+wm), col, size)
			end
		end
		if str == "耍刀技巧" then
		    --天怒十方
			local dw = 0
			if JY.Person[id]["防具"] == 323 then
		       dw = 20
	        end
			if JY.Person[id]["防具"] == 327 then
		       dw = 40
	        end
			--太玄，战场系数*140%
			local ts = 0
			if PersonKF(id, 102) and JY.Status == GAME_WMAP then
				ts = math.modf((JY.Person[id][str]+dw)*0.4)
			end
			if JY.Base["周目"]>1 then
			ts = ts +(JY.Base["周目"]-1)*5 
			end
			if ts > 0 or dw > 0 then
				DrawString(x1+size*4+10, y1 + h * i, string.format("+ %s",ts+dw), LimeGreen, size)
			end
		end
		if str == "奇门" then
		    --天怒十方
			local dw = 0
			if JY.Person[id]["防具"] == 323 then
		       dw = 20
	        end
			if JY.Person[id]["防具"] == 327 then
		       dw = 40
	        end
			--太玄，战场系数*140%
			local ts = 0
			if PersonKF(id, 102) and JY.Status == GAME_WMAP then
				ts = math.modf((JY.Person[id]["特殊兵器"]+dw)*0.4)
			end
			if JY.Base["周目"]>1 then
			ts = ts +(JY.Base["周目"]-1)*5 
			end
			if ts > 0 or dw > 0 then
				DrawString(x1+size*4+10, y1 + h * i, string.format("+ %s",ts+dw), LimeGreen, size)
			end
		end
		--战场情侣加成
		if JY.Status == GAME_WMAP then
			if str == "医疗能力" then
				for k,v in pairs(CC.AddDoc) do
					if match_ID(id, v[1]) then
						for wid = 0, WAR.PersonNum - 1 do
							if match_ID(WAR.Person[wid]["人物编号"], v[2]) and WAR.Person[wid]["死亡"] == false then
								DrawString(x1+size*4+10, y1 + h * i, "+ "..v[3], LimeGreen, size)
								--break
							end
						end
					end
				end
			end
			if str == "用毒能力" then
				for k,v in pairs(CC.AddPoi) do
					if match_ID(id, v[1]) then
						for wid = 0, WAR.PersonNum - 1 do
							if match_ID(WAR.Person[wid]["人物编号"], v[2]) and WAR.Person[wid]["死亡"] == false then
								DrawString(x1+size*4+10, y1 + h * i, "+ "..v[3], LimeGreen, size)
								--break
							end
						end
					end
				end
			end
		end
		i = i + 1
	end
  
	x1 = size*3 -10
	y1 = size + 6

	if page == 1 then
		--背景图
		lib.LoadPNG(1, 1001 * 2 , 0 , 0, 1)

		local hid = nil
		--主角
		if id == 0 and JY.Base["畅想"] == 0 then
			--标主
			if JY.Base["标准"] > 0 then
				if p["性别"] == 0 then
					hid = 280 + JY.Base["标准"]
				else
					hid = 500 + JY.Base["标准"]
				end
			--特殊
			elseif JY.Base["特殊"] == 1 then
				if p["性别"] == 0 then
					hid = 290
				else
					hid = 368
				end
			else
				hid = p["头像代号"]
			end
		--畅想主角和队友
		else
			hid = p["头像代号"]
		end
		local headw, headh = lib.GetPNGXY(1, hid*2)
		local headx = (size*9 - headw) / 3
		local heady = (h * 6 - headh) / 6

		lib.LoadPNG(1, hid * 2 , x1 + headx, y1 + heady, 1)
		y1 = y1 - 8
		i = 5
		--名字
		DrawString(x1, y1 + h * i, p["姓名"], MilkWhite, size)
		DrawString(x1 + 10 * size / 2, y1 + h * i, string.format("%3d", p["等级"]), C_GOLD, size)
		DrawString(x1 + 13 * size / 2+ 5, y1 + h * i, "级", C_ORANGE, size)
		i = i + 1
	  
		--体能
		--DrawString(x1, y1 + h * i, "体能 【 ※※ 】", Violet, size)

		
		--i = i + 1
		DrawString(x1, y1 + h * (i), "天赋：", LimeGreen, size)
	  
		--主角天赋
		if id == 0 then
			local main_tf;
			--标主
			if JY.Base["标准"] > 0 then
				main_tf = ZJTF[JY.Base["标准"]]
			--特殊
			elseif JY.Base["特殊"] > 0 then
				main_tf = " "
				if JY.Base["特殊"] == 3 then
				   DrawString(x1 + size * 3, y1 + h * (i), "正义馈赠", LimeGreen, size)
				end
			--畅想
			elseif JY.Base["畅想"] > 0 then
				if RWTFLB[p["代号"]] ~= nil then
					main_tf = RWTFLB[p["代号"]]
				end
				if main_tf ~= nil then
				  if JY.Base["畅想"] == 671 and id == 0 then
				     DrawString(x1 + size * 3, y1 + h * (i), main_tf, C_RED, size)
				  else
				     DrawString(x1 + size * 3, y1 + h * (i), main_tf, LimeGreen, size)
				  end
				end
			--宋青书
				if match_ID_awakened(id, 82, 1) then
				DrawString(x1 + size * 3, y1 + h * (i), "情意绵绵", LimeGreen, size)
				end
			--朱九真
				if match_ID_awakened(id, 81, 1) then
				DrawString(x1 + size * 3, y1 + h * (i), "娇媚婉转", LimeGreen, size)
				end
				
				if JY.Base["畅想"] == 673 then
				if JY.Person[673]["外号2"] == "怒" then
					DrawString(x1 + size * 3, y1 + h * (i), "怒火冲天", C_RED, size)
				else
					DrawString(x1 + size * 3, y1 + h * (i), "炽烈爆发", C_ORANGE, size)
				end
				end
			   	
			end
		end

		--普通角色天赋
		if id ~= 0 and RWTFLB[id] ~= nil then
			DrawString(x1 + size * 3, y1 + h * (i), RWTFLB[id], LimeGreen, size)
		end
	  
		--称号
		i = i + 1
		DrawString(x1, y1 + h * (i), "称号：", LimeGreen, size)
		
		--主角称号
		if id == 0 then
			local main_ch;
			--标主
			if JY.Base["标准"] > 0 then
				if p["六如觉醒"] == 0 then
					main_ch = "江湖小虾米"
				else
					main_ch = "觉醒之苍龙"
				end
			--特殊
			elseif JY.Base["特殊"] > 0 then
				main_ch = TSTF[JY.Base["特殊"]]
				if JY.Base["特殊"]==3 then
				   main_ch = "正义玩家"
				end   
			--畅想
			elseif JY.Base["畅想"] > 0 then
				if RWWH[JY.Base["畅想"]] ~= nil and JY.Base["畅想"] ~= 35 and JY.Base["畅想"] ~= 38 and JY.Base["畅想"] ~= 49 and JY.Base["畅想"] ~= 74 and JY.Base["畅想"] ~= 626 and JY.Base["畅想"] ~= 24 and JY.Base["畅想"] ~= 29 then
					main_ch = RWWH[JY.Base["畅想"]]
				elseif JY.Base["畅想"] == 35 then
					if JY.Person[id]["个人觉醒"] >= 2 then
						DrawString(x1 + size * 3, y1 + h * (i), RWWH["35"], LimeGreen, size)
					elseif JY.Person[id]["个人觉醒"] >= 1 then
						DrawString(x1 + size * 3, y1 + h * (i), RWWH[35], LimeGreen, size)
					end
				elseif JY.Base["畅想"] == 38 then
					if JY.Person[id]["个人觉醒"] >= 1 then
						DrawString(x1 + size * 3, y1 + h * (i), RWWH["38"], LimeGreen, size)
					end
				elseif JY.Base["畅想"] == 49 then
					if JY.Person[id]["个人觉醒"] >= 1 then
						DrawString(x1 + size * 3, y1 + h * (i), RWWH["49"], LimeGreen, size)
					else
						DrawString(x1 + size * 3, y1 + h * (i), RWWH[49], LimeGreen, size)
					end
				elseif JY.Base["畅想"] == 74 then
					if JY.Person[id]["个人觉醒"] >= 1 then
						DrawString(x1 + size * 3, y1 + h * (i), RWWH["74"], LimeGreen, size)
					else
						DrawString(x1 + size * 3, y1 + h * (i), RWWH[74], LimeGreen, size)
					end
				elseif JY.Base["畅想"] == 626 then
					if JY.Person[id]["个人觉醒"] >= 1 then
						DrawString(x1 + size * 3, y1 + h * (i), RWWH["626"], LimeGreen, size)
					else
						DrawString(x1 + size * 3, y1 + h * (i), RWWH[626], LimeGreen, size)
					end
				elseif JY.Base["畅想"] == 671 then
					if JY.Person[id]["个人觉醒"] >= 1 then
						DrawString(x1 + size * 3, y1 + h * (i), RWWH["671"], C_RED, size)
					end
				elseif JY.Base["畅想"] == 24 then
					if JY.Person[id]["个人觉醒"] >= 1 then
						DrawString(x1 + size * 3, y1 + h * (i), RWWH["24"], LimeGreen, size)
					else
						DrawString(x1 + size * 3, y1 + h * (i), RWWH[24], LimeGreen, size)
					end
                elseif JY.Base["畅想"] == 29 then
					if JY.Person[654]["品德"] == 93 then
						DrawString(x1 + size * 3, y1 + h * (i), RWWH["29"], LimeGreen, size)
					else
						DrawString(x1 + size * 3, y1 + h * (i), RWWH[29], LimeGreen, size)
					end	
				elseif JY.Base["畅想"] == 677 then
					if JY.Person[id]["个人觉醒"] >= 1 then
						DrawString(x1 + size * 3, y1 + h * (i), RWWH["677"], C_RED, size)
					end	
				end
			end
			if main_ch ~= nil then
				DrawString(x1 + size * 3, y1 + h * (i), main_ch, LimeGreen, size)
			end
		end
		
		--其他人称号
		if RWWH[id] ~= nil and id ~= 35 and id ~= 38 and id ~= 49 then
			DrawString(x1 + size * 3, y1 + h * (i), RWWH[id], LimeGreen, size)
		end

		--令狐冲
		if id == 35 then
			if JY.Person[id]["个人觉醒"] >= 2 then
				DrawString(x1 + size * 3, y1 + h * (i), RWWH["35"], LimeGreen, size)
			elseif JY.Person[id]["个人觉醒"] >= 1 then
				DrawString(x1 + size * 3, y1 + h * (i), RWWH[35], LimeGreen, size)
			end
		end

		--虚竹
		if id == 49 then
			if JY.Person[id]["个人觉醒"] >= 1 then
				DrawString(x1 + size * 3, y1 + h * (i), RWWH["49"], LimeGreen, size)
			else
				DrawString(x1 + size * 3, y1 + h * (i), RWWH[49], LimeGreen, size)
			end
		end
	  
		--石破天
		if id == 38 then
			if JY.Person[id]["个人觉醒"] >= 1 then
				DrawString(x1 + size * 3, y1 + h * (i), RWWH["38"], LimeGreen, size)
			end
		end
		
		--霍青桐
		if id == 74 then
			if JY.Person[id]["个人觉醒"] >= 1 then
				DrawString(x1 + size * 3, y1 + h * (i), RWWH["74"], LimeGreen, size)
			else
				DrawString(x1 + size * 3, y1 + h * (i), RWWH[74], LimeGreen, size)
			end
		end
		
		--郭襄
		if id == 626 then
			if JY.Person[id]["个人觉醒"] >= 1 then
				DrawString(x1 + size * 3, y1 + h * (i), RWWH["626"], LimeGreen, size)
			else
				DrawString(x1 + size * 3, y1 + h * (i), RWWH[626], LimeGreen, size)
			end
		end
		
	  
		local color = nil
		local color1 = nil
		local color2 = nil
		if p["受伤程度"] < 33 then
			color = RGB(236, 200, 40)
		elseif p["受伤程度"] < 66 then
			color = RGB(244, 128, 32)
		else
			color = RGB(232, 32, 44)
		end
		i = i + 1
		DrawString(x1, y1 + h * (i), "基础伤害", C_ORANGE, size)
		DrawString(x1 + 8 * size / 2+30, y1 + h * (i), get_skill_power(id, 225, math.modf(JY.Person[id]["武功等级16"]/100) + 1), C_GOLD, size)
		i = i + 1
		DrawString(x1, y1 + h * (i), "生命", C_ORANGE, size)
		DrawString(x1 + 2 * size, y1 + h * (i), string.format("%5d", p["生命"]), color, size)
		DrawString(x1 + 8 * size / 2+20, y1 + h * (i), "/", C_GOLD, size)
		if p["中毒程度"] == 0 then
			color = RGB(252, 148, 16)
		elseif p["中毒程度"] < 50 then
			color = RGB(120, 208, 88)
		else
			color = RGB(56, 136, 36)
		end
		DrawString(x1 + 5 * size-2, y1 + h * (i), string.format("%5s", p["生命最大值"]), color, size)
		i = i + 1
		local yin, yang, tg = NeiL(id)
		local a = yin + yang
		if a > 9 then
		   a = 9
		end
		if a < -9 then
		   a = -9
		end   
		if yin + yang < 0 then
		   color = RGB(127+a*9, 198+a*16, 216-a*2)
		elseif yin + yang > 0 then
		   color = RGB(210+a*5, 189-a*9, 109-a*10)
		else
		   color = C_WHITE
		end   
		   
		color2 = RGB(210+a*5, 189-a*9, 109-a*10)
		color1 = RGB(127+a*9, 198+a*16, 216-a*2)
		if yin + yang == 0 then
		   color1 = C_WHITE
		end   
		
		if tg == 1 then
			   color2 = TG_Red
			   color1 = TG_Red
			   color = TG_Red
		end 
		--[[天罡内力颜色
		
		if JY.Base["标准"] == 6 and id == 0 then
			color = TG_Red
		end]]
		if match_ID(id, 689) then
		DrawString(x1, y1 + h * (i), "法力", C_ORANGE, size)
		else
		DrawString(x1, y1 + h * (i), "内力", C_ORANGE, size)
		end
		DrawString(x1 + 2 * size, y1 + h * (i), string.format("%5d", p["内力"]), color, size)
		DrawString(x1 + 8 * size / 2+20, y1 + h * (i), "/", color, size)
		DrawString(x1 + 5 * size-2, y1 + h * (i), string.format("%5d", p["内力最大值"]), color, size)
		i = i + 1
		if JY.Base["畅想"] ~= 689 then
		DrawString(x1, y1 + h * (i), "内属", C_ORANGE, size)
		end
		--local ns = {"一","二","三","四","五","六","七","八","极"}
		if yang + yin ~= 0 then
		   if yin < 0 then
		   DrawString(x1 + 3 * size, y1 + h * (i), "阴"..-yin, color1, size)
		   end
		   --DrawString(x1 + 4 * size+27, y1 + h * (i), "|", C_WHITE, size)
		   if yang > 0 then
		   DrawString(x1 + 6 * size-2, y1 + h * (i), "阳"..yang, color2, size)
		   end
		else
		   DrawString(x1 + 4 * size-2, y1 + h * (i), "调和"..yang+1, color1, size)
		end   
		i = i + 1
        
		DrawString(x1, y1 + h * (i), "体力", C_ORANGE, size)
		DrawString(x1 + 2 * size, y1 + h * (i), string.format("%5d", p["体力"]), M_LightBlue, size)
		DrawString(x1 + 8 * size / 2+20, y1 + h * (i), "/", C_ORANGE, size)
		DrawString(x1 + 5 * size-2, y1 + h * (i), string.format("%5d", "100"), M_LightBlue, size)
		i = i + 1
		
		
		--资质
		DrawString(x1, y1 + h * (i), "资质", C_ORANGE, size)
		DrawString(x1 + size * 2 + 8, y1 + h * (i), p["资质"], C_GOLD, size)
		
		--体质
		DrawString(x1 + size * 4 + 16, y1 + h * (i), "体质", C_ORANGE, size)
		DrawString(x1 + size * 6 + 24, y1 + h * (i), p["生命增长"], C_GOLD, size)
		
		--出战，休战
		i = i + 1
		local hb = nil
		local dz = nil
		DrawString(x1, y1 + h * (i), "斗转", C_ORANGE, size)
		if p["出战"] == 1 then
			dz = "◎"
			if match_ID(id, 689) then
		       dz = "●"
		    end
		else
			dz = "※"
		end
		   
		DrawString(x1 + size * 2 + 8, y1 + h * (i), dz, C_GOLD, size)
		--左右
		DrawString(x1 + size * 4 + 16, y1 + h * (i), "互搏", C_ORANGE, size)
		local zyjl = 80 - JY.Person[id]["资质"]
		if zyjl < 0 then
			zyjl = 0
		end
		--周伯通100%
		if match_ID(id, 64) then
			zyjl = 100
		end
		--郭靖80%
		if match_ID(id, 55) then
			zyjl = 80
		end
		--小龙女70%
		if match_ID(id, 59) then
			zyjl = 70
		end
		--周芷若觉醒后，70%
		if match_ID_awakened(id, 631, 1) then
			zyjl = 70
		end
		--七夕郭靖100%
		--七夕龙女100%
		if match_ID(id, 612) or match_ID(id, 615) then
			zyjl = 100
		end
		--周伯通支线完成后，主角+20%
		if id == 0 and JY.Person[64]["品德"] == 80 then
			zyjl = zyjl + 20
		end
		if JY.Person[id]["专2"] == 996 then
		   zyjl = zyjl + 25
		end
		--上限100%
		if zyjl > 100 then
			zyjl = 100
		end
		if match_ID(id, 689) then
		   zyjl = 0
		end
		if p["左右互搏"] == 1 then
		DrawString(x1 + size * 6 + 24, y1 + h * (i), zyjl.."%", C_GOLD, size)
		else
		DrawString(x1 + size * 6 + 24, y1 + h * (i), "※", C_GOLD, size)
		end
		
		--连击，暴击
		i = i + 1
		if JY.Person[642]["血量翻倍"] == 1 then
		local LJ = Person_LJ(id)+20
		local BJ = Person_BJ(id)+20	
		
		DrawString(x1, y1 + h * (i), "连击", M_SandyBrown, size)
		DrawString(x1 + size * 2 + 8, y1 + h * (i), LJ.."%", M_LightBlue, size)
		DrawString(x1 + size * 4 + 16, y1 + h * (i), "暴击", M_SandyBrown, size)
		DrawString(x1 + size * 6 + 24, y1 + h * (i), BJ.."%", PinkRed, size)
		else
		DrawString(x1, y1 + h * (i), "连击", M_SandyBrown, size)
		DrawString(x1 + size * 2 + 8, y1 + h * (i), Person_LJ(id).."%", M_LightBlue, size)
		DrawString(x1 + size * 4 + 16, y1 + h * (i), "暴击", M_SandyBrown, size)
		DrawString(x1 + size * 6 + 24, y1 + h * (i), Person_BJ(id).."%", PinkRed, size)
		end
		
		--[[内伤，中毒
		i = i + 1
		DrawString(x1, y1 + h * (i), "内伤", M_SandyBrown, size)
		DrawString(x1 + size * 2 + 8, y1 + h * (i), p["受伤程度"], PinkRed, size)
		DrawString(x1 + size * 4 + 16, y1 + h * (i), "中毒", M_SandyBrown, size)
		DrawString(x1 + size * 6 + 24, y1 + h * (i), p["中毒程度"], LightGreen, size)]]
		
		--武器，防具
		i = i + 1
		DrawString(x1, y1 + h * (i), "武器", M_LightBlue, size)
		if p["武器"] > -1 then
			DrawString(x1 + size * 3 - 5, y1 + h * (i), JY.Thing[p["武器"]]["名称"], C_GOLD, size)
		else
			DrawString(x1 + size * 3 - 5, y1 + h * (i), "无", M_White, size)
		end
		i = i + 1
		DrawString(x1, y1 + h * (i), "防具", M_LightBlue, size)
		if p["防具"] > -1 then
			DrawString(x1 + size * 3 - 5, y1 + h * (i), JY.Thing[p["防具"]]["名称"], C_GOLD, size)
		else
			DrawString(x1 + size * 3 - 5, y1 + h * (i), "无", M_White, size)
		end
		i = i + 1
		DrawString(x1, y1 + h * (i), "动物伙伴", M_LightBlue, size)
		if p["动物"] > -1 then
			DrawString(x1 + size * 5 - 5, y1 + h * (i), JY.Thing[p["动物"]]["名称"], C_GOLD, size)
		else
			DrawString(x1 + size * 5 - 5, y1 + h * (i), "无", M_White, size)
		end
		i = i + 1
		
		if match_ID(id, 673) then
		  local n = math.ceil(50-JY.Person[id]["资质"]/2)
		  local s = QuanNum(id)*10 + 80 + n
		  DrawString(x1, y1 + h * i, "最大能量："..s, LightSkyBlue, size)
		end
		
		if match_ID(id, 689) and JY.Person[689]["阶"] >= 1 then
		  local n = math.ceil(JY.Person[id]["防御力"]*0.03 + JY.Person[id]["内力最大值"]*0.002)
		  if JY.Person[690]["天1"] == 2 then
	         n = n + 15
	      end
		  DrawString(x1, y1 + h * i, "护甲："..n, MilkWhite, size)
		end
		
		
		--第二列开始
		i = 0
		x1 = dx + size + 1
		y1 = size*2
		
		--装备增加的属性
		local str_gain, def_gain, agi_gain, klg_gain = 0, 0, 0, 0
		if p["武器"] > -1 then
			if JY.Thing[p["武器"]]["加攻击力"] > 0 then
				str_gain = str_gain + JY.Thing[p["武器"]]["加攻击力"]*10 + JY.Thing[p["武器"]]["加攻击力"]*(JY.Thing[p["武器"]]["装备等级"]-1)*2
			elseif JY.Thing[p["武器"]]["加攻击力"] < 0 then
				str_gain = str_gain + JY.Thing[p["武器"]]["加攻击力"]*10 - JY.Thing[p["武器"]]["加攻击力"]*(JY.Thing[p["武器"]]["装备等级"]-1)*2
			end
			if JY.Thing[p["武器"]]["加防御力"] > 0 then
				def_gain = def_gain + JY.Thing[p["武器"]]["加防御力"]*10 + JY.Thing[p["武器"]]["加防御力"]*(JY.Thing[p["武器"]]["装备等级"]-1)*2
			elseif JY.Thing[p["武器"]]["加防御力"] < 0 then
				def_gain = def_gain + JY.Thing[p["武器"]]["加防御力"]*10 - JY.Thing[p["武器"]]["加防御力"]*(JY.Thing[p["武器"]]["装备等级"]-1)*2
			end
			if JY.Thing[p["武器"]]["加轻功"] > 0 then
				agi_gain = agi_gain + JY.Thing[p["武器"]]["加轻功"]*10 + JY.Thing[p["武器"]]["加轻功"]*(JY.Thing[p["武器"]]["装备等级"]-1)*2
			elseif JY.Thing[p["武器"]]["加轻功"] < 0 then
				agi_gain = agi_gain + JY.Thing[p["武器"]]["加轻功"]*10 - JY.Thing[p["武器"]]["加轻功"]*(JY.Thing[p["武器"]]["装备等级"]-1)*2
			end
			if JY.Thing[p["武器"]]["加武学常识"] > 0 then
				klg_gain = klg_gain + JY.Thing[p["武器"]]["加武学常识"]*10 + JY.Thing[p["武器"]]["加武学常识"]*(JY.Thing[p["武器"]]["装备等级"]-1)*2
			elseif JY.Thing[p["武器"]]["加武学常识"] < 0 then
				klg_gain = klg_gain + JY.Thing[p["武器"]]["加武学常识"]*10 - JY.Thing[p["武器"]]["加武学常识"]*(JY.Thing[p["武器"]]["装备等级"]-1)*2
			end
		end
		if p["防具"] > -1 then
			if JY.Thing[p["防具"]]["加攻击力"] > 0 then
				str_gain = str_gain + JY.Thing[p["防具"]]["加攻击力"]*10 + JY.Thing[p["防具"]]["加攻击力"]*(JY.Thing[p["防具"]]["装备等级"]-1)*2
			elseif JY.Thing[p["防具"]]["加攻击力"] < 0 then
				str_gain = str_gain + JY.Thing[p["防具"]]["加攻击力"]*10 - JY.Thing[p["防具"]]["加攻击力"]*(JY.Thing[p["防具"]]["装备等级"]-1)*2
			end
			if JY.Thing[p["防具"]]["加防御力"] > 0 then
				def_gain = def_gain + JY.Thing[p["防具"]]["加防御力"]*10 + JY.Thing[p["防具"]]["加防御力"]*(JY.Thing[p["防具"]]["装备等级"]-1)*2
			elseif JY.Thing[p["防具"]]["加防御力"] < 0 then
				def_gain = def_gain + JY.Thing[p["防具"]]["加防御力"]*10 - JY.Thing[p["防具"]]["加防御力"]*(JY.Thing[p["防具"]]["装备等级"]-1)*2
			end
			if JY.Thing[p["防具"]]["加轻功"] > 0 then
				agi_gain = agi_gain + JY.Thing[p["防具"]]["加轻功"]*10 + JY.Thing[p["防具"]]["加轻功"]*(JY.Thing[p["防具"]]["装备等级"]-1)*2
			elseif JY.Thing[p["防具"]]["加轻功"] < 0 then
				agi_gain = agi_gain + JY.Thing[p["防具"]]["加轻功"]*10 - JY.Thing[p["防具"]]["加轻功"]*(JY.Thing[p["防具"]]["装备等级"]-1)*2
			end
			if JY.Thing[p["防具"]]["加武学常识"] > 0 then
				klg_gain = klg_gain + JY.Thing[p["防具"]]["加武学常识"]*10 + JY.Thing[p["防具"]]["加武学常识"]*(JY.Thing[p["防具"]]["装备等级"]-1)*2
			elseif JY.Thing[p["防具"]]["加武学常识"] < 0 then
				klg_gain = klg_gain + JY.Thing[p["防具"]]["加武学常识"]*10 - JY.Thing[p["防具"]]["加武学常识"]*(JY.Thing[p["防具"]]["装备等级"]-1)*2
			end
		end
		if p["动物"] > -1 then
			if JY.Thing[p["动物"]]["加攻击力"] > 0 then
				str_gain = str_gain + JY.Thing[p["动物"]]["加攻击力"]*10 + JY.Thing[p["动物"]]["加攻击力"]*(JY.Thing[p["动物"]]["装备等级"]-1)*2
			elseif JY.Thing[p["动物"]]["加攻击力"] < 0 then
				str_gain = str_gain + JY.Thing[p["动物"]]["加攻击力"]*10 - JY.Thing[p["动物"]]["加攻击力"]*(JY.Thing[p["动物"]]["装备等级"]-1)*2
			end
			if JY.Thing[p["动物"]]["加防御力"] > 0 then
				def_gain = def_gain + JY.Thing[p["动物"]]["加防御力"]*10 + JY.Thing[p["动物"]]["加防御力"]*(JY.Thing[p["动物"]]["装备等级"]-1)*2
			elseif JY.Thing[p["动物"]]["加防御力"] < 0 then
				def_gain = def_gain + JY.Thing[p["动物"]]["加防御力"]*10 - JY.Thing[p["动物"]]["加防御力"]*(JY.Thing[p["动物"]]["装备等级"]-1)*2
			end
			if JY.Thing[p["动物"]]["加轻功"] > 0 then
				agi_gain = agi_gain + JY.Thing[p["动物"]]["加轻功"]*10 + JY.Thing[p["动物"]]["加轻功"]*(JY.Thing[p["动物"]]["装备等级"]-1)*2
			elseif JY.Thing[p["动物"]]["加轻功"] < 0 then
				agi_gain = agi_gain + JY.Thing[p["动物"]]["加轻功"]*10 - JY.Thing[p["动物"]]["加轻功"]*(JY.Thing[p["动物"]]["装备等级"]-1)*2
			end
			if JY.Thing[p["动物"]]["加武学常识"] > 0 then
				klg_gain = klg_gain + JY.Thing[p["动物"]]["加武学常识"]*10 + JY.Thing[p["动物"]]["加武学常识"]*(JY.Thing[p["动物"]]["装备等级"]-1)*2
			elseif JY.Thing[p["动物"]]["加武学常识"] < 0 then
				klg_gain = klg_gain + JY.Thing[p["动物"]]["加武学常识"]*10 - JY.Thing[p["动物"]]["加武学常识"]*(JY.Thing[p["动物"]]["装备等级"]-1)*2
			end
		end
		
			--战场情侣加成 
		if JY.Status == GAME_WMAP then
		local gj = 0
		if Curr_NG(id,166) then	--天池心法基础攻击*1.2	
		 gj = math.modf (JY.Person[id]["攻击力"]*0.2)
		   str_gain = str_gain +gj
		 end
		if JY.Base["特殊"] ==1 and JY.Person[40]["血量翻倍"]==1 and id==0 then	--无酒不欢 一柱擎天
		 gj = math.modf (JY.Person[id]["攻击力"]*0.1)
		   str_gain = str_gain +gj
		 end
		local fy = 0
		if Curr_NG(id,166) then 	--天池心法基础防御*1.2
		 fy = math.modf(JY.Person[id]["防御力"]*0.2)
		   def_gain = def_gain +fy
		 end
		if JY.Base["特殊"] ==1 and JY.Person[40]["血量翻倍"]==1 and id==0 then	--无酒不欢 一柱擎天
		 fy = math.modf(JY.Person[id]["防御力"]*0.1)
		   def_gain = def_gain +fy
		 end
		local qg = 0
		if Curr_NG(id,166) then	--天池心法基础轻功*1.2
		 qg = math.modf(JY.Person[id]["轻功"]*0.2)
		   agi_gain = agi_gain +qg
		end
		if JY.Base["特殊"] ==1 and JY.Person[40]["血量翻倍"]==1 and id==0 then	--无酒不欢 一柱擎天
		 qg = math.modf(JY.Person[id]["轻功"]*0.1)
		   agi_gain = agi_gain +qg
		end
		end
		
		--战斗中的一苇渡江加成
			if JY.Status == GAME_WMAP then
				if WAR.YWDJ[id] then
					agi_gain = agi_gain + WAR.YWDJ[id]
				end
			end	
		
		--战场情侣加成
		if JY.Status == GAME_WMAP then
			--队友攻击力加成
			for i,v in pairs(CC.AddAtk) do
				if match_ID(id, v[1]) then
					for wid = 0, WAR.PersonNum - 1 do
						if match_ID(WAR.Person[wid]["人物编号"], v[2]) and WAR.Person[wid]["死亡"] == false then
							str_gain = str_gain + v[3]
						end
					end
				end
			end
			--队友防御力加成
			for i,v in pairs(CC.AddDef) do
				if match_ID(id, v[1]) then
					for wid = 0, WAR.PersonNum - 1 do
						if match_ID(WAR.Person[wid]["人物编号"], v[2]) and WAR.Person[wid]["死亡"] == false then
							def_gain = def_gain + v[3]
						end
					end
				end
			end
			--队友轻功加成
			for i,v in pairs(CC.AddSpd) do
				if match_ID(id, v[1]) then
					for wid = 0, WAR.PersonNum - 1 do
						if match_ID(WAR.Person[wid]["人物编号"], v[2]) and WAR.Person[wid]["死亡"] == false then
							agi_gain = agi_gain + v[3]
						end
					end
				end
			end
		end
		
		DrawAttrib("攻击力", C_WHITE, C_GOLD)
		DrawString(x1 + size * 4, y1, "↑ " .. str_gain, Violet, size)
		DrawAttrib("防御力", C_WHITE, C_GOLD)
		DrawString(x1 + size * 4, y1 + h, "↑ " .. def_gain, Violet, size)
		DrawAttrib("轻功", C_WHITE, C_GOLD)

		if agi_gain > -1 then
			DrawString(x1 + size * 4, y1 + h * 2, "↑ " .. agi_gain, Violet, size)
		else
			agi_gain = -(agi_gain)
			DrawString(x1 + size * 4, y1 + h * 2, "↓ " .. agi_gain, Violet, size)
		end
		
		--能力属性
		DrawAttrib("拳掌功夫", C_WHITE, C_GOLD)
		DrawAttrib("指法技巧", C_WHITE, C_GOLD)
		DrawAttrib("御剑能力", C_WHITE, C_GOLD)
		DrawAttrib("耍刀技巧", C_WHITE, C_GOLD)
		DrawAttrib("特殊兵器", C_WHITE, C_GOLD)
		DrawAttrib("暗器技巧", C_WHITE, C_GOLD)
		DrawAttrib("医疗能力", C_WHITE, C_GOLD)
		DrawAttrib("用毒能力", C_WHITE, C_GOLD)
		DrawAttrib("解毒能力", C_WHITE, C_GOLD)
		DrawAttrib("抗毒能力", C_WHITE, C_GOLD)
		DrawAttrib("攻击带毒", C_WHITE, C_GOLD)
		DrawAttrib("武学常识", C_WHITE, C_GOLD)
		if klg_gain > 0 then
		DrawString(x1 + size * 4, y1 + h*14, "↑ " .. klg_gain, Violet, size)
		end
		DrawAttrib("实战", C_WHITE, C_GOLD)
	   --经验值
		DrawString(x1, y1 + h * (i), "升级", C_WHITE, size)
		local kk = nil
		if p["等级"] >= 30 then
			kk = "   ="
		else
			kk = 2 * (p["经验"] - CC.Exp[p["等级"] - 1])
			if kk < 0 then
				kk = "  0"
			elseif kk < 10 then
				kk = "   " .. kk
			elseif kk < 100 then
				kk = "  " .. kk
			elseif kk < 1000 then
				kk = " " .. kk
			end
		end
		--等级
		DrawString(x1 + size * 2 + 16, y1 + h * (i), kk, C_GOLD, size)
		local tmp = nil
		if CC.Level <= p["等级"] then
			tmp = "="
		else
			tmp = 2 * (CC.Exp[p["等级"]] - CC.Exp[p["等级"] - 1])
		end
		DrawString(x1 + size * 4 + 16, y1 + h * (i), "/" .. tmp, C_GOLD, size)

		--修炼物品
		i = i + 1
		DrawString(x1, y1 + h * (i), "修炼", C_WHITE, size)
		local thingid = p["修炼物品"]
		if thingid > 0 then
			DrawString(x1 + size*2 + 10, y1 + h * (i), JY.Thing[thingid]["名称"], C_GOLD, size)
			i = i + 1
			local n = TrainNeedExp(id)
			if n < math.huge then
				DrawString(x1 + size, y1 + h * (i), string.format("%5d/%5d", p["修炼点数"], n), C_GOLD, size)
			else
				DrawString(x1 + size, y1 + h * (i), string.format("%5d/===", p["修炼点数"]), C_GOLD, size)
			end
		else
			i = i + 2
		end

		--第三列开始
		x1 = dx*2 - size*2--dx*2 - size*2 + 23
		y1 = size*2
		i = 0
		
		--武功显示
		DrawString(x1 , y1 + h * i, "所会功夫", C_RED, size)
		--DrawString(x1 + size*5, y1 + h * i, "内耗", C_RED, size)
		DrawString(x1 + size*5, y1 + h * i, "冷却", C_RED, size)
		DrawString(x1 + size*7 + 22, y1 + h * i, "等级", C_RED, size)
		DrawString(x1 + size*9 + 44, y1 + h * i, "威力", C_RED, size)
		local T = {"一", "二", "三", "四", "五", "六", "七", "八", "九", "十", "极"}
		--local SortingNum = {"01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15"}
		
		for j = 1, JY.Person[671]["品德"] do   
			i = i + 1
			local wugong = p["武功" .. j]
			if wugong > 0 then
				lib.LoadPNG(1, 1007 * 2 , x1 -30, y1 + h * (i), 1)
				if JY.Wugong[p["武功" .. j]]["啊"] > 0 then
				DrawString(x1 -25, y1 + h * (i)+6, JY.Wugong[p["武功" .. j]]["啊"], C_ORANGE, CC.FontSMALL)
				elseif JY.Wugong[p["武功" .. j]]["啊"] < 0 then
				DrawString(x1 -25, y1 + h * (i)+6, -JY.Wugong[p["武功" .. j]]["啊"], M_DeepSkyBlue, CC.FontSMALL)
				else
				DrawString(x1 -25, y1 + h * (i)+6, 0, C_WHITE, CC.FontSMALL)
				end
				local level = math.modf(p["武功等级" .. j] / 100) + 1
				if p["武功等级" .. j] == 999 then
					level = 11
				end
				local color1 = C_GOLD
				local color2 = C_ORANGE
				if JY.Person[id]["专1"] == wugong or JY.Person[id]["专2"] == wugong then
					  color1 = RGB(math.random(255), math.random(255), math.random(255))
					  color2 = RGB(math.random(255), math.random(255), math.random(255))
				end
				if match_ID(id,70) and wugong == 22 then
				DrawString(x1, y1 + h * (i), string.format("%s",  "般若掌"), color1, size)
				    if p["武功等级" .. j] > 900 then
					lib.SetClip(x1, y1 + h * 1, x1 + size + string.len(JY.Wugong[wugong]["名称"]) * size * (p["武功等级" .. j] - 900) / 200, y1 + h * (i) + h)
					DrawString(x1, y1 + h * (i), string.format("%s", "般若掌"), color2, size)
					lib.SetClip(0, 0, 0, 0)
				    end
				else
				DrawString(x1, y1 + h * (i), string.format("%s", JY.Wugong[wugong]["名称"]), color1, size)
				if p["武功等级" .. j] > 900 then
					lib.SetClip(x1, y1 + h * 1, x1 + size + string.len(JY.Wugong[wugong]["名称"]) * size * (p["武功等级" .. j] - 900) / 200, y1 + h * (i) + h)
					DrawString(x1, y1 + h * (i), string.format("%s", JY.Wugong[wugong]["名称"]), color2, size)
					lib.SetClip(0, 0, 0, 0)
				end
				end
				--等级
				DrawString(x1 + size * 8 + 9, y1 + h * (i), T[level], C_WHITE, size)
				--[[内耗
				local xh
				local CLR2 = MilkWhite
		        xh = math.modf((level + 3) / 2) * JY.Wugong[wugong]["消耗内力点数"]
				if xh >= 420 then
				   CLR2 = RGB(249, 76, 0)
				elseif xh >= 210 then
				   CLR2 = M_Yellow
				end
				if xh > 0 then
				DrawString(x1 + size * 6 -18, y1 + h * (i), xh, CLR2, size)
				else
				DrawString(x1 + size * 6 -18, y1 + h * (i), "", CLR2, size)
				end]]
				--冷却
				if JY.Wugong[wugong]["武功类型"] ~= 7 then
				local cd = KungfuCD(id, wugong)
				local lq = {"无","一","二","三","四","五","六","七","八"}
				DrawString(x1 + size * 6 -18, y1 + h * (i), " "..lq[cd+1], M_RoyalBlue, size)
				end
				--如果是特技，显示特技
				if secondary_wugong(wugong) then
					DrawString(x1 + size * 11 - 12, y1 + h * (i), "特技", M_PaleGreen, size)
				elseif thirdly_wugong(wugong) then
					DrawString(x1 + size * 11 - 12, y1 + h * (i), "惊人", C_RED, size)	
				--如果不是，则显示武功威力
				else
					--威力
					local wugongwl = get_skill_power(id, wugong, level)
					--区别天赋内外功的颜色
					local CLR = RGB(208, 152, 208)
					if wugong==68 and match_ID_awakened(id, 650, 1) and JY.Person[650]["声望"]>0 then
						DrawString(x1 + size * 9.5, y1 + h * (i), string.format("%4d",wugongwl), CLR, size)
						DrawString(x1 + size * 10.3, y1 + h * (i)+6, "    +"..JY.Person[650]["声望"], C_RED, size*0.7)
					else	
					if Given_WG(id, wugong) or Given_NG(id, wugong) then
						CLR = PinkRed
					--五岳剑法组合颜色
					elseif wugong >= 30 and wugong <= 34 and WuyueJF(id) then
						CLR = LightPurple
					--琴棋书画组合颜色
					elseif (wugong == 73 or wugong == 72 or wugong == 84 or wugong == 142) and QinqiSH(id) then
						CLR = LightPurple
					--桃花绝技组合颜色
					elseif (wugong == 12 or wugong == 18 or wugong == 38) and TaohuaJJ(id) then
						CLR = LightPurple
					--紫气天罗组合颜色
					elseif (wugong == 3 or wugong == 9 or wugong == 5 or wugong == 21 or wugong == 118 or wugong == 120 or wugong == 170) and ZiqiTL(id) then
						CLR = LightPurple
					--举火燎原组合颜色
					elseif (wugong == 61 or wugong == 65 or wugong == 66) and JuHuoLY(id) then
						CLR = LightPurple
					--利刃寒锋组合颜色
					elseif (wugong == 58 or wugong == 174 or wugong == 153) and LiRenHF(id) then
						CLR = LightPurple
					elseif (wugong == 197 or wugong == 200 ) then
						CLR = RGB(255, 220, 0)
					elseif YuzhouHH(id) then
					    CLR = M_MediumTurquoise	
					end
					if wugong ~= 217 and wugong ~= 199 then
					DrawString(x1 + size * 11 - 17, y1 + h * (i), string.format("%4d",wugongwl), CLR, size)
					end
					end
				end
			end
		end
		i = 14+math.max(0,JY.Person[671]["品德"]-13)
		if p["天赋内功"] ~= 0 then
			DrawString(x1 - size, y1 + h * (i), "天内", LightPurple, size)
			DrawString(x1 + size*1.8, y1 + h * (i), "|", LimeGreen, size)
			DrawString(x1 + size*2, y1 + h * (i), JY.Wugong[p["天赋内功"]]["名称"], TG_Red_Bright, size)
			i = i + 1
		end
		if p["天赋轻功"] ~= 0 then
			DrawString(x1 - size, y1 + h * (i), "天轻", LightPurple, size)
			DrawString(x1 + size*1.8, y1 + h * (i), "|", LimeGreen, size)
			DrawString(x1 + size*2, y1 + h * (i), JY.Wugong[p["天赋轻功"]]["名称"], M_DeepSkyBlue, size)
			i = i + 1
		end
		if p["天赋外功1"] ~= 0 then
			DrawString(x1 - size, y1 + h * (i), "天外", LightPurple, size)
			DrawString(x1 + size*1.8, y1 + h * (i), "|", LimeGreen, size)
			DrawString(x1 + size*2, y1 + h * (i), JY.Wugong[p["天赋外功1"]]["名称"], C_GOLD, size)
			--i = i + 1
		end
		if p["天赋外功2"] ~= 0 then
			--DrawString(x1, y1 + h * (i), "天赋外功", LightPurple, size)
			DrawString(x1 + size*7, y1 + h * (i), "|", LimeGreen, size)
			DrawString(x1 + size*7.2, y1 + h * (i), JY.Wugong[p["天赋外功2"]]["名称"], C_GOLD, size)
		end
		    i = i + 1
		if p["天赋外功3"] ~= 0 then
			--DrawString(x1 - size, y1 + h * (i), "天外", LightPurple, size)
			DrawString(x1 + size*1.8, y1 + h * (i), "|", LimeGreen, size)
			DrawString(x1 + size*2, y1 + h * (i), JY.Wugong[p["天赋外功3"]]["名称"], C_GOLD, size)
			--i = i + 1
		end
		if p["天赋外功4"] ~= 0 then
			--DrawString(x1, y1 + h * (i), "天赋外功", LightPurple, size)
			DrawString(x1 + size*7, y1 + h * (i), "|", LimeGreen, size)
			DrawString(x1 + size*7.2, y1 + h * (i), JY.Wugong[p["天赋外功4"]]["名称"], C_GOLD, size)
		end	
		
		x1 = dx - size *3 -10
		i = 19
		if case == nil then
			if JY.Status ~= GAME_WMAP then
				DrawString(x1-size*1.5, y1 + h * (i)+2, "上下键换人 →键人物感悟页面 Q键换装 ESC退出", LimeGreen, size*0.98)
			else
				DrawString(x1, y1 + h * (i)+2, "上下键换人 →键人物感悟页面 ESC退出", LimeGreen, size*0.98)
			end
		else
			DrawString(x1-size*1.5, y1 + h * (i)+2, "上下键选择属性 左右键减少/增加 回车键确认加点", LimeGreen, size*0.98)
		end
		--动画显示
		if dl then
			lib.PicLoadCache(97,(dl+AniFrame)*2,885,678)
		end
	--第二页
	elseif page == 2 then
		lib.LoadPNG(1, 1000 * 2 , 0 , 0, 1)
        x1 = size*2 + 10
		i = 0
		DrawString(x1+250, y1-10, p["姓名"].." 感悟点数： "..p["感悟"], C_ORANGE, size)
		for j = 1, 40 do
		    if p["人"..j] == 1 then
			lib.FillColor(SkillT[j][1], SkillT[j][2],SkillT[j][1]+50, SkillT[j][2]+50,RGB(255, 255, 255))
			end
			if SK == j then 
				
				DrawString(x1-40, y1+25, SkillT[j][3], LimeGreen, size*0.8)
				if j == 30 then
				DrawString(x1+70, y1+55, "(冰封：减少100攻击伤害，灼烧：承受100额外伤害，中毒：攻击杀气减半，内伤：被攻击集气减少200)", C_WHITE, size*0.6)
				end
				DrawString(x1-40, y1+55, SkillT[j][10].."感悟点", LightSkyBlue, size*0.8)
				DrawString(x1-40, y1+85, SkillT[j][9].."书", PinkRed, size*0.8)
				lib.FillColor(SkillT[j][1], SkillT[j][2],SkillT[j][1]+50, SkillT[j][2]+50,RGB(math.random(30,225),math.random(30,225),math.random(30,225)))
				if p["人"..SK] == 1 then
				DrawString(x1-40, y1+115, "已感悟", C_ORANGE, size*0.8)
				end
			end	
		end
        lib.LoadPNG(1, 1009 * 2 , 0 , 0, 1)
		y1 = y1 + h * 2
        if ST_selected == 0 then		
        DrawString(x1+80, 663, " ←键返回状态页面 →键显示人物天赋 空格键选择", LimeGreen, size*0.98)
		else
		DrawString(x1+80, 663, "方向键选择 空格键感悟 Backspace取消 Esc退出", LimeGreen, size*0.98)
		end
	elseif page == 3 then
		local y2 = y1
		lib.LoadPNG(1, 1000 * 2 , 0 , 0, 1)
		--上下翻的箭头显示
		if istart > 1 then
			DrawString(x1-size*2-7, y1+h, "↑", C_GOLD, size)
		end
		if istart < max_row then
			DrawString(x1-size*2-7, y1+18*h+12, "↓", C_GOLD, size)
		end
		local function strcolor_switch(s)
			local Color_Switch={{"Ｒ",PinkRed},{"Ｇ",C_GOLD},{"Ｂ",C_BLACK},{"Ｗ",C_WHITE},{"Ｏ",C_ORANGE},{"Ｌ",LimeGreen},{"Ｄ",M_DeepSkyBlue},{"Ｚ",Violet}}
			for i = 1, 8 do
				if Color_Switch[i][1] == s then
					return Color_Switch[i][2]
				end
			end
		end
		x1 = x1 - size
		local row = 1
		if JY.Person[JY.Base["畅想"]]["阶"] > 0 and id == 0 then
        DrawString(x1, y1, p["姓名"].."（"..Number[JY.Person[JY.Base["畅想"]]["阶"]].."阶）", C_ORANGE, size)
		elseif p["阶"] > 0 then
		DrawString(x1, y1, p["姓名"].."（"..Number[JY.Person[id]["阶"]].."阶）", C_ORANGE, size)
		else
		DrawString(x1, y1, p["姓名"], C_ORANGE, size)
		end
		if JY.Person[642]["血量翻倍"] == 1 then--		DrawString(x1+50, y1 + h * i, Number[JY.Person[id]["阶"]].."阶", C_GOLD, size)
		y2 = y2 + 13
			for i = istart, #TFJS[6000] do
				local tfstr = TFJS[6000][i]
				--控制显示行数
				if row < 20 then
					if string.sub(tfstr,1,2) == "Ｎ" then
						row = row + 1
					else
						local color;
						color = strcolor_switch(string.sub(tfstr,1,2))
						tfstr = string.sub(tfstr,3,-1)
						DrawString(x1, y2 + (h-2) * (row), tfstr, color, size*0.9)
						row = row + 1
					end
				end
			end
		elseif JY.Base["特殊"] ==1 and id==0 then

				y2 = y2 + 13
			local tfstr =" "
			if JY.Person[11]["血量翻倍"]==1 then
			tfstr="Ｒ风华正茂：升级时属性值大幅提高"
			elseif JY.Person[12]["血量翻倍"]==1 then
			tfstr="Ｒ厚德载物：升级时兵器值大幅提高"
			elseif JY.Person[13]["血量翻倍"]==1 then
			tfstr="Ｒ满腹经纶：修炼武功秘籍兵器值大幅提高"
			elseif JY.Person[14]["血量翻倍"]==1 then
			tfstr="Ｒ学富五车：修炼武功秘籍属性值大幅提高"
			elseif JY.Person[15]["血量翻倍"]==1 then
			tfstr="Ｒ英姿飒爽：食用千年人参属性值兵器值大幅提高"
			end
			tfstr = string.sub(tfstr,3,-1)
			DrawString(x1, y2 + (h-2) * (row), tfstr, LimeGreen, size*0.9)
			row = row + 1
			local tfstr =" "
			if JY.Person[16]["血量翻倍"]==1 then
			tfstr="Ｒ盖世神拳：每一个拳法到极，伤害提升1%、免伤提升1%"
			elseif JY.Person[17]["血量翻倍"]==1 then
			tfstr="Ｒ灵犀一指：每一个指法到极，封穴几率提高1%"
			elseif JY.Person[18]["血量翻倍"]==1 then
			tfstr="Ｒ剑神一笑：每一个剑法到极，集气速度+1"
			elseif JY.Person[19]["血量翻倍"]==1 then
			tfstr="Ｒ傲世狂刀：每一个刀法到极，受到伤害、杀气降低1%"
			elseif JY.Person[20]["血量翻倍"]==1 then
			tfstr="Ｒ奇门无双：每一个奇门到极，闪避率提高1%"
			end
			tfstr = string.sub(tfstr,3,-1)
			DrawString(x1, y2 + (h-2) * (row), tfstr, LimeGreen, size*0.9)
			row = row + 1
			local tfstr =" "
			if JY.Person[21]["血量翻倍"]==1 then
			tfstr="Ｒ无酒不欢：被攻击时有30%几率发动“酒神秘踪步”闪避"
			elseif JY.Person[22]["血量翻倍"]==1 then
			tfstr="Ｒ无喵不欢：战斗开始后的前三次被攻击不受伤害"
			elseif JY.Person[23]["血量翻倍"]==1 then
			tfstr="Ｒ无钱不欢：被攻击时消耗600银两免疫攻击"
			elseif JY.Person[24]["血量翻倍"]==1 then
			tfstr="Ｒ无女不欢：战场上我方女性角色越多，防御效果越高"
			elseif JY.Person[25]["血量翻倍"]==1 then
			tfstr="Ｒ无基不欢：战场上我方男性角色越多，防御效果越高"
			elseif JY.Person[41]["血量翻倍"]==1 then
			tfstr="Ｒ无爱不欢：不会被小动物伤害"
			end
			tfstr = string.sub(tfstr,3,-1)
			DrawString(x1, y2 + (h-2) * (row), tfstr, LimeGreen, size*0.9)
			row = row + 1	
			local tfstr =" "
			if JY.Person[26]["血量翻倍"]==1 then
			tfstr="Ｒ天下无双：必定单击，伤害永久提高25%"
			elseif JY.Person[27]["血量翻倍"]==1 then
			tfstr="Ｒ功德无量：攻击时根据道德追加真实伤害"
			elseif JY.Person[28]["血量翻倍"]==1 then
			tfstr="Ｒ至高无上：进入战斗初始集气值加250"
			elseif JY.Person[29]["血量翻倍"]==1 then
			tfstr="Ｒ走投无路：血量越低，行动后集气值越高"
			elseif JY.Person[30]["血量翻倍"]==1 then
			tfstr="Ｒ后继无人：战场上已方人员越少集气速度提升越多"
			end
			tfstr = string.sub(tfstr,3,-1)
			DrawString(x1, y2 + (h-2) * (row), tfstr, LimeGreen, size*0.9)
			row = row + 1	
			if JY.Person[31]["血量翻倍"]==1 then
			tfstr="Ｒ持之以恒：每行动一次，攻击效果提升5%"
			elseif JY.Person[32]["血量翻倍"]==1 then
			tfstr="Ｒ运筹帷幄：行动前有30%几率使敌方全体集气倒退100"
			elseif JY.Person[33]["血量翻倍"]==1 then
			tfstr="Ｒ放荡不羁：自带“放荡不羁”，提供300点气攻气防"
			elseif JY.Person[34]["血量翻倍"]==1 then
			tfstr="Ｒ睚眦必报：被攻击时，攻击方会损失其造成伤害15%的血量 "
			elseif JY.Person[35]["血量翻倍"]==1 then
			tfstr="Ｒ全力以赴：攻击追加1250点气攻 "
			end
			tfstr = string.sub(tfstr,3,-1)
			DrawString(x1, y2 + (h-2) * (row), tfstr, LimeGreen, size*0.9)
			row = row + 1	
			local tfstr =" "
			if JY.Person[36]["血量翻倍"]==1 then
			tfstr="Ｒ乘风破浪：攻击时敌方全体集气倒退50点"
			elseif JY.Person[37]["血量翻倍"]==1 then
			tfstr="Ｒ剑术通神：被攻击时按敌我御剑系数计算加成"
			elseif JY.Person[38]["血量翻倍"]==1 then
			tfstr="Ｒ枯木逢春：被攻击时恢复40点生命"
			elseif JY.Person[39]["血量翻倍"]==1 then
			tfstr="Ｒ怒发冲冠：时序增加1点怒气 "
			elseif JY.Person[40]["血量翻倍"]==1 then
			tfstr="Ｒ一柱擎天：攻击力防御力轻功提升10% "
			end
			tfstr = string.sub(tfstr,3,-1)
			DrawString(x1, y2 + (h-2) * (row), tfstr, LimeGreen, size*0.9)
			row = row + 1		
		else

		end
		if id==0 and TFJS[tfid] ~= nil and JY.Base["畅想"]==46 and JY.Person[642]["血量翻倍"] == 1 then
			y2 = y2 + 13
			for i = istart, #TFJS["46"] do
				local tfstr = TFJS["46"][i]
				--控制显示行数
				if row < 20 then
					if string.sub(tfstr,1,2) == "Ｎ" then
						row = row + 1
					else
						local color;
						color = strcolor_switch(string.sub(tfstr,1,2))
						tfstr = string.sub(tfstr,3,-1)
						DrawString(x1, y2 + (h-2) * (row), tfstr, color, size*0.9)
						row = row + 1
					end
				end
			end
			row = row + 1
		elseif TFJS[tfid] ~= nil then
		 y2 = y2 + 13
			for i = istart, #TFJS[tfid] do
				local tfstr = TFJS[tfid][i]
				--控制显示行数
				if row < 20 then
					if string.sub(tfstr,1,2) == "Ｎ" then
						row = row + 1
					else
						local color;
						color = strcolor_switch(string.sub(tfstr,1,2))
						tfstr = string.sub(tfstr,3,-1)
						DrawString(x1, y2 + (h-2) * (row), tfstr, color, size*0.9)
						row = row + 1
					end
				end
			end
			row = row + 1
		end
		--左慈
		if match_ID(id, 685) then
		  if JY.Person[685]["天1"] > 0 then
		  local str2, str3
		   if JY.Person[685]["天2"] > 0 then
		      str2 = "   "..JY.Person[JY.Person[685]["天2"]]["姓名"]
		   else
		      str2 = ""
		   end
		   if JY.Person[685]["天3"] > 0 then
		      str3 = "   "..JY.Person[JY.Person[685]["天3"]]["姓名"]
		   else
		      str3 = ""
		   end
		   DrawString(x1, y2 + (h-2) * (row), "已炼化角色："..JY.Person[JY.Person[685]["天1"]]["姓名"]..str2..str3, M_DeepSkyBlue, size)		
		   row = row + 2
		  end
		end
		--金庸
		if match_ID(id, 669) then
		local str = ""
		for i = 1, 5 do
		    if JY.Person[669]["地"..i] > 0 and JY.Person[669]["地"..i] < 999 then
			   DrawString(x1, y2 + (h-2) * (row), str..JY.Person[JY.Person[669]["地"..i]]["姓名"], M_DeepSkyBlue, size)
			   str = str.."          "
			end
		end
		str = ""
		row = row + 1
		for i = 6, 10 do
		    if JY.Person[669]["地"..i] > 0 and JY.Person[669]["地"..i] < 999 then
			   DrawString(x1, y2 + (h-2) * (row), str..JY.Person[JY.Person[669]["地"..i]]["姓名"], M_DeepSkyBlue, size)
			   str = str.."          "
			end
		end
		str = ""
		row = row + 1
		for i = 1, 4 do
		    if JY.Person[669]["天"..i] > 0 and JY.Person[669]["天"..i] < 999 then
			   DrawString(x1, y2 + (h-2) * (row), str..JY.Person[JY.Person[669]["天"..i]]["姓名"], M_DeepSkyBlue, size)
			   str = str.."          "
			end
		end	
		row = row + 1
		end
		if match_ID(id, 689) then
		local str = " ★ "
		local elm = {"冰：","雷：","火："}
		for i = 1, 3 do
		if JY.Person[689]["天"..i] > 0 then
		   for j = 1, JY.Person[689]["天"..i] do
               elm[i] = elm[i]..str
		   end   
		end
		end
		DrawString(x1, y2 + (h-2) * (row), elm[1], M_DeepSkyBlue, size)		
		row = row + 1
		DrawString(x1, y2 + (h-2) * (row), elm[2], M_Purple, size)		
		row = row + 1
		DrawString(x1, y2 + (h-2) * (row), elm[3], C_ORANGE, size)		
		row = row + 2
		end
		if JY.Person[0]["资质"] > 50 and JY.Person[0]["资质"] < 80 and id == 0 then
		local str = "集气速度+6，连击暴击率+15%，每领悟一个六如，集气速度+2，连击暴击率+3%"
		DrawString(x1, y2 + (h-2) * (row), "折中致和", C_RED, size*0.9)
		row = row + 1
		DrawString(x1, y2 + (h-2) * (row), str, C_WHITE, size*0.9)
		row = row + 1
		end
		if JY.Person[670]["无用"] == 1 and id == 0 then
		local str = "属性成长每级减少一点，自带10%减伤，1000气防，防御效果提升25%"
		DrawString(x1, y2 + (h-2) * (row), "稳如泰山", C_RED, size*0.9)
		row = row + 1
		DrawString(x1, y2 + (h-2) * (row), str, C_WHITE, size*0.9)
		row = row + 1
		end
		if JY.Person[670]["无用"] == 2 and id == 0 then
		local str = "生命硬上限-20%，秘籍获得的五系和三围额外+1，五系上限+80，伤害提升10%"
		DrawString(x1, y2 + (h-2) * (row), "颖悟绝伦", C_RED, size*0.9)
		row = row + 1
		DrawString(x1, y2 + (h-2) * (row), str, C_WHITE, size*0.9)
		row = row + 1
		end
		row = row + 1
		if JY.Person[id]["内力性质"] < 0 then
		local str = "所有武功威力提高150"
		DrawString(x1, y2 + (h-2) * (row), str, C_ORANGE, size*0.9)
		row = row + 1
		elseif JY.Person[id]["内力性质"] > 0 then
		local str = "气防提高500"
		DrawString(x1, y2 + (h-2) * (row), str, C_ORANGE, size*0.9)
		row = row + 1
		elseif JY.Person[id]["内力性质"] == 0 then
		local str = "集气速度+5"
		DrawString(x1, y2 + (h-2) * (row), str, C_ORANGE, size*0.9)
		row = row + 1
		end		
		row = row + 1
		if ZhiYZR(id) > 0 then
		local str = "至阴至柔："..Number[ZhiYZR(id)]
		DrawString(x1, y2 + (h-2) * (row), str, M_RoyalBlue, size*0.9)
		row = row + 1
		end
		if ZhiGZY(id) > 0 then
		local str = "至刚至阳："..Number[ZhiGZY(id)]
		DrawString(x1, y2 + (h-2) * (row), str, M_DarkOrange, size*0.9)
		row = row + 1
		end
		if GangRBJ(id) > 0 then
		local str = "刚柔并济："..Number[GangRBJ(id)]
		DrawString(x1, y2 + (h-2) * (row), str, M_White, size*0.9)
		row = row + 1
		end
		if JY.Base["特殊"] == 3 and JY.Person[92]["天1"] == 1 and id == 0 then
		DrawString(x1, y2 + (h-2) * (row), "破邪之证", RGB(math.random(255), math.random(255), math.random(255)), size*1.05)
		row = row + 2
		end
		for a = 1, 10 do				
		for b = 1, 8 do	
		   if p["地"..a] == b then
		   local stri = tf[a][b][1]
		   local colr = LimeGreen
		   if p["地"..a] == 8 then
		      colr = C_RED
		   end
		   DrawString(x1, y2 + (h-2) * (row), stri, colr, size*0.9)
		   row = row + 1
		   end
		end
		end
		row = row + 1   
		--主角额外显示
		if id == 0 then
			if TFJS[tfid] == nil then
				y2 = y2 + 13
			end
			for i = 1, #ZJZSJS do
				local zjstr = ZJZSJS[i]
				--控制显示行数
				if row < 20 then
					if string.sub(zjstr,1,2) == "Ｎ" then
						row = row + 1
					else
						local color;
						color = strcolor_switch(string.sub(zjstr,1,2))
						zjstr = string.sub(zjstr,3,-1)
						DrawString(x1, y2 + (h-2) * (row), zjstr, color, size*0.9)
						row = row + 1
					end
				end
			end
		end
		x1 = dx - size *6 -10
		y1 = size*2
		i = 19
		DrawString(x1, y1 + h * (i)+2, "上下键浏览 ←键人物感悟页面 →键进入AI设定 ESC退出", LimeGreen, size*0.98)
	--AI设定页面
	elseif page == 4 then
		lib.LoadPNG(1, 1000 * 2 , 0 , 0, 1)
		
		local wg_color1 = C_WHITE
		local wg_color2 = C_ORANGE
		if JY.Status == GAME_WMAP then
			wg_color1 = M_DimGray
			wg_color2 = M_DimGray
		end
		
		x1 = size*2 + 10
		i = 0
		DrawString(x1, y1, p["姓名"].." AI设定", C_ORANGE, size)

		y1 = y1 + h * 2
		local AI_s1_name = {"行为模式","优先使用","主运内功","主运轻功","是否吃药","生命阈值","内力阈值","体力阈值","禁用AI"}
		for j = 1, 9 do
			local color = LimeGreen
			if AI_s1 == j then
				color = C_GOLD
				DrawString(x1-size-2, y1 + h * (j-1)*2, "☆", color, size)
			end
			if JY.Status == GAME_WMAP and (j == 3 or j == 4) then
				color = M_DimGray
			end
			DrawString(x1, y1 + h * (j-1)*2, AI_s1_name[j], color, size)
		end
		local AI_1_s2_name = {"自动攻击","自动防御","原地休息","逃离休息"}
		for j = 1, 4 do
			local color = C_WHITE
			if AI_s2[1] == j then
				color = C_ORANGE
			end
			DrawString(x1+h*5*j, y1 + h * (i), AI_1_s2_name[j], color, size)
		end
		i = i + 2
		if p["优先使用"] == 0 then
			DrawString(x1+h*5, y1 + h * (i), "未设定", C_WHITE, size)
		else
			DrawString(x1+h*5, y1 + h * (i), JY.Wugong[p["优先使用"]]["名称"], C_ORANGE, size)
		end
		i = i + 2
		if p["主运内功"] == 0 then
			DrawString(x1+h*5, y1 + h * (i), "未设定", wg_color1, size)
		else
			DrawString(x1+h*5, y1 + h * (i), JY.Wugong[p["主运内功"]]["名称"], wg_color2, size)
		end
		i = i + 2
		if p["主运轻功"] == 0 then
			DrawString(x1+h*5, y1 + h * (i), "未设定", wg_color1, size)
		else
			DrawString(x1+h*5, y1 + h * (i), JY.Wugong[p["主运轻功"]]["名称"], wg_color2, size)
		end
		i = i + 2
		local AI_5_s2_name = {"是","否"}
		for j = 1, 2 do
			local color = C_WHITE
			if AI_s2[5] == j then
				color = C_ORANGE
			end
			DrawString(x1+h*5*j, y1 + h * (i), AI_5_s2_name[j], color, size)
		end
		i = i + 2
		local AI_6_s2_name = {"70%","50%","30%"}
		for j = 1, 3 do
			local color = C_WHITE
			if AI_s2[6] == j then
				color = C_ORANGE
			end
			DrawString(x1+h*5*j, y1 + h * (i), AI_6_s2_name[j], color, size)
		end
		i = i + 2
		local AI_7_s2_name = {"70%","50%","30%"}
		for j = 1, 3 do
			local color = C_WHITE
			if AI_s2[7] == j then
				color = C_ORANGE
			end
			DrawString(x1+h*5*j, y1 + h * (i), AI_7_s2_name[j], color, size)
		end
		i = i + 2
		local AI_8_s2_name = {"50","30","10"}
		for j = 1, 3 do
			local color = C_WHITE
			if AI_s2[8] == j then
				color = C_ORANGE
			end
			DrawString(x1+h*5*j, y1 + h * (i), AI_8_s2_name[j], color, size)
		end
		i = i + 2
		local AI_9_s2_name = {"是","否"}
		for j = 1, 2 do
			local color = C_WHITE
			if AI_s2[9] == j then
				color = C_ORANGE
			end
			DrawString(x1+h*5*j, y1 + h * (i), AI_9_s2_name[j], color, size)
		end
		
		if AI_menu_selected == 1 or AI_menu_selected > 4 then
			DrawString(x1+h*5*(AI_s2[AI_menu_selected])-h, y1 + h * (AI_menu_selected-1)*2+2, "→", C_ORANGE, size*0.98)
		end
		
		if AI_menu_selected > 1 and AI_menu_selected < 5 then
			DrawString(x1+h*4, y1 + h * (AI_menu_selected-1)*2+2, "←", C_ORANGE, size*0.98)
			DrawString(x1+h*9+12, y1 + h * (AI_menu_selected-1)*2+2, "→", C_ORANGE, size*0.98)
		end

		x1 = dx - size *5 -15
		y1 = size*2
		i = 19
		if AI_menu_selected > 0 then
			x1 = dx - 15
			DrawString(x1, y1 + h * (i)+2, "左右键选择 回车/ESC键确认", LimeGreen, size*0.98)
		else
			DrawString(x1, y1 + h * (i)+2, "上下键选择 回车键确认 ←键返回天赋页面 ESC退出", LimeGreen, size*0.98)
		end
	end
end

--计算人物修炼成功需要的点数
--id 人物id
function TrainNeedExp(id)         --计算人物修炼物品成功需要的点数
    local thingid=JY.Person[id]["修炼物品"];
	local r =0;
	if thingid >= 0 then
        if JY.Thing[thingid]["练出武功"] >=0 then
            local level=0;          --此处的level是实际level-1。这样没有武功時和炼成一级是一样的。
			for i =1,JY.Person[671]["品德"] do               -- 查找当前已经炼成武功等级
			    if JY.Person[id]["武功" .. i]==JY.Thing[thingid]["练出武功"] then
                    level=math.modf(JY.Person[id]["武功等级" .. i] /100);
					break;
                end
            end
			if level <9 then
                r=math.modf((5-math.modf(JY.Person[id]["资质"]/25))*JY.Thing[thingid]["需经验"]*(level+1)*0.5);
			else
                r=math.huge;
			end
		else
            r=(5-math.modf(JY.Person[id]["资质"]/25))*JY.Thing[thingid]["需经验"];
		end
	end
    return r;
end

--医疗菜单
function Menu_Doctor()       --医疗菜单
    DrawStrBox(CC.MainSubMenuX,CC.MainSubMenuY,"谁要使用医术",C_WHITE,CC.DefaultFont);
	local nexty=CC.MainSubMenuY+CC.SingleLineHeight;
    DrawStrBox(CC.MainSubMenuX,nexty,"医疗能力",C_ORANGE,CC.DefaultFont);

	local menu1={};
	for i=1,CC.TeamNum do
        menu1[i]={"",nil,0};
		local id=JY.Base["队伍" .. i]
        if id >=0 then
            if JY.Person[id]["医疗能力"]>=20 then
                 menu1[i][1]=string.format("%-10s%4d",JY.Person[id]["姓名"],JY.Person[id]["医疗能力"]);
                 menu1[i][3]=1;
            end
        end
	end

    local id1,id2;
	nexty=nexty+CC.SingleLineHeight;
    local r=ShowMenu(menu1,CC.TeamNum,0,CC.MainSubMenuX,nexty,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE);

    if r >0 then
	    id1=JY.Base["队伍" .. r];
        Cls(CC.MainSubMenuX,CC.MainSubMenuY,CC.ScreenW,CC.ScreenH);
        DrawStrBox(CC.MainSubMenuX,CC.MainSubMenuY,"要医治谁",C_WHITE,CC.DefaultFont);
        nexty=CC.MainSubMenuY+CC.SingleLineHeight;

		local menu2={};
		for i=1,CC.TeamNum do
			menu2[i]={"",nil,0};
			local id=JY.Base["队伍" .. i]
			if id>=0 then
				 menu2[i][1]=string.format("%-10s%4d/%4d",JY.Person[id]["姓名"],JY.Person[id]["生命"],JY.Person[id]["生命最大值"]);
				 menu2[i][3]=1;
			end
		end

		local r2=ShowMenu(menu2,CC.TeamNum,0,CC.MainSubMenuX,nexty,0,0,1,1,CC.DefaultFont,C_ORANGE,C_WHITE);

		if r2 >0 then
	        id2=JY.Base["队伍" .. r2];
            local num=ExecDoctor(id1,id2);
			if num>0 then
                AddPersonAttrib(id1,"体力",-2);
			end
            DrawStrBoxWaitKey(string.format("%s 生命增加 %d",JY.Person[id2]["姓名"],num),C_ORANGE,CC.DefaultFont);
		end
	end

	Cls();
    return 0;
end

--解毒
function Menu_DecPoison()         --解毒
    DrawStrBox(CC.MainSubMenuX,CC.MainSubMenuY,"谁要帮人解毒",C_WHITE,CC.DefaultFont);
	local nexty=CC.MainSubMenuY+CC.SingleLineHeight;
    DrawStrBox(CC.MainSubMenuX,nexty,"解毒能力",C_ORANGE,CC.DefaultFont);

	local menu1={};
	for i=1,CC.TeamNum do
        menu1[i]={"",nil,0};
		local id=JY.Base["队伍" .. i]
        if id>=0 then
            if JY.Person[id]["解毒能力"]>=20 then
                 menu1[i][1]=string.format("%-10s%4d",JY.Person[id]["姓名"],JY.Person[id]["解毒能力"]);
                 menu1[i][3]=1;
            end
        end
	end

    local id1,id2;
 	nexty=nexty+CC.SingleLineHeight;
    local r=ShowMenu(menu1,CC.TeamNum,0,CC.MainSubMenuX,nexty,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE);

    if r >0 then
	    id1=JY.Base["队伍" .. r];
         Cls(CC.MainSubMenuX,CC.MainSubMenuY,CC.ScreenW,CC.ScreenH);
        DrawStrBox(CC.MainSubMenuX,CC.MainSubMenuY,"替谁解毒",C_WHITE,CC.DefaultFont);
		nexty=CC.MainSubMenuY+CC.SingleLineHeight;

        DrawStrBox(CC.MainSubMenuX,nexty,"中毒程度",C_WHITE,CC.DefaultFont);
	    nexty=nexty+CC.SingleLineHeight;

		local menu2={};
		for i=1,CC.TeamNum do
			menu2[i]={"",nil,0};
			local id=JY.Base["队伍" .. i]
			if id>=0 then
				 menu2[i][1]=string.format("%-10s%5d",JY.Person[id]["姓名"],JY.Person[id]["中毒程度"]);
				 menu2[i][3]=1;
			end
		end

		local r2=ShowMenu(menu2,CC.TeamNum,0,CC.MainSubMenuX,nexty,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE);
		if r2 >0 then
	        id2=JY.Base["队伍" .. r2];
            local num=ExecDecPoison(id1,id2);
            DrawStrBoxWaitKey(string.format("%s 中毒程度减少 %d",JY.Person[id2]["姓名"],num),C_ORANGE,CC.DefaultFont);
		end
	end
    Cls();
    ShowScreen();
    return 0;
end

--解毒
--id1 解毒id2, 返回id2中毒减少点数
function ExecDecPoison(id1,id2)     --执行解毒
    local add=JY.Person[id1]["解毒能力"];
    local value=JY.Person[id2]["中毒程度"];

    if value > add+20 then
        return 0;
	end

 	add=limitX(math.modf(add/3)+Rnd(10)-Rnd(10),0,value);
    return -AddPersonAttrib(id2,"中毒程度",-add);
end


--显示物品菜单
function SelectThing(thing,thingnum)    

	local xnum=CC.MenuThingXnum;
	local ynum=CC.MenuThingYnum;

	local w=CC.ThingPicWidth*xnum+(xnum-1)*CC.ThingGapIn+2*CC.ThingGapOut;  --总体宽度
	local h=CC.ThingPicHeight*ynum+(ynum-1)*CC.ThingGapIn+2*CC.ThingGapOut; --物品栏高度

	local dx=(CC.ScreenW-w)/2;
	local dy=(CC.ScreenH-h-2*(CC.ThingFontSize+2*CC.MenuBorderPixel+8))/2-CC.ThingFontSize-11;

	local y1_1,y1_2,y2_1,y2_2,y3_1,y3_2;                  --名称，说明和图片的Y坐标

	local cur_line=0;
	local cur_x=0;
	local cur_y=0;
	local cur_thing=-1;
	
	--无酒不欢：记录最初的物品
	local original_thing = {}
	local original_thingnum = {}
	if IsViewingKungfuScrolls == 1 then
		original_thing = thing
		original_thingnum = thingnum
	end
	
	while true do
		if JY.Restart == 1 then
			break
		end
		Cls();
		y1_1=dy;
		y1_2=y1_1+CC.ThingFontSize+2*CC.MenuBorderPixel;
		--DrawBox(dx,y1_1,dx+w,y1_2,C_WHITE);
		y2_1=y1_2+5
		y2_2=y2_1+CC.ThingFontSize+2*CC.MenuBorderPixel
		--DrawBox(dx,y2_1,dx+w,y2_2,C_WHITE);
		y3_1=y2_2+5;
		y3_2=y3_1+h;
		--DrawBox(dx,y3_1,dx+w,y3_2,C_WHITE);
		lib.LoadPNG(1, 1004 * 2 , 0 , 0, 1)

		for y=0,ynum-1 do
			for x=0,xnum-1 do
				local id=y*xnum+x+xnum*cur_line
				local boxcolor;
				--选中物品颜色
				if x==cur_x and y==cur_y then
					boxcolor=S_Yellow;
					if thing[id]>=0 then
						cur_thing=thing[id];
						local str=JY.Thing[thing[id]]["名称"];
						--装备等级显示
						if JY.Thing[thing[id]]["装备类型"] > -1 then
							str = str .." LV."..JY.Thing[thing[id]]["装备等级"]
						end
						if JY.Thing[thing[id]]["类型"]==1 or JY.Thing[thing[id]]["类型"]==2 then
							if JY.Thing[thing[id]]["使用人"] >=0 then
								str=str .. "(" .. JY.Person[JY.Thing[thing[id]]["使用人"]]["姓名"] .. ")";
							end
						end
						str=string.format("%s X %d",str,thingnum[id]);
						local str2=JY.Thing[thing[id]]["物品说明"];
						if thing[id]==182 then
							str2=str2..string.format('(人%3d,%3d)',JY.Base['人X'],JY.Base['人Y'])
						end
						DrawString(dx+CC.ThingGapOut,y1_1+CC.MenuBorderPixel,str,C_GOLD,CC.ThingFontSize);
						DrawString(dx+CC.ThingGapOut,y2_1+CC.MenuBorderPixel,str2,C_ORANGE,CC.ThingFontSize);
						local myfont=CC.FontSmall
						local mx, my = dx + 4 * myfont, y3_2 + 2
						local myflag=0
						local myThing=JY.Thing[thing[id]]
								
						--物品说明显示
						local function drawitem(ss,str,news)
							local color = C_GOLD
							local mys
							if str==nil then
								mys=ss
							elseif myThing[ss]~=0 then
								if news==nil then
									if myflag==0 then
										--无酒不欢：装备的数值随等级变化
										if myThing["装备类型"] > -1 then
											local attr_gain = 0;
											if myThing[ss] > 0 then
												attr_gain = myThing[ss]*10 + myThing[ss]*(myThing["装备等级"]-1)*2
											elseif myThing[ss] < 0 then
												attr_gain = myThing[ss]*10 - myThing[ss]*(myThing["装备等级"]-1)*2
											end
											if attr_gain ~= 0 then
												mys=string.format(str..':%+d',attr_gain)
											end
										else
											mys=string.format(str..':%+d',myThing[ss])
										end
									elseif myflag==1 then
										mys=string.format(str..':%d',myThing[ss])
									end
								else
									if myThing[ss]<0 then
										return
									end
									mys=string.format(str..':%s',news[myThing[ss]])
								end
								--内属颜色
								if ss=="需内力性质" then
									--color = RGB(236, 200, 40)
									color = RGB(210+myThing[ss]*5, 189-myThing[ss]*9, 109-myThing[ss]*10)
								end	
								if ss=="需阴" then
								mys=string.format(str..':%s',news[myThing[ss]])
								--olor = RGB(208, 152, 208)
								color = RGB(127-myThing[ss]*9, 198-myThing[ss]*16, 216+myThing[ss]*2)
								end
							elseif myThing[ss]==0 and (ss=="需内力性质" or ss=="需阴") then
							       mys=string.format(str..':%s',news[myThing[ss]]) 
								   color = RGB(236, 236, 236)	
							
							else
								return
							end
							
							if mys ~= nil then
								local mylen = myfont * string.len(mys) / 2 + 12
								if CC.ScreenW - dx < mx + mylen then
									my = my + myfont + 10
									mx = dx + 4 * myfont
								end
								DrawString(mx+CC.MenuBorderPixel,my+CC.MenuBorderPixel,mys,color,myfont)
								mx=mx+mylen
							end
						end
					  
						--苍天泰坦：同样是老二
						if myThing["练出武功"] > 0 then
							local kfname = "习得:" .. JY.Wugong[myThing["练出武功"]]["名称"]
							DrawString(mx+CC.MenuBorderPixel, my+CC.MenuBorderPixel, kfname, C_GOLD, myfont)
							mx = mx + myfont * string.len(kfname) / 2 + 12
						end
													
						if myThing['类型']>0 then
							drawitem('加生命','生命')
							if myThing["代号"] == 0 then
							   drawitem('已损失生命值6%')
							end
							
							if myThing["代号"] == 1 then
							   drawitem('最大生命值10%')
							end
							
							if myThing["代号"] == 2 then
							   drawitem('已损失生命值35%')
							end
							
							if myThing["代号"] == 7 then
							   drawitem('最大内力值5%')
							end
							
							if myThing["代号"] == 8 then
							   drawitem('最大生命值20%')
							end
							drawitem('加生命最大值','生命最值')
							drawitem('加中毒解毒','中毒')
							drawitem('加体力','体力')
							if myThing['改变内力性质']==2 then
								drawitem('洗精伐髓')
							end
							if myThing["代号"] == 329 then
							    drawitem('暗器:+3 暗器伤害额外增加')
							end
							if myThing["代号"] == 330 then
							    drawitem('暗器:+3 暗器伤害倍数提高')
							end
							if myThing["代号"] == 331 then
							    drawitem('暗器:+3 暗器范围扩大')
							end
							if myThing["代号"] == 357 then
							    drawitem('暗器:+3 霹雳弹会造成目标周围五格范围伤害')
							end
							if myThing["代号"] == 118 then
							    drawitem('五系兵器值+1 习得斗转星移')
							end
							if myThing["代号"] == 351 then
							    drawitem('紫气天罗组合武功数量要求-1')
							end
							if myThing["代号"] == 352 then
							    drawitem('所有组合武功数量要求-1')
							end
							if myThing["代号"] == 361 then
							    drawitem('实战提升100点')
							end
							
							drawitem('加内力','内力')
							if myThing["代号"] == 3 or myThing["代号"] == 4 then
							   drawitem('最大内力值10%')
							end
							
							if myThing["代号"] == 5 or myThing["代号"] == 7 then
							   drawitem('最大内力值15%')
							end
							if myThing["代号"] == 6 then
							   drawitem('最大内力值30%')
							end
							
							drawitem('加内力最大值','内力最值')
							drawitem('加攻击力','攻击')
							drawitem('加轻功','轻功')
							drawitem('加防御力','防御')
							drawitem('加医疗能力','医疗')
							drawitem('加用毒能力','用毒')
							drawitem('加解毒能力','解毒')
							drawitem('加抗毒能力','抗毒')
							drawitem('加拳掌功夫','拳掌')
							drawitem('加指法技巧','指法')
							drawitem('加御剑能力','御剑')
							drawitem('加耍刀技巧','耍刀')
							drawitem('加特殊兵器','特殊')
							drawitem('加暗器技巧','暗器')
							drawitem('加武学常识','武常')
							drawitem('加品德','品德')
							drawitem('加攻击次数','左右',{[0]='否','是'})
							drawitem('加攻击带毒','带毒')
							if JY.Thing[myThing["代号"]]["练出武功"] > 0 and JY.Wugong[JY.Thing[myThing["代号"]]["练出武功"]]["武功类型"] < 7 then
							local lq = {"无","一","二","三","四","五","六","七","八","九"}
							local cd = JY.Wugong[JY.Thing[myThing["代号"]]["练出武功"]]["冷却"]
							--drawitem('冷却:'..lq[cd+1])
							DrawString(mx+CC.MenuBorderPixel,my+CC.MenuBorderPixel,'冷却:'..lq[cd+1],M_RoyalBlue,myfont)
							end
							--武器装备威力加成
							for i,v in ipairs(CC.ExtraOffense) do
								if v[1] == thing[id] and thing[id] ~= 344 then
									DrawString(mx+CC.MenuBorderPixel,my+CC.MenuBorderPixel,"威力强化:"..JY.Wugong[v[2]]["名称"].."+"..v[3],PinkRed,myfont)
								end
								
							end
							if thing[id] == 344 then
								DrawString(mx+CC.MenuBorderPixel,my+CC.MenuBorderPixel,"威力强化:所有枪法+300",PinkRed,myfont)
							end
							if thing[id] == 360 then
								DrawString(mx+CC.MenuBorderPixel,my+CC.MenuBorderPixel,"威力强化:所有刀法+"..JY.Thing[360]["装备等级"]*40,PinkRed,myfont)
							end
							if thing[id] == 362 then
								DrawString(mx+CC.MenuBorderPixel,my+CC.MenuBorderPixel,"威力强化:所有剑法+"..JY.Thing[362]["装备等级"]*40,PinkRed,myfont)
							end
							
							if mx~=dx or my~=y3_2+2 then
								if (thing[id] < 305 or thing[id] > 307) and (thing[id] < 333 or thing[id] > 336) and (thing[id] < 340 or thing[id] > 342) then	--特殊药品不显示
									DrawString(dx+CC.MenuBorderPixel, y3_2 + 2+CC.MenuBorderPixel, " 效果:", LimeGreen, myfont)
								end
							end
						end
						
						--装备类和秘籍类
						if myThing['类型']==1 or myThing['类型']==2 then
							if mx~=dx then
								mx=dx+4*myfont
								my=my+myfont+3
							end
							myflag=1
							local my2=my
							if myThing['仅修炼人物']>-1 then
								drawitem('仅限:'..JY.Person[myThing['仅修炼人物']]['姓名'])
							end
							--drawitem('需内力性质','内属',{[0]='阴九','阳','不限'})

							
							drawitem('需内力性质','阳', {[0]="不限","一","二","三","四","五","六","七","八","九"})
							drawitem('需阴','阴', {[0]="不限","一","二","三","四","五","六","七","八","九"})
							if JY.Thing[myThing["代号"]]["练出武功"] > 0 and JY.Wugong[JY.Thing[myThing["代号"]]["练出武功"]]["啊"] ~= 0 then
							local ns = {"一","二","三","四","五","六","七","八","九"}							
							local p = JY.Wugong[JY.Thing[myThing["代号"]]["练出武功"]]["啊"]
							
							if p > 0 then
							   drawitem('内属改变:阳'..ns[p])
							else
							   drawitem('内属改变:阴'..ns[-p])
							end
							
							end
							if myThing["代号"] == 85 or myThing["代号"] == 80 or myThing["代号"] == 64 or myThing["代号"] == 295 or myThing["代号"] == 97 
							or myThing["代号"] == 115 or myThing["代号"] == 68 or myThing["代号"] == 74 or myThing["代号"] == 75 or myThing["代号"] == 176 then
							   drawitem('内属改变:阴一')
							   drawitem('内属改变:阳一')
							end
							
							drawitem('需内力','内力')
							drawitem('需攻击力','攻击')
							drawitem('需轻功','轻功')
							drawitem('需用毒能力','用毒')
							drawitem('需医疗能力','医疗')
							drawitem('需解毒能力','解毒')
							drawitem('需拳掌功夫','拳掌')
							drawitem('需指法技巧','指法')
							drawitem('需御剑能力','御剑')
							drawitem('需耍刀技巧','耍刀')
							drawitem('需特殊兵器','特殊')
							drawitem('需暗器技巧','暗器')
							--斗转的显示
							if thing[id] == 118 then
								local exstr = "五系兵器值之和>=150 "
								local mylen = myfont * string.len(exstr) / 2 + 12
								DrawString(mx+CC.MenuBorderPixel,my+CC.MenuBorderPixel,exstr,C_GOLD,myfont)
								mx=mx+mylen
							end
							--圣火令
							if thing[id] == 337 then
								local exstr = "学有圣火神功"
								local mylen = myfont * string.len(exstr) / 2 + 12
								DrawString(mx+CC.MenuBorderPixel,my+CC.MenuBorderPixel,exstr,C_GOLD,myfont)
								mx=mx+mylen
							end
							--阴阳的显示
							if thing[id] == 176 then
								local exstr = "御剑/耍刀/特殊任一项>=70 "
								local mylen = myfont * string.len(exstr) / 2 + 12
								DrawString(mx+CC.MenuBorderPixel,my+CC.MenuBorderPixel,exstr,C_GOLD,myfont)
								mx=mx+mylen
							end
							--金丝手套的显示
							if thing[id] == 239 then
								local exstr = "拳掌或指法>=70 "
								local mylen = myfont * string.len(exstr) / 2 + 12
								DrawString(mx+CC.MenuBorderPixel,my+CC.MenuBorderPixel,exstr,C_GOLD,myfont)
								mx=mx+mylen
							end
							--七宝指环的显示
							if thing[id] == 200 then
								local exstr = "拳掌或指法>=80 "
								local mylen = myfont * string.len(exstr) / 2 + 12
								DrawString(mx+CC.MenuBorderPixel,my+CC.MenuBorderPixel,exstr,C_GOLD,myfont)
								mx=mx+mylen
							end
							drawitem('需资质','资质')
							drawitem('需经验','修炼经验')
							if mx~=dx or my~=my2 then
								DrawString(dx+CC.MenuBorderPixel,my2+CC.MenuBorderPixel,' 需求:',LimeGreen,myfont)
							end
						end
						
						--特效说明
						if myThing['是否特效'] == 1 and (WPTX[thing[id]][myThing['装备等级']] ~= nil or myThing['装备类型'] == -1) then
							if mx~=dx then
								mx=dx+4*myfont
								my=my+myfont+3
							end
							local my2=my
							if mx~=dx or my~=my2 then
								DrawString(dx+CC.MenuBorderPixel,my2+CC.MenuBorderPixel,' 特效:',C_RED,myfont)
							end
							if myThing['装备类型'] > -1 then
								local TXstr = WPTX[thing[id]][myThing['装备等级']]
								--复活戒指的耐久度
								if thing[id] == 303 then
									TXstr = TXstr.."（剩余"..JY.Person[651]["品德"].."次）"
								end
								DrawString(dx+CC.MenuBorderPixel+myfont*4,my2+CC.MenuBorderPixel, TXstr, M_DeepSkyBlue,myfont)
							else
								DrawString(dx+CC.MenuBorderPixel+myfont*4,my2+CC.MenuBorderPixel, WPTX[thing[id]], M_DeepSkyBlue,myfont)
							end
						end
					else
						cur_thing=-1;
					end
				else
					boxcolor=C_BLACK;
				end
		  
				local boxx = dx + CC.ThingGapOut + x * (CC.ThingPicWidth + CC.ThingGapIn)
				local boxy = y3_1 + CC.ThingGapOut + y * (CC.ThingPicHeight + CC.ThingGapIn)

				if thing[id] >= 0 then
					lib.PicLoadCache(2, thing[id] * 2, boxx + 1, boxy + 1, 1)
				end
				--无酒不欢：修改选择框
				if boxcolor == S_Yellow then
					DrawSingleLine(boxx+2, boxy+1, boxx + CC.ThingPicWidth/4, boxy+1, boxcolor)
					DrawSingleLine(boxx+2+ CC.ThingPicWidth*3/4, boxy+1, boxx + CC.ThingPicWidth, boxy+1, boxcolor)
					DrawSingleLine(boxx+2, boxy+1, boxx+2, boxy + CC.ThingPicHeight/4 - 1, boxcolor)
					DrawSingleLine(boxx + CC.ThingPicWidth-1, boxy+2, boxx + CC.ThingPicWidth-1, boxy + CC.ThingPicHeight/4 - 1, boxcolor)
					DrawSingleLine(boxx+2, boxy+2+CC.ThingPicHeight*3/4, boxx+2, boxy + CC.ThingPicHeight - 1, boxcolor)
					DrawSingleLine(boxx + CC.ThingPicWidth-1, boxy+2+CC.ThingPicHeight*3/4, boxx + CC.ThingPicWidth-1, boxy + CC.ThingPicHeight - 1, boxcolor)
					DrawSingleLine(boxx+1, boxy + CC.ThingPicHeight - 1, boxx + CC.ThingPicWidth/4, boxy + CC.ThingPicHeight - 1, boxcolor)
					DrawSingleLine(boxx+2+ CC.ThingPicWidth*3/4, boxy + CC.ThingPicHeight - 1, boxx + CC.ThingPicWidth-1, boxy + CC.ThingPicHeight - 1, boxcolor)
				end
			end
		end
		
		DrawString(CC.ScreenW-220,CC.ScreenH-40, "按F1查看详细说明", C_ORANGE,CC.Fontsmall)
		
		if IsViewingKungfuScrolls > 0 then
			local list = {"1:全部","2:拳法","3:指法","4:剑法","5:刀法","6:奇门","7:内轻","8:杂学"}
			local space = 0
			local h = 0
			for i = 1, 8 do
				local color = C_GOLD
				if i == IsViewingKungfuScrolls then
					color = C_RED
				end
				if i == 5 then
					space = 0
					h = 40
				end
				space = space + 81
				DrawString(CC.ScreenW-405 + space ,15 + h, list[i], color,CC.Fontsmall)
			end
		end

		ShowScreen();
  	
		local keypress, ktype, mx, my = WaitKey(1)
		lib.Delay(CC.Frame);
		if keypress==VK_ESCAPE or ktype == 4 then
			cur_thing=-1;
			break;
		elseif keypress==VK_RETURN or keypress==VK_SPACE then
			break;
		--增加物品的内置说明
		elseif keypress==VK_F1 and cur_thing ~= -1 then
			detailed_info(cur_thing)
		--数字1 全部
		elseif IsViewingKungfuScrolls > 0 and keypress==49 then
			thing = original_thing
			thingnum = original_thingnum
			cur_line=0
			cur_x=0
			cur_y=0
			cur_thing=-1
			IsViewingKungfuScrolls = 1
		--数字2 拳法
		elseif IsViewingKungfuScrolls > 0 and keypress==50 then
			local newThing = {}
			local newThingnum = {}
			for i = 0, CC.MyThingNum - 1 do
				newThing[i] = -1
				newThingnum[i] = 0
			end
			local c = -1
			for i = 0, #original_thing do
				if original_thing[i] == -1 then
					break
				end
				local TSkill = JY.Thing[original_thing[i]]["练出武功"]
				if TSkill > -1 and JY.Wugong[TSkill]["武功类型"] == 1 then
					c = c + 1
					newThing[c] = original_thing[i]
					newThingnum[c] = original_thingnum[i]
				end
			end
			thing = newThing
			thingnum = newThingnum
			cur_line=0
			cur_x=0
			cur_y=0
			cur_thing=-1
			IsViewingKungfuScrolls = 2
		--数字3 指法
		elseif IsViewingKungfuScrolls > 0 and keypress==51 then
			local newThing = {}
			local newThingnum = {}
			for i = 0, CC.MyThingNum - 1 do
				newThing[i] = -1
				newThingnum[i] = 0
			end
			local c = -1
			for i = 0, #original_thing do
				if original_thing[i] == -1 then
					break
				end
				local TSkill = JY.Thing[original_thing[i]]["练出武功"]
				if TSkill > -1 and JY.Wugong[TSkill]["武功类型"] == 2 then
					c = c + 1
					newThing[c] = original_thing[i]
					newThingnum[c] = original_thingnum[i]
				end
			end
			thing = newThing
			thingnum = newThingnum
			cur_line=0
			cur_x=0
			cur_y=0
			cur_thing=-1
			IsViewingKungfuScrolls = 3
		--数字4 剑法
		elseif IsViewingKungfuScrolls > 0 and keypress==52 then
			local newThing = {}
			local newThingnum = {}
			for i = 0, CC.MyThingNum - 1 do
				newThing[i] = -1
				newThingnum[i] = 0
			end
			local c = -1
			for i = 0, #original_thing do
				if original_thing[i] == -1 then
					break
				end
				local TSkill = JY.Thing[original_thing[i]]["练出武功"]
				if TSkill > -1 and JY.Wugong[TSkill]["武功类型"] == 3 then
					c = c + 1
					newThing[c] = original_thing[i]
					newThingnum[c] = original_thingnum[i]
				end
			end
			thing = newThing
			thingnum = newThingnum
			cur_line=0
			cur_x=0
			cur_y=0
			cur_thing=-1
			IsViewingKungfuScrolls = 4
		--数字5 刀法
		elseif IsViewingKungfuScrolls > 0 and keypress==53 then
			local newThing = {}
			local newThingnum = {}
			for i = 0, CC.MyThingNum - 1 do
				newThing[i] = -1
				newThingnum[i] = 0
			end
			local c = -1
			for i = 0, #original_thing do
				if original_thing[i] == -1 then
					break
				end
				local TSkill = JY.Thing[original_thing[i]]["练出武功"]
				if TSkill > -1 and JY.Wugong[TSkill]["武功类型"] == 4 then
					c = c + 1
					newThing[c] = original_thing[i]
					newThingnum[c] = original_thingnum[i]
				end
			end
			thing = newThing
			thingnum = newThingnum
			cur_line=0
			cur_x=0
			cur_y=0
			cur_thing=-1
			IsViewingKungfuScrolls = 5
		--数字6 奇门
		elseif IsViewingKungfuScrolls > 0 and keypress==54 then
			local newThing = {}
			local newThingnum = {}
			for i = 0, CC.MyThingNum - 1 do
				newThing[i] = -1
				newThingnum[i] = 0
			end
			local c = -1
			for i = 0, #original_thing do
				if original_thing[i] == -1 then
					break
				end
				local TSkill = JY.Thing[original_thing[i]]["练出武功"]
				if TSkill > -1 and JY.Wugong[TSkill]["武功类型"] == 5 then
					c = c + 1
					newThing[c] = original_thing[i]
					newThingnum[c] = original_thingnum[i]
				end
			end
			thing = newThing
			thingnum = newThingnum
			cur_line=0
			cur_x=0
			cur_y=0
			cur_thing=-1
			IsViewingKungfuScrolls = 6
		--数字7 内轻
		elseif IsViewingKungfuScrolls > 0 and keypress==55 then
			local newThing = {}
			local newThingnum = {}
			for i = 0, CC.MyThingNum - 1 do
				newThing[i] = -1
				newThingnum[i] = 0
			end
			local c = -1
			for i = 0, #original_thing do
				if original_thing[i] == -1 then
					break
				end
				local TSkill = JY.Thing[original_thing[i]]["练出武功"]
				if TSkill > -1 and (JY.Wugong[TSkill]["武功类型"] == 6 or JY.Wugong[TSkill]["武功类型"] == 7) then
					c = c + 1
					newThing[c] = original_thing[i]
					newThingnum[c] = original_thingnum[i]
				end
			end
			thing = newThing
			thingnum = newThingnum
			cur_line=0
			cur_x=0
			cur_y=0
			cur_thing=-1
			IsViewingKungfuScrolls = 7
		--数字8 杂学
		elseif IsViewingKungfuScrolls > 0 and keypress==56 then
			local newThing = {}
			local newThingnum = {}
			for i = 0, CC.MyThingNum - 1 do
				newThing[i] = -1
				newThingnum[i] = 0
			end
			local c = -1
			for i = 0, #original_thing do
				if original_thing[i] == -1 then
					break
				end
				local TSkill = JY.Thing[original_thing[i]]["练出武功"]
				if TSkill == -1 then
					c = c + 1
					newThing[c] = original_thing[i]
					newThingnum[c] = original_thingnum[i]
				end
			end
			thing = newThing
			thingnum = newThingnum
			cur_line=0
			cur_x=0
			cur_y=0
			cur_thing=-1
			IsViewingKungfuScrolls = 8
		elseif keypress==VK_UP or ktype == 6 then
			if  cur_y == 0 then
				if  cur_line > 0 then
					cur_line = cur_line - 1;
				end
			else
				cur_y = cur_y - 1;
			end
		elseif keypress==VK_DOWN or ktype == 7 then
			if  cur_y ==ynum-1 then
				if  cur_line < (math.modf(CC.MyThingNum/xnum)-ynum) then
					cur_line = cur_line + 1;
				end
			else
				cur_y = cur_y + 1;
			end
		elseif keypress==VK_LEFT then
			if  cur_x > 0 then
				cur_x=cur_x-1;
			else
				cur_x=xnum-1;
			end
		elseif keypress==VK_RIGHT then
			if  cur_x ==xnum-1 then
				cur_x=0;
			else
				cur_x=cur_x+1;
			end
		elseif ktype == 2 or ktype == 3 then
			if mx>dx and my>dy and mx<CC.ScreenW-dx and my<CC.ScreenH-dy then
				cur_x=math.modf((mx-dx-CC.ThingGapOut/2)/(CC.ThingPicWidth+CC.ThingGapIn))
				cur_y=math.modf((my-y3_1-CC.ThingGapOut/2)/(CC.ThingPicHeight+CC.ThingGapIn))
				if ktype==3 then
					break
				end
			end
		end
	end

	Cls();
	--无酒不欢：秘笈显示区分
	if IsViewingKungfuScrolls > 0 then
		IsViewingKungfuScrolls = 0
	end
	return cur_thing;
end


--场景处理主函数
function Game_SMap()         --场景处理主函数
	if JY.Restart == 1 then
		return
	end
	
    DrawSMap()
	--无酒不欢：下方显示
	if CC.ShowXY==1 then
        DrawString(10,CC.ScreenH-60,string.format("%s %d %d",JY.Scene[JY.SubScene]["名称"],JY.Base["人X1"],JY.Base["人Y1"]) ,C_GOLD,CC.Fontsmall);
	end
		
	DrawTimer()
	
	JYZTB()
	
    ShowScreen()
    lib.SetClip(0, 0, 0, 0)
  
	local d_pass=GetS(JY.SubScene,JY.Base["人X1"],JY.Base["人Y1"],3);   --当前路过事件
	if d_pass>=0 then
		if d_pass ~=JY.OldDPass then     --避免重复触发
			EventExecute(d_pass,3);       --路过触发事件
			JY.OldDPass=d_pass;
			JY.oldSMapX=-1;
			JY.oldSMapY=-1;
			JY.D_Valid=nil;
		end
		if JY.Status~=GAME_SMAP then
			return ;
		else
		   JY.OldDPass=-1;
		end
	end
	local isout=0;                --是否碰到出口
	if (JY.Scene[JY.SubScene]["出口X1"] ==JY.Base["人X1"] and JY.Scene[JY.SubScene]["出口Y1"] ==JY.Base["人Y1"]) or
		(JY.Scene[JY.SubScene]["出口X2"] ==JY.Base["人X1"] and JY.Scene[JY.SubScene]["出口Y2"] ==JY.Base["人Y1"]) or
		(JY.Scene[JY.SubScene]["出口X3"] ==JY.Base["人X1"] and JY.Scene[JY.SubScene]["出口Y3"] ==JY.Base["人Y1"]) then
		isout=1;
	end
	--出到大地图
	if isout == 1 then
		--无酒不欢：修复马车直接飞进场景后出来会遮挡建筑物的问题
		if JY.Base["人X"] == JY.Scene[JY.SubScene]["外景入口X1"] and JY.Base["人Y"] == JY.Scene[JY.SubScene]["外景入口Y1"] then
			--雪山要单独处理
			if JY.SubScene == 2 then
				JY.Base["人Y"] = JY.Base["人Y"] + 1
			--朱府要单独处理
			elseif JY.SubScene == 92 then
				JY.Base["人X"] = JY.Base["人X"] + 1
			else
				if JY.Base["人方向"] == 0 then
					JY.Base["人Y"] = JY.Base["人Y"] - 1
				elseif JY.Base["人方向"] == 1 then
					JY.Base["人X"] = JY.Base["人X"] + 1
				elseif JY.Base["人方向"] == 2 then
					JY.Base["人X"] = JY.Base["人X"] - 1
				elseif JY.Base["人方向"] == 3 then
					JY.Base["人Y"] = JY.Base["人Y"] + 1
				end
			end
		end
		--明教地道要单独处理
		if JY.SubScene == 13 then
			JY.Base["人X"] = 68
			JY.Base["人Y"] = 397
		end
		--蒙古包要单独处理
		if JY.SubScene == 6 then
			JY.Base["人X"] = 49
			JY.Base["人Y"] = 111
		end
		JY.Status = GAME_MMAP
		lib.PicInit()
		CleanMemory()
		JY.MmapMusic = JY.Scene[JY.SubScene]["出门音乐"]
		--如果没有设置出门音乐的话
		if JY.MmapMusic < 0 then
			JY.MmapMusic = 25
		end
		Init_MMap()
		JY.SubScene = -1
		JY.oldSMapX = -1
		JY.oldSMapY = -1
		lib.DrawMMap(JY.Base["人X"], JY.Base["人Y"], GetMyPic())
		lib.GetKey()
		lib.ShowSlow(20,0)
		return
	end
    --是否跳转到其他场景
    if JY.Scene[JY.SubScene]["跳转场景"] >= 0 and JY.Base["人X1"] == JY.Scene[JY.SubScene]["跳转口X1"] and JY.Base["人Y1"] == JY.Scene[JY.SubScene]["跳转口Y1"] then
		local OldScene = JY.SubScene
		JY.SubScene = JY.Scene[JY.SubScene]["跳转场景"]
		lib.ShowSlow(20, 1)
		if JY.Scene[OldScene]["外景入口X1"] ~= 0 then
			JY.Base["人X1"] = JY.Scene[JY.SubScene]["入口X"]
			JY.Base["人Y1"] = JY.Scene[JY.SubScene]["入口Y"]
		else
			JY.Base["人X1"] = JY.Scene[JY.SubScene]["跳转口X2"]
			JY.Base["人Y1"] = JY.Scene[JY.SubScene]["跳转口Y2"]
		end
		Init_SMap(1)
		return 
	end

    local x,y;
    local direct = -1;
    local keypress, ktype, mx, my = lib.GetKey();
	--先检测跟上次不同的方向是否被按下
    for i = VK_RIGHT,VK_UP do
        if i ~= CC.PrevKeypress and lib.GetKeyState(i) ~=0 then
			keypress = i
		end
	end 
    --如果与上次不同的方向未被按下，则检测与上次相同的方向是否被按下
	if keypress==-1 and	lib.GetKeyState(CC.PrevKeypress) ~=0 then
		keypress = CC.PrevKeypress
	end
    CC.PrevKeypress = keypress
    if keypress==VK_UP then
		direct=0;
		JY.WalkCount = JY.WalkCount + 1
	elseif keypress==VK_DOWN then
		direct=3;
		JY.WalkCount = JY.WalkCount + 1
	elseif keypress==VK_LEFT then
		direct=2;
		JY.WalkCount = JY.WalkCount + 1
	elseif keypress==VK_RIGHT then
		direct=1;
		JY.WalkCount = JY.WalkCount + 1
	else
		JY.WalkCount = 0
	end
	
	if ktype == 1 then
		JY.Mytick=0;
		if keypress==VK_ESCAPE then
			Cls()
			MMenu();
		elseif keypress==VK_SPACE or keypress==VK_RETURN then       --空格触发事件
			if JY.Base["人方向"]>=0 then
				local d_num=GetS(JY.SubScene,JY.Base["人X1"]+CC.DirectX[JY.Base["人方向"]+1],JY.Base["人Y1"]+CC.DirectY[JY.Base["人方向"]+1],3);
				if d_num>=0 then
					EventExecute(d_num,1);
				end
			end
		--无酒不欢：全套快捷键 7-30
	    elseif keypress == VK_S then	--存档
			Menu_SaveRecord()
	    elseif keypress == VK_L then	--读档
			Menu_ReadRecord()
		elseif keypress == VK_Z then	--状态
			Cls()
			Menu_Status()
		elseif keypress == VK_E then	--物品
			Cls()
			Menu_Thing()
		elseif keypress == VK_F3 then	--队友排位
			Cls()
			Menu_TZDY()
		elseif keypress == VK_F4 then	--整理
			Cls()		
			Menu_WPZL()
		end
	elseif ktype == 3 then
	    AutoMoveTab = {[0]=0}
	    local x0 = JY.Base["人X1"]
		local y0 = JY.Base["人Y1"]
		
		local px=x0
		local py=y0
		if CONFIG.Zoom == 100 then
			--无酒不欢：修正在地图边界自动寻路错误的问题
			px=limitX(x0,13,46)
			py=limitX(y0,13,46)
		else
			px=x0
			py=y0
		end
	
		mx = mx + (px-py)*CC.XScale - CC.ScreenW/2
		my = my + (px+py)*CC.YScale - CC.ScreenH/2
			
		local xx = (mx/CC.XScale + my/CC.YScale)/2;
		local yy = (my/CC.YScale - mx/CC.XScale)/2;
			
		if xx - math.modf(xx) > 0 then
			xx = math.modf(xx);
		end
			
		if yy - math.modf(yy) > 0 then
			yy = math.modf(yy);
		end	
		
		if CONFIG.Zoom ~= 100 then		--无酒不欢：不知道什么毛病，反正不加就是有毛病
			xx = xx + 1
			yy = yy + 1
		end

	    if xx > 0 and xx < CC.SWidth and yy > 0 and yy < CC.SHeight then
			walkto(xx - x0,yy - y0)
		end
	elseif ktype == 4 then
		JY.Mytick=0;
		Cls()
		MMenu();
    end

    if JY.Status~=GAME_SMAP then
        return ;
    end
	
	--无酒不欢：有标记事件坐标，且自动走到前面一格才会触发事件
	if CC.AutoMoveEvent[1] ~= 0 and 
	(JY.Base["人X1"] == CC.AutoMoveEvent[1] or JY.Base["人X1"] - 1 == CC.AutoMoveEvent[1] or JY.Base["人X1"] + 1 == CC.AutoMoveEvent[1]) and 
	(JY.Base["人Y1"] == CC.AutoMoveEvent[2] or JY.Base["人Y1"] - 1 == CC.AutoMoveEvent[2] or JY.Base["人Y1"] + 1 == CC.AutoMoveEvent[2]) then
		CC.AutoMoveEvent[0] = 1			--鼠标操作触发事件
	end
    
    if AutoMoveTab[0] ~= 0 then			--鼠标自动走动
		if direct == -1 then
			direct = AutoMoveTab[AutoMoveTab[0]]
			AutoMoveTab[AutoMoveTab[0]] = nil
			AutoMoveTab[0] = AutoMoveTab[0] - 1
	    end
	else
	    AutoMoveTab = {[0] = 0}
		if CC.AutoMoveEvent[0] == 1 then
			EventExecute(GetS(JY.SubScene,CC.AutoMoveEvent[1],CC.AutoMoveEvent[2],3),1);
			CC.AutoMoveEvent[0] = 0;
			CC.AutoMoveEvent[1] = 0;
			CC.AutoMoveEvent[2] = 0;
		end
	end
	
    if direct ~= -1 then
        AddMyCurrentPic();
        x=JY.Base["人X1"]+CC.DirectX[direct+1];
        y=JY.Base["人Y1"]+CC.DirectY[direct+1];
        JY.Base["人方向"]=direct;
		if JY.WalkCount == 1 then
			lib.Delay(90)
		end
    else
        x=JY.Base["人X1"];
        y=JY.Base["人Y1"];
    end

    JY.MyPic=GetMyPic();
    DtoSMap();
    if SceneCanPass(x,y)==true then          --新的坐标可以走过去
        JY.Base["人X1"]=x;
        JY.Base["人Y1"]=y;
    end

    JY.Base["人X1"]=limitX(JY.Base["人X1"],1,CC.SWidth-2);
    JY.Base["人Y1"]=limitX(JY.Base["人Y1"],1,CC.SHeight-2);
    
	--一些新的事件
	NEvent(keypress)
end

--场景坐标(x,y)是否可以通过
--返回true,可以，false不能
function SceneCanPass(x,y)  --场景坐标(x,y)是否可以通过
    local ispass=true;        --是否可以通过

    if GetS(JY.SubScene,x,y,1)>0 then     --场景层1有物品，不可通过
        ispass=false;
    end

    local d_data=GetS(JY.SubScene,x,y,3);     --事件层4
    if d_data>=0 then
        if GetD(JY.SubScene,d_data,0)~=0 then  --d*数据为不能通过
            ispass=false;
        end
    end

    if CC.SceneWater[GetS(JY.SubScene,x,y,0)] ~= nil then   --水面，不可进入
        ispass=false;
    end
    return ispass;
end

function DtoSMap()          ---D*中的事件数据复制到S*中，同时处理动画效果。
    for i=0,CC.DNum-1 do
        local x=GetD(JY.SubScene,i,9);
        local y=GetD(JY.SubScene,i,10);
        if x>0 and y>0 then
            SetS(JY.SubScene,x,y,3,i);

			local p1=GetD(JY.SubScene,i,5);
			if p1>=0 then
				local p2=GetD(JY.SubScene,i,6);
				local p3=GetD(JY.SubScene,i,7);
				local delay=GetD(JY.SubScene,i,8);
				if p3<=p1 then     --动画已停止
					if JY.Mytick %100 > delay then
						p3=p3+1;
					end
				else
					if JY.Mytick % 4 ==0 then      --4个节拍动画增加一次
						p3=p3+1;
					end
				end
				if p3>p2 then
					 p3=p1;
				end
				SetD(JY.SubScene,i,7,p3);
			end
        end
    end
end


function DrawSMap()         --绘场景地图
	local x0=JY.SubSceneX+JY.Base["人X1"]-1;    --绘图中心点
    local y0=JY.SubSceneY+JY.Base["人Y1"]-1;

    local x=limitX(x0,12,45)-JY.Base["人X1"];
    local y=limitX(y0,12,45)-JY.Base["人Y1"];
	
	if CONFIG.Zoom == 100 then
		lib.DrawSMap(JY.SubScene,JY.Base["人X1"],JY.Base["人Y1"],x,y,JY.MyPic)
	else
		lib.DrawSMap(JY.SubScene,JY.Base["人X1"],JY.Base["人Y1"],JY.SubSceneX,JY.SubSceneY,JY.MyPic)
	end
end


-- 读取游戏进度
-- id=0 新进度，=1/2/3 进度
--这里是先把数据读入Byte数组中。然后定义访问相应表的方法，在访问表时直接从数组访问。
--与以前的实现相比，从文件中读取和保存到文件的时间显著加快。而且内存占用少了
function LoadRecord(id)       -- 读取游戏进度
    local zipfile=string.format('data/save/Save_%d',id)
    
    if id ~= 0 and ( existFile(zipfile) == false) then
		QZXS("此存档数据不全，不能读取。请选择其它存档或重新开始");
		return -1;
	end
    
    Byte.unzip(zipfile, 'r.grp','d.grp','s.grp')

    local t1=lib.GetTime();

    --读取R*.idx文件
    local data=Byte.create(6*4);
    Byte.loadfile(data,CC.R_IDXFilename[0],0,6*4);

	local idx={};
	idx[0]=0;
	for i =1,6 do
	    idx[i]=Byte.get32(data,4*(i-1));
	end
	
	local grpFile = 'r.grp';
	local sFile = 's.grp';
	local dFile = 'd.grp';
	if id == 0 then
		grpFile = CC.R_GRPFilename[id];
		sFile = CC.S_Filename[id];
		dFile = CC.D_Filename[id];
	end
	
    --读取R*.grp文件
    JY.Data_Base=Byte.create(idx[1]-idx[0]);              --基本数据
    Byte.loadfile(JY.Data_Base,grpFile,idx[0],idx[1]-idx[0]);

    --设置访问基本数据的方法，这样就可以用访问表的方式访问了。而不用把二进制数据转化为表。节约加载时间和空间
	local meta_t={
	    __index=function(t,k)
	        return GetDataFromStruct(JY.Data_Base,0,CC.Base_S,k);
		end,

		__newindex=function(t,k,v)
	        SetDataFromStruct(JY.Data_Base,0,CC.Base_S,k,v);
	 	end
	}
    setmetatable(JY.Base,meta_t);


    JY.PersonNum=math.floor((idx[2]-idx[1])/CC.PersonSize);   --人物

	JY.Data_Person=Byte.create(CC.PersonSize*JY.PersonNum);
	Byte.loadfile(JY.Data_Person,grpFile,idx[1],CC.PersonSize*JY.PersonNum);

	for i=0,JY.PersonNum-1 do
		JY.Person[i]={};
		local meta_t={
			__index=function(t,k)
				return GetDataFromStruct(JY.Data_Person,i*CC.PersonSize,CC.Person_S,k);
			end,

			__newindex=function(t,k,v)
				SetDataFromStruct(JY.Data_Person,i*CC.PersonSize,CC.Person_S,k,v);
			end
		}
        setmetatable(JY.Person[i],meta_t);
	end

    JY.ThingNum=math.floor((idx[3]-idx[2])/CC.ThingSize);     --物品
	JY.Data_Thing=Byte.create(CC.ThingSize*JY.ThingNum);
	Byte.loadfile(JY.Data_Thing,grpFile,idx[2],CC.ThingSize*JY.ThingNum);
	for i=0,JY.ThingNum-1 do
		JY.Thing[i]={};
		local meta_t={
			__index=function(t,k)
				return GetDataFromStruct(JY.Data_Thing,i*CC.ThingSize,CC.Thing_S,k);
			end,

			__newindex=function(t,k,v)
				SetDataFromStruct(JY.Data_Thing,i*CC.ThingSize,CC.Thing_S,k,v);
			end
		}
        setmetatable(JY.Thing[i],meta_t);
	end

    JY.SceneNum=math.floor((idx[4]-idx[3])/CC.SceneSize);     --场景
	JY.Data_Scene=Byte.create(CC.SceneSize*JY.SceneNum);
	Byte.loadfile(JY.Data_Scene,grpFile,idx[3],CC.SceneSize*JY.SceneNum);
	for i=0,JY.SceneNum-1 do
		JY.Scene[i]={};
		local meta_t={
			__index=function(t,k)
				return GetDataFromStruct(JY.Data_Scene,i*CC.SceneSize,CC.Scene_S,k);
			end,

			__newindex=function(t,k,v)
				SetDataFromStruct(JY.Data_Scene,i*CC.SceneSize,CC.Scene_S,k,v);
			end
		}
        setmetatable(JY.Scene[i],meta_t);
	end

    JY.WugongNum=math.floor((idx[5]-idx[4])/CC.WugongSize);     --武功
	JY.Data_Wugong=Byte.create(CC.WugongSize*JY.WugongNum);
	Byte.loadfile(JY.Data_Wugong,grpFile,idx[4],CC.WugongSize*JY.WugongNum);
	for i=0,JY.WugongNum-1 do
		JY.Wugong[i]={};
		local meta_t={
			__index=function(t,k)
				return GetDataFromStruct(JY.Data_Wugong,i*CC.WugongSize,CC.Wugong_S,k);
			end,

			__newindex=function(t,k,v)
				SetDataFromStruct(JY.Data_Wugong,i*CC.WugongSize,CC.Wugong_S,k,v);
			end
		}
        setmetatable(JY.Wugong[i],meta_t);
	end

    JY.ShopNum=math.floor((idx[6]-idx[5])/CC.ShopSize);     --城镇商店
	JY.Data_Shop=Byte.create(CC.ShopSize*JY.ShopNum);
	Byte.loadfile(JY.Data_Shop,grpFile,idx[5],CC.ShopSize*JY.ShopNum);
	for i=0,JY.ShopNum-1 do
		JY.Shop[i]={};
		local meta_t={
			__index=function(t,k)
				return GetDataFromStruct(JY.Data_Shop,i*CC.ShopSize,CC.Shop_S,k);
			end,

			__newindex=function(t,k,v)
				SetDataFromStruct(JY.Data_Shop,i*CC.ShopSize,CC.Shop_S,k,v);
			end
		}
        setmetatable(JY.Shop[i],meta_t);

    end

    lib.LoadSMap(sFile,CC.TempS_Filename,JY.SceneNum,CC.SWidth,CC.SHeight,dFile,CC.DNum,11);
	collectgarbage();

	lib.Debug(string.format("Loadrecord time=%d",lib.GetTime()-t1));
	
	JY.LOADTIME = lib.GetTime()
	
	for i = 1, CC.MyThingNum do
		if JY.Base["物品" .. i] < 0 then
			break;
		end
		if JY.Base["物品" .. i] == 174 then
			JY.GOLD = JY.Base["物品数量" .. i]
			break;
		end
	end
	
	TFJS[77][14] = "Ｄ当前容貌评价：" .. JY.Thing[227]["物品说明"]
   
	os.remove('r.grp')
	os.remove('d.grp')
	os.remove('s.grp')
end

-- 写游戏进度
-- id=0 新进度，=1/2/3 进度
function SaveRecord(id)         -- 写游戏进度

	--判断是否在子场景保存
	if JY.Status == GAME_SMAP then
      JY.Base["无用"] = JY.SubScene
    else
      JY.Base["无用"] = -1
    end
	
    --读取R*.idx文件
    local t1 = lib.GetTime()
	JY.SAVETIME = lib.GetTime()
	JY.GTIME = math.modf((JY.SAVETIME - JY.LOADTIME) / 60000)
	SetS(14, 2, 1, 4, GetS(14, 2, 1, 4) + JY.GTIME)
	JY.LOADTIME = lib.GetTime()

    local data=Byte.create(6*4);
    Byte.loadfile(data,CC.R_IDXFilename[0],0,6*4);

	local idx={};
	idx[0]=0;
	for i =1,6 do
	    idx[i]=Byte.get32(data,4*(i-1));
	end

	--os.remove('r.grp');
    --写R*.grp文件
	Byte.savefile(JY.Data_Base,'r.grp',idx[0],idx[1]-idx[0]);

	Byte.savefile(JY.Data_Person,'r.grp',idx[1],CC.PersonSize*JY.PersonNum);

	Byte.savefile(JY.Data_Thing,'r.grp',idx[2],CC.ThingSize*JY.ThingNum);

	Byte.savefile(JY.Data_Scene,'r.grp',idx[3],CC.SceneSize*JY.SceneNum);

	Byte.savefile(JY.Data_Wugong,'r.grp',idx[4],CC.WugongSize*JY.WugongNum);

	Byte.savefile(JY.Data_Shop,'r.grp',idx[5],CC.ShopSize*JY.ShopNum);

    lib.SaveSMap('s.grp','d.grp');
    
    local zipfile=string.format('data/save/Save_%d',id)
    Byte.zip(zipfile, 'r.grp','d.grp','s.grp')
    os.remove('r.grp')
    os.remove('d.grp')
    os.remove('s.grp')
    lib.Debug(string.format("SaveRecord time=%d",lib.GetTime()-t1));
end

-------------------------------------------------------------------------------------
-----------------------------------通用函数-------------------------------------------

function filelength(filename)         --得到文件长度
    local inp=io.open(filename,"rb");
    local l= inp:seek("end");
	inp:close();
    return l;
end

--读S×数据, (x,y) 坐标，level 层 0-5
function GetS(id,x,y,level)       --读S×数据
	return lib.GetS(id,x,y,level);
end

--写S×
function SetS(id,x,y,level,v)       --写S×
	lib.SetS(id,x,y,level,v);
end

--读D*
--sceneid 场景编号，
--id D*编号
--要读第几个数据, 0-10
function GetD(Sceneid,id,i)          --读D*
    return lib.GetD(Sceneid,id,i);
end

--写D×
function SetD(Sceneid,id,i,v)         --写D×
	lib.SetD(Sceneid,id,i,v);
end

--从数据的结构中翻译数据
--data 二进制数组
--offset data中的偏移
--t_struct 数据的结构，在jyconst中有很多定义
--key  访问的key
function GetDataFromStruct(data,offset,t_struct,key)  --从数据的结构中翻译数据，用来取数据
    local t=t_struct[key];
	local r;
	if t[2]==0 then
		r=Byte.get16(data,t[1]+offset);
	elseif t[2]==1 then
		r=Byte.getu16(data,t[1]+offset);
	elseif t[2]==2 then
		if CC.SrcCharSet==0 then
			r=lib.CharSet(Byte.getstr(data,t[1]+offset,t[3]),0);
		else
			r=Byte.getstr(data,t[1]+offset,t[3]);
		end
	end
	return r;
end

function SetDataFromStruct(data,offset,t_struct,key,v)  --从数据的结构中翻译数据，保存数据
    local t=t_struct[key];
	if t[2]==0 then
		Byte.set16(data,t[1]+offset,v);
	elseif t[2]==1 then
		Byte.setu16(data,t[1]+offset,v);
	elseif t[2]==2 then
		local s;
		if CC.SrcCharSet==0 then
			s=lib.CharSet(v,1);
		else
			s=v;
		end
		Byte.setstr(data,t[1]+offset,t[3],s);
	end
end

--按照t_struct 定义的结构把数据从data二进制串中读到表t中
function LoadData(t,t_struct,data)        --data二进制串中读到表t中
    for k,v in pairs(t_struct) do
        if v[2]==0 then
            t[k]=Byte.get16(data,v[1]);
        elseif v[2]==1 then
            t[k]=Byte.getu16(data,v[1]);
		elseif v[2]==2 then
            if CC.SrcCharSet==0 then
                t[k]=lib.CharSet(Byte.getstr(data,v[1],v[3]),0);
		    else
		        t[k]=Byte.getstr(data,v[1],v[3]);
		    end
		end
	end
end

--按照t_struct 定义的结构把数据写入data Byte数组中。
function SaveData(t,t_struct,data)      --数据写入data Byte数组中。
    for k,v in pairs(t_struct) do
        if v[2]==0 then
            Byte.set16(data,v[1],t[k]);
		elseif v[2]==1 then
            Byte.setu16(data,v[1],t[k]);
		elseif v[2]==2 then
		    local s;
			if CC.SrcCharSet==0 then
			    s=lib.CharSet(t[k],1);
            else
			    s=t[k];
		    end
            Byte.setstr(data,v[1],v[3],s);
		end
	end
end

--限制x的范围
function limitX(x,minv,maxv)
	if x<minv then
	    x=minv;
	end
	if maxv ~= nil and x>maxv then
	    x=maxv;
	end
	return x
end

function RGB(r,g,b)          --设置颜色RGB
	return r*65536+g*256+b;
end

function GetRGB(color)      --分离颜色的RGB分量
    color=color%(65536*256);
    local r=math.floor(color/65536);
    color=color%65536;
    local g=math.floor(color/256);
    local b=color%256;
    return r,g,b
end

--等待键盘输入
function WaitKey(flag)
	--ktype  1：键盘，2：鼠标移动，3:鼠标左键，4：鼠标右键，5：鼠标中键，6：滚动上，7：滚动下
	local key, ktype, mx, my=-1,-1,-1,-1;
	while true do
		if JY.Restart == 1 then
			break
		end
		key, ktype, mx, my=lib.GetKey();
		if ktype == nil then
			ktype, mx, my=-1,-1,-1;
		end
		if ktype ~=-1 or key ~= -1 then
			if (flag == nil or flag == 0) and ktype ~= 2 then
				break;
			elseif flag ~= nil and flag ~= 0 then
				break;
			end
		end
		lib.Delay(CC.Frame/2);
	end
	return key, ktype, mx, my;
end

--绘制一个带背景的白色方框，四角凹进
function DrawBox(x1, y1, x2, y2, color)
	local s = 4
	lib.Background(x1 + 4, y1, x2 - 4, y1 + s, 88)
	lib.Background(x1 + 1, y1 + 1, x1 + s, y1 + s, 88)
	lib.Background(x2 - s, y1 + 1, x2 - 1, y1 + s, 88)
	lib.Background(x1, y1 + 4, x2, y2 - 4, 88)
	lib.Background(x1 + 1, y2 - s, x1 + s, y2 - 1, 88)
	lib.Background(x2 - s, y2 - s, x2 - 1, y2 - 1, 88)
	lib.Background(x1 + 4, y2 - s, x2 - 4, y2, 88)
	local r, g, b = GetRGB(color)
	DrawBox_1(x1 + 1, y1 + 1, x2, y2, RGB(math.modf(r / 2), math.modf(g / 2), math.modf(b / 2)))
	DrawBox_1(x1, y1, x2 - 1, y2 - 1, color)
end

--绘制一个带背景的白色方框，四角凹进
function DrawBox_1(x1, y1, x2, y2, color)
	local s = 4
	lib.DrawRect(x1 + s, y1, x2 - s, y1, color)
	lib.DrawRect(x1 + s, y2, x2 - s, y2, color)
	lib.DrawRect(x1, y1 + s, x1, y2 - s, color)
	lib.DrawRect(x2, y1 + s, x2, y2 - s, color)
	lib.DrawRect(x1 + 2, y1 + 1, x1 + s - 1, y1 + 1, color)
	lib.DrawRect(x1 + 1, y1 + 2, x1 + 1, y1 + s - 1, color)
	lib.DrawRect(x2 - s + 1, y1 + 1, x2 - 2, y1 + 1, color)
	lib.DrawRect(x2 - 1, y1 + 2, x2 - 1, y1 + s - 1, color)
	lib.DrawRect(x1 + 2, y2 - 1, x1 + s - 1, y2 - 1, color)
	lib.DrawRect(x1 + 1, y2 - s + 1, x1 + 1, y2 - 2, color)
	lib.DrawRect(x2 - s + 1, y2 - 1, x2 - 2, y2 - 1, color)
	lib.DrawRect(x2 - 1, y2 - s + 1, x2 - 1, y2 - 2, color)
end

--显示阴影字符串
function DrawString(x,y,str,color,size)         --显示阴影字符串
	if x==-1 then
		local ll=#str;
		local w=size*ll/2+2*CC.MenuBorderPixel;
		x=(CC.ScreenW-size/2*ll-2*CC.MenuBorderPixel)/2;
	end
	if y == -1 then
		y = (CC.ScreenH - size - 2 * CC.MenuBorderPixel) / 2
	end
    lib.DrawStr(x,y,str,color,size,CC.FontName,CC.SrcCharSet,CC.OSCharSet);
end

--显示带框的字符串
--(x,y) 坐标，如果都为-1,则在屏幕中间显示
function DrawStrBox(x,y,str,color,size,boxcolor)         --显示带框的字符串
    local ll=#str;
    local w=size*ll/2+2*CC.MenuBorderPixel;
	local h=size+2*CC.MenuBorderPixel;
	if boxcolor == nil then
		boxcolor = C_WHITE
	end
	if x==-1 then
        x=(CC.ScreenW-size/2*ll-2*CC.MenuBorderPixel)/2;
	end
	if y==-1 then
        y=(CC.ScreenH-size-2*CC.MenuBorderPixel)/2;
	end

    DrawBox(x,y,x+w-1,y+h-1,boxcolor);
    DrawString(x+CC.MenuBorderPixel,y+CC.MenuBorderPixel,str,color,size);
end

--无酒不欢：增加对颜色转换的支持
function DrawStrBox3(x, y, s, color, size, flag)         --显示带框的字符串
    local ll=#s -flag*2;
    local w=size*ll/2+2*CC.MenuBorderPixel;
	local h=size+2*CC.MenuBorderPixel;
	local function strcolor_switch(s)
		local Color_Switch={{"Ｒ",C_RED},{"Ｇ",C_GOLD},{"Ｂ",C_BLACK},{"Ｗ",C_WHITE},{"Ｏ",C_ORANGE}}
		local Numbers = {{"1",10},{"2",15},{"3",15},{"4",15},{"5",15},{"6",15},{"7",15},{"8",15},{"9",15},{"0",15}}
		for i = 1, 5 do
			if Color_Switch[i][1] == s then
				return 1, Color_Switch[i][2]
			end
		end
		for i = 1, 10 do
			if Numbers[i][1] == s then
				return 2, Numbers[i][2]
			end
		end
		return 0
	end
	
	if x==-1 then
        x=(CC.ScreenW-size/2*ll-2*CC.MenuBorderPixel)/2;
	end
	if y==-1 then
        y=(CC.ScreenH-size-2*CC.MenuBorderPixel)/2;
	end
	
	--无酒不欢：方框颜色 7-31
    DrawBox(x,y,x+w-1,y+h-1,LimeGreen);
	local space = 0;
	while string.len(s) >= 1 do
		local str
		str=string.sub(s,1,1)
		if string.byte(s,1,1) > 127 then		--判断单双字符
			str=string.sub(s,1,2)
			s=string.sub(s,3,-1)
		else
			str=string.sub(s,1,1)
			s=string.sub(s,2,-1)
		end
		local cs,cs2 = strcolor_switch(str)
		if cs == 1 then
			color = cs2
		elseif cs == 2 then
			DrawString(x+CC.MenuBorderPixel+space,y+CC.MenuBorderPixel,str,color,size);
			space = space + cs2;
		else
			DrawString(x+CC.MenuBorderPixel+space,y+CC.MenuBorderPixel,str,color,size);
			space = space + size;
		end
	end
end

--显示并询问Y/N，如果点击Y，则返回true, N则返回false
--(x,y) 坐标，如果都为-1,则在屏幕中间显示
--改为用菜单询问是否
function DrawStrBoxYesNo(x, y, str, color, size, boxcolor)
	if JY.Restart == 1 then
		return
	end
	lib.GetKey()
	local ll = #str
	local w = size * ll / 2 + 2 * CC.MenuBorderPixel
	local h = size + 2 * CC.MenuBorderPixel
	if x == -1 then
		x = (CC.ScreenW - size / 2 * ll - 2 * CC.MenuBorderPixel) / 2
	end
	if y == -1 then
		y = (CC.ScreenH - size - 2 * CC.MenuBorderPixel) / 2
	end
	Cls();
	DrawStrBox(x, y, str, color, size, boxcolor)
	local menu = {
	{"确定/是", nil, 1}, 
	{"取消/否", nil, 2}}
	local r = ShowMenu(menu, 2, 0, x + w - 4 * size - 2 * CC.MenuBorderPixel, y + h + CC.MenuBorderPixel, 0, 0, 1, 0, CC.DefaultFont, C_ORANGE, C_WHITE)
	if r == 1 then
		return true
	else
		return false
	end
end

--显示字符串并等待击键，字符串带框，显示在屏幕中间
function DrawStrBoxWaitKey(s,color,size,flag,boxcolor)
	if JY.Restart == 1 then
		return
	end
    lib.GetKey();
    Cls();
	--无酒不欢：分开多种
	if flag == nil then
		if boxcolor == nil then
			DrawStrBox(-1,-1,s,color,size);
		else
			DrawStrBox(-1,-1,s,color,size,boxcolor);
		end
	else
		DrawStrBox3(-1,-1,s,color,size,flag);
	end
    ShowScreen();
    WaitKey();
end

--返回 [0 , i-1] 的整形随机数
function Rnd(i)           --随机数
    local r=math.random(i);
    return r-1;
end

--增加人物属性，如果有最大值限制，则应用最大值限制。最小值则限制为0
--id 人物id
--str属性字符串
--value 要增加的值，负数表示减少
--返回1,实际增加的值
--返回2，字符串：xxx 增加/减少 xxxx，用于显示药品效果
function AddPersonAttrib(id, str, value)
	local oldvalue = JY.Person[id][str]
	local attribmax = math.huge
	if str == "生命" then
		attribmax = JY.Person[id]["生命最大值"]
	elseif str == "内力" then
		attribmax = JY.Person[id]["内力最大值"]
	elseif CC.PersonAttribMax[str] ~= nil then
		attribmax = CC.PersonAttribMax[str]
	end
	
	--瑜伽密乘减少受伤最大值
	if str == "受伤程度" then
		if PersonKF(id, 169) then
			attribmax = 50
		end
	end
	
	--我方生命最大值，随天书增加而提高
	if str == "生命最大值" and inteam(id) then
		local hp_max = 0
		hp_max = hp_max + JY.Base["天书数量"] * 200
		attribmax = attribmax + hp_max
		if match_ID(id, 673) then
			attribmax = math.modf(attribmax*0.7) --豪鬼
		end
		if JY.Person[id]["天赋内功"] == 100 and PersonKF(id, 100) then
		   attribmax = math.modf(attribmax*1.2)
		end
		if JY.Person[id]["洗髓"] == 100 then
		   attribmax = math.modf(attribmax*1.15)
		end
		if match_ID(id, 676) and JY.Person[676]["天1"] == 2 then
		   attribmax = math.modf(attribmax*1.25)
		end
		if match_ID(id, 77) then
			attribmax = attribmax +JY.Person[77]["品德"]*50
		end
		if JY.Person[id]["无用"]>0 then	
			attribmax=attribmax-JY.Person[id]["无用"]
		end
		if JY.Person[id]["人11"] == 1 then	
			attribmax=math.modf(attribmax*1.12)
		end
		if id == 0 and JY.Person[0]["天1"] == 1 then
		   attribmax = attribmax+500
		end
		if JY.Person[634]["天2"] == 2 and match_ID(id, 634) then
		   attribmax = attribmax+500
		end
		if attribmax<1 then
			attribmax=1
		end
        if match_ID(id, 420) then
           attribmax=attribmax + 500 + JY.Base["天书数量"]*200
		   if JY.Person[420]["阶"] >= 1 then
		      attribmax = math.modf(attribmax*1.10^JY.Person[420]["阶"])
		   end
        end	
		if JY.Person[670]["无用"] == 2 and id == 0 then
		   attribmax = attribmax*0.8
		end
		if JY.Person[id]["地8"] == 1 and JY.Person[0]["品德"] <= 30 then
	       attribmax = attribmax+2000
	    end
		if match_ID(id, 62) and JY.Person[62]["阶"] >= 2 then
		   attribmax = attribmax+1000
	    end
		if match_ID(id, 149) and JY.Person[149]["阶"] >= 3 then
		   attribmax = attribmax+1000
	    end
		if JY.Person[id]["专1"] == 90 and PersonKF(id, 90) then
	       attribmax = attribmax*1.15
	    end
		--游坦之
		if match_ID(id, 48) and JY.Person[48]["天3"] == 2 then
		   attribmax = attribmax+NeiNum(id)*100
	    end
		if JY.Person[JY.Base["畅想"]]["阶"] >= 2 and JY.Base["畅想"] > 0 and Tier[JY.Base["畅想"]] == nil and match_ID(id, JY.Base["畅想"]) then
		   attribmax = attribmax*1.1
		end
		attribmax = attribmax*(0.93+JY.Base["难度"]*0.07)
	end

	if str == "内力最大值" then
		if inteam(id) then
			local p_zz = JY.Person[id]["资质"]
			if p_zz <= 15 then
				attribmax = 6999
			elseif p_zz >= 16 and p_zz <= 30 then
				attribmax = 6299
			elseif p_zz >= 31 and p_zz <= 45 then
				attribmax = 5599
			elseif p_zz >= 46 and p_zz <= 50 then
				attribmax = 4899
			elseif p_zz >= 51 and p_zz <= 60 then
				attribmax = 4199
			elseif p_zz >= 61 and p_zz <= 75 then
				attribmax = 3399
			elseif p_zz >= 76 and p_zz <= 90 then
				attribmax = 2699
			elseif p_zz >= 91 then
				attribmax = 1999
			end
			--段誉，扫地，石破天，张无忌，上限9999
			if match_ID(id, 53) or match_ID(id, 114) or match_ID(id, 38) or match_ID(id, 9) or (match_ID(id, 634) and JY.Person[634]["天2"] == 1) then
				attribmax = 9999
			end
			if match_ID(id, 49) and JY.Person[49]["品德"] == 100 then
			   attribmax = 9998
			end
			--学一个内功开发1500内力上限
			if Num_of_Neigong(id) == 1 then
				attribmax = attribmax + 1000
			--学两个内功开发3000内力上限
			elseif Num_of_Neigong(id) == 2 then
				attribmax = attribmax + 2000
			--学两个以上内功开发4500内力上限
			elseif Num_of_Neigong(id) > 2 then
				attribmax = attribmax + 3000
			end
			--学有北冥或吸星，+300
			for i = 1, JY.Person[671]["品德"] do
				if JY.Person[id]["武功" .. i] == 85 or JY.Person[id]["武功" .. i] == 88 then
					attribmax = attribmax + 300
					break
				end
			end
			--杨过吼过的内力
			if match_ID(id, 58) then
				attribmax = attribmax + JY.Person[300]["声望"] * 100
			end
			--内力下限1999，上限9999
			if attribmax < 1999 then
				attribmax = 1999
			end
			if attribmax > 9999 then
				attribmax = 9999
			end
		if match_ID(id, 77) then
				attribmax = attribmax +JY.Person[77]["品德"]*100
		end
		else
		   attribmax = 9999
		end
		if JY.Base["特殊"] == 3 and JY.Person[92]["天1"] == 1 and id == 0 and attribmax < 9999 then
		   attribmax = 9999
		end
		
		--游坦之
		if match_ID(id, 48) and JY.Person[48]["天3"] == 2 then
		   attribmax = attribmax+NeiNum(id)*200
	    end
		if JY.Person[id]["人12"] == 1 then
		   attribmax = attribmax+500
		end
		
		--谢逊
		if match_ID(id, 13) and JY.Person[13]["阶"] >= 2 then
		   attribmax = attribmax+3000
	    end
		if match_ID(id, 53) and JY.Person[53]["阶"] >= 3 then
		   attribmax = attribmax+5000
	    end
		if match_ID(id, 26) and JY.Person[26]["阶"] >= 2 then
		   attribmax = attribmax+2000
	    end
		if match_ID(id, 149) and JY.Person[149]["阶"] >= 3 then
		   attribmax = attribmax+3000
	    end
		if match_ID(id, 103) and JY.Person[103]["阶"] >= 2 then
		   attribmax = attribmax+2000
	    end
		if match_ID(id, 69) and JY.Person[69]["阶"] >= 3 then
		   attribmax = attribmax+2000
	    end
		if match_ID(id, 37) and JY.Person[37]["阶"] >= 1 then
		   attribmax = attribmax+2000
	    end
		if match_ID(id, 60) and JY.Person[60]["阶"] >= 1 then
		   attribmax = attribmax+2000
	    end
		if match_ID(id, 62) and JY.Person[62]["阶"] >= 2 then
		   attribmax = attribmax+1000
	    end
		if match_ID(id, 70) and JY.Person[70]["阶"] >= 2 then
		   attribmax = attribmax+3000
	    end
		if match_ID(id, 49) and JY.Person[49]["阶"] >= 2 then
		   attribmax = attribmax+3000
		   if JY.Person[49]["阶"] >= 3 then
		      attribmax = attribmax+5000
		   end
	    end
		if JY.Base["标准"] == 6 and id == 0 and JY.Person[0]["阶"] >= 2 then
	       attribmax = attribmax+3000
	    end
		
		if match_ID(id, 19) and JY.Person[19]["阶"] >= 2 then
		   attribmax = attribmax+2000
	    end

		if id == 0 and JY.Person[0]["天4"] == 1 then
		   attribmax = attribmax+2500
		end
		
		if JY.Person[638]["声望"] >= 1 and match_ID(id, 638) then
	       attribmax = attribmax + 2000
	    end
		
		if JY.Person[id]["专2"] == 106 and PersonKF(id, 106) then
		   attribmax = attribmax+2500
		end
		if match_ID(id, 636) and JY.Person[636]["天2"] == 2 then
		   attribmax = attribmax+2000
		end
		
		if JY.Person[id]["专2"] == 206 and PersonKF(id, 206) then
		   attribmax = attribmax+1500
		end
		
		if JY.Person[id]["地5"] == 3 then
		   attribmax = attribmax+3000
		end
		
		if JY.Person[id]["地8"] == 4 then
		   attribmax = attribmax+1000
		end
		
		if match_ID(id, 687) then
		   attribmax = attribmax+500
		   if JY.Base["天书数量"] > 3 then
		      attribmax = attribmax+500*math.min((JY.Base["天书数量"]-3),5)
		   end
		end
		
		if JY.Person[JY.Base["畅想"]]["阶"] >= 2 and JY.Base["畅想"] > 0 and Tier[JY.Base["畅想"]] == nil and match_ID(id, JY.Base["畅想"]) then
		   attribmax = math.modf(attribmax*1.1)
		end
	end
    
	--程灵素，何铁手，王难姑，用毒500
	if str == "用毒能力" and (match_ID(id, 2) or match_ID(id, 83) or match_ID(id, 17)) then
		attribmax = 500
	end
	--蓝凤凰，用毒400
	if str == "用毒能力" and match_ID(id, 25) then
		attribmax = 400
	end
	--胡青牛，平一指，薛慕华医疗500
	if str == "医疗能力" and (match_ID(id, 16) or match_ID(id, 28) or match_ID(id, 45)) then
		attribmax = 500
		if JY.Person[16]["阶"] >= 1 then
		   attribmax = attribmax + 100
		end
	end
	--贝海石，程灵素医疗400
	if str == "医疗能力" and (match_ID(id, 85) or match_ID(id, 2)) then
		attribmax = 400
	end
	--标主医生，医疗用毒解毒都是400
	if (str == "医疗能力" or str == "用毒能力" or str == "解毒能力") and id == 0 and JY.Base["标准"] == 8 then
		attribmax = 400
	end
	--标主毒王，用毒解毒都是500
	if (str == "用毒能力" or str == "解毒能力") and id == 0 and JY.Base["标准"] == 9 then
		attribmax = 500
	end
	--阎基，医疗用毒都是300
	if (str == "医疗能力" or str == "用毒能力") and match_ID(id, 4) then
		attribmax = 300
	end
	--陈家洛觉醒后兵器值无上限
	if match_ID(id, 75) and JY.Base["天书数量"] > 6 and (str == "拳掌功夫" or str == "指法技巧" or str == "御剑能力" or str == "耍刀技巧" or str == "特殊兵器") then
		attribmax = 9999
	end
	--fyao
	if match_ID(id, 10) and JY.Person[10]["阶"] >= 2 and (str == "拳掌功夫" or str == "指法技巧" or str == "御剑能力" or str == "耍刀技巧" or str == "特殊兵器") then
		attribmax = attribmax+100
	end
	if JY.Base["标准"] == 4 and id == 0 and JY.Person[0]["阶"] >= 1 and str == "耍刀技巧" then
		attribmax = attribmax+100
	end
	if match_ID(id, 35) and JY.Person[10]["阶"] >= 1 and str == "御剑能力" then
		attribmax = attribmax+100
	end
	--李寻欢
	if str == "暗器技巧" and JY.Person[684]["天3"] == 1 then
		attribmax = attribmax + 120
	end
	--赵半山
	if str == "暗器技巧" and JY.Person[153]["阶"] >= 1 then
		attribmax = attribmax + JY.Person[153]["阶"]*80
	end
	--标主修炼秘籍
	if JY.Base["标准"] == 1 and str == "拳掌功夫" and id == 0 then
	attribmax = attribmax + 80
	elseif JY.Base["标准"] == 2 and str == "指法技巧" and id == 0 then
	attribmax = attribmax + 80
	elseif JY.Base["标准"] == 3 and str == "御剑能力" and id == 0 then
	attribmax = attribmax + 80
	elseif JY.Base["标准"] == 4 and str == "耍刀技巧" and id == 0 then
	attribmax = attribmax + 80
	elseif JY.Base["标准"] == 5 and str == "特殊兵器" and id == 0 then
	attribmax = attribmax + 80
	end
	--陆小凤
	if match_ID(id, 678) and str == "指法技巧" then
	attribmax = attribmax + 50
	if JY.Person[678]["天4"] ~= 0 then
	attribmax = attribmax + 100
	end
	end
	--西门吹雪
	if match_ID(id, 683) and JY.Person[683]["天3"] == 1 and str == "御剑能力" then
	attribmax = attribmax + 150
	end
	--小虾米
	if match_ID(id, 677) and JY.Person[677]["天4"] == 2 and (str == "拳掌功夫" or str == "指法技巧" or str == "御剑能力" or str == "耍刀技巧" or str == "特殊兵器" or str == "防御力" or str == "轻功" or str == "攻击力") then
	attribmax = attribmax + 80
	end
	if match_ID(id, 634) and (str == "拳掌功夫" or str == "指法技巧" or str == "御剑能力" or str == "耍刀技巧" or str == "特殊兵器" or str == "防御力" or str == "轻功" or str == "攻击力" or str == "武学常识") then
	attribmax = attribmax + 100
	end
	if JY.Person[id]["洗髓"] == 100 and (str == "拳掌功夫" or str == "指法技巧" or str == "御剑能力" or str == "耍刀技巧" or str == "特殊兵器" or str == "防御力" or str == "轻功" or str == "攻击力") then
	attribmax = attribmax + 30
	end
	if JY.Person[id]["地3"] == 1 and (str == "拳掌功夫" or str == "指法技巧" or str == "御剑能力" or str == "耍刀技巧" or str == "特殊兵器") then
	attribmax = attribmax + 30
	end
	if match_ID(id, 682) and str == "攻击力" then
	attribmax = attribmax + 100
	end
	if JY.Person[id]["人1"] == 1 and (str == "防御力" or str == "轻功" or str == "攻击力") then
	attribmax = attribmax + 20
	end
	if JY.Person[637]["声望"] >= 1 and match_ID(id, 637) and (str == "防御力" or str == "轻功" or str == "攻击力") then
	attribmax = attribmax + 100
	end
	if JY.Person[638]["声望"] >= 2 and match_ID(id, 638) and (str == "拳掌功夫" or str == "指法技巧" or str == "御剑能力" or str == "耍刀技巧" or str == "特殊兵器" or str == "防御力" or str == "轻功" or str == "攻击力") then
	attribmax = attribmax + 70
	end
	if match_ID(id, 637) and str == "武学常识" then
	attribmax = attribmax + 200
	end
	if JY.Person[id]["人23"] == 1 and (str == "用毒能力" or str == "解毒能力") then
	attribmax = attribmax + 100
	end
	if match_ID(id, 691) and str == "耍刀技巧" then
	attribmax = attribmax + 100
	end
	--游坦之
	if match_ID(id, 48) and JY.Person[48]["天3"] == 2 and (str == "防御力" or str == "轻功" or str == "攻击力") then
	attribmax = attribmax+NeiNum(id)*20
	end

	if JY.Person[670]["无用"] == 2 and id == 0 then
	   if str == "拳掌功夫" or str == "指法技巧" or str == "御剑能力" or str == "耍刀技巧" or str == "特殊兵器" then
	      attribmax = attribmax + 80
	   end
	end
    --托奇
	if match_ID(id, 686) and (str == "拳掌功夫" or str == "指法技巧" or str == "御剑能力" or str == "耍刀技巧" or str == "特殊兵器" or str == "防御力" or str == "轻功" or str == "攻击力") then
	attribmax = attribmax + 100
	end
	if match_ID(id, 686) and str == "拳掌功夫" then
	attribmax = attribmax + 200
	end
	if match_ID(id, 686) and str == "指法技巧" then
	attribmax = attribmax + 100
	end
	--无名，剑法上限
	if match_ID(id, 671) and str == "御剑能力" then
		local sx = 0
		for i = 1, JY.Person[671]["品德"] do
			if JY.Wugong[JY.Person[0]["武功" .. i]]["武功类型"] == 3 then
				sx = sx + 1
			end
		end
		attribmax = attribmax + sx*50
		if JY.Person[671]["阶"] >= 1 then
		attribmax = attribmax + sx*20
		end
	end
	
	--聂风上限
	if match_ID(id, 681) and str == "耍刀技巧" then
		local sx = 0
		for i = 1, JY.Person[671]["品德"] do
			if JY.Wugong[JY.Person[0]["武功" .. i]]["武功类型"] == 4 then
				sx = sx + 1
			end
		end
		attribmax = attribmax + sx*30
	end
	
	if PersonKF(id, 198) and str == "御剑能力" then
       attribmax = attribmax + 50
    end	
    --独孤九剑	
	if PersonKF(id, 47) and JY.Person[id]["专2"] == 47 and str == "御剑能力" then
       attribmax = attribmax + 100
    end
	--无名
	if match_ID(id, 671) and JY.Person[id]["六如觉醒"] == 7 and str == "内力最大值" then
	   attribmax = attribmax + 3000
	end
	--武僧
	if match_ID(id, 676) and JY.Person[676]["天2"] == 1 and str == "内力最大值" then
	   attribmax = attribmax + 3000
	end
	--武僧
	if match_ID(id, 676) and str == "防御力" and JY.Person[676]["天1"] == 1 then
	   attribmax = attribmax + 50
	end
	--武僧
	if match_ID(id, 676) and str == "轻功" and JY.Person[676]["天3"] == 1 then
	   attribmax = attribmax + 50
	end
	--武僧
	if match_ID(id, 676) and str == "攻击力" and JY.Person[676]["天3"] == 2 then
	   attribmax = attribmax + 50
	end
	if match_ID(id, 676) and str == "拳掌功夫" then
	   if JY.Base["天书数量"] >= 1 then
	     attribmax = attribmax + 50
	   end
       if JY.Base["天书数量"] >= 7 then
	     attribmax = attribmax + 50
	   end
	   if JY.Base["天书数量"] >= 9 then
	     attribmax = attribmax + 50
	   end  
	end
	--华英雄
	if match_ID(id, 675) then
	if str == "内力最大值" then
	   attribmax = attribmax + 300*JY.Person[675]["品德"]
	end
	if str == "御剑能力" then
	   if PersonKF(id, 213) then
	   attribmax = attribmax + 100
	   end
	end
	if JY.Person[675]["品德"] >= 6 and str == "拳掌功夫" then
	   attribmax = attribmax + 180
	end
	end
	
	if match_ID(id, 677) and JY.Person[id]["六如觉醒"] >= 4 and str == "内力最大值" then
	   attribmax = attribmax + math.modf(attribmax*0.5)
	end
	
	if JY.Person[id]["洗髓"] == 100 and str == "内力最大值" then
	   attribmax = math.modf(attribmax*1.15)
	end
	
	--豪鬼，拳法上限
	if match_ID(id, 673) and str == "拳掌功夫" then
		attribmax = 9999
	end
	--IRONFIST拳法上限
	if match_ID(id, 693) and str == "拳掌功夫" then
		attribmax = attribmax + JY.Base["天书数量"]*20
		if JY.Person[693]["天1"] == 2 then
		attribmax = attribmax + 50
		end
	end

	if JY.Person[id]["专2"] == 995 and str == "暗器技巧" then
	   attribmax = attribmax + 100
	end
	
	if JY.Person[id]["专2"] == 994 and str == "医疗能力" then
	   attribmax = attribmax + 100
	end
	
	if JY.Person[id]["专2"] == 993 then
	   if str == "攻击带毒" then
	   attribmax = 999
	   end
	   if str == "用毒能力" then
	   attribmax = attribmax + 100
	   end
	end
	
	if (id == JY.Person[685]["天1"] or id == JY.Person[685]["天2"]) and not match_ID(id, 685) and id ~= 0
	and (str == "拳掌功夫" or str == "指法技巧" or str == "御剑能力" or str == "耍刀技巧" or str == "特殊兵器" or str == "防御力" or str == "轻功" or str == "攻击力" or str == "生命最大值" or str == "内力最大值" or str == "暗器技巧") then
	attribmax = 1
	end
	
	local newvalue = limitX(oldvalue + value, 0, attribmax)
	JY.Person[id][str] = newvalue
	local add = newvalue - oldvalue
	local showstr = ""
	if add > 0 then
		showstr = string.format("%s 增加 %d", str, add)
	elseif add < 0 then
		showstr = string.format("%s 减少 %d", str, -add)
	end
	return add, showstr
end

--播放midi
function PlayMIDI(id)             --播放midi
    JY.CurrentMIDI=id;
    if JY.EnableMusic==0 then
        return ;
    end
    if id>=0 then
        lib.PlayMIDI(string.format(CC.MIDIFile,id+1));
    end
end

--播放音效atk***
function PlayWavAtk(id)             --播放音效atk***
    if JY.EnableSound==0 then
        return ;
    end
    if id>=0 then
        lib.PlayWAV(string.format(CC.ATKFile,id));
    end
end

--播放音效e**
function PlayWavE(id)              --播放音效e**
    if JY.EnableSound==0 then
        return ;
    end
    if id>=0 then
        lib.PlayWAV(string.format(CC.EFile,id));
    end
end

--flag =0 or nil 全部刷新屏幕
--1 考虑脏矩形的快速刷新
function ShowScreen(flag)
	if JY.Darkness == 0 then
		if flag == nil then
			flag = 0
		end
		lib.ShowSurface(flag)
	end
end

--通用菜单函数
-- menuItem 表，每项保存一个子表，内容为一个菜单项的定义
--          菜单项定义为  {   ItemName,     菜单项名称字符串
--                          ItemFunction, 菜单调用函数，如果没有则为nil
--                          Visible       是否可见  0 不可见 1 可见, 2 可见，作为当前选择项。只能有一个为2，
--                                        多了则只取第一个为2的，没有则第一个菜单项为当前选择项。
--                                        在只显示部分菜单的情况下此值无效。
--                                        此值目前只用于是否菜单缺省显示否的情况
--                       }
--          菜单调用函数说明：         itemfunction(newmenu,id)
--
--       返回值
--              0 正常返回，继续菜单循环 1 调用函数要求退出菜单，不进行菜单循环
--
-- numItem      总菜单项个数
-- numShow      显示菜单项目，如果总菜单项很多，一屏显示不下，则可以定义此值
--                =0表示显示全部菜单项

-- (x1,y1),(x2,y2)  菜单区域的左上角和右下角坐标，如果x2,y2=0,则根据字符串长度和显示菜单项自动计算x2,y2
-- isBox        是否绘制边框，0 不绘制，1 绘制。若绘制，则按照(x1,y1,x2,y2)的矩形绘制白色方框，并使方框内背景变暗
-- isEsc        Esc键是否起作用 0 不起作用，1起作用
-- Size         菜单项字体大小
-- color        正常菜单项颜色，均为RGB
-- selectColor  选中菜单项颜色,
--;
-- 返回值  0 Esc返回
--         >0 选中的菜单项(1表示第一项)
--         <0 选中的菜单项，调用函数要求退出父菜单，这个用于退出多层菜单

function ShowMenu(menuItem, numItem, numShow, x1, y1, x2, y2, isBox, isEsc, size, color, selectColor)
	local w = 0
	local h = 0
	local i = 0
	local num = 0
	local newNumItem = 0
	lib.GetKey()
	local newMenu = {}
	for i = 1, numItem do
		if menuItem[i][3] > 0 then
			newNumItem = newNumItem + 1
			newMenu[newNumItem] = {menuItem[i][1], menuItem[i][2], menuItem[i][3], i}
		end
	end
	if newNumItem == 0 then
		return 0
	end
	if numShow == 0 or newNumItem < numShow then
		num = newNumItem
	else
		num = numShow
	end
	local maxlength = 0
	if x2 == 0 and y2 == 0 then
		for i = 1, newNumItem do
		  if maxlength < string.len(newMenu[i][1]) then
			maxlength = string.len(newMenu[i][1])
		  end
		end
		w = size * maxlength / 2 + 2 * CC.MenuBorderPixel
		h = (size + CC.RowPixel) * num + CC.MenuBorderPixel
	else
		w = x2 - x1
		h = y2 - y1
	end
	local start = 1
	local current = 1
	for i = 1, newNumItem do
		if newMenu[i][3] == 2 then
		  current = i
		end
	end
	if numShow ~= 0 then
		current = 1
	end
	--无酒不欢：战斗快捷键时机判定
	local In_Battle = false;
	if JY.Status == GAME_WMAP and numItem >= 13 and menuItem[13][1] == "自动" then
		In_Battle = true
	end
	--无酒不欢：战术菜单判定
	local In_Tactics = false;
	if JY.Status == GAME_WMAP and numItem >= 3 and menuItem[3][1] == "等待" then
		In_Tactics = true
	end
	--修改战斗菜单宽度以便显示快捷键
	if In_Battle == true or In_Tactics == true then
		w = w + 15
	end
	local surid = lib.SaveSur(0, 0, CC.ScreenW, CC.ScreenH)
	local returnValue = 0
	if isBox == 1 then
		DrawBox(x1, y1, x1 + (w), y1 + (h), C_WHITE)
	end
  
  
  while true do
	if JY.Restart == 1 then
		break
	end
    if num ~= 0 then
		ClsN();
		lib.LoadSur(surid, 0, 0)
	    if isBox == 1 then
	      DrawBox(x1, y1, x1 + (w), y1 + (h), C_WHITE)
	    end
  	end
	  for i = start, start + num - 1 do
	    local drawColor = color
	    if i == current then
			drawColor = selectColor
			lib.Background(x1 + CC.MenuBorderPixel, y1 + CC.MenuBorderPixel + (i - start) * (size + CC.RowPixel), x1 - CC.MenuBorderPixel + (w), y1 + CC.MenuBorderPixel + (i - start) * (size + CC.RowPixel) + size, 128, color)
	    end
	    if newMenu[i][1] == "黯然销魂掌" then
			DrawString(x1 + CC.MenuBorderPixel, y1 + CC.MenuBorderPixel + (i - start) * (size + CC.RowPixel), newMenu[i][1], LightPurple, size)
		else
			DrawString(x1 + CC.MenuBorderPixel, y1 + CC.MenuBorderPixel + (i - start) * (size + CC.RowPixel), newMenu[i][1], drawColor, size)
		end
		--快捷键提示显示
		if In_Battle == true then
			if newMenu[i][1] == "攻击" then
				DrawString(x1 + CC.MenuBorderPixel + size*2, y1 + CC.MenuBorderPixel + (i - start) * (size + CC.RowPixel) +2, "A", LimeGreen, CC.FontSmall)
			elseif newMenu[i][1] == "运功" then
				DrawString(x1 + CC.MenuBorderPixel + size*2, y1 + CC.MenuBorderPixel + (i - start) * (size + CC.RowPixel) +2, "G", LimeGreen, CC.FontSmall)
			elseif newMenu[i][1] == "战术" then
				DrawString(x1 + CC.MenuBorderPixel + size*2, y1 + CC.MenuBorderPixel + (i - start) * (size + CC.RowPixel) +2, "S", LimeGreen, CC.FontSmall)
			elseif newMenu[i][1] == "用毒" then
				DrawString(x1 + CC.MenuBorderPixel + size*2, y1 + CC.MenuBorderPixel + (i - start) * (size + CC.RowPixel) +2, "V", LimeGreen, CC.FontSmall)
			elseif newMenu[i][1] == "解毒" then
				DrawString(x1 + CC.MenuBorderPixel + size*2, y1 + CC.MenuBorderPixel + (i - start) * (size + CC.RowPixel) +2, "Q", LimeGreen, CC.FontSmall)
			elseif newMenu[i][1] == "医疗" then
				DrawString(x1 + CC.MenuBorderPixel + size*2, y1 + CC.MenuBorderPixel + (i - start) * (size + CC.RowPixel) +2, "F", LimeGreen, CC.FontSmall)
			elseif newMenu[i][1] == "物品" then
				DrawString(x1 + CC.MenuBorderPixel + size*2, y1 + CC.MenuBorderPixel + (i - start) * (size + CC.RowPixel) +2, "E", LimeGreen, CC.FontSmall)
			elseif newMenu[i][1] == "状态" then
				DrawString(x1 + CC.MenuBorderPixel + size*2, y1 + CC.MenuBorderPixel + (i - start) * (size + CC.RowPixel) +2, "Z", LimeGreen, CC.FontSmall)
			elseif newMenu[i][1] == "休息" then
				DrawString(x1 + CC.MenuBorderPixel + size*2, y1 + CC.MenuBorderPixel + (i - start) * (size + CC.RowPixel) +2, "R", LimeGreen, CC.FontSmall)
			elseif newMenu[i][2] == War_TgrtsMenu then
				DrawString(x1 + CC.MenuBorderPixel + size*2, y1 + CC.MenuBorderPixel + (i - start) * (size + CC.RowPixel) +2, "T", LimeGreen, CC.FontSmall)
			end
		end
		if In_Tactics == true then
			if newMenu[i][1] == "蓄力" then
				DrawString(x1 + CC.MenuBorderPixel + size*2, y1 + CC.MenuBorderPixel + (i - start) * (size + CC.RowPixel) +2, "P", LimeGreen, CC.FontSmall)
			elseif newMenu[i][1] == "防御" then
				DrawString(x1 + CC.MenuBorderPixel + size*2, y1 + CC.MenuBorderPixel + (i - start) * (size + CC.RowPixel) +2, "D", LimeGreen, CC.FontSmall)
			elseif newMenu[i][1] == "等待" then
				DrawString(x1 + CC.MenuBorderPixel + size*2, y1 + CC.MenuBorderPixel + (i - start) * (size + CC.RowPixel) +2, "W", LimeGreen, CC.FontSmall)
			elseif newMenu[i][1] == "集中" then
				DrawString(x1 + CC.MenuBorderPixel + size*2, y1 + CC.MenuBorderPixel + (i - start) * (size + CC.RowPixel) +2, "J", LimeGreen, CC.FontSmall)
			end
		end
	  end

		ShowScreen()

		local keyPress, ktype, mx, my = WaitKey(1)
		lib.Delay(CC.Frame)
	  
		if keyPress==VK_ESCAPE or ktype == 4 then
			--Esc 或 退出
			if isEsc==1 then
				break
				--return 0
			end
		elseif keyPress==VK_DOWN or ktype == 7 then                --Down
			current = current +1;
			if current > (start + num-1) then
				start=start+1;
			end
			if current > newNumItem then
				start=1;
				current =1;
			end
		elseif keyPress==VK_UP or ktype == 6 then                  --Up
			current = current -1;
			if current < start then
				start=start-1;
			end
			if current < 1 then
				current = newNumItem;
				start =current-num+1;
			end
		elseif keyPress == VK_RIGHT then
			current = current + 10
			if start + num - 1 < current then
				start = start + 10
			end
			if newNumItem < current +start then                --Alungky 修复看攻略时会跳出的BUG
				current = newNumItem
				start = current - num + 1
			end
		elseif keyPress == VK_LEFT then
			current = current - 10
			if current < start then
				start = start - 10
			end
			if current < 1 then
				start = 1
				current = 1
			elseif current < num then                --Alungky 修复看攻略时会跳出的BUG
				start = 1
			end
		--无酒不欢：战斗快捷键
		--攻击
		elseif In_Battle == true and keyPress == VK_A and menuItem[2][3] == 1 then
			local r=War_FightMenu();
			if r==1 then
			returnValue= -2;
			break;
			end
			ClsN();
			lib.LoadSur(surid,0,0);
			if isBox==1 then
				DrawBox(x1,y1,x1+w,y1+h,C_WHITE);
			end
		--1-9直接攻击
		elseif In_Battle == true and (keyPress >= 49 and keyPress <= 57) and menuItem[2][3] == 1 then
			local r=War_FightMenu(nil, nil, keyPress-48);
			if r==1 then
			returnValue= -2;
			break;
			end
			ClsN();
			lib.LoadSur(surid,0,0);
			if isBox==1 then
				DrawBox(x1,y1,x1+w,y1+h,C_WHITE);
			end
		--运功
		elseif In_Battle == true and keyPress == VK_G then
			local r=War_YunGongMenu();
			if r==20 then
				returnValue= 20;
				break;
			elseif r==10 then
				returnValue= 10;
				break;
			end
			ClsN();
			lib.LoadSur(surid,0,0);
			if isBox==1 then
				DrawBox(x1,y1,x1+w,y1+h,C_WHITE);
			end
		--战术
		elseif In_Battle == true and keyPress == VK_S then
			local r=War_TacticsMenu();
			if r==1 then
				returnValue= -4;
				break;
			elseif r == 20 then
				returnValue= 20;
				break;
			end
			ClsN();
			lib.LoadSur(surid,0,0);
			if isBox==1 then
				DrawBox(x1,y1,x1+w,y1+h,C_WHITE);
			end
		--用毒
		elseif In_Battle == true and keyPress == VK_V and menuItem[5][3] == 1 then
			local r=War_PoisonMenu();
			if r==1 then
			returnValue= -5;
			break;
			end
			ClsN();
			lib.LoadSur(surid,0,0);
			if isBox==1 then
				DrawBox(x1,y1,x1+w,y1+h,C_WHITE);
			end
		--解毒
		elseif In_Battle == true and keyPress == VK_Q and menuItem[6][3] == 1 then
			local r=War_DecPoisonMenu();
			if r==1 then
			returnValue= -6;
			break;
			end
			ClsN();
			lib.LoadSur(surid,0,0);
			if isBox==1 then
				DrawBox(x1,y1,x1+w,y1+h,C_WHITE);
			end
		--医疗
		elseif In_Battle == true and keyPress == VK_F and menuItem[7][3] == 1 then
			local r=War_DoctorMenu();
			if r==1 then
			returnValue= -7;
			break;
			end
			ClsN();
			lib.LoadSur(surid,0,0);
			if isBox==1 then
				DrawBox(x1,y1,x1+w,y1+h,C_WHITE);
			end
		--物品
		elseif In_Battle == true and keyPress == VK_E and menuItem[8][3] == 1 then
			local r=War_ThingMenu();
			if r==1 then
			returnValue= -8;
			break;
			end
			ClsN();
			lib.LoadSur(surid,0,0);
			if isBox==1 then
				DrawBox(x1,y1,x1+w,y1+h,C_WHITE);
			end
		--状态
		elseif In_Battle == true and keyPress == VK_Z then
			local r=War_StatusMenu();
			if r==1 then
			returnValue= -9;
			break;
			end
			ClsN();
			lib.LoadSur(surid,0,0);
			if isBox==1 then
				DrawBox(x1,y1,x1+w,y1+h,C_WHITE);
			end
		--休息
		elseif In_Battle == true and keyPress == VK_R then
			local r=War_RestMenu();
			if r==1 then
			returnValue= -10;
			break;
			end
			ClsN();
			lib.LoadSur(surid,0,0);
			if isBox==1 then
				DrawBox(x1,y1,x1+w,y1+h,C_WHITE);
			end
		--特色指令
		elseif In_Battle == true and keyPress == VK_T and menuItem[11][3] == 1 then
			local r=War_TgrtsMenu();
			if r==1 then
				returnValue= -11;
				break;
			elseif r==20 then
				returnValue= 20
				break;
			end
			ClsN();
			lib.LoadSur(surid,0,0);
			if isBox==1 then
				DrawBox(x1,y1,x1+w,y1+h,C_WHITE);
			end
		--C查看
		elseif In_Battle == true and keyPress == VK_C then
			local r=MapWatch();
			ClsN();
			lib.LoadSur(surid,0,0);
			if isBox==1 then
				DrawBox(x1,y1,x1+w,y1+h,C_WHITE);
			end
		--蓄力
		elseif (In_Battle == true or In_Tactics == true) and keyPress == VK_P then
			local r=War_ActupMenu();
			if In_Battle == true then
				returnValue = -4;
			else	
				returnValue = 5;
			end
			break;
			ClsN();
			lib.LoadSur(surid,0,0);
			if isBox==1 then
				DrawBox(x1,y1,x1+w,y1+h,C_WHITE);
			end
		--防御
		elseif (In_Battle == true or In_Tactics == true) and keyPress == VK_D then
			local r=War_DefupMenu();
			if In_Battle == true then
				returnValue = -4;
			else
				returnValue = 5;
			end
			break;
			ClsN();
			lib.LoadSur(surid,0,0);
			if isBox==1 then
				DrawBox(x1,y1,x1+w,y1+h,C_WHITE);
			end
		--等待
		elseif (In_Battle == true or In_Tactics == true) and keyPress == VK_W then
			local r=War_Wait();
			if In_Battle == true then
				returnValue = -4;
			else
				returnValue = 5;
			end
			break;
			ClsN();
			lib.LoadSur(surid,0,0);
			if isBox==1 then
				DrawBox(x1,y1,x1+w,y1+h,C_WHITE);
			end
		--集中
		elseif (In_Battle == true or In_Tactics == true) and keyPress == VK_J then
			War_Focus()
			if In_Battle == true then
				returnValue = 20;
			else
				returnValue = 6;
			end
			break;
			ClsN();
			lib.LoadSur(surid,0,0);
			if isBox==1 then
				DrawBox(x1,y1,x1+w,y1+h,C_WHITE);
			end
		else
			local mk = false;
			if ktype == 2 or ktype == 3 then			--选中
				if mx >= x1 and mx <= x1 + w and my >= y1 and my <= y1 + h then
					current = start + math.modf((my - y1 - CC.MenuBorderPixel) / (size + CC.RowPixel))
					mk = true;
				end
			end
			--选中确认
			if  keyPress==VK_SPACE or keyPress==VK_RETURN or ktype == 5 or (ktype == 3 and mk) then
				if newMenu[current][2]==nil then
					returnValue=newMenu[current][4];
					break;
				elseif newMenu[current][2] == SelectNeiGongMenu then
					local id = WAR.Person[WAR.CurID]["人物编号"]
					--运功内力不足
					if JY.Person[id]["内力"] < 2000 then
						DrawStrBoxWaitKey("内力不足，无法运功",C_RED,CC.DefaultFont,nil,LimeGreen)
					--运功体力不足
					elseif JY.Person[id]["体力"] < 20 then
						DrawStrBoxWaitKey("体力不足，无法运功",C_RED,CC.DefaultFont,nil,LimeGreen)
					else
						local r=newMenu[current][2](newMenu,current); 
						--连续两级菜单全部返回20作为判定参数
						if r == 20 then
							returnValue= 20; 
							break;
						end
						ClsN();
						lib.LoadSur(surid,0,0);
						if isBox==1 then
							DrawBox(x1,y1,x1+w,y1+h,C_WHITE);
						end
					end
				elseif newMenu[current][2] == SelectQingGongMenu then
					local id = WAR.Person[WAR.CurID]["人物编号"]
					--运功体力不足
					if JY.Person[id]["体力"] < 20 then
						DrawStrBoxWaitKey("体力不足，无法运功",M_DeepSkyBlue,CC.DefaultFont,nil,LimeGreen)
					else
						local r=newMenu[current][2](newMenu,current); 
						if r == 10 then
							returnValue= 10; 
							break;
						end
						ClsN();
						lib.LoadSur(surid,0,0);
						if isBox==1 then
							DrawBox(x1,y1,x1+w,y1+h,C_WHITE);
						end
					end
				else
					local r=newMenu[current][2](newMenu,current);               --调用菜单函数
			
					--无酒不欢：重写一下这里的返回逻辑以适应运功
					if r==1 then
						returnValue= -newMenu[current][4];
						break;
					--连续两级菜单全部返回20作为判定参数
					elseif In_Battle == true and r == 20 then	
						returnValue= 20;
						break;
					elseif In_Battle == true and r == 10 then	
						returnValue= 10;
						break;
					end			
					ClsN();
					lib.LoadSur(surid,0,0);
					if isBox==1 then
						DrawBox(x1,y1,x1+w,y1+h,C_WHITE);
					end
				end
			end		
		end
	end
	lib.FreeSur(surid)
	return returnValue
end

--基本参数和ShowMenu一样，有一些特别的进行着重说明
--menu 每个数据三个值，1名称，2执行函数，3显示方式(0灰色可选择，1正常显示，2不显示, 3灰色不可选择)
--itemNum 菜单的个数，通常在调用的时候 #menu就可以了
--numShow 每行显示的菜单个数
--showRow 一个版面显示的最大行数，如果可显示菜单个数达不到一个版面的数，函数会自动适应这个值
--str 是标题的文字，传nil不显示
--选中项
function ShowMenu2(menu,itemNum,numShow,showRow,x1,y1,x2,y2,isBox,isEsc,size,color,selectColor, str, selIndex)     --通用菜单函数
    local w=0;
    local h=0;   --边框的宽高
    local i,j=0,0;
    local col=0;     --实际的显示菜单项
    local row=0;
    
    lib.GetKey();
    Cls();
    
    --建一个新的table
    local menuItem = {};
    local numItem = 0;                --显示的总数
    
    --把可显示的部分放到新table
    for i,v in pairs(menu) do
		if v[3] ~= 2 then
			numItem = numItem + 1;
			menuItem[numItem] = {v[1],v[2],v[3],i};                --注意第4个位置，保存i的值
		end
    end
    
    --计算实际显示的菜单项数
    if numShow==0 or numShow > numItem then
        col=numItem;
        row = 1;
    else
        col=numShow;
        row = math.modf((numItem-1)/col);
    end
    
    if showRow > row + 1 then
		showRow = row + 1;
    end

    --计算边框实际宽高
    local maxlength=0;
    if x2==0 and y2==0 then
        for i=1,numItem do
            if string.len(menuItem[i][1])>maxlength then
                maxlength=string.len(menuItem[i][1]);
            end
        end
		w=(size*maxlength/2+CC.RowPixel)*col+2*CC.MenuBorderPixel;
		h=showRow*(size+CC.RowPixel) + 2*CC.MenuBorderPixel;
    else
        w=x2-x1;
        h=y2-y1;
    end
    
    if x1 == -1 then
    	x1 = (CC.ScreenW-w)/2;
    end
    if y1 == -1 then
    	y1 = (CC.ScreenH-h+size)/2;
    end

    local start=0;             --显示的第一项

    local curx = 1;          --当前选择项
    local cury = 0;
    local current = curx + cury*numShow;
    
    --默认有选中
    if selIndex ~= nil and selIndex > 0 then
    	current = selIndex;
    	curx = math.fmod((selIndex-1),numShow) + 1;
    	cury = (selIndex - curx)/numShow;
    	if cury >= showRow/2 then
			start = limitX(cury-showRow/2,0,row-showRow+1);
		end
    end
    
    local returnValue =0;
    if str ~= nil then
		DrawStrBox(-1, y1 - size - 2*CC.MenuBorderPixel, str, color, size)
    end
    local surid = lib.SaveSur(0, 0, CC.ScreenW, CC.ScreenH)
	if isBox==1 then
		DrawBox(x1,y1,x1+w,y1+h,C_WHITE);
	end
	while true do
		if JY.Restart == 1 then
			break
		end
		if col ~= 0 then
			lib.LoadSur(surid, 0, 0)
			if isBox == 1 then
				DrawBox(x1, y1, x1 + (w), y1 + (h), C_WHITE)
			end
		end
        for i=start,showRow+start-1 do
			for j=1, col do
				local n = i*col+j;
				if n > numItem then
					break;
				end
				local drawColor=color;           --设置不同的绘制颜色
				if menuItem[n][3] == 0 or menuItem[n][3] == 3 then
					drawColor = M_DimGray
				end
				local xx = x1+(j-1)*(size*maxlength/2+CC.RowPixel) + CC.MenuBorderPixel
				local yy = y1+(i-start)*(size+CC.RowPixel) + CC.MenuBorderPixel
				if n==current then
					drawColor=selectColor;
					lib.Background(xx, yy, xx + size*maxlength/2, yy + size, 128, color)
				end
				DrawString(xx,yy,menuItem[n][1],drawColor,size);
			end
		end
		ShowScreen();
		local keyPress, ktype, mx, my = WaitKey(1)
		lib.Delay(CC.Frame);

		if keyPress==VK_ESCAPE or ktype == 4 then                  --Esc 退出
			if isEsc==1 then
				break;
			end
		elseif keyPress==VK_DOWN or ktype == 7 then                --Down
			if curx + (cury+1)*col <= numItem or row <= 16 then
				cury = cury + 1;
				if cury > row then
					cury = row;
					if row <= 16 then
					   cury = 0
					end
				elseif cury >= showRow/2 and cury <= row - showRow/2 + 1 and start <= row-showRow  then
					start = start + 1;
				end
			end
		elseif keyPress==VK_UP or ktype == 6 then                  --Up
			cury = cury -1;
			if cury < 0 then
				cury = 0
				if row <= 16 then
				   cury = row
				end
			elseif cury >= showRow/2-1 and cury < row - showRow/2 and start > 0 then
				start = start - 1;
			end
		elseif keyPress==VK_RIGHT then                --RIGHT
			curx = curx +1;
			if curx > col then
				curx = 1;
			elseif curx + cury*col > numItem then
				curx = 1;
			end
		elseif keyPress==VK_LEFT then                  --LEFT
			curx = curx -1;
			if curx < 1 then
				curx = col;
				if curx + cury*col > numItem then
					curx = numItem - cury*col;
				end
			end
		else
			local mk = false;
			if ktype == 2 or ktype == 3 then			--选中
				--无酒不欢：加个逻辑判定防止跳出
				local re1, re2 = curx, cury;
				if mx >= x1 and mx <= x1 + w and my >= y1 and my <= y1 + h then
					curx = math.modf((mx-x1-CC.MenuBorderPixel)/(size*maxlength/2+CC.RowPixel)) + 1
					cury = start + math.modf((my - y1 - CC.MenuBorderPixel) / (size + CC.RowPixel))
					mk = true;
				end
				if (curx + cury*col) > #menuItem then
					curx = re1
					cury = re2
					mk = false;
				end
			end
		
			if keyPress==VK_SPACE or keyPress==VK_RETURN or ktype == 5 or (ktype == 3 and mk) then
				current = curx + cury*col;
				if menuItem[current][3]==3 then
                              
				elseif menuItem[current][2]==nil then
					returnValue=current;
					break;
				else
					local r=menuItem[current][2](menuItem,current);               --调用菜单函数
					if r==1 then
						returnValue= -current;
						break;
					else
						lib.LoadSur(surid, 0, 0)
						if isBox==1 then
							DrawBox(x1, y1, x1 + (w), y1 + (h), C_WHITE)
						end
					end
				end
			end
		end 
		current = curx + cury*col;
    end
	lib.FreeSur(surid)
        
	--返回值，这个是取第4个位置的值
	if returnValue > 0 then
		return menuItem[returnValue][4]
	else
		return returnValue
	end
end

------------------------------------------------------------------------------------
--------------------------------------物品使用---------------------------------------
--物品使用模块
--当前物品id
--返回1 使用了物品， 0 没有使用物品。可能是某些原因不能使用
function UseThing(id)
	return DefaultUseThing(id);
end

--缺省物品使用函数，实现原始游戏效果
--id 物品id
function DefaultUseThing(id)                --缺省物品使用函数
    if JY.Thing[id]["类型"]==0 then
        return UseThing_Type0(id);
    elseif JY.Thing[id]["类型"]==1 then
        return UseThing_Type1(id);
    elseif JY.Thing[id]["类型"]==2 then
        return UseThing_Type2(id);
    elseif JY.Thing[id]["类型"]==3 then
        return UseThing_Type3(id);
    elseif JY.Thing[id]["类型"]==4 then
        return UseThing_Type4(id);
    end
end

--剧情物品，触发事件
function UseThing_Type0(id)
	--合并九阴
	if id == 286 then
		local jyzj = 0
		for j=1, CC.MyThingNum do
			if JY.Base["物品" .. j] == 287 then
				jyzj = 1;
				break;
			end
		end
		if jyzj == 1 then
			instruct_2(286,-1)
			instruct_2(287,-1)
			instruct_2(84,1)
		end
		return 0;
	end
	if id == 287 then
		local jyzj = 0
		for j=1, CC.MyThingNum do
			if JY.Base["物品" .. j] == 286 then
				jyzj = 1;
				break;
			end
		end
		if jyzj == 1 then
			instruct_2(286,-1)
			instruct_2(287,-1)
			instruct_2(84,1)
		end
		return 0;
	end
    if JY.SubScene>=0 then
		local x=JY.Base["人X1"]+CC.DirectX[JY.Base["人方向"]+1];
		local y=JY.Base["人Y1"]+CC.DirectY[JY.Base["人方向"]+1];
        local d_num=GetS(JY.SubScene,x,y,3)
        if d_num>=0 then
            JY.CurrentThing=id;
            EventExecute(d_num,2);       --物品触发事件
            JY.CurrentThing=-1;
			return 1;
		else
		    return 0;
        end
    end
end


--判断一个人是否可以装备或修炼一个物品
--返回 true可以修炼，false不可
function CanUseThing(id, personid)
	local str = ""
	--张家辉的专属装备
	if JY.Thing[id]["仅修炼人物"] == 651 then
		if personid == 0 and JY.Base["特殊"] == 2 then
			return true
		else
			return false
		end
	end
	--雷震，天怒十方
	if JY.Thing[id]["仅修炼人物"] == 670 then
		if personid == 0 and JY.Base["畅想"] == 670 then
			return true
		else
			return false
		end
	end
	--圣火令
	if id == 337 and PersonKF(personid, 93) == false then
		return false
	end
	--豪鬼，拳
	if match_ID(personid, 673) and  JY.Thing[id]["类型"] == 2 and JY.Thing[id]["练出武功"] > 0 then --豪鬼
	    if JY.Wugong[JY.Thing[id]["练出武功"]]["武功类型"] == 1 then
		   return true
		elseif JY.Wugong[JY.Thing[id]["练出武功"]]["武功类型"] < 6 then
           return false
        end		   
	end	
	--[[杨过
	if id == 235 and match_ID(personid, 58) then
	   return false
	end]] 
    	   
	--王语嫣，随便修炼秘籍
	if (match_ID(personid, 76) or match_ID(personid, 685) or match_ID(personid, 689) or match_ID(personid, 686)) and JY.Thing[id]["类型"] == 2 then
		return true
	--主角学圣火
	elseif id == 70 and personid == 0 then
		return true
	--大雪怪
    elseif match_ID(personid, 420) and (id == 235 or id == 80) then
       return true	
	--阿朱穿装备
	elseif match_ID(personid, 104) and JY.Thing[id]["装备类型"] >= 0 then
	   return true
	elseif JY.Person[124]["天1"] > 0 and JY.Thing[id]["装备类型"] >= 0 then
	   return true
	--方证学金刚不坏体
	elseif match_ID(personid, 149) and id == 265 then
		return true
	elseif match_ID(personid, 671) and  JY.Thing[id]["类型"] == 2 and JY.Thing[id]["练出武功"] > 0 and JY.Wugong[JY.Thing[id]["练出武功"]]["武功类型"] == 3 then
		return true			
	else
		if JY.Thing[id]["仅修炼人物"] >= 0 and JY.Thing[id]["仅修炼人物"] ~= personid and (personid == 0 and JY.Thing[id]["仅修炼人物"]==JY.Base["畅想"])==false then
			return false
		end
		--if JY.Thing[id]["需内力性质"] ~= 2 and JY.Person[personid]["内力性质"] ~= 2 and JY.Thing[id]["需内力性质"] ~= JY.Person[personid]["内力性质"] then
		if JY.Thing[id]["需内力性质"] ~= nil then
		local yin, yang, tg = NeiL(personid)
		local cond = 1
		    if yang >= JY.Thing[id]["需内力性质"] and -yin >= JY.Thing[id]["需阴"] then
			cond = 2
			end
			if (match_ID(personid, 637) and -yin >= JY.Thing[id]["需阴"]) or (match_ID(personid, 638) and yang >= JY.Thing[id]["需内力性质"]) then
			cond = 2
			end
			if JY.Base["标准"] == 6 and personid == 0 then
			   cond = 2
			end
			--天内可以无视阴阳学习
			if JY.Thing[id]["练出武功"] == JY.Person[personid]["天赋内功"] then
				cond = 2
			--天内可以无视阴阳学习
			elseif JY.Thing[id]["练出武功"] == JY.Person[personid]["天赋轻功"] then
				cond = 2
			end
			--天外也可以无视阴阳学习
			for i = 1, 4 do
				if JY.Thing[id]["练出武功"] == JY.Person[personid]["天赋外功"..i] then
					cond = 2
					break
				end
			end
			if cond == 1 then
				return false
			end
		end
		if JY.Person[personid]["内力最大值"] < JY.Thing[id]["需内力"] then
			return false
		end
		if JY.Person[personid]["攻击力"] < JY.Thing[id]["需攻击力"] then
			return false
		end
		if JY.Person[personid]["轻功"] < JY.Thing[id]["需轻功"] then
			return false
		end
		if JY.Person[personid]["用毒能力"] < JY.Thing[id]["需用毒能力"] then
			return false
		end
		if JY.Person[personid]["医疗能力"] < JY.Thing[id]["需医疗能力"] then
			return false
		end
		if JY.Person[personid]["解毒能力"] < JY.Thing[id]["需解毒能力"] then
			return false
		end

		--学有小无相功，兵器值视作+10点
		local lv = 0;
		if PersonKF(personid, 193) then
			lv = 10
		end
		
		--有胡刀，学苗剑，需求-40
		if id == 117 and PersonKF(personid, 67) then
			lv = lv + 40
		end
		--有苗剑，学胡刀，需求-40
		if id == 136 and PersonKF(personid, 44) then
			lv = lv + 40
		end
		
		--有黄沙，学玄虚，需求-40
		if id == 138 and PersonKF(personid, 78) then
			lv = lv + 40
		end
		--有玄虚，学黄沙，需求-40
		if id == 173 and PersonKF(personid, 64) then
			lv = lv + 40
		end
		
		--有龙爪，学灵蛇，需求-40
		if id == 247 and PersonKF(personid, 20) then
			lv = lv + 40
		end
		--有灵蛇，学龙爪，需求-40
		if id == 92 and PersonKF(personid, 81) then
			lv = lv + 40
		end
		
		--桃花绝技，学习其中之一后，剩下两个的需求减少-10，可叠加
		if id == 95 or id == 101 or id == 123 then
			for i = 1, JY.Person[671]["品德"] do
				if JY.Person[personid]["武功" .. i] == 12 or JY.Person[personid]["武功" .. i] == 18 or JY.Person[personid]["武功" .. i] == 38 then
					lv = lv + 20
				end
			end
		end
		
		--有打狗，学降龙-40
		if id == 86 and PersonKF(personid, 80) then
			lv = lv + 40
		end
		--有降龙，学打狗-40
		if id == 167 and PersonKF(personid, 26) then
			lv = lv + 40
		end
		
		--有九剑，学持瑶琴-40
		if id == 180 and PersonKF(personid, 47) then
			lv = lv + 40
		end
		--有持瑶琴，学九剑-40
		if id == 114 and PersonKF(personid, 73) then
			lv = lv + 40
		end
		
		--阴阳限制
	if id == 176 then
		local R = JY.Person[personid]
		if R["御剑能力"]+ lv +(JY.Base["周目"]-1)*5 >= 70 then
			return true
		elseif R["耍刀技巧"]+ lv +(JY.Base["周目"]-1)*5 >= 70 then
			return true
		elseif R["特殊兵器"]+ lv +(JY.Base["周目"]-1)*5 >= 70 then
			return true
		else
			return false
		end
	end
	--金丝手套限制
	if id == 239 then
		local R = JY.Person[personid]
		if R["拳掌功夫"]+ lv +(JY.Base["周目"]-1)*5 >= 70 then
			return true
		elseif R["指法技巧"]+ lv +(JY.Base["周目"]-1)*5 >= 70 then
			return true
		else
			return false
		end
	end
	
	--七宝指环限制
	if id == 200 then
		local R = JY.Person[personid]
		if R["拳掌功夫"]+ lv +(JY.Base["周目"]-1)*5 >= 80 then
			return true
		elseif R["指法技巧"]+ lv +(JY.Base["周目"]-1)*5 >= 80 then
			return true
		else
			return false
		end
	end
		
		if JY.Person[personid]["拳掌功夫"] + lv +(JY.Base["周目"]-1)*5 < JY.Thing[id]["需拳掌功夫"] then
			return false
		end
		if JY.Person[personid]["指法技巧"] + lv +(JY.Base["周目"]-1)*5  < JY.Thing[id]["需指法技巧"] then
			return false
		end
		if JY.Person[personid]["御剑能力"] + lv +(JY.Base["周目"]-1)*5   < JY.Thing[id]["需御剑能力"] then
			return false
		end
		if JY.Person[personid]["耍刀技巧"] + lv  +(JY.Base["周目"]-1)*5  < JY.Thing[id]["需耍刀技巧"] then
			return false
		end
		if JY.Person[personid]["特殊兵器"] + lv +(JY.Base["周目"]-1)*5  < JY.Thing[id]["需特殊兵器"] then
			return false
		end
		
		if JY.Person[personid]["暗器技巧"] < JY.Thing[id]["需暗器技巧"] then
			return false
		end

		if JY.Thing[id]["需资质"] >= 0 then
			if JY.Thing[id]["需资质"] > JY.Person[personid]["资质"] then
				return false;
			end
		else
			if -JY.Thing[id]["需资质"] < JY.Person[personid]["资质"] then
				return false;
			end 
		end
	end
	  
	--斗转限制
	if id == 118 then
		local R = JY.Person[personid]
		local wp = R["拳掌功夫"] + R["指法技巧"] + R["御剑能力"] + R["耍刀技巧"] + R["特殊兵器"] +(JY.Base["周目"]-1)*25
		if wp < 150 and match_ID(personid, 76)== false and match_ID(personid, 686)== false and match_ID(personid, 685)== false and match_ID(personid, 689)== false then
			return false
		end
	end
	if id == 363 and match_ID(personid, 685) == false then
	   return false
	end   
		return true
end

--药品使用实际效果
--id 物品id，
--personid 使用人id
--返回值：0 使用没有效果，物品数量应该不变。1 使用有效果，则使用后物品数量应该-1
function UseThingEffect(id, personid, amount)
	--无使用数量则默认为使用1个
	if amount == nil then
		amount = 1
	end
	--特殊药品
	if id == 305 then
		local nlsx = JYMsgBox("请选择", "请选择"..JY.Person[personid]["姓名"].."的内力属性", {"阴内","阳内","调和"}, 3, 290)
		if nlsx == 1 then
			instruct_49(personid, -1)
			Cls()  --清屏
		elseif nlsx == 2 then
			instruct_49(personid, 1)
			Cls()  --清屏
		elseif nlsx == 3 then
			instruct_49(personid, 0)
			Cls()  --清屏
		end
		return 2
	elseif id == 306 then
		Cls()  --清屏
		local n = 0
		local bg = {}
		for i = 1, JY.Person[671]["品德"] do
			if JY.Person[personid]["武功" .. i] > 0 then
				n = n + 1
				bg[n]={JY.Wugong[JY.Person[personid]["武功" .. i]]["名称"],nil,1}
			else
				break
			end
		end
		if n > 0 then
			DrawStrBox(CC.ScreenW/2-CC.DefaultFont*3-25, CC.ScreenH/2-CC.DefaultFont*7, "请选择要洗掉的武功", C_RED, CC.DefaultFont, LimeGreen)
			local nexty = CC.ScreenH/2-CC.DefaultFont*7 + CC.SingleLineHeight
			local ywwg = ShowMenu(bg, #bg, 0, CC.ScreenW/2-CC.DefaultFont*2-20, nexty, 0, 0, 1, 0, CC.DefaultFont, C_ORANGE, C_WHITE)
			if JY.Person[personid]["武功" .. ywwg] == JY.Person[personid]["优先使用"] then
				JY.Person[personid]["优先使用"] = 0
			elseif JY.Person[personid]["武功" .. ywwg] == JY.Person[personid]["主运内功"] then
				JY.Person[personid]["主运内功"] = 0
			elseif JY.Person[personid]["武功" .. ywwg] == JY.Person[personid]["主运轻功"] then
				JY.Person[personid]["主运轻功"] = 0
			end
			JY.Person[personid]["武功" .. ywwg] = 0
			JY.Person[personid]["武功等级" .. ywwg] = 0
			if ywwg < JY.Person[671]["品德"] then
				for i = ywwg+1, JY.Person[671]["品德"] do
					if JY.Person[personid]["武功" .. i] > 0 then
						JY.Person[personid]["武功" .. i-1] = JY.Person[personid]["武功" .. i]
						JY.Person[personid]["武功等级" .. i-1] = JY.Person[personid]["武功等级" .. i]
						JY.Person[personid]["武功" .. i] = 0
						JY.Person[personid]["武功等级" .. i] = 0
					else
						break
					end
				end
			end
			return 2
		else
			DrawStrBoxWaitKey("没有可以洗掉的武功！",C_GOLD,CC.DefaultFont,nil,LimeGreen)
		end
	elseif id == 307 then
		Cls()  --清屏
		JY.Person[personid]["资质"] = InputNum("输入资质",1,100)
		return 2
	elseif id == 334 then --轻功丹
		Cls()  --清屏
		local k = JY.Wugong
	    local menu = {}
	
	    for i = 1, 224 do
		local kfname = k[i]["名称"]
		if string.len(kfname) == 8 then
			kfname = kfname.."  "
		elseif string.len(kfname) == 6 then
			kfname = kfname.."    "
		elseif string.len(kfname) == 4 then
			kfname = kfname.."      "
		end
		menu[i] = {kfname,nil,2}
		if k[i]["武功类型"] == 7 and k[i]["积分"] > 0 then
			menu[i][3] = 1
		end
	    end
	local nexty = CC.ScreenH/2-CC.DefaultFont*4 + CC.SingleLineHeight
	local r = ShowMenu2(menu, #menu, 4, 5, CC.ScreenW/2-CC.DefaultFont*10-20, nexty, 0, 0, 1, 0, CC.DefaultFont, C_ORANGE, C_WHITE,"领悟天赋轻功")
	
	if r > 0 then
		SetTianQing(personid,r)
		DrawStrBoxWaitKey(JY.Person[personid]["姓名"].."天赋轻功变为"..k[r]["名称"], C_ORANGE, CC.DefaultFont)
	end
	    
		return 1

	elseif id == 335 then --天内丹
        Cls()  --清屏
		local k = JY.Wugong
	    local menu = {}
	
	    for i = 1, 224 do
		local kfname = k[i]["名称"]
		if string.len(kfname) == 8 then
			kfname = kfname.."  "
		elseif string.len(kfname) == 6 then
			kfname = kfname.."    "
		elseif string.len(kfname) == 4 then
			kfname = kfname.."      "
		end
		menu[i] = {kfname,nil,2}
		if k[i]["武功类型"] == 6 and k[i]["积分"] > 0 then
			menu[i][3] = 1
		end
	end
	local nexty = CC.ScreenH/2-CC.DefaultFont*4 + CC.SingleLineHeight
	local r = ShowMenu2(menu, #menu, 4, 5, CC.ScreenW/2-CC.DefaultFont*10-20, nexty, 0, 0, 1, 0, CC.DefaultFont, C_ORANGE, C_WHITE,"领悟天赋内功")
	
	if r > 0 then
		SetTianNei(personid, r)
		DrawStrBoxWaitKey(JY.Person[personid]["姓名"].."天赋内功变为"..k[r]["名称"], C_ORANGE, CC.DefaultFont)
	end
		return 1
		
	elseif id == 333 then
	local t = 0
	    for i = 1, 4 do
		    if JY.Person[personid]["天赋外功"..i] == 0 then
			   t = i
			   break
			end
		end
		
		Cls()  --清屏
		local k = JY.Wugong
	    local menu = {}
	
	    for i = 1, 224 do
		local kfname = k[i]["名称"]
		if string.len(kfname) == 8 then
			kfname = kfname.."  "
		elseif string.len(kfname) == 6 then
			kfname = kfname.."    "
		elseif string.len(kfname) == 4 then
			kfname = kfname.."      "
		end
		menu[i] = {kfname,nil,2}
		if k[i]["武功类型"] < 6 and k[i]["武功类型"] > 0 and k[i]["积分"] > 0 then
			menu[i][3] = 1
		end
	    end
	    local nexty = CC.ScreenH/2-CC.DefaultFont*4 + CC.SingleLineHeight
	    local r = ShowMenu2(menu, #menu, 4, 5, CC.ScreenW/2-CC.DefaultFont*10-20, nexty, 0, 0, 1, 0, CC.DefaultFont, C_ORANGE, C_WHITE,"领悟天赋外功")
		
		if r > 0 then
		if t ~= 0 then --不满
		SetTianWai(personid, t, r)
		DrawStrBoxWaitKey(JY.Person[personid]["姓名"].."天赋外功"..t.."变为"..k[r]["名称"], C_ORANGE, CC.DefaultFont)
		else
		local c = JYMsgBox("请选择领悟替换天外", "                                                            " ,{k[JY.Person[personid]["天赋外功1"]]["名称"],k[JY.Person[personid]["天赋外功2"]]["名称"],k[JY.Person[personid]["天赋外功3"]]["名称"],k[JY.Person[personid]["天赋外功4"]]["名称"]},4)
		      if c > 0 then
			  SetTianWai(personid, c, r)
			  DrawStrBoxWaitKey(JY.Person[personid]["姓名"].."天赋外功"..c.."变为"..k[r]["名称"], C_ORANGE, CC.DefaultFont)
			  end
		end
		end

		return 1	
	elseif id == 340 then --续命丹
	    JY.Person[personid]["生命"] = JY.Person[personid]["生命最大值"]
		JY.Person[personid]["内力"] = JY.Person[personid]["内力最大值"]
		JY.Person[personid]["体力"] = CC.PersonAttribMax["体力"]
		JY.Person[personid]["受伤程度"] = 0
		JY.Person[personid]["中毒程度"] = 0
		JY.Person[personid]["冰封程度"] = 0
		JY.Person[personid]["灼烧程度"] = 0
		DrawStrBoxWaitKey(JY.Person[personid]["姓名"].."又活过来了", C_ORANGE, CC.DefaultFont)
		return 1
	elseif id == 361 then
	    JY.Person[personid]["实战"] = JY.Person[personid]["实战"] + 100
		   if JY.Person[personid]["实战"] > 500 then
		      JY.Person[personid]["实战"] = 500
		   end
		DrawStrBoxWaitKey(JY.Person[personid]["姓名"].."实战提升100点", C_ORANGE, CC.DefaultFont)
		return 1
	elseif id == 365 then
	    if JY.Status == GAME_WMAP then
		   if WAR.Siphon[personid] == nil then
		   WAR.Siphon[personid] = 600
		   else
		   WAR.Siphon[personid] = WAR.Siphon[personid] + 600
		      if WAR.Siphon[personid] > 1000 then
		      WAR.Siphon[personid] = 1000
		      end	  
		   end
		   DrawStrBoxWaitKey(JY.Person[personid]["姓名"].."获得护盾", C_ORANGE, CC.DefaultFont)
		end

		return 1	
	else
		local str = {}
		str[0] = string.format("使用 %s × %d", JY.Thing[id]["名称"], amount)
		local strnum = 1
		local addvalue = nil
		if JY.Thing[id]["加生命"] > 0 then
			local add = JY.Thing[id]["加生命"] - math.modf(JY.Thing[id]["加生命"] * JY.Person[personid]["受伤程度"] / 200) + Rnd(5)
			--百分比回血
			if id == 0 then
			   add = add + (JY.Person[personid]["生命最大值"]-JY.Person[personid]["生命"])*0.06
			elseif id == 1 then
			   add = add + JY.Person[personid]["生命最大值"]*0.1
			elseif id == 2 then
			   add = add + (JY.Person[personid]["生命最大值"]-JY.Person[personid]["生命"])*0.35
			elseif id == 7 then
			   add = add + JY.Person[personid]["内力最大值"]*0.05
			elseif id == 8 then
			   add = add + JY.Person[personid]["生命最大值"]*0.2
			elseif id == 366 then
			   if JY.Status == GAME_WMAP then
		          WAR.HCDLW[personid] = 50
		          DrawStrBoxWaitKey(JY.Person[personid]["姓名"].."伤害提高，集气速度提高", C_ORANGE, CC.DefaultFont)
		       end 
			end  
			--胡青牛在队，吃药效果为1.3倍
			if JY.Status == GAME_WMAP and inteam(personid) and (inteam(16) or JY.Base["畅想"] == 16 or (JY.Base["畅想"] == 685 and (JY.Person[685]["天1"] == 16 or JY.Person[685]["天2"] == 16 or JY.Person[685]["天3"] == 16))) then
				for w = 0, WAR.PersonNum - 1 do
					if match_ID(WAR.Person[w]["人物编号"], 16) and WAR.Person[w]["死亡"] == false and WAR.Person[w]["我方"] then
						add = math.modf(add * 1.3)
						break;
					end
				end
			end
			if JY.Person[personid]["人11"] == 1 then
			   add = add*1.4
			end
			if JY.Person[637]["声望"] >= 2 and match_ID(personid, 637) then
			   add = add*1.5
			end
			--递减
			if JY.Status == GAME_WMAP then
			   if WAR.DrugD[personid] == nil then
	           WAR.DrugD[personid] = 0
			   else
			   WAR.DrugD[personid] = WAR.DrugD[personid] + 1
			   end
			   add = add*0.92^WAR.DrugD[personid]
			end
			if add <= 0 then
				add = 5 + Rnd(5)
			end
			add = math.modf(add)
			
			
			--洪安通，敌人吃药不加血反而减血
			if JY.Status == GAME_WMAP then
				for w = 0, WAR.PersonNum - 1 do
					if match_ID(WAR.Person[w]["人物编号"], 71) and WAR.Person[w]["死亡"] == false and WAR.Person[w]["我方"] ~= WAR.Person[WAR.CurID]["我方"] then
						add = -add
						break;
					end
				end
			end
			
			--敌人吃药效果加倍
			if not inteam(personid) then
				add = add * 2;
			end
			
			if JY.Person[personid]["地1"] == 1 then
			   add = add * 2
			end
			
			if inteam(personid) and JY.Person[642]["血量翻倍"] == 1 then
				add = add * 2;
			end	
			if XueDao() and WAR.XHTT[personid] ~= nil then
			if add > 0 then
			   add = 0
			end
			end
			
			if JY.Status == GAME_WMAP then
				WAR.Person[WAR.CurID]["内伤点数"] = AddPersonAttrib(personid, "受伤程度", -math.modf(add / 8))
			end

			addvalue, str[strnum] = AddPersonAttrib(personid, "生命", add*amount)
			
			--蓝烟清：显示生命点数
			if JY.Status == GAME_WMAP then
				WAR.Person[WAR.CurID]["生命点数"] = addvalue;
			end
			if addvalue ~= 0 then
				strnum = strnum + 1
			end
		end
	  
		local function ThingAddAttrib(s)
			if JY.Thing[id]["加" .. s] ~= 0 then
			   if s ~= "内力" then
				addvalue, str[strnum] = AddPersonAttrib(personid, s, JY.Thing[id]["加" .. s]*amount)
			   else
				local addnl = JY.Thing[id]["加内力"]
				  if id == 3 then
				     addnl = addnl + JY.Person[personid]["内力最大值"] * 0.1
				  elseif id == 4 then
				     addnl = addnl + JY.Person[personid]["内力最大值"] * 0.1
				  elseif id == 5 then
				     addnl = addnl + JY.Person[personid]["内力最大值"] * 0.15
				  elseif id == 6 then
				     addnl = addnl + JY.Person[personid]["内力最大值"] * 0.30
				  elseif id == 7 then
				     addnl = addnl + JY.Person[personid]["内力最大值"] * 0.15
				  elseif id == 8 then
				     addnl = addnl + JY.Person[personid]["内力最大值"] * 0.15	 
				  end
				  addnl = math.modf(addnl)
				addvalue, str[strnum] = AddPersonAttrib(personid, "内力", addnl*amount)  
			   end	
				if addvalue ~= 0 then
				strnum = strnum + 1
				end
				--蓝烟清：显示体力，内力点数
				if JY.Status == GAME_WMAP then
					if s == "体力" then
						WAR.Person[WAR.CurID]["体力点数"] = addvalue;
					elseif s == "内力" then
						WAR.Person[WAR.CurID]["内力点数"] = addvalue;
					end
				end
			end
		end
	  
		ThingAddAttrib("生命最大值")
	  
		if JY.Thing[id]["加中毒解毒"] < 0 then
			addvalue, str[strnum] = AddPersonAttrib(personid, "中毒程度", JY.Thing[id]["加中毒解毒"]*amount)
			if addvalue ~= 0 then
				strnum = strnum + 1
			end
			--蓝烟清：显示中解毒点数
			if JY.Status == GAME_WMAP then
				if addvalue < 0 then
					WAR.Person[WAR.CurID]["解毒点数"] = -addvalue;
				elseif addvalue > 0 then
					WAR.Person[WAR.CurID]["中毒点数"] = addvalue;
				end
			end
		end
		  
		ThingAddAttrib("体力")
	  
		--[[if JY.Thing[id]["改变内力性质"] == 2 then
			str[strnum] = "内力门路改为阴阳合一"
			strnum = strnum + 1
		end]]

		ThingAddAttrib("内力")
		ThingAddAttrib("内力最大值")
		ThingAddAttrib("攻击力")
		ThingAddAttrib("防御力")
		ThingAddAttrib("轻功")
		ThingAddAttrib("医疗能力")
		ThingAddAttrib("用毒能力")
		ThingAddAttrib("解毒能力")
		ThingAddAttrib("抗毒能力")
		ThingAddAttrib("拳掌功夫")
		ThingAddAttrib("御剑能力")
		ThingAddAttrib("耍刀技巧")
		ThingAddAttrib("特殊兵器")
		ThingAddAttrib("暗器技巧")
		ThingAddAttrib("武学常识")
		ThingAddAttrib("攻击带毒")
	  
		Cls()
		
		--萧中慧变美
		if id == 15 and match_ID(personid, 77) then
			JY.Person[77]["品德"] = JY.Person[77]["品德"] + amount
			if JY.Person[77]["品德"] > 19 then
				JY.Person[77]["品德"] = 19
			end
			local xid = 77
			if JY.Base["畅想"] == 77 then
			xid = 0
			end
			DrawStrBoxWaitKey("萧中慧变得更美了", C_GOLD, CC.DefaultFont,nil,LimeGreen)
			AddPersonAttrib(xid, "攻击力", 1*amount)
			AddPersonAttrib(xid, "防御力", 1*amount)
			AddPersonAttrib(xid, "轻功", 1*amount)
			AddPersonAttrib(xid, "拳掌功夫", 1*amount)
			AddPersonAttrib(xid, "指法技巧", 1*amount)
			AddPersonAttrib(xid, "御剑能力", 1*amount)
			AddPersonAttrib(xid, "耍刀技巧", 1*amount)
			AddPersonAttrib(xid, "特殊兵器", 1*amount)
			JY.Thing[227]["物品说明"] = XZH_d[JY.Person[77]["品德"]]
			TFJS[77][14] = "Ｄ当前容貌评价：" .. JY.Thing[227]["物品说明"]
		end
		
		--无酒不欢 英姿飒爽	
		if id == 16 and JY.Base["特殊"] ==1 and JY.Person[15]["血量翻倍"]==1 and personid==0 then
			DrawStrBoxWaitKey("无酒不欢的属性值兵器值大幅提高了", C_GOLD, CC.DefaultFont,nil,LimeGreen)
			AddPersonAttrib(0, "攻击力", 1*amount)
			AddPersonAttrib(0, "防御力", 1*amount)
			AddPersonAttrib(0, "轻功", 1*amount)
			AddPersonAttrib(0, "拳掌功夫", 1*amount)
			AddPersonAttrib(0, "指法技巧", 1*amount)
			AddPersonAttrib(0, "御剑能力", 1*amount)
			AddPersonAttrib(0, "耍刀技巧", 1*amount)
			AddPersonAttrib(0, "特殊兵器", 1*amount)
		end
		
		if id == 336 then
			DrawStrBoxWaitKey(JY.Person[personid]["姓名"].."的属性值兵器值增加".. 20*amount, C_GOLD, CC.DefaultFont,nil,LimeGreen)
			AddPersonAttrib(personid, "拳掌功夫", 20*amount)
			AddPersonAttrib(personid, "指法技巧", 20*amount)
			AddPersonAttrib(personid, "御剑能力", 20*amount)
			AddPersonAttrib(personid, "耍刀技巧", 20*amount)
			AddPersonAttrib(personid, "特殊兵器", 20*amount)
		end
		
		if strnum > 1 then
			local maxlength = 0
			for i = 0, strnum-1 do
				if maxlength < #str[i] then
					maxlength = #str[i]
				end
			end
			
			if JY.Status ~= GAME_WMAP then
				local ww = maxlength * CC.DefaultFont / 2 + CC.MenuBorderPixel * 2
				local hh = (strnum) * CC.DefaultFont + (strnum - 1) * CC.RowPixel + 2 * CC.MenuBorderPixel
				local x = (CC.ScreenW - ww) / 2
				local y = (CC.ScreenH - hh) / 2
				DrawBox(x, y, x + ww, y + hh, C_WHITE)
				DrawString(x + CC.MenuBorderPixel, y + CC.MenuBorderPixel, str[0], C_WHITE, CC.DefaultFont)
				for i = 1, strnum - 1 do
				  DrawString(x + CC.MenuBorderPixel, y + CC.MenuBorderPixel + (CC.DefaultFont + CC.RowPixel) * i, str[i], C_ORANGE, CC.DefaultFont)
				end
				ShowScreen()
			else
				--显示使用物品文字
				DrawString(CC.MainMenuX, CC.ScreenH-(strnum+2)*CC.Fontsmall, JY.Person[WAR.Person[WAR.CurID]["人物编号"]]["姓名"].." "..str[0], C_WHITE, CC.Fontsmall);
				for i=1, strnum-1 do 
					DrawString(CC.MainMenuX, CC.ScreenH + (i-strnum-2)*CC.Fontsmall, str[i], C_WHITE, CC.Fontsmall);
				end
				
				ShowScreen()
				--显示点数
				War_Show_Count(WAR.CurID);
				--return 1;
			end
			return 1
		else
			DrawStrBox(-1, -1, str[0], C_WHITE, CC.DefaultFont)
			ShowScreen()
			return 1
		end
	end
end

--装备物品
function UseThing_Type1(id)
	DrawStrBox(CC.MainSubMenuX, CC.MainSubMenuY, string.format("谁要配备%s?", JY.Thing[id]["名称"]), C_WHITE, CC.DefaultFont)
	local nexty = CC.MainSubMenuY + CC.SingleLineHeight
	local r = SelectTeamMenu(CC.MainSubMenuX, nexty)
	local pp1, pp2 = 0, 0
	if r > 0 then
		local personid = JY.Base["队伍" .. r]
		--田归农装闯王军刀
		if id == 202 and match_ID(personid, 72) then
			say("嘿嘿，这口宝刀本来就是田掌门的兵器，谁说耍刀不够就装不了？",72,0)
			if JY.Thing[id]["使用人"] >= 0 then
								
				JY.Person[JY.Thing[id]["使用人"]]["武器"] = -1
			end
			if JY.Person[personid]["武器"] >= 0 then
				JY.Thing[JY.Person[personid]["武器"]]["使用人"] = -1
			end
			JY.Person[personid]["武器"] = id
			JY.Thing[id]["使用人"] = personid
			return 1
		end
		
		if CanUseThing(id, personid) then
			if JY.Thing[id]["装备类型"] == 0 then
				if JY.Thing[id]["使用人"] >= 0 then
					
					JY.Person[JY.Thing[id]["使用人"]]["武器"] = -1
				end
				if JY.Person[personid]["武器"] >= 0 then
					JY.Thing[JY.Person[personid]["武器"]]["使用人"] = -1
				end
				JY.Person[personid]["武器"] = id
			
			elseif JY.Thing[id]["装备类型"] == 1 then
				if JY.Thing[id]["使用人"] >= 0 then
					
					JY.Person[JY.Thing[id]["使用人"]]["防具"] = -1
				end
				if JY.Person[personid]["防具"] >= 0 then
					JY.Thing[JY.Person[personid]["防具"]]["使用人"] = -1
				end
				JY.Person[personid]["防具"] = id
			
			elseif JY.Thing[id]["装备类型"] == 2 then
				if JY.Thing[id]["使用人"] >= 0 then
					
					JY.Person[JY.Thing[id]["使用人"]]["动物"] = -1
				end
				if JY.Person[personid]["动物"] >= 0 then
					JY.Thing[JY.Person[personid]["动物"]]["使用人"] = -1
				end
				JY.Person[personid]["动物"] = id
			  
			end
			JY.Thing[id]["使用人"] = personid
		else
			DrawStrBoxWaitKey("此人不适合配备此物品", C_WHITE, CC.DefaultFont)
			return 0
		end
	end
	return 1
end
--秘籍物品使用
function UseThing_Type2(id)
	if JY.Thing[id]["使用人"] >= 0 and DrawStrBoxYesNo(-1, -1, "此物品已经有人修炼，是否换人修炼?", C_WHITE, CC.DefaultFont) == false then
		Cls(CC.MainSubMenuX, CC.MainSubMenuY, CC.ScreenW, CC.ScreenH)
		ShowScreen()
		return 0
	end
	Cls()
	DrawStrBox(CC.MainSubMenuX, CC.MainSubMenuY, string.format("谁要修炼%s?", JY.Thing[id]["名称"]), C_WHITE, CC.DefaultFont)
	local nexty = CC.MainSubMenuY + CC.SingleLineHeight
	local r = SelectTeamMenu(CC.MainSubMenuX, nexty)
	if r > 0 then
		local personid = JY.Base["队伍" .. r]
		local yes, full = nil, nil
		if JY.Thing[id]["练出武功"] >= 0 then
			yes = 0
			full = 1
			for i = 1, JY.Person[671]["品德"] do
				if JY.Person[personid]["武功" .. i] == JY.Thing[id]["练出武功"] then
					yes = 1
				else
					if JY.Person[personid]["武功" .. i] == 0 then
						full = 0
					end
				end
			end
		end
		
		
		--[[local R = JY.Person[personid]
		local wp = R["拳掌功夫"] + R["指法技巧"] + R["御剑能力"] + R["耍刀技巧"] + R["特殊兵器"]
		if id == 118 and JY.Person[personid]["资质"]>79 and wp>149 then
		JY.Person[personid]["出战"] = 1
		end]]
		
		
		
		--纯阳一脉相承九阳，面板有纯阳的可以无条件学九阳
		if id == 83 then
			if PersonKF(personid, 99) and PersonKF(personid, 106) == false then
				if DrawStrBoxYesNo(-1, -1, "纯阳九阳，一脉相承，是否将武功洗为九阳神功?", C_WHITE, CC.DefaultFont) then
					for i = 1, JY.Person[671]["品德"] do
						if JY.Person[personid]["武功" .. i] == 99 then
							JY.Person[personid]["武功" .. i] = 106
							JY.Person[personid]["武功等级" .. i] = 50
							if JY.Person[personid]["天赋内功"] == 99 then
								JY.Person[personid]["天赋内功"] = 106
							end
							yes = 2
							break
						end
					end
				end
			end
		end
		
		--紫霞神功一脉相承葵花宝典，面板有紫霞的可以无条件学葵花
		if id == 93 then
			if PersonKF(personid, 89) and PersonKF(personid, 105) == false then
				say("紫霞秘笈，入门初基，葵花宝典，登峰造极。",personid,1)
				if DrawStrBoxYesNo(-1, -1, "是否将紫霞神功洗为葵花宝典?", C_WHITE, CC.DefaultFont) then
					for i = 1, JY.Person[671]["品德"] do
						if JY.Person[personid]["武功" .. i] == 89 then
							JY.Person[personid]["武功" .. i] = 105
							JY.Person[personid]["武功等级" .. i] = 50
							if JY.Person[personid]["天赋内功"] == 89 then
								JY.Person[personid]["天赋内功"] = 105
							end
							yes = 2
							break
						end
					end
				end
			end
		end
    
		--如果已经满武功并且选择的武功没有学会，则不可装备修炼
		if yes == 0 and full == 1 then
			DrawStrBoxWaitKey("一个人只能修炼"..JY.Person[671]["品德"].."种武功", C_WHITE, CC.DefaultFont)
			return 0
		end
    
		--自宫武功
		if CC.Shemale[id] == 1 then
		     if id == 78 and JY.Person[personid]["性别"] == 1 and not match_ID(personid, 27) and (JY.Base["标准"] == 3 and personid == 0)==false then
					DrawStrBoxWaitKey("此物品不适合女性修炼", C_WHITE, CC.DefaultFont)
					return 0
			end
			--剑神可以直接学
			if personid == 0 and JY.Base["标准"] == 3 then
				say("嗯……我看看，这套武功的精妙之处其实不在于是否自宫。看我如何以剑入道克服这个问题！",0,1)
				yes = 2
			elseif personid == 0 and JY.Base["畅想"] == 671 then
				say("雕虫小技，又何须自残",0,1)
				yes = 2
			elseif match_ID(personid, 685) or match_ID(personid, 689) or match_ID(personid, 686) then
				yes = 2	
			--主角打赢葵花尊者，可以直接学
			elseif personid == 0 and JY.Person[27]["品德"] == 10 then
				yes = 2
			elseif PersonKF(personid, 105) then
				yes = 2
			elseif JY.Person[personid]["性别"] == 0 and CanUseThing(id, personid) then
				Cls(CC.MainSubMenuX, CC.MainSubMenuY, CC.ScreenW, CC.ScreenH)
				if DrawStrBoxYesNo(-1, -1, "修炼此书必须先挥刀自宫，是否仍要修炼?", C_WHITE, CC.DefaultFont) == false then
					return 0
				else
					lib.FillColor(0, 0, CC.ScreenW, CC.ScreenH, C_RED, 128)
					ShowScreen()
					lib.Delay(80)
					lib.ShowSlow(15, 1)
					Cls()
					lib.ShowSlow(50, 0)
					JY.Person[personid]["性别"] = 2
					local add, str = AddPersonAttrib(personid, "攻击力", -20)
					DrawStrBoxWaitKey(JY.Person[personid]["姓名"] .. str, C_ORANGE, CC.DefaultFont)
					add, str = AddPersonAttrib(personid, "防御力", -30)
					DrawStrBoxWaitKey(JY.Person[personid]["姓名"] .. str, C_ORANGE, CC.DefaultFont)
					if JY.Base["标准"] > 0 then
						JY.Person[0]["外号"] = "姑娘"
						JY.Person[0]["外号2"] = "丫头"
						JY.Person[0]["头像代号"] = 303
						local f_ani = {
						{0, 0, 0}, 
						{0, 0, 0}, 
						{10, 8, 6}, 
						{0, 0, 0}, 
						{0, 0, 0}}
						for i = 1, 5 do
							JY.Person[0]["出招动画帧数" .. i] = f_ani[i][1]
							JY.Person[0]["出招动画延迟" .. i] = f_ani[i][3]
							JY.Person[0]["武功音效延迟" .. i] = f_ani[i][2]
						end
					end
				end
			elseif JY.Person[personid]["性别"] == 1 then
			    if id == 78 then
				--if id == 93 then
					DrawStrBoxWaitKey("此物品不适合女性修炼", C_WHITE, CC.DefaultFont)
					return 0
				else
				--elseif id == 311 then
					yes = 2
				--end
				end
			end
		end
		
		
		if yes == 1 or CanUseThing(id, personid) or yes == 2 then
			if JY.Thing[id]["使用人"] == personid then
				return 0
			end
			if JY.Person[personid]["修炼物品"] >= 0 then
				JY.Thing[JY.Person[personid]["修炼物品"]]["使用人"] = -1
			end
			if JY.Thing[id]["使用人"] >= 0 then
				JY.Person[JY.Thing[id]["使用人"]]["修炼物品"] = -1
				JY.Person[JY.Thing[id]["使用人"]]["物品修炼点数"] = 0
			end
			JY.Thing[id]["使用人"] = personid
			JY.Person[personid]["修炼物品"] = id
			JY.Person[personid]["物品修炼点数"] = 0
		elseif match_ID(personid, 673) and JY.Thing[id]["练出武功"] > 0 and JY.Wugong[JY.Thing[id]["练出武功"]]["武功类型"] ~= 1 and JY.Wugong[JY.Thing[id]["练出武功"]]["武功类型"] < 6 then --豪鬼
		    DrawStrBoxWaitKey("他只练拳", C_WHITE, CC.DefaultFont)
		else
			DrawStrBoxWaitKey("此人不适合修炼此物品", C_WHITE, CC.DefaultFont)
			return 0
		end
	end
	return 1
end

--无酒不欢；使用药品和食品
function UseThing_Type3(id)
	local usepersonid = -1
	local amount_use = 0
	if JY.Status == GAME_MMAP or JY.Status == GAME_SMAP then
		Cls(CC.MainSubMenuX, CC.MainSubMenuY, CC.ScreenW, CC.ScreenH)
		DrawStrBox(CC.MainSubMenuX, CC.MainSubMenuY, string.format("谁要使用%s?", JY.Thing[id]["名称"]), C_WHITE, CC.DefaultFont)
		local nexty = CC.MainSubMenuY + CC.SingleLineHeight
		local r = SelectTeamMenu(CC.MainSubMenuX, nexty)
		if r > 0 then
			usepersonid = JY.Base["队伍" .. r]
			--非战斗中可以批量使用
			local max_amount = 0
			for i = 1, CC.MyThingNum do
				if JY.Base["物品" .. i] == id then
					max_amount = JY.Base["物品数量" .. i]
					break;
				end
			end
			amount_use = InputNum("使用数量", 1, max_amount)
		end
	--战斗中
	elseif JY.Status == GAME_WMAP then
		--胡青牛可以向队友用药
		if match_ID(WAR.Person[WAR.CurID]["人物编号"], 16) then
			War_CalMoveStep(WAR.CurID, 8, 1)
			local x, y = War_SelectMove()
			if x ~= nil then
				local emeny = GetWarMap(x, y, 2)
				if emeny >= 0 and WAR.Person[WAR.CurID]["我方"] == WAR.Person[emeny]["我方"] then
					usepersonid = WAR.Person[emeny]["人物编号"]
				end
			end
		else
			usepersonid = WAR.Person[WAR.CurID]["人物编号"]
		end
	end

	--战斗中不可使用加血内上限的物品
	if JY.Status == GAME_WMAP and ((id >=14 and id <= 25) or (id >=305 and id <= 307)) then
		return 0
	end
	
	if usepersonid >= 0 then
		--非战斗下使用物品
		if JY.Status == GAME_MMAP or JY.Status == GAME_SMAP then
			local r = UseThingEffect(id, usepersonid, amount_use)
			if r == 1 then
				instruct_32(id, -amount_use)
				WaitKey()
			elseif r == 2 then
				instruct_32(id, -amount_use)
			end
		--战斗中使用物品
		elseif JY.Status == GAME_WMAP then
			if UseThingEffect(id, usepersonid) == 1 then
				instruct_32(id, -1)
			end
		end
	else
		return 0
	end
	return 1
end

--暗器物品
function UseThing_Type4(id)
	if JY.Status == GAME_WMAP then
		return War_UseAnqi(id)
	end
	return 0
end

--------------------------------------------------------------------------------
--------------------------------------事件调用-----------------------------------

--事件调用主入口
--id，d*中的编号
--flag 1 空格触发，2，物品触发，3，路过触发
function EventExecute(id,flag)
    JY.CurrentD=id;

    oldEventExecute(flag)

    JY.CurrentD=-1;
end

--调用原有的指定位置的函数
--旧的函数名字格式为  oldevent_xxx();  xxx为事件编号
function oldEventExecute(flag)
	local eventnum = nil
	if flag == 1 then
		eventnum = GetD(JY.SubScene, JY.CurrentD, 2)
	elseif flag == 2 then
		eventnum = GetD(JY.SubScene, JY.CurrentD, 3)
	elseif flag == 3 then
		eventnum = GetD(JY.SubScene, JY.CurrentD, 4)
	end
	if eventnum > 0 then
			lib.Debug(eventnum.."");
		end
	if eventnum > 0 then
		CallCEvent(eventnum)  
	end
end

function existFile(filename)
    local f = io.open(filename)
    if f == nil then
        return false
    end
    io.close(f)
    return true
end

function CallCEvent(eventnum)
	local eventfilename = string.format("%s%d.lua", CONFIG.CEventPath,eventnum)
	if existFile(eventfilename) then
		dofile(eventfilename)
		return true
	else
		return false
	end
end


--改变大地图坐标，从场景出去后移动到相应坐标
function ChangeMMap(x,y,direct)          --改变大地图坐标
	JY.Base["人X"]=x;
	JY.Base["人Y"]=y;
	JY.Base["人方向"]=direct;
end

--改变当前场景
function ChangeSMap(sceneid,x,y,direct)       --改变当前场景
    JY.SubScene=sceneid;
	JY.Base["人X1"]=x;
	JY.Base["人Y1"]=y;
	JY.Base["人方向"]=direct;
end


--清除(x1,y1)-(x2,y2)矩形内的文字等。
--如果没有参数，则清除整个屏幕表面
--注意该函数并不直接刷新显示屏幕
function Cls(x1,y1,x2,y2)                    --清除屏幕
    if x1==nil then        --第一个参数为nil,表示没有参数，用缺省
	    x1=0;
		y1=0;
		x2=CC.ScreenW;
		y2=CC.ScreenH;
	end

	lib.SetClip(x1,y1,x2,y2);

	if JY.Status==GAME_START then
	    lib.FillColor(0,0,0,0,0);
        lib.LoadPicture(CC.FirstFile,-1,-1);
	elseif JY.Status==GAME_MMAP then
        lib.DrawMMap(JY.Base["人X"],JY.Base["人Y"],GetMyPic());             --显示主地图
	elseif JY.Status==GAME_SMAP then
        DrawSMap();
	elseif JY.Status==GAME_WMAP then
        WarDrawMap(0);
	elseif JY.Status==GAME_DEAD then
	    lib.FillColor(0,0,0,0,0);
        lib.LoadPicture(CC.DeadFile,-1,-1);
	end
	lib.SetClip(0,0,CC.ScreenW,CC.ScreenH);
end


--产生对话显示需要的字符串，即每隔n个中文字符加一个星号
function GenTalkString(str,n)             					 --产生对话显示需要的字符串
    local tmpstr="";
    for s in string.gmatch(str .. "*","(.-)%*") do           --去掉对话中的所有*. 字符串尾部加一个星号，避免无法匹配
        tmpstr=tmpstr .. s;
    end

    local newstr="";
    while #tmpstr>0 do
		local w=0;
		while w<#tmpstr do
		    local v=string.byte(tmpstr,w+1);	--当前字符的值
			if v>=128 then
			    w=w+2;
			else
			    w=w+1;
			end
			if w >= 2*n-1 then					--为了避免跨段中文字符
			    break;
			end
		end

        if w<#tmpstr then
		    if w==2*n-1 and string.byte(tmpstr,w+1)<128 then
				newstr=newstr .. string.sub(tmpstr,1,w+1) .. "*";
				tmpstr=string.sub(tmpstr,w+2,-1);
			else
				newstr=newstr .. string.sub(tmpstr,1,w)  .. "*";
				tmpstr=string.sub(tmpstr,w+1,-1);
			end
		else
		    newstr=newstr .. tmpstr;
			break;
		end
	end
    return newstr;
end

--个人新对话
function TalkEx(s,pid,flag,name)
	say(s,pid,flag,name)
end

--测试指令，占位置用
function instruct_test(s)
    DrawStrBoxWaitKey(s,C_ORANGE,24);
end

--清屏
function instruct_0()         --清屏
    Cls();
end

function ReadTalk(id, flag)
	local tidx = Byte.create(id * 4 + 4)
	Byte.loadfile(tidx, CC.TDX, 0, id * 4 + 4)
	local idx1, idx2 = nil, nil
	if id < 1 then
		idx1 = 0
	else
		idx1 = Byte.get32(tidx, (id - 1) * 4)
	end
	idx2 = Byte.get32(tidx, id * 4)
	local len = idx2 - idx1
	local talk = Byte.create(len)
	Byte.loadfile(talk, CC.TRP, idx1, len)
	local str = ""
	for i = 0, len - 2 do
		local byte = Byte.getu16(talk, i)
		byte = 255 - math.fmod(byte, 256)
		str = str .. string.char(byte)
	end
	if flag == nil then
		str = lib.CharSet(str, 0)
		str = GenTalkString(str, 12)
	end
	return str
end

--对话
--talkid: 为数字，则为对话编号；为字符串，则为对话本身。
--headid: 头像id
--flag :对话框位置：0 屏幕上方显示, 左边头像，右边对话
--            1 屏幕下方显示, 左边对话，右边头像
--            2 屏幕上方显示, 左边空，右边对话
--            3 屏幕下方显示, 左边对话，右边空
--            4 屏幕上方显示, 左边对话，右边头像
--            5 屏幕下方显示, 左边头像，右边对话
function instruct_1(talkid, headid, flag)
	local s = ReadTalk(talkid)
	if s == nil then
		return 
	end
	TalkEx(s, headid, flag)
end

--得到物品
function instruct_2(thingid, num)
	if JY.Thing[thingid] == nil then
		return 
	end
	instruct_32(thingid, num)
	if num > 0 then
		DrawStrBoxWaitKey(string.format("得到物品%sX%d", "【Ｇ"..JY.Thing[thingid]["名称"].."Ｏ】", num), C_ORANGE, CC.DefaultFont, 1)
	else
		DrawStrBoxWaitKey(string.format("失去物品%sX%d", "【Ｇ"..JY.Thing[thingid]["名称"].."Ｏ】", -num), C_ORANGE, CC.DefaultFont, 1)
	end
end

--修改指定场景坐标的事件
function instruct_3(sceneid, id, v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10)
	if JY.Restart == 1 then
		return
	end
  if sceneid == -2 then
    sceneid = JY.SubScene
  end
  if id == -2 then
    id = JY.CurrentD
  end
  if v0 ~= -2 then
    SetD(sceneid, id, 0, v0)
  end
  if v1 ~= -2 then
    SetD(sceneid, id, 1, v1)
  end
  if v2 ~= -2 then
    SetD(sceneid, id, 2, v2)
  end
  if v3 ~= -2 then
    SetD(sceneid, id, 3, v3)
  end
  if v4 ~= -2 then
    SetD(sceneid, id, 4, v4)
  end
  if v5 ~= -2 then
    SetD(sceneid, id, 5, v5)
  end
  if v6 ~= -2 then
    SetD(sceneid, id, 6, v6)
  end
  if v7 ~= -2 then
    SetD(sceneid, id, 7, v7)
  end
  if v8 ~= -2 then
    SetD(sceneid, id, 8, v8)
  end
  if v9 ~= -2 and v10 ~= -2 and v9 > 0 and v10 > 0 then
    SetS(sceneid, GetD(sceneid, id, 9), GetD(sceneid, id, 10), 3, -1)
    SetD(sceneid, id, 9, v9)
    SetD(sceneid, id, 10, v10)
    SetS(sceneid, GetD(sceneid, id, 9), GetD(sceneid, id, 10), 3, id)
  end
end

function instruct_4(thingid)
	if JY.CurrentThing == thingid then
		return true
	else
		return false
	end
end

function instruct_5()
	return DrawStrBoxYesNo(-1, -1, "是否与之过招(Y/N)?", C_ORANGE, CC.DefaultFont)
end

function instruct_6(warid, tmp, tmp, flag)
	return WarMain(warid, flag)
end

function instruct_7()
	instruct_test("指令7测试")
end

function instruct_8(musicid)
	JY.MmapMusic = musicid
end

function instruct_9()
	return DrawStrBoxYesNo(-1, -1, "是否要求加入(Y/N)?", C_ORANGE, CC.DefaultFont)
end

--入队函数
function instruct_10(personid)
	if JY.Person[personid] == nil then
		lib.Debug("instruct_10 error: person id not exist")
		return 
	end
	local add = 0
	--无酒不欢：畅想不能收自己
	if personid ~= JY.Base["畅想"] then
		for i = 2, CC.TeamNum do
			if JY.Base["队伍" .. i] < 0 then
			  JY.Base["队伍" .. i] = personid
			  add = 1
			  break
			end
		end
	end
	for i = 1, 4 do
		local id = JY.Person[personid]["携带物品" .. i]
		local n = JY.Person[personid]["携带物品数量" .. i]
		if n < 0 then
			n = 0
		end
		if id >= 0 and n > 0 then
			instruct_2(id, n)
			JY.Person[personid]["携带物品" .. i] = -1
			JY.Person[personid]["携带物品数量" .. i] = 0
		end
	end
	AddPersonAttrib(personid, "生命最大值", 0)
	AddPersonAttrib(personid, "内力最大值", 0)
	AddPersonAttrib(personid, "生命", 0)
	AddPersonAttrib(personid, "内力", 0)
	if add == 0 then
		lib.Debug("instruct_10 error: 加入队伍已满")
		return
	end
end

function instruct_11()
	return DrawStrBoxYesNo(-1, -1, "是否(Y/N)?", C_ORANGE, CC.DefaultFont)
end

--休息
function instruct_12(flag)
	for i = 1, CC.TeamNum do
		local id = JY.Base["队伍" .. i]
		if id >= 0 then
			JY.Person[id]["受伤程度"] = 0
			JY.Person[id]["中毒程度"] = 0
			AddPersonAttrib(id, "体力", math.huge)
			AddPersonAttrib(id, "生命", math.huge)
			AddPersonAttrib(id, "内力", math.huge)
		end
	end
end

--dark
function instruct_13()
	if JY.Restart == 1 then
		return
	end
	Cls()
	JY.Darkness = 0
	lib.ShowSlow(20, 0)
	lib.GetKey()
end

--light
function instruct_14()
	if JY.Restart == 1 then
		return
	end
	lib.ShowSlow(20, 1)
	JY.Darkness = 1
end

function instruct_15()
	JY.Status = GAME_DEAD
	Cls()
	DrawString(CC.GameOverX, CC.GameOverY, JY.Person[0]["姓名"], RGB(0, 0, 0), CC.DefaultFont)
	local x = CC.ScreenW - 9 * CC.DefaultFont
	DrawString(x, 10, os.date("%Y-%m-%d %H:%M"), RGB(216, 20, 24), CC.DefaultFont)
	DrawString(x, 10 + CC.DefaultFont + CC.RowPixel, "在地球的某处", RGB(216, 20, 24), CC.DefaultFont)
	DrawString(x, 10 + (CC.DefaultFont + CC.RowPixel) * 2, "当地人口的失踪数", RGB(216, 20, 24), CC.DefaultFont)
	DrawString(x, 10 + (CC.DefaultFont + CC.RowPixel) * 3, "又多了一笔。。。", RGB(216, 20, 24), CC.DefaultFont)
	local loadMenu = {
	{"选择读档", nil, 1},  
	{"回家睡觉去", nil, 1}}
	local y = CC.ScreenH - 4 * (CC.DefaultFont + CC.RowPixel) - 10
	local sl = ShowMenu(loadMenu, #loadMenu, 0, x, y, 0, 0, 0, 0, CC.DefaultFont, C_ORANGE, C_WHITE)
	if sl ==1 then
		local r = SaveList();
			if r < 1 then
				JY.Status = GAME_END
				return 0;
			end
			
			Cls();
			DrawStrBox(-1,CC.StartMenuY,"请稍候...",C_GOLD,CC.DefaultFont);
			ShowScreen();
			local result = LoadRecord(r);
			if result ~= nil then
				instruct_15();
				return 0;
			end
		if JY.Base["无用"] ~= -1 then
			JY.Status = GAME_SMAP
			JY.SubScene = JY.Base["无用"]
			JY.MmapMusic = -1
			JY.MyPic = GetMyPic()
			Init_SMap(1)
		else
			JY.SubScene = -1
			JY.Status = GAME_FIRSTMMAP
		end
		ShowScreen()
		lib.LoadPicture("", 0, 0)
		lib.GetKey()
		Game_Cycle()
	else
		JY.Status = GAME_END
	end
end

function inteam(pid)
	return instruct_16(pid)
end

function instruct_16(personid)
	local r = false
	local xwperson;	--判定人物
	--非战斗中才生效，用于触发剧情等判定
	if personid == JY.Base["畅想"] and JY.Status ~= GAME_WMAP then
		xwperson = 0
	else
		xwperson = personid
	end
	for i = 1, CC.TeamNum do
		if xwperson == JY.Base["队伍" .. i] then
			r = true
			break;
		end
	end
	if JY.Status == GAME_WMAP then
	   if WAR.ZDDH == 329 then
	      for i = 2, CC.TeamNum do
		    if xwperson == JY.Base["队伍" .. i] then
			   r = false
	        end
		  end	
	   end
       if WAR.ZDDH == 322 then
		    if xwperson ~= 0 then
			   r = false
	        end	
	   end	   
	end

	return r
end

function instruct_17(sceneid, level, x, y, v)
	if sceneid == -2 then
		sceneid = JY.SubScene
	end
	SetS(sceneid, x, y, level, v)
end

function instruct_18(thingid)
	for i = 1, CC.MyThingNum do
		if JY.Base["物品" .. i] == thingid then
			return true
		end
	end
	return false
end

function instruct_19(x, y)
	JY.Base["人X1"] = x
	JY.Base["人Y1"] = y
	JY.SubSceneX = 0
	JY.SubSceneY = 0
end

function instruct_20()
	if JY.Base["队伍" .. CC.TeamNum] >= 0 then
		return true
	end
	return false
end

--离队函数
function instruct_21(personid)
	if JY.Person[personid] == nil then
		lib.Debug("instruct_21 error: personid not exist")
		return 
	end
	local j = 0
	for i = 1, CC.TeamNum do
		if personid == JY.Base["队伍" .. i] then
		  j = i
		end
	end
	if j == 0 then
		return 
	end
	for i = j + 1, CC.TeamNum do
		JY.Base["队伍" .. i - 1] = JY.Base["队伍" .. i]
	end
	JY.Base["队伍" .. CC.TeamNum] = -1
	if JY.Person[personid]["武器"] >= 0 then
		JY.Thing[JY.Person[personid]["武器"]]["使用人"] = -1
		JY.Person[personid]["武器"] = -1
	end
	if JY.Person[personid]["防具"] >= 0 then
		JY.Thing[JY.Person[personid]["防具"]]["使用人"] = -1
		JY.Person[personid]["防具"] = -1
	end
	if JY.Person[personid]["动物"] >= 0 then
		JY.Thing[JY.Person[personid]["动物"]]["使用人"] = -1
		JY.Person[personid]["动物"] = -1
	end
	if JY.Person[personid]["修炼物品"] >= 0 then
		JY.Thing[JY.Person[personid]["修炼物品"]]["使用人"] = -1
		JY.Person[personid]["修炼物品"] = -1
	end
	JY.Person[personid]["物品修炼点数"] = 0
end

function instruct_22()
	for i = 1, CC.TeamNum do
		if JY.Base["队伍" .. i] >= 0 then
			JY.Person[JY.Base["队伍" .. i]]["内力"] = 0
		end
	end
end

function instruct_23(personid, value)
	JY.Person[personid]["用毒能力"] = value
	AddPersonAttrib(personid, "用毒能力", 0)
end

function instruct_24()
	instruct_test("指令24测试")
end

--镜头移动
function instruct_25(x1, y1, x2, y2)
	if JY.Restart == 1 then
		return
	end
	local sign = nil
	if y1 ~= y2 then
		if y2 < y1 then
			sign = -1
		else
			sign = 1
		end
		for i = y1 + sign, y2, sign do
			lib.GetKey()
			local t1 = lib.GetTime()
			JY.SubSceneY = JY.SubSceneY + sign
			DrawSMap()
			ShowScreen()
			local t2 = lib.GetTime()
			if t2 - t1 < CC.SceneMoveFrame then
				lib.Delay(CC.SceneMoveFrame - (t2 - t1))
			end
		end
	end
	if x1 ~= x2 then
		if x2 < x1 then
			sign = -1
		else
			sign = 1
		end
		for i = x1 + sign, x2, sign do
			lib.GetKey()
			local t1 = lib.GetTime()
			JY.SubSceneX = JY.SubSceneX + sign
			DrawSMap()
			ShowScreen()
			local t2 = lib.GetTime()
			if t2 - t1 < CC.SceneMoveFrame then
				lib.Delay(CC.SceneMoveFrame - (t2 - t1))
			end
		end
	end
end

function instruct_26(sceneid, id, v1, v2, v3)
	if sceneid == -2 then
		sceneid = JY.SubScene
	end
	local v = GetD(sceneid, id, 2)
	SetD(sceneid, id, 2, v + v1)
	v = GetD(sceneid, id, 3)
	SetD(sceneid, id, 3, v + v2)
	v = GetD(sceneid, id, 4)
	SetD(sceneid, id, 4, v + v3)
end

function instruct_27(id, startpic, endpic)
	local old1, old2, old3 = nil
	if id ~= -1 then
		old1 = GetD(JY.SubScene, id, 5)
		old2 = GetD(JY.SubScene, id, 6)
		old3 = GetD(JY.SubScene, id, 7)
	end
	for i = startpic, endpic, 2 do
		lib.GetKey()
		local t1 = lib.GetTime()
		if id == -1 then
			JY.MyPic = i / 2
		else
			SetD(JY.SubScene, id, 5, i)
			SetD(JY.SubScene, id, 6, i)
			SetD(JY.SubScene, id, 7, i)
		end
		DtoSMap()
		DrawSMap()
		ShowScreen()
		local t2 = lib.GetTime()
		if t2 - t1 < CC.AnimationFrame then
			lib.Delay(CC.AnimationFrame - (t2 - t1))
		end
	end
	if id ~= -1 then
		SetD(JY.SubScene, id, 5, old1)
		SetD(JY.SubScene, id, 6, old2)
		SetD(JY.SubScene, id, 7, old3)
	end
end

function instruct_28(personid, vmin, vmax)
	local v = JY.Person[personid]["品德"]
	if vmin <= v and v <= vmax then
		return true
	else
		return false
	end
end

function instruct_29(personid, vmin, vmax)
	local v = JY.Person[personid]["攻击力"]
	if vmin <= v and v <= vmax then
		return true
	else
		return false
	end
end

--人物自动移动
function instruct_30(x1, y1, x2, y2)
	if JY.Restart == 1 then
		return
	end
  if x1 < x2 then
    for i = x1 + 1, x2 do
      local t1 = lib.GetTime()
      instruct_30_sub1(1)
      local t2 = lib.GetTime()
      if t2 - t1 < CC.PersonMoveFrame then
        lib.Delay(CC.PersonMoveFrame - (t2 - t1))
      end
    end
  elseif x2 < x1 then
    for i = x2 + 1, x1 do
      local t1 = lib.GetTime()
      instruct_30_sub1(2)
      local t2 = lib.GetTime()
      if t2 - t1 < CC.PersonMoveFrame then
        lib.Delay(CC.PersonMoveFrame - (t2 - t1))
      end
    end
  end
  if y1 < y2 then
    for i = y1 + 1, y2 do
      local t1 = lib.GetTime()
      instruct_30_sub1(3)
      local t2 = lib.GetTime()
      if t2 - t1 < CC.PersonMoveFrame then
        lib.Delay(CC.PersonMoveFrame - (t2 - t1))
      end
    end
  elseif y2 < y1 then
    for i = y2 + 1, y1 do
      local t1 = lib.GetTime()
      instruct_30_sub1(0)
      local t2 = lib.GetTime()
      if t2 - t1 < CC.PersonMoveFrame then
        lib.Delay(CC.PersonMoveFrame - (t2 - t1))
      end
    end
  end
end

function instruct_30_sub1(direct)
  local x, y = nil, nil
  AddMyCurrentPic()
  x = JY.Base["人X1"] + CC.DirectX[direct + 1]
  y = JY.Base["人Y1"] + CC.DirectY[direct + 1]
  JY.Base["人方向"] = direct
  JY.MyPic = GetMyPic()
  DtoSMap()
  if SceneCanPass(x, y) == true then
    JY.Base["人X1"] = x
    JY.Base["人Y1"] = y
  end
  JY.Base["人X1"] = limitX(JY.Base["人X1"], 1, CC.SWidth - 2)
  JY.Base["人Y1"] = limitX(JY.Base["人Y1"], 1, CC.SHeight - 2)
  DrawSMap()
  ShowScreen()
  return 1
end

function instruct_30_sub(direct)
  local x, y = nil, nil
  local d_pass = GetS(JY.SubScene, JY.Base["人X1"], JY.Base["人Y1"], 3)

  if d_pass >= 0 and d_pass ~= JY.OldDPass then
    EventExecute(d_pass, 3)
    JY.OldDPass = d_pass
    JY.oldSMapX = -1
    JY.oldSMapY = -1
    JY.D_Valid = nil
  end

  JY.OldDPass = -1
  local isout = 0
  if (((JY.Scene[JY.SubScene]["出口X1"] == JY.Base["人X1"] and JY.Scene[JY.SubScene]["出口Y1"] == JY.Base["人Y1"]) or JY.Scene[JY.SubScene]["出口X2"] ~= JY.Base["人X1"] or JY.Scene[JY.SubScene]["出口Y2"] == JY.Base["人Y1"] or JY.Scene[JY.SubScene]["出口X3"] == JY.Base["人X1"] and JY.Scene[JY.SubScene]["出口Y3"] == JY.Base["人Y1"])) then
    isout = 1
  end
  if isout == 1 then
    JY.Status = GAME_MMAP
    lib.PicInit()
    CleanMemory()
    lib.ShowSlow(20, 1)
    if JY.MmapMusic < 0 then
      JY.MmapMusic = JY.Scene[JY.SubScene]["出门音乐"]
    end
    Init_MMap()
    JY.SubScene = -1
    JY.oldSMapX = -1
    JY.oldSMapY = -1
    lib.DrawMMap(JY.Base["人X"], JY.Base["人Y"], GetMyPic())
    lib.ShowSlow(20, 0)
    lib.GetKey()
    return 
  end
  if JY.Scene[JY.SubScene]["跳转场景"] >= 0 and JY.Base["人X1"] == JY.Scene[JY.SubScene]["跳转口X1"] and JY.Base["人Y1"] == JY.Scene[JY.SubScene]["跳转口Y1"] then
    JY.SubScene = JY.Scene[JY.SubScene]["跳转场景"]
    lib.ShowSlow(20, 1)
    if JY.Scene[JY.SubScene]["外景入口X1"] == 0 and JY.Scene[JY.SubScene]["外景入口Y1"] == 0 then
      JY.Base["人X1"] = JY.Scene[JY.SubScene]["入口X"]
      JY.Base["人Y1"] = JY.Scene[JY.SubScene]["入口Y"]
    else
      JY.Base["人X1"] = JY.Scene[JY.SubScene]["跳转口X2"]
      JY.Base["人Y1"] = JY.Scene[JY.SubScene]["跳转口Y2"]
    end
    Init_SMap(1)
    return 
  end
  AddMyCurrentPic()
  x = JY.Base["人X1"] + CC.DirectX[direct + 1]
  y = JY.Base["人Y1"] + CC.DirectY[direct + 1]
  JY.Base["人方向"] = direct
  JY.MyPic = GetMyPic()
  DtoSMap()
  if SceneCanPass(x, y) == true then
    JY.Base["人X1"] = x
    JY.Base["人Y1"] = y
  end
  JY.Base["人X1"] = limitX(JY.Base["人X1"], 1, CC.SWidth - 2)
  JY.Base["人Y1"] = limitX(JY.Base["人Y1"], 1, CC.SHeight - 2)
  DrawSMap()
  ShowScreen()
  return 1
end

--计算钱是否足够
function instruct_31(num)
	local r = false
	for i = 1, CC.MyThingNum do
		if JY.Base["物品" .. i] == CC.MoneyID and num <= JY.Base["物品数量" .. i] then
			r = true
		end
	end
	return r
end

--增加，减少物品的函数
function instruct_32(thingid, num)
	local p = 1
	--首先控制获取数量，超过30000自动算30000
	if num > 30000 then
		num = 30000
	end
	for i = 1, CC.MyThingNum do
		if JY.Base["物品" .. i] == thingid then
			--已经有一定数量的物品，如果相加之后超过30000，按30000算
			if (JY.Base["物品数量" .. i] + num) > 30000 then
				JY.Base["物品数量" .. i] = 30000
			else
				JY.Base["物品数量" .. i] = JY.Base["物品数量" .. i] + num
			end
			p = i
			break;
		elseif JY.Base["物品" .. i] == -1 then
			JY.Base["物品" .. i] = thingid
			JY.Base["物品数量" .. i] = num
			p = i
			break;
		end
	end
	
	--获取银两的时候刷新银两显示
	if thingid == CC.MoneyID then
		JY.GOLD = JY.Base["物品数量" .. p]
	end
  
  
	--获得天书，增加15点声望
	--获得的时候才增加
	if num > 0 and thingid >= CC.BookStart and thingid < CC.BookStart + CC.BookNum then
		JY.Person[0]["声望"] = JY.Person[0]["声望"] + 15;
		JY.Base["天书数量"] = JY.Base["天书数量"] + 1
		JY.Person[0]["感悟"] = JY.Person[0]["感悟"] + 60
		if JY.Base["畅想"] == 58 or (JY.Base["畅想"] == 685 and (JY.Person[685]["天1"] == 58 or JY.Person[685]["天2"] == 58 or JY.Person[685]["天3"] == 58)) then
		JY.Person[0]["感悟"] = JY.Person[0]["感悟"] + 40
		end
		if JY.Base["畅想"] == 637 or (JY.Base["畅想"] == 685 and (JY.Person[685]["天1"] == 637 or JY.Person[685]["天2"] == 637 or JY.Person[685]["天3"] == 637)) then
		JY.Person[0]["武学常识"] = JY.Person[0]["武学常识"] + 20
		end
		   
		--无酒不欢：用520号人物的品德判定可以摘取的蟠桃数量
		--替换蟠桃树贴图
		JY.Person[520]["品德"] = JY.Person[520]["品德"] + 1
		--在已经种过树的情况下，树会结果，用521号人物的品德判定是否已触发种树事件
		if JY.Person[521]["品德"] == 1 then
			addevent(70, 65, 1, 4119, 1, 2366*2)
		end
		--12书后触发新华山论剑事件
		if JY.Base["天书数量"] == 12 then
			addevent(80, 19, 1, 4141, 1, 4335*2)	--羊
		end
		if JY.Base["畅想"] == 692 or (JY.Base["畅想"] == 685 and (JY.Person[685]["天1"] == 692 or JY.Person[685]["天2"] == 692 or JY.Person[685]["天3"] == 692)) then
		if JY.Base["天书数量"] == 1 then
		   null(62,17)
		end
		if JY.Base["天书数量"] == 5 then
			addevent(62, 17, 1, 4295, 1, 3132*2, 27, 14)	--洪日庆
		end
		end
		--铁拳
		if JY.Base["畅想"] == 693 or (JY.Base["畅想"] == 685 and (JY.Person[685]["天1"] == 693 or JY.Person[685]["天2"] == 693 or JY.Person[685]["天3"] == 693)) then
		AddPersonAttrib(0, "拳掌功夫", 20)
        end
		--金庸
		if JY.Base["畅想"] == 669 or (JY.Base["畅想"] == 685 and (JY.Person[685]["天1"] == 669 or JY.Person[685]["天2"] == 669 or JY.Person[685]["天3"] == 669)) then
		AddPersonAttrib(0, "拳掌功夫", 10)
		AddPersonAttrib(0, "指法技巧", 10)
		AddPersonAttrib(0, "特殊兵器", 10)
		AddPersonAttrib(0, "耍刀技巧", 10)
		AddPersonAttrib(0, "御剑能力", 10)
		AddPersonAttrib(0, "攻击力", 10)
		AddPersonAttrib(0, "轻功", 10)
		AddPersonAttrib(0, "防御力", 10)
		AddPersonAttrib(0, "武学常识", 10)
		
		for i = 144, 153 do
		   if instruct_18(i) then
		      JY.Person[669]["地"..(i-143)] = 999  
		   end
		end
		for i = 154, 157 do
		   if instruct_18(i) then
		      JY.Person[669]["天"..(i-153)] = 999  
		   end
		end
	    end
	end	
	
	if JY.Base["物品数量" .. p] <= 0 then
		for i = p + 1, CC.MyThingNum do
			JY.Base["物品" .. i - 1] = JY.Base["物品" .. i]
			JY.Base["物品数量" .. i - 1] = JY.Base["物品数量" .. i]
		end
		JY.Base["物品" .. CC.MyThingNum] = -1
		JY.Base["物品数量" .. CC.MyThingNum] = 0
	end
end

--人物学会武功
function instruct_33(personid, wugongid, flag)
	local xwperson;	--判定要洗武功的人
	if personid == JY.Base["畅想"] then
		xwperson = 0
	else
		xwperson = personid
	end
	local add = 0
	for i = 1, JY.Person[671]["品德"] do
    if JY.Person[xwperson]["武功" .. i] == 0 then
		JY.Person[xwperson]["武功" .. i] = wugongid
		JY.Person[xwperson]["武功等级" .. i] = 0
		add = 1
		break;
    end
	end
	if add == 0 then
		JY.Person[xwperson]["武功12"] = wugongid
		JY.Person[xwperson]["武功等级12"] = 0
	end
	if flag == 0 then
		DrawStrBoxWaitKey(string.format("%s 学会武功 %s", JY.Person[xwperson]["姓名"], JY.Wugong[wugongid]["名称"]), C_ORANGE, CC.DefaultFont)
	end
end

--改变资质
function instruct_34(id, value)
	local xwperson;	--判定人物
	if id == JY.Base["畅想"] then
		xwperson = 0
	else
		xwperson = id
	end
	local add, str = AddPersonAttrib(xwperson, "资质", value)
	DrawStrBoxWaitKey(JY.Person[xwperson]["姓名"] .. str, C_ORANGE, CC.DefaultFont)
end

--洗武功函数
function instruct_35(personid, id, wugongid, wugonglevel)
	local xwperson;	--判定要洗武功的人
	if personid == JY.Base["畅想"] then
		xwperson = 0
	else
		xwperson = personid
	end
	--被洗掉的武功从自动列表清除
	if JY.Person[xwperson]["武功" .. id + 1] > 0 then
		if JY.Person[xwperson]["武功" .. id + 1] == JY.Person[xwperson]["优先使用"] then
			JY.Person[xwperson]["优先使用"] = 0
		elseif JY.Person[xwperson]["武功" .. id + 1] == JY.Person[xwperson]["主运内功"] then
			JY.Person[xwperson]["主运内功"] = 0
		elseif JY.Person[xwperson]["武功" .. id + 1] == JY.Person[xwperson]["主运轻功"] then
			JY.Person[xwperson]["主运轻功"] = 0
		end
	end
	JY.Person[xwperson]["武功" .. id + 1] = wugongid
	JY.Person[xwperson]["武功等级" .. id + 1] = wugonglevel
end

function instruct_36(sex)
	if JY.Person[0]["性别"] == sex then
		return true
	else
		return false
	end
end

--无酒不欢：加减道德显示
function instruct_37(v)
	AddPersonAttrib(0, "品德", v)
	if v < 0 then
		for i = 1, 15 do
			if JY.Restart == 1 then
				break
			end
			local y_off = i * 2 + CC.DefaultFont + CC.RowPixel
			DrawString(CC.ScreenW/2-CC.DefaultFont*5, CC.ScreenH/4 - CC.DefaultFont - CC.RowPixel + y_off, "你的道德指数下降了"..-v.."点", M_DeepSkyBlue, CC.DefaultFont)
			ShowScreen()		  
			lib.Delay(50)
			Cls()
		end
	else
		for i = 1, 15 do
			if JY.Restart == 1 then
				break
			end
			local y_off = i * 2 + CC.DefaultFont + CC.RowPixel
			DrawString(CC.ScreenW/2-CC.DefaultFont*5, CC.ScreenH/4 + 30 + CC.DefaultFont + CC.RowPixel - y_off, "你的道德指数提升了"..v.."点", PinkRed, CC.DefaultFont)
			ShowScreen()		  
			lib.Delay(50)
			Cls()
		end
	end
end

function instruct_38(sceneid, level, oldpic, newpic)
	if sceneid == -2 then
		sceneid = JY.SubScene
	end
	for i = 0, CC.SWidth - 1 do
		for j = 1, CC.SHeight - 1 do
			if GetS(sceneid, i, j, level) == oldpic then
				SetS(sceneid, i, j, level, newpic)
			end
		end
	end
end

function instruct_39(sceneid)
	JY.Scene[sceneid]["进入条件"] = 0
end

function instruct_40(v)
	JY.Base["人方向"] = v
	JY.MyPic = GetMyPic()
end

function instruct_41(personid, thingid, num)
	local k = 0
	for i = 1, 4 do
		if JY.Person[personid]["携带物品" .. i] == thingid then
			JY.Person[personid]["携带物品数量" .. i] = JY.Person[personid]["携带物品数量" .. i] + num
			k = i
			break;
		end
	end
	if k > 0 and JY.Person[personid]["携带物品数量" .. k] <= 0 then
		JY.Person[personid]["携带物品" .. k] = -1
	end
	if k == 0 then
		for i = 1, 4 do
			if JY.Person[personid]["携带物品" .. i] == -1 then
				JY.Person[personid]["携带物品" .. i] = thingid
				JY.Person[personid]["携带物品数量" .. i] = num
				break;
			end
		end
	end
end

function instruct_42()
	local r = false
	for i = 1, CC.TeamNum do
		if JY.Base["队伍" .. i] >= 0 and JY.Person[JY.Base["队伍" .. i]]["性别"] == 1 then
			r = true
		end
	end
	return r
end

function instruct_43(thingid)
	return instruct_18(thingid)
end

function instruct_44(id1, startpic1, endpic1, id2, startpic2, endpic2)
  local old1 = GetD(JY.SubScene, id1, 5)
  local old2 = GetD(JY.SubScene, id1, 6)
  local old3 = GetD(JY.SubScene, id1, 7)
  local old4 = GetD(JY.SubScene, id2, 5)
  local old5 = GetD(JY.SubScene, id2, 6)
  local old6 = GetD(JY.SubScene, id2, 7)
  for i = startpic1, endpic1, 2 do
	lib.GetKey()
    local t1 = lib.GetTime()
    if id1 == -1 then
      JY.MyPic = i / 2
    else
      SetD(JY.SubScene, id1, 5, i)
      SetD(JY.SubScene, id1, 6, i)
      SetD(JY.SubScene, id1, 7, i)
    end
    if id2 == -1 then
      JY.MyPic = i / 2
    else
      SetD(JY.SubScene, id2, 5, i - startpic1 + startpic2)
      SetD(JY.SubScene, id2, 6, i - startpic1 + startpic2)
      SetD(JY.SubScene, id2, 7, i - startpic1 + startpic2)
    end
    DtoSMap()
    DrawSMap()
    ShowScreen()
    local t2 = lib.GetTime()
    if t2 - t1 < CC.AnimationFrame then
      lib.Delay(CC.AnimationFrame - (t2 - t1))
    end
  end
  SetD(JY.SubScene, id1, 5, old1)
  SetD(JY.SubScene, id1, 6, old2)
  SetD(JY.SubScene, id1, 7, old3)
  SetD(JY.SubScene, id2, 5, old4)
  SetD(JY.SubScene, id2, 6, old5)
  SetD(JY.SubScene, id2, 7, old6)
end

--加轻
function instruct_45(id, value)
	local xwperson;	--判定要洗武功的人
	if id == JY.Base["畅想"] then
		xwperson = 0
	else
		xwperson = id
	end
	local add, str = AddPersonAttrib(xwperson, "轻功", value)
end

--加内
function instruct_46(id, value)
	local xwperson;	--判定要洗武功的人
	if id == JY.Base["畅想"] then
		xwperson = 0
	else
		xwperson = id
	end
	local add, str = AddPersonAttrib(xwperson, "内力最大值", value)
	AddPersonAttrib(xwperson, "内力", 0)
end

--加攻
function instruct_47(id, value)
	local xwperson;	--判定要洗武功的人
	if id == JY.Base["畅想"] then
		xwperson = 0
	else
		xwperson = id
	end
	local add, str = AddPersonAttrib(xwperson, "攻击力", value)
end

--加防
function add_deffense(id, value)
	local xwperson;	--判定要洗武功的人
	if id == JY.Base["畅想"] then
		xwperson = 0
	else
		xwperson = id
	end
	local add, str = AddPersonAttrib(xwperson, "防御力", value)
end

--加血
function instruct_48(id, value)
	local xwperson;	--判定要洗武功的人
	if id == JY.Base["畅想"] then
		xwperson = 0
	else
		xwperson = id
	end
	local add, str = AddPersonAttrib(xwperson, "生命最大值", value)
	AddPersonAttrib(xwperson, "生命", value)
end

--洗内属
function instruct_49(personid, value)
	local xwperson;	--判定要洗内属的人
	if personid == JY.Base["畅想"] then
		xwperson = 0
	else
		xwperson = personid
	end
	JY.Person[xwperson]["内力性质"] = value
end

function instruct_50(id1, id2, id3, id4, id5)
  local num = 0
  if instruct_18(id1) == true then
    num = num + 1
  end
  if instruct_18(id2) == true then
    num = num + 1
  end
  if instruct_18(id3) == true then
    num = num + 1
  end
  if instruct_18(id4) == true then
    num = num + 1
  end
  if instruct_18(id5) == true then
    num = num + 1
  end
  if num == 5 then
    return true
  else
    return false
  end
end

function instruct_51()
	instruct_1(2547 + Rnd(18), 114, 0)
end

function instruct_52()
	DrawStrBoxWaitKey(string.format("你现在的品德指数为: %d", JY.Person[0]["品德"]), C_ORANGE, CC.DefaultFont)
end

function instruct_53()
	DrawStrBoxWaitKey(string.format("你现在的声望指数为: %d", JY.Person[0]["声望"]), C_ORANGE, CC.DefaultFont)
end

function instruct_54()
	for i = 0, JY.SceneNum - 1 do
		JY.Scene[i]["进入条件"] = 0
	end
	JY.Scene[2]["进入条件"] = 2
	JY.Scene[38]["进入条件"] = 2
	JY.Scene[75]["进入条件"] = 1
	JY.Scene[80]["进入条件"] = 1
end

function instruct_55(id, num)
	if GetD(JY.SubScene, id, 2) == num then
		return true
	else
		return false
	end
end

function instruct_56(v)
	--JY.Person[0]["声望"] = JY.Person[0]["声望"] + v
	--instruct_2_sub()
end

function instruct_57()
  instruct_27(-1, 7664, 7674)
  for i = 0, 56, 2 do
    local t1 = lib.GetTime()
    if JY.MyPic < 3844 then
      JY.MyPic = (7676 + i) / 2
    end
    SetD(JY.SubScene, 2, 5, i + 7690)
    SetD(JY.SubScene, 2, 6, i + 7690)
    SetD(JY.SubScene, 2, 7, i + 7690)
    SetD(JY.SubScene, 3, 5, i + 7748)
    SetD(JY.SubScene, 3, 6, i + 7748)
    SetD(JY.SubScene, 3, 7, i + 7748)
    SetD(JY.SubScene, 4, 5, i + 7806)
    SetD(JY.SubScene, 4, 6, i + 7806)
    SetD(JY.SubScene, 4, 7, i + 7806)
    DtoSMap()
    DrawSMap()
    ShowScreen()
    local t2 = lib.GetTime()
    if t2 - t1 < CC.AnimationFrame then
      lib.Delay(CC.AnimationFrame - (t2 - t1))
    end
  end
end

function instruct_58()
  local group = 5
  local num1 = 6
  local num2 = 3
  local startwar = 102
  local flag = {}
  for i = 0, group - 1 do
    for j = 0, num1 - 1 do
      flag[j] = 0
    end
    for j = 1, num2 do
      local r = nil
      while 1 do
        r = Rnd(num1)
        if flag[r] == 0 then
          flag[r] = 1
          do break end
        end
      end
      local warnum = r + i * num1
      WarLoad(warnum + startwar)
      instruct_1(2854 + warnum, JY.Person[WAR.Data["敌人1"]]["头像代号"], 0)
      instruct_0()
      if WarMain(warnum + startwar, 0) == true then
        instruct_0()
        instruct_13()
        TalkEx("还有那位前辈肯赐教？", 0, 1)
        instruct_0()
      else
        instruct_15()
        return 
      end
    end
    if i < group - 1 then
      TalkEx(JY.Person[0]["外号"].."已连战三场，*可先休息再战．", 70, 0)
      instruct_0()
      instruct_14()
      lib.Delay(300)
      if JY.Person[0]["受伤程度"] < 50 and JY.Person[0]["中毒程度"] <= 0 then
        JY.Person[0]["受伤程度"] = 0
        AddPersonAttrib(0, "体力", math.huge)
        AddPersonAttrib(0, "内力", math.huge)
        AddPersonAttrib(0, "生命", math.huge)
      end
      instruct_13()
      TalkEx("我已经休息够了，*有谁要再上？", 0, 1)
      instruct_0()
    end
  end
  TalkEx("接下来换谁？**．．．．*．．．．***没有人了吗？", 0, 1)
  instruct_0()
  TalkEx("如果还没有人要出来向这位*"..JY.Person[0]["外号"].."挑战，那麽这武功天下*第一之名，武林盟主之位，*就由这位"..JY.Person[0]["外号"].."夺得．***．．．．．．*．．．．．．*．．．．．．*好，恭喜"..JY.Person[0]["外号"].."，这武林盟主*之位就由"..JY.Person[0]["外号"].."获得，而这把*”武林神杖”也由你保管．", 70, 0)
  instruct_0()
  TalkEx("恭喜"..JY.Person[0]["外号"].."！", 12, 0)
  instruct_0()
  TalkEx("小兄弟，恭喜你！", 64, 4)
  instruct_0()
  TalkEx("好，今年的武林大会到此已*圆满结束，希望明年各位武*林同道能再到我华山一游．", 19, 0)
  instruct_0()
  instruct_14()
  for i = 24, 72 do
    instruct_3(-2, i, 0, 0, -1, -1, -1, -1, -1, -1, -2, -2, -2)
  end
  instruct_0()
  instruct_13()
  TalkEx("历经千辛万苦，我终於打败*群雄，得到这武林盟主之位*及神杖．*但是”圣堂”在那呢？*为什麽没人告诉我，难道大*家都不知道．*这会儿又有的找了．", 0, 1)
  instruct_0()
  instruct_2(143, 1)
end

--全部队友离队
function instruct_59()
	for i = CC.TeamNum, 2, -1 do
		if JY.Base["队伍" .. i] >= 0 then
			instruct_21(JY.Base["队伍" .. i])
		end
	end
	for i,v in ipairs(CC.AllPersonExit) do
		instruct_3(v[1], v[2], 0, 0, -1, -1, -1, -1, -1, -1, 0, -2, -2)
	end
end

function instruct_60(sceneid, id, num)
  if sceneid == -2 then
    sceneid = JY.SubScene
  end
  if id == -2 then
    id = JY.CurrentD
  end
  if GetD(sceneid, id, 5) == num then
    return true
  else
    return false
  end
end

function instruct_61()
  for i = 11, 24 do
    if GetD(JY.SubScene, i, 5) ~= 4664 then
      return false
    end
  end
  return true
end

--通关函数
function instruct_62(id1, startnum1, endnum1, id2, startnum2, endnum2)
	--JY.MyPic = -1
	--instruct_44(id1, startnum1, endnum1, id2, startnum2, endnum2)
	--ShowScreen()
	lib.Delay(200)
	say("本次游戏就到这里了，选择重新开始可进行下一周目的游戏！", 260, 5, "无酒不欢")
	if JY.Person[124]["天1"] > 6 then
	   DrawStrBoxWaitKey("恭喜获得专精一和录像带奖励，下次游戏可以使用。", C_GOLD, CC.Fontbig, nil, C_GOLD)
	end

	if JY.Person[124]["天1"] > 19 then
	   DrawStrBoxWaitKey("恭喜获得专精二奖励，下次游戏可以使用。", C_GOLD, CC.Fontbig, nil, C_GOLD)
	end
	
	if JY.Person[674]["品德"] == 120 then
	   DrawStrBoxWaitKey("恭喜获得专精一、二和破邪飞剑奖励，下次游戏可以使用。", C_GOLD, CC.Fontbig, nil, C_GOLD)
	end
	if JY.Person[124]["天1"] > 16 or JY.Person[674]["品德"] == 120 then
	   
	   local menu = {}
	   local a1,a2,a3,b1,b2,b3
	   a1 = math.random(7)
	   a2 = math.random(7)
	   a3 = math.random(7)
	   b1 = math.random(7)
	   b2 = math.random(7)
	   b3 = math.random(7)
	   if a1 > 5 and math.random(2) == 1 then
	      a1 = math.random(10)
		  if a1 > 7 and math.random(2) == 1 then
		  a1 = math.random(5)
		  end
	   end
	   if a2 > 5 and math.random(2) == 1 then
	      a2 = math.random(10)
		  if a2 > 6 and math.random(2) == 1 then
		  a2 = math.random(5)
		  end
	   end
	   if a3 > 5 and math.random(2) == 1 then
	      a3 = math.random(10)
		  if a3 > 5 and math.random(2) == 1 then
		  a3 = math.random(5)
		  end
	   end
	   menu[1] = tf[a1][b1]
	   menu[2] = tf[a2][b2]
	   menu[3] = tf[a3][b3]
	   DrawStrBoxWaitKey("请选择下周目奖励天赋", C_GOLD, CC.Fontbig, nil, C_GOLD)
	   local wh = ShowMenu2(menu, #menu, 1, 3, CC.ScreenW/2-CC.DefaultFont*10-155, 200, 0, 0, 1, 0, CC.DefaultFont, C_RED, C_WHITE)
	   if wh == 1 then
	   JY.Person[125]["品德"] = a1
	   JY.Person[125]["声望"] = b1
	   elseif wh == 2 then
	   JY.Person[125]["品德"] = a2
	   JY.Person[125]["声望"] = b2
	   elseif wh == 3 then
	   JY.Person[125]["品德"] = a3
	   JY.Person[125]["声望"] = b3
	   end
	
	end
	--增加周目
	local x = AddZM()
	
	--lib.PlayMPEG("ending.mp4",VK_ESCAPE)
	
	---[[
	Cls()
	lib.FillColor(0, 0, CC.ScreenW, CC.ScreenH, C_BLACK)
	DrawString(350, 200, "片尾曲《四大山》", C_WHITE, CC.DefaultFont)
	DrawString(375, 300, "演唱：老凡总", C_WHITE, CC.DefaultFont)
	ShowScreen()
  
	PlayMIDI(116)
	local stime = 0
	local a = 1
	local lyrics = {
	{530,"吓 近万个小时 精心打磨"},
	{560,"做游戏为了什么冷笑着"},
	{590,"前辈元老功高又如何"},
	{610,"开源码我随手可得"},
	{640,"我的 加密了得 却奈何 赞助还不够多"},
	{680,"江湖难测 人傻钱多 谁争六级会员的资格"},
	{730,"论坛里 发帖要统一 否则请离去"},
	{810,"充过钱的** 我记得你 你再来充一笔"},
	{920,"抄抄 抄抄 抄抄抄抄"},
	{940,"抄袭来的代码真的不错"},
	{970,"我我 我我 我我我我"},
	{1000,"只要加密它们就是我的"},
	{1030,"作作 作作 作作作作"},
	{1050,"国产绿色益智单机大作"},
	{1070,"你你 你你 你你你你"},
	{1100,"你的钱包终究要属于我"},
	{1220,"吓 阴谋破坏者 在论坛等着"},
	{1250,"讲道理 赢了什么 删封沉"},
	{1280,"天下谁的 原创又如何"},
	{1300,"开源码 我辈善抄袭"},
	{1320,"我的游戏热门 却奈何"},
	{1350,"徒增虚名一个"},
	{1370,"没有赞助 都是辣鸡"},
	{1390,"谁争热心玩家的资格"},
	{1410,"小城里 岁月流过去 清澈钱包里"},
	{1510,"充过钱的** 我记得你 骄傲的活下去"},
	{1610,"抄抄 抄抄 抄抄抄抄"},
	{1630,"抄过来的代码真的实用"},
	{1660,"发发 发发 发发发发"},
	{1680,"不发帖说就没赞助收入"},
	{1710,"过过 过过 过过过过"},
	{1730,"过错软弱从来不属于我"},
	{1760,"你你 你你 你你你你"},
	{1780,"你的钱包终究要属于我"},
	{2100,"抄抄 抄抄 抄抄抄抄"},
	{2120,"抄袭来的代码真的不错"},
	{2140,"我我 我我 我我我我"},
	{2170,"只要加密它们就是我的"},
	{2190,"作作 作作 作作作作"},
	{2210,"国产绿色益智单机大作"},
	{2240,"你你 你你 你你你你"},
	{2260,"你的钱包终究要属于我"},
	{2310,"论坛里 发帖要统一 否则请离去"},
	{2390,"充过钱的** 我记得你 你再来充一笔"},
	{2700,"全剧终 感谢支持"},
	{2750," "}
	}
	while true do
		if JY.Restart == 1 then
			break
		end
		local key = lib.GetKey()
		lib.Delay(100)
		stime = stime + 1
		if stime == lyrics[a][1] then
			local size = CC.DefaultFont
			Cls()
			lib.FillColor(0, 0, CC.ScreenW, CC.ScreenH, C_BLACK)
			DrawString(350, 200, "片尾曲《四大山》", C_WHITE, size)
			DrawString(375, 300, "演唱：老凡总", C_WHITE, size)
			local align = CC.ScreenW/2 - (string.len(lyrics[a][2])/2*size)/2
			DrawString(align, 500, lyrics[a][2], C_WHITE, size)
			ShowScreen()
			a = a + 1
		end
		if a > #lyrics then
			break
		end
		if key == VK_ESCAPE then
			break
		end
	end--]]
	
	Cls()
	
	DrawStrBoxWaitKey("获得【Ｇ秘武残章Ｏ】×"..x, C_ORANGE, CC.DefaultFont, 2)
  
	JY.Status=GAME_END;
end

function instruct_63(personid, sex)
	JY.Person[personid]["性别"] = sex
end

--无酒不欢：商店数据
function instruct_64()
	local headid = 223
	local id = -1
	for i = 0, JY.ShopNum - 1 do
		if CC.ShopScene[i].sceneid == JY.SubScene then
		  id = i
		end
	end
	if id < 0 then
		return 
	end
	TalkEx("这位"..JY.Person[0]["外号"].."，看看有什么需要的，小店卖的东西价钱绝对公道。", headid, 0,"商家")
	local menu = {}
	for i = 1, 6 do
		local thingid = JY.Shop[id]["物品" .. i]
		if thingid ~= -1 then
			menu[i] = {}
			menu[i][1] = string.format("%-12s %5d", JY.Thing[thingid]["名称"], JY.Shop[id]["物品价格" .. i])
			menu[i][2] = nil
			if JY.Shop[id]["物品数量" .. i] > 0 then
			  menu[i][3] = 1
			else
			  menu[i][3] = 0
			end
		end
	end
		

	--3书以前没有混元
	--if JY.Base["天书数量"] < 3 and id == 0 then
	--	menu[5][3] = 0
	--end

	local x1 = (CC.ScreenW - 9 * CC.DefaultFont - 2 * CC.MenuBorderPixel) / 2
	local y1 = (CC.ScreenH - 5 * CC.DefaultFont - 4 * CC.RowPixel - 2 * CC.MenuBorderPixel) / 2
	local r = ShowMenu(menu, #menu, 0, x1, y1, 0, 0, 1, 1, CC.DefaultFont, C_ORANGE, C_WHITE)
	--[[
	local itemJC = {}
	itemJC[0] = {38, 12, 28, 14, 68, -1, 400, 100, 80, 500, 6000, -1}
	itemJC[1] = {48, 0, 29, 15, 90, -1, 400, 100, 100, 500, 1000, -1}
	itemJC[2] = {54, 3, 32, 16, 159, -1, 400, 100, 100, 600, 600, -1}
	itemJC[3] = {63, 7, 33, 17, 175, -1, 400, 200, 120, 600, 800, -1}
	itemJC[4] = {27, 9, 34, 22, 69, -1, 2000, 50, 130, 400, 8000, -1}]]
	if r > 0 then
		if instruct_31(JY.Shop[id]["物品价格" .. r]) == false then
			TalkEx("非常抱歉，你身上的钱似乎不够。", headid, 0,"商家")
		else
			JY.Shop[id]["物品数量" .. r] = JY.Shop[id]["物品数量" .. r] - 1
			instruct_32(CC.MoneyID, -JY.Shop[id]["物品价格" .. r])
			instruct_32(JY.Shop[id]["物品" .. r], 1)
			TalkEx(JY.Person[0]["外号"].."买了小店的东西，保证绝不后悔。", headid, 0,"商家")
		end
	end
	for i,v in ipairs(CC.ShopScene[id].d_leave) do
		instruct_3(-2, v, 0, -2, -1, -1, 939, -1, -1, -1, -2, -2, -2)
	end
end


function instruct_65()
  local id = -1
  for i = 0, JY.ShopNum - 1 do
    if CC.ShopScene[i].sceneid == JY.SubScene then
      id = i
    end
  end
  if id < 0 then
    return 
  end
  instruct_3(-2, CC.ShopScene[id].d_shop, 0, -2, -1, -1, -1, -1, -1, -1, -2, -2, -2)
  for i,v in ipairs(CC.ShopScene[id].d_leave) do
    instruct_3(-2, v, 0, -2, -1, -1, -1, -1, -1, -1, -2, -2, -2)
  end
  local newid = id + 1
  if newid >= 5 then
    newid = 0
  end
  instruct_3(CC.ShopScene[newid].sceneid, CC.ShopScene[newid].d_shop, 1, -2, 938, -1, -1, 8256, 8256, 8256, -2, -2, -2)
end

function instruct_66(id)
  PlayMIDI(id)
end

function instruct_67(id)
  PlayWavAtk(id)
end


--选择框，每个选项都带边框
--title 标题
--str 内容 *换行
--button 选项
--num 选项的个数，一定要和选项对应起来
--headid 显示在内容左边的贴图，如果不传值则不显示贴图
function JYMsgBox(title, str, button, num, headid, isEsc)
	if JY.Restart == 1 then
		return 1
	end
	local strArray = {}
	local xnum, ynum, width, height = nil, nil, nil, nil
	local picw, pich = 0, 0
	local x1, x2, y1, y2 = nil, nil, nil, nil
	local size = CC.DefaultFont;
	local xarr = {};

	local function between(x, select)
		for i=1, num do
			if xarr[i] < x and x < xarr[i] + string.len(button[i])*size/2 then
				return i
			end
		end
		return select
	end
  
	if headid ~= nil then
		headid = headid*2;
		--picw, pich = lib.PicGetXY(1, headid)
		picw, pich = lib.GetPNGXY(1, headid)
		picw = picw + CC.MenuBorderPixel * 2
		pich = pich + CC.MenuBorderPixel * 2
	end
	ynum, strArray = Split(str, "*")
	xnum = 0
	for i = 1, ynum do
		local len = string.len(strArray[i])
		if xnum < len then
			xnum = len
		end
	end
	if xnum < 12 then
		xnum = 12
	end
	width = CC.MenuBorderPixel * 2 + math.modf(size * xnum / 2) + (picw)
	height = CC.MenuBorderPixel * 2 + (size + CC.MenuBorderPixel) * ynum
	if height < pich then
		height = pich
	end
	y2 = height
	height = height + CC.MenuBorderPixel * 2 + size * 2
	x1 = (CC.ScreenW - (width)) / 2 + CC.MenuBorderPixel
	x2 = x1 + (picw)
	y1 = (CC.ScreenH - (height)) / 2 + CC.MenuBorderPixel + 2 + size * 0.7
	y2 = y2 + (y1) - 5
	local select = 1

	Cls();
  
	DrawBoxTitle(width, height, title, C_GOLD)
	if headid ~= nil then
		--lib.PicLoadCache(1, headid, x1, y1, 1, 0)
		lib.LoadPNG(1, headid, x1, y1,1)
	end
	for i = 1, ynum do
		DrawString(x2, y1 + (CC.MenuBorderPixel + size) * (i - 1), strArray[i], C_WHITE, size)
	end
	
	local yczj = 0	--隐藏主角张家辉
	
	if title == "主角选择" then
		yczj = 1
	end
	
	local surid = lib.SaveSur((CC.ScreenW - (width)) / 2 - 4, (CC.ScreenH - (height)) / 2 - size, (CC.ScreenW + (width)) / 2 + 4, (CC.ScreenH + (height)) / 2 + 4)
	while true do
		if JY.Restart == 1 then
			break
		end
		Cls();
		lib.LoadSur(surid, (CC.ScreenW - (width)) / 2 - 4, (CC.ScreenH - (height)) / 2 - size)
		
		for i = 1, num do
			local color, bjcolor = nil, nil
			if i == select then
				color = M_Yellow
				bjcolor = M_DarkOliveGreen
			else
				color = M_DarkOliveGreen
			end
			xarr[i] = (CC.ScreenW - (width)) / 2 + (width) * i / (num + 1) - string.len(button[i]) * size / 4;
			DrawStrBox2(xarr[i], y2, button[i], color, size, bjcolor)
		end
		ShowScreen()
		  
		local key, ktype, mx, my = WaitKey(1)
		lib.Delay(CC.Frame)
		if key == VK_ESCAPE or ktype == 4 then
			if isEsc ~= nil and isEsc == 1 then
				select = -2
				break
			end
		elseif key == VK_LEFT or ktype == 6 then
			select = select - 1
			if select < 1 then
				select = num
			end
			if yczj == 1 and key == VK_LEFT then
				YC_ZhangJiaHui(key)
			end
		elseif key == VK_RIGHT or ktype == 7 then
			select = select + 1
			if num < select then
				select = 1
			end
			if yczj == 1 and key == VK_RIGHT then
				YC_ZhangJiaHui(key)
			end
		elseif key == VK_UP then
			if yczj == 1 then
				YC_ZhangJiaHui(key)
			end
		elseif key == VK_DOWN then
			if yczj == 1 then
				YC_ZhangJiaHui(key)
			end
		elseif key >= VK_A and key <= VK_Z then
			if yczj == 1 then
				YC_ZhangJiaHui(key)
				YC_Kael(key)
			end
		elseif key == VK_RETURN or key == VK_SPACE or ktype == 5 then
			break
		elseif ktype == 2 or ktype == 3 then
			if mx >= x1 and mx <= x1 + width and my >= y2 and my <= y2 + 2*CC.MenuBorderPixel + size then
				--无酒不欢：这里pass in select，避免在选择不到的情况下返回不存在的选项
				select = between(mx, select);
				if select > 0 and select <= num and ktype==3 then
					break
				end
			end
		end
		--隐藏主角张家辉
		if yczj == 1 and YC.ZJH == 12 then
			YC.ZJH = 0
			return 3
		end
		if yczj == 1 and YC.Kael == 4 then
			YC.Kael = 0
			return 4
		end
	end
	select = limitX(select, -2, num)
	lib.FreeSur(surid)
	
	Cls()
	return select
end

function JYMsgBox2(title, str, button, num, headid, isEsc)
	if JY.Restart == 1 then
		return 1
	end
	local strArray = {}
	local xnum, ynum, width, height = nil, nil, nil, nil
	local picw, pich = 0, 0
	local x1, x2, y1, y2 = nil, nil, nil, nil
	local size = CC.DefaultFont;
	local xarr = {};

	local function between(x, select)
		for i=1, num do
			if xarr[i] < x and x < xarr[i] + string.len(button[i])*size/2 then
				return i
			end
		end
		return select
	end
  
	if headid ~= nil then
		headid = headid*2;
		picw, pich = lib.GetPNGXY(1, headid)
		picw = picw + CC.MenuBorderPixel * 2
		pich = pich + CC.MenuBorderPixel * 2
	end
	ynum, strArray = Split(str, "*")
	xnum = 0
	for i = 1, ynum do
		local len = string.len(strArray[i])
		if xnum < len then
			xnum = len
		end
	end
	if xnum < 12 then
		xnum = 12
	end
	width = CC.MenuBorderPixel * 2 + math.modf(size * xnum / 2) + (picw)
	height = CC.MenuBorderPixel * 2 + (size + CC.MenuBorderPixel) * ynum
	if height < pich then
		height = pich
	end
	y2 = height
	height = height + CC.MenuBorderPixel * 2 + size * 2
	x1 = (CC.ScreenW - (width)) / 2 + CC.MenuBorderPixel
	x2 = x1 + (picw)
	y1 = (CC.ScreenH - (height)) / 2 + CC.MenuBorderPixel + 2 + size * 0.7
	y2 = y2 + (y1) - 5
	local select = 1

	Cls()
  
	DrawBoxTitle(width, height, title, C_GOLD)
	if headid ~= nil then
		lib.LoadPNG(1, headid, x1, y1,1)
	end
	for i = 1, ynum do
		DrawString(x2, y1 + (CC.MenuBorderPixel + size) * (i - 1), strArray[i], C_WHITE, size)
	end
	
	local surid = lib.SaveSur((CC.ScreenW - (width)) / 2 - 4, (CC.ScreenH - (height)) / 2 - size, (CC.ScreenW + (width)) / 2 + 4, (CC.ScreenH + (height)) / 2 + 4)
	while true do
		if JY.Restart == 1 then
			break
		end
		Cls();
		lib.LoadSur(surid, (CC.ScreenW - (width)) / 2 - 4, (CC.ScreenH - (height)) / 2 - size)
		
		for i = 1, num do
			local color, bjcolor = nil, nil
			if i == select then
				color = M_Yellow
				bjcolor = M_DarkOliveGreen
			else
				color = M_DarkOliveGreen
			end
			xarr[i] = (CC.ScreenW - (width)) / 2 + (width) * i / (num + 1) - string.len(button[i]) * size / 4;
			DrawStrBox2(xarr[i], y2, button[i], color, size, bjcolor)
		end
		ShowScreen()
		  
		local key, ktype, mx, my = WaitKey(1)
		lib.Delay(CC.Frame)
		if key == VK_ESCAPE or ktype == 4 then
			if isEsc ~= nil and isEsc == 1 then
				select = -2
				break
			end
		elseif key == VK_LEFT or ktype == 6 then
			select = select - 1
			if select < 1 then
				select = num
			end
		elseif key == VK_RIGHT or ktype == 7 then
			select = select + 1
			if num < select then
				select = 1
			end
		elseif key == VK_RETURN or key == VK_SPACE or ktype == 5 then
			break
		elseif ktype == 2 or ktype == 3 then
			if mx >= x1 and mx <= x1 + width and my >= y2 and my <= y2 + 2*CC.MenuBorderPixel + size then
				--无酒不欢：这里pass in select，避免在选择不到的情况下返回不存在的选项
				select = between(mx, select);
				if select > 0 and select <= num and ktype==3 then
					break
				end
			end
		end
	end
	select = limitX(select, -2, num)
	lib.FreeSur(surid)
	
	Cls()
	return button[select]
end

function JYMsgBox3(title, str, button, num, headid, isEsc)
	if JY.Restart == 1 then
		return 1
	end
	local strArray = {}
	local xnum, ynum, width, height = nil, nil, nil, nil
	local picw, pich = 0, 0
	local x1, x2, y1, y2 = nil, nil, nil, nil
	local size = CC.DefaultFont;
	local xarr = {};

	local function between(x, select)
		for i=1, num do
			if xarr[i] < x and x < xarr[i] + string.len(button[i])*size/2 then
				return i
			end
		end
		return select
	end
  
	if headid ~= nil then
		headid = headid*2;
		--picw, pich = lib.PicGetXY(1, headid)
		picw, pich = lib.GetPNGXY(1, headid)
		picw = picw + CC.MenuBorderPixel * 2
		pich = pich + CC.MenuBorderPixel * 2
	end
	ynum, strArray = Split(str, "*")
	xnum = 0
	for i = 1, ynum do
		local len = string.len(strArray[i])
		if xnum < len then
			xnum = len
		end
	end
	if xnum < 12 then
		xnum = 12
	end
	width = CC.MenuBorderPixel * 2 + math.modf(size * xnum / 2) + (picw)+300
	height = CC.MenuBorderPixel * 2 + (size + CC.MenuBorderPixel) * ynum
	if height < pich then
		height = pich
	end
	y2 = height
	height = height + CC.MenuBorderPixel * 2 + size * 2
	x1 = (CC.ScreenW - (width)) / 2 + CC.MenuBorderPixel
	x2 = x1 + (picw)
	y1 = (CC.ScreenH - (height)) / 2 + CC.MenuBorderPixel + 2 + size * 0.7
	y2 = y2 + (y1) - 5
	local select = 1

	Cls();
  
	DrawBoxTitle(width, height, title, C_GOLD)
	if headid ~= nil then
		--lib.PicLoadCache(1, headid, x1, y1, 1, 0)
		lib.LoadPNG(1, headid, x1, y1,1)
	end
	for i = 1, ynum do
		DrawString(x2, y1 + (CC.MenuBorderPixel + size) * (i - 1), strArray[i], C_WHITE, size)
	end
	
	local yczj = 0	--隐藏主角张家辉
	
	if title == "主角选择" then
		yczj = 1
	end
	
	local surid = lib.SaveSur((CC.ScreenW - (width)) / 2 - 4, (CC.ScreenH - (height)) / 2 - size, (CC.ScreenW + (width)) / 2 + 4, (CC.ScreenH + (height)) / 2 + 4)
	while true do
		if JY.Restart == 1 then
			break
		end
		Cls();
		lib.LoadSur(surid, (CC.ScreenW - (width)) / 2 - 4, (CC.ScreenH - (height)) / 2 - size)
		
		for i = 1, num do
			local color, bjcolor = nil, nil
			if i == select then
				color = M_Yellow
				bjcolor = M_DarkOliveGreen
			else
				color = M_DarkOliveGreen
			end
			xarr[i] = (CC.ScreenW - (width)) / 2 + (width) * i / (num + 1) - string.len(button[i]) * size / 4;
			DrawStrBox2(xarr[i], y2, button[i], color, size, bjcolor)
		end
		ShowScreen()
		  
		local key, ktype, mx, my = WaitKey(1)
		lib.Delay(CC.Frame)
		if key == VK_ESCAPE or ktype == 4 then
			if isEsc ~= nil and isEsc == 1 then
				select = -2
				break
			end
		elseif key == VK_LEFT or ktype == 6 then
			select = select - 1
			if select < 1 then
				select = num
			end
			if yczj == 1 and key == VK_LEFT then
				YC_ZhangJiaHui(key)
			end
		elseif key == VK_RIGHT or ktype == 7 then
			select = select + 1
			if num < select then
				select = 1
			end
			if yczj == 1 and key == VK_RIGHT then
				YC_ZhangJiaHui(key)
			end
		elseif key == VK_UP then
			if yczj == 1 then
				YC_ZhangJiaHui(key)
			end
		elseif key == VK_DOWN then
			if yczj == 1 then
				YC_ZhangJiaHui(key)
			end
		elseif key >= VK_A and key <= VK_Z then
			if yczj == 1 then
				YC_ZhangJiaHui(key)
				YC_Kael(key)
			end
		elseif key == VK_RETURN or key == VK_SPACE or ktype == 5 then
			break
		elseif ktype == 2 or ktype == 3 then
			if mx >= x1 and mx <= x1 + width and my >= y2 and my <= y2 + 2*CC.MenuBorderPixel + size then
				--无酒不欢：这里pass in select，避免在选择不到的情况下返回不存在的选项
				select = between(mx, select);
				if select > 0 and select <= num and ktype==3 then
					break
				end
			end
		end
		--隐藏主角张家辉
		if yczj == 1 and YC.ZJH == 12 then
			YC.ZJH = 0
			return 3
		end
		if yczj == 1 and YC.Kael == 4 then
			YC.Kael = 0
			return 4
		end
	end
	select = limitX(select, -2, num)
	lib.FreeSur(surid)
	
	Cls()
	return select
end

--显示带边框的文字
function DrawBoxTitle(width, height, str, color)
  local s = 4
  local x1, y1, x2, y2, tx1, tx2 = nil, nil, nil, nil, nil, nil
  local fontsize = s + CC.DefaultFont
  local len = string.len(str) * fontsize / 2
  x1 = (CC.ScreenW - width) / 2
  x2 = (CC.ScreenW + width) / 2
  y1 = (CC.ScreenH - height) / 2
  y2 = (CC.ScreenH + height) / 2
  tx1 = (CC.ScreenW - len) / 2
  tx2 = (CC.ScreenW + len) / 2
  lib.Background(x1, y1 + s, x1 + s, y2 - s, 128)
  lib.Background(x1 + s, y1, x2 - s, y2, 128)
  lib.Background(x2 - s, y1 + s, x2, y2 - s, 128)
  lib.Background(tx1, y1 - fontsize / 2 + s, tx2, y1, 128)
  lib.Background(tx1 + s, y1 - fontsize / 2, tx2 - s, y1 - fontsize / 2 + s, 128)
  local r, g, b = GetRGB(color)
  DrawBoxTitle_sub(x1 + 1, y1 + 1, x2, y2, tx1 + 1, y1 - fontsize / 2 + 1, tx2, y1 + fontsize / 2, RGB(math.modf(r / 2), math.modf(g / 2), math.modf(b / 2)))
  DrawBoxTitle_sub(x1, y1, x2 - 1, y2 - 1, tx1, y1 - fontsize / 2, tx2 - 1, y1 + fontsize / 2 - 1, color)
  DrawString(tx1 + 2 * s, y1 - (fontsize - s) / 2, str, color, CC.DefaultFont)
end

function DrawBoxTitle_sub(x1, y1, x2, y2, tx1, ty1, tx2, ty2, color)
  local s = 4
  lib.DrawRect(x1 + s, y1, tx1, y1, color)
  lib.DrawRect(tx2, y1, x2 - s, y1, color)
  lib.DrawRect(x2 - s, y1, x2 - s, y1 + s, color)
  lib.DrawRect(x2 - s, y1 + s, x2, y1 + s, color)
  lib.DrawRect(x2, y1 + s, x2, y2 - s, color)
  lib.DrawRect(x2, y2 - s, x2 - s, y2 - s, color)
  lib.DrawRect(x2 - s, y2 - s, x2 - s, y2, color)
  lib.DrawRect(x2 - s, y2, x1 + s, y2, color)
  lib.DrawRect(x1 + s, y2, x1 + s, y2 - s, color)
  lib.DrawRect(x1 + s, y2 - s, x1, y2 - s, color)
  lib.DrawRect(x1, y2 - s, x1, y1 + s, color)
  lib.DrawRect(x1, y1 + s, x1 + s, y1 + s, color)
  lib.DrawRect(x1 + s, y1 + s, x1 + s, y1, color)
  DrawBox_1(tx1, ty1, tx2, ty2, color)
end

function Init_SMap(showname)
	lib.PicInit()
	--加载场景贴图文件
	lib.PicLoadFile(CC.SMAPPicFile[1], CC.SMAPPicFile[2], 0)

	lib.LoadPNGPath(CC.HeadPath, 1, CC.HeadNum, limitX(CC.ScreenW/936*100,0,100))
	
	lib.LoadPNGPath(CC.PTPath, 95, CC.PTNum, limitX(CC.ScreenW/936*100,0,100))
	
	lib.LoadPNGPath(CC.UIPath, 96, CC.UINum, limitX(CC.ScreenW/936*100,0,100))
	
	lib.PicLoadFile(CC.ThingPicFile[1], CC.ThingPicFile[2], 2, 100, 100)
  
	PlayMIDI(JY.Scene[JY.SubScene]["进门音乐"])
	JY.oldSMapX = -1
	JY.oldSMapY = -1
	JY.SubSceneX = 0
	JY.SubSceneY = 0
	JY.OldDPass = -1
	JY.D_Valid = nil
	DrawSMap()
	lib.GetKey()
	if showname == 1 then
		DrawStrBox(-1, 10, JY.Scene[JY.SubScene]["名称"], C_WHITE, CC.DefaultFont)
		ShowScreen()
		WaitKey()
	end
  
	AutoMoveTab = {[0] = 0}
end

--新对话方式
--加入控制字符
--暂停，任意键后继续，ｐ
--控制颜色Ｒ=redＧ=goldＢ=blackＷ=whiteＯ=orange
--控制字符显示速度０,１,２,３,４,５,６,７,８,９
--控制字体ＡＳＤＦ
--控制换行Ｈ   分页Ｐ
--Ｎ代表自己ｎ代表主角
function say(s,pid,flag,name)          --个人新对话
	if JY.EnableSay == 0 then
		return
	end
	if JY.Restart == 1 then
		return
	end
    local picw=130;       --最大头像图片宽高
	local pich=130;
	local talkxnum=22;         --对话一行字数
	local talkynum=3;          --对话行数
	local dx=2;
	local dy=2;
    local boxpicw=picw+10;
	local boxpich=pich+10;
	local boxtalkw=talkxnum*CC.DefaultFont+10;
	local boxtalkh=boxpich-27;
	local headid = pid;
	--头像的确认
	if pid == 0 then
		if JY.Base["标准"] > 0 then
			if JY.Person[0]["性别"] == 0 then
				headid = 280 + JY.Base["标准"]
			else
				headid = 500 + JY.Base["标准"]
			end
		--特殊
		elseif JY.Base["特殊"] == 1 then
			if JY.Person[0]["性别"] == 0 then
				headid = 290
			else
				headid = 368
			end
		else
			headid = JY.Person[pid]["头像代号"]
		end
	end
	name=name or JY.Person[pid]["姓名"]
    local talkBorder=(pich-talkynum*CC.DefaultFont)/(talkynum+1);
	
	local n_box_len = #name*16

	--显示头像和对话的坐标
    local xy={ [0]={headx=dx,heady=dy,
	                talkx=dx+boxpicw+2,talky=dy+27,
					namex=dx+boxpicw+2,namey=dy,
					showhead=1},--左上
                   {headx=CC.ScreenW-1-dx-boxpicw,heady=CC.ScreenH-dy-boxpich,
				    talkx=CC.ScreenW-1-dx-boxpicw-boxtalkw-2,talky= CC.ScreenH-dy-boxpich+27,
					namex=CC.ScreenW-2-dx-boxpicw-n_box_len,namey=CC.ScreenH-dy-boxpich,
					showhead=1},--右下
                   {headx=dx,heady=dy,
				   talkx=dx+boxpicw-43,talky=dy+27,
					namex=dx+boxpicw+2,namey=dy,
				   showhead=0},--上中
                   {headx=CC.ScreenW-1-dx-boxpicw,heady=CC.ScreenH-dy-boxpich,
				   talkx=CC.ScreenW-1-dx-boxpicw-boxtalkw-2,talky= CC.ScreenH-dy-boxpich+27,
					namex=CC.ScreenW-1-dx-boxpicw-n_box_len,namey=CC.ScreenH-dy-boxpich,
					showhead=1},
                   {headx=CC.ScreenW-1-dx-boxpicw,heady=dy,
				    talkx=CC.ScreenW-1-dx-boxpicw-boxtalkw-2,talky=dy+27,
					namex=CC.ScreenW-2-dx-boxpicw-n_box_len,namey=dy,
					showhead=1},--右上
                   {headx=dx,heady=CC.ScreenH-dy-boxpich,
				   talkx=dx+boxpicw+2,talky=CC.ScreenH-dy-boxpich+27,
					namex=dx+boxpicw+2,namey=CC.ScreenH-dy-boxpich,
				   showhead=1}, --左下
			}

    if flag<0 or flag>5 then
        flag=0;
    end
	
	

  if xy[flag].showhead == 0 then
    headid = -1
  end

    lib.GetKey();

	local function readstr(str)
		local T1={"０","１","２","３","４","５","６","７","８","９"}
		local T2={{"Ｒ",C_RED},{"Ｇ",C_GOLD},{"Ｂ",C_BLACK},{"Ｗ",C_WHITE},{"Ｏ",C_ORANGE},{"Ｌ",LimeGreen},{"Ｄ",M_DeepSkyBlue},{"Ｚ",LightPurple}}
		local T3={{"Ｈ",CC.FontNameSong},{"Ｓ",CC.FontNameHei},{"Ｆ",CC.FontName}}
		--美观起见，针对不同字体同一行显示，需要微调ｙ坐标，以及字号
		--以默认的字体为标准，启体需下移，细黑需上移
		for i=0,9 do
			if T1[i+1]==str then return 1,i*50 end
		end
		for i=1,8 do
			if T2[i][1]==str then return 2,T2[i][2] end
		end
		for i=1,3 do
			if T3[i][1]==str then return 3,T3[i][2] end
		end
		return 0
	end

	local function mydelay(t)
		if t<=0 then return end
		lib.ShowSurface(0)
		lib.Delay(t)
	end

	local page, cy, cx = 0, 0, 0
  local color, t, font = C_WHITE, 0, CC.FontName
  while string.len(s) >= 1 do
	lib.GetKey();
	if JY.Restart == 1 then
		break
	end
    if page == 0 then
      Cls()
      if headid >= 0 then
        DrawBox(xy[flag].headx, xy[flag].heady, xy[flag].headx + boxpicw, xy[flag].heady + boxpich, C_WHITE)
        DrawBox(xy[flag].namex, xy[flag].namey, xy[flag].namex + n_box_len, xy[flag].namey + 24, C_WHITE)
        MyDrawString(xy[flag].namex, xy[flag].namex + n_box_len, xy[flag].namey + 1, name, C_ORANGE, 21)
        --local w, h = lib.PicGetXY(1, headid * 2)
		local w, h = lib.GetPNGXY(1, headid*2)
        local x = (picw - w) / 2
        local y = (pich - h) / 2
        --lib.PicLoadCache(1, headid * 2, xy[flag].headx + 5 + x, xy[flag].heady + 5 + y, 1)
		
		lib.LoadPNG(1, headid*2, xy[flag].headx + 5 + x, xy[flag].heady + 5 + y, 1)
      end
      DrawBox(xy[flag].talkx, xy[flag].talky, xy[flag].talkx + boxtalkw, xy[flag].talky + boxtalkh, C_WHITE)
      page = 1
    end
		local str
		str=string.sub(s,1,1)
		if str=='*' then
			--str='Ｈ'
			s=string.sub(s,2,-1)
		else
			if string.byte(s,1,1) > 127 then		--判断单双字符
				str=string.sub(s,1,2)
				s=string.sub(s,3,-1)
			else
				str=string.sub(s,1,1)
				s=string.sub(s,2,-1)
			end
		end
		--开始控制逻辑
		if str=='*' then
		elseif str=="Ｈ" then
			cx=0
			cy=cy+1
			if cy==3 then
				cy=0
				page=0
			end
		elseif str=="Ｐ" then
			cx=0
			cy=0
			page=0
		elseif str=="ｐ" then
			ShowScreen();
			--WaitKey();
			lib.Delay(50)
		elseif str=="ｗ" then
			ShowScreen();
			WaitKey();
			--lib.Delay(50)
		elseif str=="Ｎ" then
			s=JY.Person[pid]["姓名"]..s
		elseif str=="ｎ" then
			s=JY.Person[0]["姓名"]..s
		else
			local kz1,kz2=readstr(str)
			if kz1==1 then
				t=kz2
			elseif kz1==2 then
				color=kz2
			elseif kz1==3 then
				font=kz2
			else
				lib.DrawStr(xy[flag].talkx+CC.DefaultFont*cx+5,
							xy[flag].talky+(CC.DefaultFont+talkBorder)*cy+talkBorder-8,
							str,color,CC.DefaultFont,font,0,0, 255)
				mydelay(t)
				cx=cx+string.len(str)/2
				if cx==talkxnum then
					cx=0
					cy=cy+1
					if cy==talkynum then
						cy=0
						page=0
					end
				end
			end
		end
		--如果换页，则显示，等待按键
		if page==0 or string.len(s)<1 then
			ShowScreen();
			WaitKey();
			lib.Delay(100)
		end

	end


	if JY.Restart == 1 then
		do return end
	end

	Cls();
end

---
function MyDrawString(x1, x2, y, str, color, size)
	local len = math.modf(string.len(str) * size / 4)
	local x = math.modf((x1 + x2) / 2) - len
	DrawString(x, y, str, color, size)
end

--分割字符串
--szFullString字符串
--szSeparator分割符
--返回总数,分割后数组
function Split(szFullString, szSeparator)
  local nFindStartIndex = 1
  local nSplitIndex = 1
  local nSplitArray = {}
  while true do
    local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
    if not nFindLastIndex then
      nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
      break;
    else
	    nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
	    nFindStartIndex = nFindLastIndex + string.len(szSeparator)
	    nSplitIndex = nSplitIndex + 1
	  end
  end
  return nSplitIndex, nSplitArray
end

function DrawStrBox2(x, y, str, color, size, bjcolor)
  local strarray = {}
  local num, maxlen = nil, nil
  maxlen = 0
  num, strarray = Split(str, "*")
  for i = 1, num do
    local len = string.len(strarray[i])
    if maxlen < len then
      maxlen = len
    end
  end
  local w = size * maxlen / 2 + 2 * CC.MenuBorderPixel
  local h = 2 * CC.MenuBorderPixel + size * num
  if x == -1 then
    x = (CC.ScreenW - size / 2 * maxlen - 2 * CC.MenuBorderPixel) / 2
  end
  if y == -1 then
    y = (CC.ScreenH - size * num - 2 * CC.MenuBorderPixel) / 2
  end
  DrawBox2(x, y, x + w - 1, y + h - 1, C_WHITE, bjcolor)
  for i = 1, num do
    DrawString(x + CC.MenuBorderPixel, y + CC.MenuBorderPixel + size * (i - 1), strarray[i], color, size)
  end
end

--绘制一个带背景的白色方框，四角凹进
function DrawBox2(x1, y1, x2, y2, color, bjcolor)
  local s = 4
  if not bjcolor then
    bjcolor = 0
  end
  if bjcolor >= 0 then
    lib.Background(x1, y1 + s, x1 + s, y2 - s, 128, bjcolor)
    lib.Background(x1 + s, y1, x2 - s, y2, 128, bjcolor)
    lib.Background(x2 - s, y1 + s, x2, y2 - s, 128, bjcolor)
  end
  if color >= 0 then
    local r, g, b = GetRGB(color)
    DrawBox_2(x1 + 1, y1, x2, y2, RGB(math.modf(r / 2), math.modf(g / 2), math.modf(b / 2)))
    DrawBox_2(x1, y1, x2 - 1, y2 - 1, color)
  end
end

--绘制四角凹进的方框
function DrawBox_2(x1, y1, x2, y2, color)
  local s = 4
  lib.DrawRect(x1 + s, y1, x2 - s, y1, color)
  lib.DrawRect(x2 - s, y1, x2 - s, y1 + s, color)
  lib.DrawRect(x2 - s, y1 + s, x2, y1 + s, color)
  lib.DrawRect(x2, y1 + s, x2, y2 - s, color)
  lib.DrawRect(x2, y2 - s, x2 - s, y2 - s, color)
  lib.DrawRect(x2 - s, y2 - s, x2 - s, y2, color)
  lib.DrawRect(x2 - s, y2, x1 + s, y2, color)
  lib.DrawRect(x1 + s, y2, x1 + s, y2 - s, color)
  lib.DrawRect(x1 + s, y2 - s, x1, y2 - s, color)
  lib.DrawRect(x1, y2 - s, x1, y1 + s, color)
  lib.DrawRect(x1, y1 + s, x1 + s, y1 + s, color)
  lib.DrawRect(x1 + s, y1 + s, x1 + s, y1, color)
end

--初始化主地图
function Init_MMap()
	lib.PicInit()
	lib.LoadMMap(CC.MMapFile[1], CC.MMapFile[2], CC.MMapFile[3], CC.MMapFile[4], CC.MMapFile[5], CC.MWidth, CC.MHeight, JY.Base["人X"], JY.Base["人Y"])
  
	lib.PicLoadFile(CC.MMAPPicFile[1], CC.MMAPPicFile[2], 0)
  
	lib.LoadPNGPath(CC.HeadPath, 1, CC.HeadNum, limitX(CC.ScreenW/936*100,0,100))
	
	lib.LoadPNGPath(CC.PTPath, 95, CC.PTNum, limitX(CC.ScreenW/936*100,0,100))
	
	lib.LoadPNGPath(CC.UIPath, 96, CC.UINum, limitX(CC.ScreenW/936*100,0,100))
  
	lib.PicLoadFile(CC.ThingPicFile[1], CC.ThingPicFile[2], 2, 100, 100)

	JY.EnterSceneXY = nil
	JY.oldMMapX = -1
	JY.oldMMapY = -1
	PlayMIDI(JY.MmapMusic)
  
	AutoMoveTab = {[0] = 0}
end

--自定义的进入子场景的函数
--需要进入的子场景编号
--x进入子场景后人物的X坐标，传入-1则默认为入口X
--y进入子场景后人物的Y坐标，传入-1则默认为入口Y
--direct人物面对的方向
function My_Enter_SubScene(sceneid,x,y,direct)
	--从大地图进入子场景前自动保存到10号档
	if JY.Status == GAME_MMAP then
		SaveRecord(10)
	end
	JY.SubScene = sceneid;
	local flag = 1;   --是否自定义的xy坐标, 0是，1否
	if x == -1 and y == -1 then
		JY.Base["人X1"]=JY.Scene[sceneid]["入口X"];
		JY.Base["人Y1"]=JY.Scene[sceneid]["入口Y"];
	else
		JY.Base["人X1"] = x;
		JY.Base["人Y1"] = y;
		flag = 0;
	end
	
	if direct > -1 then
		JY.Base["人方向"] = direct;
	end
 			
	
	if JY.Status == GAME_MMAP then
		CleanMemory();
		lib.UnloadMMap();
	end
	lib.ShowSlow(20,1)

	JY.Status=GAME_SMAP;  --改变状态
	JY.MmapMusic=-1;

	JY.Base["乘船"]=0;
	JY.MyPic=GetMyPic(); 
  
	--外景入口是个难点，有些子场景是通过跳转的方式进入的，需要判断
	--由于目前最多只能有一个子场景跳转，所以不需要进行循环判断
	local sid = JY.Scene[sceneid]["跳转场景"];
  
	if sid < 0 or (JY.Scene[sid]["外景入口X1"] <= 0 and JY.Scene[sid]["外景入口Y1"] <= 0) then
		JY.Base["人X"] = JY.Scene[sceneid]["外景入口X1"];  --改变出子场景后的XY坐标
		JY.Base["人Y"] = JY.Scene[sceneid]["外景入口Y1"];
	else
		JY.Base["人X"] = JY.Scene[sid]["外景入口X1"];  --改变出子场景后的XY坐标
		JY.Base["人Y"] = JY.Scene[sid]["外景入口Y1"];
	end


	Init_SMap(flag);  --重新初始化地图
  
	if flag == 0 then    --如果是自定义位置，先传送到那个位置，再显示场景名称
		DrawStrBox(-1,10,JY.Scene[JY.SubScene]["名称"],C_WHITE,CC.DefaultFont);
		ShowScreen();
		WaitKey();
	end
  
	Cls();	
end

--简易信息
function JYZTB()
	local tnd = math.fmod(JY.Base["难度"],#MODEXZ2);
	if tnd == 0 then
		tnd = #MODEXZ2
	end
	local zjlx;
	if JY.Base["标准"] > 0 then
		zjlx = "标准"
	elseif JY.Base["畅想"] > 0 then
		zjlx = "畅想"
	else
		zjlx = "特殊"
	end
	local yxms
	if JY.Base["单通"] == 0 then
		yxms = "普通"
	else
		yxms = "单通"
	end
	local t = math.modf((lib.GetTime() - JY.LOADTIME) / 60000 + GetS(14, 2, 1, 4))
	local t1, t2 = 0, 0
	while t >= 60 do
		t = t - 60
		t1 = t1 + 1
	end
	t2 = t
	local i = 0
	DrawBox(10, 10, 10 + 10*CC.FontSmall2, 15 + 5*(CC.FontSmall2 + CC.RowPixel), M_SandyBrown)
	DrawString(15, 15, "正邪", M_SandyBrown, CC.FontSmall2)
	DrawString(15+CC.FontSmall2*2+4, 14, JY.Person[0]["品德"], M_Silver, CC.FontSmall2)
	DrawString(15+CC.FontSmall2*4+4, 15, "银", M_SandyBrown, CC.FontSmall2)
	DrawString(15+CC.FontSmall2*5+4, 16, "两", M_SandyBrown, CC.FontSmall2)
	DrawString(15+CC.FontSmall2*6+8, 15, JY.GOLD, Dark_Gold, CC.FontSmall2)
	i = i + 1
	DrawString(15, 15+i*(CC.FontSmall2+CC.RowPixel), string.format("江湖时间 %2d时%2d分", t1, t2), M_SandyBrown, CC.FontSmall2)
	i = i + 1
	DrawString(15, 15+i*(CC.FontSmall2+CC.RowPixel), "难度", M_SandyBrown, CC.FontSmall2)
	DrawString(15+CC.FontSmall2*2+4, 15+i*(CC.FontSmall2+CC.RowPixel), MODEXZ2[tnd], Violet, CC.FontSmall2)
	DrawString(15+CC.FontSmall2*5-2, 15+i*(CC.FontSmall2+CC.RowPixel)+1, "周目", M_SandyBrown, CC.FontSmall2)
	DrawString(15+CC.FontSmall2*7+2, 15+i*(CC.FontSmall2+CC.RowPixel), JY.Base["周目"], Violet, CC.FontSmall2)
	i = i + 1
	DrawString(15, 15+i*(CC.FontSmall2+CC.RowPixel), "天书数量", M_SandyBrown, CC.FontSmall2)
	DrawString(15+CC.FontSmall2*4+4, 15+i*(CC.FontSmall2+CC.RowPixel), JY.Base["天书数量"], PinkRed, CC.FontSmall2)
	i = i + 1
	DrawString(15, 15+i*(CC.FontSmall2+CC.RowPixel), "主角", M_SandyBrown, CC.FontSmall2)
	DrawString(15+CC.FontSmall2*2+4, 15+i*(CC.FontSmall2+CC.RowPixel), zjlx, Violet, CC.FontSmall2)
	DrawString(15+CC.FontSmall2*5-2, 15+i*(CC.FontSmall2+CC.RowPixel), "模式", M_SandyBrown, CC.FontSmall2)
	DrawString(15+CC.FontSmall2*7+2, 15+i*(CC.FontSmall2+CC.RowPixel), yxms, Violet, CC.FontSmall2)
	if JY.Person[642]["血量翻倍"] == 1 then
	i = i + 1
	DrawString(15+CC.FontSmall2*2+4, 15+i*(CC.FontSmall2+CC.RowPixel), "至尊江湖V6会员", C_GOLD, CC.FontBig)		
	end
end

function QZXS(s)
	DrawStrBoxWaitKey(s, C_GOLD, CC.DefaultFont)
end

--显示武功的文字
function KungfuString(str, x, y, color, size, font, place)
  if str == nil then
    return 
  end
  local w, h = size, size + 5
  local len = string.len(str) / 2
  x = x - len * w / 2
  y = y - h * place
  lib.DrawStr(x, y, str, color, size, font, 0, 0)
end

--清除贴图文字
function ClsN(x1, y1, x2, y2)
  if x1 == nil then
    x1 = 0
    y1 = 0
    x2 = 0
    y2 = 0
  end
  lib.SetClip(x1, y1, x2, y2)
  lib.FillColor(0, 0, 0, 0, 0)
  lib.SetClip(0, 0, 0, 0)
end


---对矩形进行屏幕剪裁
--返回剪裁后的矩形，如果超出屏幕，返回空
function ClipRect(r)
  if CC.ScreenW <= r.x1 or r.x2 <= 0 or CC.ScreenH <= r.y1 or r.y2 <= 0 then
    return nil
  else
    local res = {}
    res.x1 = limitX(r.x1, 0, CC.ScreenW)
    res.x2 = limitX(r.x2, 0, CC.ScreenW)
    res.y1 = limitX(r.y1, 0, CC.ScreenH)
    res.y2 = limitX(r.y2, 0, CC.ScreenH)
    return res
  end
end

--计算贴图改变形成的Clip裁剪
--(dx1,dy1) 新贴图和绘图中心点的坐标偏移。在场景中，视角不同而主角动时用到
--pic1 旧的贴图编号
--id1 贴图文件加载编号
--(dx2,dy2) 新贴图和绘图中心点的偏移
--pic2 旧的贴图编号
--id2 贴图文件加载编号
--返回，裁剪矩形 {x1,y1,x2,y2}
function Cal_PicClip(dx1, dy1, pic1, id1, dx2, dy2, pic2, id2)
  local w1, h1, x1_off, y1_off = lib.PicGetXY(id1, pic1 * 2)
  local old_r = {}
  old_r.x1 = CC.XScale * (dx1 - dy1) + CC.ScreenW / 2 - x1_off
  old_r.y1 = CC.YScale * (dx1 + dy1) + CC.ScreenH / 2 - y1_off
  old_r.x2 = old_r.x1 + w1
  old_r.y2 = old_r.y1 + h1
  local w2, h2, x2_off, y2_off = lib.PicGetXY(id2, pic2 * 2)
  local new_r = {}
  new_r.x1 = CC.XScale * (dx2 - dy2) + CC.ScreenW / 2 - x2_off
  new_r.y1 = CC.YScale * (dx2 + dy2) + CC.ScreenH / 2 - y2_off
  new_r.x2 = new_r.x1 + w2
  new_r.y2 = new_r.y1 + h2
  return MergeRect(old_r, new_r)
end

--合并矩形
function MergeRect(r1, r2)
  local res = {}
  res.x1 = math.min(r1.x1, r2.x1)
  res.y1 = math.min(r1.y1, r2.y1)
  res.x2 = math.max(r1.x2, r2.x2)
  res.y2 = math.max(r1.y2, r2.y2)
  return res
end

--自定义事件
function NEvent(keypress)
	NEvent2(keypress)		--十四本天书之后得到5000两，洗四神技
	NEvent3(keypress)		--胡斐 苗人凤教苗家剑法
	NEvent4(keypress)		--令狐冲变身
	NEvent6(keypress)		--蜘蛛洞 金龙帮
	NEvent10(keypress)	--武道大会放书
	NEvent12(keypress)	--归还金蛇剑
end

--显示阴影字符串
--如果x,y传-1，那么显示在屏幕中间
function NewDrawString(x, y, str, color, size)
	local ll = #str
	local w = size * ll / 2 + 2 * CC.MenuBorderPixel
	local h = size + 2 * CC.MenuBorderPixel
	if x == -1 then
		x = (CC.ScreenW - size / 2 * ll - 2 * CC.MenuBorderPixel) / 2
	else
		x = (x - size / 2 * ll - 2 * CC.MenuBorderPixel) / 2
	end
	if y == -1 then
		y = (CC.ScreenH - size - 2 * CC.MenuBorderPixel) / 2
	else
		y = (y - size - 2 * CC.MenuBorderPixel) / 2
	end
	lib.DrawStr(x, y, str, color, size, CC.FontName, CC.SrcCharSet, CC.OSCharSet)
end

--无酒不欢：仿造提款机ATM画的数字输入UI
function InputNum(str, minNum, maxNum, isEsc)
	local size = CC.DefaultFont;
	local b_space = size+CC.RowPixel
	local x=(CC.ScreenW-size*9-2*CC.MenuBorderPixel)/2;
	local y=(CC.ScreenH-size*9-2*CC.MenuBorderPixel)/2;
	local w=size*9+2*CC.MenuBorderPixel;
	local h=(b_space+CC.RowPixel*2)*6;
	local functional_button = {{name="确认"},{name="最大"},{name="清空"},{name="删除"},{name=0},{name=1},{name=2},{name=3},{name=4},{name=5},{name=6},{name=7},{name=8},{name=9}};
	local starting_y = 5;
	local starting_x = 1;

	for i = 1, #functional_button do
		functional_button[i].x1 = CC.ScreenW/2+(b_space+CC.RowPixel*2)*starting_x-11
		functional_button[i].y1 = y+(b_space+CC.RowPixel*2)*starting_y
		if i <= 4 then
			functional_button[i].x2 = CC.ScreenW/2+(b_space+CC.RowPixel*2)*starting_x-11+b_space*2
			functional_button[i].y2 = y+(b_space+CC.RowPixel*2)*starting_y+b_space
		else
			functional_button[i].x2 = CC.ScreenW/2+(b_space+CC.RowPixel*2)*starting_x-11+b_space
			functional_button[i].y2 = y+(b_space+CC.RowPixel*2)*starting_y+b_space
		end
		if i < 4 then
			starting_y = starting_y - 1
		elseif i == 4 then
			starting_y = 5
			starting_x = -1
		elseif i == 5 or i == 8 or i == 11 then
			starting_x = -2
			starting_y = starting_y - 1
		elseif i > 5 then
			starting_x = starting_x + 1
		end
	end

	local num = 0;
	if minNum ~= nil then
		num = minNum;
	end
	
	local selected_content = 0
	
	DrawBox(x,y,x+w-1,y+h-1,C_WHITE);
	DrawString(x+CC.MenuBorderPixel*2,y+CC.MenuBorderPixel,str.." "..minNum.." - "..maxNum,C_WHITE,size);
  
	local sid = lib.SaveSur(0, 0, CC.ScreenW, CC.ScreenH);
  
	while true do
		if JY.Restart == 1 then
			break
		end
		DrawShades(CC.ScreenW/2-b_space*3,y+b_space+CC.RowPixel*2,CC.ScreenW/2+b_space*3,y+b_space+CC.RowPixel*2+b_space)
		DrawString(CC.ScreenW/2,y+b_space+CC.RowPixel*2,string.format("%d",num),C_WHITE,size);
		
		for i = 1, #functional_button do
			local x_indent = 7
			local y_indent = 2
			if i > 4 then
				x_indent = 11
				y_indent = 0
			end
			local shade_color = nil;
			if i == selected_content then
				shade_color = C_GOLD
			end
			DrawShades(functional_button[i].x1,functional_button[i].y1,functional_button[i].x2,functional_button[i].y2,shade_color)
			DrawString(functional_button[i].x1+x_indent,functional_button[i].y1+y_indent,functional_button[i].name,C_GOLD,size);
		end
		
		ShowScreen()
		local key, ktype, mx, my = lib.GetKey();
		lib.Delay(CC.Frame)
		if (key == VK_ESCAPE or ktype == 4) and isEsc ~= nil then
			num = nil;
			break;
		elseif key >= 49 and key <= 57 then
			num = num * 10
			num = num + key - 48
			if num > maxNum then
				num = maxNum
			end
		elseif key >= 1073741913 and key <= 1073741921 then
			num = num * 10
			num = num + key - 1073741912
			if num > maxNum then
				num = maxNum
			end
		elseif key == 48 or key == 1073741922 then
			num = num * 10
			if num > maxNum then
				num = maxNum
			end
		elseif key == VK_BACKSPACE then
			num = math.modf(num/10)
		elseif key == VK_SPACE or key == VK_RETURN then
			if num >= minNum and num <= maxNum then
				break;
			end
		elseif ktype == 2 or ktype == 3 then
			selected_content = 0
			if mx >= x and mx <= x + w-1 and my >= y and my <= y + h-1 then
				for k = 1, #functional_button do 
					if mx >= functional_button[k].x1 and mx <= functional_button[k].x2 and my >= functional_button[k].y1 and my <= functional_button[k].y2 then
						selected_content = k;
						break;
					end
				end
			end
			if ktype == 3 then
				if selected_content == 1 then
					if num >= minNum and num <= maxNum then
						break;
					end
				elseif selected_content == 2 then
					num = maxNum
				elseif selected_content == 3 then
					num = 0
				elseif selected_content == 4 then
					num = math.modf(num/10)
				elseif selected_content > 4 then
					num = num * 10
					num = num + functional_button[selected_content].name
					if num > maxNum then
						num = maxNum
					end
				end
			end
		end
		ClsN();
		lib.LoadSur(sid,0,0)
	end
	lib.FreeSur(sid);
	return num;
end

--分析字符串中是否有颜色标志
--被DrawTxt函数调用
function AnalyString(str)
	local tlen = 0;
	local strcolor = {}
	--检查是否有颜色标志
	local f1, f2 = string.find(str, "<[A-R]>");
	if f1 ~= nil then
		while 1 do
			if f1 > 1 then
				local s1 = string.sub(str, 1, f1-1)
				table.insert(strcolor, {s1, nil});
				tlen = tlen + #s1;
			end
			local match = string.match(str, "<([A-R])>");
			local f3, f4 = string.find(str, "</"..match..">"); 
			if f3 ~= nil then
				local s2 = string.sub(str, f2+1, f3-1);
				table.insert(strcolor, {s2, CC.Color[match]});
				tlen = tlen + #s2;
				if f4+1 >= #str then
					break;
				end
				str = string.sub(str, f4+1, #str);
				f1, f2 = string.find(str, "<[A-R]>");
				--如果已经没有其它颜色标志，直接输入退出循环
				if f1 == nil then
					table.insert(strcolor, {str, nil});
					break;
				end
			else		--如果找不到结束标志，直接输入退出循环
				str = string.sub(str, f2+1, #str);
				table.insert(strcolor, {str, CC.Color[match]});
				break;
			end
		end
	else
		table.insert(strcolor, {str, nil});
	end
	return strcolor;
end

--存档列表
function SaveList()
	--读取R*.idx文件
	local idxData = Byte.create(24)
	Byte.loadfile(idxData, CC.R_IDXFilename[0], 0, 24)
	local idx = {}
	idx[0] = 0
	for i = 1, 6 do
		idx[i] = Byte.get32(idxData, 4 * (i - 1))
	end

	local table_struct = {}
	table_struct["姓名"]={idx[1]+8,2,10}
	table_struct["资质"]={idx[1]+122,0,2}
  
	table_struct["无用"]={idx[0]+2,0,2}
	table_struct["难度"]={idx[0]+24,0,2}
	
	table_struct["标准"]={idx[0]+26,0,2}
	table_struct["畅想"]={idx[0]+28,0,2}
	table_struct["特殊"]={idx[0]+30,0,2}
	
	table_struct["天书数量"]={idx[0]+36,0,2}
	
	table_struct["场景名称"]={idx[3]+2,2,10}
  
	--主角编号
	table_struct["队伍1"]={idx[0]+38,0,2}
  
	--table_struct[WZ7]={idx[2]+88,0,2}
  
	--时间保存在场景数据里
	--table_struct["游戏时间"]={(CC.SWidth*CC.SHeight*(14*6+4) + CC.SWidth + 2)*2, 0, 2}
	--S_XMax*S_YMax*(id*6+level)+y*S_XMax+x
	--14, 2, 1, 4
	--sFile,CC.TempS_Filename,JY.SceneNum,CC.SWidth,CC.SHeight

	--读取R*.grp文件

	local len = filelength(CC.R_GRPFilename[0]);
	local data = Byte.create(len);
	
	--读取SMAP.grp
	local slen  = filelength(CC.S_Filename[0]);
	local sdata = Byte.create(slen);
	
	local menu = {};

	for i=1, CC.SaveNum do
	
		local name = "";
		--local lv = "";
		local sname = "";
		local nd = "";
		local time = "";
		--天书数量
		local tssl = "";
		--主角类型
		local zjlx = "";	
		--资质
		local zz = "";
		
		if existFile(string.format('data/save/Save_%d',i)) then
			Byte.loadfilefromzip(data, string.format('data/save/Save_%d',i),'r.grp', 0, len);
			
			local pid = GetDataFromStruct(data,0,table_struct,"队伍1");
			
			name = GetDataFromStruct(data,pid*CC.PersonSize,table_struct,"姓名");
			zz = GetDataFromStruct(data,pid*CC.PersonSize,table_struct,"资质");
			
			local wy = GetDataFromStruct(data,0,table_struct,"无用");
			if wy == -1 then
				sname = "大地图";
			else
				sname = GetDataFromStruct(data,wy*CC.SceneSize,table_struct,"场景名称").."";
			end
			
			local lxid1 = GetDataFromStruct(data,0,table_struct,"标准");
			local lxid2 = GetDataFromStruct(data,0,table_struct,"畅想");
			local lxid3 = GetDataFromStruct(data,0,table_struct,"特殊");
			
			if lxid1 > 0 then
				zjlx = "标准"
			elseif lxid2 > 0 then
				zjlx = "畅想"
			elseif lxid3 > 0 then
				zjlx = "特殊"
			end
			
			local wz = GetDataFromStruct(data,0,table_struct,"难度");
			tssl = GetDataFromStruct(data,0,table_struct,"天书数量").."本";

			nd = MODEXZ2[wz]
			
			--游戏时间
			--[[
			Byte.loadfile(sdata, string.format(CC.S_GRP,i), 0, slen);
			
			local t = GetDataFromStruct(sdata, 0, table_struct, "游戏时间")
			local t1, t2 = 0, 0
			while t >= 60 do
				t = t - 60
				t1 = t1 + 1
			end
			t2 = t
		  
			time = string.format("%2d时%2d秒", t1, t2)]]
		end
		
		if i < 10 then
			menu[i] = {string.format("存档%02d %-4s %-10s %-4s %4s %4s %-10s", i, zjlx, name, nd, zz, tssl, sname), nil, 1};
		else
			menu[i] = {string.format("自动档 %-4s %-10s %-4s %4s %4s %-10s", zjlx, name, nd, zz, tssl, sname), nil, 1};
		end
	end

	local menux=(CC.ScreenW-24*CC.DefaultFont-2*CC.MenuBorderPixel)/2
	local menuy=(CC.ScreenH - 9*(CC.DefaultFont+CC.RowPixel))/2

	local r=ShowMenu(menu,CC.SaveNum,10,menux,menuy,0,0,1,1,CC.DefaultFont,C_WHITE,C_GOLD)
	
	CleanMemory()
	return r;
end

--动态提示显示
function DrawTimer()
	if CC.OpenTimmerRemind ~= 1 then
		return;
	end
	local t2 = lib.GetTime();
	if CC.Timer.status==0 then
		if t2-CC.Timer.stime > 30000 or CC.Timer.stime == 0 then
			CC.Timer.stime=t2;
			CC.Timer.status=1;
			CC.Timer.str=CC.RUNSTR[math.random(#CC.RUNSTR)];
			CC.Timer.len=string.len(CC.Timer.str)/2+3;
		end
	else
		CC.Timer.fun(t2);
	end
end

function demostr(t)
	local tt=t-CC.Timer.stime;
	tt=math.modf(tt/25)%(CC.ScreenW+CC.Timer.len*CC.Fontsmall);
	if runword(CC.Timer.str,M_Orange,CC.Fontsmall,1,tt)==1 then
		CC.Timer.status=0;
		CC.Timer.stime=t;
	end
end

function runword(str,color,size,place,offset)
	offset=CC.ScreenW-offset;
	local y1,y2
	if place==0 then
		y1=0;
		y2=size;
	elseif place==1 then
		y1=CC.ScreenH-size;
		y2=CC.ScreenH;
	end
	lib.Background(0,y1,CC.ScreenW,y2,128);
	if -offset>(CC.Timer.len-1)*size then
		return 1;
	end
	DrawString(offset,y1,str,color,size);
	return 0;
end

function dark()
	instruct_14()
end

function light()
	instruct_13()
end

--无酒不欢：添加事件函数
function addevent(sid, pid, pass, event, etype, pic, x, y)
	if JY.Restart == 1 then
		return
	end
	if x == nil then x = -2 end
	if y == nil then y = -2 end
	if pic == nil then pic = -2 end
	if etype == nil then etype = 1 end
	if event == nil then event = -2 end
	if pass == nil then pass = -2 end
	if etype == 1 then
		instruct_3(sid, pid, pass, 0, event, 0, 0, pic, pic, pic, -2, x, y)
	elseif etype == 2 then
		instruct_3(sid, pid, pass, 0, 0, event, 0, pic, pic, pic, -2, x, y)
	else
		instruct_3(sid, pid, pass, 0, 0, 0, event, pic, pic, pic, -2, x, y)
	end	
end

--无酒不欢：删除事件函数
function null(sid, pid)
	addevent(sid, pid, 0, 0, 0, 0)
end

--无酒不欢：畅想的选择菜单
function ShowMenu3(menu,itemNum,numShow,showRow,x1,y1,size,color,selectColor)
    local w=0;
    local h=0;   --边框的宽高
    local i,j=0,0;
    local col=0;     --实际的显示菜单项
    local row=0;
    
    lib.GetKey();
    Cls();
    
    --建一个新的table
    local menuItem = {};
    local numItem = 0;                --显示的总数
    
    --把可选为畅想的人物保存到新的table
    for i,v in pairs(menu) do
        if v[3] ~= 0 then
            numItem = numItem + 1;
			menuItem[numItem] = {v[1],v[2],v[3],i};                --注意第4个位置，保存i的值
        end
    end
    
    --计算实际显示的菜单项数
    if numShow==0 or numShow > numItem then
        col=numItem;
        row = 1;
    else
		--列数
        col=numShow;
		--(项目总数-1)/列数=行数
        row = math.modf((numItem-1)/col);
    end
    
    if showRow > row + 1 then
        showRow = row + 1;
    end

    --计算边框实际宽高
    local maxlength=0;

	for i=1,numItem do
		if string.len(menuItem[i][1])>maxlength then
			maxlength=string.len(menuItem[i][1]);
		end
	end
	w=(size*maxlength/2+CC.RowPixel*2)*col+2*CC.MenuBorderPixel;
	h=showRow*(size+CC.RowPixel*2) + 2*CC.MenuBorderPixel;

    local start=0;             --显示的第一项

    local curx = 1;          --当前选择项
    local cury = 0;
    local current = curx + cury*numShow;

    local returnValue =0;

    local surid = lib.SaveSur(0, 0, CC.ScreenW, CC.ScreenH)

    while true do
		if JY.Restart == 1 then
			break
		end
        if col ~= 0 then
            lib.LoadSur(surid, 0, 0)
        end
		--说明行在此
		DrawString(x1+(size+CC.RowPixel)*9-3,y1-(size+CC.RowPixel)*2-CC.RowPixel,"PgUp/PgDn/鼠标滚轮翻页",LimeGreen,size);
		DrawString(x1+(size+CC.RowPixel)*8,y1-(size+CC.RowPixel)*1,"名称黄色为一阶 名称蓝色为高阶",LimeGreen,size);
		for i=start,showRow+start-1 do
			for j=1, col do
				local n = i*col+j;
				if n > numItem then
					break;
				end
                
				--设置不同的绘制颜色
                local drawColor=color; 
                if menuItem[n][3] == 2 then
					drawColor = M_DeepSkyBlue
				end
				if menuItem[n][3] == 4 then
					drawColor = PinkRed
				end
				--[[if menuItem[n][1] == "雷震" or menuItem[n][1] == "无名" or menuItem[n][1] == "豪鬼" or menuItem[n][1] == "独孤求败" or menuItem[n][1] == "华英雄"
				or menuItem[n][1] == "武僧" or menuItem[n][1] == "小虾米" or menuItem[n][1] == "聂风" 
				or menuItem[n][1] == "步惊云" or menuItem[n][1] == "左慈" or menuItem[n][1] == "托奇" or menuItem[n][1] == "逍遥子" then
				    drawColor = C_RED
				end]]
				if menuItem[n][1] == "四大山" then
					drawColor = LimeGreen
                end
                local xx = x1+(j-1)*(size*maxlength/2+CC.RowPixel*2) + CC.MenuBorderPixel
                local yy = y1+(i-start)*(size+CC.RowPixel*2) + CC.MenuBorderPixel
                if n==current then
                    drawColor=selectColor;
                    lib.Background(xx-5, yy-5, xx + size*maxlength/2, yy + size+5, 128, color)
                end
                DrawString(xx,yy,menuItem[n][1],drawColor,size);

            end
        end
		ShowScreen();
		local keyPress, ktype, mx, my = WaitKey(1)
		local mk = false;
		lib.Delay(CC.Frame);

		if keyPress==VK_DOWN then                --Down
			cury = cury + 1;
					if cury == showRow then
						cury = 0
					elseif curx + cury*col > numItem then
						cury = 15
					end
		elseif keyPress==VK_UP then                  --Up
					if cury ~= 15 then
						cury = cury -1;
						if cury < 0 then
							cury = showRow-1;
						end
					else
						if curx + row*col > numItem then
							cury = row - 1
						else
							cury = row
						end
					end
		elseif keyPress==VK_RIGHT then                --RIGHT
                    curx = curx +1;
                    if curx > col then
                        curx = 1;
                    elseif curx + cury*col > numItem then
                        curx = 1;
                    end
		elseif keyPress==VK_LEFT then                  --LEFT
                    curx = curx -1;
                    if curx < 1 then
                        curx = col;
                        if curx + cury*col > numItem then
							curx = numItem - cury*col;
                        end
                    end
		elseif keyPress==VK_PGUP or ktype == 6 then    --PgUp 或 鼠标滚轮上
					if start == 15 then
						start = start - 15;
						curx = 1
						cury = 0
						mk = true;
					end
		elseif keyPress==VK_PGDN or ktype == 7 then    --PgDn 或 鼠标滚轮下	
			if start == 0 then
				start = start + 15;
				curx = 1
				cury = 15
				mk = true;
			end
		else
			if ktype == 2 or ktype == 3 then			--选中
				--无酒不欢：加个逻辑判定防止跳出
				local re1, re2 = curx, cury;
				if mx >= x1 and mx <= x1 + w and my >= y1 and my <= y1 + h then
					curx = math.modf((mx-x1-CC.MenuBorderPixel)/(size*maxlength/2+CC.RowPixel*2)) + 1
					cury = start + math.modf((my - y1 - CC.MenuBorderPixel) / (size + CC.RowPixel*2))
					mk = true;
				end
				if (curx + cury*col) > #menuItem then
					curx = re1
					cury = re2
					mk = false;
				end
			end
			--空格，回车，
			if keyPress==VK_SPACE or keyPress==VK_RETURN or ktype == 5 or (ktype == 3 and mk) then
				current = curx + cury*col;
				if menuItem[current][3]==3 then
				
				elseif menuItem[current][2]==nil then
					local ys = showCXStatic(menuItem[current][4])
					if ys then
						returnValue=current
						break
					end
				else
					local r=menuItem[current][2](menuItem,current)
					if r==1 then
						returnValue= -current;
						break;
					else
						lib.LoadSur(surid, 0, 0)
					end
				end
            end
		end 
		current = curx + cury*col;
    end
	lib.FreeSur(surid)
        
	--返回值，这个是取第4个位置的值
	if returnValue > 0 then
		return menuItem[returnValue][4]
	else
		return returnValue
	end
end

function showCXStatic(id)
	if existFile(CC.Acvmts) then
		dofile(CC.Acvmts)
		local r = false
		local ndChn = {"入门","少侠","大侠","掌门","宗师","传说","至尊","星河"}
		local highLvl
		if Achievements.rdsCpltd[id].lvlReached2 > 0 then
			highLvl = Achievements.rdsCpltd[id].lvlReached1.."周"..ndChn[Achievements.rdsCpltd[id].lvlReached2]
		else
			highLvl = "暂无"
		end
		while true do
			if JY.Restart == 1 then
				return
			end
			Cls()
			
			lib.LoadPNG(1, 1000 * 2 , 0, 0, 1)
			
			DrawString(390,50,JY.Person[id]["姓名"],C_GOLD,CC.FontBig)
			
			DrawString(80,130,"通关次数："..Achievements.rdsCpltd[id].n.."次",C_WHITE,CC.DefaultFont)
			DrawString(80,200,"最高通关难度："..highLvl,C_WHITE,CC.DefaultFont)
			
			DrawString(CC.ScreenW/2 - 160,CC.ScreenH - 40,"回车键确认选择 ESC退出",LimeGreen,CC.DefaultFont*0.98)
			
			local keypress, ktype, mx, my = lib.GetKey()
			
			if keypress == VK_RETURN then
				r = true
				break
			elseif keypress == VK_ESCAPE or ktype == 4 then
				break
			end
			ShowScreen()
			lib.Delay(CC.Frame)
		end
		return r
	end
end

--无酒不欢：获取武功威力
function get_skill_power(personid, wugongid, wugonglvl)
local yin, yang, tg = NeiL(personid)
local fx = yin + yang
	local power;
	--到极的武功按10级威力算
	if wugonglvl == 11 then
		wugonglvl = 10
	end
	power = JY.Wugong[wugongid]["攻击力"..wugonglvl]
	
	if wugongid == 240 and JY.Person[personid]["洗髓"] == 100 then
	   power = 4000
	end
	
	if JY.Person[personid]["专1"] == 998 then
	   power = power * 1.1
	end
	--鹰蛇生死搏
	if PersonKF(personid, 4) and PersonKF(personid, 74) and JY.Person[personid]["左右互搏"] == 1 then
	   if wugongid == 74 then
	      power = power + 700
	   end
	   if wugongid == 4 then
	      power = power + 550
	   end
	end
	--阶威力kfid == 1 or kfid == 22 or kfid == 24 or kfid == 96 or kfid == 108 or kfid == 144
	if wugongid == 67 and match_ID(personid, 1) and JY.Person[1]["阶"] >= 1 then
       power = power + 1000
    end
	if (wugongid == 1 or wugongid == 22 or wugongid == 24 or wugongid == 96 or wugongid == 108 or wugongid == 144) and match_ID(personid, 114) and JY.Person[114]["阶"] >= 2 then
       power = power + 1000
    end
	if wugongid == 66 and match_ID(personid, 103) and JY.Person[103]["阶"] >= 1 then
       power = power + 300
    end
	if wugongid == 44 and match_ID(personid, 3) then
       power = power + 500*JY.Person[3]["阶"] 
    end
	if JY.Wugong[wugongid]["武功类型"] == 3 and JY.Base["标准"] == 3 and personid == 0 and JY.Person[0]["阶"] >= 1 then
       power = power + 500
    end
	if JY.Wugong[wugongid]["武功类型"] == 3 and match_ID(personid, 6) and JY.Person[6]["阶"] >= 1 then
       power = power + 800
    end
	if JY.Wugong[wugongid]["武功类型"] == 1 and match_ID(personid, 151) and JY.Person[151]["阶"] >= 1 then
       power = power + 500
    end
	if wugongid == 23 and match_ID(personid, 8) and JY.Person[8]["阶"] >= 1 then
       power = power + 1000
    end
	
	if wugongid == 37 and match_ID(personid, 37) and JY.Person[37]["阶"] >= 2 then
       power = power + 800
    end
	if (wugongid == 46 or wugongid == 16 or wugongid == 23) and match_ID(personid, 9) and JY.Person[9]["阶"] >= 1 then
       power = power + 500
    end
	if (wugongid == 46 or wugongid == 16) and match_ID(personid, 171) and JY.Person[171]["阶"] >= 1 then
       power = power + 1000
    end
	if wugongid == 81 and match_ID(personid, 15) and JY.Person[15]["阶"] >= 1 then
       power = power + 800
	   if JY.Person[15]["阶"] >= 3 then
	      power = power + 800
	   end
    end
	if wugongid == 19 and match_ID(personid, 18) and JY.Person[18]["阶"] >= 1 then
       power = power + 800
    end
	if wugongid == 33 and match_ID(personid, 22) and JY.Person[22]["阶"] >= 1 then
       power = power + 700
    end
	if wugongid == 8 and match_ID(personid, 116) and JY.Person[116]["阶"] >= 3 then
       power = power + 800
    end
	if wugongid == 31 and match_ID(personid, 23) and JY.Person[23]["阶"] >= 1 then
       power = power + 500
    end
	if wugongid == 41 and match_ID(personid, 631) and JY.Person[631]["阶"] >= 1 then
       power = power + 1000
    end
	if wugongid == 11 and match_ID(personid, 631) and JY.Person[631]["阶"] >= 2 then
       power = power + 2000
    end
	if wugongid == 47 and match_ID(personid, 35) and JY.Person[35]["阶"] >= 1 then
       power = power + 500
    end
	if wugongid == 35 and match_ID(personid, 43) and JY.Person[43]["阶"] >= 1 then
       power = power+1000
    end
	if wugongid == 26 and match_ID(personid, 55) and JY.Person[55]["阶"] >= 2 then
       power = power+1000
    end
	if wugongid == 39 and match_ID(personid, 129) and JY.Person[129]["阶"] >= 1 then
       power = power+1000
    end
	if wugongid == 17 and match_ID(personid, 129) and JY.Person[129]["阶"] >= 1 then
       power = power+600
    end
	if wugongid == 80 and match_ID(personid, 56) and JY.Person[56]["阶"] >= 1 then
       power = power+1000
    end
	if (wugongid == 12 or wugongid == 38 or wugongid == 18) and match_ID(personid, 57) and JY.Person[57]["阶"] >= 1 then
       power = power+1000
    end
	if (wugongid == 12 or wugongid == 38 or wugongid == 18) and match_ID(personid, 626) and JY.Person[626]["阶"] >= 1 then
       power = power+1000
    end
	if (wugongid == 18 or wugongid == 206) and match_ID(personid, 164) and JY.Person[164]["阶"] >= 1 then
       power = power+800
    end
	if wugongid == 45 and match_ID(personid, 58) and JY.Person[58]["阶"] >= 1 then
       power = power+600
    end
	if wugongid == 38 and match_ID(personid, 63) and JY.Person[63]["阶"] >= 1 then
       power = power+1000
    end
	if wugongid == 15 and match_ID(personid, 64) and JY.Person[64]["阶"] >= 2 then
       power = power+800
    end
	if (wugongid == 46 or wugongid == 16 ) and match_ID(personid, 80) and JY.Person[80]["阶"] >= 2 then
       power = power+1000
    end
	if wugongid == 7 and match_ID(personid, 82) then
       power = power+300*JY.Person[82]["阶"]
    end
	if wugongid == 239 and match_ID(personid, 85) and JY.Person[85]["阶"] >= 1 then
       power = power+500
    end
	if match_ID(personid, 112) and JY.Person[112]["阶"] >= 2 then
       power = power+500
    end
	if wugongid == 43 and match_ID(personid, 113) and JY.Person[113]["阶"] >= 2 then
       power = power+1000
    end
	if wugongid == 155 and match_ID(personid, 601) and JY.Person[601]["阶"] >= 3 then
       power = power+3000
    end
	if (wugongid == 202 or wugongid == 203 or wugongid == 205 or wugongid == 210) and match_ID(personid, 673) and JY.Person[673]["阶"] >= 1 then
       power = power + 1000
    end
	if wugongid == 208 and match_ID(personid, 688) and JY.Person[688]["阶"] >= 1 then
       power = power+800
    end
	
	if (wugongid == 11 or wugongid == 164 or wugongid == 201) and match_ID(personid, 637) then
       power = power + 500
    end
	if JY.Person[personid]["地7"] == 2 and (JY.Wugong[wugongid]["武功类型"] == 1 or JY.Wugong[wugongid]["武功类型"] == 2) then
	   power = power + 500
	end
	if JY.Person[personid]["地7"] == 3 and (JY.Wugong[wugongid]["武功类型"] == 3 or JY.Wugong[wugongid]["武功类型"] == 4 or JY.Wugong[wugongid]["武功类型"] == 5) then
	   power = power + 500
	end
	if match_ID(personid, 681) and JY.Wugong[wugongid]["武功类型"] == 4 then
	   power = power * 1.1
	end
	if JY.Person[48]["天1"] == 1 and JY.Wugong[wugongid]["武功类型"] == 6 and match_ID(personid, 48) then
	   power = power * 1.1
	end
	if JY.Person[personid]["地2"] == 1 and JY.Wugong[wugongid]["武功类型"] == 1 then
	   power = power * 1.2
	end
	if JY.Person[personid]["地2"] == 2 and JY.Wugong[wugongid]["武功类型"] == 2 then
	   power = power * 1.2
	end
	if JY.Person[personid]["地2"] == 3 and JY.Wugong[wugongid]["武功类型"] == 3 then
	   power = power * 1.2
	end
	if JY.Person[personid]["地2"] == 4 and JY.Wugong[wugongid]["武功类型"] == 4 then
	   power = power * 1.2
	end
	if JY.Person[personid]["地2"] == 5 and JY.Wugong[wugongid]["武功类型"] == 5 then
	   power = power * 1.2
	end
	if JY.Person[personid]["地2"] == 6 then
	   power = power * 1.15
	end
	if JY.Person[personid]["地5"] == 1 then
	local wg = {8, 22, 26, 43, 49, 51, 56, 57, 58, 65, 66, 74, 75, 76, 80, 98, 101, 108, 120, 122, 132, 133, 135, 136, 137, 138, 140, 170}
	   for i = 1, #wg do
	       if wugongid == wg[i] then
		   power = power * 1.5
		   end
	   end
	end 

	if wugongid == 210 and not match_ID(personid, 673) then
	   power = power*0.75
	end
	if wugongid == 1 then
	if tg ~= 1 then
	  if fx > 0 then
		power = power + fx*30
	  end
	  if fx > 9 then
		power = power + 500
	  end
	else
		power = power + yang*30 + 500
	end
	
	end
	
	if JY.Wugong[wugongid]["武功类型"] == 2 and match_ID(personid, 678) and JY.Person[678]["天1"] == 1 then
	   power = power * 1.1
	end
	if match_ID(personid, 688) and JY.Person[688]["天1"] == 2 then
	  if WAR.SXTJ ~= nil then
	   power = power + WAR.SXTJ*3
	  end
	end
	if match_ID(personid, 48) and JY.Person[48]["天3"] == 1 and wugongid == 120 then
	   power = power + 700
	end
	--无量神掌
	if wugongid == 212 then
	power = power + JY.Person[675]["品德"]*170
	end
	if wugongid == 211 then
	power = power + JY.Person[675]["声望"]
	end
	--剑血浮生
	if wugongid == 200 then
	   power = JY.Person[personid]["御剑能力"]+2500+math.modf(JY.Person[personid]["御剑能力"]*2*(JY.Person[personid]["生命最大值"]-JY.Person[personid]["生命"])/JY.Person[personid]["生命最大值"])
	end
	if wugongid == 219 then
	   power = JY.Person[personid]["耍刀技巧"]+600
    end
	--[[桃花绝技威力提高
	if (wugongid == 12 or wugongid == 18 or wugongid == 38) and TaohuaJJ(personid) then
		power = 1100
	end]]
	--学了葵花之后，辟邪的威力
	if wugongid == 48 and PersonKF(personid, 105) then
		power = power + 200
	end
	--七伤拳
	if wugongid == 23 then
	  if inteam(personid) then
	  local add = JY.Person[personid]["内力"]/17
	    if add > 490 then
		   add = 490
		end
	    if JY.Person[personid]["内力最大值"] >= 9999 then
	       add = add + 177
	    end
	  power = power + add
	  else
	    power = power + 490
	  end
	end
	
	if match_ID(personid, 689) then
	   power = power*(1.1^JY.Person[689]["天3"])+100*JY.Person[689]["天3"]
	end
	
	--成昆，幻阴指
	if match_ID(personid, 18) and wugongid == 19 then
	   power = power + 400
	end
	
	--裘千仞，铁掌
	if match_ID(personid, 67) and wugongid == 13 then
	   power = power + 300
	end
	
	--丁典，神照
	if wugongid == 94 and JY.Person[672]["声望"] == 100 and match_ID(personid, 672) then
	   power = power + 100
	   if JY.Person[672]["品德"] == 100 then
	      power = power + 350
	   end
	end
	
	if wugongid == 201 then
	
	if tg ~= 1 then
	   if fx < 0 then
	   power = power - 30*fx
	   end
	   if fx < -9 then
	   power = power + 550
	   end
	else
	   power = power - 30*yin + 550
	end
	
	end

	if wugongid == 11 then
	   
	if tg ~= 1 then
	   if fx < 0 then
	   power = power - 10*fx
	   end
	   if fx < -9 then
	   power = power + 800
	   end
	else
	   power = power - 15*yin + 700
	end
	end
	
	if wugongid == 48 then
	if tg ~= 1 then
	   if fx < 0 then
	   power = power^(1-0.006*fx)
	   end
	else
	   power = power^(1-0.006*yin)
	end
	end
	
	
	--[[无名，剑法
	if match_ID(personid, 671) and JY.Wugong[wugongid]["武功类型"] == 3 and wugongid ~= 199 then
	   power = math.modf(power*1.2)
	end]]
	
	--雷震，易筋经
	if match_ID(personid, 670) and JY.Person[personid]["天赋内功"] == 108 and PersonKF(personid, 108) then
	   power = power*1.2
	end
	
	if match_ID(personid, 676) and JY.Person[676]["天4"] == 1 then
	   power = power*1.5
	end
	
	if match_ID(personid, 681) and JY.Person[681]["天4"] == 1 then
	   power = power * 1.25
	end
	if match_ID(personid, 682) and JY.Person[682]["天3"] == 1 then
	   power = power * 1.25
	end
	
	--易筋经
	if Curr_NG(personid, 108) and wugongid ~= 199 then
	   
	if tg ~= 1 then
	  if fx > 0 then
		power = power*((fx*0.01)+1)
	  end
	else
		power = power*((yang*0.01)+1)
	end
	end
	
	if (wugongid == 46 or wugongid == 16 or wugongid == 171) and match_ID(personid, 5) and JY.Person[5]["阶"] >= 2 then
       power = power*1.2
    end
	if wugongid == 37 and match_ID(personid, 7) and JY.Person[7]["阶"] >= 1 then
       power = power*1.5^JY.Person[7]["阶"]
    end
	if wugongid == 34 and match_ID(personid, 19) and JY.Person[19]["阶"] >= 1 then
       power = power*2
    end
	if wugongid == 22 and match_ID(personid, 70) and JY.Person[70]["阶"] >= 1 then
       power = power*2
    end
	if wugongid == 32 and match_ID(personid, 20) and JY.Person[20]["阶"] >= 1 then
       power = power*2
    end
	if wugongid == 30 and match_ID(personid, 21) and JY.Person[21]["阶"] >= 2 then
       power = power*2
    end
	if wugongid == 4 and match_ID(personid, 12) and JY.Person[12]["阶"] >= 1 then
       power = power*2^JY.Person[12]["阶"]
    end
	if wugongid == 207 and match_ID(personid, 22) and JY.Person[22]["阶"] >= 2 then
       power = power*2
    end
	if wugongid == 31 and match_ID(personid, 23) and JY.Person[23]["阶"] >= 3 then
       power = power*2
    end
	if wugongid == 13 and match_ID(personid, 67) and JY.Person[67]["阶"] >= 1 then
       power = power*2
    end
	if (wugongid == 54 or wugongid == 62) and match_ID(personid, 77) and JY.Person[77]["阶"] >= 1 then
       power = power*2
    end
	if wugongid == 36 and match_ID(personid, 80) and JY.Person[80]["阶"] >= 1 then
       power = power*2
    end
	if wugongid == 56 and match_ID(personid, 89) and JY.Person[89]["阶"] >= 1 then
       power = power*3
    end
	if wugongid == 59 and match_ID(personid, 106) and JY.Person[106]["阶"] >= 1 then
       power = power*2
    end
	if (wugongid == 72 or wugongid == 73 or wugongid == 84 or wugongid == 142) and match_ID(personid, 115) and JY.Person[115]["阶"] >= 3 then
       power = power*2
    end
	if wugongid == 3 and match_ID(personid, 161) and JY.Person[161]["阶"] >= 1 then
       power = power*2
    end
	if JY.Wugong[wugongid]["武功类型"] == 1 and match_ID(personid, 186) and JY.Person[186]["阶"] >= 1 then
       power = power*1.5
    end
	
	--天佛降世
	if match_ID(personid, 670) and wugongid == 197 then
	   power = power + JY.Person[personid]["拳掌功夫"]*2+1100
	end
	if wugongid == 220 then
	   power = power + JY.Person[personid]["拳掌功夫"]*1.3
	end
	if wugongid == 221 then
	   power = power + JY.Person[personid]["拳掌功夫"]*2.1
	end
	if wugongid == 222 then
	   power = power + JY.Person[personid]["御剑能力"]*2.3
	end
	
	--提高天赋内功的威力
	if power < 1000 and Given_NG(personid, wugongid) then
		power = power + 100
		if power > 1000 then
			power = 1000
		end
	end
	--提高天赋外功的威力
	if Given_WG(personid, wugongid) and wugongid ~= 161 and wugongid ~= 199 and wugongid ~= 217 and wugongid ~= 218 and wugongid ~= 219 and wugongid ~= 221 and wugongid ~= 222 then
		if power < 1200 then
			power = power + 200
		elseif power >= 1200 and power < 1400 and wugongid ~= 199 then
			power = 1400
		end
	end
	--一指镇江南
	if match_ID(personid, 138) and JY.Wugong[wugongid]["武功类型"] == 2 and JY.Base["天书数量"] > 0 then
	   power = power* (1.08 ^ JY.Base["天书数量"])
	end   
	--觉醒后翻倍的众人
	--王重阳+全真七子，全真剑法
	if wugongid == 39 and JY.Person[0]["六如觉醒"] > 3 then
		if match_ID(personid, 123) or match_ID(personid, 124) or match_ID(personid, 125) or match_ID(personid, 126) or
		match_ID(personid, 127) or match_ID(personid, 128) or match_ID(personid, 129) or match_ID(personid, 68) then
			power = power * 2
		end
	end
	if wugongid == 49 and match_ID(personid, 670) then
	   power = power * 1.15
	end
	--梅超风，九阴白骨爪
	if wugongid == 11 and JY.Base["天书数量"] > 6 and match_ID(personid, 78) then
		power = power * 1.5
	end
	--圣火令
	if JY.Person[personid]["武器"] == 337 and wugongid == 93 then
	   power = power + JY.Thing[337]["装备等级"]*50
	end
	--雪饮刀
	if JY.Person[personid]["武器"] == 360 and JY.Wugong[wugongid]["武功类型"] == 4 then
	   power = power + JY.Thing[360]["装备等级"]*40
	end
	if JY.Person[personid]["武器"] == 362 and JY.Wugong[wugongid]["武功类型"] == 3 then
	   power = power + JY.Thing[362]["装备等级"]*40
	end
	--田伯光，狂风刀法
	if wugongid == 55 and match_ID(personid, 29) and JY.Person[654]['品德']>=90 then
		power = power + 500*(JY.Person[654]['品德']-90)
	end
	if match_ID(personid, 29) and JY.Person[654]['品德'] == 93 and JY.Wugong[wugongid]["武功类型"] == 4 then
	   power = power*1.2
	end 
	if match_ID(personid, 691) and JY.Wugong[wugongid]["武功类型"] == 4 then
	   power = power + 300
	end
	if match_ID(personid, 693) and JY.Wugong[wugongid]["武功类型"] == 1 and JY.Person[693]["天1"] == 1 then
	   power = power + 300
	end
	
	if match_ID(personid, 693) and wugongid == 250 and JY.Person[693]["天3"] == 1 then
	   power = power + 1000
	end
	
	--韦一笑，寒冰绵掌
	if wugongid == 5 and JY.Base["天书数量"] > 6 and match_ID(personid, 14) then
		power = power * 2
	end
	--殷天正，鹰爪功
	if wugongid == 4 and JY.Base["天书数量"] > 6 and match_ID(personid, 12) then
		power = power * 2
	end
	--朱聪，分筋错骨手
	if wugongid == 117 and JY.Base["天书数量"] > 6 and match_ID(personid, 131) then
		power = power * 2
	end
	--黄钟公，持瑶琴
	if wugongid == 73 and JY.Base["天书数量"] > 6 and match_ID(personid, 34) then
		power = power * 2
	end
	--黑白子，棋盘招式
	if wugongid == 72 and JY.Base["天书数量"] > 6 and match_ID(personid, 33) then
		power = power * 2
	end
	--秃笔翁，倚天屠龙功
	if wugongid == 84 and JY.Base["天书数量"] > 6 and match_ID(personid, 32) then
		power = power * 2
	end
	--丹青生，妙笔丹青
	if wugongid == 142 and JY.Base["天书数量"] > 6 and match_ID(personid, 31) then
		power = power * 2
	end
	--花铁杆，中平枪法
	if wugongid == 70 and JY.Base["天书数量"] > 6 and match_ID(personid, 52) then
		power = power * 2
	end
	if wugongid == 70 and match_ID(personid, 52) and JY.Person[personid]["六如觉醒"] >= 6 then
	   power = power * 2
	end
	--花铁杆，中平枪法
	if wugongid == 70 and JY.Base["天书数量"] > 13 and match_ID(personid, 52) then
		power = power * 2
	end
	--潇湘子，鹤蛇八打
	if wugongid == 74 and JY.Base["天书数量"] > 6 and match_ID(personid, 157) then
		power = power * 2
	end
	--白万剑，雪山剑法
	if wugongid == 35 and JY.Base["天书数量"] > 6 and match_ID(personid, 43) then
		power = power * 2
	end
	--余沧海，松风剑法
	if wugongid == 27 and (match_ID_awakened(personid, 24, 1) or match_ID_awakened(personid, 24, 2)) then
		power = power*5
	end
	if wugongid == 201 and match_ID_awakened(personid, 24, 2) then
		power = power*5
	end
	--余沧海，松风剑法
	if wugongid == 27 and JY.Base["天书数量"] > 6 and match_ID(personid, 24) then
		power = power * 2 
	end
	--欧阳克，白驼拳
	if wugongid == 9 and JY.Base["天书数量"] > 6 and match_ID(personid, 61) then
		power = power * 2
	end
	--海大富，化骨绵掌
	if wugongid == 118 and JY.Base["天书数量"] > 6 and match_ID(personid, 602) then
		power = power * 2
	end
	--霍青桐，三分剑法
	if wugongid == 29 and JY.Base["天书数量"] > 6 and match_ID(personid, 74) then
		power = power + 300
	end
	--霍青桐，三分剑法
	if wugongid == 29 and match_ID_awakened(personid, 74, 1) then
		power = power + 600
	end
	--扫地僧，慈悲刀法
	if wugongid == 57 and match_ID(personid, 114) then
		power = power * 2
	end
	--袁士霄，百花错拳
	if wugongid == 10 and match_ID(personid, 635) then
		power = power * 2
	end
	if (wugongid == 49 or wugongid == 224) and match_ID(personid, 687) then
	   power = power*1.2
	end
	if wugongid == 17 and match_ID(personid, 687) then
	   power = power + JY.Person[687]["声望"]/2
	   if JY.Person[687]["天2"] == 1 and JY.Person[687]["声望"] == 1000 then
	      power = power + JY.Person[687]["声望"]/2
	   end
	end
	--王元霸，五虎断门刀
	if wugongid == 59 and JY.Person[personid]["武器"]==47 and match_ID(personid, 106) then
		power = power + 300
	end
	--灵蛇
	if wugongid == 81 and JY.Person[personid]["武器"]== 244 and JY.Person[personid]["专2"] == 81 then
		power = power + 800
	end
	if wugongid == 189 and ((JY.Person[personid]["武器"]== 319 and JY.Person[personid]["专2"] == 189) or match_ID(personid, 691)) then
		power = power + 900
	end
	if wugongid == 59 and JY.Base["天书数量"] > 6 and match_ID(personid, 106) then
		power = power * 2
	end
	if wugongid == 161 and JY.Person[personid]["专1"] == 161 then
	   power = power + 100
	end
	--玉真子战斗中铁血十二式威力翻倍
	if match_ID(personid, 184) and wugongid == 161 and JY.Status == GAME_WMAP and WAR.HTS > 0 then
		power = power * WAR.HTS
	end
	--阿九战斗中铁血十二式威力翻倍
	if match_ID(personid, 629) and wugongid == 161 and JY.Status == GAME_WMAP and WAR.HTS > 0 then
		power = power * WAR.HTS
	end
	--何铁手战斗中五毒威力翻倍
	if match_ID(personid, 83) and wugongid == 3 and JY.Status == GAME_WMAP and WAR.HTS > 0 then
		power = power * WAR.HTS
		if JY.Person[83]["阶"] >= 1 then
		   power = power*2
		end
	end
	if match_ID(personid, 646) and JY.Person[646]["天2"] == 1 and wugongid == 183 and JY.Status == GAME_WMAP then
	   local add = 0
	   for i = 0, WAR.PersonNum-1 do
	       add = add + JY.Person[WAR.Person[i]["人物编号"]]["中毒程度"]*2
	   end
	   power = power + add
	   if JY.Person[646]["阶"] >= 1 then
	   power = power*(JY.Person[personid]["中毒程度"]*0.01 + 1)
	   end
	end
	--天山折梅手，虚竹威力提高
	if wugongid == 14 then
		if match_ID(personid, 49) then
			for i = 1, JY.Person[671]["品德"] do
				if JY.Person[personid]["武功"..i] ~= 14 and JY.Person[personid]["武功等级"..i] == 999 then
					power = power + 50
				end
			end
		end
	end
	--豪鬼
	if wugongid == 202 or wugongid == 203 then
		if match_ID(personid, 673) then
			for i = 1, JY.Person[671]["品德"] do
				if JY.Person[personid]["武功"..i] ~= 202 and JY.Person[personid]["武功"..i] ~= 203 and JY.Person[personid]["武功"..i] ~= 0 and JY.Wugong[JY.Person[personid]["武功"..i]]["武功类型"] == 1 then
					power = power+120
				end
			end
		end
	end
	if wugongid == 217 and personid == 681 then
	   power = 1200
	end
	--五岳剑法威力提高
	if wugongid >= 30 and wugongid <= 34 and WuyueJF(personid) then
		power = power + 500
	end
	--五岳剑法+五岳剑诀，威力提高
	if wugongid >= 30 and wugongid <= 34 and PersonKF(personid,175) then
		power = power + 200
		if JY.Person[personid]["专1"] == 175 then
		   power = power + 500
		end
	end
	
	--琴棋书画威力提高
	if (wugongid == 73 or wugongid == 72 or wugongid == 84 or wugongid == 142) and QinqiSH(personid) then
		power = power + 300
	end
	
	--天山六阳掌
	if wugongid == 8 and JY.Person[personid]["专2"] == 8 then
	   power = power + 600
	end
	if wugongid == 115 and SanhuaJD(personid) then
	   power = power + 666
	end
	--桃花绝技威力提高
	if (wugongid == 12 or wugongid == 18 or wugongid == 38) and TaohuaJJ(personid) then
		power = power + 300
	end
	--九阴神功对白骨爪威力提高
	if wugongid == 11 and PersonKFJ(personid, 107) then
		power = power + 200
	end
	if wugongid == 201 and PersonKF(personid, 107) then
		power = power + 200
	end
	
	--百花错拳
	if wugongid == 10 and JY.Person[personid]["专1"] == 10 then
	   power = power + 500
	end
	--寒冰之墙
	if wugongid == 234 and JY.Person[personid]["专1"] == 234 then
	   power = power + 400
	end
	--声波
	if match_ID(personid, 689) and wugongid == 235 and JY.Person[690]["天3"] == 2 then
	   power = power + 600
	end
	if match_ID(personid, 689) and wugongid == 228 and JY.Person[690]["品德"] == 1 then
	   power = power + 500
	end
	--苏灿
	if match_ID(personid, 692) and JY.Wugong[wugongid]["武功类型"] < 6 and JY.Person[692]["天1"] == 1 then
	   power = power + 300
	end
	if match_ID(personid, 692) and (wugongid == 80 or wugongid == 26) and JY.Person[692]["天3"] == 2 then
	   power = power + 1000
	end
	if match_ID(personid, 692) and wugongid == 26 and JY.Person[692]["天4"] == 1 then
	   power = power + 500
	end
	--三分剑法
	if wugongid == 29 and JY.Person[personid]["专1"] == 29 then
	   power = power + 500
	end
	--太岳三青峰
	if wugongid == 34 and JY.Person[personid]["专1"] == 34 then
	   power = power + 300
	end
	--柴刀十八路
	if wugongid == 50 and JY.Person[personid]["专1"] == 50 then
	   power = power + 600
	end
	if JY.Wugong[wugongid]["武功类型"] == 4 and JY.Person[personid]["专1"] == 54 and PersonKF(personid, 54) then
	   power = power + 250
	end
	if wugongid > 108 and wugongid < 113 and JY.Person[personid]["专2"] == wugongid then
	   power = power + 1000
	end
	if wugongid == 116 and JY.Person[personid]["专1"] == 116 then
	   power = power + 1000
	end
	if wugongid == 117 and JY.Person[personid]["专1"] == 117 then
	   power = power + 800
	end
	if wugongid == 118 and (JY.Person[personid]["专2"] == 118 or match_ID(personid, 602)) then
	   power = power + 400
	end
	if wugongid == 119 and JY.Person[personid]["专2"] == 119 then
	   power = power + 700
	end
	if wugongid == 239 and JY.Person[personid]["专2"] == 239 then
	   power = power + 500
	end
	if wugongid == 124 and JY.Person[personid]["专1"] == 124 then
	   power = power + 800
	end
	if wugongid == 126 and JY.Person[personid]["专1"] == 126 then
	   power = power + 500
	end
	if wugongid == 127 and JY.Person[personid]["专1"] == 127 then
	   power = power + 700
	end
	if wugongid == 131 and JY.Person[personid]["专1"] == 131 then
	   power = power + 500
	end
	if JY.Wugong[wugongid]["武功类型"] == 2 and PersonKF(personid, 132) and JY.Person[personid]["专2"] == 132 then
	   power = power + 400
	end
	if JY.Wugong[wugongid]["武功类型"] == 4 and PersonKF(personid, 215) and JY.Person[personid]["专2"] == 215 then
	   power = power + 300
	end
	if wugongid == 137 and JY.Person[personid]["专2"] == 137 then
	   power = power + 400
	end
	if wugongid == 139 and JY.Person[personid]["专2"] == 139 then
	   power = power + 300
	end
	if wugongid == 142 and JY.Person[personid]["专2"] == 142 then
	   power = power + 800
	end
	if wugongid == 153 and JY.Person[personid]["专2"] == 153 then
	   power = power + 600
	end
	if wugongid == 183 and JY.Person[personid]["专2"] == 183 then
	   power = power + 500
	end
	--金蛇剑法
	if wugongid == 40 and JY.Person[personid]["专1"] == 40 then
	   power = power + 300
	end
	--苗家剑法
	if wugongid == 44 and JY.Person[personid]["专2"] == 44 then
	   power = power + 800
	end
	--血刀大法
	if wugongid == 63 and JY.Person[personid]["专2"] == 63 then
	   power = power + 700
	end
	if wugongid == 164 and JY.Person[personid]["专2"] == 164 then
	   power = power + 300
	end
	if wugongid == 67 and JY.Person[personid]["专2"] == 67 then
	   power = power + 600
	end
	if wugongid == 69 and JY.Person[personid]["专1"] == 69 then
	   power = power + 1000
	end
	if wugongid == 72 and JY.Person[personid]["专1"] == 72 then
	   power = power + 500
	end
	if wugongid == 73 and JY.Person[personid]["专1"] == 73 then
	   power = power + 700
	end
	if wugongid == 74 and JY.Person[personid]["专1"] == 74 then
	   power = power + 300
	end
	if wugongid == 84 and JY.Person[personid]["专2"] == 84 then
	   power = power + 300
	end
	if wugongid == 184 and JY.Person[personid]["专2"] == 184 then
	   power = power + 500
	end
	--雪山剑法
	if wugongid == 35 and JY.Person[personid]["专1"] == 35 then
	   power = power + 300
	end
	--九阴白骨爪
	if wugongid == 11 and JY.Person[personid]["专2"] == 11 then
	   power = power + 300
	end
	if wugongid == 196 and JY.Person[personid]["专1"] == 196 then
	   power = power + 500 + JY.Base["天书数量"]*100
	end
	if wugongid == 206 and JY.Person[personid]["专2"] == 206 then
	   power = power + 500
	end
	--擒龙功对降龙十八掌, 打狗棒法威力+200
	if (wugongid == 26 or wugongid == 80) and PersonKF(personid,188) then
		power = power + 200
	end
	--碧池神功对落英神剑掌、弹指神通、玉箫剑法、旋风扫叶腿、兰花拂穴手+200
	if (wugongid == 12 or wugongid == 18 or wugongid == 38 or wugongid == 129 or wugongid == 126) and PersonKF(personid,193) then
		power = power + 200
	end
	--玉女心经对古墓武功威力提高
	if (wugongid == 6 or wugongid == 42 or wugongid == 79 or wugongid == 139) and PersonKF(personid,154) then
		power = power + 200
		if JY.Person[personid]["专2"] == 154 then
		power = power + 200
		end
	end
	
	--太玄
	if Curr_NG(personid, 102) and JY.Person[personid]["天赋内功"] == 102 then
	   if JY.Wugong[wugongid]["武功类型"] == 1 then
	   power = power + JY.Person[personid]["拳掌功夫"]
	   elseif JY.Wugong[wugongid]["武功类型"] == 2 then
	   power = power + JY.Person[personid]["指法技巧"]
	   elseif JY.Wugong[wugongid]["武功类型"] == 3 then
	   power = power + JY.Person[personid]["御剑能力"]
	   elseif JY.Wugong[wugongid]["武功类型"] == 4 then
	   power = power + JY.Person[personid]["耍刀技巧"]
	   elseif JY.Wugong[wugongid]["武功类型"] == 5 then
	   power = power + JY.Person[personid]["特殊兵器"]
	   end
	end
	--武器装备威力加成
	for i,v in ipairs(CC.ExtraOffense) do
		if v[1] == JY.Person[personid]["武器"] and v[2] == wugongid then
			power = power + v[3]
		end
	end
	
	--只有战斗中才有的加成
	if JY.Status == GAME_WMAP then
		--太极拳蓄力
		if wugongid == 16 and WAR.tmp[3000 + personid] ~= nil and WAR.tmp[3000 + personid] > 0 then
			power = power + WAR.tmp[3000 + personid]
		end
		--田伯光，狂风刀法
		if match_ID(personid, 29) and JY.Person[29]["阶"] >= 3 and wugongid == 55 then
		   power = power*(1+WAR.JQSDXS[personid]/67)
		end
		--柯镇恶
		if match_ID(personid, 130) and JY.Person[130]["阶"] >= 1 then
		   power = power+WAR.JQSDXS[personid]*10
		   if JY.Person[130]["阶"] >= 3 then
		   power = power+WAR.JQSDXS[personid]*10
		   end
		end
		
		if wugongid == 46 and WAR.tmp[3000 + personid] ~= nil and WAR.tmp[3000 + personid] > 0 then
			power = power + math.modf(WAR.tmp[3000 + personid]/2)
		end
		if wugongid == 197 and WAR.LQZ[personid] ~= nil then
		   power = power + WAR.LQZ[personid]*8
		   if WAR.LQZ[personid] == 100 then
		     power = power + 1000
		   end
	    end
		--辟邪剑法
	    if wugongid == 48 and WAR.JQSDXS[personid] ~= nil then
	       power = power + WAR.JQSDXS[personid]*4
	    end

		--须弥山神掌
	    if wugongid == 24 and WAR.LQZ[personid] == 100 then
		   power = power + 500
		end
		if match_ID(personid, 681) and JY.Person[681]["天4"] == 1 and WAR.MXD[personid] ~= nil then
	       power = power * 1.25
	    end
	end
	--周芷若，谁与争锋
	if match_ID(personid, 631) and JY.Person[personid]["武器"] == 37 and JY.Wugong[wugongid]["武功类型"] == 3 then
		power = power + 500
	end
	if JY.Person[personid]["人3"] == 1 and JY.Person[personid]["武器"] > 0 then
		power = power + 200
	end
	
	--六脉神剑
	if JY.Wugong[wugongid]["武功类型"] == 2 and PersonKF(personid, 49) and JY.Person[personid]["专2"] == 49 then
	   power = power * 1.1
	end
	--林朝英，惊才绝艳
	if match_ID(personid, 605) then
		power = power * 1.1
	end
	if match_ID(personid, 693) and JY.Wugong[wugongid]["武功类型"] == 1 and JY.Person[693]["天4"] == 2 then
	   power = power*1.7
	end
	if fx == 0 and (wugongid == 16 or wugongid == 46 or wugongid == 171 or wugongid == 108) then
	    power = power*(1.05+(1 + yang)*0.01)
	end
	if JY.Wugong[wugongid]["啊"] == 0 then
	   if fx == 0 then
	   power = power+(1 + yang)*15
	   elseif math.abs(fx) <= 2 and yin < -2 and yang > 2 then
	          if fx > 0 then
			     power = power-yin*15
			  elseif fx < 0 then
			     power = power+yang*15
			  end  
	   end
	end
	if match_ID(personid, 634) and (wugongid == 168 or wugongid == 101 or wugongid == 98 or wugongid == 8 or wugongid == 14 or wugongid == 184) then
	   power = power * 1.3
	end
	
	if JY.Person[personid]["内力性质"] < 0 then
	   power = power + 150
	end
	
	--岳灵珊
	if JY.Wugong[wugongid]["武功类型"] == 3 and match_ID(personid, 79) and JY.Person[79]["阶"] >= 1 then
       power = power*1.3
	   if JY.Person[79]["阶"] >= 2 then
	   power = power*1.3
	   end
	   if JY.Person[79]["阶"] >= 3 then
	   local z = 0
	    for i = 2, JY.Person[671]["品德"] do
			if JY.Wugong[JY.Person[personid]["武功" .. i]]["武功类型"] == 3 then
			   z = z + JY.Wugong[JY.Person[personid]["武功" .. i]]["攻击力10"]
			end
		end
		if wugongid == JY.Person[personid]["武功1"] then
		   power = power + z
		end
	   end
    end
	
	if personid == 0 and JY.Person[0]["天3"] == 2 then
	   if power < 1300 then
	      power = 1300
	   end	  
	end
	if personid == 0 and JY.Person[0]["天4"] == 4 and JY.Person[0]["武功"..JY.Person[671]["品德"]] > 0 then
	   power = power + 700
	end
	if match_ID(personid, 50) and JY.Wugong[wugongid]["武功类型"] < 6 and JY.Wugong[wugongid]["武功类型"] > 0 then
	   if power < 1000 then
	      power = 1000
	   end
	end
	if wugongid == 223 then
	   power = 0
	end
	if JY.Wugong[wugongid]["武功类型"] < 7 and power <= 0 then
	   power = 1
	end
	if wugongid == 225 then--普通攻击
	power = power*0.05 + JY.Wugong[wugongid]["攻击力"..wugonglvl] + Xishu_max(personid)*0.5 + JY.Person[personid]["攻击力"]*0.5 + JY.Person[personid]["内力"]*0.04
	  if JY.Person[0]["天2"] == 4 and personid == 0 then
	     power = power + 700
	  end
	if PersonKF(personid, 103) then
	   power = power + 350
	end
	if match_ID(personid, 682) then
	   power = power + 400
	end
    if JY.Person[personid]["地1"] == 7 then
       power = power + 200
	end
	if JY.Person[personid]["地6"] == 8 then
       power = power*2
	end
	   --熔炉
	   if match_ID(personid, 690) then
	      power = power + 200*JY.Person[689]["天3"]
	   end
	   if not inteam(personid) then
	      power = (power + 150)*(1+0.03*JY.Base["天书数量"]+0.05*JY.Base["难度"])
	   end
	end
	if match_ID(personid, 76) and JY.Person[76]["阶"] >= 1 then
       power = power*1.3
    end
	if wugongid == 241 then
	   power = 13500
	end
	if JY.Person[677]["阶"] >= 2 and match_ID(personid, 677) then
	   power = power*1.5
	end
	power = math.modf(power)
	return power
end

--Nv，cd
function KungfuCD(personid, wugongid)
local yin, yang, tg = NeiL(personid)
local fx = yin + yang
	local cd

	cd = JY.Wugong[wugongid]["冷却"]
	--[[队伍外-1
	if not inteam(personid) then
	   if (JY.Person[0]["实战"] > 200 or JY.Base["天书数量"] > 4) and JY.Base["难度"] == 7 then
	      cd = cd - 1
	   end
	end]]
	if personid == 0 then
	if wugongid == JY.Person[261]["声望"] then
	   if cd > 1 then
	   cd = cd - 1
	   if cd < 1 then
	      cd = 1
	   end
	   end
	end
	if wugongid == JY.Person[262]["声望"] then
	   if cd > 1 then
	   cd = cd - 1
	   if cd < 1 then
	      cd = 1
	   end
	   end	  
	end
	if wugongid == JY.Person[263]["声望"] then
	   if cd > 1 then
	   cd = cd - 1
	   if cd < 1 then
	      cd = 1
	   end
	   end	  
	end
	end
	----------------==================计算0
	if not inteam(personid) then
	   if JY.Person[0]["实战"] > 500 - 50*JY.Base["难度"] then
	      cd = cd - 1
	   end
	   if JY.Person[0]["实战"] > 450 and JY.Base["难度"] >= 7 then
	      cd = cd - 1
	   end
	end
	if inteam(personid) and JY.Base["难度"] == 1 then
	   cd = 0
	end
	if JY.Person[123]["天2"] == 2 then
	   cd = 0
	end
	--天内外-1
	for i = 1, 4 do
	    if JY.Person[personid]["天赋外功"..i] == wugongid then
		   cd = cd - 1
		end
	end
	--[[if JY.Person[personid]["天赋内功"] == wugongid then
	   cd = cd - 1
	end]]
	if fx >= 5 then
	   if JY.Wugong[wugongid]["啊"] > 0 then
	      cd = cd - 1
	   end  
	end
	if fx <= -5 then
	   if JY.Wugong[wugongid]["啊"] < 0 then
	      cd = cd - 1
	   end  
	end
	if fx == 0 and yang >= 5 then
	   if JY.Wugong[wugongid]["啊"] == 0 then
	      cd = cd - 1
	   end
	end
	if wugongid == 49 and match_ID(personid, 687) then--段思平六脉
	   cd = 0
	end
    if (wugongid == 11 or wugongid == 164 or wugongid == 201) and match_ID(personid, 637) then
       cd = 0
    end
    if wugongid == 106 and match_ID(personid, 638) then
       cd = 0
    end	
	if match_ID(personid,602) and wugongid == 118 then
	   cd = cd - 1
	end
	if JY.Person[690]["品德"] == 1 and wugongid == 228 then
	   cd = cd - 3
	end
	if match_ID(personid,688) and wugongid == 208 then
	   cd = cd - 1
	end
	if match_ID(personid,691) and wugongid == 189 then
	   cd = cd - 1
	end
	if (match_ID(personid,597) or match_ID(personid,598) or match_ID(personid,599)) and wugongid == 82 then
	   cd = cd - 1
	end
	if JY.Person[personid]["专1"] == wugongid or JY.Person[personid]["专2"] == wugongid then
	   cd = cd - 1
	   if wugongid == 231 then
	   cd = cd - 1
	   end
	end
	if cd < 0 then
	   cd = 0
	end
	return cd
end

--无酒不欢：判定天赋外功的函数
function Given_WG(personid, WGid)
	local tw = false;
	for i = 1, 4 do
		if JY.Person[personid]["天赋外功"..i] == WGid then
			tw = true;
			break;
		end
	end
	return tw;
end

--无酒不欢：判定天赋内功的函数
function Given_NG(personid, NGid)
	local tw = false;
	if JY.Person[personid]["天赋内功"] == NGid then
		tw = true;
	end
	return tw;
end

--人物恢复站定
function stands()
	JY.MyCurrentPic=0
	if JY.Person[0]["性别"] == 0 then
		JY.MyPic=CC.MyStartPicM+JY.Base["人方向"]*7+JY.MyCurrentPic;
	else
		JY.MyPic=CC.MyStartPicF+JY.Base["人方向"]*7+JY.MyCurrentPic;
	end
end

--无酒不欢：马车的选择菜单
function TeleportMenu(menu, color, selectColor)
	local x1	--菜单起始X坐标
    local y1	--菜单起始Y坐标
    local w		--菜单宽度
    local h		--菜单高度
	local maxlength		--单位最大长度
	local size = CC.Fontsmall	--字体大小
    
	x1 = CC.MainMenuX+3
    y1 = CC.MainMenuY+CC.Fontsmall*2 +9

	maxlength = 8
	
	w = (size*maxlength/2+CC.RowPixel*4+5)*7 + CC.MenuBorderPixel	--7为列数
    h = (size+CC.RowPixel*2-1)*16 + CC.MenuBorderPixel				--16为最大行数
	
    lib.GetKey();
    Cls();
	
	lib.LoadPNG(1, 1003 * 2 , 0 , 0, 1)		--背景图
    
	--建立七个表格来存储不同类型的场景
    local PType_1 = {};
    local PNum_1 = 0;
	local PType_2 = {};
    local PNum_2 = 0;
	local PType_3 = {};
    local PNum_3 = 0;
	local PType_4 = {};
    local PNum_4 = 0;
	local PType_5 = {};
    local PNum_5 = 0;
	local PType_6 = {};
    local PNum_6 = 0;
	local PType_7 = {};
    local PNum_7 = 0;
    
	--v123分别为场景名称，可否进入，场景编号
	--v2为0代表可进入，1代表不可进入
    for i,v in pairs(menu) do
        if v[4] == 1 then
			PNum_1 = PNum_1 +1
			PType_1[PNum_1] = {v[1],v[2],v[3]}
		elseif v[4] == 2 then
			PNum_2 = PNum_2 +1
			PType_2[PNum_2] = {v[1],v[2],v[3]}	
		elseif v[4] == 3 then
			PNum_3 = PNum_3 +1
			PType_3[PNum_3] = {v[1],v[2],v[3]}
		elseif v[4] == 4 then
			PNum_4 = PNum_4 +1
			PType_4[PNum_4] = {v[1],v[2],v[3]}	
		elseif v[4] == 5 then
			PNum_5 = PNum_5 +1
			PType_5[PNum_5] = {v[1],v[2],v[3]}
		elseif v[4] == 6 then
			PNum_6 = PNum_6 +1
			PType_6[PNum_6] = {v[1],v[2],v[3]}
		elseif v[4] == 7 then
			PNum_7 = PNum_7 +1
			PType_7[PNum_7] = {v[1],v[2],v[3]}
		end
    end
	
	--场景信息
	local P_inf = {{PType_1,PNum_1},{PType_2,PNum_2},{PType_3,PNum_3},{PType_4,PNum_4},{PType_5,PNum_5},{PType_6,PNum_6},{PType_7,PNum_7},[0]={0,0}}
	local PType_name = {"客栈城镇","名门正派","奇教帮会","人物居所","山谷洞穴","海外岛屿","杂类场所"}

	--光标的初始位置
	local cursor_x = 1
	local cursor_y = 1
	local current = 1

	--返回值
    local returnValue =-1;
  
    local surid = lib.SaveSur(0, 0, CC.ScreenW, CC.ScreenH)

    while true do
		if JY.Restart == 1 then
			break
		end
        lib.LoadSur(surid, 0, 0)
		--DrawString(x1+10,y1-CC.RowPixel*4-7,"X:"..cursor_x.."，Y:"..cursor_y.."，Current:"..current,LimeGreen,size);	--输出测试信息
		for i = 1, 7 do
			--大类名称
			DrawString(x1+(i-1)*(size*maxlength/2+CC.RowPixel*4+5)+CC.MenuBorderPixel,y1-CC.RowPixel*6+1,PType_name[i],LimeGreen,size);
			for j = 1, 16 do
				if j > P_inf[i][2] then
					break;
				end
				--确定当前单位编号
				local id = 0
				for jj = 1, i do
					id = id + P_inf[jj-1][2]
				end
				id = id + j
				--无法进入的场景名称为灰色
				local drawColor = color; 
				if P_inf[i][1][j][2] == 1 then
					drawColor = M_DimGray
				end
				local xx = x1+(i-1)*(size*maxlength/2+CC.RowPixel*4+5) + CC.MenuBorderPixel
				local yy = y1+(j-1)*(size+CC.RowPixel*2-1)
				--区别当前选中的单位颜色
				if id == current then
					drawColor = selectColor;
					lib.Background(xx-5, yy-5, xx + size*maxlength/2+5, yy + size + 5, 128, color)
				end
				--显示场景名称
				DrawString(xx,yy,P_inf[i][1][j][1],drawColor,size);
			end
		end
  
        ShowScreen();
        local keyPress, ktype, mx, my = WaitKey(1)
		
		lib.Delay(CC.Frame);
				
		--ktype  1：键盘，2：鼠标移动，3:鼠标左键，4：鼠标右键，5：鼠标中键，6：滚动上，7：滚动下
        if keyPress==VK_ESCAPE or ktype == 4 then
            break;
        elseif keyPress==VK_DOWN then
			cursor_y = cursor_y + 1
			if cursor_y > P_inf[cursor_x][2] then
				cursor_y = 1
			end
		elseif keyPress==VK_UP then
			cursor_y = cursor_y - 1
			if cursor_y < 1 then
				cursor_y = P_inf[cursor_x][2]
			end
		elseif keyPress==VK_RIGHT then
			cursor_x = cursor_x + 1
			if cursor_x > 7 then
				cursor_x = 1
			end
			if cursor_y > P_inf[cursor_x][2] then
				cursor_y = 1
			end
		elseif keyPress==VK_LEFT then
			cursor_x = cursor_x - 1
			if cursor_x < 1 then
				cursor_x = 7
			end
			if cursor_y > P_inf[cursor_x][2] then
				cursor_y = 1
			end
		else
			local mk = false;
			if ktype == 2 or ktype == 3 then
				if mx >= x1 and mx <= x1 + w and my >= y1 and my <= y1 + h then
					cursor_x = math.modf((mx - x1 - CC.MenuBorderPixel)/(size*maxlength/2+CC.RowPixel*4+5)) + 1
					cursor_y = math.modf((my - y1 - CC.MenuBorderPixel) / (size+CC.RowPixel*2-1)) + 1
					mk = true;
				end
				if cursor_y > P_inf[cursor_x][2] then
					cursor_y = P_inf[cursor_x][2]
					mk = false;
				end
			end				
			if  keyPress==VK_SPACE or keyPress==VK_RETURN or (ktype == 3 and mk) then
				if P_inf[cursor_x][1][cursor_y][2] == 0 then
					returnValue=P_inf[cursor_x][1][cursor_y][3];
					break;
				end
			end
		end
		current = 0
		for i = 1, cursor_x do 
			current = current + P_inf[i-1][2]
		end
		current = current + cursor_y
    end
    lib.FreeSur(surid)
    --返回值
	return returnValue
end

--无酒不欢：判断队伍是不是有两个空位
function More_than_2_vacant_slot()
	if JY.Base["队伍14"] == -1 and JY.Base["队伍15"] == -1 then
		return true
	end
	return false
end

--无酒不欢：个人觉醒
function awakening(id, value)
	local xwperson;	--判定要觉醒的人
	if id == JY.Base["畅想"] then
		xwperson = 0
	else
		xwperson = id
	end
	JY.Person[xwperson]["个人觉醒"] = JY.Person[xwperson]["个人觉醒"] + value
end

--无酒不欢：增加武常
function kungfu_knowledge(id, value)
	local xwperson;	--判定要增加武常的人
	if id == JY.Base["畅想"] then
		xwperson = 0
	else
		xwperson = id
	end
	JY.Person[xwperson]["武学常识"] = JY.Person[xwperson]["武学常识"] + value
end

--无酒不欢：判定是否为指定ID的人物，并且判定是否达到指定觉醒次数
function match_ID_awakened(personid, id, awkntimes)
	if personid == id then
		if JY.Person[personid]["个人觉醒"] >= awkntimes then
			return true
		else
			return false
		end
	elseif personid == 0 and JY.Base["畅想"] == id then
		if JY.Person[0]["个人觉醒"] >= awkntimes then
			return true
		else
			return false
		end
	elseif (personid == 685 or (JY.Base["畅想"] == 685 and personid == 0)) and (JY.Person[685]["天1"] == id or JY.Person[685]["天2"] == id or JY.Person[685]["天3"] == id) and JY.Person[id]["个人觉醒"] >= awkntimes then
	    return true	
	else
		return false
	end
end

--直接设定指定人物的资质
function set_potential(id, value)
	local xwperson;	--判定要指定资质的人
	if id == JY.Base["畅想"] then
		xwperson = 0
	else
		xwperson = id
	end
	JY.Person[xwperson]["资质"] = value
end

--无酒不欢：判定是不是显示特技, 只在面板显示时用
function secondary_wugong(wugongid)
	--轻功
	if JY.Wugong[wugongid]["武功类型"] == 7 then
		return true
	--吸功，金刚不坏，五岳剑诀, 万剑归宗
	elseif wugongid == 85 or wugongid == 87 or wugongid == 88 or wugongid == 144 or wugongid == 175 or wugongid == 187 or wugongid == 171 then
		return true
	end
	return false
end

function thirdly_wugong(wugongid)
	--万剑归宗
	if wugongid == 198 or wugongid == 204 or wugongid == 223 then
       return true
	end
	return false
end

--无酒不欢：判定主运内功的函数
function Curr_NG(personid, NGid)
	if JY.Person[personid]["主运内功"] == NGid and PersonKF(personid, NGid) then
		return true
	elseif match_ID(personid, 631) and JY.Person[631]["阶"] >= 3 and NGid == 107 and PersonKF(personid, 107) then
		return true		
	elseif match_ID(personid, 626) and JY.Person[626]["阶"] >= 2 and NGid == 169 and PersonKF(personid, 169) then
		return true	
	elseif match_ID(personid, 161) and JY.Person[161]["阶"] >= 3 and NGid == 154 and PersonKF(personid, 154) then
		return true	
	elseif match_ID(personid, 149) and JY.Person[149]["阶"] >= 2 and NGid == 108 and PersonKF(personid, 108) then
		return true	
	elseif match_ID(personid, 129) and JY.Person[129]["阶"] >= 2 and NGid == 100 and PersonKF(personid, 100) then
		return true		
	elseif match_ID(personid, 118) and JY.Person[118]["阶"] >= 2 and NGid == 98 and PersonKF(personid, 98) then
		return true	
	elseif match_ID(personid, 117) and JY.Person[117]["阶"] >= 2 and NGid == 101 and PersonKF(personid, 101) then
		return true	
	elseif match_ID(personid, 116) and JY.Person[116]["阶"] >= 2 and NGid == 85 and PersonKF(personid, 85) then
		return true	
	elseif match_ID(personid, 103) and JY.Person[103]["阶"] >= 3 and NGid == 98 and PersonKF(personid, 98) then
		return true	
	elseif match_ID(personid, 85) and JY.Person[85]["阶"] >= 2 and NGid == 108 and PersonKF(personid, 108) then
		return true	
	elseif match_ID(personid, 66) and JY.Person[66]["阶"] >= 1 and NGid == 93 and PersonKF(personid, 93) then
		return true	
	elseif match_ID(personid, 65) and JY.Person[65]["阶"] >= 3 and NGid == 100 and PersonKF(personid, 100) then
		return true	
	elseif match_ID(personid, 64) and JY.Person[64]["阶"] >= 3 and NGid == 107 and PersonKF(personid, 107) then
		return true	
	elseif match_ID(personid, 55) and JY.Person[55]["阶"] >= 3 and NGid == 107 and PersonKF(personid, 107) then
		return true	
	elseif match_ID(personid, 53) and JY.Person[53]["阶"] >= 1 and NGid == 85 and PersonKF(personid, 85) then
		return true	
	elseif ((match_ID(personid, 46) and JY.Person[46]["阶"] >= 1) or (match_ID(personid, 47)and JY.Person[47]["阶"] >= 1)) and NGid == 87 and PersonKF(personid, 87) then
		return true	
	elseif match_ID(personid, 27) and JY.Person[27]["阶"] >= 2 and NGid == 105 and PersonKF(personid, 105) then
		return true		
	elseif match_ID(personid, 26) and JY.Person[26]["阶"] >= 1 and NGid == 88 and PersonKF(personid, 88) then
		return true	
	elseif match_ID(personid, 22) and JY.Person[22]["阶"] >= 1 and NGid == 207 and PersonKF(personid, 207) then
		return true	
	elseif match_ID(personid, 11) and JY.Person[11]["阶"] >= 2 and NGid == JY.Person[personid]["天赋内功"] and PersonKF(personid, JY.Person[personid]["天赋内功"]) then
		return true
	elseif match_ID(personid, 19) and JY.Person[19]["阶"] >= 2 and NGid == 89 and PersonKF(personid, 89) then
		return true	
	elseif match_ID(personid, 9) and JY.Person[9]["阶"] >= 2 and NGid == 97 and PersonKF(personid, 97) then
		return true
	elseif match_ID(personid, 9) and JY.Person[9]["阶"] >= 3 and NGid == 106 and PersonKF(personid, 106) then
		return true	
	elseif match_ID(personid, 638) and personid == 0 and (JY.Person[637]["声望"] >= 6 or PersonKF(personid, 106)) and NGid == 106 then
		return true	
	elseif match_ID(personid, 637) and personid == 0 and JY.Person[637]["声望"] >= 7 and NGid == 107 then
		return true	
	--九阴主运，逆运享受主运
	elseif JY.Person[personid]["主运内功"]==107 and NGid==104 and PersonKF(personid, 104) then
		return true
	--觉醒欧阳锋主运蛤蟆功
	elseif match_ID_awakened(personid, 60, 1) and NGid==95 and PersonKF(personid, 95) then
		return true
	elseif match_ID(personid, 687) and NGid==186 and PersonKF(personid, 186) then
		return true	
	--丁典，神照	
	elseif match_ID(personid, 672) and (JY.Person[672]["品德"] == 100 or JY.Person[672]["品德"] == 70) and PersonKF(personid, 94) and NGid==94 then
		return true	
	--丁典，神照	
	elseif match_ID(personid, 9) and PersonKF(personid, 97) and NGid==97 then
		return true	
	elseif match_ID(personid, 53) and PersonKF(personid, 85) and NGid==85 then
		return true	
	elseif JY.Person[personid]["主运内功"] > 0 and JY.Person[personid]["主运内功"] ~= 190 and (match_ID(personid, 682) and PersonKF(personid, NGid) and JY.Person[682]["天4"] == 1) then
		return true	
	--天罡的判定
	elseif personid == 0 and JY.Base["标准"] == 6 then
		--如果是天内，并且已经学会，则自动主运
		if (JY.Person[personid]["天赋内功"] == NGid and PersonKF(personid, NGid)) or (JY.Person[personid]["天赋内功"]==107 and NGid==104 and PersonKF(personid, 104)) then
			return true
		else
			return false
		end
	else
		return false
	end
end

--无酒不欢：判定主运轻功的函数
function Curr_QG(personid, QGid)
	if JY.Person[personid]["主运轻功"] == QGid and PersonKF(personid, QGid) then  --柯镇恶主运飞天神行
		return true
	elseif match_ID(personid, 161) and PersonKF(personid, 148) and JY.Person[1]["阶"] >= 2 and QGid == 148 then
		return true	
	elseif match_ID(personid, 130) and PersonKF(personid, QGid) and JY.Wugong[QGid]["武功类型"] == 7 then
	    return true
	elseif match_ID(personid, 637) and personid == 0 and JY.Person[637]["声望"] >= 7 and QGid == 181 then
		return true
	elseif match_ID(personid, 54) and PersonKF(personid, 146) and JY.Person[54]["阶"] >= 2 and QGid == 146 then
		return true	
	elseif match_ID(personid, 1) and PersonKF(personid, 145) and JY.Person[1]["阶"] >= 1 and QGid == 145 then
		return true	
	elseif match_ID(personid, 116) and PersonKF(personid, 147) and JY.Person[116]["阶"] >= 1 and QGid == 147 then
	    return true	
	else
		return false
	end
end

--无酒不欢：判定人物面板上极的个数
function calc_mas_num(id)
	local mas_num = 0;
	for i = 1, JY.Person[671]["品德"] do
		if JY.Person[id]["武功等级" .. i] == 999 then
			mas_num = mas_num + 1;
		end
	end
	return mas_num
end

--无酒不欢：判定是否为指定ID的人物，用作天赋等判定
function match_ID(personid, id)
	if personid == id then
		return true
	elseif personid == 0 and JY.Base["畅想"] == id then
		return true
	elseif (personid == 685 or (JY.Base["畅想"] == 685 and personid == 0)) and (JY.Person[685]["天1"] == id or JY.Person[685]["天2"] == id or JY.Person[685]["天3"] == id) then
	    return true	
	elseif personid == 642 and WAR.ZDDH == 327 and JY.Base["畅想"] == id then
	    return true
	elseif JY.Base["畅想"] == 692 and personid == 0 and JY.Status == GAME_WMAP and WAR.WCY[0] == 1 and id == 69 then
	    return true
	elseif JY.Base["畅想"] == 669 and personid == 0 then
	   for i = 1, 10 do
	       if JY.Person[669]["地"..i] == id then
		      return true
		   end
	   end
	   for i = 1, 4 do
	       if JY.Person[669]["天"..i] == id then
		      return true
		   end
	   end	
	else
		return false
	end
end

--无酒不欢：判定连击率
function Person_LJ(pid)
local yin, yang, tg = NeiL(pid)
local fx = yin + yang
	--根据内轻资质计算基础连击率
	local LJ1 = math.modf(JY.Person[pid]["轻功"] / 18)
	local LJ2 = math.modf((JY.Person[pid]["内力最大值"] + JY.Person[pid]["内力"]) / 1000)
	local LJ3 = math.modf(JY.Person[pid]["资质"] / 10)
	local LJ = 0
	LJ = (LJ1 + LJ2 + LJ3) / 2
	if LJ < 100 then
	--灭绝、裘千仞、洪教主、成昆、萧半和、戚长发、令狐冲二觉之后，连击率+70%
	if match_ID(pid, 6) or match_ID(pid, 67) or match_ID(pid, 71) or match_ID(pid, 18) or match_ID(pid, 594) or match_ID_awakened(pid, 35, 2) then
		LJ = LJ + (100 - LJ) * 0.7
	end

	--连击武功，每个连击+2.5%
	--百花，空明，玉女，泰山，鸳鸯，反两仪，杨家枪，海叟，银锁，连城，去烦恼，黑风, 素心
	local ljup = {10, 15, 42, 31, 54, 60, 68, 76, 79, 114, 124, 131, 139}
	for i = 1, JY.Person[671]["品德"] do
		if JY.Person[pid]["武功" .. i] > 0 then
			for ii = 1, #ljup do
				if JY.Person[pid]["武功" .. i] == ljup[ii] then
					LJ = LJ + (100 - LJ) * 0.025
				end
			end
		else
			break
		end
	end
	
	--指法主角，每个指法+5%
	if JY.Base["标准"] == 2 and pid == 0 then
		local lxyz = 0
		for i = 1, JY.Person[671]["品德"] do
			if JY.Wugong[JY.Person[0]["武功" .. i]]["武功类型"] == 2 and JY.Person[0]["武功等级" .. i] == 999 then
				lxyz = lxyz + 1
			end
		end
		if lxyz > 7 then
			lxyz = 7
		end
		LJ = LJ + (100 - LJ) * 0.05 * lxyz
	end	
	
	--独孤九剑连击+5%
	for i = 1, JY.Person[671]["品德"] do
		if JY.Person[pid]["武功" .. i] == 47 then
			LJ = LJ + (100 - LJ) * 0.05
		end
	end
	
	--论剑打赢林朝英奖励+50%
	if pid == 0 and JY.Person[605]["论剑奖励"] == 1 then
		LJ = LJ + (100 - LJ) * 0.5
	end
	
	--实战，每40点+1%
	local jp = JY.Person[pid]["实战"] / 4000
	LJ = LJ + (100 - LJ) * jp
	
	--主运九阴+50%
	if Curr_NG(pid, 107) then
		LJ = LJ + (100 - LJ) * 0.3
	end
	
	--主运易筋经
	if Curr_NG(pid, 108) then
		LJ = LJ + (100 - LJ) * 0.25
		if tg ~= 1 then
		   if fx < 0 then
		      LJ = LJ - fx
		   end
		else
		      LJ = LJ - yin
		end
	end
	
	--焦宛儿在场，全体加10%
	if inteam(pid) and JY.Status == GAME_WMAP then
		for wid = 0, WAR.PersonNum - 1 do
			if match_ID(WAR.Person[wid]["人物编号"], 607) and WAR.Person[wid]["死亡"] == false and WAR.Person[wid]["我方"] then
				LJ = LJ + 10
				break
			end
		end
	end
	
	--雷震
	if match_ID(pid, 670) then
	local df = JY.Person[pid]["耍刀技巧"]
	   if JY.Person[pid]["防具"] == 323 then
	      df = df + 20
	   elseif JY.Person[pid]["防具"] == 327 then
	      df = df + 40
	   end
	   if PersonKF(pid, 102) and JY.Status == GAME_WMAP then
	      df = df + df*0.4
	   end
	   df = df*0.2
	   LJ = LJ + df
	end
	--废资
	if pid == 0 and JY.Person[0]["资质"] > 50 and JY.Person[0]["资质"] < 80 then
	local add = 15
	   add = add + JY.Person[0]["六如觉醒"]*3
	   LJ = LJ + add
	end
	
	if JY.Person[246]["品德"] == 100 and pid == 0 then
	   LJ = LJ + 10
	end
	
	if match_ID(pid, 673) and JY.Person[673]["外号2"] == "烈" then
	   LJ = LJ + 30
	end
	
	--无名连击
	if match_ID(pid, 671) then
	local yj = JY.Person[pid]["御剑能力"]
	   yj = yj*0.02
	   LJ = LJ + yj
	end
	--聂风，暴击
    if match_ID(pid, 681) and JY.Person[681]["天2"] == 2 then
	local yj = JY.Person[pid]["耍刀技巧"]*0.1
		LJ = LJ + yj
    end
	
	if match_ID(pid, 678) and JY.Person[678]["天2"] == 1 then
	local yj = JY.Person[pid]["指法技巧"]
	   yj = yj*0.1
	   LJ = LJ + yj
	end
	
	if JY.Person[36]["天2"] == 1 then
	   if match_ID(pid, 36) or not inteam(pid) then
	   LJ = LJ + 60
	   end   
	end
	
	if match_ID(pid, 82) and JY.Person[82]["阶"] >= 3 then
       LJ = LJ + 30
    end
	
	if JY.Person[48]["天2"] == 1 then
	   if match_ID(pid, 48) or not inteam(pid) then
	   LJ = LJ + 40
	   end   
	end
	
	if JY.Person[91]["阶"] >= 3 and match_ID(pid, 91) then
	   LJ = LJ + 50
	end
	if JY.Person[151]["阶"] >= 2 and match_ID(pid, 151) then
	   LJ = LJ + 50
	end
	if match_ID(pid, 693) then
	   LJ = LJ + 50
	end
	
	if JY.Person[pid]["人34"] == 1 then
	   LJ = LJ + 9
	end
	if JY.Person[pid]["人17"] == 1 then
	   LJ = LJ + 10
	end
	if JY.Person[pid]["人7"] == 1 then
	   LJ = LJ + 10
	end
	if JY.Person[pid]["人4"] == 1 then
	   LJ = LJ + 5
	end

	--东方不败必连击
	if match_ID(pid, 27) then
		LJ = 100
	end
	
	--连击率下限1
    if LJ < 1 then
		LJ = 1
    end
	if JY.Person[pid]["地6"] == 6 then
	   LJ = LJ + 100
	end
	end
	if match_ID(pid, 683) and JY.Person[683]["天1"] == 1 then
	   LJ = LJ + 60
	end 
	if match_ID(pid, 689) and JY.Person[pid]["左右互搏"] == 1 then
	local l = 80 - JY.Person[pid]["资质"]
	if l < 0 then
	   l = 0
	end
	   LJ = LJ + l
	end   
	if LJ > 100 and match_ID(pid, 683)==false then
	   LJ = 100
	end	
	--取整
	LJ = math.modf(LJ)
	return LJ
end

--无酒不欢：判定暴击率
function Person_BJ(pid)
local yin, yang, tg = NeiL(pid)
local fx = yin + yang
    --根据内攻体力计算基础暴击率
    local BJ1 = math.modf(JY.Person[pid]["攻击力"] / 18)
    local BJ2 = math.modf((JY.Person[pid]["内力最大值"] + JY.Person[pid]["内力"]) / 1000)
    local BJ3 = math.modf(JY.Person[pid]["体力"] / 10)
    local BJ = 0
    BJ = (BJ1 + BJ2 + BJ3) / 2
    --血刀老祖、裘千仞、洪教主、任我行、玉真子、萧半和，暴击率+70%
    if match_ID(pid, 97) or match_ID(pid, 67) or match_ID(pid, 71) or match_ID(pid, 26) or match_ID(pid, 184) then
		BJ = BJ + (100 - BJ) * 0.7
    end

	--袁承志，暴击率+50%
    if match_ID(pid, 54) then
		BJ = BJ + (100 - BJ) * 0.5
    end
	
	
    --杨过，血量少于四分之一时，基础暴击率3倍
    if match_ID(pid, 58) and JY.Person[pid]["生命"] < JY.Person[pid]["生命最大值"] / 4 then
		BJ = BJ * 3
    --杨过，血量少于二分之一，基础暴击率2倍
    elseif match_ID(pid, 58) and JY.Person[pid]["生命"] < JY.Person[pid]["生命最大值"] / 2 then
		BJ = BJ * 2
    end
	
	--暴击武功，每个暴击+2.5%
	--弹指，大力，全真，金蛇，奇门三才，燃木，裴将军，黄沙，鹤蛇，金乌，玄冥，铁指诀，一阳指
    local bjup = {18, 22, 39, 40, 56, 65, 71, 78, 74, 61, 21, 121, 17}
    for i = 1, JY.Person[671]["品德"] do
		if JY.Person[pid]["武功" .. i] > 0 then
			for ii = 1, #bjup do
				if JY.Person[pid]["武功" .. i] == bjup[ii] then
					BJ = BJ + (100 - BJ) * 0.025
				end
			end
		else
			break;
		end
    end
	
	--实战，每40点+1%
	local jp = JY.Person[pid]["实战"] / 4000
	BJ = BJ + (100 - BJ) * jp
	
	--主运逆运+50%
	if Curr_NG(pid, 104) then
		BJ = BJ + (100 - BJ) * 0.5
	end
	
	--论剑打赢林朝英奖励+50%
	if pid == 0 and JY.Person[605]["论剑奖励"] == 1 then
		BJ = BJ + (100 - BJ) * 0.5
	end
	
	if Curr_NG(pid, 108) then
		BJ = BJ + (100 - BJ) * 0.25
		if tg ~= 1 then
		   if fx < 0 then
		      BJ = BJ - fx
		   end
		else
		      BJ = BJ - yin
		end
		    
	end
	
	--萧峰、灭绝必暴击
    if match_ID(pid, 50) or match_ID(pid, 6) then
		BJ = 100
    end
	
	if JY.Person[36]["天2"] == 1 then
	   if match_ID(pid, 36) or not inteam(pid) then
	   BJ = BJ + 40
	   end   
	end
	
	if JY.Person[48]["天2"] == 1 then
	   if match_ID(pid, 48) or not inteam(pid) then
	   BJ = BJ + 60
	   end   
	end
	
	--只有战斗中才有的加成
	if JY.Status == GAME_WMAP then
	    
		--欧阳锋 逆运状态下必暴击
		if match_ID(pid, 60) and WAR.tmp[1000+pid] == 1 then
			BJ = 100
		end
		if match_ID(pid, 14) and JY.Person[14]["阶"] >= 3 and JY.Person[pid]["生命"] < JY.Person[pid]["生命最大值"]*0.3 then
	       BJ = 100
	    end
		
		--怒气值100，非斗转下必暴击
		if WAR.LQZ[pid] == 100 and WAR.DZXY ~= 1 then
			BJ = 100
		end
	end
	
	--暴击率下限1
    if BJ < 1 then
		BJ = 1
    end
	
	if JY.Person[81]["阶"] >= 1 and match_ID(pid, 81) then
		BJ = BJ + JY.Person[81]["阶"]*10
	end
	
	--废资
	if pid == 0 and JY.Person[0]["资质"] > 50 and JY.Person[0]["资质"] < 80 then
	local add = 15
	   add = add + JY.Person[0]["六如觉醒"]*3
	   BJ = BJ + add
	end
	
	if match_ID(pid, 673) and JY.Person[673]["外号2"] == "怒" then
	   BJ = BJ + 30
	end
	
	if match_ID(pid, 677) and JY.Person[677]["天2"] == 1 then
	   BJ = BJ + 35
	end
	
	if JY.Person[246]["品德"] == 100 and pid == 0 then
	   BJ = BJ + 10
	end
	
	if JY.Person[91]["阶"] >= 3 and match_ID(pid, 91) then
	   BJ = BJ + 50
	end
	
	
	if JY.Person[pid]["人34"] == 1 then
	   BJ = BJ + 9
	end
	if JY.Person[pid]["人17"] == 1 then
	   BJ = BJ + 10
	end
	if JY.Person[pid]["人7"] == 1 then
	   BJ = BJ + 10
	end
	
	if JY.Person[pid]["人5"] == 1 then
	   BJ = BJ + 5
	end
	
	--无名，暴击
    if match_ID(pid, 671) then
	local yj = JY.Person[pid]["御剑能力"]*0.02
		BJ = BJ + yj
    end
	--聂风，暴击
    if match_ID(pid, 681) and JY.Person[681]["天2"] == 1 then
	local yj = JY.Person[pid]["耍刀技巧"]*0.1
		BJ = BJ + yj
    end
	--lxf暴击
    if match_ID(pid, 678) and JY.Person[678]["天2"] == 2 then
	local yj = JY.Person[pid]["指法技巧"]*0.1
		BJ = BJ + yj
    end
	
	if JY.Person[pid]["地4"] == 4 then
	   BJ = BJ + 10
	end
	
	if JY.Person[pid]["地2"] == 7 then
	   BJ = 100
	end
	if JY.Person[pid]["地6"] == 6 then
	   BJ = 100
	end
	if match_ID(pid, 683) and JY.Person[683]["天1"] == 2 then
	   BJ = BJ + 75
	end
	if match_ID(pid, 689) and JY.Person[pid]["出战"] == 1 then
	   BJ = BJ + math.max(JY.Person[pid]["资质"]-20,0)
	end
	if BJ > 100 then
		BJ = 100
    end
	
	--取整
	BJ = math.modf(BJ)
	
	return BJ
end

function ZhuJZ(pid)
local yin, yang, tg = NeiL(pid)
local fx = yin + yang
    --根据内攻体力计算基础暴击率
    local BJ1 = math.modf(JY.Person[pid]["攻击力"] / 18)
    local BJ2 = math.modf((JY.Person[pid]["内力最大值"] + JY.Person[pid]["内力"]) / 1000)
    local BJ3 = math.modf(JY.Person[pid]["体力"] / 10)
    local BJ = 0
    BJ = (BJ1 + BJ2 + BJ3) / 2
    --血刀老祖、裘千仞、洪教主、任我行、玉真子、萧半和，暴击率+70%
    if match_ID(pid, 97) or match_ID(pid, 67) or match_ID(pid, 71) or match_ID(pid, 26) or match_ID(pid, 184) then
		BJ = BJ + (100 - BJ) * 0.7
    end

	--袁承志，暴击率+50%
    if match_ID(pid, 54) then
		BJ = BJ + (100 - BJ) * 0.5
    end
	
	
    --杨过，血量少于四分之一时，基础暴击率3倍
    if match_ID(pid, 58) and JY.Person[pid]["生命"] < JY.Person[pid]["生命最大值"] / 4 then
		BJ = BJ * 3
    --杨过，血量少于二分之一，基础暴击率2倍
    elseif match_ID(pid, 58) and JY.Person[pid]["生命"] < JY.Person[pid]["生命最大值"] / 2 then
		BJ = BJ * 2
    end
	
	--暴击武功，每个暴击+2.5%
	--弹指，大力，全真，金蛇，奇门三才，燃木，裴将军，黄沙，鹤蛇，金乌，玄冥，铁指诀，一阳指
    local bjup = {18, 22, 39, 40, 56, 65, 71, 78, 74, 61, 21, 121, 17}
    for i = 1, JY.Person[671]["品德"] do
		if JY.Person[pid]["武功" .. i] > 0 then
			for ii = 1, #bjup do
				if JY.Person[pid]["武功" .. i] == bjup[ii] then
					BJ = BJ + (100 - BJ) * 0.025
				end
			end
		else
			break;
		end
    end
	
	--实战，每40点+1%
	local jp = JY.Person[pid]["实战"] / 4000
	BJ = BJ + (100 - BJ) * jp
	
	--主运逆运+50%
	if Curr_NG(pid, 104) then
		BJ = BJ + (100 - BJ) * 0.5
	end
	
	--论剑打赢林朝英奖励+50%
	if pid == 0 and JY.Person[605]["论剑奖励"] == 1 then
		BJ = BJ + (100 - BJ) * 0.5
	end
	
	if Curr_NG(pid, 108) then
		BJ = BJ + (100 - BJ) * 0.25
		if tg ~= 1 then
		   if fx < 0 then
		      BJ = BJ - fx
		   end
		else
		      BJ = BJ - yin
		end
		    
	end
	
	--萧峰、灭绝必暴击
    if match_ID(pid, 50) or match_ID(pid, 6) then
		BJ = 100
    end
	
	if JY.Person[36]["天2"] == 1 then
	   if match_ID(pid, 36) or not inteam(pid) then
	   BJ = BJ + 40
	   end   
	end
	
	if JY.Person[48]["天2"] == 1 then
	   if match_ID(pid, 48) or not inteam(pid) then
	   BJ = BJ + 60
	   end   
	end
	
	--只有战斗中才有的加成
	if JY.Status == GAME_WMAP then
	    
		--欧阳锋 逆运状态下必暴击
		if match_ID(pid, 60) and WAR.tmp[1000+pid] == 1 then
			BJ = 100
		end
		if match_ID(pid, 14) and JY.Person[14]["阶"] >= 3 and JY.Person[pid]["生命"] < JY.Person[pid]["生命最大值"]*0.3 then
	       BJ = 100
	    end
		
	end
	
	--暴击率下限1
    if BJ < 1 then
		BJ = 1
    end
	
	if JY.Person[81]["阶"] >= 1 and match_ID(pid, 81) then
		BJ = BJ + JY.Person[81]["阶"]*10
	end
	
	--废资
	if pid == 0 and JY.Person[0]["资质"] > 50 and JY.Person[0]["资质"] < 80 then
	local add = 15
	   add = add + JY.Person[0]["六如觉醒"]*3
	   BJ = BJ + add
	end
	
	if match_ID(pid, 673) and JY.Person[673]["外号2"] == "怒" then
	   BJ = BJ + 30
	end
	
	if match_ID(pid, 677) and JY.Person[677]["天2"] == 1 then
	   BJ = BJ + 35
	end
	
	if JY.Person[246]["品德"] == 100 and pid == 0 then
	   BJ = BJ + 10
	end
	
	if JY.Person[91]["阶"] >= 3 and match_ID(pid, 91) then
	   BJ = BJ + 50
	end
	
	
	if JY.Person[pid]["人34"] == 1 then
	   BJ = BJ + 9
	end
	if JY.Person[pid]["人17"] == 1 then
	   BJ = BJ + 10
	end
	if JY.Person[pid]["人7"] == 1 then
	   BJ = BJ + 10
	end
	
	if JY.Person[pid]["人5"] == 1 then
	   BJ = BJ + 5
	end
	
	--无名，暴击
    if match_ID(pid, 671) then
	local yj = JY.Person[pid]["御剑能力"]*0.02
		BJ = BJ + yj
    end
	--聂风，暴击
    if match_ID(pid, 681) and JY.Person[681]["天2"] == 1 then
	local yj = JY.Person[pid]["耍刀技巧"]*0.1
		BJ = BJ + yj
    end
	--lxf暴击
    if match_ID(pid, 678) and JY.Person[678]["天2"] == 2 then
	local yj = JY.Person[pid]["指法技巧"]*0.1
		BJ = BJ + yj
    end
	
	if JY.Person[pid]["地4"] == 4 then
	   BJ = BJ + 10
	end
	
	if JY.Person[pid]["地2"] == 7 then
	   BJ = 100
	end
	if JY.Person[pid]["地6"] == 6 then
	   BJ = 100
	end
	if match_ID(pid, 683) and JY.Person[683]["天1"] == 2 then
	   BJ = BJ + 75
	end
	if match_ID(pid, 689) and JY.Person[pid]["出战"] == 1 then
	   BJ = BJ + math.max(JY.Person[pid]["资质"]-20,0)
	end
	if BJ > 100 then
		BJ = 100
    end
	
	--取整
	BJ = math.modf(BJ)
	
	return BJ
end

--无酒不欢：返回人物所学内功的数量
function Num_of_Neigong(id)
	local num = 0
	for i = 1, JY.Person[671]["品德"] do
		local kfid = JY.Person[id]["武功"..i]
		if JY.Wugong[kfid]["武功类型"] == 6 then
			num = num + 1
		end
	end
	return num
end

--无酒不欢：判定一个人物是否满足五岳剑法的条件
function WuyueJF(id)
	local wuyuenum = 0;
	for i = 1, JY.Person[671]["品德"] do
		local kfid = JY.Person[id]["武功"..i]
		local klvl = JY.Person[id]["武功等级"..i]
		if kfid >= 30 and kfid <= 34 and klvl == 999 then
			wuyuenum = wuyuenum + 1
		end
	end
	if JY.Person[id]["防具"] == 352 and wuyuenum >= 2 then
	   wuyuenum = wuyuenum + 1
	end
	if JY.Person[id]["地8"] == 3 and wuyuenum >= 1 then
	   wuyuenum = wuyuenum + 2
	end
	if JY.Person[76]["阶"] >= 3 and match_ID(id, 76) then
	   wuyuenum = wuyuenum + 2
	end
	if wuyuenum >= 5 or (id>=19 and id<=23) or (id==0 and JY.Base["畅想"]>=19 and JY.Base["畅想"]<=23) then
		return true
	else
		return false
	end
end

--无酒不欢：真实拳掌能力的判定
function TrueQZ(id)
	local qz = JY.Person[id]["拳掌功夫"]
	if match_ID(id, 186) and JY.Person[186]["阶"] >= 2 then
	   qz = qz*2
	end
	--金丝手套
	if JY.Person[id]["武器"] == 239 then
		local add = 10
		if JY.Thing[239]["装备等级"] >= 5 then
			add = 30
		elseif JY.Thing[239]["装备等级"] >= 4 then
			add = 25
		elseif JY.Thing[239]["装备等级"] >= 3 then
			add = 20
		elseif JY.Thing[239]["装备等级"] >= 2 then
			add = 15
		end
		qz = qz + add
	end
	
	--天怒十方
	if JY.Person[id]["防具"] == 323 then
	   qz = qz + 20
	elseif JY.Person[id]["防具"] == 327 then
	   qz = qz + 40
	end
	--太玄，战场系数*140%
	if PersonKF(id, 102) and JY.Status == GAME_WMAP then
		qz = qz + math.modf(qz*0.4)
	end
	if JY.Base["周目"]>1 then
		qz=qz+(JY.Base["周目"]-1)*5
	end
	return qz
end

--无酒不欢：真实指法能力的判定
function TrueZF(id)
	local zf = JY.Person[id]["指法技巧"]
	--金丝手套
	if JY.Person[id]["武器"] == 239 then
		local add = 10
		if JY.Thing[239]["装备等级"] >= 5 then
			add = 30
		elseif JY.Thing[239]["装备等级"] >= 4 then
			add = 25
		elseif JY.Thing[239]["装备等级"] >= 3 then
			add = 20
		elseif JY.Thing[239]["装备等级"] >= 2 then
			add = 15
		end
		zf = zf + add
	end
	--天怒十方
	if JY.Person[id]["防具"] == 323 then
	   zf = zf + 20
	elseif JY.Person[id]["防具"] == 327 then
	   zf = zf + 40
	end
	--太玄，战场系数*140%
	if PersonKF(id, 102) and JY.Status == GAME_WMAP then
		zf = zf + math.modf(zf*0.4)
	end
	if JY.Base["周目"]>1 then
		zf=zf+(JY.Base["周目"]-1)*5
	end
	return zf
end

--无酒不欢：真实御剑能力的判定
function TrueYJ(id)
	local yj = JY.Person[id]["御剑能力"]
	--五岳剑法
	if WuyueJF(id) then
		yj = yj + 50
	end
	--战斗中的加成
	if JY.Status == GAME_WMAP then
		--剑胆琴心
		if WAR.JDYJ[id] then
			yj = yj + WAR.JDYJ[id]
		end
		--太玄，战场系数*140%
		if PersonKF(id, 102) then
			yj = yj + math.modf(yj*0.4)
		end
	end
	--天怒十方
	if JY.Person[id]["防具"] == 323 then
	   yj = yj + 20
	elseif JY.Person[id]["防具"] == 327 then
	   yj = yj + 40
	end
	if JY.Base["周目"]>1 then
		yj=yj+(JY.Base["周目"]-1)*5
	end
	if match_ID(id, 671) and JY.Status == GAME_WMAP and JY.Person[671]["阶"] >= 3 and WAR.WMJY[id] ~= nil then
	   yj = math.modf(yj * (1+WAR.WMJY[id]*0.01))
	end
	return yj
end

--无酒不欢：真实耍刀能力的判定
function TrueSD(id)
	local sd = JY.Person[id]["耍刀技巧"]
	--天怒十方
	if JY.Person[id]["防具"] == 323 then
	   sd = sd + 20
	elseif JY.Person[id]["防具"] == 327 then
	   sd = sd + 40
	end
	--太玄，战场系数*140%
	if PersonKF(id, 102) and JY.Status == GAME_WMAP then
		sd = sd + math.modf(sd*0.4)
	end
	if JY.Base["周目"]>1 then
		sd=sd+(JY.Base["周目"]-1)*5
	end
	return sd
end

--无酒不欢：真实特殊能力的判定
function TrueTS(id)
	local ts = JY.Person[id]["特殊兵器"]
	--天怒十方
	if JY.Person[id]["防具"] == 323 then
	   ts = ts + 20
	elseif JY.Person[id]["防具"] == 327 then
	   ts = ts + 40
	end
	--太玄，战场系数*140%
	if PersonKF(id, 102) and JY.Status == GAME_WMAP then
		ts = ts + math.modf(ts*0.4)
	end
	if JY.Base["周目"]>1 then
		ts=ts+(JY.Base["周目"]-1)*5
	end
	return ts
end

function BinghuoDL(id)
    local b = 0
    if PersonKF(id, 35) then
       b = b + 1
    end
	if PersonKF(id, 50) then
       b = b + 1
	end
	if PersonKF(id, 69) then
	   b = b + 1
	end   
    
	if JY.Person[id]["防具"] == 352 and b >= 2 then
	   b = b + 1
	end
	if JY.Person[id]["地8"] == 3 and b >= 1 then
	   b = b + 2
	end
	if JY.Person[76]["阶"] >= 3 and match_ID(id, 76) then
	   b = b + 2
	end
	
	if b >= 3 then
		return true
	else
		return false
	end
end	

--无酒不欢：判定一个人物是否满足琴棋书画的条件
function QinqiSH(id)
	local qinqinum = 0;
	for i = 1, JY.Person[671]["品德"] do
		local kfid = JY.Person[id]["武功"..i]
		local klvl = JY.Person[id]["武功等级"..i]
		if (kfid == 73 or kfid == 72 or kfid == 84 or kfid == 142) and klvl == 999 then
			qinqinum = qinqinum + 1
		end
	end
	if JY.Person[id]["防具"] == 352 and qinqinum >= 2 then
	   qinqinum = qinqinum + 1
	end
	if JY.Person[id]["地8"] == 3 and qinqinum >= 1 then
	   qinqinum = qinqinum + 2
	end
	if JY.Person[76]["阶"] >= 3 and match_ID(id, 76) then
	   qinqinum = qinqinum + 2
	end
	if qinqinum >= 4 then
		return true
	else
		return false
	end
end

function SANQIANGPAIAN(id)
	local sanqiangnum = 0;
	for i = 1, JY.Person[671]["品德"] do
		local kfid = JY.Person[id]["武功"..i]
		local klvl = JY.Person[id]["武功等级"..i]
		if (kfid == 68 or kfid == 70 or kfid == 165) and klvl == 999 then
			sanqiangnum = sanqiangnum + 1
		end
	end
	if sanqiangnum >= 1 then
		return true
	else
		return false
	end
end

function SANQIANGPAIANSL(id)
	local sqnum = 0;
	for i = 1, JY.Person[671]["品德"] do
		local kfid = JY.Person[id]["武功"..i]
		local klvl = JY.Person[id]["武功等级"..i]
		if (kfid == 68 or kfid == 70 or kfid == 165) and klvl == 999 then
			sqnum = sqnum + 1
		end
	end
	if JY.Person[id]["防具"] == 352 and sqnum >= 2 then
	   sqnum = sqnum + 1
	end
	if JY.Person[id]["地8"] == 3 and sqnum >= 1 then
	   sqnum = sqnum + 2
	end
	if JY.Person[76]["阶"] >= 3 and match_ID(id, 76) then
	   sqnum = sqnum + 2
	end
	return sqnum
end

--随风飘叶 调整队友顺序
function Menu_TZDY()
   local menu = {}
   local px={}
   local m=0
   --队友超过2人才会生效
   if JY.Base["队伍" .. 3]>0 then
		Cls()
		DrawStrBox(CC.MainMenuX,CC.MainSubMenuY,"需要调整谁的位置",LimeGreen,CC.DefaultFont,C_GOLD);
		local nexty=CC.MainSubMenuY+CC.SingleLineHeight;
		for i=1,CC.TeamNum do
			menu[i]={"",nil,0};
			local id=JY.Base["队伍" .. i]
			if id>0 then
				menu[i]={"",nil,0};
				if JY.Person[id]["生命"]>0 then
					menu[i][1]=JY.Person[id]["姓名"];
					menu[i][3]=1;
				end
			end
		end  
   
		local r = -1;
		while true do
			r = ShowMenu(menu,#menu,0,CC.MainMenuX,CC.MainSubMenuY+CC.SingleLineHeight,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE)
			if px["交换人"]==nil and r>1 then
				px["交换人"]=r
				menu[r]={"",nil,0}
				Cls()
				DrawStrBox(CC.MainMenuX,CC.MainSubMenuY,JY.Person[JY.Base["队伍" .. r]]["姓名"].."和谁交换位置",LimeGreen,CC.DefaultFont,C_GOLD);
			elseif r>1 and px["交换人"]~=nil and r ~=px["交换人"] then	
				local m1=JY.Base["队伍" .. r]
				local m2=JY.Base["队伍" .. px["交换人"]]
				JY.Base["队伍" .. r]=m2
				JY.Base["队伍" .. px["交换人"]]=m1
				say("Ｇ"..JY.Person[m2]["姓名"].."Ｗ 和 Ｇ"..JY.Person[m1]["姓名"].."Ｗ 交换了位置。",JY.Person[m2]["头像代号"],1,JY.Person[m2]["姓名"])
				Cls()
				--return
				break
			--无酒不欢：增加ESC退出功能
			else
				break
			end
		end
	end
end

--队友切磋
function Menu_DYQC()	
local nexty = CC.ScreenH/2-CC.DefaultFont*11.2 + CC.SingleLineHeight
local menu = {{"亲自上阵", nil, 1},{"看戏模式", nil, 1}}
local T_Num = GetTeamNum()
for i = 1, 20 do
JY.Person[220+i]["声望"] = 0
JY.Person[250+i]["声望"] = 0
end
if T_Num < 3 then
menu[2][3] = 2
end
local lx = ShowMenu2(menu, #menu, 1, 2, CC.ScreenW/2-CC.DefaultFont*10-145, nexty, 0, 0, 1, 0, CC.DefaultFont, C_ORANGE, C_WHITE)
if lx == 1 then ----------------------------------------------------主角单挑
local p = {{name="取消", picked=0, nil, alr = false}}
   for i = 2, T_Num do
    p[i] = {name=JY.Person[JY.Base["队伍"..i]]["姓名"], picked=0, pid=JY.Base["队伍"..i], alr = false}
   end
    p[T_Num+1]={name="开始战斗", picked=0, nil, alr = false}
   
    local size = CC.DefaultFont
	local surid = lib.SaveSur(0, 0, CC.ScreenW, CC.ScreenH)
	local choice = 1
    while true do
		if JY.Restart == 1 then
			break
		end
		Cls()
		for i = 1, #p do
			lib.LoadPNG(1, 997 * 2 , 210, 1+i*40, 1)
			local color = M_Gray
			if i == 1 or i == #p then
			   color = M_RoyalBlue
			end
			if p[i].alr==true then
				color = C_WHITE
				if i == choice then
					DrawString(380, 3+i*40, "√", C_RED, size)
				end
			end
			if i == choice then
				color = C_GOLD
			end
			if i > 1 and i < #p then
			DrawString(220, 3+i*40, i, color, size*0.8)
			end
			DrawString(251, 3+i*40, p[i].name, color, size*0.9)
		end
		
		--lib.LoadPNG(1, 996 * 2 , 480, 500, 1)
		ShowScreen()
		local keyPress, ktype, mx, my = lib.GetKey()
		lib.Delay(CC.Frame)
		
		if keyPress==VK_SPACE or keyPress==VK_RETURN then
		    if choice > 1 and choice < T_Num+1 then
			   if p[choice].alr == true then
			   p[choice].alr = false
			   elseif p[choice].alr == false then
			   p[choice].alr = true
			   end
			end
			local c = 0
			for i = 2, T_Num do
			    if p[i].alr == true then
				   c = c + 1 
				end 
				if p[i].alr == true then -- 五毒弟子声望
		           JY.Person[219+i]["声望"] = p[i].pid
				elseif p[i].alr == false then  
 				   JY.Person[219+i]["声望"] = 0
		        end
			end
			if choice == T_Num+1 and c > 0 then
			    if choice == T_Num+1 then
		          if WarMain(329, 0) == false then
		          say("好功夫!", 0, 1)
	              Cls()
		          do return end
	              end
				  for i = 1, 20 do
                      JY.Person[220+i]["声望"] = 0
                  end
		        end
				break
			end
			if choice == 1 then
			   for i = 1, 20 do
                  JY.Person[220+i]["声望"] = 0
               end
			   break
			end
		elseif keyPress == VK_UP then
			choice = choice - 1
			if choice < 1 then
				choice = #p
			end
		elseif keyPress == VK_DOWN then
			choice = choice + 1
			if choice > #p then
				choice = 1
			end
		end	   
	end
elseif lx == 2 then ------------------------------------群架

local p = {{name="取消", picked=0, nil, alr = false}}
local p2 = {{name="开始战斗", picked=0, nil, alr = false}}
   for i = 2, T_Num do
    p[i] = {name=JY.Person[JY.Base["队伍"..i]]["姓名"], picked=0, pid=JY.Base["队伍"..i], alr = false}
	p2[i] = {name=JY.Person[JY.Base["队伍"..i]]["姓名"], picked=0, pid=JY.Base["队伍"..i], alr = false}
   end
    
   
    local size = CC.DefaultFont
	local surid = lib.SaveSur(0, 0, CC.ScreenW, CC.ScreenH)
	local choice = 1
    while true do
		if JY.Restart == 1 then
			break
		end
		Cls()
		for i = 1, #p do
			lib.LoadPNG(1, 997 * 2 , 110, 1+i*40, 1)
			local color = M_Gray
			if i == 1 then
			   color = M_RoyalBlue
			end
			if p[i].alr==true then
				color = C_RED
				if i == choice then
					DrawString(280, 3+i*40, "√", C_RED, size)
				end
			end
			if i == choice then
				color = C_GOLD
			end
			if i > 1 then
			DrawString(120, 3+i*40, i-1, color, size*0.8)
			end
			DrawString(151, 3+i*40, p[i].name, color, size*0.9)
		end
		lib.LoadPNG(1, 1008 * 2 , 415, 210, 1)
		DrawString(431, 230, "点", C_WHITE, size*2)
		DrawString(431, 290, "到", C_WHITE, size*2)
		DrawString(431, 350, "即", C_WHITE, size*2)
		DrawString(431, 410, "止", C_WHITE, size*2)
		for i = 1+#p, #p*2 do
		    local t = i-#p
			lib.LoadPNG(1, 997 * 2 , 610, 1+t*40, 1)
			local color = M_Gray
			if i == #p + 1 then
			   color = M_RoyalBlue
			end
			if p2[t].alr==true then
				color = C_RED
				if i == choice then
					DrawString(780, 3+t*40, "√", C_RED, size)
				end
			end
			if i == choice then
				color = C_GOLD
			end
			if t > 1 then
			DrawString(620, 3+t*40, t-1, color, size*0.8)
			end
			DrawString(651, 3+t*40, p2[t].name, color, size*0.9)
		end
		
		ShowScreen()
		local keyPress, ktype, mx, my = lib.GetKey()
		lib.Delay(CC.Frame)
		
		if keyPress==VK_SPACE or keyPress==VK_RETURN then
		    if choice > 1 and choice <= #p then
			   if p[choice].alr == true then
			   p[choice].alr = false
			   elseif p[choice].alr == false then
			   p[choice].alr = true
			   p2[choice].alr = false
			   end
			end
			if choice > 1+#p and choice <= #p*2 then
			   if p2[choice-#p].alr == true then
			   p2[choice-#p].alr = false
			   elseif p2[choice-#p].alr == false then
			   p2[choice-#p].alr = true
			   p[choice-#p].alr = false
			   end
			end
			---确定角色
			local c = 0
			local v = 0
			for i = 2, #p do
			    if p[i].alr == true then
				   c = c + 1 
				end 
				if p[i].alr == true then -- 五毒弟子声望
		           JY.Person[219+i]["声望"] = p[i].pid
				elseif p[i].alr == false then  
 				   JY.Person[219+i]["声望"] = 0
		        end
			end
			for i = #p+2, #p*2 do
			local t = i-#p
			    if p2[t].alr == true then
				   v = v + 1 
				end 
				if p2[t].alr == true then -- 番僧声望
		           JY.Person[249+t]["声望"] = p2[t].pid
				elseif p2[t].alr == false then  
 				   JY.Person[249+t]["声望"] = 0
		        end
			end
			--战斗事件
			if choice == #p+1 and c > 0 and v < 7 and v > 0 then
			    if choice == #p+1 then
		          if WarMain(329, 0) == false then
		          say("精彩!", 0, 1)
	              Cls()
		          do return end
	              end
				  say("精彩!", 0, 1)
	              Cls()
				  for i = 1, 20 do
                      JY.Person[220+i]["声望"] = 0
					  JY.Person[250+i]["声望"] = 0
                  end
		        end
				break
			end
			if choice == 1 then
			   for i = 1, 20 do
                  JY.Person[220+i]["声望"] = 0
				  JY.Person[250+i]["声望"] = 0
               end
			   break
			end
		elseif keyPress == VK_RIGHT and choice <= #p then
			choice = choice + #p
		elseif keyPress == VK_LEFT and choice > #p then
			choice = choice - #p
		elseif keyPress == VK_UP then
			
			if choice == #p + 1 then
				choice = #p*2
			elseif choice == 1 then
				choice = #p
			else
			    choice = choice - 1
			end
		elseif keyPress == VK_DOWN then
			choice = choice + 1
			if choice == #p+1 then
				choice = 1
			end
			if choice > #p*2 then
				choice = 1+#p
			end
		end	   
	end
end	
	

end--end
--kael

function Menu_LHDY()
local menu = {{"放弃", nil, 1, nil}}
for i = 2, GetTeamNum() do
    menu[i] = {JY.Person[JY.Base["队伍"..i]]["姓名"], nil, 1, JY.Base["队伍"..i]}
end
if (JY.Person[0]["实战"] < 250 or JY.Base["天书数量"] < 6) and JY.Person[685]["天1"] > 0 then
   for i = 2, #menu do
       menu[i][3] = 3
   end
end
for i = 2, #menu do
    if (JY.Person[685]["天2"] == menu[i][4] or JY.Person[685]["天1"] == menu[i][4]) then
       menu[i][3] = 2
	end   
end

---------------------------------12
local nexty = CC.ScreenH/2-CC.DefaultFont*11.2 + CC.SingleLineHeight

if JY.Person[685]["天1"] > 0 and JY.Person[685]["天2"] > 0 then--------------3
menu = {{"放弃", nil, 1, nil}}
for i = 1, 692 do
    menu[i+1] = {JY.Person[i]["姓名"], nil, 1, i}	
end
for i = 2, #menu do
    if JY.Person[685]["天2"] == menu[i][4] or JY.Person[685]["天1"] == menu[i][4] or JY.Person[menu[i][4]]["畅想分阶"] == 0 or menu[i][4] == 685 then
       menu[i][3] = 2
	end
end
if (JY.Person[0]["实战"] < 500 or JY.Base["天书数量"] < 12) and JY.Person[685]["天2"] > 0 then
   for i = 2, #menu do
       if menu[i][3] ~= 2 then
          menu[i][3] = 3
	   end
   end
end
if JY.Person[685]["天3"] > 0 then
   for i = 2, #menu do
       menu[i][3] = 2
   end
end
local lh = ShowMenu2(menu, #menu, 7, 10, CC.ScreenW/2-CC.DefaultFont*10-145, nexty, 0, 0, 1, 0, CC.DefaultFont, C_ORANGE, C_RED, "请选择要炼化的角色")
    if lh > 1 then
	   JY.Person[685]["天3"] = menu[lh][4]
	   if JY.Person[685]["阶"] >= 2 then
	   JY.Person[menu[lh][4]]["阶"] = JY.Person[685]["阶"]
	   end
	   DrawStrBoxWaitKey("左慈吸收"..JY.Person[menu[lh][4]]["姓名"], C_RED, CC.DefaultFont)
	   if menu[lh][4] == 673 then
	   local wh = JYMsgBox("请选择天赋类型", "I怒火冲天：*指令状态提高爆发伤害能力*II炽烈爆发：*指令状态提高连续进攻能力",{"怒火冲天","炽烈爆发"},2,410)
	      if wh == 1 then
		     JY.Person[673]["外号2"] = "怒"
		  else	 
		     JY.Person[673]["外号2"] = "烈"
          end
		  JY.Person[673]["声望"] = 1
	   end
	end

else
local lh = ShowMenu2(menu, #menu, 1, 10, CC.ScreenW/2-CC.DefaultFont*10-145, nexty, 0, 0, 1, 0, CC.DefaultFont, C_ORANGE, C_RED, "请选择要炼化的角色")
    if lh > 1 then
	   if JY.Person[685]["天1"] == 0 then
	      JY.Person[685]["天1"] = menu[lh][4]
		  if JY.Person[685]["阶"] >= 2 then
		  JY.Person[menu[lh][4]]["阶"] = JY.Person[685]["阶"]
		  end
		  DrawStrBoxWaitKey("左慈吸收"..JY.Person[menu[lh][4]]["姓名"], C_RED, CC.DefaultFont)
	   elseif JY.Person[685]["天2"] == 0 then
	      JY.Person[685]["天2"] = menu[lh][4]
		  if JY.Person[685]["阶"] >= 2 then
		  JY.Person[menu[lh][4]]["阶"] = JY.Person[685]["阶"]
		  end
		  DrawStrBoxWaitKey("左慈吸收"..JY.Person[menu[lh][4]]["姓名"], C_RED, CC.DefaultFont)
	   end
	   local str = {"拳掌功夫", "指法技巧", "御剑能力", "耍刀技巧", "特殊兵器", "防御力", "轻功", "攻击力","生命","生命最大值","内力","内力最大值","暗器技巧"}
	   for i = 1, #str do
	      JY.Person[menu[lh][4]][str[i]] = 1	  
	   end
	   JY.Person[menu[lh][4]]["等级"] = 30
	   instruct_37(-30)
	end

end



end

--无酒不欢：画一条线
function DrawSingleLine(x1, y1, x2, y2, color)
	lib.DrawRect(x1 + 1, y1 + 1, x2, y2, color)
	lib.DrawRect(x1, y1, x2 - 1, y2 - 1, color)
end

--改变天外
function SetTianWai(personid, x, wugongid)
	local xwperson;	--判定要洗天外的人
	if personid == JY.Base["畅想"] then
		xwperson = 0
	else
		xwperson = personid
	end	
	JY.Person[xwperson]["天赋外功"..x] = wugongid
end

--改变天内
function SetTianNei(personid, wugongid)
	local xwperson;	--判定要洗天内的人
	if personid == JY.Base["畅想"] then
		xwperson = 0
	else
		xwperson = personid
	end	
	JY.Person[xwperson]["天赋内功"] = wugongid
end

--改变天轻
function SetTianQing(personid, wugongid)
	local xwperson;	--判定要洗天轻的人
	if personid == JY.Base["畅想"] then
		xwperson = 0
	else
		xwperson = personid
	end	
	JY.Person[xwperson]["天赋轻功"] = wugongid
end

--学会互搏
function SetHuBo(personid)
	local xwperson;
	if personid == JY.Base["畅想"] then
		xwperson = 0
	else
		xwperson = personid
	end	
	JY.Person[xwperson]["左右互搏"] = 1
end

--无酒不欢：判定一个人物是否满足桃花绝技的条件
function TaohuaJJ(id)
	--郭襄自动满足
	if match_ID(id, 626) then
		return true
	end
	local taohuanum = 0;
	for i = 1, JY.Person[671]["品德"] do
		local kfid = JY.Person[id]["武功"..i]
		local klvl = JY.Person[id]["武功等级"..i]
		if (kfid == 12 or kfid == 18 or kfid == 38) and klvl == 999 then
			taohuanum = taohuanum + 1
		end
	end
	if JY.Person[id]["防具"] == 352 and taohuanum >= 2 then
	   taohuanum = taohuanum + 1
	end
	if JY.Person[id]["地8"] == 3 and taohuanum >= 1 then
	   taohuanum = taohuanum + 2
	end
	if JY.Person[76]["阶"] >= 3 and match_ID(id, 76) then
	   taohuanum = taohuanum + 2
	end
	if taohuanum >= 3 then
		return true
	else
		return false
	end
end

--计算人物五系兵器值之和
function Xishu_sum(id)
	local sum = 0
	sum = sum + TrueQZ(id)
	sum = sum + TrueZF(id)
	sum = sum + TrueYJ(id)
	sum = sum + TrueSD(id)
	sum = sum + TrueTS(id)
	return sum
end

--求人物五系兵器值最高的一项
function Xishu_max(id)
	local m = 0
	local xishu = {TrueQZ,TrueZF,TrueYJ,TrueSD,TrueTS}
	for i = 1, #xishu do
		local x = xishu[i](id)
		if x > m then
			m = x
		end
	end
	return m
end

--剪裁版背景图
function Clipped_BgImg(x1,y1,x2,y2,picnum)
	lib.SetClip(x1 + 2, y1 + 2, x2 - 1, y2 - 1)
	lib.LoadPNG(1, picnum * 2 , 0 , 0, 1)
	lib.SetClip(0,0,0,0)
end

--显示带边框的文字
function DrawBoxTitle(width, height, str, color)
	local s = 4
	local x1, y1, x2, y2, tx1, tx2 = nil, nil, nil, nil, nil, nil
	local fontsize = s + CC.DefaultFont
	local len = string.len(str) * fontsize / 2
	x1 = (CC.ScreenW - width) / 2
	x2 = (CC.ScreenW + width) / 2
	y1 = (CC.ScreenH - height) / 2
	y2 = (CC.ScreenH + height) / 2
	tx1 = (CC.ScreenW - len) / 2
	tx2 = (CC.ScreenW + len) / 2
	lib.Background(x1, y1 + s, x1 + s, y2 - s, 128)
	lib.Background(x1 + s, y1, x2 - s, y2, 128)
	lib.Background(x2 - s, y1 + s, x2, y2 - s, 128)
	lib.Background(tx1, y1 - fontsize / 2 + s, tx2, y1, 128)
	lib.Background(tx1 + s, y1 - fontsize / 2, tx2 - s, y1 - fontsize / 2 + s, 128)
	local r, g, b = GetRGB(color)
	DrawBoxTitle_sub(x1 + 1, y1 + 1, x2, y2, tx1 + 1, y1 - fontsize / 2 + 1, tx2, y1 + fontsize / 2, RGB(math.modf(r / 2), math.modf(g / 2), math.modf(b / 2)))
	DrawBoxTitle_sub(x1, y1, x2 - 1, y2 - 1, tx1, y1 - fontsize / 2, tx2 - 1, y1 + fontsize / 2 - 1, color)
	DrawString(tx1 + 2 * s, y1 - (fontsize - s) / 2, str, color, CC.DefaultFont)
end

--无酒不欢：判定一个人物是否满足除却四相的条件
--同时修炼多罗叶指/大智无定指/无相劫指/拈花指到极
function ChuQueSX(id)
	local sixiangnum = 0;
	for i = 1, JY.Person[671]["品德"] do
		local kfid = JY.Person[id]["武功"..i]
		local klvl = JY.Person[id]["武功等级"..i]
		if (kfid == 132 or kfid == 133 or kfid == 136 or kfid == 137) and klvl == 999 then
			sixiangnum = sixiangnum + 1
		end
	end
	if JY.Person[id]["防具"] == 352 and sixiangnum >= 2 then
	   sixiangnum = sixiangnum + 1
	end
	if JY.Person[id]["地8"] == 3 and sixiangnum >= 1 then
	   sixiangnum = sixiangnum + 2
	end
	if JY.Person[76]["阶"] >= 3 and match_ID(id, 76) then
	   sixiangnum = sixiangnum + 2
	end
	if sixiangnum >= 2 then
	return sixiangnum
	end
end

--绘制一片四角凹进的背景
function DrawShades(x1,y1,x2,y2,color)
	local s=4;
	lib.Background(x1+4,y1,x2-4,y1+s,128,color);
	lib.Background(x1+1,y1+1,x1+s,y1+s,128,color);
	lib.Background(x2-s,y1+1,x2-1,y1+s,128,color);
	lib.Background(x1,y1+4,x2,y2-4,128,color);
	lib.Background(x1+1,y2-s,x1+s,y2-1,128,color);
	lib.Background(x2-s,y2-s,x2-1,y2-1,128,color);
	lib.Background(x1+4,y2-s,x2-4,y2,128,color);
end

--物品详细说明
function detailed_info(thingID)
	local str=JY.Thing[thingID]["代号"] .. JY.Thing[thingID]["名称"]
	local str2=JY.Thing[thingID]["物品说明"]
	local str3=JY.Thing[thingID]["名称"]
	local infoFile = CC.ItemInfoPath .. str .. ".lua"
	if existFile(infoFile) then
		dofile(infoFile)
	else
		return
	end
	local info = {}
	info = ItemInfo[thingID]
	local function strcolor_switch(s)
		local Color_Switch={{"Ｒ",PinkRed},{"Ｇ",C_GOLD},{"Ｂ",C_BLACK},{"Ｗ",C_WHITE},{"Ｏ",C_ORANGE},{"Ｌ",LimeGreen},{"Ｄ",M_DeepSkyBlue},{"Ｚ",Violet}}
		for i = 1, 8 do
			if Color_Switch[i][1] == s then
				return Color_Switch[i][2]
			end
		end
	end
	local maxRowExisting = #info		--当前说明总行数
	local maxRowDisplayable = 11		--当面页面可以显示的最大行数
	if maxRowDisplayable > maxRowExisting-1 then
		maxRowDisplayable = maxRowExisting-1
	end
	local startingRow = 1
	local size = CC.Fontsmall
	while true do
		if JY.Restart == 1 then
			break
		end
		Cls()
		lib.LoadPNG(1, 1004 * 2 , 0 , 0, 1)
		DrawString(2,14.5,str3,C_GOLD,CC.ThingFontSize)
		DrawString(2,54.5,str2,C_ORANGE,CC.ThingFontSize)
		local row = 1
		for i = startingRow, startingRow+maxRowDisplayable do
			local tfstr = info[i]
			if string.sub(tfstr,1,2) == "Ｎ" then
				row = row + 1
			else
				local color;
				color = strcolor_switch(string.sub(tfstr,1,2))
				tfstr = string.sub(tfstr,3,-1)
				DrawString(15, 80 + (size+CC.RowPixel*2) * (row), tfstr, color, size)
				row = row + 1
			end
		end
		--上下翻的箭头显示
		if startingRow > 1 then
			DrawString(CC.ScreenW-40, 110, "↑", C_GOLD, size)
		end
		if startingRow+maxRowDisplayable < maxRowExisting then
			DrawString(CC.ScreenW-40, CC.ScreenH-140, "↓", C_GOLD, size)
		end
		DrawString(CC.ScreenW-220,CC.ScreenH-40, "按F1返回物品菜单", C_ORANGE,size)
		ShowScreen()
		local keypress, ktype, mx, my = WaitKey(1)
		if keypress==VK_ESCAPE or keypress==VK_RETURN or keypress==VK_F1 or ktype == 4 then
			return
		elseif keypress==VK_UP and startingRow > 1 then
			startingRow = startingRow - 1
		elseif keypress==VK_DOWN and startingRow+maxRowDisplayable < maxRowExisting then
			startingRow = startingRow + 1
		end
	end
end

--无酒不欢：判定一个人物是否满足紫气天罗的条件
function ZiqiTL(id)
	local ziqinum = 0;
	for i = 1, JY.Person[671]["品德"] do
		local kfid = JY.Person[id]["武功"..i]
		local klvl = JY.Person[id]["武功等级"..i]
		if (kfid == 3 or kfid == 9 or kfid == 5 or kfid == 21 or kfid == 118 or kfid == 120 or kfid == 170) and klvl == 999 then
			ziqinum = ziqinum + 1
		end
	end
	if JY.Person[id]["动物"] == 351 then
	   ziqinum = ziqinum + 1
	end
	if JY.Person[id]["防具"] == 352 and ziqinum >= 2 then
	   ziqinum = ziqinum + 1
	end
	if JY.Person[id]["地8"] == 3 and ziqinum >= 1 then
	   ziqinum = ziqinum + 2
	end
	if JY.Person[76]["阶"] >= 3 and match_ID(id, 76) then
	   ziqinum = ziqinum + 2
	end
	if ziqinum >= 5 or (match_ID(id, 46) and JY.Person[642]["血量翻倍"] == 1) or id==46 then
		return true
	else
		return false
	end
end

--盖世无双
function GaiSWS(id)
local g = 0
    for i = 1, JY.Person[671]["品德"] do
    local kfid = JY.Person[id]["武功"..i]
	local klvl = JY.Person[id]["武功等级"..i]
	if (kfid == 26 or kfid == 80) and klvl == 999 then
		g = g + 1
	end
	end
	
	if JY.Person[id]["地8"] == 3 and g >= 1 then
	   g = g + 2
	end
	if JY.Person[76]["阶"] >= 3 and match_ID(id, 76) then
	   g = g + 2
	end
	if g >= 2 then
		return true
	else
		return false
	end
end
--太极
function TaiJi(id)
local g = 0
    for i = 1, JY.Person[671]["品德"] do
    local kfid = JY.Person[id]["武功"..i]
	local klvl = JY.Person[id]["武功等级"..i]
	if (kfid == 16 or kfid == 46) and klvl == 999 then
		g = g + 1
	end
	end
	
	if JY.Person[id]["地8"] == 3 and g >= 1 then
	   g = g + 2
	end
	if JY.Person[76]["阶"] >= 3 and match_ID(id, 76) then
	   g = g + 2
	end
	if g >= 2 then
		return true
	else
		return false
	end
end
--龙蛇
function LongShe(id)
local g = 0
    for i = 1, JY.Person[671]["品德"] do
    local kfid = JY.Person[id]["武功"..i]
	local klvl = JY.Person[id]["武功等级"..i]
	if (kfid == 20 or kfid == 81) and klvl == 999 then
		g = g + 1
	end
	end
	
	if JY.Person[id]["地8"] == 3 and g >= 1 then
	   g = g + 2
	end
	if JY.Person[76]["阶"] >= 3 and match_ID(id, 76) then
	   g = g + 2
	end
	if g >= 2 then
		return true
	else
		return false
	end
end
--太极
function TaiKong(id)
local g = 0
    for i = 1, JY.Person[671]["品德"] do
    local kfid = JY.Person[id]["武功"..i]
	local klvl = JY.Person[id]["武功等级"..i]
	if (kfid == 15 or kfid == 16) and klvl == 999 then
		g = g + 1
	end
	end
	
	if JY.Person[id]["地8"] == 3 and g >= 1 then
	   g = g + 2
	end
	if JY.Person[76]["阶"] >= 3 and match_ID(id, 76) then
	   g = g + 2
	end
	if g >= 2 then
		return true
	else
		return false
	end
end
--我佛慈悲
function WoFo(id)
local g = 0
    for i = 1, JY.Person[671]["品德"] do
    local kfid = JY.Person[id]["武功"..i]
	local klvl = JY.Person[id]["武功等级"..i]
	if (kfid == 122 or kfid == 57) and klvl == 999 then
		g = g + 1
	end
	end
	
	if JY.Person[id]["地8"] == 3 and g >= 1 then
	   g = g + 2
	end
	if JY.Person[76]["阶"] >= 3 and match_ID(id, 76) then
	   g = g + 2
	end
	if g >= 2 then
		return true
	else
		return false
	end
end
--两仪
function LiangYi(id)
local g = 0
    for i = 1, JY.Person[671]["品德"] do
    local kfid = JY.Person[id]["武功"..i]
	local klvl = JY.Person[id]["武功等级"..i]
	if (kfid == 37 or kfid == 60) and klvl == 999 then
		g = g + 1
	end
	end
	
	if JY.Person[id]["地8"] == 3 and g >= 1 then
	   g = g + 2
	end
	if JY.Person[76]["阶"] >= 3 and match_ID(id, 76) then
	   g = g + 2
	end
	if g >= 2 then
		return true
	else
		return false
	end
end

--花开花落
function HuaKHL(id)
local g = 0
    for i = 1, JY.Person[671]["品德"] do
    local kfid = JY.Person[id]["武功"..i]
	local klvl = JY.Person[id]["武功等级"..i]
	if kfid == 10 or kfid == 30 or kfid == 115 then
		g = g + 1
	end
	end
	
	if JY.Person[id]["地8"] == 3 and g >= 1 then
	   g = g + 2
	end
	if JY.Person[76]["阶"] >= 3 and match_ID(id, 76) then
	   g = g + 2
	end
	if g >= 3 then
		return true
	else
		return false
	end
end

function ShaoL(id)
	local s = 0
	for i = 1, JY.Person[671]["品德"] do
		local kfid = JY.Person[id]["武功"..i]
		local klvl = JY.Person[id]["武功等级"..i]
		if kfid == 1 or kfid == 22 or kfid == 24 or kfid == 96 or kfid == 108 or kfid == 144 then
			s = s + 1
		end
	end
	if JY.Person[id]["防具"] == 352 and s >= 2 then
	   s = s + 1
	end
	if JY.Person[id]["地8"] == 3 and s >= 1 then
	   s = s + 2
	end
	if JY.Person[76]["阶"] >= 3 and match_ID(id, 76) then
	   s = s + 2
	end
	if s >= 2 then
		return s
	end
end

function TiandiXH(id)
    local t = 0
	if PersonKF(id, 64) then
	   t = t + 1
	end
	if PersonKF(id, 78) then
	   t = t + 1
	end
	if Curr_QG(id, 148) then
	   t = t + 1
	end
    if JY.Person[id]["防具"] == 352 and t >= 2 then
	   t = t + 1
	end
	if JY.Person[id]["地8"] == 3 and t >= 1 then
	   t = t + 2
	end
	if JY.Person[76]["阶"] >= 3 and match_ID(id, 76) then
	   t = t + 2
	end
	if t >= 3 then
		return true
	else
		return false
	end
end	


--无酒不欢：判定一个人物是否满足剑胆琴心的条件
function JiandanQX(id)
	local jiandannum = 0;
	for i = 1, JY.Person[671]["品德"] do
		local kfid = JY.Person[id]["武功"..i]
		local klvl = JY.Person[id]["武功等级"..i]
		if (kfid == 47 or kfid == 73) and klvl == 999 then
			jiandannum = jiandannum + 1
		end
	end
	if JY.Person[id]["地8"] == 3 and jiandannum >= 1 then
	   jiandannum = jiandannum + 2
	end
	if JY.Person[76]["阶"] >= 3 and match_ID(id, 76) then
	   jiandannum = jiandannum + 2
	end
	if jiandannum >= 2 then
		return true
	else
		return false
	end
end

function SanhuaJD(id)
	local s = 0
	for i = 1, JY.Person[671]["品德"] do
		local kfid = JY.Person[id]["武功"..i]
		local klvl = JY.Person[id]["武功等级"..i]
		if (kfid == 100 or kfid == 107) and klvl == 999 then
			s = s + 1
		end
	end
	if JY.Person[id]["地8"] == 3 and s >= 1 then
	   s = s + 2
	end
	if JY.Person[76]["阶"] >= 3 and match_ID(id, 76) then
	   s = s + 2
	end
	if s >= 2 and (JY.Person[id]["专1"] == 100 or (match_ID(id, 129) and JY.Person[129]["阶"] >= 1)) then
		return true
	else
		return false
	end
end

--内功数量
function NeiNum(id)
local ng = 0
for a = 1, JY.Person[671]["品德"] do
	if JY.Wugong[JY.Person[id]["武功"..a]]["武功类型"] == 6 then
		ng = ng+1
	end
end
return ng
end

function QuanNum(id)
local ng = 0
for a = 1, JY.Person[671]["品德"] do
	if JY.Wugong[JY.Person[id]["武功"..a]]["武功类型"] == 1 then
		ng = ng+1
	end
end
return ng
end

function JianNum(id)
local ng = 0
for a = 1, JY.Person[671]["品德"] do
	if JY.Wugong[JY.Person[id]["武功"..a]]["武功类型"] == 3 then
		ng = ng+1
	end
end
return ng
end

function is_inc(value, tab)
    for k,v in ipairs(tab) do
      if v == value then
          return true
      end
    end
    return false
end					   

function NeiL(id)
    if id < 0 then
	   id = 0
	end       
    local yang = 0
	local yin = 0
	local tg = 0
	--其他人
	for i = 1, JY.Person[671]["品德"] do
	local kfid = JY.Person[id]["武功"..i]
	    if JY.Wugong[kfid]["啊"] > 0 then
		 if match_ID(id, 637) then
		 yin = yin - 1
		 else
		 yang = yang + JY.Wugong[kfid]["啊"]
		 end   
		end
		if JY.Wugong[kfid]["啊"] < 0 then
		 if match_ID(id, 638) then
		 yang = yang + 1
		 else
		 yin = yin + JY.Wugong[kfid]["啊"]
		 end
		end
	end
	--调和
	for i = 1, JY.Person[671]["品德"] do
	local kfid = JY.Person[id]["武功"..i]
	    if JY.Wugong[kfid]["啊"] == 0 and kfid ~= 0 then
		   if JY.Wugong[kfid]["武功类型"] == 6 then
		      
			  if match_ID(id, 637) then
		        yin = yin - 1.6
		      elseif match_ID(id, 638) then
			    yang = yang + 1.6
			  else
		        yin = yin - 0.8
		        yang = yang + 0.8
		      end
		   else
		      if match_ID(id, 637) then
		        yin = yin - 1
		      elseif match_ID(id, 638) then
			    yang = yang + 1
			  else
		        yin = yin - 0.5
		        yang = yang + 0.5
		      end
		   end	  
		end
		if kfid == 16 or kfid == 46 or kfid == 85 or kfid == 108 or kfid == 102 or kfid == 171 or kfid == 90 or kfid == 97 or kfid == 98 or kfid == 77 then
        yang = yang + 1
		yin = yin - 1
		--[[if JY.Base["标准"] == 6 and id == 0 then
		   yang = yang + 1
		   yin = yin - 1
		end]]
        end
	end
	yin = math.modf(yin)
	yang = math.modf(yang)
	
	if JY.Person[id]["内力性质"] > 0 then
	   yang = yang + JY.Person[id]["内力性质"]
	else
	   yin = yin + JY.Person[id]["内力性质"]
	end   
	
	if JY.Person[id]["洗髓"] == 100 then
	   yin = yin - 2
	   yang = yang + 2
	end
	
	if JY.Person[id]["人4"] == 1 then
	   yin = yin - 1
	   yang = yang + 1
	end

	if JY.Person[id]["地9"] == 4 then
	   yin = yin - 10
	end
	
	if PersonKF(id, 153) and JY.Person[id]["专2"] == 153 then
	  yin = yin - 3
	end
	if PersonKF(id, 207) and JY.Person[id]["专1"] == 207 then
	  yin = yin - 3
	end
	if PersonKF(id, 100) and (JY.Person[id]["专1"] == 100 or (match_ID(id, 129) and JY.Person[129]["阶"] >= 2)) then
	  yin = yin - 1
	  yang = yang + 1
	end
	
	if match_ID(id, 692) and JY.Person[692]["声望"] == 1 then
	   yin = yin - 2
	   yang = yang + 2
	end
	if PersonKF(id, 17) and PersonKF(id, 19) then
	   yin = yin - 2
	   yang = yang + 2
	end
	if match_ID(id, 5) and JY.Person[5]["阶"] >= 1 then
	   yin = yin - 2
	   yang = yang + 2
	end
	if match_ID(id, 69) and JY.Person[69]["阶"] >= 2 then
	   yin = yin - 3
	   yang = yang + 3
	end
	if JY.Base["标准"] == 6 and id == 0 and JY.Person[0]["阶"] >= 3 then
	   yin = yin - 4
	   yang = yang + 4
	end
	if JY.Person[id]["地9"] == 5 then
	   yang = yang + 10
	end
	
	
	
	if JY.Person[id]["地9"] == 6 then
	   yin = -14
	   yang = 14
	end
	
	
	if JY.Person[id]["地10"] == 6 then
	   yin = yin - 5
	   yang = yang + 5
	   tg = 1
	end
	if match_ID(id, 689) then
	   tg = 1
	end
	
	if JY.Base["标准"] == 6 and id == 0 and yin < -9 and yang > 9 then
       tg = 1
	end
	
	   if not inteam(id) and JY.Base["难度"] >= 5 then
	   local add = math.modf(JY.Person[123]["天1"])
	      if yin + yang > 0 then
		     yang = yang + JY.Base["难度"] - 5 + add
		  elseif yin + yang < 0 then
 		     yin = yin - JY.Base["难度"] + 5 - add
		  else
  		     yin = yin - JY.Base["难度"] + 5 - add
			 yang = yang + JY.Base["难度"] - 5 + add
		  end	 
	   end
	return yin, yang, tg
end

function ZhiYZR(id)
local yin = 0
    for i = 1, JY.Person[671]["品德"] do
	local kfid = JY.Person[id]["武功"..i]
	    if JY.Wugong[kfid]["啊"] < 0 then
		yin = yin + 1
		end
		if JY.Wugong[kfid]["啊"] > 0 and match_ID(id, 637) == false then
		yin = 0
		break
		end
	end
	if not inteam(id) then
	   yin = yin+2
	end
	if yin < 3 then
	   yin = 0
	end
    return yin
end

function ZhiGZY(id)
local yang = 0
    for i = 1, JY.Person[671]["品德"] do
	local kfid = JY.Person[id]["武功"..i]
	    if JY.Wugong[kfid]["啊"] > 0 then
		yang = yang + 1
		end
		if JY.Wugong[kfid]["啊"] < 0 and match_ID(id, 638) == false then
		yang = 0
		break
		end
	end
	if not inteam(id) then
	   yang = yang+2
	end
	if yang < 3 then
	   yang = 0
	end
    return yang
end

function GangRBJ(id)
local g = 0
local yang = 0
local yin = 0
    for i = 1, JY.Person[671]["品德"] do
	local kfid = JY.Person[id]["武功"..i]
	    if kfid ~= 0 then
	    if JY.Wugong[kfid]["啊"] > 0 then
		yang = yang + 1
		end
		if JY.Wugong[kfid]["啊"] < 0 then
		yin = yin + 1
		end
		if JY.Wugong[kfid]["啊"] == 0 then
		g = g + 0.5
		end
		end
	end
	if yang > yin then
	   g = g + yin
	else
       g = g + yang
	end
	if yang == yin then
	   g = g*2
	end
	if match_ID(id, 637) and JY.Person[637]["声望"] >= 7 and ZhiYZR(id) > g then
	   g = ZhiYZR(id)
	end
	if match_ID(id, 638) and ZhiGZY(id) > g then
	   g = ZhiGZY(id)
	end
	g = math.modf(g)
    return g
end

function BeiM(id)
if (JY.Person[id]["专2"] == 85 or (match_ID(id, 116) and JY.Person[116]["阶"]>=2)) and JY.Status == GAME_WMAP then
	return true
end
end

function ZuoCi()
local menu = {}
    for i = 1, 3 do
      if JY.Person[JY.Person[685]["天"..i]]["特色指令"] == 1 and GRTS[JY.Person[685]["天"..i]] ~= nil then
       menu[i] = {GRTS[JY.Person[685]["天"..i]]..string.gsub(string.gsub(GRTSSAY[JY.Person[685]["天"..i]], " ",""),"*","，"),nil,1,JY.Person[685]["天"..i]}
	  else
	   menu[i] = {"",nil,0,JY.Person[685]["天"..i]}
	  end
    end
	if JY.Person[143]["品德"] == 100 then
	   menu[1][3] = 0
	end
	if JY.Person[144]["品德"] == 100 then
	   menu[2][3] = 0
	end
	if JY.Person[145]["品德"] == 100 then
	   menu[3][3] = 0
	end
	
	--local nexty = CC.ScreenH/2-CC.DefaultFont*11.2 + CC.SingleLineHeight
	DrawStrBox(10, CC.ScreenH/2-CC.DefaultFont*11, "请选择需要使用的指令", C_WHITE, CC.DefaultFont, M_RoyalBlue)
	return ShowMenu(menu, #menu, 0, CC.MainMenuX, CC.MainMenuY+65, 0, 0, 1, 0, CC.DefaultFont*0.85, C_ORANGE, C_WHITE)
	--ShowMenu2(menu, #menu, 1, 3, CC.ScreenW/2-CC.DefaultFont*10-145, nexty, 0, 0, 1, 0, CC.DefaultFont*0.9, C_ORANGE, C_RED, "请选择指令")
end


function XueHe()
 if JY.Status == GAME_WMAP then
   for j = 0, WAR.PersonNum - 1 do
	   if WAR.Person[j]['死亡'] == false and PersonKF(WAR.Person[j]["人物编号"], 163) and JY.Person[WAR.Person[j]["人物编号"]]["专1"] == 163 then
		  return true
	   end				
   end
 end
end

function ShaX()
 if JY.Status == GAME_WMAP then
   for j = 0, WAR.PersonNum - 1 do
	   if WAR.Person[j]['死亡'] == false and JY.Person[WAR.Person[j]["人物编号"]]["地7"] == 7 then
		  return true
	   end				
   end
 end
end

function Yiliao()
 if JY.Status == GAME_WMAP then
   for j = 0, WAR.PersonNum - 1 do
	   if WAR.Person[j]['死亡'] == false and JY.Person[WAR.Person[j]["人物编号"]]["专2"] == 994 then
		  return true
	   end				
   end
 end
end

function AlFoes_mp()
local f = 0
 if JY.Status == GAME_WMAP then
   for j = 0, WAR.PersonNum - 1 do
	   if WAR.Person[j]['死亡'] == false and not inteam(WAR.Person[j]["人物编号"]) and JY.Person[WAR.Person[j]["人物编号"]]["内力"] > 0 then
		  f = f + 1
	   end				
   end
 end
return f
end

function DuZ()
 if JY.Status == GAME_WMAP then
   for j = 0, WAR.PersonNum - 1 do
	   if WAR.Person[j]['死亡'] == false and JY.Person[WAR.Person[j]["人物编号"]]["专2"] == 993 then
		  return true
	   end				
   end
 end
end

function Wush1()
 if JY.Status == GAME_WMAP then
   for j = 0, WAR.PersonNum - 1 do
	   if WAR.Person[j]['死亡'] == false and JY.Person[WAR.Person[j]["人物编号"]]["人7"] == 1 and WAR.Person[j]["我方"] == true then
		  return true
	   end				
   end
 end
end

function Wush2()
 if JY.Status == GAME_WMAP then
   for j = 0, WAR.PersonNum - 1 do
	   if WAR.Person[j]['死亡'] == false and JY.Person[WAR.Person[j]["人物编号"]]["人7"] == 1 and WAR.Person[j]["我方"] == false then
		  return true
	   end				
   end
 end
end

function Danji()
 if JY.Status == GAME_WMAP then
   for j = 0, WAR.PersonNum - 1 do
	   if WAR.Person[j]['死亡'] == false and JY.Person[WAR.Person[j]["人物编号"]]["人40"] == 1 and WAR.Person[j]["我方"] == true then
		  return true
	   end				
   end
 end
end

function Danji2()
 if JY.Status == GAME_WMAP then
   for j = 0, WAR.PersonNum - 1 do
	   if WAR.Person[j]['死亡'] == false and JY.Person[WAR.Person[j]["人物编号"]]["人40"] == 1 and WAR.Person[j]["我方"] == false then
		  return true
	   end				
   end
 end
end

function Azhu()
 if JY.Status == GAME_WMAP then
   for j = 0, WAR.PersonNum - 1 do
	   if WAR.Person[j]['死亡'] == false and match_ID(WAR.Person[j]["人物编号"], 646) and WAR.Person[j]["人物编号"] == 0 then
		  return true
	   end				
   end
 end
end

function ZhangJ()
 if JY.Status == GAME_WMAP then
   for j = 0, WAR.PersonNum - 1 do
	   if WAR.Person[j]['死亡'] == false and match_ID(WAR.Person[j]["人物编号"], 694) and WAR.Person[j]["人物编号"] == 0 then
		  return true
	   end				
   end
 end
end

function WeiXB()
 if JY.Status == GAME_WMAP then
   for j = 0, WAR.PersonNum - 1 do
	   if WAR.Person[j]['死亡'] == false and match_ID(WAR.Person[j]["人物编号"], 601) and WAR.Person[j]["人物编号"] == 0 and JY.Person[601]["阶"] >= 2 then
		  return true
	   end				
   end
 end
end

function Bwj1()
 if JY.Status == GAME_WMAP then
   for j = 0, WAR.PersonNum - 1 do
	   if WAR.Person[j]['死亡'] == false and match_ID(WAR.Person[j]["人物编号"], 43) and JY.Person[43]["阶"] >= 2 and WAR.Person[j]["我方"] == true then
		  return true
	   end				
   end
 end
end

function Bwj2()
 if JY.Status == GAME_WMAP then
   for j = 0, WAR.PersonNum - 1 do
	   if WAR.Person[j]['死亡'] == false and match_ID(WAR.Person[j]["人物编号"], 43) and JY.Person[43]["阶"] >= 2 and WAR.Person[j]["我方"] == false then
		  return true
	   end				
   end
 end
end

function MoDao()
 if JY.Status == GAME_WMAP then
   for j = 0, WAR.PersonNum - 1 do
	   if WAR.Person[j]['死亡'] == false and match_ID(WAR.Person[j]["人物编号"], 691) and JY.Person[691]["天2"] == 1 and JY.Person[WAR.Person[j]["人物编号"]]["武器"] == 319 then
		  return true
	   end				
   end
 end
end

function XueDao()
 if JY.Status == GAME_WMAP then
   for j = 0, WAR.PersonNum - 1 do
	   if WAR.Person[j]['死亡'] == false and match_ID(WAR.Person[j]["人物编号"], 97) and WAR.Person[j]["人物编号"] == 0 then
		  return true
	   end				
   end
 end
end

function XueDao2()
 if JY.Status == GAME_WMAP then
   for j = 0, WAR.PersonNum - 1 do
	   if WAR.Person[j]['死亡'] == false and match_ID(WAR.Person[j]["人物编号"], 97) and JY.Person[97]["阶"] >= 1 then
		  return true
	   end				
   end
 end
end

--宇宙洪荒
function YuzhouHH(id)
    local yz = 0
	for i = 1, JY.Person[671]["品德"] do
	local kfid = JY.Person[id]["武功"..i]
	local power = get_skill_power(id, kfid, 11)
		if JY.Wugong[kfid]["武功类型"] == 1 and power >= 1000 then
		   yz = yz + 1
		   break
		end
	end
	for i = 1, JY.Person[671]["品德"] do
	local kfid = JY.Person[id]["武功"..i]
	local power = get_skill_power(id, kfid, 11)
		if JY.Wugong[kfid]["武功类型"] == 2 and power >= 1000 then
		   yz = yz + 1
		   break
		end
	end
	local j = 0
	for i = 1, JY.Person[671]["品德"] do
	local kfid = JY.Person[id]["武功"..i]
	local power = get_skill_power(id, kfid, 11)
		if JY.Wugong[kfid]["武功类型"] == 3 and power >= 1000 then
		   yz = yz + 1
		   j = j + 1
		   break
		end
	end
	if j == 0 then
		for i = 1, JY.Person[671]["品德"] do
	    local kfid = JY.Person[id]["武功"..i]
		if kfid == 49 then
		   yz = yz + 1
		   break
		end
	end
	end

	for i = 1, JY.Person[671]["品德"] do
	local kfid = JY.Person[id]["武功"..i]
	local power = get_skill_power(id, kfid, 11)
		if JY.Wugong[kfid]["武功类型"] == 4 and power >= 1000 then
		   yz = yz + 1
		   break
		end
	end
	for i = 1, JY.Person[671]["品德"] do
	local kfid = JY.Person[id]["武功"..i]
	local power = get_skill_power(id, kfid, 11)
		if JY.Wugong[kfid]["武功类型"] == 5 and power >= 1000 then
		   yz = yz + 1
		   break
		end
	end
	for i = 1, JY.Person[671]["品德"] do
	local kfid = JY.Person[id]["武功"..i]
	local power = get_skill_power(id, kfid, 11)
		if JY.Wugong[kfid]["武功类型"] == 6 and power >= 1200 then
		   yz = yz + 1
		   break
		end
	end
	for i = 1, JY.Person[671]["品德"] do
	local kfid = JY.Person[id]["武功"..i]
		if JY.Wugong[kfid]["武功类型"] == 7 then
		   yz = yz + 1
		   break
		end
	end
	if JY.Person[id]["防具"] == 352 and yz >= 2 then
	   yz = yz + 1
	end 
	if JY.Person[id]["地8"] == 3 and yz >= 1 then
	   yz = yz + 2
	end
	if JY.Person[76]["阶"] >= 3 and match_ID(id, 76) then
	   yz = yz + 2
	end
	if yz >= 7 or (match_ID(id, 677) and JY.Person[677]["天4"] == 1) then
		return true
	else
		return false
	end
end	

--无酒不欢：判定一个人物是否满足天衣无缝的条件
function TianYiWF(id)
	local tianyinum = 0;
	for i = 1, JY.Person[671]["品德"] do
		local kfid = JY.Person[id]["武功"..i]
		local klvl = JY.Person[id]["武功等级"..i]
		if (kfid == 54 or kfid == 62) and klvl == 999 then
			tianyinum = tianyinum + 1
		end
	end
	if tianyinum >= 2 then
		return true
	else
		return false
	end
end

--无酒不欢：举火燎原，金乌+燃木+火焰刀
function JuHuoLY(id)
	local juhuonum = 0;
	for i = 1, JY.Person[671]["品德"] do
		local kfid = JY.Person[id]["武功"..i]
		local klvl = JY.Person[id]["武功等级"..i]
		if (kfid == 61 or kfid == 65 or kfid == 66) and klvl == 999 then
			juhuonum = juhuonum + 1
		end
	end
	if JY.Person[id]["防具"] == 352 and juhuonum >= 2 then
	   juhuonum = juhuonum + 1
	end
	if JY.Person[id]["地8"] == 3 and juhuonum >= 1 then
	   juhuonum = juhuonum + 2
	end
	if JY.Person[76]["阶"] >= 3 and match_ID(id, 76) then
	   juhuonum = juhuonum + 2
	end
	if juhuonum >= 3 then
		return true
	else
		return false
	end
end

--无酒不欢：利刃寒锋，修罗+阴风+沧溟
function LiRenHF(id)
	local lirennum = 0;
	for i = 1, JY.Person[671]["品德"] do
		local kfid = JY.Person[id]["武功"..i]
		local klvl = JY.Person[id]["武功等级"..i]
		if (kfid == 58 or kfid == 174 or kfid == 153) and klvl == 999 then
			lirennum = lirennum + 1
		end
	end
	if JY.Person[id]["防具"] == 352 and lirennum >= 2 then
	   lirennum = lirennum + 1
	end
	if JY.Person[id]["地8"] == 3 and lirennum >= 1 then
	   lirennum = lirennum + 2
	end
	if JY.Person[76]["阶"] >= 3 and match_ID(id, 76) then
	   lirennum = lirennum + 2
	end
	if lirennum >= 3 then
		return true
	else
		return false
	end
end

--换装
function Avatar_Switch(id)
	--判断是否畅想
	local Ani_id = id
	if id == 0 and JY.Base["标准"] > 0 then
		if JY.Person[id]["性别"] == 0 and JY.Base["标准"] == 4 then
			Ani_id = 4
		elseif JY.Person[id]["性别"] == 0 then
			Ani_id = 0
		end
	end
	if id == 0 and JY.Base["畅想"] > 0 then
		Ani_id = JY.Base["畅想"]
	end
	if Avatar[Ani_id] == nil then
		return
	end
	local r = JYMsgBox("一键换装", "请选择"..JY.Person[id]["姓名"].."的造型", {Avatar[Ani_id][1].name,Avatar[Ani_id][2].name}, #Avatar[Ani_id], JY.Person[id]["头像代号"])
	JY.Person[id]["头像代号"] = Avatar[Ani_id][r].num
	for i = 1, 5 do
		JY.Person[id]["出招动画帧数" .. i] = Avatar[Ani_id][r].frameNum[i]
		JY.Person[id]["出招动画延迟" .. i] = Avatar[Ani_id][r].frameDelay[i]
		JY.Person[id]["武功音效延迟" .. i] = Avatar[Ani_id][r].soundDelay[i]
	end
end

function Teammember_View()

	local choice = 1

	while true do
		if JY.Restart == 1 then
			return
		end
		Cls()
		
		lib.LoadPNG(96, 1 * 2 , 0, 0, 1)
		
		local x = 8
		for i = 1, 5 do
			if choice ~= i then
				lib.SetClip(x + 10, CC.ScreenH-579 + 13, x + 184 -10, CC.ScreenH-579 + 575)
				lib.LoadPNG(95, i * 2 , x - 90, CC.ScreenH-579, 1)
				
				local h = 494
				local space = 35
				local color = C_WHITE
				
				local indent = 0
				
				if string.len(JY.Person[i]["姓名"]) == 8 then
					indent = 29
				elseif string.len(JY.Person[i]["姓名"]) == 6 then
					indent = 14
				end
				
				DrawString(x + 61 - indent, h, JY.Person[i]["姓名"],color,CC.DefaultFont)
				h = h + space
				
				DrawString(x + 58, h, "LV."..JY.Person[i]["等级"],color,CC.Fontsmall)
				h = h + space
				
				DrawString(x + 41, h, "攻击 "..JY.Person[i]["攻击力"],color,CC.Fontsmall)
				h = h + space
				
				DrawString(x + 41, h, "防御 "..JY.Person[i]["防御力"],color,CC.Fontsmall)
				h = h + space
				
				DrawString(x + 41, h, "轻功 "..JY.Person[i]["轻功"],color,CC.Fontsmall)
				h = h + space
			end
			x = x + 184
		end
		
		lib.SetClip(0,0,0,0)
		
		x = 8
		for i = 1, 5 do
			if choice == i then
				lib.LoadPNG(96, 3 * 2 , x, CC.ScreenH-579, 1)
			else
				lib.LoadPNG(96, 2 * 2 , x, CC.ScreenH-579, 1)
			end
			x = x + 184
		end
		
		x = 8
		for i = 1, 5 do
			if choice == i then
				lib.SetClip(x + 10, CC.ScreenH-579 + 13, x + 184 -10, CC.ScreenH-579 + 575)
				lib.LoadPNG(95, i * 2 , x - 90, CC.ScreenH-579, 1)
				
				local h = 494
				local space = 35
				local color = LightYellow2
				
				local indent = 0
				
				if string.len(JY.Person[i]["姓名"]) == 8 then
					indent = 29
				elseif string.len(JY.Person[i]["姓名"]) == 6 then
					indent = 14
				end
				
				DrawString(x + 61 - indent, h, JY.Person[i]["姓名"],color,CC.DefaultFont)
				h = h + space
				
				DrawString(x + 58, h, "LV."..JY.Person[i]["等级"],color,CC.Fontsmall)
				h = h + space
				
				DrawString(x + 41, h, "攻击 "..JY.Person[i]["攻击力"],color,CC.Fontsmall)
				h = h + space
				
				DrawString(x + 41, h, "防御 "..JY.Person[i]["防御力"],color,CC.Fontsmall)
				h = h + space
				
				DrawString(x + 41, h, "轻功 "..JY.Person[i]["轻功"],color,CC.Fontsmall)
				h = h + space
			end
			x = x + 184
		end
		
		local keypress, ktype, mx, my = lib.GetKey()
		
		if keypress == VK_LEFT then
			choice = choice - 1
		elseif keypress == VK_RIGHT then
			choice = choice + 1
		end
		
		ShowScreen()
		lib.Delay(CC.Frame)

	end
	
end

--逍遥御风
function XiaoYaoYF(id)
	if id ~= 0 then
		return false
	end
	local x = 0
	if PersonKF(id,85) then
	   x = x + 1
	end  
	if PersonKF(id,98) then
	   x = x + 1
	end
	if PersonKF(id,101) then
	   x = x + 1
	end
	if JY.Person[id]["防具"] == 352 and x >= 2 then
	   x = x + 1
	end
	if JY.Person[id]["地8"] == 3 and x >= 1 then
	   x = x + 2
	end
	if JY.Person[76]["阶"] >= 3 and match_ID(id, 76) then
	   x = x + 2
	end
	if x >= 3 and JY.Person[634]["品德"] == 50 then
		return true
	end
	return false
end

--选择张家辉的秘籍
--上上下下左右左右BABA
function YC_ZhangJiaHui(key)
	local up,down,left,right = VK_UP, VK_DOWN, VK_LEFT, VK_RIGHT
	local A,B = VK_A, VK_B
	local sequence = {up,up,down,down,left,right,left,right,B,A,B,A}
	if key == sequence[YC.ZJH + 1] then
		YC.ZJH = YC.ZJH + 1
	else
		YC.ZJH = 0
	end
end

function YC_Kael(key)
	local K,A,E,L = VK_K, VK_A, VK_E, VK_L
	local sequence = {K,A,E,L}
	if key == sequence[YC.Kael + 1] then
		YC.Kael = YC.Kael + 1
	else
		YC.Kael = 0
	end
end

--无酒不欢：太极+柔云，以柔克刚
function YiRouKG(id)
	local yirounum = 0;
	for i = 1, JY.Person[671]["品德"] do
		local kfid = JY.Person[id]["武功"..i]
		local klvl = JY.Person[id]["武功等级"..i]
		if (kfid == 36 or kfid == 46) and klvl == 999 then
			yirounum = yirounum + 1
		end
	end
	if yirounum >= 2 then
		return true
	else
		return false
	end
end

--周目商店
function zmStore()
	dofile(CC.Acvmts)
	local mrchds = {}
	for i = 1, 8 do
		mrchds[i] = {}
		mrchds[i].num = 0
	end
	mrchds[1].name = "玄元丹"
	mrchds[1].price = 200
	mrchds[2].name = "无极丹"
	mrchds[2].price = 500
	mrchds[3].name = "洗髓丹"
	mrchds[3].price = 900
	mrchds[4].name = "先天丹"
	mrchds[4].price = 600
	mrchds[5].name = "天机丹"
	mrchds[5].price = 400
	mrchds[6].name = "归元丹"
	mrchds[6].price = 600
	mrchds[7].name = "通窍丹"
	mrchds[7].price = 700
	mrchds[8].name = "天王造化续命丹"
	mrchds[8].price = 200
	local choice = 1
	local t_price = 0
	local m_left = Achievements.sp
	while true do
		if JY.Restart == 1 then
			return
		end
		Cls()
		lib.LoadPNG(1, 1000 * 2 , 0, 0, 1)
		DrawString(390,50,"周目商店",C_ORANGE,CC.FontBig)
		DrawString(220,130,string.format("%-12s %6s %6s %6s","物品", "单价", "数量", "现有"),C_ORANGE,CC.DefaultFont)
		for i = 1, #mrchds do
			local t_color = C_WHITE
			if i == choice then
				t_color = C_GOLD
			end
			DrawString(220,190+60*(i-1),string.format("%-12s %6s %6s %6s",mrchds[i].name, mrchds[i].price, mrchds[i].num, Achievements.bonus[i]),t_color,CC.DefaultFont)
		end
		
		DrawString(220,190+60*(#mrchds+1),string.format("%-10s %-6s %-10s %-6s","总价：",t_price,"余额：",m_left), C_GOLD,CC.DefaultFont)
		
		DrawString(20,CC.ScreenH - 47,"秘武残章：".. Achievements.sp, C_ORANGE, CC.DefaultFont)
		DrawString(450,CC.ScreenH - 40,"上下键选择 左右键调整数量 回车键确认 ESC退出",LimeGreen,CC.FontSmall)

		local keypress, ktype, mx, my = lib.GetKey()
		if keypress == VK_UP then
			choice = choice - 1
			if choice < 1 then
				choice = #mrchds
			end
		elseif keypress == VK_DOWN then
			choice = choice + 1
			if choice > #mrchds then
				choice = 1
			end
		elseif keypress == VK_LEFT and mrchds[choice].num > 0 then
			mrchds[choice].num = mrchds[choice].num - 1
			m_left = m_left + mrchds[choice].price
			t_price = t_price - mrchds[choice].price
		elseif keypress == VK_RIGHT then
			if m_left >= mrchds[choice].price then
				mrchds[choice].num = mrchds[choice].num + 1
				m_left = m_left - mrchds[choice].price
				t_price = t_price + mrchds[choice].price
			else
				DrawString(500,520,"您的余额不足！", C_RED, CC.FontBig)
				ShowScreen()
				lib.Delay(300)
			end
		elseif keypress == VK_RETURN then
			Achievements.sp = m_left
			for i = 1, #mrchds do
				if mrchds[i].num > 0 then
					Achievements.bonus[i] = mrchds[i].num
					mrchds[i].num = 0
				end
			end
			SaveTable(Achievements)
		elseif keypress == VK_ESCAPE then
			break
		end
		ShowScreen()
		lib.Delay(CC.Frame)
	end
end


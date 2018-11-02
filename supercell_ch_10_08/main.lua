--2018 10 08脚本
require("TSLib")
local ts = require("ts")
local json=ts.json
--local gHost = "http://120.79.174.99:8080"   --测试环境
local gHost = "http://47.75.118.68:8080"       --线上环境
time = getNetTime();   --获取当前时间
local logName=os.date("%Y年%m月%d日",time)  --日志名

init(0,1)   --手机横屏
function text_recognition(tab, intX, intY, cast)
	--tab: tab模式的字库文件，由点阵字库工具生成
	--intX: 识别区域的左上角定点坐标
	--intY: 识别区域的右下角坐标
	--cast：偏色列表，由点阵字库工具生成
	local index = addTSOcrDictEx(tab)
	local ret = tsOcrText(index, intX[1], intX[2], intY[1], intY[2], cast, 90)
	return ret
end
function text_rec_coor(tab, content, intX, intY, cast)
	--tab: tab模式的字库文件，由点阵字库工具生成
	--content: 要识别的文字内容
	--intX: 识别区域的左上角定点坐标
	--intY: 识别区域的右下角坐标
	--cast：偏色列表，由点阵字库工具生成
	local index = addTSOcrDictEx(tab)
	x, y = tsFindText(index, content, intX[1], intX[2], intY[1], intY[2], cast, 90)
	return x,y
end
local tab_connecttion = {
	--conn
	"1fe3ffbffdffef03601b00f807c03e01c0000000fe0ff87fe7ff301980cc067873ff8ff83f80000000ff87fe7ff3f01f807f00fe01f80f87fc3fe1fe00000003fe1ff9ffcfc07e01fc03f807e03e1ff0ff87f@100$conn$342$13$51",
	--disconn
	"6001ffffffffffffff807e00f803e00f80f7ffdffe7ff07f0000000047f91fe400000000000e007843e10f84233087821e087821c000000003f81fe07f83fe0c0820308042010804000000000003f01fe0ffc3ff0804201080c3870ffc3fe07f000000001fe0ffc3ff0f803e00fe007e00fc03e0ff83fe0ff000000001fe0ffc3ff0f803e00fe007e00fc03e0ff83fe0ff@00$disconn$484$14$83",
}
local tab_login = {
	--ok
	"03fc00fff03fffc7fffe7c03ef000ff0007e0007e0007e0007e0007f000ff801f7fffe3fffc1fff807fe0000000000000000ffffffffffffffffffff00f8001f0007f800ffc01fff03e1f87c0fef807ff001fe000f8000300001$ok$355$20$36",
	--CONFIRM
	"07f00ffe0fff8701c600330019800cc006600330019c01c703c181c000c000000000000001f003fe03ff8380e38039800cc006600330019800cc00670071e0f07ff01ff000800000000000000ffffffffffffe78000e0003800070001e00038000f0007dffffffff800000000000000007ffffffffffffe1c070e038701c380e1c070e038701c00000000000000000000ffffffffc000000000000000000001fffffffff07030301818060c03070183e0e3fc3f8f9f81c00020000000000003fffffffffffffc000fc000fc000f8000f8001e001f007c01f007c01f000ffffffffffff@111$CONFIRM$676$17$107",
	--log out
	--"ffffffffffffe000700038001c000e000700038001c000800000000004003fe03ff83c1e38039800cc006600330019800cc00670071c0707ff01ff003e0000000000000003e007fc0fff8701c700730019800cc006600330e19870c738631fe00ff0000000000000000000000000000000000000000fe01ffc1fff0e038c006600330019800cc006600330019c01c7c7c1ffc03f8000000000000000003ffe1fffc003f00018000c0006000300018000c000efffe7ffe3ffc000000000700038001c000e000700038001fffffffff00038001c000e0007000@00$LOG OUT$520$17$102",
	--log in
	"ffffffffffffff800070000e0001c0003800070000e0001c000380000000000000007c003fe01fff07c1f0e00e3800e6000cc00198003300066000cc0019c0071e03c1fff01ffc00fe0000000000000000000003fe01fff07fff0e00e3800e6000cc001980033000660e0cc1c19e3871c7fc18ff801fe000000000000000000000000000000000000000000000000ffffffffffffff80000000000000000007fffffffffffffdf0000f000070000780003c0003c0001e0000f0001f7ffffffff@111$LOG IN$508$19$81",
}
local tab_number = {
	"1fe0ffe7fffffffc1f803e00f803e01fffffffdfff3ff@00$0$127$14$13",  --0
	"4007003fffffffff@1$1$43$13$5",  --1
	"40fb03fc1ff0ffc39f1c3ef0ff83fc09f02$2$79$14$10",  --2
	"c00f003c20f187c61fffffffbe7e30f0030$3$73$14$10",  --3
	"80030800f0803f080ff081e30838308383083c7983fff83fff83ffe80030800108000080000$4$104$20$15",  --4
	"3e03fc3ff0ffc3c71f0c6c3fb0fec1f307c$5$81$14$10",  --5
	--"07f8fff9fff3fff738fc70f8e1f1c7e1ff83f807f@0$6$109$15$11",  --6
	"07f07ff9fff3fff738ec70f8e1f1c7e1ff83f807f@0$6$106$15$11",
	"6000c00980fb07f63fddfe1ff03f807c0@000$7$63$15$9",  --7
	"0830f8f9fffbfff6387870f0e1f1c3fffefffde3f083c002@000$8$115$15$13",  --8
	"1f03fc0ff0ffc3c30f0c6c31b0eefffbffc3ff@00$9$94$14$11",  --9
}
--点击
function click(x, y)
    touchDown(x, y)
    mSleep(30)
    touchUp(x, y)
	mSleep(500)
end

function  initialize()
	--flag = appIsRunning("com.cyjh.gundam"); --检测 是否在运行
	flag = appIsRunning("com.cyjh.gundam"); --检测蜂窝游戏是否在运行
	if flag  == 0 then                      --如果没有运行
		r=runApp("com.cyjh.gundam")           --运行 
		mSleep(10 * 1000);
		
		if r == 0 then
			toast("游戏蜂窝启动成功");	
		else
			toast("游戏蜂窝启动失败");
		end
	else	
		toast("游戏蜂窝正在运行")
	end
	bid = frontAppBid();
	if bid ~= "com.supercell.clashofclans" then 
		toast("打开coc再运行该脚本！", 5);
		mSleep(3000); 
		r = runApp("com.supercell.clashofclans");    --启动 部落冲突coc
		mSleep(10 * 1000);
		
		if r == 0 then
			toast("coc启动成功");	
		else
			toast("coc启动失败");
		end
		--识别ok按钮
		local ok = ""
		for i=1,10 do
			mSleep(5000)
			local gold=getGold()
			if gold and (gold > "1") then
				break	
			end
			--获取登录按钮
			ok= text_recognition(tab_login,{270,473},{702,719},"6DA09B , 142B29 # 6DA09B , 142B29 # 6DA09B , 142B29")
			if (ok == "ok" ) then
				toast("已获取到ok，将获取ok位置并点击")
				break;
			end
		end
		if ok == "ok" then
			ok_x,ok_y = text_rec_coor(tab_login,"ok",{270,473},{702,719},"6DA09B , 142B29 # 6DA09B , 142B29 # 6DA09B , 142B29")
			click(ok_x,ok_y)
		else
			--toast("未识别到ok");
			log("未识别到ok",logName)
		end
		mSleep(10*1000)
		click(1159,381)
	else
		toast("coc正在运行，可运行该脚本！");
	end
end
--入口
function start( )
	log("----------------脚本开始---------------------",logName)
	
	initialize() --初始化
	
	if (isColor(  50,  550, 0xce0d0e, 85) and 
		isColor(  73,  520, 0xfe5a62, 85) and 
		isColor( 151,  524, 0xfb5d61, 85)) then
		
		toast("攻击页面,不操作")
		log("----------------脚本结束---------------------",logName)
	else
		toast("主页面，正常执行")
		--click(958,40)  --每次运行脚本点击屏幕
	
		local file = readFile(userPath().."/res/test.txt") --读文件
		
		if file then     --如果有账号在线
			local data=json.decode(file[1])  --文件中获取数据
			--获取用户状态 看是否要下线
			local status = getUesrStatus(data["user_name"],data["email"],data["game_id"])
			if (status ==0) then
				--logOut()  			--退出挂机
				clearApp()
				delFile(userPath().."/res/test.txt") --删除文件
				log("----------------脚本结束---------------------",logName)
			elseif(status ==1) then
				--更新数据
				toast("已有账号在线，只更新数据"); 
				updateData(data["user_name"],data["email"],data["game_id"])  
				log("----------------脚本结束---------------------",logName)
			else
				toast("获取用户状态错误，将退出脚本");
				log("获取用户状态错误，将退出脚本",logName)
				lua_exit();
			end
		else 
			click(958,40)  --每次运行脚本点击屏幕
			toast("点击屏幕")
			local data=getEmail()   --获取邮箱数据
			if (data ~= 0) then
				log(data["game_account"],logName)
				local login=logIn(data)  --登录
				if login == 0 then
					mSleep(2000)
					login_second =logIn(data)
					if login_second ==0 then
						toast("退出脚本")
						click(1080,45)
						lua_exit(); 
				    end
				end
				--mSleep(5000)
				-- 获取IMO 位置 并点击
				--x,y = findMultiColorInRegionFuzzy( 0x538de5, "18|-7|0x4483e3,7|9|0x518be5,21|25|0x4181e2,27|9|0x4584e3,9|23|0x4f77ab,13|41|0x538de5", 90, 0, 0, 1279, 719)
				--click(x, y)
				--click(639, 586)
				log("----------------脚本结束---------------------",logName)
			else
				toast("获取邮箱result结果为[ ]"); 
				log("----------------脚本结束---------------------",logName)
			end
		end	
	end
end

--获取是否有账号标志
function getLoginMsg()
	-- body 
	--返回文字 坐标
	return  
end

--登录成功
function loginSuccess(name,account,id,code)
	-- body
	local url = gHost.."/record_login_result"
	local data = "user_name="..name.."&game_account="..account.."&game_id="..id.."&password="..code
	local res=httpPost(url, data)
	if res ==false then
		return 0
	end
	local b=json.decode(res)
	if b.result == "success" then
		log("登录成功"..res,logName)
		return 1
	else
		return 0
	end
end
--获取登录按钮坐标
function getlogincoord()
	-- body
end
--获取退出按钮坐标
function getlogoutcoord()
	-- body
end


--判断模拟器是否已有账户
function isAccountOnline()
	-- body
	local online=
	--点击设置
	tap(x,y,50)
	--判断是否在线,识别按钮
	
	
	if   online then
		return true
	else
		return false
	end	
end

--获取用户状态
function getUesrStatus(name,account,id)
	-- body
	local url = gHost.."/get_is_register"
	--local url = "http://120.79.174.99:8080/record_exit_result"
	local data = "user_name="..name.."&account="..account.."&game_id="..id
	local res=httpPost(url, data)
	if res ==false then
		return 2
	end
	log("获取用户状态:"..res,logName)
	local status=json.decode(res)
	return status.result
end

--发请求判断是否下线
function isOffline()
	--发网页请求
	
end

--更新发送数据
function updateData(name,account,id)
	--click(35,437) --点击确保能获取到数据
	--click(122,197) --点击确保能获取到数据
	-- body
	local url = gHost.."/update_or_insert"
	
	local gold=getGold()
	local water = getElixir()
	local dark =  getDark()
	local cup = getCup()
	local data = "user_name="..name.."&game_account="..account.."&game_id="..id.."&gold="..gold.."&water="..water.."&dark="..dark.."&cup="..cup
	if gold and (gold > "1") then
		local res=httpPost(url, data)
		if res ==false then
			return 
		end
		toast("更新发送数据:"..res)
		log("更新发送数据:"..res,logName)	
	end
end

--获取gold数据
function getGold()
	-- body
	--获取金币数量
	gold = text_recognition(tab_number,{997,11},{1268,73},"FFFFFF , 010101")
	return gold
end

--获取elixir数据
function getElixir()
	-- body
	--获取圣水数量
	elixir = text_recognition(tab_number,{997,89},{1268,141},"FFFFFF , 010101")
	--elixir = text_recognition(tab_number,{997,89},{1268,141},"FFFFFF , 010101")
	return elixir
end

--获取dark数据
function getDark()
	-- body
	--获取黑油数量
	--dark = text_recognition(tab_number,{997,152},{1268,199},"FFFFFF , 010101")
	dark = text_recognition(tab_number,{997,152},{1268,199},"FFFFFF , 010101")
	data = text_recognition(tab_number,{997,212},{1268,291},"FFFFFF , 010101")
	if data == "" then
		return 0
	else
	   return dark
	end
	
end
--获取杯数据
function getCup()
	-- body
	--获取杯等级
	cup = text_recognition(tab_number,{1,76},{226,163},"FFFFFF , 010101")
	return cup
end
--登录
function logIn(data)
	toast("开始执行登录操作");
	--没有账户
			--登录操作
			click(839,395) --教程
			click(839,395) --教程
			click(839,395) --教程
			click(839,395) --教程
			click(839,395) --教程
			click(51,41) --点击设置按钮 在左上角
			click(786,428)   --左上进入页面
			
			local log_in = ""
			for i=1,10 do
				mSleep(2000)
				log_in = text_recognition(tab_login,{701,330},{1033,483},"FFFFFF , 010101")
				if (log_in == "LOG IN" )then
					toast("已识别到log in,将获取位置并点击")
					break;
				end
				mSleep(3000)
			end
			if (log_in == "LOG IN" ) then
				log_in_x,log_in_y = text_rec_coor(tab_login,"LOG IN",{701,330},{1033,483},"FFFFFF , 010101")
				click(log_in_x,log_in_y)  --点击log in
				--click(872,395)  --点击log in
				
				switchTSInputMethod(true);   -- 切换到触动/帮你玩输入法
				
				click(620,406)   --点击输入框
				mSleep(1000)
				
				toast("邮箱为"..data["game_account"])
				inputText(data["game_account"]) --把邮箱填入进去
				
				local email_x= ""
			    local email_y=""
		
				for i=1,10 do
					email_x,email_y = findColorInRegionFuzzy(0x21c49f, 100,850, 0, 1000, 719);
					if (email_x ~= -1 and email_y ~= -1)then
						toast("已识别到邮箱格式正确")
						break;
					end
					mSleep(5000)
				end
				
				if (email_x ~= -1 and email_y ~= -1) then
					log("邮箱为"..data["game_account"],logName)
					click(586,274)
					mSleep(1000)
					click(625,570)   --点击log-in 去到输入验证码页面
					mSleep(3000)
					click(380,340)   --点击验证码页第一个按钮
					
					local code=0  --获取验证码
					local vcode=nil  --获取验证码
	
					for i=1,50 do
						code=getCode(data["user_name"],data["game_account"],data["game_id"],data["session_id"])
						if code ~=0  then
							vcode=code["verification_code"]	
							toast("获取的验证码为"..vcode)
							log("获取的验证码为"..vcode,logName)
							break;
						end
						mSleep(5000)
					end
					if vcode then
						toast("验证码为"..code["verification_code"])
						inputText(vcode)   --把验证码填入进去
						log("验证码为"..code["verification_code"],logName)
						local code_x= ""
						local code_y=""
						for i=1,10 do
							code_x,code_y = findColorInRegionFuzzy( 0x3d91fa, 100, 322, 192, 952, 285)
							if (code_x ~= -1 and code_y ~= -1)then
								toast("已识别到验证码已填入")
								break;
							end
							mSleep(5000)
						end
						if (code_x ~= -1 and code_y ~= -1)then
							click(783,469)  --点击去登录
							--识别confirm按钮
							local confirm = ""
							for i=1,5 do
								mSleep(5000)
								confirm= text_recognition(tab_login,{826,452},{1041,555},"FFFFFF , 010101")
								if (confirm == "CONFIRM" ) then
									toast("已获取到confirm")
									break;
								end
							end
							if confirm == "CONFIRM" then
								click(919,530)  --点击confirm
								mSleep(8000)
								click(122,197) --点击确保能获取到数据
								
									
								--写文件 把数据存进去
								local gold=getGold()
								if gold  then
									loginSuccess(code["user_name"],code["email"],code["game_id"],code["verification_code"])
									updateData(code["user_name"],code["email"],code["game_id"])      --第一次更新数据
									local str =json.encode(code) --转化为字符串
									delFile(userPath().."/res/test.txt")
									writeFileString(userPath().."/res/test.txt",str,"a",1)	
								end
								mSleep(10000)
								clearSoldier()  --攻击一次
								hangUp()                 --开启挂机
							else
								toast("未识别到confirm,将退出脚本");
								log("未识别到confirm,将退出脚本",logName)
								click(635,510)
								click(500,572)
								mSleep(3000)
								click(1080,45)
								lua_exit(); 
							end
						else
							toast("验证码未填入，将退出脚本");
							log("验证码未填入，将退出脚本",logName)
							click(498,645)
							click(500,572)
							mSleep(3000)
							click(1080,45)
							lua_exit(); 
						end
					else
							toast("获取验证码超时，将退出脚本");
							log("获取验证码超时，将退出脚本",logName)
							click(498,645)
							click(500,572)
							mSleep(3000)
							click(1080,45)
							lua_exit(); 	
					end
				else
					toast("未识别到填入邮箱格式正确标志，将退出脚本");
					log("未识别到填入邮箱格式正确标志",logName)
					lua_exit(); 
				end 
			else
				toast("未识别到log in");
				log("未识别到log in",logName)
				x,y = findMultiColorInRegionFuzzy( 0x696969, "7|8|0x666666,-6|6|0x676767,-8|-9|0x6c6c6c,10|-9|0x6c6c6c", 90,  1054, 19, 1105, 63)
				toast("识别到x="..x.." y="..y)
				click(x,y)
				return 0
			end
end

--发请求获取supercell邮箱
function getEmail()
	-- body
	local url = gHost.."/get_latest_email_request"
	local data = "num=1"
	local res=httpPost(url, data)
	if res ==false then
			return 0
	end
	log("发请求获取supercell邮箱"..res,logName)
	local data=json.decode(res)
	local resultstr=data.result[1]
	if type(resultstr) == "string" then
		local result=json.decode(resultstr)
		return result
	else
		return 0
	end
end

--发请求获取验证码
	function getCode(name,account,id,session_id)
	-- body
	    local res =""
		local url = gHost.."/get_email_code_request"
		local data = "user_name="..name.."&game_account="..account.."&game_id="..id.."&session_id="..session_id
		res=httpPost(url, data)
		if res ==false then
			return 0
		end
		log("获取验证码"..res,logName) 
		local data=json.decode(res)
		local result=data.result
		local vercode=result["verification_code"]
		if vercode then
			--log("发请求获取验证码"..res,logName)
			return result
		else
			return 0
		end
end

--退出挂机
function logOut()
	toast("开始执行退出挂机操作");
	-- 获取i MOD 位置
	x,y = findMultiColorInRegionFuzzy( 0x85312d, "16|28|0x89362f,28|10|0x88362e,30|-6|0x7e3a32", 90, 1200, 0, 1279, 719)
		click(x,y)
		click(x,y)
	    mSleep(2000)
	click(1230,521) --点击设置按钮 在右下角
	log("退出挂机",logName)
	click(636,171)   --点击connectted
	
	local log_out = ""
	--while (log_out == "") do
		--获取退出按钮
		--log_out = text_recognition(tab_login,{779,216},{1092,397},"FFFFFF , 010101 # D4E6FE , 2C1902")
	--end
	
	for i=1,10 do
		--获取退出按钮
		mSleep(5000)
		log_out = text_recognition(tab_login,{779,216},{1092,397},"FFFFFF , 010101 # D4E6FE , 2C1902")
		if (log_out == "log out" ) then
			break;
		end
	end
	
	if (log_out == "log out" )then
		--获取log out坐标
		log_out_x,log_out_y = text_rec_coor(tab_login,"log out",{779,216},{1092,397},"FFFFFF , 010101 # D4E6FE , 2C1902")
		
		click(log_out_x,log_out_y)   --点击退出按钮
	
		click(814,478)    --点击确定退出按钮
	
		click(836,656)    --点击不使用supercellID 登录
	else
		toast("未识别到log out，将退出脚本");
		log("未识别到log out，将退出脚本",logName)
		lua_exit(); 
	end
end
function clearSoldier()
	-- body
	tap(91,637)
	mSleep(1000)
	tap(286,513)
	mSleep(10000)


	tap(141,658)
	for i=1,100 do
		tap(1173,185)
	end
	tap(246,658)
	for i=1,100 do
		tap(1173,185)
	end

	tap(338,658)
	for i=1,50 do
		tap(1173,185)
	end

	tap(447,658)
	for i=1,50 do
		tap(1173,185)
	end

	tap(550,658)
	for i=1,50 do
		tap(1173,185)
	end

	tap(647,658)
	for i=1,50 do
		tap(1173,185)
	end

	tap(747,658)
	for i=1,50 do
		tap(1173,185)
	end

	click(91,536)
	mSleep(1000)
	click(794,467)
	mSleep(2000)
	click(649,642)
end
function hangUp()
	-- body
	
	--识别几本
	local grade =0
	for i=1,5 do
		grade=getGrade()
		if grade > 0 then
			toast("已识别为"..grade.."本")
			break;
		end
			mSleep(2000)
	end
	
	if grade ==0  then
		toast("未识别几本，默认为九本")
		grade=9
	end
	

	--x1,y1 = findMultiColorInRegionFuzzy( 0xffcb00, "7|11|0x441a00,2|16|0xffffff,-19|7|0x2a2005", 90, 1179, 0, 1279, 719)
	
	
	
	mSleep(2000)
	x1,y1 = findMultiColorInRegionFuzzy( 0x4f2100, "-5|10|0xffffff,-7|-5|0xffcb00,3|18|0x3a1801", 90, 1179, 0, 1279, 719)
	if x1 then
		toast("已识别到挂机按钮x="..x1..";y="..y1)
		click(x1,y1)
		mSleep(3000)
		local tab = {
		"0180001800018000180001803018070180e01838018f001fc001f0001c0001c00ffffffffff01c0001f0001fc0018f0018380181e018070180301801018000180001800$本$141$20$27",
		}
		local index = addTSOcrDictEx(tab)

		x, y = tsFindText(index, "本", 218, 171, 950, 515,"121212 , 131313 # 121212 , 131313", 90)

		click(x,y)
		
		mSleep(1000)
		--moveTo(478,594,478,479)
		moveTowards(x,y+161,270,1200)
		mSleep(2000)
		moveTowards(x,y+161,90,grade*100-200)
		--tap(472,332)
		mSleep(2000)
		if grade==10 then
			click(x,y+183)
		elseif grade== 11 then
			click(x,y+283)
		elseif grade ==12 then 
			click(x,y+383)
		else
			click(x,y+80)
		end
		mSleep(1000)
		click(961,623)	
	else
	   toast("未识别到挂机按钮")
	end
end
function getGrade(...)
	-- body
	local i=0
	click(51,42)
	mSleep(2000)
	if (isColor( 231,  533, 0x444854, 85) and 
	isColor( 260,  566, 0x8c897c, 85) and 
	isColor( 207,  562, 0x242834, 85) and 
	isColor( 237,  549, 0xe2cbba, 85)) then
			i=9
	end

	if (isColor( 224,  535, 0x99683f, 85) and 
	isColor( 254,  563, 0xfdab42, 85) and 
	isColor( 237,  600, 0x524235, 85) and 
	isColor( 218,  514, 0xf8dbcd, 85)) then
		i=8
	end

	if (isColor( 200,  555, 0xffff38, 85) and 
	isColor( 221,  527, 0xd2bd69, 85) and 
	isColor( 205,  531, 0x9c4038, 85) and 
	isColor( 242,  581, 0x383438, 85)) then
	   i=10
	end

	if (isColor( 233,  523, 0xff7f3b, 85) and 
	isColor( 260,  585, 0xffbe67, 85) and 
	isColor( 275,  565, 0x857565, 85) and 
	isColor( 237,  508, 0xd8d4da, 85)) then
		i=11
	end
	
	if (isColor( 202,  528, 0x408cd8, 85) and 
	isColor( 247,  542, 0xfbdc6b, 85) and 
	isColor( 258,  592, 0xa58267, 85) and 
	isColor( 221,  599, 0x293141, 85)) then
		i=12
	end
	
	if (isColor( 222,  598, 0x705b28, 85) and 
	isColor( 273,  579, 0x737d32, 85) and 
	isColor( 218,  528, 0xa77143, 85) and 
	isColor( 201,  531, 0x585855, 85)) then
	    i=7
	end
	
	if (isColor( 246,  525, 0xd2b8ac, 85) and 
	isColor( 211,  528, 0xffab40, 85) and 
	isColor( 270,  577, 0x656323, 85) and 
	isColor( 209,  585, 0xb19448, 85)) then
		i=6
	end

	if (isColor( 222,  527, 0xffb047, 85) and 
	isColor( 211,  555, 0x525765, 85) and 
	isColor( 232,  603, 0x4e494d, 85) and 
	isColor( 258,  590, 0xbea790, 85)) then
		i=5
	end
	
	if (isColor( 255,  583, 0x422e1f, 85) and 
	isColor( 226,  565, 0x63647b, 85) and 
	isColor( 207,  536, 0x76521e, 85) and 
	isColor( 209,  528, 0xffae40, 85)) then
        i=4
	end

	if (isColor( 206,  468, 0xffb047, 85) and 
	isColor( 252,  527, 0xc1ac99, 85) and 
	isColor( 222,  530, 0x3c311f, 85) and 
	isColor( 211,  489, 0x6c6965, 85)) then
		i=3
	end
    mSleep(2000)
	click(51,42)
	return i
end
function clearApp()
	-- body
	toast("开始执行退出挂机操作");
	log("开始执行退出挂机操作",logName)
	--closeApp("com.cyjh.gundam");     --关闭游戏蜂窝
	x,y = findMultiColorInRegionFuzzy( 0xff3300, "", 90, 1150, 0, 1279, 719)
	click(x,y)
	closeApp("com.supercell.clashofclans"); --关闭部落冲突coc
	cleanApp("com.supercell.clashofclans");   --清除数据
	mSleep(10*1000)
	--imo=runApp("com.ais.imodgames.coc");    --启动 imo coc
	--imo=runApp("com.cyjh.gundam");    --启动 游戏蜂窝
	--mSleep(10 * 1000);
	--click(800,192)
    --if imo == 0 then
		--toast("启动成功");	
	--else
		--toast("启动失败");
	--end
	--mSleep(10 * 1000);
	r = runApp("com.supercell.clashofclans");    --启动 部落冲突coc
	mSleep(10 * 1000);
	
	if r == 0 then
		toast("启动成功");	
	else
		toast("启动失败");
	end
	
	--识别ok按钮
	local ok = ""
	for i=1,15 do
		mSleep(5000)
		--获取登录按钮
		ok= text_recognition(tab_login,{270,473},{702,719},"6DA09B , 142B29 # 6DA09B , 142B29 # 6DA09B , 142B29")
		if (ok == "ok" ) then
			toast("已获取到ok，将获取ok位置并点击")
			break;
		end
	end
	if ok == "ok" then
		ok_x,ok_y = text_rec_coor(tab_login,"ok",{270,473},{702,719},"6DA09B , 142B29 # 6DA09B , 142B29 # 6DA09B , 142B29")
		click(ok_x+10,ok_y+10)
	else
		toast("未识别到ok");
		log("未识别到ok",logName)
		--lua_exit(); 
	end
	mSleep(10*1000)
	click(1159,381)
end


start( )



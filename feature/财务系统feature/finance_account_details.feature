#_author_:张三香 2016.05.12

Feature:财务系统-结算明细
	"""
	1、查询条件
		统计时间：最近7天、最近30天、最近90天、全部
			选择'最近7天'后，时间框中显示时间：7天前 00:00~当天 23:59
			选择'最近30天'后，时间框中显示时间：30天前 00:00~当天 23:59
			选择'最近90天'后，时间框中显示时间：90天前 00:00~当天 23:59
			选择'全部'后，时间框中显示时间：??????
		供货商:可按供货商首字母匹配查询，例如输入adh，则可搜索出奥达行；例如输入a，则供货商第一个字包含a的都可搜索出来
		按钮：查询、重置、导出
	2、结算明细列表字段
		【下单数】：按照订单的'下单时间'进行筛选
			微众系列：所有订单数（除去8000的订单）
			本店：包含微众卡的所有订单
		【有效订单】：按照订单的'完成时间'进行筛选
			微众系列：所有已完成订单（除去8000的订单）
			本店：包含微众卡的所有已完成订单
		【订单金额】：有效订单的销售额（除去运费）
		【应结算金额】：
			微众系列：查询区间内，所有可结算订单的'结算金额'的和（采购价*数量的总和）
			本店：查询区间内，所有可结算订单的'结算金额'的和（微众卡的总和）
		【已结算金额】：查询区间内，微众已打款的金额的和（'结算完成'的和'余款未结'已打款的部分）
		【未结算金额】：查询区间内，应结算金额-未结算金额
	
	"""

Background:
	#bill、jack为普通商家
	#jobs、nokia为自营平台
	#admin为财务系统管理者

	#普通商家bill的信息
		Given 添加bill店铺名称为'bill商家'
		Given bill登录系统
		And bill已添加支付方式
			"""
			[{
				"type": "微信支付",
				"is_active": "启用"
			}, {
				"type": "支付宝",
				"is_active": "启用"
			}, {
				"type": "货到付款",
				"is_active": "启用"
			}]
			"""
		When bill开通使用微众卡权限
		When bill添加支付方式
			"""
			[{
				"type": "微众卡支付",
				"is_active": "启用"
			}]
			"""
		Given bill已创建微众卡
			"""
			{
				"cards": [{
					"id": "0000001",
					"password": "123456",
					"status": "未使用",
					"price": 50.00
				},{
					"id": "0000002",
					"password": "223456",
					"status": "未使用",
					"price": 310.00
				},{
					"id": "0000003",
					"password": "323456",
					"status": "未使用",
					"price": 200.00
				},{
					"id": "0000004",
					"password": "423456",
					"status": "未使用",
					"price": 50.00
				}]
			}
			"""
		Given bill设定会员积分策略
			"""
			{
				"integral_each_yuan": 1,
				"use_ceiling": 100,
				"be_member_increase_count": 200
			}
			"""
		Given bill已添加商品规格
			"""
			[{
				"name": "尺寸",
				"type": "文字",
				"values": [{
					"name": "M"
				}, {
					"name": "S"
				}]
			}]
			"""
		And bill已添加商品
			"""
			[{
				"name": "bill商品1",
				"model": {
					"models": {
						"standard": {
							"price": 100.00,
							"user_code":"1111",
							"weight": 1.0,
							"stock_type": "无限"
						}
					}
				},
				"postage":10.00
			},{
				"name": "bill商品2",
				"model": {
					"models": {
						"standard": {
							"price": 200.00,
							"user_code":"1112",
							"weight": 1.0,
							"stock_type": "无限"
						}
					}
				}
			},{
				"name": "bill商品3",
				"is_enable_model": "启用规格",
				"model": {
					"models": {
						"M": {
							"price": 310.00,
							"user_code":"1113",
							"weight":1.0,
							"stock_type": "有限",
							"stocks":100
						},
						"S": {
							"price": 320.00,
							"user_code":"1114",
							"weight":1.0,
							"stock_type": "无限"
						}
					}
				}
			}]
			"""

	#普通商家jack的信息
		Given 添加jack店铺名称为'jack商家'
		Given jack登录系统
		And jack已添加支付方式
			"""
			[{
				"type": "微信支付",
				"is_active": "启用"
			}, {
				"type": "支付宝",
				"is_active": "启用"
			}, {
				"type": "货到付款",
				"is_active": "启用"
			}]
			"""
		When jack开通使用微众卡权限
		When jack添加支付方式
			"""
			[{
				"type": "微众卡支付",
				"is_active": "启用"
			}]
			"""
		Given jack已创建微众卡
			"""
			{
				"cards": [{
					"id": "1000001",
					"password": "123456",
					"status": "未使用",
					"price": 50.00
				},{
					"id": "2000002",
					"password": "223456",
					"status": "未使用",
					"price": 310.00
				},{
					"id": "3000003",
					"password": "323456",
					"status": "未使用",
					"price": 200.00
				},{
					"id": "4000004",
					"password": "423456",
					"status": "未使用",
					"price": 50.00
				}]
			}
			"""
		Given jack设定会员积分策略
			"""
			{
				"integral_each_yuan": 1,
				"use_ceiling": 100,
				"be_member_increase_count": 200
			}
			"""
		Given jack已添加商品规格
			"""
			[{
				"name": "尺寸",
				"type": "文字",
				"values": [{
					"name": "M"
				}, {
					"name": "S"
				}]
			}]
			"""
		And jack添加商品
			"""
			[{
				"name": "jack商品1",
				"model": {
					"models": {
						"standard": {
							"price": 100.00,
							"user_code":"1111",
							"weight": 1.0,
							"stock_type": "无限"
						}
					}
				},
				"postage":10.00
			},{
				"name": "jack商品2",
				"model": {
					"models": {
						"standard": {
							"price": 200.00,
							"user_code":"1112",
							"weight": 1.0,
							"stock_type": "无限"
						}
					}
				}
			},{
				"name": "bill商品3",
				"is_enable_model": "启用规格",
				"model": {
					"models": {
						"M": {
							"price": 310.00,
							"user_code":"1113",
							"weight":1.0,
							"stock_type": "有限",
							"stocks":100
						},
						"S": {
							"price": 320.00,
							"user_code":"1114",
							"weight":1.0,
							"stock_type": "无限"
						}
					}
				}
			}]
			"""

	#自营平台jobs的信息
		Given 设置jobs为自营平台账号
		Given jobs登录系统
		And jobs已添加供货商
			"""
			[{
				"name": "供货商1",
				"responsible_person": "宝宝",
				"supplier_tel": "13811223344",
				"supplier_address": "北京市海淀区泰兴大厦",
				"remark": "备注卖花生油"
			}, {
				"name": "供货商2",
				"responsible_person": "陌陌",
				"supplier_tel": "13811223344",
				"supplier_address": "北京市海淀区泰兴大厦",
				"remark": ""
			}]
			"""
		And jobs已添加支付方式
			"""
			[{
				"type": "微信支付",
				"is_active": "启用"
			}, {
				"type": "支付宝",
				"is_active": "启用"
			}, {
				"type": "货到付款",
				"is_active": "启用"
			}]
			"""
		When jobs开通使用微众卡权限
		When jobs添加支付方式
			"""
			[{
				"type": "微众卡支付",
				"is_active": "启用"
			}]
			"""
		Given jobs设定会员积分策略
			"""
			{
				"integral_each_yuan": 2,
				"use_ceiling": 50,
				"be_member_increase_count": 100
			}
			"""
		Given jobs已创建微众卡
			"""
			{
				"cards": 
				[{
					"id": "1000001",
					"password": "11",
					"status": "未使用",
					"price": 110.00
				},{
					"id": "1000004",
					"password": "11",
					"status": "未使用",
					"price": 110.00
				}]
			}
			"""
		And jobs已添加商品
			"""
			[{
				"supplier": "供货商1",
				"name": "jobs商品1",
				"price": 10.00,
				"purchase_price": 9.00,
				"weight": 1.0,
				"stock_type": "无限"
			}, {
				"supplier": "供货商2",
				"name": "jobs商品2",
				"price": 20.00,
				"purchase_price": 19.00,
				"weight": 1.0,
				"stock_type": "有限",
				"stocks": 10
				}]
			}]
			"""
		When jobs将商品池商品批量放入待售于'2016-08-02 12:30'
			"""
			[
				"bill商品2", "bill商品1","jack商品2", "jack商品1"
			]
			"""
		And jobs更新商品'bill商品1'
			"""
			{
				"name": "bill商品1",
				"supplier":"bill商家",
				"purchase_price": 90.00,
				"model": {
					"models": {
						"standard": {
							"price": 100.00,
							"user_code":"1111",
							"weight": 1.0,
							"stock_type": "无限"
						}
					}
				}
			}
			"""
		And jobs更新商品'bill商品2'
			"""
			{
				"name": "bill商品2",
				"supplier":"bill商家",
				"purchase_price": 190.00,
				"model": {
					"models": {
						"standard": {
							"price": 200.00,
							"user_code":"1112",
							"weight": 1.0,
							"stock_type": "无限"
						}
					}
				}
			}
			"""
		And jobs更新商品'jack商品1'
			"""
			{
				"name": "jack商品1",
				"supplier":"jack商家",
				"purchase_price": 90.00,
				"model": {
					"models": {
						"standard": {
							"price": 100.00,
							"user_code":"1111",
							"weight": 1.0,
							"stock_type": "无限"
						}
					}
				}
			}
			"""
		And jobs更新商品'jack商品2'
			"""
			{
				"name": "jack商品2",
				"supplier":"jack商家",
				"purchase_price": 190.00,
				"model": {
					"models": {
						"standard": {
							"price": 200.00,
							"user_code":"1112",
							"weight": 1.0,
							"stock_type": "无限"
						}
					}
				}
			}
			"""
		And jobs批量上架商品
			"""
			[
				"bill商品2",
				"bill商品1",
				"jack商品2",
				"jack商品1"
			]
			"""

	When tom关注bill的公众号
	When tom关注jack的公众号
	When tom关注jobs的公众号
	#购买bill的商品
		When tom访问bill的webap
		#0001-微信支付-已完成（bill商品1,1-微众卡50+现金60）
			When tom购买bill的商品
				"""
				{
					"order_id":"0001",
					"date":"2016-04-01 10:00:00",
					"pay_type":"微信支付",
					"products":[{
						"name":"bill商品1",
						"count":1
					}],
						"weizoom_card":[{
							"card_name":"0000001",
							"card_pass":"123456"
						}]
				}
				"""
			When tom使用支付方式'微信支付'进行支付订单'0001'
			Given bill登录系统
			When bill对订单进行发货
				"""
				{
					"order_no":"0001",
					"logistics":"off",
					"shipper": "",
					"delivery_time":"2016-04-01 10:01:00"
				}
				"""
			When bill'完成'订单'0001'于'2016-04-01 10:02:00'
		#0002-优惠抵扣-已完成（bill商品1,1+bill商品2,1-微众卡310）
			When tom购买bill的商品
				"""
				{
					"order_id":"0002",
					"date":"2016-04-02 10:00:00",
					"pay_type":"微信支付",
					"products":[{
						"name":"bill商品1",
						"count":1
					},{
						"name":"bill商品2",
						"count":1
					}],
						"weizoom_card":[{
							"card_name":"0000002",
							"card_pass":"223456"
						}]
				}
				"""
			Given bill登录系统
			When bill对订单进行发货
				"""
				{
					"order_no":"0002",
					"logistics":"off",
					"shipper": "",
					"delivery_time":"2016-04-02 10:01:00"
				}
				"""
			When bill'完成'订单'0002'于'2016-04-02 10:02:00'
		#0003-微信支付-已完成（bill商品2,2-微众卡200+积分200）
			When tom购买bill的商品
				"""
				{
					"order_id":"0003",
					"date":"2016-04-03 10:00:00",
					"pay_type":"微信支付",
					"products":[{
						"name":"bill商品2",
						"count":2
					}],
						"weizoom_card":[{
							"card_name":"0000003",
							"card_pass":"323456"
						}],
					"integral":200,
					"integral_money":200.00
				}
				"""
			Given bill登录系统
			When bill对订单进行发货
				"""
				{
					"order_no":"0003",
					"logistics":"off",
					"shipper": "",
					"delivery_time":"2016-04-03 10:02:00"
				}
				"""
			When bill'完成'订单'0003'于'2016-04-03 10:03:00'
		#0004-微信支付-待支付（bill商品1,1）
			When tom购买bill的商品
					"""
					{
						"order_id":"0004",
						"date":"2016-04-04 10:00:00",
						"pay_type":"微信支付",
						"products":[{
							"name":"bill商品1",
							"count":1
						}]
					}
					"""
		#0005-微信支付-已完成-（bill商品1,1-现金110）
			When tom购买bill的商品
					"""
					{
						"order_id":"0005",
						"date":"2016-04-05 10:00:00",
						"pay_type":"微信支付",
						"products":[{
							"name":"bill商品1",
							"count":1
						}]
					}
					"""
			When tom使用支付方式'微信支付'进行支付订单'0005'
			Given bill登录系统
			When bill对订单进行发货
				"""
				{
					"order_no":"0005",
					"logistics":"off",
					"shipper": "",
					"delivery_time":"2016-04-05 10:02:00"
				}
				"""
			When bill'完成'订单'0001'于'2016-04-05 10:05:00'
	#购买jack的商品
		When tom访问jack的webapp
		#0011-微信支付（jack商品1,1-微众卡50+现金60）
			When tom购买jack的商品
				"""
				{
					"order_id":"0011",
					"date":"2016-04-11 10:00:00",
					"pay_type":"微信支付",
					"products":[{
						"name":"jack商品1",
						"count":1
					}],
						"weizoom_card":[{
							"card_name":"1000001",
							"card_pass":"123456"
						}]
				}
				"""
			When tom使用支付方式'微信支付'进行支付订单'0011'
			Given bill登录系统
			When bill对订单进行发货
				"""
				{
					"order_no":"0011",
					"logistics":"off",
					"shipper": "",
					"delivery_time":"2016-04-11 10:01:00"
				}
				"""
			When bill'完成'订单'0011'于'2016-04-11 10:02:00'
		#0012-优惠抵扣（jack商品1,1+bill商品2,1-微众卡310）
			When tom购买jack的商品
				"""
				{
					"order_id":"0012",
					"date":"2016-04-12 10:00:00",
					"pay_type":"微信支付",
					"products":[{
						"name":"jack商品1",
						"count":1
					},{
						"name":"jack商品2",
						"count":1
					}],
						"weizoom_card":[{
							"card_name":"1000002",
							"card_pass":"223456"
						}]
				}
				"""
			Given bill登录系统
			When bill对订单进行发货
				"""
				{
					"order_no":"0012",
					"logistics":"off",
					"shipper": "",
					"delivery_time":"2016-04-12 10:01:00"
				}
				"""
			When bill'完成'订单'0012'于'2016-04-12 10:02:00'
		#0013-微信支付（jack商品2,2-微众卡200+积分200）
			When tom购买jack的商品
				"""
				{
					"order_id":"0013",
					"date":"2016-04-13 10:00:00",
					"pay_type":"微信支付",
					"products":[{
						"name":"jack商品2",
						"count":2
					}],
						"weizoom_card":[{
							"card_name":"1000003",
							"card_pass":"323456"
						}],
					"integral":200,
					"integral_money":200.00
				}
				"""
			Given bill登录系统
			When bill对订单进行发货
				"""
				{
					"order_no":"0013",
					"logistics":"off",
					"shipper": "",
					"delivery_time":"2016-04-13 10:02:00"
				}
				"""
			When bill'完成'订单'0013'于'2016-04-13 10:03:00'
		#0014-货到付款-待发货（jack商品1,1）
			When tom购买jack的商品
					"""
					{
						"order_id":"0014",
						"date":"2016-04-14 10:00:00",
						"pay_type":"微信支付",
						"products":[{
							"name":"jack商品1",
							"count":1
						}]
					}
					"""
	#购买jobs的商品
		When tom访问jobs的webap
		#1001-货到付款（bill商品1,1-现金100）
			When tom购买jobs的商品
				"""
				{
					"order_id":"1001",
					"date":"2016-04-11 10:00:00",
					"pay_type":"货到付款",
					"products":[{
						"name":"bill商品1",
						"count":1
					}]
				}
				"""
			Given jobs登录系统
			When jobs对订单进行发货
				"""
				{
					"order_no":"1001",
					"logistics":"off",
					"shipper": "",
					"delivery_time":"2016-04-11 10:01:00"
				}
				"""
			When jobs'完成'订单'1001'于'2016-04-11 10:02:00'
		#1002-优惠抵扣（bill商品1,1+jobs商品1,1-微众卡110）
			When tom购买jobs的商品
				"""
				{
					"order_id":"1002",
					"date":"2016-04-12 10:00:00",
					"pay_type":"微信支付",
					"products":[{
						"name":"bill商品1",
						"count":1
					},{
						"name":"jobs商品1",
						"count":1
					}],
						"weizoom_card":[{
							"card_name":"1000001",
							"card_pass":"11"
						}]

				}
				"""
			Given jobs登录系统
			When jobs对订单进行发货
				"""
				{
					"order_no":"1002-bill商家",
					"logistics":"off",
					"shipper": "",
					"delivery_time":"2016-04-12 10:01:00"
				}
				"""
			When jobs'完成'订单'1001-bill商家'于'2016-04-12 10:02:00'
		#1003-货到付款（jack商品1,1-现金100）
			When tom购买jobs的商品
				"""
				{
					"order_id":"1003",
					"date":"2016-04-13 10:00:00",
					"pay_type":"货到付款",
					"products":[{
						"name":"jack商品1",
						"count":1
					}]
				}
				"""
			Given jobs登录系统
			When jobs对订单进行发货
				"""
				{
					"order_no":"1003",
					"logistics":"off",
					"shipper": "",
					"delivery_time":"2016-04-13 10:01:00"
				}
				"""
			When jobs'完成'订单'1003'于'2016-04-21 10:01:00'
		#1004-优惠抵扣（jack商品1,1+jobs商品1,1-微众卡110）
			When tom购买jobs的商品
				"""
				{
					"order_id":"1004",
					"date":"2016-04-14 10:00:00",
					"pay_type":"微信支付",
					"products":[{
						"name":"jack商品1",
						"count":1
					},{
						"name":"jobs商品1",
						"count":1
					}],
						"weizoom_card":[{
							"card_name":"1000004",
							"card_pass":"11"
						}]

				}
				"""
			Given jobs登录系统
			When jobs对订单进行发货
				"""
				{
					"order_no":"1004-jack商家",
					"logistics":"off",
					"shipper": "",
					"delivery_time":"2016-04-14 10:01:00"
				}
				"""
			When jobs'完成'订单'1004-jack商家'于'2016-04-22 10:01:00'
	#bill提交结算单信息
	Given bill登录系统
	#创建结算单001-本店
		When bill创建结算单
			"""
			{
				"account_id":"001",
				"account_shop":"本店",
				"account_start_date":"2016-04-01 00:00:00",
				"account_end_date":"2016-04-10 00:00:00",
				"order_info":
					[{
						"order_id":"0002",
						"price":["100.00","200.00"],
						"count":["1","1"],
						"finish_time":"2016-04-02 10:02:00",
						"order_account":310.00,
						"status":"已完成",
						"actions":["查看详情"]
					},{
						"order_id":"0001",
						"price":["100.00"],
						"count":["1"],
						"finish_time":"2016-04-01 10:01:00",
						"order_account":50.00,
						"status":"已完成",
						"actions":["查看详情"]
					}],
					"un_account":560.00,
					"shops_account":-360.00,
					"remain_un_account":200.00
			}
			"""
	#创建结算单002-jobs
		When bill创建结算单
			"""
			{
				"account_id":"002",
				"account_shop":"jobs",
				"account_start_date":"2016-04-11 00:00:00",
				"account_end_date":"2016-04-15 00:00:00",
				"order_info":
					[{
						"order_id":"1002",
						"price":["99.00"],
						"count":["1"],
						"finish_time":"2016-04-12 10:02:00",
						"order_account":99.00,
						"status":"已完成",
						"actions":["查看详情"]
					},{
						"order_id":"1001",
						"price":["99.00"],
						"count":["1"],
						"finish_time":"2016-04-11 10:01:00",
						"order_account":99.00,
						"status":"已完成",
						"actions":["查看详情"]
					}],
					"un_account":198.00,
					"shops_account":-198.00,
					"remain_un_account":0.00
			}
			"""
	#结算单001-本店，结算完成
		Given admin登录财务系统
		When admin'核算确认'结算单'001'
		When admin'确认收票'结算单'001'
		When admin对结算单进行打款
			"""
			{
				"account_id":"001",
				"input_account":360.00
			}
			"""
		Given bill登录系统
		When bill'确认收款'结算单'001'
	#创建结算单003-本店
		When bill创建结算单
			"""
			{
				"account_id":"003",
				"account_shop":"本店",
				"account_start_date":"2016-04-01 00:00:00",
				"account_end_date":"2016-04-30 10:00:00",
				"order_info":
					[{
						"order_id":"0003",
						"price":["200.00"],
						"count":["2"],
						"finish_time":"2016-04-02 10:02:00",
						"order_account":200.00,
						"status":"已完成",
						"actions":["查看详情"]
					}],
					"un_account":200.00,
					"shops_account":-200.00,
					"remain_un_account":0.00
			}

			"""
	#按照结算单的创建时间倒序显示（无余款未结状态）
		Given admin登录财务系统
		Then admin能获得财务结算单列表
			"""
			[{
				"id":"1",
				"account_id":"003",
				"account_shop":"本店",
				"start_date":"2016-04-01 00:00:00",
				"end_date":"2016-04-30 00:00:00",
				"order_num":"1",
				"supplier":"bill商家",
				"real_account":0.00,
				"total_account":200.00,
				"status":"商家提交结算",
				"aciton":["核算确认","驳回",查看"]
			},{
				"id":"2",
				"account_id":"002",
				"account_shop":"jobs",
				"start_date":"2016-04-11 00:00:00",
				"end_date":"2016-04-15 00:00:00",
				"order_num":"2",
				"supplier":"bill商家",
				"real_account":0.00,
				"total_account":198.00,
				"status":"商家提交结算",
				"aciton":["核算确认","驳回",查看"]
			},{
				"id":"3",
				"account_id":"001",
				"account_shop":"本店",
				"start_date":"2016-04-01 00:00:00",
				"end_date":"2016-04-10 00:00:00",
				"order_num":"2",
				"supplier":"bill商家",
				"real_account":360.00,
				"total_account":360.00,
				"status":"结算完成",
				"aciton":["查看"]
			}]
			"""
	#结算单002-jobs,余款未结
		Given admin登录财务系统
		When admin'核算确认'结算单'002'
		When admin'确认收票'结算单'002'
		When admin对结算单进行打款
			"""
			{
				"account_id":"002",
				"input_account":100.00
			}
			"""
		Given bill登录系统
		When bill'确认收款'结算单'002'

Scenario:1 财务系统-结算明细列表
	Given admin登录财务系统
	Then admin获得财务结算明细列表
		|商户    |公众号|下单数|有效订单数|订单金额 |应结算金额 |未结算金额|已结算金额|
		|bill商家|jobs  |2     |2         |210.00   |198.00     |98.00     |100.00    |
		|bill商家|本店  |5     |3         |800.00   |560.00     |200.00    |360.00    |
		|jack商家|jobs  |2     |2         |210.00   |198.00     |198.00    |0.00      |
		|jack商家|本店  |4     |3         |800.00   |560.00     |560.00    |0.00      |

Scenario:2 财务系统-结算明细列表的查询
	Given admin登录财务系统
	#按统计时间进行查询
		When admin设置财务结算明细查询条件
			"""
			{
				"start_date":"2016-04-01 00:00",
				"end_date":"2016-05-01 00:00",
				"supplier":""
			}
			"""
		Then admin获得财务结算明细列表
			|商户    |公众号|下单数|有效订单数|订单金额 |应结算金额 |未结算金额|已结算金额|
			|bill商家|jobs  |2     |2         |210.00   |198.00     |98.00     |100.00    |
			|bill商家|本店  |5     |3         |800.00   |560.00     |200.00    |360.00    |
			|jack商家|jobs  |2     |2         |210.00   |198.00     |198.00    |0.00      |
			|jack商家|本店  |4     |3         |800.00   |560.00     |560.00    |0.00      |
	#有效订单数，筛选时按照订单的完成时间
		When admin设置财务结算明细查询条件
			"""
			{
				"start_date":"2016-04-01 00:00",
				"end_date":"2016-04-21 00:00",
				"supplier":"jack"
			}
			"""
		Then admin获得财务结算明细列表
			|商户    |公众号|下单数|有效订单数|订单金额 |应结算金额 |未结算金额|已结算金额|
			|jack商家|jobs  |2     |0         |0.00     |0.00       |0.00      |0.00      |
			|jack商家|本店  |4     |3         |800.00   |560.00     |560.00    |0.00      |
	#按供货商进行查询
		When admin设置财务结算明细查询条件
			"""
			{
				"start_date":"",
				"end_date":"",
				"supplier":"jack商家"
			}
			"""
		Then admin获得财务结算明细列表
			|商户    |公众号|下单数|有效订单数|订单金额 |应结算金额 |未结算金额|已结算金额|
			|jack商家|jobs  |2     |2         |210.00   |198.00     |198.00    |0.00      |
			|jack商家|本店  |4     |3         |800.00   |560.00     |560.00    |0.00      |
	#组合查询
		When admin设置财务结算明细查询条件
			"""
			{
				"start_date":"2016-04-01 00:00",
				"end_date":"2016-05-01 00:00",
				"supplier":"bill商家"
			}
			"""
		Then admin获得财务结算明细列表
			|商户    |公众号|下单数|有效订单数|订单金额 |应结算金额 |未结算金额|已结算金额|
			|bill商家|jobs  |2     |2         |210.00   |198.00     |98.00     |100.00    |
			|bill商家|本店  |5     |3         |800.00   |560.00     |200.00    |360.00    |



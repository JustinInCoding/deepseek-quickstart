CREATE TABLE products (
    product_id VARCHAR(10) PRIMARY KEY,
    product_name VARCHAR(50) NOT NULL,
    model_number VARCHAR(20) NOT NULL,
    release_date DATE NOT NULL,
    current_version VARCHAR(10) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO products (product_id, product_name, model_number, release_date, current_version, description) VALUES
('PRO-001', 'Aurora Pro 多功能露营灯', 'SL-AU-PRO-2025', '2025-03-15', 'V2.1', '专业级露营灯，1200流明，IPX6防水，可拆卸电池'),
('PRO-002', 'Aurora Lite 轻量露营灯', 'SL-AU-LITE-2025', '2025-04-10', 'V1.3', '超轻量设计，适合短途徒步'),
('PRO-003', 'Aurora Solar 太阳能露营灯', 'SL-AU-SOLAR-2025', '2025-02-28', 'V3.0', '集成高效太阳能充电板，适合无电源环境'),
('PRO-004', 'Aurora Tactical 战术露营灯', 'SL-AU-TAC-2025', '2025-05-20', 'V2.5', '军用级防护，防爆抗震设计'),
('PRO-005', 'Aurora Home 智能家居灯', 'SL-AU-HOME-2025', '2025-06-05', 'V1.8', 'APP控制，家庭应急照明'),
('PRO-006', 'Aurora Mini 迷你钥匙灯', 'SL-AU-MINI-2025', '2025-07-12', 'V1.0', '便携钥匙扣设计，300流明');

CREATE TABLE product_specs (
    spec_id SERIAL PRIMARY KEY,
    product_id VARCHAR(10) REFERENCES products(product_id),
    brightness_lumens INTEGER,
    battery_capacity_mah INTEGER,
    battery_type VARCHAR(20),
    waterproof_rating VARCHAR(10),
    weight_grams INTEGER,
    charging_time_hours DECIMAL(3,1),
    material VARCHAR(30),
    dimensions VARCHAR(30),
    UNIQUE(product_id)
);

INSERT INTO product_specs (product_id, brightness_lumens, battery_capacity_mah, battery_type, waterproof_rating, weight_grams, charging_time_hours, material, dimensions) VALUES
('PRO-001', 1200, 10000, '可拆卸锂电池', 'IPX6', 450, 2.5, '航空级铝合金', '12.5×6.5×6.5cm'),
('PRO-002', 600, 5000, '固定锂电池', 'IPX4', 198, 2.0, '聚碳酸酯', '10.2×5.8×5.8cm'),
('PRO-003', 1000, 8000, '可拆卸锂电池', 'IPX6', 520, 8.0, '太阳能硅胶', '13.0×7.0×6.8cm'),
('PRO-004', 1500, 12000, '可拆卸锂电池', 'IP68', 680, 3.0, '军用级复合材料', '14.0×8.0×7.5cm'),
('PRO-005', 800, 6000, '固定锂电池', 'IPX4', 350, 2.2, 'ABS塑料', '11.0×6.0×6.0cm'),
('PRO-006', 300, 2000, '固定锂电池', 'IPX4', 85, 1.5, '铝合金', '6.5×3.2×2.8cm');

CREATE TABLE product_pricing (
    price_id SERIAL PRIMARY KEY,
    product_id VARCHAR(10) REFERENCES products(product_id),
    base_price DECIMAL(10,2) NOT NULL,
    current_price DECIMAL(10,2) NOT NULL,
    cost DECIMAL(10,2) NOT NULL,
    min_sale_price DECIMAL(10,2),
    inventory INTEGER NOT NULL,
    warehouse_locations VARCHAR(100)[],
    last_price_update TIMESTAMP WITH TIME ZONE,
    UNIQUE(product_id)
);

INSERT INTO product_pricing (product_id, base_price, current_price, cost, min_sale_price, inventory, warehouse_locations) VALUES
('PRO-001', 499.00, 399.00, 235.50, 359.00, 1250, '{"上海仓","广州仓","成都仓"}'),
('PRO-002', 299.00, 229.00, 135.80, 199.00, 870, '{"上海仓","北京仓"}'),
('PRO-003', 699.00, 599.00, 320.00, 539.00, 420, '{"上海仓","深圳仓"}'),
('PRO-004', 799.00, 689.00, 410.50, 620.00, 380, '{"广州仓","武汉仓"}'),
('PRO-005', 399.00, 369.00, 195.00, 329.00, 1560, '{"上海仓","北京仓","西安仓"}'),
('PRO-006', 159.00, 129.00, 68.00, 109.00, 2300, '{"上海仓","广州仓","成都仓","北京仓"}');

CREATE TABLE product_features (
    feature_id SERIAL PRIMARY KEY,
    product_id VARCHAR(10) REFERENCES products(product_id),
    has_solar BOOLEAN DEFAULT FALSE,
    has_usb_output BOOLEAN DEFAULT FALSE,
    has_wireless_charging BOOLEAN DEFAULT FALSE,
    has_app_control BOOLEAN DEFAULT FALSE,
    has_sos_mode BOOLEAN DEFAULT FALSE,
    has_color_change BOOLEAN DEFAULT FALSE,
    has_magnetic_base BOOLEAN DEFAULT FALSE,
    has_hook BOOLEAN DEFAULT FALSE,
    max_output_wattage DECIMAL(5,2),
    charging_inputs VARCHAR(50)[],
    UNIQUE(product_id)
);

INSERT INTO product_features (product_id, has_solar, has_usb_output, has_wireless_charging, has_app_control, has_sos_mode, has_color_change, has_magnetic_base, has_hook, max_output_wattage, charging_inputs) VALUES
('PRO-001', FALSE, TRUE, FALSE, FALSE, TRUE, TRUE, TRUE, TRUE, 18.00, '{"Type-C","Micro-USB"}'),
('PRO-002', FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, NULL, '{"Type-C"}'),
('PRO-003', TRUE, TRUE, FALSE, FALSE, TRUE, FALSE, TRUE, TRUE, 15.00, '{"Type-C","Solar"}'),
('PRO-004', FALSE, TRUE, FALSE, FALSE, TRUE, FALSE, TRUE, TRUE, 20.00, '{"Type-C","军用接口"}'),
('PRO-005', FALSE, TRUE, TRUE, TRUE, FALSE, TRUE, FALSE, FALSE, 10.00, '{"Type-C","无线充电"}'),
('PRO-006', FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, NULL, '{"Micro-USB"}');

CREATE TABLE product_accessories (
    accessory_id VARCHAR(10) PRIMARY KEY,
    accessory_name VARCHAR(50) NOT NULL,
    compatible_products VARCHAR(10)[],
    price DECIMAL(10,2) NOT NULL,
    cost DECIMAL(10,2) NOT NULL,
    inventory INTEGER NOT NULL,
    is_essential BOOLEAN DEFAULT FALSE
);

INSERT INTO product_accessories (accessory_id, accessory_name, compatible_products, price, cost, inventory, is_essential) VALUES
('ACC-001', 'SP-20太阳能充电板', '{"PRO-001","PRO-003","PRO-004"}', 199.00, 95.00, 320, FALSE),
('ACC-002', 'BN-30低温电池', '{"PRO-001","PRO-003","PRO-004"}', 129.00, 62.00, 150, FALSE),
('ACC-003', '磁吸车载支架', '{"PRO-001","PRO-002","PRO-003","PRO-004"}', 59.00, 22.00, 780, FALSE),
('ACC-004', '防水收纳袋', '{"PRO-001","PRO-002","PRO-003","PRO-004","PRO-005"}', 29.00, 8.50, 1200, TRUE),
('ACC-005', 'Type-C充电线(1.5m)', '{"PRO-001","PRO-002","PRO-003","PRO-004","PRO-005"}', 39.00, 12.00, 2500, TRUE),
('ACC-006', '备用挂钩套装', '{"PRO-001","PRO-002","PRO-003","PRO-004"}', 19.00, 6.80, 890, FALSE),
('ACC-007', '智能家居网关', '{"PRO-005"}', 159.00, 75.00, 180, TRUE),
('ACC-008', '战术携行包', '{"PRO-004"}', 89.00, 38.00, 210, FALSE),
('ACC-009', '迷你灯柔光罩', '{"PRO-006"}', 15.00, 4.50, 450, FALSE),
('ACC-010', '多设备充电坞', '{"PRO-001","PRO-003","PRO-004"}', 149.00, 68.00, 95, FALSE);

CREATE TABLE product_versions (
    version_id SERIAL PRIMARY KEY,
    product_id VARCHAR(10) REFERENCES products(product_id),
    version_number VARCHAR(10) NOT NULL,
    release_date DATE NOT NULL,
    firmware_version VARCHAR(20),
    hardware_changes TEXT,
    known_issues TEXT,
    is_recalled BOOLEAN DEFAULT FALSE
);

-- 为每个产品插入3-5个版本记录
INSERT INTO product_versions (product_id, version_number, release_date, firmware_version, hardware_changes, known_issues) VALUES
-- Aurora Pro
('PRO-001', 'V1.0', '2024-11-15', 'FW1.0', '初始版本', '低温环境下电池效率下降'),
('PRO-001', 'V1.5', '2025-01-20', 'FW1.2', '改进电池仓密封性', '无'),
('PRO-001', 'V2.0', '2025-03-01', 'FW2.0', '升级LED驱动芯片', '极亮模式发热量增加'),
('PRO-001', 'V2.1', '2025-06-10', 'FW2.1', '优化散热结构', '无'),

-- Aurora Lite
('PRO-002', 'V1.0', '2025-03-05', 'FW1.0', '初始版本', '挂钩承重不足'),
('PRO-002', 'V1.2', '2025-04-01', 'FW1.1', '强化挂钩结构', '充电口易进灰'),
('PRO-002', 'V1.3', '2025-05-15', 'FW1.3', '增加防尘盖', '无'),

-- Aurora Solar
('PRO-003', 'V2.0', '2024-12-10', 'FW2.0', '初始版本(前代改进)', '太阳能板效率不稳定'),
('PRO-003', 'V2.5', '2025-01-25', 'FW2.3', '更换太阳能板供应商', '阴天充电慢'),
('PRO-003', 'V3.0', '2025-02-28', 'FW3.0', '升级充电管理芯片', '无'),

-- Aurora Tactical
('PRO-004', 'V2.0', '2025-04-01', 'FW2.0', '初始版本', '重量偏大'),
('PRO-004', 'V2.3', '2025-05-01', 'FW2.1', '减轻外壳重量', '防爆认证延迟'),
('PRO-004', 'V2.5', '2025-05-20', 'FW2.5', '通过军用标准认证', '无'),

-- Aurora Home
('PRO-005', 'V1.5', '2025-05-15', 'FW1.5', '初始版本', 'APP连接不稳定'),
('PRO-005', 'V1.7', '2025-05-28', 'FW1.7', '升级WiFi模块', '夜间自动亮度调节不灵敏'),
('PRO-005', 'V1.8', '2025-06-05', 'FW1.8', '优化光线传感器', '无'),

-- Aurora Mini
('PRO-006', 'V1.0', '2025-06-20', 'FW1.0', '初始版本', '按键易误触');

CREATE TABLE product_colors (
    color_id SERIAL PRIMARY KEY,
    product_id VARCHAR(10) REFERENCES products(product_id),
    color_name VARCHAR(20) NOT NULL,
    color_code VARCHAR(7) NOT NULL,
    stock_status VARCHAR(10) NOT NULL,
    price_adjustment DECIMAL(10,2) DEFAULT 0.00,
    UNIQUE(product_id, color_name)
);

-- 为每个产品插入颜色选项
INSERT INTO product_colors (product_id, color_name, color_code, stock_status, price_adjustment) VALUES
-- Aurora Pro
('PRO-001', '极地黑', '#2B2B2B', '充足', 0.00),
('PRO-001', '军绿色', '#4B5320', '充足', 0.00),
('PRO-001', '沙漠黄', '#C2B280', '充足', 0.00),
('PRO-001', '限量红', '#FF0000', '缺货', 50.00),

-- Aurora Lite
('PRO-002', '月光白', '#F5F5F5', '充足', 0.00),
('PRO-002', '天空蓝', '#87CEEB', '充足', 0.00),
('PRO-002', '薄荷绿', '#98FF98', '充足', 0.00),

-- Aurora Solar
('PRO-003', '太阳能橙', '#FFA500', '充足', 0.00),
('PRO-003', '深空灰', '#A9A9A9', '充足', 0.00),

-- Aurora Tactical
('PRO-004', '战术黑', '#1A1A1A', '充足', 0.00),
('PRO-004', '迷彩色', '#755C48', '充足', 0.00),

-- Aurora Home
('PRO-005', '珍珠白', '#F8F8FF', '充足', 0.00),
('PRO-005', '香槟金', '#F0E68C', '充足', 20.00),
('PRO-005', '石墨灰', '#686868', '充足', 0.00),

-- Aurora Mini
('PRO-006', '曜石黑', '#0A0A0A', '充足', 0.00),
('PRO-006', '玫瑰金', '#B76E79', '充足', 15.00),
('PRO-006', '荧光绿', '#CCFF00', '充足', 0.00);

CREATE TABLE product_promotions (
    promotion_id VARCHAR(10) PRIMARY KEY,
    product_id VARCHAR(10) REFERENCES products(product_id),
    promotion_name VARCHAR(50) NOT NULL,
    start_date TIMESTAMP WITH TIME ZONE NOT NULL,
    end_date TIMESTAMP WITH TIME ZONE NOT NULL,
    discount_type VARCHAR(20) NOT NULL,
    discount_value DECIMAL(10,2) NOT NULL,
    max_uses INTEGER,
    current_uses INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE
);

INSERT INTO product_promotions (promotion_id, product_id, promotion_name, start_date, end_date, discount_type, discount_value, max_uses, current_uses) VALUES
('PROMO-001', 'PRO-001', '夏季露营季', '2025-06-01 00:00:00+08', '2025-08-31 23:59:59+08', '金额直减', 100.00, 1000, 423),
('PROMO-002', 'PRO-003', '太阳能套装', '2025-05-15 00:00:00+08', '2025-07-15 23:59:59+08', '捆绑折扣', 150.00, 500, 187),
('PROMO-003', 'PRO-002', '新人专享', '2025-01-01 00:00:00+08', '2025-12-31 23:59:59+08', '百分比折扣', 20.00, NULL, 892),
('PROMO-004', 'PRO-004', '军人优惠', '2025-01-01 00:00:00+08', '2025-12-31 23:59:59+08', '百分比折扣', 15.00, NULL, 156),
('PROMO-005', 'PRO-005', '智能家居套装', '2025-07-01 00:00:00+08', '2025-07-31 23:59:59+08', '捆绑赠品', 0.00, 300, 89),
('PROMO-006', 'PRO-006', '买一送一', '2025-07-10 00:00:00+08', '2025-07-20 23:59:59+08', '买赠', 129.00, 200, 134);

CREATE TABLE product_reviews (
    review_id SERIAL PRIMARY KEY,
    product_id VARCHAR(10) REFERENCES products(product_id),
    average_rating DECIMAL(2,1) NOT NULL,
    total_reviews INTEGER NOT NULL,
    five_star_count INTEGER NOT NULL,
    four_star_count INTEGER NOT NULL,
    three_star_count INTEGER NOT NULL,
    two_star_count INTEGER NOT NULL,
    one_star_count INTEGER NOT NULL,
    last_updated TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO product_reviews (product_id, average_rating, total_reviews, five_star_count, four_star_count, three_star_count, two_star_count, one_star_count) VALUES
('PRO-001', 4.7, 342, 210, 95, 25, 8, 4),
('PRO-002', 4.3, 187, 89, 62, 20, 10, 6),
('PRO-003', 4.5, 276, 150, 85, 30, 7, 4),
('PRO-004', 4.8, 158, 110, 35, 8, 3, 2),
('PRO-005', 4.2, 231, 98, 80, 40, 10, 3),
('PRO-006', 4.6, 412, 250, 120, 30, 8, 4);

CREATE TABLE product_faqs (
    faq_id SERIAL PRIMARY KEY,
    product_id VARCHAR(10) REFERENCES products(product_id),
    question TEXT NOT NULL,
    answer TEXT NOT NULL,
    is_technical BOOLEAN DEFAULT FALSE,
    view_count INTEGER DEFAULT 0,
    last_updated TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 为每个产品插入5-8个FAQ
INSERT INTO product_faqs (product_id, question, answer, is_technical, view_count) VALUES
-- Aurora Pro
('PRO-001', '电池可以带上飞机吗？', '可以，10000mAh符合民航规定，建议随身携带并做好绝缘处理。', FALSE, 1250),
('PRO-001', '极亮模式能持续多久？', '1200流明模式下可持续4小时，建议搭配移动电源使用延长续航。', FALSE, 892),
('PRO-001', '防水性能如何测试？', 'IPX6认证表示可抵抗强力喷水，但请勿长时间浸泡水中。', TRUE, 567),
('PRO-001', '磁吸功能支持哪些表面？', '可吸附在任何铁质金属表面，不锈钢和铝合金属性表面无效。', FALSE, 423),
('PRO-001', '如何更换电池？', '逆时针旋转底部电池仓盖，注意对准红色标记线安装新电池。', TRUE, 678),

-- Aurora Lite
('PRO-002', '重量具体是多少？', '实测198克（含电池），相当于一部智能手机的重量。', FALSE, 342),
('PRO-002', '挂钩最大承重多少？', '设计承重2公斤，建议不要悬挂过重物品。', FALSE, 289),
('PRO-002', '充电接口是什么类型？', 'Type-C接口，支持正反插，但不支持快充协议。', TRUE, 176),
('PRO-002', '有没有SOS功能？', 'Lite款未配备SOS模式，如需此功能建议选择Pro或Tactical款。', FALSE, 98),

-- Aurora Solar
('PRO-003', '太阳能充电需要多久？', '晴天直射约8小时充满，阴天可能需要24小时以上。', FALSE, 587),
('PRO-003', '太阳能板寿命多长？', '单晶硅太阳能板寿命约10年，效率每年衰减约1%。', TRUE, 321),
('PRO-003', '能否边晒边用？', '可以，但会优先使用太阳能电力，电池充电效率会降低。', FALSE, 254),
('PRO-003', '太阳能板如何清洁？', '用软布蘸清水擦拭，避免使用化学清洁剂。', FALSE, 189),

-- Aurora Tactical
('PRO-004', '防爆等级是多少？', '通过MIL-STD-810G军规认证，可承受1.5米跌落和爆破冲击。', TRUE, 432),
('PRO-004', '电池在极端环境下的表现？', '配备低温电池模式，-30℃仍可工作，但续航会降低40%。', TRUE, 287),
('PRO-004', '战术携行包是否标配？', '需单独购买(配件代码ACC-008)，不包含在基础套装中。', FALSE, 156),
('PRO-004', '如何激活隐藏的战术模式？', '同时长按开关和模式键5秒，进入红蓝交替闪烁的战术照明模式。', TRUE, 398),

-- Aurora Home
('PRO-005', '支持哪些智能家居平台？', '兼容HomeKit、Google Home和米家APP，需搭配网关使用。', TRUE, 543),
('PRO-005', '断电后能否自动亮起？', '可以，在APP中开启"应急模式"后，断电时会自动点亮。', FALSE, 421),
('PRO-005', '无线充电功率是多少？', '支持Qi标准10W无线充电，需使用兼容充电板。', TRUE, 287),
('PRO-005', '色温调节范围是多少？', '2700K-6500K无级调节，支持1600万色RGB氛围灯。', TRUE, 365),

-- Aurora Mini
('PRO-006', '钥匙灯防水吗？', 'IPX4防水等级，可防泼溅但不建议浸泡水中。', FALSE, 198),
('PRO-006', '续航时间多长？', '50流明模式下可持续15小时，300流明模式下为2小时。', FALSE, 254),
('PRO-006', '能否更换电池？', '内置不可更换电池，循环充电约500次后容量降至80%。', TRUE, 187),
('PRO-006', '有几种亮度模式？', '3档亮度调节(50/150/300流明)+1档SOS闪烁模式。', FALSE, 132);
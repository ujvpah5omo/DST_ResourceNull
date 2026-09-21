name = "无资源修正"
author = "codex"
version = "0.1.24"
forumthread = ""
api_version = 10
dst_compatible = true
all_clients_require_mod = true
client_only_mod = false
server_filter_tags = { "resource-null-fix" }

description = "修正原版世界设置无法完全实现无资源配置时造成的进度入口缺失。"

configuration_options =
{
    {
        name = "celestial_orb_compensation",
        label = "天体宝球补偿",
        hover = "开启后，关闭陨石且世界没有天体宝球入口时，补一个大陆陨石区的可疑月岩矿。",
        options =
        {
            { description = "开启", data = true, hover = "关闭陨石且没有天体宝球入口时，优先在大陆陨石区或陨石生成器附近补可疑月岩矿；找不到则在出生门附近生成。" },
            { description = "关闭", data = false, hover = "不进行补偿。" },
        },
        default = true,
    },
    {
        name = "lunar_warg_compensation",
        label = "月化座狼补偿",
        hover = "开启后，在新生成的月亮裂隙附近补一个变异座狼检查点。",
        options =
        {
            { description = "开启", data = true, hover = "在月亮裂隙附近生成月化踪迹；调查后在裂隙中心生成变异座狼。" },
            { description = "关闭", data = false, hover = "不补偿变异座狼入口。" },
        },
        default = true,
    },
    {
        name = "beefalo_hunt_surprise",
        label = "小皮弗娄牛狩猎惊喜",
        hover = "春天雨天，狩猎终点位于稀树草原附近时，考拉象改为小皮弗娄牛；座狼或钢羊会额外带出一只被攻击的小牛。",
        options =
        {
            { description = "开启", data = true, hover = "像原版春雨绿洲沙漠必出电羊一样，春雨草原狩猎终点触发小皮弗娄牛惊喜；危险猎物会攻击小牛，需要玩家救援。" },
            { description = "关闭", data = false, hover = "不调整狩猎惊喜。" },
        },
        default = true,
    },
    {
        name = "hunt_cooldown_multiplier",
        label = "狩猎刷新间隔",
        hover = "调整原版狩猎冷却时间；只影响新狩猎刷新间隔，不改变脚印数量和狩猎惊喜概率。",
        options =
        {
            { description = "原版", data = 1, hover = "不调整原版狩猎冷却。" },
            { description = "2 倍", data = 2, hover = "狩猎冷却时间翻倍；例如“较少”约从 2.1-2.7 天变为 4.2-5.4 天。" },
            { description = "3 倍", data = 3, hover = "狩猎冷却时间变为三倍；例如“较少”约从 2.1-2.7 天变为 6.3-8.1 天。" },
        },
        default = 1,
    },
    {
        name = "section_boon_compensation",
        label = "──── 补给奇遇 ────",
        hover = "下面是奖励物资奇遇（boons）的补偿设置。",
        options =
        {
            { description = "────", data = false },
        },
        default = false,
    },
    {
        name = "boon_cooking",
        label = "【补给】烹饪补给奇遇",
        hover = "控制 CookingBoon；可作为无资源设定下的一次性烹饪补偿，会出现锅和烹饪相关物品。",
        options =
        {
            { description = "原版", data = "default", hover = "按原版随机规则生成。" },
            { description = "优先", data = "priority", hover = "不增加补给奇遇数量；原版本轮生成补给奇遇时，优先从设置为优先的补给里随机。" },
            { description = "必出 1 个", data = "required", hover = "世界生成时强制出现 1 个；若加入必出池则不再从随机池重复抽取。" },
            { description = "关闭", data = "off", hover = "移除该奇遇。" },
        },
        default = "default",
    },
    {
        name = "boon_fishing",
        label = "【补给】海钓补给奇遇",
        hover = "控制 FishingBoon；可作为无资源设定下的一次性海钓补偿。",
        options =
        {
            { description = "原版", data = "default", hover = "按原版随机规则生成。" },
            { description = "优先", data = "priority", hover = "不增加补给奇遇数量；原版本轮生成补给奇遇时，优先从设置为优先的补给里随机。" },
            { description = "必出 1 个", data = "required", hover = "世界生成时强制出现 1 个；若加入必出池则不再从随机池重复抽取。" },
            { description = "关闭", data = "off", hover = "移除该奇遇。" },
        },
        default = "default",
    },
    {
        name = "boon_farming",
        label = "【补给】种田补给奇遇",
        hover = "控制 FarmingBoon；可作为无资源设定下的一次性种田补偿。",
        options =
        {
            { description = "原版", data = "default", hover = "按原版随机规则生成。" },
            { description = "优先", data = "priority", hover = "不增加补给奇遇数量；原版本轮生成补给奇遇时，优先从设置为优先的补给里随机。" },
            { description = "必出 1 个", data = "required", hover = "世界生成时强制出现 1 个；若加入必出池则不再从随机池重复抽取。" },
            { description = "关闭", data = "off", hover = "移除该奇遇。" },
        },
        default = "default",
    },
    {
        name = "boon_level2_wood",
        label = "【补给】二级木材补给奇遇",
        hover = "控制 Level2WoodBoon；可作为无资源设定下的一次性木材补偿。",
        options =
        {
            { description = "原版", data = "default", hover = "按原版随机规则生成。" },
            { description = "优先", data = "priority", hover = "不增加补给奇遇数量；原版本轮生成补给奇遇时，优先从设置为优先的补给里随机。" },
            { description = "必出 1 个", data = "required", hover = "世界生成时强制出现 1 个；若加入必出池则不再从随机池重复抽取。" },
            { description = "关闭", data = "off", hover = "移除该奇遇。" },
        },
        default = "default",
    },
    {
        name = "boon_level2_rock",
        label = "【补给】二级石材补给奇遇",
        hover = "控制 Level2RockBoon；可作为无资源设定下的一次性石材补偿。",
        options =
        {
            { description = "原版", data = "default", hover = "按原版随机规则生成。" },
            { description = "优先", data = "priority", hover = "不增加补给奇遇数量；原版本轮生成补给奇遇时，优先从设置为优先的补给里随机。" },
            { description = "必出 1 个", data = "required", hover = "世界生成时强制出现 1 个；若加入必出池则不再从随机池重复抽取。" },
            { description = "关闭", data = "off", hover = "移除该奇遇。" },
        },
        default = "default",
    },
    {
        name = "boon_level2_grass",
        label = "【补给】二级草补给奇遇",
        hover = "控制 Level2GrassBoon；可作为无资源设定下的一次性草类补偿。",
        options =
        {
            { description = "原版", data = "default", hover = "按原版随机规则生成。" },
            { description = "优先", data = "priority", hover = "不增加补给奇遇数量；原版本轮生成补给奇遇时，优先从设置为优先的补给里随机。" },
            { description = "必出 1 个", data = "required", hover = "世界生成时强制出现 1 个；若加入必出池则不再从随机池重复抽取。" },
            { description = "关闭", data = "off", hover = "移除该奇遇。" },
        },
        default = "default",
    },
    {
        name = "section_skeleton_compensation",
        label = "──── 骸骨奇遇 ────",
        hover = "下面是骸骨兴趣点奇遇（pointsofinterest）的补偿设置。",
        options =
        {
            { description = "────", data = false },
        },
        default = false,
    },
    {
        name = "setpiece_skeleton_trapper",
        label = "【骸骨】捕猎者骸骨",
        hover = "控制 skeleton_trapper；优先时不增加兴趣点数量，只在原版生成兴趣点时优先进入候选池。",
        options =
        {
            { description = "原版", data = "default", hover = "按原版兴趣点池随机生成。" },
            { description = "优先", data = "priority", hover = "原版本轮生成兴趣点时，优先从设置为优先的骸骨奇遇里随机。" },
            { description = "必出 1 个", data = "required", hover = "世界生成时强制出现 1 个；若加入必出池则不再从兴趣点随机池重复抽取。" },
            { description = "关闭", data = "off", hover = "移除该骸骨奇遇。" },
        },
        default = "default",
    },
    {
        name = "setpiece_skeleton_entomologist",
        label = "【骸骨】昆虫学家骸骨",
        hover = "控制 skeleton_entomologist；优先时不增加兴趣点数量，只在原版生成兴趣点时优先进入候选池。",
        options =
        {
            { description = "原版", data = "default", hover = "按原版兴趣点池随机生成。" },
            { description = "优先", data = "priority", hover = "原版本轮生成兴趣点时，优先从设置为优先的骸骨奇遇里随机。" },
            { description = "必出 1 个", data = "required", hover = "世界生成时强制出现 1 个；若加入必出池则不再从兴趣点随机池重复抽取。" },
            { description = "关闭", data = "off", hover = "移除该骸骨奇遇。" },
        },
        default = "default",
    },
    {
        name = "setpiece_skeleton_miner_dirt",
        label = "【骸骨】泥地矿工骸骨",
        hover = "控制 skeleton_miner_dirt；会生成树精，优先时可作为少量活木补充来源。",
        options =
        {
            { description = "原版", data = "default", hover = "按原版兴趣点池随机生成。" },
            { description = "优先", data = "priority", hover = "原版本轮生成兴趣点时，优先从设置为优先的骸骨奇遇里随机。" },
            { description = "必出 1 个", data = "required", hover = "世界生成时强制出现 1 个；若加入必出池则不再从兴趣点随机池重复抽取。" },
            { description = "关闭", data = "off", hover = "移除该骸骨奇遇。" },
        },
        default = "default",
    },
    {
        name = "setpiece_skeleton_miner",
        label = "【骸骨】矿工骸骨",
        hover = "控制 skeleton_miner；优先时不增加兴趣点数量，只在原版生成兴趣点时优先进入候选池。",
        options =
        {
            { description = "原版", data = "default", hover = "按原版兴趣点池随机生成。" },
            { description = "优先", data = "priority", hover = "原版本轮生成兴趣点时，优先从设置为优先的骸骨奇遇里随机。" },
            { description = "必出 1 个", data = "required", hover = "世界生成时强制出现 1 个；若加入必出池则不再从兴趣点随机池重复抽取。" },
            { description = "关闭", data = "off", hover = "移除该骸骨奇遇。" },
        },
        default = "default",
    },
    {
        name = "setpiece_skeleton_camper",
        label = "【骸骨】露营者骸骨",
        hover = "控制 skeleton_camper；优先时不增加兴趣点数量，只在原版生成兴趣点时优先进入候选池。",
        options =
        {
            { description = "原版", data = "default", hover = "按原版兴趣点池随机生成。" },
            { description = "优先", data = "priority", hover = "原版本轮生成兴趣点时，优先从设置为优先的骸骨奇遇里随机。" },
            { description = "必出 1 个", data = "required", hover = "世界生成时强制出现 1 个；若加入必出池则不再从兴趣点随机池重复抽取。" },
            { description = "关闭", data = "off", hover = "移除该骸骨奇遇。" },
        },
        default = "default",
    },
    {
        name = "setpiece_skeleton_construction",
        label = "【骸骨】建造者骸骨",
        hover = "控制 skeleton_construction；优先时不增加兴趣点数量，只在原版生成兴趣点时优先进入候选池。",
        options =
        {
            { description = "原版", data = "default", hover = "按原版兴趣点池随机生成。" },
            { description = "优先", data = "priority", hover = "原版本轮生成兴趣点时，优先从设置为优先的骸骨奇遇里随机。" },
            { description = "必出 1 个", data = "required", hover = "世界生成时强制出现 1 个；若加入必出池则不再从兴趣点随机池重复抽取。" },
            { description = "关闭", data = "off", hover = "移除该骸骨奇遇。" },
        },
        default = "default",
    },
    {
        name = "setpiece_skeleton_night_hunter",
        label = "【骸骨】夜猎者骸骨",
        hover = "控制 skeleton_night_hunter；优先时不增加兴趣点数量，只在原版生成兴趣点时优先进入候选池。",
        options =
        {
            { description = "原版", data = "default", hover = "按原版兴趣点池随机生成。" },
            { description = "优先", data = "priority", hover = "原版本轮生成兴趣点时，优先从设置为优先的骸骨奇遇里随机。" },
            { description = "必出 1 个", data = "required", hover = "世界生成时强制出现 1 个；若加入必出池则不再从兴趣点随机池重复抽取。" },
            { description = "关闭", data = "off", hover = "移除该骸骨奇遇。" },
        },
        default = "default",
    },
    {
        name = "setpiece_skeleton_rain_coat",
        label = "【骸骨】雨具骸骨",
        hover = "控制 skeleton_rain_coat；优先时不增加兴趣点数量，只在原版生成兴趣点时优先进入候选池。",
        options =
        {
            { description = "原版", data = "default", hover = "按原版兴趣点池随机生成。" },
            { description = "优先", data = "priority", hover = "原版本轮生成兴趣点时，优先从设置为优先的骸骨奇遇里随机。" },
            { description = "必出 1 个", data = "required", hover = "世界生成时强制出现 1 个；若加入必出池则不再从兴趣点随机池重复抽取。" },
            { description = "关闭", data = "off", hover = "移除该骸骨奇遇。" },
        },
        default = "default",
    },
    {
        name = "setpiece_skeleton_winter_hard",
        label = "【骸骨】困难冬季骸骨",
        hover = "控制 skeleton_winter_hard；优先时不增加兴趣点数量，只在原版生成兴趣点时优先进入候选池。",
        options =
        {
            { description = "原版", data = "default", hover = "按原版兴趣点池随机生成。" },
            { description = "优先", data = "priority", hover = "原版本轮生成兴趣点时，优先从设置为优先的骸骨奇遇里随机。" },
            { description = "必出 1 个", data = "required", hover = "世界生成时强制出现 1 个；若加入必出池则不再从兴趣点随机池重复抽取。" },
            { description = "关闭", data = "off", hover = "移除该骸骨奇遇。" },
        },
        default = "default",
    },
    {
        name = "section_disabled_resource_setpieces",
        label = "──── 禁用奇遇 ────",
        hover = "下面是影响无资源设定的资源奇遇开关。",
        options =
        {
            { description = "────", data = false },
        },
        default = false,
    },
    {
        name = "setpiece_leif_forest",
        label = "树精森林奇遇",
        hover = "控制树精守护森林；该布局会生成大量树和树精。",
        options =
        {
            { description = "开启", data = true, hover = "保留树精森林。" },
            { description = "关闭", data = false, hover = "移除树精森林，避免额外树木和活木入口。" },
        },
        default = true,
    },
    {
        name = "setpiece_spider_forest",
        label = "蜘蛛森林奇遇",
        hover = "控制蜘蛛守护森林；该布局会生成蜘蛛巢和树。",
        options =
        {
            { description = "开启", data = true, hover = "保留蜘蛛森林。" },
            { description = "关闭", data = false, hover = "移除蜘蛛森林，避免蜘蛛巢资源入口。" },
        },
        default = true,
    },
    {
        name = "setpiece_pigguard_berries",
        label = "猪人守卫浆果奇遇",
        hover = "控制猪人守卫浆果布局；会生成浆果丛。",
        options =
        {
            { description = "开启", data = true, hover = "保留猪人守卫浆果布局。" },
            { description = "关闭", data = false, hover = "移除该布局，避免额外浆果丛。" },
        },
        default = true,
    },
    {
        name = "setpiece_pigguard_berries_easy",
        label = "简单猪人守卫浆果奇遇",
        hover = "控制简单版猪人守卫浆果布局；会生成浆果丛。",
        options =
        {
            { description = "开启", data = true, hover = "保留简单猪人守卫浆果布局。" },
            { description = "关闭", data = false, hover = "移除该布局，避免额外浆果丛。" },
        },
        default = true,
    },
    {
        name = "setpiece_pigguard_grass",
        label = "猪人守卫草奇遇",
        hover = "控制猪人守卫草丛布局；会生成草丛。",
        options =
        {
            { description = "开启", data = true, hover = "保留猪人守卫草布局。" },
            { description = "关闭", data = false, hover = "移除该布局，避免额外草丛。" },
        },
        default = true,
    },
    {
        name = "setpiece_pigguard_grass_easy",
        label = "简单猪人守卫草奇遇",
        hover = "控制简单版猪人守卫草丛布局；会生成草丛。",
        options =
        {
            { description = "开启", data = true, hover = "保留简单猪人守卫草布局。" },
            { description = "关闭", data = false, hover = "移除该布局，避免额外草丛。" },
        },
        default = true,
    },
    {
        name = "setpiece_wasphive_grass_easy",
        label = "蜂巢草地奇遇",
        hover = "控制杀人蜂巢守草布局；会生成草丛和杀人蜂巢。",
        options =
        {
            { description = "开启", data = true, hover = "保留蜂巢草地布局。" },
            { description = "关闭", data = false, hover = "移除该布局，避免草丛和蜂巢入口。" },
        },
        default = true,
    },
    {
        name = "setpiece_tenticle_reeds",
        label = "触手芦苇奇遇",
        hover = "控制触手守芦苇布局；会生成大量芦苇。",
        options =
        {
            { description = "开启", data = true, hover = "保留触手芦苇布局。" },
            { description = "关闭", data = false, hover = "移除该布局，避免额外芦苇入口。" },
        },
        default = true,
    },
    {
        name = "setpiece_tallbird_rocks",
        label = "高脚鸟岩石奇遇",
        hover = "控制高脚鸟守岩石布局；会生成高脚鸟巢。",
        options =
        {
            { description = "开启", data = true, hover = "保留高脚鸟岩石布局。" },
            { description = "关闭", data = false, hover = "移除该布局，避免高脚鸟巢入口。" },
        },
        default = true,
    },
    {
        name = "setpiece_hound_rocks",
        label = "猎犬丘岩石奇遇",
        hover = "控制猎犬丘守岩石布局；会生成猎犬丘。",
        options =
        {
            { description = "开启", data = true, hover = "保留猎犬丘岩石布局。" },
            { description = "关闭", data = false, hover = "移除该布局，避免猎犬丘入口。" },
        },
        default = true,
    },
    {
        name = "setpiece_rotted_base",
        label = "腐烂营地资源奇遇",
        hover = "控制腐烂营地；该布局会生成池塘、芦苇和针刺树。",
        options =
        {
            { description = "开启", data = true, hover = "保留腐烂营地。" },
            { description = "关闭", data = false, hover = "移除腐烂营地，避免池塘和芦苇入口。" },
        },
        default = true,
    },
    {
        name = "setpiece_beefalo_farm",
        label = "牛农场草丛奇遇",
        hover = "控制牛农场陷阱布局；该布局会生成少量草丛。",
        options =
        {
            { description = "开启", data = true, hover = "保留牛农场布局。" },
            { description = "关闭", data = false, hover = "移除该布局，避免额外草丛。" },
        },
        default = true,
    },
    {
        name = "setpiece_sleeping_spider",
        label = "睡蜘蛛植物陷阱",
        hover = "控制睡觉蜘蛛陷阱；该布局会生成草丛、树苗和多枝树。",
        options =
        {
            { description = "开启", data = true, hover = "保留睡觉蜘蛛陷阱。" },
            { description = "关闭", data = false, hover = "移除该布局，避免额外草丛、树苗和多枝树。" },
        },
        default = true,
    },
    {
        name = "setpiece_chilled_base",
        label = "冰冻营地植物奇遇",
        hover = "控制冰冻营地；该布局会生成少量草、树苗和树。",
        options =
        {
            { description = "开启", data = true, hover = "保留冰冻营地。" },
            { description = "关闭", data = false, hover = "移除该布局，避免额外植物资源。" },
        },
        default = true,
    },
    {
        name = "setpiece_dev_graveyard",
        label = "墓地树木奇遇",
        hover = "控制开发者墓地；该布局会生成树和恶魔花。",
        options =
        {
            { description = "开启", data = true, hover = "保留开发者墓地。" },
            { description = "关闭", data = false, hover = "移除该布局，避免额外树木和恶魔花。" },
        },
        default = true,
    },
    {
        name = "setpiece_skeleton_researchlab1",
        label = "科技站废墟 1 奇遇",
        hover = "控制科技站废墟 1；会生成树和农场建筑。",
        options =
        {
            { description = "开启", data = true, hover = "保留科技站废墟 1。" },
            { description = "关闭", data = false, hover = "移除该布局，避免额外树木和农场建筑。" },
        },
        default = true,
    },
    {
        name = "setpiece_skeleton_researchlab2",
        label = "科技站废墟 2 奇遇",
        hover = "控制科技站废墟 2；会生成树。",
        options =
        {
            { description = "开启", data = true, hover = "保留科技站废墟 2。" },
            { description = "关闭", data = false, hover = "移除该布局，避免额外树木。" },
        },
        default = true,
    },
    {
        name = "setpiece_skeleton_researchlab3",
        label = "科技站废墟 3 奇遇",
        hover = "控制科技站废墟 3；会生成浆果丛、树苗、蜂箱和树。",
        options =
        {
            { description = "开启", data = true, hover = "保留科技站废墟 3。" },
            { description = "关闭", data = false, hover = "移除该布局，避免浆果丛、树苗、蜂箱和树木入口。" },
        },
        default = true,
    },
    {
        name = "setpiece_skeleton_hunter_swamp",
        label = "沼泽猎人触手奇遇",
        hover = "控制沼泽猎人骸骨；该布局会生成触手。",
        options =
        {
            { description = "开启", data = true, hover = "保留沼泽猎人触手布局。" },
            { description = "关闭", data = false, hover = "移除该布局，避免触手掉落入口。" },
        },
        default = true,
    },
    {
        name = "setpiece_skeleton_wizard_ice",
        label = "冰法师骸骨树木奇遇",
        hover = "控制冰法师骸骨中的树木布局。",
        options =
        {
            { description = "开启", data = true, hover = "保留冰法师骸骨树木。" },
            { description = "关闭", data = false, hover = "移除该布局，避免额外树木。" },
        },
        default = true,
    },
    {
        name = "setpiece_skeleton_wizard_fire",
        label = "火法师骸骨树木奇遇",
        hover = "控制火法师骸骨中的树木布局。",
        options =
        {
            { description = "开启", data = true, hover = "保留火法师骸骨树木。" },
            { description = "关闭", data = false, hover = "移除该布局，避免额外树木。" },
        },
        default = true,
    },
    {
        name = "setpiece_skeleton_lightfarmer",
        label = "荧光花农夫骸骨奇遇",
        hover = "控制洞穴泥地的发光农夫骸骨；会生成荧光花、双朵荧光花和三朵荧光花。",
        options =
        {
            { description = "开启", data = true, hover = "保留荧光花农夫骸骨布局。" },
            { description = "关闭", data = false, hover = "移除该布局，避免额外荧光花入口。" },
        },
        default = true,
    },
    {
        name = "setpiece_lures_and_worms",
        label = "发光浆果蠕虫奇遇",
        hover = "控制洞穴泥地的发光浆果与蠕虫守护布局；会生成发光浆果植株和洞穴蠕虫生成点。",
        options =
        {
            { description = "开启", data = true, hover = "保留发光浆果蠕虫布局。" },
            { description = "关闭", data = false, hover = "移除该布局，避免发光浆果植株和洞穴蠕虫入口。" },
        },
        default = true,
    },
}

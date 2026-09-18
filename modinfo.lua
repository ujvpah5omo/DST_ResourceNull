name = "无资源修正"
author = "codex"
version = "0.1.17"
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
        hover = "春天雨天，狩猎终点位于稀树草原附近时，必定出现一只小皮弗娄牛。",
        options =
        {
            { description = "开启", data = true, hover = "像原版春雨绿洲沙漠必出电羊一样，春雨草原狩猎终点必出一只小皮弗娄牛。" },
            { description = "关闭", data = false, hover = "不调整狩猎惊喜。" },
        },
        default = true,
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
        name = "setpiece_skeleton_miner_dirt",
        label = "泥地矿工树精奇遇",
        hover = "控制泥地矿工骸骨；该布局会生成树精。",
        options =
        {
            { description = "开启", data = true, hover = "保留泥地矿工树精布局。" },
            { description = "关闭", data = false, hover = "移除该布局，避免活木入口。" },
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
}

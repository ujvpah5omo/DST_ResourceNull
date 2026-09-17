name = "无资源修正"
author = "codex"
version = "0.1.12"
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
        name = "worldgen_boon_setpieces",
        label = "奖励骸骨奇遇",
        hover = "控制原版奖励骸骨/开局资源堆一类奇遇，关闭后新世界不生成这些额外物资。",
        options =
        {
            { description = "开启", data = true, hover = "保留原版奖励骸骨奇遇。" },
            { description = "关闭", data = false, hover = "移除奖励骸骨奇遇，避免额外工具、材料和装备。" },
        },
        default = true,
    },
    {
        name = "worldgen_trap_setpieces",
        label = "陷阱奇遇",
        hover = "控制原版陷阱类奇遇，如法杖猎犬、腐烂营地、冰冻营地等。",
        options =
        {
            { description = "开启", data = true, hover = "保留原版陷阱奇遇。" },
            { description = "关闭", data = false, hover = "移除陷阱奇遇及其附带资源。" },
        },
        default = true,
    },
    {
        name = "worldgen_point_setpieces",
        label = "兴趣点奇遇",
        hover = "控制原版兴趣点类奇遇。",
        options =
        {
            { description = "开启", data = true, hover = "保留原版兴趣点奇遇。" },
            { description = "关闭", data = false, hover = "移除兴趣点奇遇。" },
        },
        default = true,
    },
    {
        name = "worldgen_protected_resource_setpieces",
        label = "受保护资源奇遇",
        hover = "控制原版受保护资源类奇遇，关闭后新世界不生成这些额外资源点。",
        options =
        {
            { description = "开启", data = true, hover = "保留原版受保护资源奇遇。" },
            { description = "关闭", data = false, hover = "移除受保护资源奇遇。" },
        },
        default = true,
    },
    {
        name = "worldgen_random_setpieces",
        label = "随机奇遇",
        hover = "控制原版随机布局奇遇。",
        options =
        {
            { description = "开启", data = true, hover = "保留原版随机奇遇。" },
            { description = "关闭", data = false, hover = "移除随机奇遇。" },
        },
        default = true,
    },
    {
        name = "worldgen_fixed_setpieces",
        label = "额外固定奇遇",
        hover = "控制额外固定布局奇遇；洞穴入口、月岛祭坛、隐士岛等关键入口会保留。",
        options =
        {
            { description = "开启", data = true, hover = "保留原版额外固定奇遇。" },
            { description = "关闭", data = false, hover = "移除非关键固定奇遇，保留必要进度入口。" },
        },
        default = true,
    },
}

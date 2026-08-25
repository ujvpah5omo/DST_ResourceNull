name = "无资源修正"
author = "codex"
version = "0.1.0"
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
        label = "关闭陨石：天体宝球补偿",
        hover = "当检测到陨石雨关闭时，补一个天体宝球入口。",
        options =
        {
            { description = "关闭", data = "off", hover = "不进行补偿。" },
            { description = "自动：可疑石头", data = "auto_boulder", hover = "关闭陨石时，优先在陨石地形生成可疑月岩矿；找不到则在出生门附近生成。" },
            { description = "总是：可疑石头", data = "always_boulder", hover = "优先在陨石地形生成可疑月岩矿；找不到则在出生门附近生成。" },
        },
        default = "auto_boulder",
    },
    {
        name = "lunar_warg_compensation",
        label = "关闭狩猎：裂隙座狼补偿",
        hover = "当狩猎关闭且月亮裂隙开启后，在新生成的月亮裂隙附近补一个变异座狼检查点。",
        options =
        {
            { description = "关闭", data = "off", hover = "不补偿变异座狼入口。" },
            { description = "自动：月化踪迹", data = "auto_clue", hover = "狩猎关闭时，在月亮裂隙附近生成月化踪迹。" },
            { description = "总是：月化踪迹", data = "always_clue", hover = "在月亮裂隙附近生成月化踪迹，不检测狩猎设置。" },
        },
        default = "auto_clue",
    },
    {
        name = "beefalo_hunt_surprise",
        label = "皮弗娄牛狩猎惊喜",
        hover = "春天雨天，狩猎终点位于稀树草原时，按电羊世界设置的概率出现皮弗娄牛。",
        options =
        {
            { description = "开启", data = true, hover = "按电羊设置概率，把草原狩猎终点的考拉象替换为皮弗娄牛。" },
            { description = "关闭", data = false, hover = "不调整狩猎惊喜。" },
        },
        default = true,
    },
}

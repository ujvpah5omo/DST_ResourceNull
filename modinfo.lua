name = "无资源修正"
author = "codex"
version = "0.1.10"
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

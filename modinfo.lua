local mod_locale = locale or "en"
local is_zh = mod_locale == "zh" or mod_locale == "zhr" or mod_locale == "zht" or mod_locale == "chs" or mod_locale == "cht"

local function Text(zh, en)
    return is_zh and zh or en
end

local function Hover(zh, en)
    return Text(zh, en)
end

local function OnOffOptions(on_zh, on_en, off_zh, off_en)
    return
    {
        { description = Text("开启", "On"), data = true, hover = Hover(on_zh, on_en) },
        { description = Text("关闭", "Off"), data = false, hover = Hover(off_zh, off_en) },
    }
end

local function BoonOptions()
    return
    {
        { description = Text("原版", "Default"), data = "default", hover = Hover("按原版随机规则生成。", "Use the vanilla random spawn rules.") },
        { description = Text("优先", "Priority"), data = "priority", hover = Hover("不增加补给奇遇数量；原版本轮生成补给奇遇时，优先从设置为优先的补给里随机。", "Does not add extra boon setpieces. When vanilla would spawn a boon, it prefers the boon setpieces marked as Priority.") },
        { description = Text("必出 1 个", "Force 1"), data = "required", hover = Hover("世界生成时强制出现 1 个；若加入必出池则不再从随机池重复抽取。", "Forces one copy during world generation. Once forced, it is removed from the random pool to avoid duplicates.") },
        { description = Text("关闭", "Off"), data = "off", hover = Hover("移除该奇遇。", "Removes this setpiece.") },
    }
end

local function SkeletonOptions()
    return
    {
        { description = Text("原版", "Default"), data = "default", hover = Hover("按原版兴趣点池随机生成。", "Use the vanilla point-of-interest random pool.") },
        { description = Text("优先", "Priority"), data = "priority", hover = Hover("原版本轮生成兴趣点时，优先从设置为优先的骸骨奇遇里随机。", "When vanilla would spawn a point of interest, it prefers skeleton setpieces marked as Priority.") },
        { description = Text("必出 1 个", "Force 1"), data = "required", hover = Hover("世界生成时强制出现 1 个；若加入必出池则不再从兴趣点随机池重复抽取。", "Forces one copy during world generation. Once forced, it is removed from the point-of-interest random pool to avoid duplicates.") },
        { description = Text("关闭", "Off"), data = "off", hover = Hover("移除该骸骨奇遇。", "Removes this skeleton setpiece.") },
    }
end

name = Text("无资源设定修正", "Resource Null Fix")
author = "Codex"
version = "0.1.27"
forumthread = "https://steamcommunity.com/sharedfiles/filedetails/?id=3789775647"
api_version = 10
api_version_dst = 10
dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false
hamlet_compatible = false
all_clients_require_mod = true
client_only_mod = false
server_only_mod = false
priority = 0
icon_atlas = "modicon.xml"
icon = "modicon.tex"
server_filter_tags = { "resource-null-fix", "resource-null", "worldgen", "setpiece", "dst" }

description = Text([[
修正原版世界设置无法完全实现无资源配置时造成的进度入口缺失，并提供部分会影响无资源设定的奇遇控制。

主要功能：
- 关闭陨石时补偿天体宝球入口。
- 月亮裂隙后补偿月化座狼入口。
- 春季雨天草原狩猎可触发小皮弗娄牛惊喜。
- 可调整狩猎刷新间隔。
- 可控制补给、骸骨和资源类奇遇的原版、优先、必出或关闭状态。

Steam Workshop:
https://steamcommunity.com/sharedfiles/filedetails/?id=3789775647
]], [[
Fixes progression gaps that vanilla world settings can create when building a resource-null world, and adds controls for setpieces that may affect resource-null rules.

Features:
- Compensates the Celestial Orb entry when meteors are disabled.
- Adds a lunar warg entry after lunar rifts become available.
- Adds a spring-rain savanna hunt surprise with a baby beefalo.
- Allows longer hunt refresh intervals.
- Controls boon, skeleton, and resource-related setpieces with Default, Priority, Force 1, or Off modes.

Steam Workshop:
https://steamcommunity.com/sharedfiles/filedetails/?id=3789775647
]])

configuration_options =
{
    {
        name = "celestial_orb_compensation",
        label = Text("天体宝球补偿", "Celestial Orb Compensation"),
        hover = Hover("开启后，关闭陨石且世界没有天体宝球入口时，补一个大陆陨石区的可疑月岩矿。", "When enabled, if meteors are disabled and the world has no Celestial Orb entry, adds a suspicious moonrock boulder in a mainland meteor area."),
        options = OnOffOptions(
            "关闭陨石且没有天体宝球入口时，优先在大陆陨石区或陨石生成器附近补可疑月岩矿；找不到则在出生门附近生成。",
            "If meteors are disabled and no Celestial Orb entry exists, tries mainland meteor areas or meteor spawners first; falls back near the portal if needed.",
            "不进行补偿。",
            "Do not add this compensation."
        ),
        default = true,
    },
    {
        name = "lunar_warg_compensation",
        label = Text("月化座狼补偿", "Lunar Warg Compensation"),
        hover = Hover("开启后，在新生成的月亮裂隙附近补一个变异座狼检查点。", "When enabled, adds a mutated warg clue near newly generated lunar rifts."),
        options = OnOffOptions(
            "在月亮裂隙附近生成月化踪迹；调查后在裂隙中心生成变异座狼。",
            "Spawns a lunar trail near a lunar rift. Investigating it spawns a mutated warg at the rift center.",
            "不补偿变异座狼入口。",
            "Do not add a mutated warg entry."
        ),
        default = true,
    },
    {
        name = "beefalo_hunt_surprise",
        label = Text("小皮弗娄牛狩猎惊喜", "Baby Beefalo Hunt Surprise"),
        hover = Hover("春天雨天，狩猎终点位于稀树草原附近时，考拉象改为小皮弗娄牛；座狼或钢羊会额外带出一只被攻击的小牛。", "In spring rain, if the final hunt point is near savanna, koalefants become baby beefalo; wargs or spats also bring a baby beefalo they attack."),
        options = OnOffOptions(
            "像原版春雨绿洲沙漠必出电羊一样，春雨草原狩猎终点触发小皮弗娄牛惊喜；危险猎物会攻击小牛，需要玩家救援。",
            "Like the vanilla spring-rain oasis volt goat surprise, spring-rain savanna hunts trigger a baby beefalo surprise. Dangerous prey attack the baby, so players must rescue it.",
            "不调整狩猎惊喜。",
            "Do not change hunt surprises."
        ),
        default = true,
    },
    {
        name = "hunt_cooldown_multiplier",
        label = Text("狩猎刷新间隔", "Hunt Refresh Interval"),
        hover = Hover("调整原版狩猎冷却时间；只影响新狩猎刷新间隔，不改变脚印数量和狩猎惊喜概率。", "Adjusts vanilla hunt cooldown. Only affects how often new hunts refresh, not track count or surprise chance."),
        options =
        {
            { description = Text("原版", "Default"), data = 1, hover = Hover("不调整原版狩猎冷却。", "Do not change vanilla hunt cooldown.") },
            { description = Text("2 倍", "2x"), data = 2, hover = Hover("狩猎冷却时间翻倍；例如“较少”约从 2.1-2.7 天变为 4.2-5.4 天。", "Doubles hunt cooldown. For example, Rare changes from about 2.1-2.7 days to 4.2-5.4 days.") },
            { description = Text("3 倍", "3x"), data = 3, hover = Hover("狩猎冷却时间变为三倍；例如“较少”约从 2.1-2.7 天变为 6.3-8.1 天。", "Triples hunt cooldown. For example, Rare changes from about 2.1-2.7 days to 6.3-8.1 days.") },
        },
        default = 1,
    },
    {
        name = "section_boon_compensation",
        label = Text("──── 补给奇遇 ────", "──── Boon Setpieces ────"),
        hover = Hover("下面是奖励物资奇遇（boons）的补偿设置。", "Settings below control boon setpiece compensation."),
        options = { { description = "────", data = false } },
        default = false,
    },
    {
        name = "boon_cooking",
        label = Text("【补给】烹饪补给奇遇", "[Boon] Cooking Supplies"),
        hover = Hover("控制烹饪补给奇遇；可作为无资源设定下的一次性烹饪补偿。物品/备注：食谱卡 x2、烹饪书、腐烂食物/鱼；会给成品锅。", "Controls the cooking boon. Can be a one-time cooking compensation in resource-null worlds. Items/notes: 2 recipe cards, cookbook, spoiled food/fish, and a built crock pot."),
        options = BoonOptions(),
        default = "default",
    },
    {
        name = "boon_fishing",
        label = Text("【补给】海钓补给奇遇", "[Boon] Ocean Fishing Supplies"),
        hover = Hover("控制海钓补给奇遇；可作为无资源设定下的一次性海钓补偿。物品/备注：海钓竿、浮标/拟饵、腐烂小鱼、饰品。", "Controls the ocean fishing boon. Can be a one-time fishing compensation in resource-null worlds. Items/notes: sea fishing rod, floats/lures, spoiled fish, trinkets."),
        options = BoonOptions(),
        default = "default",
    },
    {
        name = "boon_farming",
        label = Text("【补给】种田补给奇遇", "[Boon] Farming Supplies"),
        hover = Hover("控制种田补给奇遇；可作为无资源设定下的一次性种田补偿。物品/备注：耕地机物品、植物登记帽、粪肥、鸟粪、腐烂食物。", "Controls the farming boon. Can be a one-time farming compensation in resource-null worlds. Items/notes: garden digamajig item, plant registry hat, manure, guano, spoiled food."),
        options = BoonOptions(),
        default = "default",
    },
    {
        name = "boon_level2_wood",
        label = Text("【补给】二级木材补给奇遇", "[Boon] Level 2 Wood Supplies"),
        hover = Hover("控制二级木材补给奇遇；可作为无资源设定下的一次性木材补偿。物品/备注：木甲/斧头、木板。", "Controls the level 2 wood boon. Can be a one-time wood compensation in resource-null worlds. Items/notes: log suit/axe, boards."),
        options = BoonOptions(),
        default = "default",
    },
    {
        name = "boon_level2_rock",
        label = Text("【补给】二级石材补给奇遇", "[Boon] Level 2 Rock Supplies"),
        hover = Hover("控制二级石材补给奇遇；可作为无资源设定下的一次性石材补偿。物品/备注：镐子、石头、火药、石砖。", "Controls the level 2 rock boon. Can be a one-time stone compensation in resource-null worlds. Items/notes: pickaxe, rocks, gunpowder, cut stone."),
        options = BoonOptions(),
        default = "default",
    },
    {
        name = "boon_level2_grass",
        label = Text("【补给】二级草补给奇遇", "[Boon] Level 2 Grass Supplies"),
        hover = Hover("控制二级草补给奇遇；可作为无资源设定下的一次性草类补偿。物品/备注：火把/陷阱、绳子。", "Controls the level 2 grass boon. Can be a one-time grass-material compensation in resource-null worlds. Items/notes: torch/trap, rope."),
        options = BoonOptions(),
        default = "default",
    },
    {
        name = "section_skeleton_compensation",
        label = Text("──── 骸骨奇遇 ────", "──── Skeleton Setpieces ────"),
        hover = Hover("下面是骸骨兴趣点奇遇（pointsofinterest）的补偿设置。", "Settings below control skeleton point-of-interest compensation."),
        options = { { description = "────", data = false } },
        default = false,
    },
    {
        name = "setpiece_skeleton_trapper",
        label = Text("【骸骨】捕猎者骸骨", "[Skeleton] Trapper"),
        hover = Hover("控制捕猎者骸骨；优先时不增加兴趣点数量，只在原版生成兴趣点时优先进入候选池。物品/备注：捕鸟陷阱、陷阱、蓝图、灌木帽、绳子、腐烂食物。", "Controls the trapper skeleton. Priority does not add extra points of interest; it only affects vanilla POI selection. Items/notes: bird trap, trap, blueprint, bush hat, rope, spoiled food."),
        options = SkeletonOptions(),
        default = "default",
    },
    {
        name = "setpiece_skeleton_entomologist",
        label = Text("【骸骨】昆虫学家骸骨", "[Skeleton] Entomologist"),
        hover = Hover("控制昆虫学家骸骨；优先时不增加兴趣点数量，只在原版生成兴趣点时优先进入候选池。物品/备注：捕虫网、蜂帽、蜂雷、蓝图、蜂刺。", "Controls the entomologist skeleton. Priority does not add extra points of interest; it only affects vanilla POI selection. Items/notes: bug net, beekeeper hat, bee mine, blueprint, stingers."),
        options = SkeletonOptions(),
        default = "default",
    },
    {
        name = "setpiece_skeleton_miner_dirt",
        label = Text("【骸骨】泥地矿工骸骨", "[Skeleton] Dirt Miner"),
        hover = Hover("控制泥地矿工骸骨；会生成树精，优先时可作为少量活木补充来源。物品/备注：金块、矿工帽、镐子、石头；树精 x4。", "Controls the dirt miner skeleton. It spawns treeguards and can provide a small living log source in Priority mode. Items/notes: gold nuggets, miner hat, pickaxe, rocks; 4 treeguards."),
        options = SkeletonOptions(),
        default = "default",
    },
    {
        name = "setpiece_skeleton_miner",
        label = Text("【骸骨】矿工骸骨", "[Skeleton] Miner"),
        hover = Hover("控制矿工骸骨；优先时不增加兴趣点数量，只在原版生成兴趣点时优先进入候选池。物品/备注：金块、矿工帽、镐子、石头。", "Controls the miner skeleton. Priority does not add extra points of interest; it only affects vanilla POI selection. Items/notes: gold nuggets, miner hat, pickaxe, rocks."),
        options = SkeletonOptions(),
        default = "default",
    },
    {
        name = "setpiece_skeleton_camper",
        label = Text("【骸骨】露营者骸骨", "[Skeleton] Camper"),
        hover = Hover("控制露营者骸骨；优先时不增加兴趣点数量，只在原版生成兴趣点时优先进入候选池。物品/备注：背包、草席卷、绳子、腐烂食物、草帽。", "Controls the camper skeleton. Priority does not add extra points of interest; it only affects vanilla POI selection. Items/notes: backpack, straw roll, rope, spoiled food, straw hat."),
        options = SkeletonOptions(),
        default = "default",
    },
    {
        name = "setpiece_skeleton_construction",
        label = Text("【骸骨】建造者骸骨", "[Skeleton] Builder"),
        hover = Hover("控制建造者骸骨；优先时不增加兴趣点数量，只在原版生成兴趣点时优先进入候选池。物品/备注：蓝图、木板、石砖、橄榄球头盔、锤子、绳子。", "Controls the builder skeleton. Priority does not add extra points of interest; it only affects vanilla POI selection. Items/notes: blueprint, boards, cut stone, football helmet, hammer, rope."),
        options = SkeletonOptions(),
        default = "default",
    },
    {
        name = "setpiece_skeleton_night_hunter",
        label = Text("【骸骨】夜猎者骸骨", "[Skeleton] Night Hunter"),
        hover = Hover("控制夜猎者骸骨；优先时不增加兴趣点数量，只在原版生成兴趣点时优先进入候选池。物品/备注：木甲、鼹鼠帽、晨星。", "Controls the night hunter skeleton. Priority does not add extra points of interest; it only affects vanilla POI selection. Items/notes: log suit, moggles, morning star."),
        options = SkeletonOptions(),
        default = "default",
    },
    {
        name = "setpiece_skeleton_rain_coat",
        label = Text("【骸骨】雨具骸骨", "[Skeleton] Rain Gear"),
        hover = Hover("控制雨具骸骨；优先时不增加兴趣点数量，只在原版生成兴趣点时优先进入候选池。物品/备注：草、猪皮、雨衣、雨帽。", "Controls the rain gear skeleton. Priority does not add extra points of interest; it only affects vanilla POI selection. Items/notes: cut grass, pig skin, rain coat, rain hat."),
        options = SkeletonOptions(),
        default = "default",
    },
    {
        name = "setpiece_skeleton_winter_hard",
        label = Text("【骸骨】困难冬季骸骨", "[Skeleton] Harsh Winter"),
        hover = Hover("控制困难冬季骸骨；优先时不增加兴趣点数量，只在原版生成兴趣点时优先进入候选池。物品/备注：蓝图、冬象背心。", "Controls the harsh winter skeleton. Priority does not add extra points of interest; it only affects vanilla POI selection. Items/notes: blueprint, puffy vest."),
        options = SkeletonOptions(),
        default = "default",
    },
    {
        name = "section_disabled_resource_setpieces",
        label = Text("──── 禁用奇遇 ────", "──── Disable Setpieces ────"),
        hover = Hover("下面是影响无资源设定的资源奇遇开关。", "Settings below toggle resource-related setpieces that can affect resource-null worlds."),
        options = { { description = "────", data = false } },
        default = false,
    },
    {
        name = "setpiece_leif_forest",
        label = Text("树精森林奇遇", "Treeguard Forest"),
        hover = Hover("控制树精守护森林；该布局会生成大量树和树精。物品/备注：常青树 x41、树精 x10。", "Controls the treeguard forest. This layout spawns many trees and treeguards. Items/notes: 41 evergreen trees, 10 treeguards."),
        options = OnOffOptions("保留树精森林。", "Keep the treeguard forest.", "移除树精森林，避免额外树木和活木入口。", "Remove it to avoid extra trees and living-log access."),
        default = true,
    },
    {
        name = "setpiece_spider_forest",
        label = Text("蜘蛛森林奇遇", "Spider Forest"),
        hover = Hover("控制蜘蛛守护森林；该布局会生成蜘蛛巢和树。物品/备注：蜘蛛巢 x12、大量常青树。", "Controls the spider forest. This layout spawns spider dens and trees. Items/notes: 12 spider dens, many evergreen trees."),
        options = OnOffOptions("保留蜘蛛森林。", "Keep the spider forest.", "移除蜘蛛森林，避免蜘蛛巢资源入口。", "Remove it to avoid spider den resource access."),
        default = true,
    },
    {
        name = "setpiece_pigguard_berries",
        label = Text("猪人守卫浆果奇遇", "Pig Guarded Berries"),
        hover = Hover("控制猪人守卫浆果布局；会生成浆果丛。物品/备注：浆果丛 x20、多汁浆果丛 x12、猪人火炬 x8。", "Controls the pig-guarded berry layout. It spawns berry bushes. Items/notes: 20 berry bushes, 12 juicy berry bushes, 8 pig torches."),
        options = OnOffOptions("保留猪人守卫浆果布局。", "Keep the pig-guarded berry layout.", "移除该布局，避免额外浆果丛。", "Remove it to avoid extra berry bushes."),
        default = true,
    },
    {
        name = "setpiece_pigguard_berries_easy",
        label = Text("简单猪人守卫浆果奇遇", "Easy Pig Guarded Berries"),
        hover = Hover("控制简单版猪人守卫浆果布局；会生成浆果丛。物品/备注：浆果丛 x22、多汁浆果丛 x16、猪人火炬 x1。", "Controls the easy pig-guarded berry layout. It spawns berry bushes. Items/notes: 22 berry bushes, 16 juicy berry bushes, 1 pig torch."),
        options = OnOffOptions("保留简单猪人守卫浆果布局。", "Keep the easy pig-guarded berry layout.", "移除该布局，避免额外浆果丛。", "Remove it to avoid extra berry bushes."),
        default = true,
    },
    {
        name = "setpiece_pigguard_grass",
        label = Text("猪人守卫草奇遇", "Pig Guarded Grass"),
        hover = Hover("控制猪人守卫草丛布局；会生成草丛。物品/备注：草丛 x50、猪人火炬 x8。", "Controls the pig-guarded grass layout. It spawns grass tufts. Items/notes: 50 grass tufts, 8 pig torches."),
        options = OnOffOptions("保留猪人守卫草布局。", "Keep the pig-guarded grass layout.", "移除该布局，避免额外草丛。", "Remove it to avoid extra grass tufts."),
        default = true,
    },
    {
        name = "setpiece_pigguard_grass_easy",
        label = Text("简单猪人守卫草奇遇", "Easy Pig Guarded Grass"),
        hover = Hover("控制简单版猪人守卫草丛布局；会生成草丛。物品/备注：草丛 x44、猪人火炬 x4。", "Controls the easy pig-guarded grass layout. It spawns grass tufts. Items/notes: 44 grass tufts, 4 pig torches."),
        options = OnOffOptions("保留简单猪人守卫草布局。", "Keep the easy pig-guarded grass layout.", "移除该布局，避免额外草丛。", "Remove it to avoid extra grass tufts."),
        default = true,
    },
    {
        name = "setpiece_wasphive_grass_easy",
        label = Text("蜂巢草地奇遇", "Killer Bee Grass"),
        hover = Hover("控制杀人蜂巢守草布局；会生成草丛和杀人蜂巢。物品/备注：草丛 x46、杀人蜂巢 x3。", "Controls the killer-bee-guarded grass layout. It spawns grass tufts and killer bee hives. Items/notes: 46 grass tufts, 3 killer bee hives."),
        options = OnOffOptions("保留蜂巢草地布局。", "Keep the killer bee grass layout.", "移除该布局，避免草丛和蜂巢入口。", "Remove it to avoid grass tuft and bee hive access."),
        default = true,
    },
    {
        name = "setpiece_tenticle_reeds",
        label = Text("触手芦苇奇遇", "Tentacle Reeds"),
        hover = Hover("控制触手守芦苇布局；会生成大量芦苇。物品/备注：芦苇 x55、触手 x76。", "Controls the tentacle-guarded reed layout. It spawns many reeds. Items/notes: 55 reeds, 76 tentacles."),
        options = OnOffOptions("保留触手芦苇布局。", "Keep the tentacle reed layout.", "移除该布局，避免额外芦苇入口。", "Remove it to avoid extra reed access."),
        default = true,
    },
    {
        name = "setpiece_tallbird_rocks",
        label = Text("高脚鸟岩石奇遇", "Tallbird Rocks"),
        hover = Hover("控制高脚鸟守岩石布局；会生成高脚鸟巢。物品/备注：高脚鸟巢 x17、岩石/矿石。", "Controls the tallbird-guarded rock layout. It spawns tallbird nests. Items/notes: 17 tallbird nests, rocks/minerals."),
        options = OnOffOptions("保留高脚鸟岩石布局。", "Keep the tallbird rock layout.", "移除该布局，避免高脚鸟巢入口。", "Remove it to avoid tallbird nest access."),
        default = true,
    },
    {
        name = "setpiece_hound_rocks",
        label = Text("猎犬丘岩石奇遇", "Hound Rocks"),
        hover = Hover("控制猎犬丘守岩石布局；会生成猎犬丘。物品/备注：猎犬丘 x10、岩石/矿石。", "Controls the hound-mound rock layout. It spawns hound mounds. Items/notes: 10 hound mounds, rocks/minerals."),
        options = OnOffOptions("保留猎犬丘岩石布局。", "Keep the hound rock layout.", "移除该布局，避免猎犬丘入口。", "Remove it to avoid hound mound access."),
        default = true,
    },
    {
        name = "setpiece_rotted_base",
        label = Text("腐烂营地资源奇遇", "Rotted Base"),
        hover = Hover("控制腐烂营地；该布局会生成池塘、芦苇和针刺树。物品/备注：箱子、猪头、腐烂食物、骸骨。", "Controls the rotted base. This layout spawns ponds, reeds, and twiggy trees. Items/notes: chest, pig heads, spoiled food, skeletons."),
        options = OnOffOptions("保留腐烂营地。", "Keep the rotted base.", "移除腐烂营地，避免池塘和芦苇入口。", "Remove it to avoid pond and reed access."),
        default = true,
    },
    {
        name = "setpiece_beefalo_farm",
        label = Text("牛农场草丛奇遇", "Beefalo Farm"),
        hover = Hover("控制牛农场陷阱布局；该布局会生成少量草丛。物品/备注：木墙、箱子、牛毛、猪头、骨头。", "Controls the beefalo farm trap layout. It spawns a small number of grass tufts. Items/notes: wood walls, chest, beefalo wool, pig heads, bones."),
        options = OnOffOptions("保留牛农场布局。", "Keep the beefalo farm layout.", "移除该布局，避免额外草丛。", "Remove it to avoid extra grass tufts."),
        default = true,
    },
    {
        name = "setpiece_sleeping_spider",
        label = Text("睡蜘蛛植物陷阱", "Sleeping Spider Trap"),
        hover = Hover("控制睡觉蜘蛛陷阱；该布局会生成草丛、树苗和多枝树。物品/备注：蜘蛛战士、干草墙、猪头、骨头。", "Controls the sleeping spider trap. This layout spawns grass tufts, saplings, and twiggy trees. Items/notes: spider warrior, hay walls, pig heads, bones."),
        options = OnOffOptions("保留睡觉蜘蛛陷阱。", "Keep the sleeping spider trap.", "移除该布局，避免额外草丛、树苗和多枝树。", "Remove it to avoid extra grass tufts, saplings, and twiggy trees."),
        default = true,
    },
    {
        name = "setpiece_chilled_base",
        label = Text("冰冻营地植物奇遇", "Chilled Base"),
        hover = Hover("控制冰冻营地；该布局会生成少量草、树苗和树。物品/备注：草丛、树苗、树。", "Controls the chilled base. This layout spawns some grass, saplings, and trees. Items/notes: grass tufts, saplings, trees."),
        options = OnOffOptions("保留冰冻营地。", "Keep the chilled base.", "移除该布局，避免额外植物资源。", "Remove it to avoid extra plant resources."),
        default = true,
    },
    {
        name = "setpiece_dev_graveyard",
        label = Text("墓地树木奇遇", "Dev Graveyard"),
        hover = Hover("控制开发者墓地；该布局会生成树和恶魔花。物品/备注：大理石柱、麦斯威尔雕像、铲子。", "Controls the developer graveyard. This layout spawns trees and evil flowers. Items/notes: marble pillars, Maxwell statues, shovel."),
        options = OnOffOptions("保留开发者墓地。", "Keep the developer graveyard.", "移除该布局，避免额外树木和恶魔花。", "Remove it to avoid extra trees and evil flowers."),
        default = true,
    },
    {
        name = "setpiece_skeleton_researchlab1",
        label = Text("科技站废墟 1 奇遇", "Science Ruins 1"),
        hover = Hover("控制科技站废墟 1；会生成树和农场建筑。物品/备注：箱子、草帽、干草叉；有成品科技站。", "Controls science ruins 1. It spawns trees and farm structures. Items/notes: chest, straw hat, pitchfork; includes a built science machine."),
        options = OnOffOptions("保留科技站废墟 1。", "Keep science ruins 1.", "移除该布局，避免额外树木和农场建筑。", "Remove it to avoid extra trees and farm structures."),
        default = true,
    },
    {
        name = "setpiece_skeleton_researchlab2",
        label = Text("科技站废墟 2 奇遇", "Science Ruins 2"),
        hover = Hover("控制科技站废墟 2；会生成树。物品/备注：牛帽、斧头、猪头、木墙；有成品科技站。", "Controls science ruins 2. It spawns trees. Items/notes: beefalo hat, axe, pig heads, wood walls; includes a built science machine."),
        options = OnOffOptions("保留科技站废墟 2。", "Keep science ruins 2.", "移除该布局，避免额外树木。", "Remove it to avoid extra trees."),
        default = true,
    },
    {
        name = "setpiece_skeleton_researchlab3",
        label = Text("科技站废墟 3 奇遇", "Science Ruins 3"),
        hover = Hover("控制科技站废墟 3；会生成浆果丛、树苗、蜂箱和树。物品/备注：箱子、金镐、矿工帽、石墙；这是有锅的彩蛋之一。", "Controls science ruins 3. It spawns berry bushes, saplings, bee boxes, and trees. Items/notes: chest, golden pickaxe, miner hat, stone walls; one of the crock-pot setpieces."),
        options = OnOffOptions("保留科技站废墟 3。", "Keep science ruins 3.", "移除该布局，避免浆果丛、树苗、蜂箱和树木入口。", "Remove it to avoid berry bush, sapling, bee box, and tree access."),
        default = true,
    },
    {
        name = "setpiece_skeleton_hunter_swamp",
        label = Text("沼泽猎人触手奇遇", "Swamp Hunter"),
        hover = Hover("控制沼泽猎人骸骨；该布局会生成触手。物品/备注：牛帽、牛毛、骨头、狗牙、长矛；触手 x19。", "Controls the swamp hunter skeleton. This layout spawns tentacles. Items/notes: beefalo hat, beefalo wool, bones, hound teeth, spear; 19 tentacles."),
        options = OnOffOptions("保留沼泽猎人触手布局。", "Keep the swamp hunter tentacle layout.", "移除该布局，避免触手掉落入口。", "Remove it to avoid tentacle drop access."),
        default = true,
    },
    {
        name = "setpiece_skeleton_wizard_ice",
        label = Text("冰法师骸骨树木奇遇", "Ice Wizard Skeleton"),
        hover = Hover("控制冰法师骸骨中的树木布局。物品/备注：冰杖、胡须、骨头、冬象背心。", "Controls the tree layout in the ice wizard skeleton setpiece. Items/notes: ice staff, beard hair, bones, puffy vest."),
        options = OnOffOptions("保留冰法师骸骨树木。", "Keep the ice wizard skeleton trees.", "移除该布局，避免额外树木。", "Remove it to avoid extra trees."),
        default = true,
    },
    {
        name = "setpiece_skeleton_wizard_fire",
        label = Text("火法师骸骨树木奇遇", "Fire Wizard Skeleton"),
        hover = Hover("控制火法师骸骨中的树木布局。物品/备注：火杖、灰烬、胡须、火药、骨头。", "Controls the tree layout in the fire wizard skeleton setpiece. Items/notes: fire staff, ash, beard hair, gunpowder, bones."),
        options = OnOffOptions("保留火法师骸骨树木。", "Keep the fire wizard skeleton trees.", "移除该布局，避免额外树木。", "Remove it to avoid extra trees."),
        default = true,
    },
    {
        name = "setpiece_skeleton_lightfarmer",
        label = Text("荧光花农夫骸骨奇遇", "Light Flower Farmer"),
        hover = Hover("控制洞穴泥地的发光农夫骸骨；会生成荧光花、双朵荧光花和三朵荧光花。物品/备注：灯笼、干草叉。", "Controls the muddy cave light-flower farmer skeleton. It spawns light flowers, double light flowers, and triple light flowers. Items/notes: lantern, pitchfork."),
        options = OnOffOptions("保留荧光花农夫骸骨布局。", "Keep the light-flower farmer layout.", "移除该布局，避免额外荧光花入口。", "Remove it to avoid extra light flower access."),
        default = true,
    },
    {
        name = "setpiece_lures_and_worms",
        label = Text("发光浆果蠕虫奇遇", "Lures and Worms"),
        hover = Hover("控制洞穴泥地的发光浆果与蠕虫守护布局；会生成发光浆果植株和洞穴蠕虫生成点。物品/备注：发光浆果植株、蠕虫生成点。", "Controls the muddy cave glow berry and worm-guarded layout. It spawns glow berry plants and cave worm spawners. Items/notes: glow berry plants, worm spawners."),
        options = OnOffOptions("保留发光浆果蠕虫布局。", "Keep the lures and worms layout.", "移除该布局，避免发光浆果植株和洞穴蠕虫入口。", "Remove it to avoid glow berry plant and cave worm access."),
        default = true,
    },
}

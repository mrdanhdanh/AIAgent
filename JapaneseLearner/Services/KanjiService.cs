using Blazored.LocalStorage;
using JapaneseLearner.Models;

namespace JapaneseLearner.Services;

public class KanjiService : IKanjiService
{
    private readonly ILocalStorageService _storage;
    private const string StorageKey = "japanese_kanji";
    private List<JapaneseKanji>? _cache;
    private int _nextId;

    public KanjiService(ILocalStorageService storage)
    {
        _storage = storage;
    }

    private async Task<List<JapaneseKanji>> GetCachedAsync(IProgress<int>? progress = null)
    {
        if (_cache != null)
        {
            progress?.Report(100);
            return _cache;
        }

        progress?.Report(10);
        var stored = await _storage.GetItemAsync<List<JapaneseKanji>>(StorageKey);
        progress?.Report(40);

        if (stored != null && stored.Count > 0)
        {
            _cache = stored;
            _nextId = _cache.Max(c => c.Id) + 1;
            progress?.Report(100);
            return _cache;
        }

        progress?.Report(50);
        _cache = GetDefaultData(progress);
        _nextId = _cache.Count + 1;
        progress?.Report(90);
        await _storage.SetItemAsync(StorageKey, _cache);
        progress?.Report(100);
        return _cache;
    }

    public async Task<List<JapaneseKanji>> GetAllAsync(IProgress<int>? progress = null)
    {
        return await GetCachedAsync(progress);
    }

    public async Task<JapaneseKanji?> GetByIdAsync(int id)
    {
        var all = await GetCachedAsync();
        return all.FirstOrDefault(k => k.Id == id);
    }

    public async Task<List<JapaneseKanji>> GetByLevelAsync(string level)
    {
        var all = await GetCachedAsync();
        if (level == "All")
            return all;
        return all.Where(k => k.JLPTLevel == level).ToList();
    }

    public async Task AddAsync(JapaneseKanji k)
    {
        var list = await GetCachedAsync();
        k.Id = _nextId++;
        list.Add(k);
        await _storage.SetItemAsync(StorageKey, list);
    }

    public async Task UpdateAsync(JapaneseKanji k)
    {
        var list = await GetCachedAsync();
        var idx = list.FindIndex(x => x.Id == k.Id);
        if (idx >= 0)
        {
            list[idx] = k;
            await _storage.SetItemAsync(StorageKey, list);
        }
    }

    public async Task DeleteAsync(int id)
    {
        var list = await GetCachedAsync();
        list.RemoveAll(x => x.Id == id);
        await _storage.SetItemAsync(StorageKey, list);
    }

    private static List<JapaneseKanji> GetDefaultData(IProgress<int>? progress = null)
    {
        var list = new List<JapaneseKanji>();
        int id = 1;

        void Add(string kanji, string onYomi, string kunYomi, string meaning, int strokes, string jlpt, string[]? examples = null)
        {
            list.Add(new JapaneseKanji
            {
                Id = id++,
                Kanji = kanji,
                OnYomi = onYomi,
                KunYomi = kunYomi,
                Meaning = meaning,
                StrokeCount = strokes,
                JLPTLevel = jlpt,
                Examples = examples?.ToList() ?? new List<string>(),
                Strokes = new List<string>()
            });
        }

        // Numbers
        Add("一", "イチ・イツ", "ひと・ひと.つ", "một", 1, "N5", new[] { "一つ(ひとつ)", "一人(ひとり)", "一月(いちがつ)" });
        Add("二", "ニ", "ふた・ふた.つ", "hai", 2, "N5", new[] { "二つ(ふたつ)", "二人(ふたり)", "二月(にがつ)" });
        Add("三", "サン", "み・み.つ", "ba", 3, "N5", new[] { "三つ(みっつ)", "三人(さんにん)", "三月(さんがつ)" });
        Add("四", "シ", "よ・よ.つ・よっ.つ", "bốn", 5, "N5", new[] { "四つ(よっつ)", "四人(よにん)", "四月(しがつ)" });
        Add("五", "ゴ", "いつ・いつ.つ", "năm", 4, "N5", new[] { "五つ(いつつ)", "五人(ごにん)", "五月(ごがつ)" });
        Add("六", "ロク", "む・む.つ", "sáu", 4, "N5", new[] { "六つ(むっつ)", "六月(ろくがつ)" });
        Add("七", "シチ", "なな・なな.つ・なの", "bảy", 2, "N5", new[] { "七つ(ななつ)", "七月(しちがつ)" });
        Add("八", "ハチ", "や・や.つ", "tám", 2, "N5", new[] { "八つ(やっつ)", "八月(はちがつ)" });
        Add("九", "キュウ・ク", "ここの・ここの.つ", "chín", 2, "N5", new[] { "九つ(ここのつ)", "九月(くがつ)" });
        Add("十", "ジュウ", "とお", "mười", 2, "N5", new[] { "十(じゅう)", "十月(じゅうがつ)" });
        Add("百", "ヒャク", "もも", "trăm", 6, "N5", new[] { "百(ひゃく)", "三百(さんびゃく)" });
        Add("千", "セン", "ち", "ngàn", 3, "N5", new[] { "千(せん)", "千円(せんえん)" });
        Add("万", "マン・バン", "よろず", "vạn", 3, "N5", new[] { "一万(いちまん)", "万年(まんねん)" });

        // Time
        Add("年", "ネン", "とし", "năm (tuổi)", 6, "N5", new[] { "今年(ことし)", "去年(きょねん)", "一年生(いちねんせい)" });
        Add("月", "ゲツ・ガツ", "つき", "tháng, mặt trăng", 4, "N5", new[] { "一月(いちがつ)", "月曜日(げつようび)" });
        Add("日", "ニチ・ジツ", "ひ・か", "ngày, mặt trời", 4, "N5", new[] { "日曜日(にちようび)", "毎日(まいにち)" });
        Add("時", "ジ", "とき", "thời gian, giờ", 10, "N5", new[] { "時間(じかん)", "時計(とけい)" });
        Add("分", "ブン・フン", "わ.ける", "phút, chia", 4, "N5", new[] { "十分(じゅっぷん)", "自分(じぶん)" });
        Add("半", "ハン", "なか.ば", "một nửa", 5, "N5", new[] { "半分(はんぶん)", "三時半(さんじはん)" });
        Add("今", "コン・キン", "いま", "bây giờ, hiện tại", 4, "N5", new[] { "今日(きょう)", "今週(こんしゅう)" });
        Add("毎", "マイ", "ごと", "mỗi", 6, "N5", new[] { "毎日(まいにち)", "毎週(まいしゅう)" });
        Add("週", "シュウ", "", "tuần", 11, "N5", new[] { "今週(こんしゅう)", "毎週(まいしゅう)" });
        Add("間", "カン・ケン", "あいだ・ま", "khoảng, giữa", 12, "N5", new[] { "時間(じかん)", "間(あいだ)" });

        // People
        Add("人", "ジン・ニン", "ひと", "người", 2, "N5", new[] { "日本人(にほんじん)", "一人(ひとり)" });
        Add("子", "シ・ス", "こ", "trẻ em", 3, "N5", new[] { "子供(こども)", "女の子(おんなのこ)" });
        Add("女", "ジョ・ニョ", "おんな・め", "phụ nữ, nữ giới", 3, "N5", new[] { "女の人(おんなのひと)", "女性(じょせい)" });
        Add("男", "ダン・ナン", "おとこ", "đàn ông, nam giới", 7, "N5", new[] { "男の人(おとこのひと)", "男性(だんせい)" });
        Add("父", "フ", "ちち", "cha", 4, "N5", new[] { "お父さん(おとうさん)", "父(ちち)" });
        Add("母", "ボ", "はは", "mẹ", 5, "N5", new[] { "お母さん(おかあさん)", "母(はは)" });
        Add("友", "ユウ", "とも", "bạn bè", 4, "N5", new[] { "友達(ともだち)", "友人(ゆうじん)" });

        // Places
        Add("学", "ガク", "まな.ぶ", "học", 8, "N5", new[] { "学校(がっこう)", "学生(がくせい)" });
        Add("校", "コウ", "", "trường", 10, "N5", new[] { "学校(がっこう)", "校長(こうちょう)" });
        Add("国", "コク", "くに", "đất nước", 8, "N5", new[] { "外国(がいこく)", "日本(にほん)" });
        Add("家", "カ・ケ", "いえ・や", "nhà, gia đình", 10, "N5", new[] { "家(いえ)", "家族(かぞく)" });
        Add("店", "テン", "みせ", "cửa hàng", 8, "N5", new[] { "店(みせ)", "喫茶店(きっさてん)" });
        Add("駅", "エキ", "", "ga tàu", 14, "N5", new[] { "駅(えき)", "駅前(えきまえ)" });
        Add("会", "カイ・エ", "あ.う", "gặp gỡ, hội", 6, "N5", new[] { "会社(かいしゃ)", "会う(あう)" });
        Add("社", "シャ", "やしろ", "công ty", 7, "N5", new[] { "会社(かいしゃ)", "神社(じんじゃ)" });
        Add("病", "ビョウ", "や.む", "bệnh", 10, "N5", new[] { "病気(びょうき)", "病院(びょういん)" });
        Add("院", "イン", "", "viện", 10, "N5", new[] { "病院(びょういん)", "医院(いいん)" });

        // Nature
        Add("山", "サン・ザン", "やま", "núi", 3, "N5", new[] { "山(やま)", "富士山(ふじさん)" });
        Add("川", "セン", "かわ", "sông", 3, "N5", new[] { "川(かわ)", "小川(おがわ)" });
        Add("林", "リン", "はやし", "rừng (nhỏ)", 8, "N5", new[] { "林(はやし)", "森林(しんりん)" });
        Add("森", "シン", "もり", "rừng (lớn)", 12, "N5", new[] { "森(もり)", "森林(しんりん)" });
        Add("空", "クウ", "そら・あ.く", "bầu trời, trống", 8, "N5", new[] { "空(そら)", "空気(くうき)" });
        Add("天", "テン", "あめ・あま", "trời", 4, "N5", new[] { "天気(てんき)", "天国(てんごく)" });
        Add("気", "キ・ケ", "いき", "không khí, tinh thần", 6, "N5", new[] { "天気(てんき)", "元気(げんき)" });
        Add("雨", "ウ", "あめ・あま", "mưa", 8, "N5", new[] { "雨(あめ)", "雨天(うてん)" });
        Add("雪", "セツ", "ゆき", "tuyết", 11, "N5", new[] { "雪(ゆき)", "大雪(おおゆき)" });
        Add("花", "カ", "はな", "hoa", 7, "N5", new[] { "花(はな)", "花見(はなみ)" });
        Add("火", "カ", "ひ・ほ", "lửa", 4, "N5", new[] { "火曜日(かようび)", "火事(かじ)" });
        Add("水", "スイ", "みず", "nước", 4, "N5", new[] { "水(みず)", "水曜日(すいようび)" });
        Add("金", "キン・コン", "かね・かな", "vàng, tiền", 8, "N5", new[] { "お金(おかね)", "金曜日(きんようび)" });
        Add("土", "ド・ト", "つち", "đất", 3, "N5", new[] { "土曜日(どようび)", "土地(とち)" });
        Add("木", "モク・ボク", "き・こ", "cây, gỗ", 4, "N5", new[] { "木(き)", "木曜日(もくようび)" });

        // Directions
        Add("上", "ジョウ", "うえ・あ.げる", "trên", 3, "N5", new[] { "上(うえ)", "上手(じょうず)" });
        Add("下", "カ・ゲ", "した・さ.げる", "dưới", 3, "N5", new[] { "下(した)", "下手(へた)" });
        Add("左", "サ", "ひだり", "trái", 5, "N5", new[] { "左(ひだり)", "左手(ひだりて)" });
        Add("右", "ウ・ユウ", "みぎ", "phải", 5, "N5", new[] { "右(みぎ)", "右手(みぎて)" });
        Add("東", "トウ", "ひがし", "phía đông", 8, "N5", new[] { "東(ひがし)", "東京(とうきょう)" });
        Add("西", "セイ・サイ", "にし", "phía tây", 6, "N5", new[] { "西(にし)", "西口(にしぐち)" });
        Add("南", "ナン", "みなみ", "phía nam", 9, "N5", new[] { "南(みなみ)", "南口(みなみぐち)" });
        Add("北", "ホク", "きた", "phía bắc", 5, "N5", new[] { "北(きた)", "北口(きたぐち)" });
        Add("前", "ゼン", "まえ", "trước", 9, "N5", new[] { "前(まえ)", "名前(なまえ)" });
        Add("後", "ゴ・コウ", "あと・うし.ろ", "sau, phía sau", 9, "N5", new[] { "後(あと)", "午後(ごご)" });
        Add("中", "チュウ", "なか", "trong, giữa", 4, "N5", new[] { "中(なか)", "中国(ちゅうごく)" });
        Add("外", "ガイ・ゲ", "そと・ほか", "ngoài", 5, "N5", new[] { "外(そと)", "外国(がいこく)" });

        // Actions
        Add("見", "ケン", "み.る", "nhìn, xem", 7, "N5", new[] { "見る(みる)", "花見(はなみ)" });
        Add("聞", "ブン・モン", "き.く", "nghe, hỏi", 14, "N5", new[] { "聞く(きく)", "新聞(しんぶん)" });
        Add("話", "ワ", "はな.す", "nói chuyện", 13, "N5", new[] { "話す(はなす)", "電話(でんわ)" });
        Add("読", "ドク・トク", "よ.む", "đọc", 14, "N5", new[] { "読む(よむ)", "読書(どくしょ)" });
        Add("書", "ショ", "か.く", "viết, sách", 10, "N5", new[] { "書く(かく)", "辞書(じしょ)" });
        Add("食", "ショク・ジキ", "た.べる", "ăn, thực phẩm", 9, "N5", new[] { "食べる(たべる)", "食事(しょくじ)" });
        Add("飲", "イン", "の.む", "uống", 12, "N5", new[] { "飲む(のむ)", "飲食(いんしょく)" });
        Add("行", "コウ・ギョウ", "い.く", "đi", 6, "N5", new[] { "行く(いく)", "銀行(ぎんこう)" });
        Add("来", "ライ", "く.る・きた.る", "đến", 7, "N5", new[] { "来る(くる)", "由来(ゆらい)" });
        Add("帰", "キ", "かえ.る", "về nhà", 10, "N5", new[] { "帰る(かえる)", "帰国(きこく)" });
        Add("入", "ニュウ", "い.る・はい.る", "vào", 2, "N5", new[] { "入る(はいる)", "入口(いりぐち)" });
        Add("出", "シュツ・スイ", "で.る", "ra", 5, "N5", new[] { "出る(でる)", "出口(でぐち)" });
        Add("立", "リツ・リュウ", "た.つ", "đứng", 5, "N5", new[] { "立つ(たつ)", "立派(りっぱ)" });
        Add("休", "キュウ", "やす.む", "nghỉ ngơi", 6, "N5", new[] { "休む(やすむ)", "休日(きゅうじつ)" });
        Add("買", "バイ", "か.う", "mua", 12, "N5", new[] { "買う(かう)", "買い物(かいもの)" });
        Add("売", "バイ", "う.る", "bán", 7, "N5", new[] { "売る(うる)", "売店(ばいてん)" });

        // Adjectives
        Add("大", "ダイ・タイ", "おお.きい", "lớn", 3, "N5", new[] { "大きい(おおきい)", "大学(だいがく)" });
        Add("小", "ショウ", "ちい.さい・こ", "nhỏ", 3, "N5", new[] { "小さい(ちいさい)", "小学校(しょうがっこう)" });
        Add("高", "コウ", "たか.い", "cao, đắt", 10, "N5", new[] { "高い(たかい)", "高校(こうこう)" });
        Add("低", "テイ", "ひく.い", "thấp", 7, "N5", new[] { "低い(ひくい)", "最低(さいてい)" });
        Add("長", "チョウ", "なが.い", "dài", 8, "N5", new[] { "長い(ながい)", "校長(こうちょう)" });
        Add("新", "シン", "あたら.しい", "mới", 13, "N5", new[] { "新しい(あたらしい)", "新聞(しんぶん)" });
        Add("古", "コ", "ふる.い", "cũ", 5, "N5", new[] { "古い(ふるい)", "中古(ちゅうこ)" });
        Add("多", "タ", "おお.い", "nhiều", 6, "N5", new[] { "多い(おおい)", "多分(たぶん)" });
        Add("少", "ショウ", "すく.ない", "ít", 4, "N5", new[] { "少ない(すくない)", "少し(すこし)" });
        Add("安", "アン", "やす.い", "rẻ, an toàn", 6, "N5", new[] { "安い(やすい)", "安心(あんしん)" });
        Add("白", "ハク・ビャク", "しろ・しろ.い", "trắng", 5, "N5", new[] { "白い(しろい)", "白髪(しらが)" });
        Add("黒", "コク", "くろ・くろ.い", "đen", 11, "N5", new[] { "黒い(くろい)", "黒板(こくばん)" });
        Add("赤", "セキ・シャク", "あか・あか.い", "đỏ", 7, "N5", new[] { "赤い(あかい)", "赤ちゃん(あかちゃん)" });
        Add("青", "セイ・ショウ", "あお・あお.い", "xanh", 8, "N5", new[] { "青い(あおい)", "青空(あおぞら)" });

        // Others
        Add("名", "メイ・ミョウ", "な", "tên", 6, "N5", new[] { "名前(なまえ)", "有名(ゆうめい)" });
        Add("何", "カ", "なに・なん", "cái gì", 7, "N5", new[] { "何(なに)", "何人(なんにん)" });
        Add("電", "デン", "", "điện", 13, "N5", new[] { "電話(でんわ)", "電車(でんしゃ)" });
        Add("車", "シャ", "くるま", "xe", 7, "N5", new[] { "車(くるま)", "電車(でんしゃ)" });
        Add("道", "ドウ・トウ", "みち", "đường", 12, "N5", new[] { "道(みち)", "道路(どうろ)" });
        Add("語", "ゴ", "かた.る", "ngôn ngữ", 14, "N5", new[] { "日本語(にほんご)", "単語(たんご)" });
        Add("本", "ホン", "もと", "sách, gốc", 5, "N5", new[] { "日本(にほん)", "本(ほん)" });
        Add("文", "ブン・モン", "ふみ", "văn bản, câu", 4, "N5", new[] { "文学(ぶんがく)", "文字(もじ)" });
        Add("円", "エン", "まる.い", "yên (tiền), tròn", 4, "N5", new[] { "千円(せんえん)", "円(まる)" });
        Add("肉", "ニク", "", "thịt", 6, "N5", new[] { "肉(にく)", "牛肉(ぎゅうにく)" });
        Add("魚", "ギョ", "うお・さかな", "cá", 11, "N5", new[] { "魚(さかな)", "金魚(きんぎょ)" });
        Add("茶", "チャ・サ", "", "trà", 9, "N5", new[] { "お茶(おちゃ)", "茶色(ちゃいろ)" });
        Add("員", "イン", "", "thành viên", 10, "N5", new[] { "店員(てんいん)", "社員(しゃいん)" });
        Add("曜", "ヨウ", "", "thứ (ngày)", 18, "N5", new[] { "日曜日(にちようび)", "月曜日(げつようび)" });
        Add("勉", "ベン", "つと.める", "cố gắng", 10, "N5", new[] { "勉強(べんきょう)", "勉学(べんがく)" });
        Add("強", "キョウ・ゴウ", "つよ.い", "mạnh", 11, "N5", new[] { "勉強(べんきょう)", "強い(つよい)" });
        Add("運", "ウン", "はこ.ぶ", "vận chuyển", 12, "N5", new[] { "運動(うんどう)", "運転(うんてん)" });
        Add("動", "ドウ", "うご.く", "di chuyển", 11, "N5", new[] { "動物(どうぶつ)", "運動(うんどう)" });
        Add("教", "キョウ", "おし.える", "dạy", 11, "N5", new[] { "教室(きょうしつ)", "教える(おしえる)" });
        Add("室", "シツ", "むろ", "phòng", 9, "N5", new[] { "教室(きょうしつ)", "室内(しつない)" });
        Add("駅", "エキ", "", "ga tàu", 14, "N5", new[] { "駅(えき)", "駅員(えきいん)" });
        Add("医", "イ", "い.やす", "y tế", 7, "N5", new[] { "医者(いしゃ)", "医学(いがく)" });
        Add("者", "シャ", "もの", "người", 8, "N5", new[] { "医者(いしゃ)", "作者(さくしゃ)" });

        return list;
    }
}

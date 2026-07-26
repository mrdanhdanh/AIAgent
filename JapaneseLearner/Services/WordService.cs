using Blazored.LocalStorage;
using JapaneseLearner.Models;

namespace JapaneseLearner.Services;

public class WordService : IWordService
{
    private readonly ILocalStorageService _storage;
    private const string StorageKey = "japanese_words";
    private List<JapaneseWord>? _cache;
    private int _nextId;

    public WordService(ILocalStorageService storage)
    {
        _storage = storage;
    }

    private async Task<List<JapaneseWord>> GetCachedAsync(IProgress<int>? progress = null)
    {
        if (_cache != null)
        {
            progress?.Report(100);
            return _cache;
        }

        progress?.Report(10);
        var stored = await _storage.GetItemAsync<List<JapaneseWord>>(StorageKey);
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

    public async Task<List<JapaneseWord>> GetAllAsync(IProgress<int>? progress = null)
    {
        return await GetCachedAsync(progress);
    }

    public async Task<List<JapaneseWord>> GetByTypeAsync(string type)
    {
        var all = await GetCachedAsync();
        if (type == "All")
            return all;
        return all.Where(w => w.Type == type).ToList();
    }

    public async Task AddAsync(JapaneseWord w)
    {
        var list = await GetCachedAsync();
        w.Id = _nextId++;
        list.Add(w);
        await _storage.SetItemAsync(StorageKey, list);
    }

    public async Task UpdateAsync(JapaneseWord w)
    {
        var list = await GetCachedAsync();
        var idx = list.FindIndex(x => x.Id == w.Id);
        if (idx >= 0)
        {
            list[idx] = w;
            await _storage.SetItemAsync(StorageKey, list);
        }
    }

    public async Task DeleteAsync(int id)
    {
        var list = await GetCachedAsync();
        list.RemoveAll(x => x.Id == id);
        await _storage.SetItemAsync(StorageKey, list);
    }

    private static List<JapaneseWord> GetDefaultData(IProgress<int>? progress = null)
    {
        var words = new List<JapaneseWord>();
        int id = 1;

        void Add(string chars, string romaji, string meaning, string type)
        {
            words.Add(new JapaneseWord { Id = id++, Characters = chars, Romaji = romaji, Meaning = meaning, Type = type });
        }

        void ReportAfterCategory(int categoryIndex, int totalCategories = 7)
        {
            progress?.Report(50 + (categoryIndex * 40 / totalCategories));
        }

        // ===== 清音 (Seion) - Root sounds, 2-5 characters =====
        Add("あさ", "asa", "sáng", "Seion");
        Add("いぬ", "inu", "chó", "Seion");
        Add("うみ", "umi", "biển", "Seion");
        Add("えき", "eki", "ga tàu", "Seion");
        Add("おか", "oka", "đồi", "Seion");
        Add("かさ", "kasa", "ô/dù", "Seion");
        Add("きく", "kiku", "hoa cúc", "Seion");
        Add("くすり", "kusuri", "thuốc", "Seion");
        Add("けしき", "keshiki", "phong cảnh", "Seion");
        Add("ここ", "koko", "chỗ này", "Seion");
        Add("さけ", "sake", "rượu", "Seion");
        Add("した", "shita", "phía dưới", "Seion");
        Add("すし", "sushi", "sushi", "Seion");
        Add("せなか", "senaka", "lưng", "Seion");
        Add("そら", "sora", "bầu trời", "Seion");
        Add("たけ", "take", "tre", "Seion");
        Add("ちち", "chichi", "cha", "Seion");
        Add("つき", "tsuki", "mặt trăng", "Seion");
        Add("て", "te", "tay", "Seion");
        Add("とけい", "tokei", "đồng hồ", "Seion");
        Add("なか", "naka", "bên trong", "Seion");
        Add("にほん", "nihon", "Nhật Bản", "Seion");
        Add("ぬの", "nuno", "vải", "Seion");
        Add("ねこ", "neko", "mèo", "Seion");
        Add("のはら", "nohara", "cánh đồng", "Seion");
        Add("はな", "hana", "hoa", "Seion");
        Add("ひと", "hito", "người", "Seion");
        Add("ふね", "fune", "tàu thuyền", "Seion");
        Add("へや", "heya", "căn phòng", "Seion");
        Add("ほし", "hoshi", "ngôi sao", "Seion");
        Add("まち", "machi", "thị trấn", "Seion");
        Add("みず", "mizu", "nước", "Seion");
        Add("むし", "mushi", "côn trùng", "Seion");
        Add("め", "me", "mắt", "Seion");
        Add("もり", "mori", "rừng", "Seion");
        Add("やま", "yama", "núi", "Seion");
        Add("ゆき", "yuki", "tuyết", "Seion");
        Add("よる", "yoru", "ban đêm", "Seion");
        Add("りんご", "ringo", "táo", "Seion");
        Add("るす", "rusu", "vắng nhà", "Seion");
        Add("れきし", "rekishi", "lịch sử", "Seion");
        Add("ろく", "roku", "sáu", "Seion");
        Add("わたし", "watashi", "tôi", "Seion");
        Add("かきくけこ", "kakikukeko", "KA-KI-KU-KE-KO", "Seion");

        ReportAfterCategory(1);

        // ===== 濁音 (Dakuon) - Voiced sounds (が・ざ・だ・ば) =====
        Add("がくせい", "gakusei", "học sinh", "Dakuon");
        Add("ぎんこう", "ginkou", "ngân hàng", "Dakuon");
        Add("ぐあい", "guai", "tình trạng", "Dakuon");
        Add("げんき", "genki", "khỏe mạnh", "Dakuon");
        Add("ごはん", "gohan", "cơm", "Dakuon");
        Add("ざっし", "zasshi", "tạp chí", "Dakuon");
        Add("じかん", "jikan", "thời gian", "Dakuon");
        Add("ずつう", "zutsuu", "đau đầu", "Dakuon");
        Add("ぜんぶ", "zenbu", "tất cả", "Dakuon");
        Add("ぞう", "zou", "voi", "Dakuon");
        Add("だいがく", "daigaku", "đại học", "Dakuon");
        Add("づつみ", "dzutsumi", "gói", "Dakuon");
        Add("でんわ", "denwa", "điện thoại", "Dakuon");
        Add("どくしょ", "dokusho", "đọc sách", "Dakuon");
        Add("ばんごう", "bangou", "số", "Dakuon");
        Add("びょういん", "byouin", "bệnh viện", "Dakuon");
        Add("ぶどう", "budou", "nho", "Dakuon");
        Add("べんきょう", "benkyou", "học tập", "Dakuon");
        Add("ぼうし", "boushi", "mũ", "Dakuon");

        ReportAfterCategory(2);

        // ===== 半濁音 (Handakuon) - Semi-voiced (ぱ・ぴ・ぷ・ぺ・ぽ) =====
        Add("ぱん", "pan", "bánh mì", "Handakuon");
        Add("ぴあの", "piano", "piano", "Handakuon");
        Add("ぷーる", "puuru", "hồ bơi", "Handakuon");
        Add("ぺん", "pen", "bút", "Handakuon");
        Add("ぽすと", "posuto", "hòm thư", "Handakuon");
        Add("ぱぴぷぺぽ", "papipupepo", "PA-PI-PU-PE-PO", "Handakuon");

        ReportAfterCategory(3);

        // ===== 拗音 (Yoon) - Contracted sounds (きゃ・きゅ・きょ etc.) =====
        Add("きゃく", "kyaku", "khách", "Yoon");
        Add("きゅう", "kyuu", "chín", "Yoon");
        Add("きょか", "kyoka", "cho phép", "Yoon");
        Add("ぎゃく", "gyaku", "ngược lại", "Yoon");
        Add("ぎゅうにゅう", "gyuunyu", "sữa bò", "Yoon");
        Add("ぎょ", "gyo", "cá", "Yoon");
        Add("しゃかい", "shakai", "xã hội", "Yoon");
        Add("しゅみ", "shumi", "sở thích", "Yoon");
        Add("しょくじ", "shokuji", "bữa ăn", "Yoon");
        Add("じゃま", "jama", "làm phiền", "Yoon");
        Add("じゅう", "juu", "mười", "Yoon");
        Add("じょせい", "josei", "phụ nữ", "Yoon");
        Add("ちゃわん", "chawan", "chén", "Yoon");
        Add("ちゅうがく", "chuugaku", "trung học", "Yoon");
        Add("ちょきん", "chokin", "tiết kiệm", "Yoon");
        Add("ぢゃ", "dja", "DJ", "Yoon");
        Add("ぢゅ", "dju", "DJU", "Yoon");
        Add("ぢょ", "djo", "DJO", "Yoon");
        Add("にゃ", "nya", "tiếng mèo kêu", "Yoon");
        Add("にゅうしゃ", "nyuusha", "nhập xã", "Yoon");
        Add("にょい", "nyoi", "như ý", "Yoon");
        Add("ひゃく", "hyaku", "trăm", "Yoon");
        Add("ひゅう", "hyuu", "HYU", "Yoon");
        Add("ひょう", "hyou", "bảng/báo giá", "Yoon");
        Add("びゃく", "byaku", "trăm (âm đục)", "Yoon");
        Add("びゅ", "byu", "BYU", "Yoon");
        Add("びょうき", "byouki", "bệnh", "Yoon");
        Add("ぴゃ", "pya", "PYA", "Yoon");
        Add("ぴゅ", "pyu", "PYU", "Yoon");
        Add("ぴょ", "pyo", "PYO", "Yoon");
        Add("みゃく", "myaku", "mạch", "Yoon");
        Add("みゅ", "myu", "MYU", "Yoon");
        Add("みょう", "myou", "kỳ diệu", "Yoon");
        Add("りゃく", "ryaku", "tóm tắt", "Yoon");
        Add("りゅう", "ryuu", "rồng", "Yoon");
        Add("りょこう", "ryokou", "du lịch", "Yoon");

        ReportAfterCategory(4);

        // ===== 促音 (Sokuon) - Double consonants (っ) =====
        Add("がっこう", "gakkou", "trường học", "Sokuon");
        Add("きって", "kitte", "tem thư", "Sokuon");
        Add("ざっし", "zasshi", "tạp chí", "Sokuon");
        Add("ほっかいどう", "hokkaidou", "Hokkaido", "Sokuon");
        Add("にっき", "nikki", "nhật ký", "Sokuon");
        Add("はっきり", "hakkiri", "rõ ràng", "Sokuon");
        Add("まっすぐ", "massugu", "thẳng", "Sokuon");
        Add("がっき", "gakki", "nhạc cụ", "Sokuon");
        Add("けっせき", "kesseki", "vắng mặt", "Sokuon");
        Add("じっけん", "jikken", "thí nghiệm", "Sokuon");

        ReportAfterCategory(5);

        // ===== 長音 (Choon) - Long vowels (ー, ああ, いい etc.) =====
        Add("おかあさん", "okaasan", "mẹ", "Choon");
        Add("おにいさん", "oniisan", "anh trai", "Choon");
        Add("おとうさん", "otousan", "cha", "Choon");
        Add("おねえさん", "oneesan", "chị gái", "Choon");
        Add("せんせい", "sensei", "giáo viên", "Choon");
        Add("こうこう", "koukou", "trung học phổ thông", "Choon");
        Add("そうじ", "souji", "dọn dẹp", "Choon");
        Add("とうよう", "touyou", "phương Đông", "Choon");
        Add("きょう", "kyou", "hôm nay", "Choon");
        Add("りょうり", "ryouri", "nấu ăn", "Choon");
        Add("びょういん", "byouin", "bệnh viện", "Choon");
        Add("じゅう", "juu", "mười", "Choon");
        Add("しゅう", "shuu", "tuần", "Choon");
        Add("ゆうびん", "yuubin", "bưu điện", "Choon");
        Add("こうえん", "kouen", "công viên", "Choon");
        Add("ちょうさ", "chousa", "điều tra", "Choon");
        Add("りゅうがく", "ryuugaku", "du học", "Choon");
        Add("きょうみ", "kyoumi", "sở thích", "Choon");

        ReportAfterCategory(6);

        // ===== N5 General - JLPT N5 vocabulary =====
        Add("わたし", "watashi", "tôi", "N5");
        Add("あなた", "anata", "bạn", "N5");
        Add("かれ", "kare", "anh ấy", "N5");
        Add("かのじょ", "kanojo", "cô ấy", "N5");
        Add("せんせい", "sensei", "giáo viên", "N5");
        Add("がくせい", "gakusei", "học sinh", "N5");
        Add("ともだち", "tomodachi", "bạn bè", "N5");
        Add("かぞく", "kazoku", "gia đình", "N5");
        Add("おとうさん", "otousan", "cha", "N5");
        Add("おかあさん", "okaasan", "mẹ", "N5");
        Add("おにいさん", "oniisan", "anh trai", "N5");
        Add("おねえさん", "oneesan", "chị gái", "N5");
        Add("おとうと", "otouto", "em trai", "N5");
        Add("いもうと", "imouto", "em gái", "N5");
        Add("こども", "kodomo", "trẻ em", "N5");
        Add("ひと", "hito", "người", "N5");
        Add("おとこのひと", "otokonohito", "người đàn ông", "N5");
        Add("おんなのひと", "onnanohito", "người phụ nữ", "N5");
        Add("いえ", "ie", "nhà", "N5");
        Add("うち", "uchi", "nhà (của tôi)", "N5");
        Add("へや", "heya", "căn phòng", "N5");
        Add("まど", "mado", "cửa sổ", "N5");
        Add("ドア", "doa", "cửa", "N5");
        Add("たてもの", "tatemono", "tòa nhà", "N5");
        Add("がっこう", "gakkou", "trường học", "N5");
        Add("としょかん", "toshokan", "thư viện", "N5");
        Add("こうえん", "kouen", "công viên", "N5");
        Add("びょういん", "byouin", "bệnh viện", "N5");
        Add("ぎんこう", "ginkou", "ngân hàng", "N5");
        Add("ゆうびんきょく", "yuubinkyoku", "bưu điện", "N5");
        Add("えき", "eki", "ga tàu", "N5");
        Add("くうこう", "kuukou", "sân bay", "N5");
        Add("みせ", "mise", "cửa hàng", "N5");
        Add("レストラン", "resutoran", "nhà hàng", "N5");
        Add("スーパー", "suupaa", "siêu thị", "N5");
        Add("ほんや", "honya", "hiệu sách", "N5");
        Add("くすりや", "kusuriya", "hiệu thuốc", "N5");
        Add("はなや", "hanaya", "cửa hàng hoa", "N5");
        Add("こうばん", "kouban", "đồn cảnh sát", "N5");
        Add("びじゅつかん", "bijutsukan", "bảo tàng mỹ thuật", "N5");
        Add("としょかん", "toshokan", "thư viện", "N5");
        Add("かいしゃ", "kaisha", "công ty", "N5");
        Add("くに", "kuni", "đất nước", "N5");
        Add("まち", "machi", "thị trấn", "N5");
        Add("むら", "mura", "làng", "N5");
        Add("みち", "michi", "đường đi", "N5");
        Add("はし", "hashi", "cầu", "N5");
        Add("かわ", "kawa", "sông", "N5");
        Add("うみ", "umi", "biển", "N5");
        Add("やま", "yama", "núi", "N5");
        Add("そら", "sora", "bầu trời", "N5");
        Add("いし", "ishi", "đá", "N5");
        Add("き", "ki", "cây", "N5");
        Add("はな", "hana", "hoa", "N5");
        Add("くさ", "kusa", "cỏ", "N5");
        Add("にわ", "niwa", "vườn", "N5");
        Add("どうぶつ", "doubutsu", "động vật", "N5");
        Add("ねこ", "neko", "mèo", "N5");
        Add("いぬ", "inu", "chó", "N5");
        Add("とり", "tori", "chim", "N5");
        Add("うま", "uma", "ngựa", "N5");
        Add("さかな", "sakana", "cá", "N5");
        Add("むし", "mushi", "côn trùng", "N5");
        Add("たべもの", "tabemono", "đồ ăn", "N5");
        Add("のみもの", "nomimono", "đồ uống", "N5");
        Add("ごはん", "gohan", "cơm", "N5");
        Add("パン", "pan", "bánh mì", "N5");
        Add("ぎゅうにゅう", "gyuunyuu", "sữa", "N5");
        Add("みず", "mizu", "nước", "N5");
        Add("おちゃ", "ocha", "trà", "N5");
        Add("コーヒー", "koohii", "cà phê", "N5");
        Add("ジュース", "juusu", "nước ép", "N5");
        Add("さけ", "sake", "rượu", "N5");
        Add("くだもの", "kudamono", "trái cây", "N5");
        Add("りんご", "ringo", "táo", "N5");
        Add("みかん", "mikan", "cam", "N5");
        Add("バナナ", "banana", "chuối", "N5");
        Add("いちご", "ichigo", "dâu tây", "N5");
        Add("ぶどう", "budou", "nho", "N5");
        Add("すいか", "suika", "dưa hấu", "N5");
        Add("やさい", "yasai", "rau", "N5");
        Add("にく", "niku", "thịt", "N5");
        Add("たまご", "tamago", "trứng", "N5");
        Add("とうふ", "toufu", "đậu phụ", "N5");
        Add("おかし", "okashi", "bánh kẹo", "N5");
        Add("モーニング", "mooningu", "buổi sáng", "N5");
        Add("あさ", "asa", "sáng", "N5");
        Add("ひる", "hiru", "trưa", "N5");
        Add("ばん", "ban", "tối", "N5");
        Add("よる", "yoru", "đêm", "N5");
        Add("きょう", "kyou", "hôm nay", "N5");
        Add("あした", "ashita", "ngày mai", "N5");
        Add("きのう", "kinou", "hôm qua", "N5");
        Add("あさって", "asatte", "ngày kia", "N5");
        Add("おととい", "ototoi", "hôm kia", "N5");
        Add("まいにち", "mainichi", "mỗi ngày", "N5");
        Add("まいしゅう", "maishuu", "mỗi tuần", "N5");
        Add("まいげつ", "maigetsu", "mỗi tháng", "N5");
        Add("まいとし", "maitoshi", "mỗi năm", "N5");
        Add("こんしゅう", "konshuu", "tuần này", "N5");
        Add("らいしゅう", "raishuu", "tuần sau", "N5");
        Add("せんしゅう", "senshuu", "tuần trước", "N5");
        Add("こんげつ", "kongetsu", "tháng này", "N5");
        Add("らいげつ", "raigetsu", "tháng sau", "N5");
        Add("せんげつ", "sengetsu", "tháng trước", "N5");
        Add("ことし", "kotoshi", "năm nay", "N5");
        Add("らいねん", "rainen", "năm sau", "N5");
        Add("きょねん", "kyonen", "năm trước", "N5");
        Add("いま", "ima", "bây giờ", "N5");
        Add("あと", "ato", "sau", "N5");
        Add("まえ", "mae", "trước", "N5");
        Add("とき", "toki", "khi, lúc", "N5");
        Add("じかん", "jikan", "thời gian", "N5");
        Add("いちじ", "ichiji", "1 giờ", "N5");
        Add("にじ", "niji", "2 giờ", "N5");
        Add("さんじ", "sanji", "3 giờ", "N5");
        Add("よじ", "yoji", "4 giờ", "N5");
        Add("ごじ", "goji", "5 giờ", "N5");
        Add("ろくじ", "rokuji", "6 giờ", "N5");
        Add("しちじ", "shichiji", "7 giờ", "N5");
        Add("はちじ", "hachiji", "8 giờ", "N5");
        Add("くじ", "kuji", "9 giờ", "N5");
        Add("じゅうじ", "juuji", "10 giờ", "N5");
        Add("じゅういちじ", "juuichiji", "11 giờ", "N5");
        Add("じゅうにじ", "juuniji", "12 giờ", "N5");
        Add("はん", "han", "rưỡi", "N5");
        Add("ふん", "fun", "phút", "N5");
        Add("ようび", "youbi", "thứ", "N5");
        Add("にちようび", "nichiyoubi", "chủ nhật", "N5");
        Add("げつようび", "getsuyoubi", "thứ hai", "N5");
        Add("かようび", "kayoubi", "thứ ba", "N5");
        Add("すいようび", "suiyoubi", "thứ tư", "N5");
        Add("もくようび", "mokuyoubi", "thứ năm", "N5");
        Add("きんようび", "kinyoubi", "thứ sáu", "N5");
        Add("どようび", "doyoubi", "thứ bảy", "N5");
        Add("ついたち", "tsuitachi", "ngày 1", "N5");
        Add("ふつか", "futsuka", "ngày 2", "N5");
        Add("みっか", "mikka", "ngày 3", "N5");
        Add("よっか", "yokka", "ngày 4", "N5");
        Add("いつか", "itsuka", "ngày 5", "N5");
        Add("むいか", "muika", "ngày 6", "N5");
        Add("なのか", "nanoka", "ngày 7", "N5");
        Add("ようか", "youka", "ngày 8", "N5");
        Add("ここのか", "kokonoka", "ngày 9", "N5");
        Add("とおか", "tooka", "ngày 10", "N5");
        Add("はつか", "hatsuka", "ngày 20", "N5");
        Add("ねん", "nen", "năm", "N5");
        Add("がつ", "gatsu", "tháng", "N5");
        Add("いちがつ", "ichigatsu", "tháng 1", "N5");
        Add("にがつ", "nigatsu", "tháng 2", "N5");
        Add("さんがつ", "sangatsu", "tháng 3", "N5");
        Add("しがつ", "shigatsu", "tháng 4", "N5");
        Add("ごがつ", "gogatsu", "tháng 5", "N5");
        Add("ろくがつ", "rokugatsu", "tháng 6", "N5");
        Add("しちがつ", "shichigatsu", "tháng 7", "N5");
        Add("はちがつ", "hachigatsu", "tháng 8", "N5");
        Add("くがつ", "kugatsu", "tháng 9", "N5");
        Add("じゅうがつ", "juugatsu", "tháng 10", "N5");
        Add("じゅういちがつ", "juuichigatsu", "tháng 11", "N5");
        Add("じゅうにがつ", "juunigatsu", "tháng 12", "N5");
        Add("てんき", "tenki", "thời tiết", "N5");
        Add("はれ", "hare", "nắng", "N5");
        Add("あめ", "ame", "mưa", "N5");
        Add("くもり", "kumori", "mây", "N5");
        Add("ゆき", "yuki", "tuyết", "N5");
        Add("かぜ", "kaze", "gió", "N5");
        Add("あたたかい", "atatakai", "ấm áp", "N5");
        Add("すずしい", "suzushii", "mát mẻ", "N5");
        Add("さむい", "samui", "lạnh", "N5");
        Add("あつい", "atsui", "nóng", "N5");
        Add("いい", "ii", "tốt", "N5");
        Add("わるい", "warui", "xấu", "N5");
        Add("おおきい", "ookii", "lớn", "N5");
        Add("ちいさい", "chiisai", "nhỏ", "N5");
        Add("たかい", "takai", "cao, đắt", "N5");
        Add("ひくい", "hikui", "thấp", "N5");
        Add("あたらしい", "atarashii", "mới", "N5");
        Add("ふるい", "furui", "cũ", "N5");
        Add("やすい", "yasui", "rẻ, dễ", "N5");
        Add("むずかしい", "muzukashii", "khó", "N5");
        Add("やさしい", "yasashii", "dễ, hiền", "N5");
        Add("おもしろい", "omoshiroi", "thú vị", "N5");
        Add("つまらない", "tsumaranai", "chán", "N5");
        Add("おいしい", "oishii", "ngon", "N5");
        Add("まずい", "mazui", "dở", "N5");
        Add("いそがしい", "isogashii", "bận rộn", "N5");
        Add("たのしい", "tanoshii", "vui vẻ", "N5");
        Add("うれしい", "ureshii", "vui mừng", "N5");
        Add("かなしい", "kanashii", "buồn", "N5");
        Add("ひろい", "hiroi", "rộng", "N5");
        Add("せまい", "semai", "hẹp", "N5");
        Add("とおい", "tooi", "xa", "N5");
        Add("ちかい", "chikai", "gần", "N5");
        Add("はやい", "hayai", "nhanh, sớm", "N5");
        Add("おそい", "osoi", "chậm, muộn", "N5");
        Add("おおい", "ooi", "nhiều", "N5");
        Add("すくない", "sukunai", "ít", "N5");
        Add("いぬ", "inu", "chó", "N5");
        Add("しごと", "shigoto", "công việc", "N5");
        Add("べんきょう", "benkyou", "học tập", "N5");
        Add("かいもの", "kaimono", "mua sắm", "N5");
        Add("りょこう", "ryokou", "du lịch", "N5");
        Add("でんわ", "denwa", "điện thoại", "N5");
        Add("てがみ", "tegami", "thư", "N5");
        Add("きって", "kitte", "tem", "N5");
        Add("はがき", "hagaki", "bưu thiếp", "N5");
        Add("しんぶん", "shinbun", "báo", "N5");
        Add("ざっし", "zasshi", "tạp chí", "N5");
        Add("ほん", "hon", "sách", "N5");
        Add("じしょ", "jisho", "từ điển", "N5");
        Add("かばん", "kaban", "cặp sách", "N5");
        Add("えんぴつ", "enpitsu", "bút chì", "N5");
        Add("ペン", "pen", "bút", "N5");
        Add("かみ", "kami", "giấy", "N5");
        Add("はさみ", "hasami", "kéo", "N5");
        Add("テレビ", "terebi", "tivi", "N5");
        Add("ラジオ", "rajio", "radio", "N5");
        Add("コンピュータ", "konpyuuta", "máy tính", "N5");
        Add("くるま", "kuruma", "xe hơi", "N5");
        Add("じてんしゃ", "jitensha", "xe đạp", "N5");
        Add("バス", "basu", "xe buýt", "N5");
        Add("でんしゃ", "densha", "tàu điện", "N5");
        Add("ひこうき", "hikouki", "máy bay", "N5");
        Add("ふね", "fune", "tàu thuyền", "N5");
        Add("タクシー", "takushii", "taxi", "N5");
        Add("あるく", "aruku", "đi bộ", "N5");
        Add("はしる", "hashiru", "chạy", "N5");
        Add("たべる", "taberu", "ăn", "N5");
        Add("のむ", "nomu", "uống", "N5");
        Add("みる", "miru", "nhìn, xem", "N5");
        Add("きく", "kiku", "nghe, hỏi", "N5");
        Add("はなす", "hanasu", "nói chuyện", "N5");
        Add("よむ", "yomu", "đọc", "N5");
        Add("かく", "kaku", "viết", "N5");
        Add("かう", "kau", "mua", "N5");
        Add("うる", "uru", "bán", "N5");
        Add("つくる", "tsukuru", "làm, chế tạo", "N5");
        Add("おしえる", "oshieru", "dạy", "N5");
        Add("ならう", "narau", "học (được dạy)", "N5");
        Add("わかる", "wakaru", "hiểu", "N5");
        Add("できる", "dekiru", "có thể", "N5");
        Add("ある", "aru", "có (vật)", "N5");
        Add("いる", "iru", "có (người)", "N5");
        Add("いく", "iku", "đi", "N5");
        Add("くる", "kuru", "đến", "N5");
        Add("かえる", "kaeru", "về nhà", "N5");
        Add("でかける", "dekakeru", "ra ngoài", "N5");
        Add("のる", "noru", "lên xe", "N5");
        Add("おりる", "oriru", "xuống xe", "N5");
        Add("のりかえる", "norikaeru", "chuyển xe", "N5");
        Add("まつ", "matsu", "chờ", "N5");
        Add("とまる", "tomaru", "dừng lại", "N5");
        Add("すわる", "suwaru", "ngồi", "N5");
        Add("たつ", "tatsu", "đứng", "N5");
        Add("ねる", "neru", "ngủ", "N5");
        Add("おきる", "okiru", "thức dậy", "N5");
        Add("あびる", "abiru", "tắm", "N5");
        Add("きる", "kiru", "mặc", "N5");
        Add("はく", "haku", "mang (quần, giày)", "N5");
        Add("かぶる", "kaburu", "đội (mũ)", "N5");
        Add("もつ", "motsu", "cầm, mang", "N5");
        Add("もってくる", "mottekuru", "mang đến", "N5");
        Add("もっていく", "motteiku", "mang đi", "N5");
        Add("あける", "akeru", "mở", "N5");
        Add("しめる", "shimeru", "đóng", "N5");
        Add("いれる", "ireru", "bỏ vào", "N5");
        Add("だす", "dasu", "lấy ra", "N5");
        Add("つける", "tsukeru", "bật (đèn)", "N5");
        Add("けす", "kesu", "tắt", "N5");
        Add("あらう", "arau", "rửa", "N5");
        Add("ふく", "fuku", "lau", "N5");
        Add("そうじする", "soujisuru", "dọn dẹp", "N5");
        Add("せんたくする", "sentakusuru", "giặt quần áo", "N5");
        Add("りょうりする", "ryourisuru", "nấu ăn", "N5");
        Add("さんぽする", "sanposuru", "đi dạo", "N5");
        Add("うんどうする", "undousuru", "tập thể dục", "N5");
        Add("でんわする", "denwasuru", "gọi điện", "N5");
        Add("しごとする", "shigotosuru", "làm việc", "N5");
        Add("いっしょに", "isshoni", "cùng nhau", "N5");
        Add("ひとりで", "hitoride", "một mình", "N5");
        Add("ゆっくり", "yukkuri", "chậm rãi", "N5");
        Add("いつも", "itsumo", "luôn luôn", "N5");
        Add("たいてい", "taitei", "thường", "N5");
        Add("ときどき", "tokidoki", "thỉnh thoảng", "N5");
        Add("よく", "yoku", "thường, giỏi", "N5");
        Add("たまに", "tamani", "thỉnh thoảng", "N5");
        Add("あまり", "amari", "không...lắm", "N5");
        Add("ぜんぜん", "zenzen", "hoàn toàn không", "N5");
        Add("もう", "mou", "đã, rồi", "N5");
        Add("まだ", "mada", "vẫn còn", "N5");
        Add("すぐ", "sugu", "ngay lập tức", "N5");
        Add("だんだん", "dandan", "dần dần", "N5");
        Add("ちょうど", "choudo", "vừa đúng", "N5");
        Add("とても", "totemo", "rất", "N5");
        Add("すごく", "sugoku", "cực kỳ", "N5");
        Add("ちょっと", "chotto", "một chút", "N5");
        Add("たくさん", "takusan", "nhiều", "N5");
        Add("すこし", "sukoshi", "một ít", "N5");
        Add("さい", "sai", "~tuổi", "N5");
        Add("ねん", "nen", "năm (học)", "N5");
        Add("くらす", "kurasu", "lớp học", "N5");
        Add("がくねん", "gakunen", "khối lớp", "N5");
        Add("せいと", "seito", "học sinh", "N5");
        Add("しつもん", "shitsumon", "câu hỏi", "N5");
        Add("こたえ", "kotae", "câu trả lời", "N5");
        Add("もんだい", "mondai", "vấn đề, bài tập", "N5");
        Add("れい", "rei", "ví dụ", "N5");
        Add("みぎ", "migi", "bên phải", "N5");
        Add("ひだり", "hidari", "bên trái", "N5");
        Add("うえ", "ue", "trên", "N5");
        Add("した", "shita", "dưới", "N5");
        Add("まえ", "mae", "trước", "N5");
        Add("うしろ", "ushiro", "sau", "N5");
        Add("なか", "naka", "trong", "N5");
        Add("そと", "soto", "ngoài", "N5");
        Add("となり", "tonari", "bên cạnh", "N5");
        Add("ちかく", "chikaku", "gần", "N5");
        Add("あいだ", "aida", "giữa", "N5");
        Add("むこう", "mukou", "phía bên kia", "N5");
        Add("いろ", "iro", "màu sắc", "N5");
        Add("あか", "aka", "đỏ", "N5");
        Add("あお", "ao", "xanh dương", "N5");
        Add("きいろ", "kiiro", "vàng", "N5");
        Add("しろ", "shiro", "trắng", "N5");
        Add("くろ", "kuro", "đen", "N5");
        Add("みどり", "midori", "xanh lá", "N5");
        Add("むらさき", "murasaki", "tím", "N5");
        Add("ちゃいろ", "chairo", "nâu", "N5");
        Add("オレンジ", "orenji", "cam", "N5");
        Add("ピンク", "pinku", "hồng", "N5");
        Add("からだ", "karada", "cơ thể", "N5");
        Add("あたま", "atama", "đầu", "N5");
        Add("かお", "kao", "mặt", "N5");
        Add("め", "me", "mắt", "N5");
        Add("はな", "hana", "mũi", "N5");
        Add("みみ", "mimi", "tai", "N5");
        Add("くち", "kuchi", "miệng", "N5");
        Add("て", "te", "tay", "N5");
        Add("あし", "ashi", "chân", "N5");
        Add("おなか", "onaka", "bụng", "N5");
        Add("のど", "nodo", "cổ họng", "N5");
        Add("こころ", "kokoro", "tim, lòng", "N5");
        Add("かみ", "kami", "tóc", "N5");
        Add("は", "ha", "răng", "N5");
        Add("せ", "se", "lưng, chiều cao", "N5");
        Add("かた", "kata", "vai", "N5");
        Add("ひざ", "hiza", "đầu gối", "N5");
        Add("ゆび", "yubi", "ngón tay", "N5");
        Add("つめ", "tsume", "móng tay", "N5");
        Add("いしゃ", "isha", "bác sĩ", "N5");
        Add("かんごふ", "kangofu", "y tá", "N5");
        Add("うんてんしゅ", "untenshu", "tài xế", "N5");
        Add("やきゅう", "yakyuu", "bóng chày", "N5");
        Add("サッカー", "sakkaa", "bóng đá", "N5");
        Add("テニス", "tenisu", "quần vợt", "N5");
        Add("ゴルフ", "gorufu", "golf", "N5");
        Add("すいえい", "suiei", "bơi lội", "N5");
        Add("うた", "uta", "bài hát", "N5");
        Add("おんがく", "ongaku", "âm nhạc", "N5");
        Add("え", "e", "tranh ảnh", "N5");
        Add("しゃしん", "shashin", "ảnh", "N5");
        Add("えいが", "eiga", "phim", "N5");
        Add("きって", "kitte", "tem thư", "N5");
        Add("おくりもの", "okurimono", "quà tặng", "N5");
        Add("おみやげ", "omiyage", "quà lưu niệm", "N5");
        Add("はなび", "hanabi", "pháo hoa", "N5");
        Add("まつり", "matsuri", "lễ hội", "N5");
        Add("あいて", "aite", "đối phương", "N5");
        Add("うそ", "uso", "nói dối", "N5");
        Add("おかね", "okane", "tiền", "N5");
        Add("おつり", "otsuri", "tiền thừa", "N5");
        Add("きっぷ", "kippu", "vé", "N5");
        Add("くすり", "kusuri", "thuốc", "N5");
        Add("こいびと", "koibito", "người yêu", "N5");
        Add("さいふ", "saifu", "ví", "N5");
        Add("さとう", "satou", "đường", "N5");
        Add("しお", "shio", "muối", "N5");
        Add("しょうゆ", "shouyu", "xì dầu", "N5");
        Add("はし", "hashi", "đũa", "N5");
        Add("スプーン", "supuun", "muỗng", "N5");
        Add("ナイフ", "naifu", "dao", "N5");
        Add("フォーク", "fooku", "nĩa", "N5");
        Add("コップ", "koppu", "cốc", "N5");
        Add("おさら", "osara", "đĩa", "N5");
        Add("ボール", "booru", "bát", "N5");
        Add("ベッド", "beddo", "giường", "N5");
        Add("つくえ", "tsukue", "bàn", "N5");
        Add("いす", "isu", "ghế", "N5");
        Add("たんす", "tansu", "tủ", "N5");
        Add("ほんだな", "hondana", "kệ sách", "N5");
        Add("カーテン", "kaaten", "rèm cửa", "N5");
        Add("でんき", "denki", "đèn điện", "N5");
        Add("れいぞうこ", "reizouko", "tủ lạnh", "N5");
        Add("でんしレンジ", "denshirenji", "lò vi sóng", "N5");
        Add("せんたくき", "sentakuki", "máy giặt", "N5");
        Add("そうじき", "soujiki", "máy hút bụi", "N5");
        Add("エアコン", "eakon", "máy lạnh", "N5");
        Add("ストーブ", "sutoubu", "lò sưởi", "N5");
        Add("かぎ", "kagi", "chìa khóa", "N5");
        Add("とけい", "tokei", "đồng hồ", "N5");
        Add("めがね", "megane", "kính mắt", "N5");
        Add("かさ", "kasa", "ô/dù", "N5");
        Add("ぼうし", "boushi", "mũ", "N5");
        Add("ふく", "fuku", "quần áo", "N5");
        Add("シャツ", "shatsu", "áo sơ mi", "N5");
        Add("ズボン", "zubon", "quần", "N5");
        Add("スカート", "sukaato", "váy", "N5");
        Add("くつ", "kutsu", "giày", "N5");
        Add("くつした", "kutsushita", "vớ", "N5");
        Add("ベルト", "beruto", "thắt lưng", "N5");
        Add("うでどけい", "udedokei", "đồng hồ đeo tay", "N5");
        Add("こころ", "kokoro", "trái tim", "N5");
        Add("きもち", "kimochi", "cảm giác", "N5");
        Add("いみ", "imi", "ý nghĩa", "N5");
        Add("わけ", "wake", "lý do", "N5");
        Add("ほんとう", "hontou", "sự thật", "N5");
        Add("もちろん", "mochiron", "tất nhiên", "N5");
        Add("たぶん", "tabun", "có lẽ", "N5");
        Add("きっと", "kitto", "chắc chắn", "N5");
        Add("はじめて", "hajimete", "lần đầu", "N5");
        Add("はじめまして", "hajimemashite", "rất vui được gặp bạn", "N5");
        Add("ありがとう", "arigatou", "cảm ơn", "N5");
        Add("すみません", "sumimasen", "xin lỗi", "N5");
        Add("ごめんなさい", "gomennasai", "xin lỗi", "N5");
        Add("こんにちは", "konnichiwa", "xin chào", "N5");
        Add("こんばんは", "konbanwa", "chào buổi tối", "N5");
        Add("おはよう", "ohayou", "chào buổi sáng", "N5");
        Add("さようなら", "sayounara", "tạm biệt", "N5");
        Add("おやすみ", "oyasumi", "chúc ngủ ngon", "N5");
        Add("いただきます", "itadakimasu", "mời ăn", "N5");
        Add("ごちそうさまでした", "gochisousamadeshita", "cảm ơn vì bữa ăn", "N5");
        Add("いらっしゃいませ", "irasshaimase", "chào mừng", "N5");
        Add("おげんきですか", "ogenkidesuka", "bạn khỏe không", "N5");

        return words;
    }
}

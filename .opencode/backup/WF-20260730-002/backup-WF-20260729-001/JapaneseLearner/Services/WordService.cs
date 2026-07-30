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

    private async Task<List<JapaneseWord>> GetCachedAsync()
    {
        if (_cache != null)
            return _cache;

        var stored = await _storage.GetItemAsync<List<JapaneseWord>>(StorageKey);
        if (stored != null && stored.Count > 0)
        {
            _cache = stored;
            _nextId = _cache.Max(c => c.Id) + 1;
            return _cache;
        }

        _cache = GetDefaultData();
        _nextId = _cache.Count + 1;
        await _storage.SetItemAsync(StorageKey, _cache);
        return _cache;
    }

    public async Task<List<JapaneseWord>> GetAllAsync()
    {
        return await GetCachedAsync();
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

    private static List<JapaneseWord> GetDefaultData()
    {
        var words = new List<JapaneseWord>();
        int id = 1;

        void Add(string chars, string romaji, string meaning, string type)
        {
            words.Add(new JapaneseWord { Id = id++, Characters = chars, Romaji = romaji, Meaning = meaning, Type = type });
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
        Add("ぢゃ", "dja", "DJ", "Dakuon");
        Add("づつみ", "dzutsumi", "gói", "Dakuon");
        Add("でんわ", "denwa", "điện thoại", "Dakuon");
        Add("どくしょ", "dokusho", "đọc sách", "Dakuon");
        Add("ばんごう", "bangou", "số", "Dakuon");
        Add("びょういん", "byouin", "bệnh viện", "Dakuon");
        Add("ぶどう", "budou", "nho", "Dakuon");
        Add("べんきょう", "benkyou", "học tập", "Dakuon");
        Add("ぼうし", "boushi", "mũ", "Dakuon");

        // ===== 半濁音 (Handakuon) - Semi-voiced (ぱ・ぴ・ぷ・ぺ・ぽ) =====
        Add("ぱん", "pan", "bánh mì", "Handakuon");
        Add("ぴあの", "piano", "piano", "Handakuon");
        Add("ぷーる", "puuru", "hồ bơi", "Handakuon");
        Add("ぺん", "pen", "bút", "Handakuon");
        Add("ぽすと", "posuto", "hòm thư", "Handakuon");
        Add("ぱぴぷぺぽ", "papipupepo", "PA-PI-PU-PE-PO", "Handakuon");

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

        return words;
    }
}

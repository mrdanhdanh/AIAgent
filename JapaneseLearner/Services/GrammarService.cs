using Blazored.LocalStorage;
using JapaneseLearner.Models;

namespace JapaneseLearner.Services;

public class GrammarService : IGrammarService
{
    private readonly ILocalStorageService _storage;
    private const string StorageKey = "japanese_grammar";
    private List<JapaneseGrammar>? _cache;
    private int _nextId;

    public GrammarService(ILocalStorageService storage)
    {
        _storage = storage;
    }

    private async Task<List<JapaneseGrammar>> GetCachedAsync(IProgress<int>? progress = null)
    {
        if (_cache != null)
        {
            progress?.Report(100);
            return _cache;
        }

        progress?.Report(10);
        var stored = await _storage.GetItemAsync<List<JapaneseGrammar>>(StorageKey);
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

    public async Task<List<JapaneseGrammar>> GetAllAsync(IProgress<int>? progress = null)
    {
        return await GetCachedAsync(progress);
    }

    public async Task<JapaneseGrammar?> GetByIdAsync(int id)
    {
        var all = await GetCachedAsync();
        return all.FirstOrDefault(g => g.Id == id);
    }

    public async Task<List<JapaneseGrammar>> GetByLevelAsync(string level)
    {
        var all = await GetCachedAsync();
        if (level == "All")
            return all;
        return all.Where(g => g.JLPTLevel == level).ToList();
    }

    public async Task AddAsync(JapaneseGrammar g)
    {
        var list = await GetCachedAsync();
        g.Id = _nextId++;
        list.Add(g);
        await _storage.SetItemAsync(StorageKey, list);
    }

    public async Task UpdateAsync(JapaneseGrammar g)
    {
        var list = await GetCachedAsync();
        var idx = list.FindIndex(x => x.Id == g.Id);
        if (idx >= 0)
        {
            list[idx] = g;
            await _storage.SetItemAsync(StorageKey, list);
        }
    }

    public async Task DeleteAsync(int id)
    {
        var list = await GetCachedAsync();
        list.RemoveAll(x => x.Id == id);
        await _storage.SetItemAsync(StorageKey, list);
    }

    private static List<JapaneseGrammar> GetDefaultData(IProgress<int>? progress = null)
    {
        var list = new List<JapaneseGrammar>();
        int id = 1;

        void Add(string pattern, string meaning, string explanation, string[]? examples = null, string level = "N5")
        {
            list.Add(new JapaneseGrammar
            {
                Id = id++,
                Pattern = pattern,
                Meaning = meaning,
                Explanation = explanation,
                JLPTLevel = level,
                Examples = examples?.ToList() ?? new List<string>()
            });
        }

        // === CƠ BẢN ===
        Add("〜は〜です", "Là...", "Cấu trúc câu cơ bản nhất. は là trợ từ chủ đề, です là động từ 'là'.",
            new[] { "これは本です。", "彼は学生です。", "私は日本人です。" });
        Add("〜は〜ではありません", "Không phải là...", "Dạng phủ định của です. ではありません = không phải.",
            new[] { "これは本ではありません。", "彼は学生ではありません。" });
        Add("〜は〜でした", "Đã là...", "Dạng quá khứ của です.",
            new[] { "昨日は日曜日でした。", "彼は学生でした。" });
        Add("〜は〜ではありませんでした", "Đã không phải là...", "Dạng phủ định quá khứ.",
            new[] { "昨日は日曜日ではありませんでした。", "あれは本ではありませんでした。" });

        // === TRỢ TỪ ===
        Add("〜が〜", "Chủ ngữ (が)", "Trợ từ が đánh dấu chủ ngữ. Thường dùng với động từ chỉ tồn tại.",
            new[] { "猫がいます。", "庭に花があります。", "だれが来ましたか。" });
        Add("〜を〜", "Tân ngữ (を)", "Trợ từ を đánh dấu tân ngữ trực tiếp của động từ.",
            new[] { "本を読みます。", "ご飯を食べます。", "水を飲みます。" });
        Add("〜に〜", "Chỉ điểm đến/thời gian (に)", "Trợ từ に chỉ thời điểm, địa điểm tồn tại hoặc hướng đến.",
            new[] { "学校に行きます。", "8時に起きます。", "ここにあります。" });
        Add("〜で〜", "Chỉ phương tiện/nơi hành động (で)", "Trợ từ で chỉ nơi xảy ra hành động hoặc phương tiện.",
            new[] { "バスで行きます。", "レストランで食べます。", "ペンで書きます。" });
        Add("〜へ〜", "Chỉ hướng (へ)", "Trợ từ へ chỉ hướng di chuyển. Đọc là 'e'.",
            new[] { "日本へ行きます。", "ここへ来てください。" });
        Add("〜と〜", "Cùng với (と)", "Trợ từ と nối danh từ, nghĩa là 'và' hoặc 'cùng với'.",
            new[] { "友達と映画を見ます。", "これとそれをください。" });
        Add("〜から〜まで", "Từ... đến...", "から = từ, まで = đến. Chỉ khoảng không gian hoặc thời gian.",
            new[] { "9時から5時まで働きます。", "東京から大阪まで電車で行きます。" });

        // === ĐỘNG TỪ ===
        Add("〜ます / 〜ません", "Làm / Không làm", "Dạng lịch sự của động từ. ます = khẳng định, ません = phủ định.",
            new[] { "毎日勉強します。", "タバコを吸いません。" });
        Add("〜ました / 〜ませんでした", "Đã làm / Đã không làm", "Dạng lịch sự quá khứ.",
            new[] { "昨日勉強しました。", "日曜日は働きませんでした。" });
        Add("〜てください", "Hãy làm ~ (yêu cầu)", "Dạng yêu cầu lịch sự. Động từ chia thể て + ください.",
            new[] { "ここに座ってください。", "ドアを開けてください。" });
        Add("〜ましょう", "Hãy cùng làm ~", "Dạng rủ rê, đề nghị cùng làm gì đó.",
            new[] { "一緒に行きましょう。", "食べましょう。" });
        Add("〜てもいいです", "Được phép làm ~", "Xin phép hoặc cho phép ai đó làm gì.",
            new[] { "ここに座ってもいいですか。", "写真を撮ってもいいです。" });
        Add("〜てはいけません", "Không được làm ~", "Diễn tả sự cấm đoán, không được phép.",
            new[] { "ここでタバコを吸ってはいけません。", "遅れてはいけません。" });
        Add("〜なければなりません", "Phải làm ~", "Diễn tả sự bắt buộc, nghĩa vụ phải làm.",
            new[] { "宿題をしなければなりません。", "毎日練習しなければなりません。" });

        // === TÍNH TỪ ===
        Add("い-adj + です", "Tính từ đuôi い", "Tính từ kết thúc bằng い. Thêm です để lịch sự.",
            new[] { "この本は安いです。", "今日は暑いです。" });
        Add("い-adj + くないです", "Tính từ đuôi い (phủ định)", "Phủ định: bỏ い + くないです.",
            new[] { "この本は安くないです。", "今日は暑くないです。" });
        Add("な-adj + です", "Tính từ đuôi な", "Tính từ kết thúc bằng な. Thêm です để lịch sự.",
            new[] { "この町は静かです。", "彼は元気です。" });
        Add("な-adj + ではありません", "Tính từ đuôi な (phủ định)", "Phủ định: ではありません thay vì です.",
            new[] { "この町は静かではありません。", "彼は元気ではありません。" });

        // === THỜI GIAN ===
        Add("〜とき〜", "Khi ~", "Diễn tả thời điểm xảy ra hành động. とき = khi.",
            new[] { "子供のとき、日本に住んでいました。", "暇なとき、本を読みます。" });
        Add("〜前に〜", "Trước khi ~", "Diễn tả hành động xảy ra trước một thời điểm/hành động khác.",
            new[] { "寝る前に歯を磨きます。", "食事の前に手を洗います。" });
        Add("〜後で〜", "Sau khi ~", "Diễn tả hành động xảy ra sau một hành động khác.",
            new[] { "仕事の後で、ジムに行きます。", "食べた後で、薬を飲みます。" });
        Add("〜ながら〜", "Vừa làm A vừa làm B", "Diễn tả hai hành động xảy ra đồng thời.",
            new[] { "音楽を聞きながら勉強します。", "テレビを見ながら食べます。" });

        // === CÂU HỎI ===
        Add("〜か", "Có... không? (câu hỏi)", "Thêm か ở cuối câu để tạo câu hỏi.",
            new[] { "これは本ですか。", "明日学校に行きますか。" });
        Add("〜はどこですか", "Ở đâu?", "Hỏi vị trí của một vật/người.",
            new[] { "トイレはどこですか。", "駅はどこですか。" });
        Add("〜はいくらですか", "Bao nhiêu tiền?", "Hỏi giá cả.",
            new[] { "これはいくらですか。", "りんごはいくらですか。" });
        Add("〜がほしいです", "Muốn có ~", "Diễn tả mong muốn sở hữu một vật.",
            new[] { "新しいスマホがほしいです。", "友達がほしいです。" });

        // === KHẢ NĂNG / Ý ĐỊNH ===
        Add("〜たいです", "Muốn làm ~", "Thêm たい vào thân động từ để diễn tả mong muốn làm gì.",
            new[] { "日本に行きたいです。", "すしを食べたいです。" });
        Add("〜ことができます", "Có thể làm ~", "Diễn tả khả năng làm một việc gì đó.",
            new[] { "日本語を話すことができます。", "泳ぐことができます。" });
        Add("〜つもりです", "Dự định làm ~", "Diễn tả ý định, dự định trong tương lai.",
            new[] { "来年日本に行くつもりです。", "大学に行くつもりです。" });
        Add("〜と思います", "Tôi nghĩ là ~", "Diễn tả suy nghĩ, ý kiến cá nhân.",
            new[] { "明日雨だと思います。", "この本は面白いと思います。" });

        // === KHÁC ===
        Add("〜がある / 〜がいる", "Có ~ (vật/người)", "ある = tồn tại của vật vô tri. いる = tồn tại của người/động vật.",
            new[] { "机の上に本があります。", "庭に猫がいます。" });
        Add("〜方 (かた)", "Cách làm ~", "Thêm 方 vào thân động từ (dạng ます bỏ ます) để chỉ cách làm.",
            new[] { "この漢字の書き方を教えてください。", "寿司の作り方を知っていますか。" });
        Add("〜すぎる", "Làm ~ quá mức", "Thêm すぎる vào thân động từ hoặc bỏ い/な của tính từ.",
            new[] { "食べすぎました。", "この問題は難しすぎます。" });
        Add("〜ほうがいいです", "Nên làm ~", "Đưa ra lời khuyên. Động từ thể た + ほうがいい.",
            new[] { "早く寝たほうがいいです。", "医者に行ったほうがいいです。" });

        progress?.Report(100);
        return list;
    }
}
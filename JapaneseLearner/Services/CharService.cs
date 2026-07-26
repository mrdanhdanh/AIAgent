using Blazored.LocalStorage;
using JapaneseLearner.Models;

namespace JapaneseLearner.Services;

public class CharService : ICharService
{
    private readonly ILocalStorageService _storage;
    private const string StorageKey = "japanese_chars";
    private List<JapaneseChar>? _cache;
    private int _nextId;

    public CharService(ILocalStorageService storage)
    {
        _storage = storage;
    }

    private async Task<List<JapaneseChar>> GetCachedAsync()
    {
        if (_cache != null)
            return _cache;

        var stored = await _storage.GetItemAsync<List<JapaneseChar>>(StorageKey);
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

    public async Task<List<JapaneseChar>> GetAllAsync()
    {
        return await GetCachedAsync();
    }

    public async Task<List<JapaneseChar>> GetByTypeAsync(string type)
    {
        var all = await GetCachedAsync();
        if (type == "All")
            return all;
        return all.Where(c => c.Type == type).ToList();
    }

    public async Task AddAsync(JapaneseChar c)
    {
        var list = await GetCachedAsync();
        c.Id = _nextId++;
        list.Add(c);
        await _storage.SetItemAsync(StorageKey, list);
    }

    public async Task UpdateAsync(JapaneseChar c)
    {
        var list = await GetCachedAsync();
        var idx = list.FindIndex(x => x.Id == c.Id);
        if (idx >= 0)
        {
            list[idx] = c;
            await _storage.SetItemAsync(StorageKey, list);
        }
    }

    public async Task DeleteAsync(int id)
    {
        var list = await GetCachedAsync();
        list.RemoveAll(x => x.Id == id);
        await _storage.SetItemAsync(StorageKey, list);
    }

    private static List<JapaneseChar> GetDefaultData()
    {
        var chars = new List<JapaneseChar>();
        int id = 1;

        void Add(string ch, string romaji, string type)
        {
            chars.Add(new JapaneseChar { Id = id++, Character = ch, Romaji = romaji, Type = type });
        }

        Add("あ", "a", "Hiragana"); Add("い", "i", "Hiragana"); Add("う", "u", "Hiragana");
        Add("え", "e", "Hiragana"); Add("お", "o", "Hiragana"); Add("か", "ka", "Hiragana");
        Add("き", "ki", "Hiragana"); Add("く", "ku", "Hiragana"); Add("け", "ke", "Hiragana");
        Add("こ", "ko", "Hiragana"); Add("さ", "sa", "Hiragana"); Add("し", "shi", "Hiragana");
        Add("す", "su", "Hiragana"); Add("せ", "se", "Hiragana"); Add("そ", "so", "Hiragana");
        Add("た", "ta", "Hiragana"); Add("ち", "chi", "Hiragana"); Add("つ", "tsu", "Hiragana");
        Add("て", "te", "Hiragana"); Add("と", "to", "Hiragana"); Add("な", "na", "Hiragana");
        Add("に", "ni", "Hiragana"); Add("ぬ", "nu", "Hiragana"); Add("ね", "ne", "Hiragana");
        Add("の", "no", "Hiragana"); Add("は", "ha", "Hiragana"); Add("ひ", "hi", "Hiragana");
        Add("ふ", "fu", "Hiragana"); Add("へ", "he", "Hiragana"); Add("ほ", "ho", "Hiragana");
        Add("ま", "ma", "Hiragana"); Add("み", "mi", "Hiragana"); Add("む", "mu", "Hiragana");
        Add("め", "me", "Hiragana"); Add("も", "mo", "Hiragana"); Add("や", "ya", "Hiragana");
        Add("ゆ", "yu", "Hiragana"); Add("よ", "yo", "Hiragana"); Add("ら", "ra", "Hiragana");
        Add("り", "ri", "Hiragana"); Add("る", "ru", "Hiragana"); Add("れ", "re", "Hiragana");
        Add("ろ", "ro", "Hiragana"); Add("わ", "wa", "Hiragana"); Add("を", "wo", "Hiragana");
        Add("ん", "n", "Hiragana");

        Add("ア", "a", "Katakana"); Add("イ", "i", "Katakana"); Add("ウ", "u", "Katakana");
        Add("エ", "e", "Katakana"); Add("オ", "o", "Katakana"); Add("カ", "ka", "Katakana");
        Add("キ", "ki", "Katakana"); Add("ク", "ku", "Katakana"); Add("ケ", "ke", "Katakana");
        Add("コ", "ko", "Katakana"); Add("サ", "sa", "Katakana"); Add("シ", "shi", "Katakana");
        Add("ス", "su", "Katakana"); Add("セ", "se", "Katakana"); Add("ソ", "so", "Katakana");
        Add("タ", "ta", "Katakana"); Add("チ", "chi", "Katakana"); Add("ツ", "tsu", "Katakana");
        Add("テ", "te", "Katakana"); Add("ト", "to", "Katakana"); Add("ナ", "na", "Katakana");
        Add("ニ", "ni", "Katakana"); Add("ヌ", "nu", "Katakana"); Add("ネ", "ne", "Katakana");
        Add("ノ", "no", "Katakana"); Add("ハ", "ha", "Katakana"); Add("ヒ", "hi", "Katakana");
        Add("フ", "fu", "Katakana"); Add("ヘ", "he", "Katakana"); Add("ホ", "ho", "Katakana");
        Add("マ", "ma", "Katakana"); Add("ミ", "mi", "Katakana"); Add("ム", "mu", "Katakana");
        Add("メ", "me", "Katakana"); Add("モ", "mo", "Katakana"); Add("ヤ", "ya", "Katakana");
        Add("ユ", "yu", "Katakana"); Add("ヨ", "yo", "Katakana"); Add("ラ", "ra", "Katakana");
        Add("リ", "ri", "Katakana"); Add("ル", "ru", "Katakana"); Add("レ", "re", "Katakana");
        Add("ロ", "ro", "Katakana"); Add("ワ", "wa", "Katakana"); Add("ヲ", "wo", "Katakana");
        Add("ン", "n", "Katakana");

        return chars;
    }
}

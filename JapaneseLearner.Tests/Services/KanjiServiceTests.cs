using JapaneseLearner.Models;
using JapaneseLearner.Services;
using JapaneseLearner.Tests.TestHelpers;

namespace JapaneseLearner.Tests;

public class KanjiServiceTests
{
    [Fact]
    public async Task GetAllAsync_ReturnsDefaultData_WhenStorageEmpty()
    {
        var storage = new MockStorageService();
        var service = new KanjiService(storage);

        var result = await service.GetAllAsync();

        Assert.NotEmpty(result);
        Assert.Contains(result, k => k.Kanji == "一");
    }

    [Fact]
    public async Task GetAllAsync_ReturnsStoredData_WhenExists()
    {
        var storage = new MockStorageService();
        var service = new KanjiService(storage);

        await service.AddAsync(new JapaneseKanji { Kanji = "試験", OnYomi = "シケン", KunYomi = "し.みる", Meaning = "thi", JLPTLevel = "N5" });

        var result = await service.GetAllAsync();
        Assert.Contains(result, k => k.Kanji == "試験");
    }

    [Fact]
    public async Task GetByLevelAsync_ReturnsAll_WhenLevelIsAll()
    {
        var storage = new MockStorageService();
        var service = new KanjiService(storage);

        var all = await service.GetByLevelAsync("All");

        Assert.NotEmpty(all);
    }

    [Fact]
    public async Task GetByLevelAsync_FiltersCorrectly()
    {
        var storage = new MockStorageService();
        var service = new KanjiService(storage);

        await service.AddAsync(new JapaneseKanji { Kanji = "仮", OnYomi = "カ・ケ", KunYomi = "かり", Meaning = "tạm thời", JLPTLevel = "N4" });

        var n5 = await service.GetByLevelAsync("N5");
        var n4 = await service.GetByLevelAsync("N4");

        Assert.All(n5, k => Assert.Equal("N5", k.JLPTLevel));
        Assert.All(n4, k => Assert.Equal("N4", k.JLPTLevel));
    }

    [Fact]
    public async Task GetByIdAsync_ReturnsCorrectKanji()
    {
        var storage = new MockStorageService();
        var service = new KanjiService(storage);

        var all = await service.GetAllAsync();
        var first = all.First();

        var result = await service.GetByIdAsync(first.Id);

        Assert.NotNull(result);
        Assert.Equal(first.Kanji, result.Kanji);
    }

    [Fact]
    public async Task GetByIdAsync_ReturnsNull_WhenNotFound()
    {
        var storage = new MockStorageService();
        var service = new KanjiService(storage);

        var result = await service.GetByIdAsync(99999);

        Assert.Null(result);
    }

    [Fact]
    public async Task AddAsync_AssignsIdAndPersists()
    {
        var storage = new MockStorageService();
        var service = new KanjiService(storage);

        await service.AddAsync(new JapaneseKanji { Kanji = "新", OnYomi = "シン", KunYomi = "あたら.しい", Meaning = "mới", StrokeCount = 13, JLPTLevel = "N5" });

        var all = await service.GetAllAsync();
        var added = all.FirstOrDefault(k => k.Kanji == "新");
        Assert.NotNull(added);
        Assert.True(added.Id > 0);
        Assert.Equal("シン", added.OnYomi);
    }

    [Fact]
    public async Task UpdateAsync_ModifiesExistingKanji()
    {
        var storage = new MockStorageService();
        var service = new KanjiService(storage);

        var all = await service.GetAllAsync();
        var first = all.First();
        first.Meaning = "một (đã sửa)";
        await service.UpdateAsync(first);

        var reloaded = await service.GetAllAsync();
        var updated = reloaded.First(k => k.Id == first.Id);
        Assert.Equal("một (đã sửa)", updated.Meaning);
    }

    [Fact]
    public async Task UpdateAsync_DoesNothing_WhenIdNotFound()
    {
        var storage = new MockStorageService();
        var service = new KanjiService(storage);

        var before = await service.GetAllAsync();
        await service.UpdateAsync(new JapaneseKanji { Id = 99999, Kanji = "無" });
        var after = await service.GetAllAsync();

        Assert.Equal(before.Count, after.Count);
    }

    [Fact]
    public async Task DeleteAsync_RemovesKanji()
    {
        var storage = new MockStorageService();
        var service = new KanjiService(storage);

        var before = await service.GetAllAsync();
        var toDelete = before.First();
        var beforeCount = before.Count;
        await service.DeleteAsync(toDelete.Id);

        var after = await service.GetAllAsync();
        Assert.DoesNotContain(after, k => k.Id == toDelete.Id);
        Assert.Equal(beforeCount - 1, after.Count);
    }

    [Fact]
    public async Task DeleteAsync_DoesNothing_WhenIdNotFound()
    {
        var storage = new MockStorageService();
        var service = new KanjiService(storage);

        var before = await service.GetAllAsync();
        await service.DeleteAsync(99999);
        var after = await service.GetAllAsync();

        Assert.Equal(before.Count, after.Count);
    }

    [Fact]
    public async Task GetAllAsync_HasN5Kanji()
    {
        var storage = new MockStorageService();
        var service = new KanjiService(storage);

        var all = await service.GetAllAsync();

        Assert.Contains(all, k => k.JLPTLevel == "N5");
        Assert.Contains(all, k => k.Kanji == "一");
        Assert.Contains(all, k => k.Kanji == "十");
        Assert.Contains(all, k => k.Kanji == "人");
        Assert.Contains(all, k => k.Kanji == "山");
        Assert.Contains(all, k => k.Kanji == "大");
    }
}

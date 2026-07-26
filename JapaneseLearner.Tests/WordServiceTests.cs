using JapaneseLearner.Models;
using JapaneseLearner.Services;
using JapaneseLearner.Tests.TestHelpers;

namespace JapaneseLearner.Tests;

public class WordServiceTests
{
    [Fact]
    public async Task GetAllAsync_ReturnsDefaultData_WhenStorageEmpty()
    {
        var storage = new MockStorageService();
        var service = new WordService(storage);

        var result = await service.GetAllAsync();

        Assert.NotEmpty(result);
        Assert.Contains(result, w => w.Characters == "あさ");
    }

    [Fact]
    public async Task GetAllAsync_ReturnsStoredData_WhenExists()
    {
        var storage = new MockStorageService();
        var service = new WordService(storage);

        await service.AddAsync(new JapaneseWord { Characters = "テスト", Romaji = "tesuto", Meaning = "test", Type = "Seion" });

        var result = await service.GetAllAsync();
        Assert.Contains(result, w => w.Characters == "テスト");
    }

    [Fact]
    public async Task GetByTypeAsync_ReturnsAll_WhenTypeIsAll()
    {
        var storage = new MockStorageService();
        var service = new WordService(storage);

        var all = await service.GetByTypeAsync("All");
        var totalByType = (await service.GetByTypeAsync("Seion")).Count
                        + (await service.GetByTypeAsync("Dakuon")).Count
                        + (await service.GetByTypeAsync("Handakuon")).Count
                        + (await service.GetByTypeAsync("Yoon")).Count
                        + (await service.GetByTypeAsync("Sokuon")).Count
                        + (await service.GetByTypeAsync("Choon")).Count
                        + (await service.GetByTypeAsync("N5")).Count;

        Assert.Equal(all.Count, totalByType);
    }

    [Fact]
    public async Task GetByTypeAsync_FiltersCorrectly()
    {
        var storage = new MockStorageService();
        var service = new WordService(storage);

        var seion = await service.GetByTypeAsync("Seion");
        Assert.All(seion, w => Assert.Equal("Seion", w.Type));

        var dakuon = await service.GetByTypeAsync("Dakuon");
        Assert.All(dakuon, w => Assert.Equal("Dakuon", w.Type));
    }

    [Fact]
    public async Task AddAsync_AssignsIdAndPersists()
    {
        var storage = new MockStorageService();
        var service = new WordService(storage);

        await service.AddAsync(new JapaneseWord { Characters = "新語", Romaji = "shingo", Meaning = "từ mới", Type = "Seion" });

        var all = await service.GetAllAsync();
        var added = all.FirstOrDefault(w => w.Romaji == "shingo");
        Assert.NotNull(added);
        Assert.True(added.Id > 0);
        Assert.Equal("新語", added.Characters);
    }

    [Fact]
    public async Task UpdateAsync_ModifiesExistingWord()
    {
        var storage = new MockStorageService();
        var service = new WordService(storage);

        var all = await service.GetAllAsync();
        var first = all.First();
        first.Meaning = "buổi sáng";
        await service.UpdateAsync(first);

        var reloaded = await service.GetAllAsync();
        var updated = reloaded.First(w => w.Id == first.Id);
        Assert.Equal("buổi sáng", updated.Meaning);
    }

    [Fact]
    public async Task UpdateAsync_DoesNothing_WhenIdNotFound()
    {
        var storage = new MockStorageService();
        var service = new WordService(storage);

        var before = await service.GetAllAsync();
        await service.UpdateAsync(new JapaneseWord { Id = 99999, Characters = "無" });
        var after = await service.GetAllAsync();

        Assert.Equal(before.Count, after.Count);
    }

    [Fact]
    public async Task DeleteAsync_RemovesWord()
    {
        var storage = new MockStorageService();
        var service = new WordService(storage);

        var before = await service.GetAllAsync();
        var toDelete = before.First();
        var beforeCount = before.Count;
        await service.DeleteAsync(toDelete.Id);

        var after = await service.GetAllAsync();
        Assert.DoesNotContain(after, w => w.Id == toDelete.Id);
        // Capture snapshot count before DeleteAsync mutates the shared list
        Assert.Equal(beforeCount - 1, after.Count);
    }

    [Fact]
    public async Task DeleteAsync_DoesNothing_WhenIdNotFound()
    {
        var storage = new MockStorageService();
        var service = new WordService(storage);

        var before = await service.GetAllAsync();
        await service.DeleteAsync(99999);
        var after = await service.GetAllAsync();

        Assert.Equal(before.Count, after.Count);
    }

    [Fact]
    public async Task GetAllAsync_HasAllWordTypes()
    {
        var storage = new MockStorageService();
        var service = new WordService(storage);

        var all = await service.GetAllAsync();

        Assert.Contains(all, w => w.Type == "Seion");
        Assert.Contains(all, w => w.Type == "Dakuon");
        Assert.Contains(all, w => w.Type == "Handakuon");
        Assert.Contains(all, w => w.Type == "Yoon");
        Assert.Contains(all, w => w.Type == "Sokuon");
        Assert.Contains(all, w => w.Type == "Choon");
    }
}

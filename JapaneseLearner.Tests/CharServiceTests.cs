using JapaneseLearner.Models;
using JapaneseLearner.Services;
using JapaneseLearner.Tests.TestHelpers;

namespace JapaneseLearner.Tests;

public class CharServiceTests
{
    [Fact]
    public async Task GetAllAsync_ReturnsDefaultData_WhenStorageEmpty()
    {
        var storage = new MockStorageService();
        var service = new CharService(storage);

        var result = await service.GetAllAsync();

        Assert.NotEmpty(result);
        Assert.Contains(result, c => c.Character == "あ");
        Assert.Contains(result, c => c.Character == "ア");
    }

    [Fact]
    public async Task GetAllAsync_ReturnsStoredData_WhenExists()
    {
        var storage = new MockStorageService();
        var service = new CharService(storage);

        await service.AddAsync(new JapaneseChar { Character = "試", Romaji = "shi", Type = "Hiragana" });

        var result = await service.GetAllAsync();
        Assert.Contains(result, c => c.Character == "試");
    }

    [Fact]
    public async Task GetByTypeAsync_ReturnsFilteredResults()
    {
        var storage = new MockStorageService();
        var service = new CharService(storage);

        var all = await service.GetByTypeAsync("All");
        var hiragana = await service.GetByTypeAsync("Hiragana");
        var katakana = await service.GetByTypeAsync("Katakana");

        Assert.Equal(all.Count, hiragana.Count + katakana.Count);
        Assert.All(hiragana, c => Assert.Equal("Hiragana", c.Type));
        Assert.All(katakana, c => Assert.Equal("Katakana", c.Type));
    }

    [Fact]
    public async Task AddAsync_AssignsIdAndPersists()
    {
        var storage = new MockStorageService();
        var service = new CharService(storage);

        await service.AddAsync(new JapaneseChar { Character = " test", Romaji = "test", Type = "Hiragana" });

        var all = await service.GetAllAsync();
        var added = all.FirstOrDefault(c => c.Romaji == "test");
        Assert.NotNull(added);
        Assert.True(added.Id > 0);
    }

    [Fact]
    public async Task UpdateAsync_ModifiesExistingChar()
    {
        var storage = new MockStorageService();
        var service = new CharService(storage);

        var all = await service.GetAllAsync();
        var first = all.First();
        first.Romaji = "updated";
        await service.UpdateAsync(first);

        var reloaded = await service.GetAllAsync();
        var updated = reloaded.First(c => c.Id == first.Id);
        Assert.Equal("updated", updated.Romaji);
    }

    [Fact]
    public async Task UpdateAsync_DoesNothing_WhenIdNotFound()
    {
        var storage = new MockStorageService();
        var service = new CharService(storage);

        var before = await service.GetAllAsync();
        await service.UpdateAsync(new JapaneseChar { Id = 99999, Character = "無", Romaji = "mu" });
        var after = await service.GetAllAsync();

        Assert.Equal(before.Count, after.Count);
        Assert.DoesNotContain(after, c => c.Character == "無");
    }

    [Fact]
    public async Task DeleteAsync_RemovesChar()
    {
        var storage = new MockStorageService();
        var service = new CharService(storage);

        var before = await service.GetAllAsync();
        var beforeCount = before.Count;
        var toDelete = before.First();
        await service.DeleteAsync(toDelete.Id);

        var after = await service.GetAllAsync();
        Assert.Equal(beforeCount - 1, after.Count);
        Assert.DoesNotContain(after, c => c.Id == toDelete.Id);
    }

    [Fact]
    public async Task DeleteAsync_DoesNothing_WhenIdNotFound()
    {
        var storage = new MockStorageService();
        var service = new CharService(storage);

        var before = await service.GetAllAsync();
        await service.DeleteAsync(99999);
        var after = await service.GetAllAsync();

        Assert.Equal(before.Count, after.Count);
    }

    [Fact]
    public async Task GetAllAsync_PersistsDefaultData_ToStorage()
    {
        var storage = new MockStorageService();
        var service = new CharService(storage);

        await service.GetAllAsync();

        var stored = await storage.GetItemAsync<List<JapaneseChar>>("japanese_chars");
        Assert.NotNull(stored);
        Assert.NotEmpty(stored);
    }

    [Fact]
    public async Task Cache_ReturnsSameInstance_OnMultipleCalls()
    {
        var storage = new MockStorageService();
        var service = new CharService(storage);

        var first = await service.GetAllAsync();
        var second = await service.GetAllAsync();

        Assert.Same(first, second);
    }
}

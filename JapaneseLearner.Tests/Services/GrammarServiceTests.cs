using JapaneseLearner.Models;
using JapaneseLearner.Services;
using JapaneseLearner.Tests.TestHelpers;

namespace JapaneseLearner.Tests;

public class GrammarServiceTests
{
    [Fact]
    public async Task GetAllAsync_ReturnsSeedData()
    {
        var storage = new MockStorageService();
        var service = new GrammarService(storage);

        var result = await service.GetAllAsync();

        Assert.Equal(38, result.Count);
    }

    [Fact]
    public async Task GetAllAsync_WithProgress_ReportsProgress()
    {
        var storage = new MockStorageService();
        var service = new GrammarService(storage);
        var reportedValues = new List<int>();
        IProgress<int> progress = new ProgressSpy(reportedValues);

        await service.GetAllAsync(progress);

        Assert.Contains(10, reportedValues);
        Assert.Contains(40, reportedValues);
        Assert.Contains(50, reportedValues);
        Assert.Contains(90, reportedValues);
        Assert.Contains(100, reportedValues);
    }

    private class ProgressSpy : IProgress<int>
    {
        private readonly List<int> _target;
        public ProgressSpy(List<int> target) => _target = target;
        public void Report(int value) => _target.Add(value);
    }

    [Fact]
    public async Task GetByIdAsync_ValidId_ReturnsItem()
    {
        var storage = new MockStorageService();
        var service = new GrammarService(storage);

        var all = await service.GetAllAsync();
        var first = all.First();

        var result = await service.GetByIdAsync(first.Id);

        Assert.NotNull(result);
        Assert.Equal(first.Pattern, result.Pattern);
    }

    [Fact]
    public async Task GetByIdAsync_InvalidId_ReturnsNull()
    {
        var storage = new MockStorageService();
        var service = new GrammarService(storage);

        var result = await service.GetByIdAsync(99999);

        Assert.Null(result);
    }

    [Fact]
    public async Task GetByLevelAsync_ReturnsFiltered()
    {
        var storage = new MockStorageService();
        var service = new GrammarService(storage);

        var n5 = await service.GetByLevelAsync("N5");

        Assert.NotEmpty(n5);
        Assert.All(n5, g => Assert.Equal("N5", g.JLPTLevel));
    }

    [Fact]
    public async Task GetByLevelAsync_All_ReturnsAll()
    {
        var storage = new MockStorageService();
        var service = new GrammarService(storage);

        var result = await service.GetByLevelAsync("All");
        var all = await service.GetAllAsync();

        Assert.Equal(all.Count, result.Count);
    }

    [Fact]
    public async Task AddAsync_PersistsItem()
    {
        var storage = new MockStorageService();
        var service = new GrammarService(storage);

        await service.AddAsync(new JapaneseGrammar
        {
            Pattern = "テスト",
            Meaning = "test",
            Explanation = "test pattern",
            JLPTLevel = "N5"
        });

        var all = await service.GetAllAsync();
        var added = all.FirstOrDefault(g => g.Pattern == "テスト");
        Assert.NotNull(added);
        Assert.True(added.Id > 0);
        Assert.Equal("test", added.Meaning);
    }

    [Fact]
    public async Task UpdateAsync_ModifiesItem()
    {
        var storage = new MockStorageService();
        var service = new GrammarService(storage);

        var all = await service.GetAllAsync();
        var first = all.First();
        first.Meaning = "nghĩa đã sửa";
        await service.UpdateAsync(first);

        var reloaded = await service.GetAllAsync();
        var updated = reloaded.First(g => g.Id == first.Id);
        Assert.Equal("nghĩa đã sửa", updated.Meaning);
    }

    [Fact]
    public async Task DeleteAsync_RemovesItem()
    {
        var storage = new MockStorageService();
        var service = new GrammarService(storage);

        var before = await service.GetAllAsync();
        var toDelete = before.First();
        var beforeCount = before.Count;
        await service.DeleteAsync(toDelete.Id);

        var after = await service.GetAllAsync();
        Assert.DoesNotContain(after, g => g.Id == toDelete.Id);
        Assert.Equal(beforeCount - 1, after.Count);
    }

    [Fact]
    public async Task SeedData_Count_38()
    {
        var storage = new MockStorageService();
        var service = new GrammarService(storage);

        var result = await service.GetAllAsync();

        Assert.Equal(38, result.Count);
    }

    [Fact]
    public async Task SeedData_AllN5()
    {
        var storage = new MockStorageService();
        var service = new GrammarService(storage);

        var result = await service.GetAllAsync();

        Assert.All(result, g => Assert.Equal("N5", g.JLPTLevel));
    }
}

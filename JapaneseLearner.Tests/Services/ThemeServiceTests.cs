using Blazored.LocalStorage;
using JapaneseLearner.Services;
using Moq;
using Xunit;

namespace JapaneseLearner.Tests.Services;

public class ThemeServiceTests
{
    private readonly Mock<ILocalStorageService> _mockStorage;
    private readonly ThemeService _service;

    public ThemeServiceTests()
    {
        _mockStorage = new Mock<ILocalStorageService>();
        _service = new ThemeService(_mockStorage.Object);
    }

    [Fact]
    public async Task GetCurrentModeAsync_Default_ReturnsLight()
    {
        _mockStorage.Setup(s => s.GetItemAsync<bool>("japanese-learner-dark-mode", default))
            .ReturnsAsync(false);
        var result = await _service.GetCurrentModeAsync();
        Assert.False(result);
    }

    [Fact]
    public async Task GetCurrentModeAsync_StoredDark_ReturnsDark()
    {
        _mockStorage.Setup(s => s.GetItemAsync<bool>("japanese-learner-dark-mode", default))
            .ReturnsAsync(true);
        var result = await _service.GetCurrentModeAsync();
        Assert.True(result);
    }

    [Fact]
    public async Task ToggleAsync_FromLight_SwitchesToDark()
    {
        _mockStorage.Setup(s => s.GetItemAsync<bool>("japanese-learner-dark-mode", default))
            .ReturnsAsync(false);
        await _service.GetCurrentModeAsync();
        Assert.False(_service.IsDarkMode);

        _mockStorage.Setup(s => s.SetItemAsync("japanese-learner-dark-mode", true, default))
            .Returns(ValueTask.CompletedTask);
        await _service.ToggleAsync();
        Assert.True(_service.IsDarkMode);
    }
}
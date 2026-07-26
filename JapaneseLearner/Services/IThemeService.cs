namespace JapaneseLearner.Services;

public interface IThemeService
{
    bool IsDarkMode { get; }
    Task<bool> GetCurrentModeAsync();
    Task ToggleAsync();
    event Action? OnThemeChanged;
}
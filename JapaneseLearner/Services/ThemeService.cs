using Blazored.LocalStorage;

namespace JapaneseLearner.Services;

public class ThemeService : IThemeService
{
    private readonly ILocalStorageService _storage;
    private bool _isDark;
    private const string StorageKey = "japanese-learner-dark-mode";

    public bool IsDarkMode => _isDark;
    public event Action? OnThemeChanged;

    public ThemeService(ILocalStorageService storage)
    {
        _storage = storage;
    }

    public async Task<bool> GetCurrentModeAsync()
    {
        _isDark = await _storage.GetItemAsync<bool>(StorageKey);
        return _isDark;
    }

    public async Task ToggleAsync()
    {
        _isDark = !_isDark;
        await _storage.SetItemAsync(StorageKey, _isDark);
        OnThemeChanged?.Invoke();
    }
}
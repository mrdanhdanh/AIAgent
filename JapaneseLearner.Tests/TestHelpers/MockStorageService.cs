using Blazored.LocalStorage;
using System.Text.Json;

namespace JapaneseLearner.Tests.TestHelpers;

public class MockStorageService : ILocalStorageService
{
    private readonly Dictionary<string, string> _store = new();

    public event EventHandler<ChangingEventArgs>? Changing;
    public event EventHandler<ChangedEventArgs>? Changed;

    public ValueTask<T?> GetItemAsync<T>(string key, CancellationToken cancellationToken = default)
    {
        if (_store.TryGetValue(key, out var json))
        {
            var result = JsonSerializer.Deserialize<T>(json, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
            return ValueTask.FromResult(result);
        }
        return ValueTask.FromResult(default(T));
    }

    public ValueTask SetItemAsync<T>(string key, T value, CancellationToken cancellationToken = default)
    {
        var json = JsonSerializer.Serialize(value);
        _store[key] = json;
        return ValueTask.CompletedTask;
    }

    public ValueTask RemoveItemAsync(string key, CancellationToken cancellationToken = default)
    {
        _store.Remove(key);
        return ValueTask.CompletedTask;
    }

    public ValueTask RemoveItemsAsync(IEnumerable<string> keys, CancellationToken cancellationToken = default)
    {
        foreach (var key in keys)
            _store.Remove(key);
        return ValueTask.CompletedTask;
    }

    public ValueTask ClearAsync(CancellationToken cancellationToken = default)
    {
        _store.Clear();
        return ValueTask.CompletedTask;
    }

    public ValueTask<bool> ContainKeyAsync(string key, CancellationToken cancellationToken = default)
    {
        return ValueTask.FromResult(_store.ContainsKey(key));
    }

    public ValueTask<string?> GetItemAsStringAsync(string key, CancellationToken cancellationToken = default)
    {
        _store.TryGetValue(key, out var val);
        return ValueTask.FromResult<string?>(val);
    }

    public ValueTask SetItemAsStringAsync(string key, string value, CancellationToken cancellationToken = default)
    {
        _store[key] = value;
        return ValueTask.CompletedTask;
    }

    public ValueTask<string?> KeyAsync(int index, CancellationToken cancellationToken = default)
    {
        if (index < _store.Count)
            return ValueTask.FromResult(_store.Keys.ElementAt(index));
        return ValueTask.FromResult<string?>(null);
    }

    public ValueTask<IEnumerable<string>> KeysAsync(CancellationToken cancellationToken = default)
    {
        return ValueTask.FromResult(_store.Keys.AsEnumerable());
    }

    public ValueTask<int> CountAsync(CancellationToken cancellationToken = default)
    {
        return ValueTask.FromResult(_store.Count);
    }

    public ValueTask<int> LengthAsync(CancellationToken cancellationToken = default)
    {
        return ValueTask.FromResult(_store.Count);
    }
}

using System.Diagnostics;

namespace JapaneseLearner.E2ETests;

public class AppFixture : IAsyncLifetime
{
    private Process _server = null!;
    private const string BaseUrl = "http://localhost:5173";

    public string ServerUrl => BaseUrl;

    public async Task InitializeAsync()
    {
        var projectDir = Path.GetFullPath(Path.Combine(Directory.GetCurrentDirectory(), "..", "..", "..", "..", "JapaneseLearner"));

        _server = new Process
        {
            StartInfo = new ProcessStartInfo
            {
                FileName = "dotnet",
                Arguments = $"run --project \"{projectDir}\" --urls \"{BaseUrl}\" --configuration Debug",
                UseShellExecute = false,
                RedirectStandardOutput = true,
                RedirectStandardError = true,
                CreateNoWindow = true,
            }
        };

        _server.Start();

        var cts = new CancellationTokenSource(TimeSpan.FromSeconds(90));
        var ready = false;

        while (!cts.Token.IsCancellationRequested)
        {
            try
            {
                using var client = new HttpClient { Timeout = TimeSpan.FromSeconds(2) };
                var response = await client.GetAsync(BaseUrl, cts.Token);
                if (response.IsSuccessStatusCode)
                {
                    ready = true;
                    break;
                }
            }
            catch
            {
                await Task.Delay(1000, cts.Token);
            }
        }

        if (!ready)
        {
            var error = _server.HasExited
                ? await _server.StandardError.ReadToEndAsync()
                : "Server did not start within 90 seconds (timeout)";
            throw new InvalidOperationException($"Server failed to start: {error}");
        }
    }

    public async Task DisposeAsync()
    {
        if (_server is { HasExited: false })
        {
            _server.Kill(entireProcessTree: true);
            await _server.WaitForExitAsync();
            _server.Dispose();
        }
    }
}

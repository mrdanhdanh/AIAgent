using Microsoft.AspNetCore.Components.Web;
using Microsoft.AspNetCore.Components.WebAssembly.Hosting;
using Microsoft.FluentUI.AspNetCore.Components;
using AIHub.Services;

var builder = WebAssemblyHostBuilder.CreateDefault(args);
builder.RootComponents.Add<AIHub.App>("#app");
builder.RootComponents.Add<HeadOutlet>("head::after");

builder.Services.AddScoped(sp => new HttpClient
{
    BaseAddress = new Uri(builder.HostEnvironment.BaseAddress),
    Timeout = TimeSpan.FromSeconds(20) // BUG-20260803-001: prevent indefinite "Fetching trending items..." spinner
});
builder.Services.AddFluentUIComponents();
builder.Services.AddScoped<ITrendingService, TrendingService>();

await builder.Build().RunAsync();
